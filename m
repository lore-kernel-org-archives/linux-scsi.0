From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 1/5] virtio: add functions for piecewise addition of buffers
Date: Tue, 18 Dec 2012 13:32:48 +0100
Message-ID: <1355833972-20319-2-git-send-email-pbonzini@redhat.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com, hutao@cn.fujitsu.com, virtualization@lists.linux-foundation.org, stefanha@redhat.com
List-Id: linux-scsi@vger.kernel.org

The virtqueue_add_buf function has two limitations:

1) it requires the caller to provide all the buffers in a single call;

2) it does not support chained scatterlists: the buffers must be
provided as an array of struct scatterlist;

Because of these limitations, virtio-scsi has to copy each request into
a scatterlist internal to the driver.  It cannot just use the one that
was prepared by the upper SCSI layers.

This patch adds a different set of APIs for adding a buffer to a virtqueue.
The new API lets you pass the buffers piecewise, wrapping multiple calls
to virtqueue_add_sg between virtqueue_start_buf and virtqueue_end_buf.
virtio-scsi can then call virtqueue_add_sg 3/4 times: for the request
header, for the write buffer (if present), for the response header, and
finally for the read buffer (again if present).  It saves the copying
and the related locking.

Note that this API is not needed in virtio-blk, because it does all the
work of the upper SCSI layers itself in the blk_map_rq_sg call.  Then
it simply hands the resulting scatterlist to virtqueue_add_buf.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v1->v2: new

 drivers/virtio/virtio_ring.c |  205 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio.h       |   21 ++++
 2 files changed, 226 insertions(+), 0 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index ffd7e7d..ccfa97c 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -394,6 +394,211 @@ static void detach_buf(struct vring_virtqueue *vq, unsigned int head)
 	vq->vq.num_free++;
 }
 
