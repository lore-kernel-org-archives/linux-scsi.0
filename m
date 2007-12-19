From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2/7] sg_ring: use in virtio.
Date: Wed, 19 Dec 2007 18:31:06 +1100
Message-ID: <200712191831.07804.rusty@rustcorp.com.au>
References: <200712191731.26512.rusty@rustcorp.com.au> <200712191733.15409.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200712191733.15409.rusty@rustcorp.com.au>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Using sg_rings, we can join together scatterlists returned by other
subsystems, without needing to allocate an extra element for chaining.
This helps the virtio_blk device which wants to prepend and append
metadata to the request's scatterlist.

As an added bonus, the old virtio layer used to pass a scatterlist
array and two numbers indicating the number of readable and writable
elements respectively; now we can simply hand two sg_rings which is
much clearer (each sg_ring contains its own length).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/block/virtio_blk.c    |   33 ++++++++-------
 drivers/char/virtio_console.c |   13 +++---
 drivers/net/virtio_net.c      |   22 +++++-----
 drivers/virtio/virtio_ring.c  |   90 ++++++++++++++++++++++++++--------------
 include/linux/virtio.h        |   12 ++---
 5 files changed, 99 insertions(+), 71 deletions(-)

diff -r 6fe7cf582293 drivers/block/virtio_blk.c
--- a/drivers/block/virtio_blk.c	Wed Dec 19 16:06:43 2007 +1100
+++ b/drivers/block/virtio_blk.c	Wed Dec 19 18:29:58 2007 +1100
@@ -5,8 +5,6 @@
 #include <linux/virtio.h>
 #include <linux/virtio_blk.h>
 #include <linux/scatterlist.h>
-
-#define VIRTIO_MAX_SG	(3+MAX_PHYS_SEGMENTS)
 
 static unsigned char virtblk_index = 'a';
 struct virtio_blk
@@ -24,8 +22,10 @@ struct virtio_blk
 
 	mempool_t *pool;
 
-	/* Scatterlist: can be too big for stack. */
-	struct scatterlist sg[VIRTIO_MAX_SG];
+	/* Scatterlist ring: can be too big for stack. */
+	DECLARE_SG_RING(out, 1);
+	DECLARE_SG_RING(in, 1);
+	DECLARE_SG_RING(sg, MAX_PHYS_SEGMENTS);
 };
 
 struct virtblk_req