+/**
+ * virtqueue_start_buf - start building buffer for the other end
+ * @vq: the struct virtqueue we're talking about.
+ * @buf: a struct keeping the state of the buffer
+ * @data: the token identifying the buffer.
+ * @count: the number of buffers that will be added
+ * @count_sg: the number of sg lists that will be added
+ * @gfp: how to do memory allocations (if necessary).
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted), and that a successful call is
+ * followed by one or more calls to virtqueue_add_sg, and finally a call
+ * to virtqueue_end_buf.
+ *
+ * Returns zero or a negative error (ie. ENOSPC).
+ */
+int virtqueue_start_buf(struct virtqueue *_vq,
+			struct virtqueue_buf *buf,
+			void *data,
+			unsigned int count,
+			unsigned int count_sg,
+			gfp_t gfp)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+	struct vring_desc *desc = NULL;
+	int head;
+	int ret = -ENOMEM;
+
+	START_USE(vq);
+
+	BUG_ON(data == NULL);
+
+#ifdef DEBUG
+	{
+		ktime_t now = ktime_get();
+
+		/* No kick or get, with .1 second between?  Warn. */
+		if (vq->last_add_time_valid)
+			WARN_ON(ktime_to_ms(ktime_sub(now, vq->last_add_time))
+					    > 100);
+		vq->last_add_time = now;
+		vq->last_add_time_valid = true;
+	}
+#endif
+
+	BUG_ON(count < count_sg);
+	BUG_ON(count_sg == 0);
+
+	/* If the host supports indirect descriptor tables, and there is
+	 * no space for direct buffers or there are multi-item scatterlists,
+	 * go indirect.
+	 */
+	head = vq->free_head;
+	if (vq->indirect && (count > count_sg || vq->vq.num_free < count)) {
+		if (vq->vq.num_free == 0)
+			goto no_space;
+
+		desc = kmalloc(count * sizeof(struct vring_desc), gfp);
+		if (!desc)
+			goto error;
+
+		/* We're about to use a buffer */
+		vq->vq.num_free--;
+
+		/* Use a single buffer which doesn't continue */
+		vq->vring.desc[head].flags = VRING_DESC_F_INDIRECT;
+		vq->vring.desc[head].addr = virt_to_phys(desc);
+		vq->vring.desc[head].len = count * sizeof(struct vring_desc);
+
+		/* Update free pointer */
+		vq->free_head = vq->vring.desc[head].next;
+	}
+
+	/* Set token. */
+	vq->data[head] = data;
+
+	pr_debug("Started buffer head %i for %p\n", head, vq);
+
+	buf->vq = _vq;
+	buf->indirect = desc;
+	buf->tail = NULL;
+	buf->head = head;
+	return 0;
+
+no_space:
+	ret = -ENOSPC;
+error:
+	pr_debug("Can't add buf (%d) - count = %i, avail = %i\n",
+		 ret, count, vq->vq.num_free);
+	END_USE(vq);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(virtqueue_start_buf);
+
+/**
+ * virtqueue_add_sg - add sglist to buffer
+ * @buf: the struct that was passed to virtqueue_start_buf
+ * @sgl: the description of the buffer(s).
+ * @count: the number of items to process in sgl
+ * @dir: whether the sgl is read or written (DMA_TO_DEVICE/DMA_FROM_DEVICE only)
+ *
+ * Note that, unlike virtqueue_add_buf, this function follows chained
+ * scatterlists, and stops before the @count-th item if a scatterlist item
+ * has a marker.
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ */
+void virtqueue_add_sg(struct virtqueue_buf *buf,
+		      struct scatterlist sgl[],
+		      unsigned int count,
+		      enum dma_data_direction dir)
+{
+	struct vring_virtqueue *vq = to_vvq(buf->vq);
+	unsigned int i, uninitialized_var(prev), n;
+	struct scatterlist *sg;
+	struct vring_desc *tail;
+	u32 flags;
+
+#ifdef DEBUG
+	BUG_ON(!vq->in_use);
+#endif
+
+	BUG_ON(dir != DMA_FROM_DEVICE && dir != DMA_TO_DEVICE);
+	BUG_ON(count == 0);
+
+	flags = (dir == DMA_FROM_DEVICE ? VRING_DESC_F_WRITE : 0);
+	flags |= VRING_DESC_F_NEXT;
+
+	/* If using indirect descriptor tables, fill in the buffers
+	 * at buf->indirect.  */
+	if (buf->indirect != NULL) {
+		i = 0;
+		if (likely(buf->tail != NULL))
+			i = buf->tail - buf->indirect + 1;
+
+		for_each_sg(sgl, sg, count, n) {
+			tail = &buf->indirect[i];
+			tail->flags = flags;
+			tail->addr = sg_phys(sg);
+			tail->len = sg->length;
+			tail->next = ++i;
+		}
+	} else {
+		BUG_ON(vq->vq.num_free < count);
+
+		i = vq->free_head;
+		for_each_sg(sgl, sg, count, n) {
+			tail = &vq->vring.desc[i];
+			tail->flags = flags;
+			tail->addr = sg_phys(sg);
+			tail->len = sg->length;
+			i = vq->vring.desc[i].next;
+			vq->vq.num_free--;
+		}
+
+		vq->free_head = i;
+	}
+	buf->tail = tail;
+}
+EXPORT_SYMBOL_GPL(virtqueue_add_sg);
+
+/**
+ * virtqueue_end_buf - expose buffer to other end
+ * @buf: the struct that was passed to virtqueue_start_buf
+ *
+ * Caller must ensure we don't call this with other virtqueue operations
+ * at the same time (except where noted).
+ */
+void virtqueue_end_buf(struct virtqueue_buf *buf)
+{
+	struct vring_virtqueue *vq = to_vvq(buf->vq);
+	unsigned int avail;
+	int head = buf->head;
+	struct vring_desc *tail = buf->tail;
+
+#ifdef DEBUG
+	BUG_ON(!vq->in_use);
+#endif
+	BUG_ON(tail == NULL);
+
+	/* The last one does not have the next flag set.  */
+	tail->flags &= ~VRING_DESC_F_NEXT;
+
+	/* Put entry in available array (but don't update avail->idx until
+	 * virtqueue_end_buf). */
+	avail = (vq->vring.avail->idx & (vq->vring.num-1));
+	vq->vring.avail->ring[avail] = head;
+
+	/* Descriptors and available array need to be set before we expose the
+	 * new available array entries. */
+	virtio_wmb(vq);
+	vq->vring.avail->idx++;
+	vq->num_added++;
+
+	/* This is very unlikely, but theoretically possible.  Kick
+	 * just in case. */
+	if (unlikely(vq->num_added == (1 << 16) - 1))
+		virtqueue_kick(buf->vq);
+
+	pr_debug("Added buffer head %i to %p\n", head, vq);
+	END_USE(vq);
+}
+EXPORT_SYMBOL_GPL(virtqueue_end_buf);
+
 static inline bool more_used(const struct vring_virtqueue *vq)
 {
 	return vq->last_used_idx != vq->vring.used->idx;
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index cf8adb1..39d56c4 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -7,6 +7,7 @@
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
+#include <linux/dma-direction.h>
 #include <linux/gfp.h>
 
 /**
@@ -40,6 +41,26 @@ int virtqueue_add_buf(struct virtqueue *vq,
 		      void *data,
 		      gfp_t gfp);
 
+struct virtqueue_buf {
+	struct virtqueue *vq;
+	struct vring_desc *indirect, *tail;
+	int head;
+};
+
+int virtqueue_start_buf(struct virtqueue *_vq,
+			struct virtqueue_buf *buf,
+			void *data,
+			unsigned int count,
+			unsigned int count_sg,
+			gfp_t gfp);
+
+void virtqueue_add_sg(struct virtqueue_buf *buf,
+		      struct scatterlist sgl[],
+		      unsigned int count,
+		      enum dma_data_direction dir);
+
+void virtqueue_end_buf(struct virtqueue_buf *buf);
+
 void virtqueue_kick(struct virtqueue *vq);
 
 bool virtqueue_kick_prepare(struct virtqueue *vq);
-- 
1.7.1