@@ -70,8 +70,8 @@ static bool do_req(struct request_queue 
 static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		   struct request *req)
 {
-	unsigned long num, out, in;
 	struct virtblk_req *vbr;
+	struct sg_ring *in;
 
 	vbr = mempool_alloc(vblk->pool, GFP_ATOMIC);
 	if (!vbr)
@@ -95,23 +95,24 @@ static bool do_req(struct request_queue 
 	if (blk_barrier_rq(vbr->req))
 		vbr->out_hdr.type |= VIRTIO_BLK_T_BARRIER;
 
-	/* This init could be done at vblk creation time */
-	sg_init_table(vblk->sg, VIRTIO_MAX_SG);
-	sg_set_buf(&vblk->sg[0], &vbr->out_hdr, sizeof(vbr->out_hdr));
-	num = blk_rq_map_sg(q, vbr->req, vblk->sg+1);
-	sg_set_buf(&vblk->sg[num+1], &vbr->in_hdr, sizeof(vbr->in_hdr));
+ 	sg_ring_single(&vblk->out.ring, &vbr->out_hdr, sizeof(vbr->out_hdr));
+ 	sg_ring_init(&vblk->sg.ring, ARRAY_SIZE(vblk->sg.sg));
+ 	vblk->sg.ring.num = blk_rq_map_sg(q, vbr->req, vblk->sg.sg);
+ 	sg_ring_single(&vblk->in.ring, &vbr->in_hdr, sizeof(vbr->in_hdr));
 
 	if (rq_data_dir(vbr->req) == WRITE) {
 		vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
-		out = 1 + num;
-		in = 1;
+		/* Chain write request onto output buffers. */
+		list_add_tail(&vblk->sg.ring.list, &vblk->out.ring.list);
+		in = &vblk->in.ring;
 	} else {
 		vbr->out_hdr.type |= VIRTIO_BLK_T_IN;
-		out = 1;
-		in = 1 + num;
+		/* Chain input (status) buffer at end of read buffers. */
+		list_add_tail(&vblk->in.ring.list, &vblk->sg.ring.list);
+		in = &vblk->sg.ring;
 	}
 
-	if (vblk->vq->vq_ops->add_buf(vblk->vq, vblk->sg, out, in, vbr)) {
+	if (vblk->vq->vq_ops->add_buf(vblk->vq, &vblk->out.ring, in, vbr)) {
 		mempool_free(vbr, vblk->pool);
 		return false;
 	}
@@ -128,7 +129,7 @@ static void do_virtblk_request(struct re
 
 	while ((req = elv_next_request(q)) != NULL) {
 		vblk = req->rq_disk->private_data;
-		BUG_ON(req->nr_phys_segments > ARRAY_SIZE(vblk->sg));
+		BUG_ON(req->nr_phys_segments > ARRAY_SIZE(vblk->sg.sg));
 
 		/* If this request fails, stop queue and wait for something to
 		   finish to restart it. */
diff -r 6fe7cf582293 drivers/char/virtio_console.c
--- a/drivers/char/virtio_console.c	Wed Dec 19 16:06:43 2007 +1100
+++ b/drivers/char/virtio_console.c	Wed Dec 19 18:29:58 2007 +1100
@@ -54,15 +54,15 @@ static struct hv_ops virtio_cons;
  * immediately (lguest's Launcher does). */
 static int put_chars(u32 vtermno, const char *buf, int count)
 {
-	struct scatterlist sg[1];
+	DECLARE_SG_RING(sg, 1);
 	unsigned int len;
 
 	/* This is a convenient routine to initialize a single-elem sg list */
-	sg_init_one(sg, buf, count);
+	sg_ring_single(&sg.ring, buf, count);
 
 	/* add_buf wants a token to identify this buffer: we hand it any
 	 * non-NULL pointer, since there's only ever one buffer. */
-	if (out_vq->vq_ops->add_buf(out_vq, sg, 1, 0, (void *)1) == 0) {
+	if (out_vq->vq_ops->add_buf(out_vq, &sg.ring, NULL, (void *)1) == 0) {
 		/* Tell Host to go! */
 		out_vq->vq_ops->kick(out_vq);
 		/* Chill out until it's done with the buffer. */
@@ -78,11 +78,12 @@ static int put_chars(u32 vtermno, const 
  * queue. */
 static void add_inbuf(void)
 {
-	struct scatterlist sg[1];
-	sg_init_one(sg, inbuf, PAGE_SIZE);
+	DECLARE_SG_RING(sg, 1);
+
+	sg_ring_single(&sg.ring, inbuf, PAGE_SIZE);
 
 	/* We should always be able to add one buffer to an empty queue. */
-	if (in_vq->vq_ops->add_buf(in_vq, sg, 0, 1, inbuf) != 0)
+	if (in_vq->vq_ops->add_buf(in_vq, NULL, &sg.ring, inbuf) != 0)
 		BUG();
 	in_vq->vq_ops->kick(in_vq);
 }
diff -r 6fe7cf582293 drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c	Wed Dec 19 16:06:43 2007 +1100
+++ b/drivers/net/virtio_net.c	Wed Dec 19 18:29:58 2007 +1100
@@ -211,21 +211,21 @@ static void try_fill_recv(struct virtnet
 static void try_fill_recv(struct virtnet_info *vi)
 {
 	struct sk_buff *skb;
-	struct scatterlist sg[1+MAX_SKB_FRAGS];
-	int num, err;
+	DECLARE_SG_RING(sg, 1+MAX_SKB_FRAGS);
+	int err;
 
-	sg_init_table(sg, 1+MAX_SKB_FRAGS);
+	sg_ring_init(&sg.ring, 1+MAX_SKB_FRAGS);
 	for (;;) {
 		skb = netdev_alloc_skb(vi->dev, MAX_PACKET_LEN);
 		if (unlikely(!skb))
 			break;
 
 		skb_put(skb, MAX_PACKET_LEN);
-		vnet_hdr_to_sg(sg, skb);
-		num = skb_to_sgvec(skb, sg+1, 0, skb->len) + 1;
+		vnet_hdr_to_sg(sg.sg, skb);
+		sg.ring.num = skb_to_sgvec(skb, sg.sg+1, 0, skb->len) + 1;
 		skb_queue_head(&vi->recv, skb);
 
-		err = vi->rvq->vq_ops->add_buf(vi->rvq, sg, 0, num, skb);
+		err = vi->rvq->vq_ops->add_buf(vi->rvq, NULL, &sg.ring, skb);
 		if (err) {
 			skb_unlink(skb, &vi->recv);
 			kfree_skb(skb);
@@ -304,13 +304,13 @@ static int start_xmit(struct sk_buff *sk
 static int start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
-	int num, err;
-	struct scatterlist sg[1+MAX_SKB_FRAGS];
+	int err;
+	DECLARE_SG_RING(sg, 1+MAX_SKB_FRAGS);
 	struct virtio_net_hdr *hdr;
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 	DECLARE_MAC_BUF(mac);
 
-	sg_init_table(sg, 1+MAX_SKB_FRAGS);
+	sg_ring_init(&sg.ring, 1+MAX_SKB_FRAGS);
 
 	pr_debug("%s: xmit %p %s\n", dev->name, skb, print_mac(mac, dest));
 
@@ -345,13 +345,13 @@ static int start_xmit(struct sk_buff *sk
 		hdr->gso_size = 0;
 	}
 
-	vnet_hdr_to_sg(sg, skb);
-	num = skb_to_sgvec(skb, sg+1, 0, skb->len) + 1;
+	vnet_hdr_to_sg(sg.sg, skb);
+	sg.ring.num = skb_to_sgvec(skb, sg.sg+1, 0, skb->len) + 1;
 	__skb_queue_head(&vi->send, skb);
-	vi->stats.sendq_sglen += num;
+	vi->stats.sendq_sglen += sg.ring.num;
 
 again:
-	err = vi->svq->vq_ops->add_buf(vi->svq, sg, num, 0, skb);
+	err = vi->svq->vq_ops->add_buf(vi->svq, &sg.ring, NULL, skb);
 	if (err) {
 		vi->stats.sendq_full++;
 
diff -r 6fe7cf582293 drivers/virtio/virtio_ring.c
--- a/drivers/virtio/virtio_ring.c	Wed Dec 19 16:06:43 2007 +1100
+++ b/drivers/virtio/virtio_ring.c	Wed Dec 19 18:29:58 2007 +1100
@@ -69,48 +69,62 @@ struct vring_virtqueue
 
 #define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
 
+static int add_desc(struct vring_virtqueue *vq, unsigned int i,
+		    struct scatterlist *sg, unsigned int flags)
+{
+	if (vq->num_free == 0)
+		return -ENOSPC;
+
+	vq->vring.desc[i].flags = VRING_DESC_F_NEXT | flags;
+	vq->vring.desc[i].addr = (page_to_pfn(sg_page(sg))<<PAGE_SHIFT)
+		+ sg->offset;
+	vq->vring.desc[i].len = sg->length;
+	vq->num_free--;
+	return vq->vring.desc[i].next;
+}
+
 static int vring_add_buf(struct virtqueue *_vq,
-			 struct scatterlist sg[],
-			 unsigned int out,
-			 unsigned int in,
+			 struct sg_ring *out,
+			 struct sg_ring *in,
 			 void *data)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
-	unsigned int i, avail, head, uninitialized_var(prev);
+	unsigned int j, avail, head, free, uninitialized_var(prev);
+	int i;
+	struct sg_ring empty_sg, *sg;
 
 	BUG_ON(data == NULL);
-	BUG_ON(out + in > vq->vring.num);
-	BUG_ON(out + in == 0);
+
+	sg_ring_init(&empty_sg, 0);
+	empty_sg.num = 0;
+	if (!out)
+		out = &empty_sg;
+	if (!in)
+		in = &empty_sg;
+
+	BUG_ON(in->num == 0 && out->num == 0);
 
 	START_USE(vq);
 
-	if (vq->num_free < out + in) {
-		pr_debug("Can't add buf len %i - avail = %i\n",
-			 out + in, vq->num_free);
-		END_USE(vq);
-		return -ENOSPC;
+	i = head = vq->free_head;
+	free = vq->num_free;
+
+	/* Lay out the output buffers first. */
+	sg_ring_for_each(out, sg, j) {
+		prev = i;
+		i = add_desc(vq, i, &sg->sg[j], 0);
+		if (unlikely(i < 0))
+			goto full;
 	}
 
-	/* We're about to use some buffers from the free list. */
-	vq->num_free -= out + in;
+	/* Lay out the input buffers next. */
+	sg_ring_for_each(in, sg, j) {
+		prev = i;
+		i = add_desc(vq, i, &sg->sg[j], VRING_DESC_F_WRITE);
+		if (unlikely(i < 0))
+			goto full;
+	}
 
-	head = vq->free_head;
-	for (i = vq->free_head; out; i = vq->vring.desc[i].next, out--) {
-		vq->vring.desc[i].flags = VRING_DESC_F_NEXT;
-		vq->vring.desc[i].addr = (page_to_pfn(sg_page(sg))<<PAGE_SHIFT)
-			+ sg->offset;
-		vq->vring.desc[i].len = sg->length;
-		prev = i;
-		sg++;
-	}
-	for (; in; i = vq->vring.desc[i].next, in--) {
-		vq->vring.desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
-		vq->vring.desc[i].addr = (page_to_pfn(sg_page(sg))<<PAGE_SHIFT)
-			+ sg->offset;
-		vq->vring.desc[i].len = sg->length;
-		prev = i;
-		sg++;
-	}
 	/* Last one doesn't continue. */
 	vq->vring.desc[prev].flags &= ~VRING_DESC_F_NEXT;
 
@@ -128,6 +142,12 @@ static int vring_add_buf(struct virtqueu
 	pr_debug("Added buffer head %i to %p\n", head, vq);
 	END_USE(vq);
 	return 0;
+
+full:
+	pr_debug("Buffer needed more than %u on %p\n", free, vq);
+	vq->num_free = free;
+	END_USE(vq);
+	return i;
 }
 
 static void vring_kick(struct virtqueue *_vq)
diff -r 6fe7cf582293 include/linux/virtio.h
--- a/include/linux/virtio.h	Wed Dec 19 16:06:43 2007 +1100
+++ b/include/linux/virtio.h	Wed Dec 19 18:29:58 2007 +1100
@@ -3,7 +3,7 @@
 /* Everything a virtio driver needs to work with any particular virtio
  * implementation. */
 #include <linux/types.h>
-#include <linux/scatterlist.h>
+#include <linux/sg_ring.h>
 #include <linux/spinlock.h>
 #include <linux/device.h>
 #include <linux/mod_devicetable.h>
@@ -27,9 +27,8 @@ struct virtqueue
  * virtqueue_ops - operations for virtqueue abstraction layer
  * @add_buf: expose buffer to other end
  *	vq: the struct virtqueue we're talking about.
- *	sg: the description of the buffer(s).
- *	out_num: the number of sg readable by other side
- *	in_num: the number of sg which are writable (after readable ones)
+ *	out: the scatter gather elements readable by other side (can be NULL)
+ *	in: the scatter gather elements which are writable (can be NULL)
  *	data: the token identifying the buffer.
  *      Returns 0 or an error.
  * @kick: update after add_buf
@@ -56,9 +55,8 @@ struct virtqueue
  */
 struct virtqueue_ops {
 	int (*add_buf)(struct virtqueue *vq,
-		       struct scatterlist sg[],
-		       unsigned int out_num,
-		       unsigned int in_num,
+		       struct sg_ring *out,
+		       struct sg_ring *in,
 		       void *data);
 
 	void (*kick)(struct virtqueue *vq);
diff -r 6fe7cf582293 net/9p/trans_virtio.c
--- a/net/9p/trans_virtio.c	Wed Dec 19 16:06:43 2007 +1100
+++ b/net/9p/trans_virtio.c	Wed Dec 19 18:29:59 2007 +1100
@@ -88,7 +88,7 @@ static int p9_virtio_write(struct p9_tra
 {
 	struct virtio_chan *chan = (struct virtio_chan *) trans->priv;
 	struct virtqueue *out_vq = chan->out_vq;
-	struct scatterlist sg[1];
+	DECLARE_SG_RING(sg, 1);
 	unsigned int len;
 
 	P9_DPRINTK(P9_DEBUG_TRANS, "9p debug: virtio write (%d)\n", count);
@@ -97,11 +97,11 @@ static int p9_virtio_write(struct p9_tra
 	if (rest_of_page(buf) < count)
 		count = rest_of_page(buf);
 
-	sg_init_one(sg, buf, count);
+	sg_ring_single(&sg.ring, buf, count);
 
 	/* add_buf wants a token to identify this buffer: we hand it any
 	 * non-NULL pointer, since there's only ever one buffer. */
-	if (out_vq->vq_ops->add_buf(out_vq, sg, 1, 0, (void *)1) == 0) {
+	if (out_vq->vq_ops->add_buf(out_vq, &sg.ring, NULL, (void *)1) == 0) {
 		/* Tell Host to go! */
 		out_vq->vq_ops->kick(out_vq);
 		/* Chill out until it's done with the buffer. */
@@ -119,12 +119,12 @@ static int p9_virtio_write(struct p9_tra
  * queue. */
 static void add_inbuf(struct virtio_chan *chan)
 {
-	struct scatterlist sg[1];
+	DECLARE_SG_RING(sg, 1);
 
-	sg_init_one(sg, chan->inbuf, PAGE_SIZE);
+	sg_ring_single(&sg.ring, chan->inbuf, PAGE_SIZE);
 
 	/* We should always be able to add one buffer to an empty queue. */
-	if (chan->in_vq->vq_ops->add_buf(chan->in_vq, sg, 0, 1, chan->inbuf))
+	if (chan->in_vq->vq_ops->add_buf(chan->in_vq,&sg.ring,NULL,chan->inbuf))
 		BUG();
 	chan->in_vq->vq_ops->kick(chan->in_vq);
 }
