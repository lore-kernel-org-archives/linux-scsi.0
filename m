From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH v2 1/5] virtio: add functions for piecewise addition of
	buffers
Date: Thu, 03 Jan 2013 16:58:06 +0800
Message-ID: <50E5481E.20801@cn.fujitsu.com>
References: <1355833972-20319-1-git-send-email-pbonzini@redhat.com>
	<1355833972-20319-2-git-send-email-pbonzini@redhat.com>
	<87r4m45g88.fsf@rustcorp.com.au>
Reply-To: gaowanlong@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <87r4m45g88.fsf@rustcorp.com.au>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: kvm@vger.kernel.org, linux-scsi@vger.kernel.org, mst@redhat.com, hutao@cn.fujitsu.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 01/02/2013 01:03 PM, Rusty Russell wrote:
> Paolo Bonzini <pbonzini@redhat.com> writes:
>> The virtqueue_add_buf function has two limitations:
>>
>> 1) it requires the caller to provide all the buffers in a single call;
>>
>> 2) it does not support chained scatterlists: the buffers must be
>> provided as an array of struct scatterlist;
> 
> Chained scatterlists are a horrible interface, but that doesn't mean we
> shouldn't support them if there's a need.
> 
> I think I once even had a patch which passed two chained sgs, rather
> than a combo sg and two length numbers.  It's very old, but I've pasted
> it below.
> 
> Duplicating the implementation by having another interface is pretty
> nasty; I think I'd prefer the chained scatterlists, if that's optimal
> for you.

I rebased against virtio-next and use it in virtio-scsi, and tested it with 4 targets
virtio-scsi devices and host cpu idle=poll. Saw a little performance regression here.

General:
Run status group 0 (all jobs):
   READ: io=34675MB, aggrb=248257KB/s, minb=248257KB/s, maxb=248257KB/s, mint=143025msec, maxt=143025msec
  WRITE: io=34625MB, aggrb=247902KB/s, minb=247902KB/s, maxb=247902KB/s, mint=143025msec, maxt=143025msec

Chained:
Run status group 0 (all jobs):
   READ: io=34863MB, aggrb=242320KB/s, minb=242320KB/s, maxb=242320KB/s, mint=147325msec, maxt=147325msec
  WRITE: io=34437MB, aggrb=239357KB/s, minb=239357KB/s, maxb=239357KB/s, mint=147325msec, maxt=147325msec

Thanks,
Wanlong Gao

>From d3181b3f9bbdebbd3f2928b64821b406774757f8 Mon Sep 17 00:00:00 2001
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 2 Jan 2013 16:43:49 +0800
Subject: [PATCH] virtio: use chained scatterlists

Rather than handing a scatterlist[] and out and in numbers to
virtqueue_add_buf(), hand two separate ones which can be chained.

I shall refrain from ranting about what a disgusting hack chained
scatterlists are.  I'll just note that this doesn't make things
simpler (see diff).

The scatterlists we use can be too large for the stack, so we put them
in our device struct and reuse them.  But in many cases we don't want
to pay the cost of sg_init_table() as we don't know how many elements
we'll have and we'd have to initialize the entire table.

This means we have two choices: carefully reset the end markers after
we call virtqueue_add_buf(), which we do in virtio_net for the xmit
path where it's easy and we want to be optimal.  Elsewhere we
implement a helper to unset the end markers after we've filled the
array.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/block/virtio_blk.c          | 57 ++++++++++++++++++-----------
 drivers/char/hw_random/virtio-rng.c |  2 +-
 drivers/char/virtio_console.c       |  6 ++--
 drivers/net/virtio_net.c            | 68 ++++++++++++++++++-----------------
 drivers/scsi/virtio_scsi.c          | 18 ++++++----
 drivers/virtio/virtio_balloon.c     |  6 ++--
 drivers/virtio/virtio_ring.c        | 71 +++++++++++++++++++++++--------------
 include/linux/virtio.h              | 14 ++++++--
 net/9p/trans_virtio.c               | 31 +++++++++++++---
 9 files changed, 172 insertions(+), 101 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 0bdde8f..17cf0b7 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -102,8 +102,8 @@ static inline struct virtblk_req *virtblk_alloc_req(struct virtio_blk *vblk,
 
 static void virtblk_add_buf_wait(struct virtio_blk *vblk,
 				 struct virtblk_req *vbr,
-				 unsigned long out,
-				 unsigned long in)
+				 struct scatterlist *out,
+				 struct scatterlist *in)
 {
 	DEFINE_WAIT(wait);
 
@@ -112,7 +112,7 @@ static void virtblk_add_buf_wait(struct virtio_blk *vblk,
 					  TASK_UNINTERRUPTIBLE);
 
 		spin_lock_irq(vblk->disk->queue->queue_lock);
-		if (virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
+		if (virtqueue_add_buf(vblk->vq, out, in, vbr,
 				      GFP_ATOMIC) < 0) {
 			spin_unlock_irq(vblk->disk->queue->queue_lock);
 			io_schedule();
@@ -128,12 +128,13 @@ static void virtblk_add_buf_wait(struct virtio_blk *vblk,
 }
 
 static inline void virtblk_add_req(struct virtblk_req *vbr,
-				   unsigned int out, unsigned int in)
+				   struct scatterlist *out,
+				   struct scatterlist *in)
 {
 	struct virtio_blk *vblk = vbr->vblk;
 
 	spin_lock_irq(vblk->disk->queue->queue_lock);
-	if (unlikely(virtqueue_add_buf(vblk->vq, vbr->sg, out, in, vbr,
+	if (unlikely(virtqueue_add_buf(vblk->vq, out, in, vbr,
 					GFP_ATOMIC) < 0)) {
 		spin_unlock_irq(vblk->disk->queue->queue_lock);
 		virtblk_add_buf_wait(vblk, vbr, out, in);
@@ -154,7 +155,11 @@ static int virtblk_bio_send_flush(struct virtblk_req *vbr)
 	sg_set_buf(&vbr->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
 	sg_set_buf(&vbr->sg[out + in++], &vbr->status, sizeof(vbr->status));
 
-	virtblk_add_req(vbr, out, in);
+	sg_unset_end_markers(vbr->sg, out + in);
+	sg_mark_end(&vbr->sg[out - 1]);
+	sg_mark_end(&vbr->sg[out + in - 1]);
+
+	virtblk_add_req(vbr, vbr->sg, vbr->sg + out);
 
 	return 0;
 }
@@ -174,9 +179,6 @@ static int virtblk_bio_send_data(struct virtblk_req *vbr)
 
 	num = blk_bio_map_sg(vblk->disk->queue, bio, vbr->sg + out);
 
-	sg_set_buf(&vbr->sg[num + out + in++], &vbr->status,
-		   sizeof(vbr->status));
-
 	if (num) {
 		if (bio->bi_rw & REQ_WRITE) {
 			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
@@ -187,7 +189,13 @@ static int virtblk_bio_send_data(struct virtblk_req *vbr)
 		}
 	}
 
-	virtblk_add_req(vbr, out, in);
+	sg_set_buf(&vbr->sg[out + in++], &vbr->status, sizeof(vbr->status));
+
+	sg_unset_end_markers(vbr->sg, out + in);
+	sg_mark_end(&vbr->sg[out - 1]);
+	sg_mark_end(&vbr->sg[out + in - 1]);
+
+	virtblk_add_req(vbr, vbr->sg, vbr->sg + out);
 
 	return 0;
 }
@@ -335,6 +343,7 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		}
 	}
 
+	/* We layout out scatterlist in a single array, out then in. */
 	sg_set_buf(&vblk->sg[out++], &vbr->out_hdr, sizeof(vbr->out_hdr));
 
 	/*
@@ -346,17 +355,9 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC)
 		sg_set_buf(&vblk->sg[out++], vbr->req->cmd, vbr->req->cmd_len);
 
+	/* This marks the end of the sg list at vblk->sg[out]. */
 	num = blk_rq_map_sg(q, vbr->req, vblk->sg + out);
 
-	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC) {
-		sg_set_buf(&vblk->sg[num + out + in++], vbr->req->sense, SCSI_SENSE_BUFFERSIZE);
-		sg_set_buf(&vblk->sg[num + out + in++], &vbr->in_hdr,
-			   sizeof(vbr->in_hdr));
-	}
-
-	sg_set_buf(&vblk->sg[num + out + in++], &vbr->status,
-		   sizeof(vbr->status));
-
 	if (num) {
 		if (rq_data_dir(vbr->req) == WRITE) {
 			vbr->out_hdr.type |= VIRTIO_BLK_T_OUT;
@@ -367,8 +368,22 @@ static bool do_req(struct request_queue *q, struct virtio_blk *vblk,
 		}
 	}
 
-	if (virtqueue_add_buf(vblk->vq, vblk->sg, out, in, vbr,
-			      GFP_ATOMIC) < 0) {
+	if (vbr->req->cmd_type == REQ_TYPE_BLOCK_PC) {
+		sg_set_buf(&vblk->sg[out + in++], vbr->req->sense,
+			   SCSI_SENSE_BUFFERSIZE);
+		sg_set_buf(&vblk->sg[out + in++], &vbr->in_hdr,
+			   sizeof(vbr->in_hdr));
+	}
+
+	sg_set_buf(&vblk->sg[out + in++], &vbr->status,
+		   sizeof(vbr->status));
+
+	sg_unset_end_markers(vblk->sg, out + in);
+	sg_mark_end(&vblk->sg[out - 1]);
+	sg_mark_end(&vblk->sg[out + in - 1]);
+
+	if (virtqueue_add_buf(vblk->vq, vblk->sg, vblk->sg + out, vbr, GFP_ATOMIC)
+	    < 0) {
 		mempool_free(vbr, vblk->pool);
 		return false;
 	}
diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index 621f595..4dec874 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -47,7 +47,7 @@ static void register_buffer(u8 *buf, size_t size)
 	sg_init_one(&sg, buf, size);
 
 	/* There should always be room for one buffer. */
-	if (virtqueue_add_buf(vq, &sg, 0, 1, buf, GFP_KERNEL) < 0)
+	if (virtqueue_add_buf(vq, NULL, &sg, buf, GFP_KERNEL) < 0)
 		BUG();
 
 	virtqueue_kick(vq);
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index c594cb1..bc56ff5 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -508,7 +508,7 @@ static int add_inbuf(struct virtqueue *vq, struct port_buffer *buf)
 
 	sg_init_one(sg, buf->buf, buf->size);
 
-	ret = virtqueue_add_buf(vq, sg, 0, 1, buf, GFP_ATOMIC);
+	ret = virtqueue_add_buf(vq, NULL, sg, buf, GFP_ATOMIC);
 	virtqueue_kick(vq);
 	if (!ret)
 		ret = vq->num_free;
@@ -575,7 +575,7 @@ static ssize_t __send_control_msg(struct ports_device *portdev, u32 port_id,
 	vq = portdev->c_ovq;
 
 	sg_init_one(sg, &cpkt, sizeof(cpkt));
-	if (virtqueue_add_buf(vq, sg, 1, 0, &cpkt, GFP_ATOMIC) == 0) {
+	if (virtqueue_add_buf(vq, sg, NULL, &cpkt, GFP_ATOMIC) == 0) {
 		virtqueue_kick(vq);
 		while (!virtqueue_get_buf(vq, &len))
 			cpu_relax();
@@ -624,7 +624,7 @@ static ssize_t __send_to_port(struct port *port, struct scatterlist *sg,
 
 	reclaim_consumed_buffers(port);
 
-	err = virtqueue_add_buf(out_vq, sg, nents, 0, data, GFP_ATOMIC);
+	err = virtqueue_add_buf(out_vq, sg, NULL, data, GFP_ATOMIC);
 
 	/* Tell Host to go! */
 	virtqueue_kick(out_vq);
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index a6fcf15..32f6e13 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -432,11 +432,12 @@ static int add_recvbuf_small(struct receive_queue *rq, gfp_t gfp)
 	skb_put(skb, MAX_PACKET_LEN);
 
 	hdr = skb_vnet_hdr(skb);
+	sg_init_table(rq->sg, 2);
 	sg_set_buf(rq->sg, &hdr->hdr, sizeof hdr->hdr);
 
 	skb_to_sgvec(skb, rq->sg + 1, 0, skb->len);
 
-	err = virtqueue_add_buf(rq->vq, rq->sg, 0, 2, skb, gfp);
+	err = virtqueue_add_buf(rq->vq, NULL, rq->sg, skb, gfp);
 	if (err < 0)
 		dev_kfree_skb(skb);
 
@@ -449,6 +450,8 @@ static int add_recvbuf_big(struct receive_queue *rq, gfp_t gfp)
 	char *p;
 	int i, err, offset;
 
+	sg_init_table(rq->sg, MAX_SKB_FRAGS + 1);
+
 	/* page in rq->sg[MAX_SKB_FRAGS + 1] is list tail */
 	for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
 		first = get_a_page(rq, gfp);
@@ -481,8 +484,7 @@ static int add_recvbuf_big(struct receive_queue *rq, gfp_t gfp)
 
 	/* chain first in list head */
 	first->private = (unsigned long)list;
-	err = virtqueue_add_buf(rq->vq, rq->sg, 0, MAX_SKB_FRAGS + 2,
-				first, gfp);
+	err = virtqueue_add_buf(rq->vq, NULL, rq->sg, first, gfp);
 	if (err < 0)
 		give_pages(rq, first);
 
@@ -500,7 +502,7 @@ static int add_recvbuf_mergeable(struct receive_queue *rq, gfp_t gfp)
 
 	sg_init_one(rq->sg, page_address(page), PAGE_SIZE);
 
-	err = virtqueue_add_buf(rq->vq, rq->sg, 0, 1, page, gfp);
+	err = virtqueue_add_buf(rq->vq, NULL, rq->sg, page, gfp);
 	if (err < 0)
 		give_pages(rq, page);
 
@@ -664,6 +666,7 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 	struct virtnet_info *vi = sq->vq->vdev->priv;
 	unsigned num_sg;
+	int ret;
 
 	pr_debug("%s: xmit %p %pM\n", vi->dev->name, skb, dest);
 
@@ -703,8 +706,15 @@ static int xmit_skb(struct send_queue *sq, struct sk_buff *skb)
 		sg_set_buf(sq->sg, &hdr->hdr, sizeof hdr->hdr);
 
 	num_sg = skb_to_sgvec(skb, sq->sg + 1, 0, skb->len) + 1;
-	return virtqueue_add_buf(sq->vq, sq->sg, num_sg,
-				 0, skb, GFP_ATOMIC);
+	ret = virtqueue_add_buf(sq->vq, sq->sg, NULL, skb, GFP_ATOMIC);
+
+	/*
+	 * An optimization: clear the end bit set by skb_to_sgvec, so
+	 * we can simply re-use sq->sg[] next time.
+	 */
+	sq->sg[num_sg-1].page_link &= ~0x02;
+
+	return ret;
 }
 
 static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -825,32 +835,30 @@ static void virtnet_netpoll(struct net_device *dev)
  * never fail unless improperly formated.
  */
 static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
-				 struct scatterlist *data, int out, int in)
+				 struct scatterlist *cmdsg)
 {
-	struct scatterlist *s, sg[VIRTNET_SEND_COMMAND_SG_MAX + 2];
+	struct scatterlist in[1], out[2];
 	struct virtio_net_ctrl_hdr ctrl;
 	virtio_net_ctrl_ack status = ~0;
 	unsigned int tmp;
-	int i;
 
 	/* Caller should know better */
-	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ) ||
-		(out + in > VIRTNET_SEND_COMMAND_SG_MAX));
-
-	out++; /* Add header */
-	in++; /* Add return status */
+	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ));
 
+	/* Prepend header to output */
+	sg_init_table(out, 2);
 	ctrl.class = class;
 	ctrl.cmd = cmd;
+	sg_set_buf(&out[0], &ctrl, sizeof(ctrl));
+	if (cmdsg)
+		sg_chain(out, 2, cmdsg);
+	else
+		sg_mark_end(&out[0]);
 
-	sg_init_table(sg, out + in);
-
-	sg_set_buf(&sg[0], &ctrl, sizeof(ctrl));
-	for_each_sg(data, s, out + in - 2, i)
-		sg_set_buf(&sg[i + 1], sg_virt(s), s->length);
-	sg_set_buf(&sg[out + in - 1], &status, sizeof(status));
+	/* Status response */
+	sg_init_one(in, &status, sizeof(status));
 
-	BUG_ON(virtqueue_add_buf(vi->cvq, sg, out, in, vi, GFP_ATOMIC) < 0);
+	BUG_ON(virtqueue_add_buf(vi->cvq, out, in, vi, GFP_ATOMIC) < 0);
 
 	virtqueue_kick(vi->cvq);
 
@@ -868,8 +876,7 @@ static void virtnet_ack_link_announce(struct virtnet_info *vi)
 {
 	rtnl_lock();
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_ANNOUNCE,
-				  VIRTIO_NET_CTRL_ANNOUNCE_ACK, NULL,
-				  0, 0))
+				  VIRTIO_NET_CTRL_ANNOUNCE_ACK, NULL))
 		dev_warn(&vi->dev->dev, "Failed to ack link announce.\n");
 	rtnl_unlock();
 }
@@ -887,7 +894,7 @@ static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
 	sg_init_one(&sg, &s, sizeof(s));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MQ,
-				  VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET, &sg, 1, 0)){
+				  VIRTIO_NET_CTRL_MQ_VQ_PAIRS_SET, &sg)){
 		dev_warn(&dev->dev, "Fail to set num of queue pairs to %d\n",
 			 queue_pairs);
 		return -EINVAL;
@@ -933,16 +940,14 @@ static void virtnet_set_rx_mode(struct net_device *dev)
 	sg_init_one(sg, &promisc, sizeof(promisc));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_RX,
-				  VIRTIO_NET_CTRL_RX_PROMISC,
-				  sg, 1, 0))
+				  VIRTIO_NET_CTRL_RX_PROMISC, sg))
 		dev_warn(&dev->dev, "Failed to %sable promisc mode.\n",
 			 promisc ? "en" : "dis");
 
 	sg_init_one(sg, &allmulti, sizeof(allmulti));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_RX,
-				  VIRTIO_NET_CTRL_RX_ALLMULTI,
-				  sg, 1, 0))
+				  VIRTIO_NET_CTRL_RX_ALLMULTI, sg))
 		dev_warn(&dev->dev, "Failed to %sable allmulti mode.\n",
 			 allmulti ? "en" : "dis");
 
@@ -980,8 +985,7 @@ static void virtnet_set_rx_mode(struct net_device *dev)
 		   sizeof(mac_data->entries) + (mc_count * ETH_ALEN));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
-				  VIRTIO_NET_CTRL_MAC_TABLE_SET,
-				  sg, 2, 0))
+				  VIRTIO_NET_CTRL_MAC_TABLE_SET, sg))
 		dev_warn(&dev->dev, "Failed to set MAC fitler table.\n");
 
 	kfree(buf);
@@ -995,7 +999,7 @@ static int virtnet_vlan_rx_add_vid(struct net_device *dev, u16 vid)
 	sg_init_one(&sg, &vid, sizeof(vid));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_VLAN,
-				  VIRTIO_NET_CTRL_VLAN_ADD, &sg, 1, 0))
+				  VIRTIO_NET_CTRL_VLAN_ADD, &sg))
 		dev_warn(&dev->dev, "Failed to add VLAN ID %d.\n", vid);
 	return 0;
 }
@@ -1008,7 +1012,7 @@ static int virtnet_vlan_rx_kill_vid(struct net_device *dev, u16 vid)
 	sg_init_one(&sg, &vid, sizeof(vid));
 
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_VLAN,
-				  VIRTIO_NET_CTRL_VLAN_DEL, &sg, 1, 0))
+				  VIRTIO_NET_CTRL_VLAN_DEL, &sg))
 		dev_warn(&dev->dev, "Failed to kill VLAN ID %d.\n", vid);
 	return 0;
 }
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 74ab67a..5021c64 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -223,7 +223,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
 
 	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
 
-	err = virtqueue_add_buf(vscsi->event_vq.vq, &sg, 0, 1, event_node,
+	err = virtqueue_add_buf(vscsi->event_vq.vq, NULL, &sg, event_node,
 				GFP_ATOMIC);
 	if (!err)
 		virtqueue_kick(vscsi->event_vq.vq);
@@ -378,7 +378,7 @@ static void virtscsi_map_sgl(struct scatterlist *sg, unsigned int *p_idx,
  */
 static void virtscsi_map_cmd(struct virtio_scsi_target_state *tgt,
 			     struct virtio_scsi_cmd *cmd,
-			     unsigned *out_num, unsigned *in_num,
+			     unsigned *out, unsigned *in,
 			     size_t req_size, size_t resp_size)
 {
 	struct scsi_cmnd *sc = cmd->sc;
@@ -392,7 +392,7 @@ static void virtscsi_map_cmd(struct virtio_scsi_target_state *tgt,
 	if (sc && sc->sc_data_direction != DMA_FROM_DEVICE)
 		virtscsi_map_sgl(sg, &idx, scsi_out(sc));
 
-	*out_num = idx;
+	*out = idx;
 
 	/* Response header.  */
 	sg_set_buf(&sg[idx++], &cmd->resp, resp_size);
@@ -401,7 +401,11 @@ static void virtscsi_map_cmd(struct virtio_scsi_target_state *tgt,
 	if (sc && sc->sc_data_direction != DMA_TO_DEVICE)
 		virtscsi_map_sgl(sg, &idx, scsi_in(sc));
 
-	*in_num = idx - *out_num;
+	*in = idx - *out;
+
+	sg_unset_end_markers(sg, *out + *in);
+	sg_mark_end(&sg[*out - 1]);
+	sg_mark_end(&sg[*out + *in - 1]);
 }
 
 static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
@@ -409,16 +413,16 @@ static int virtscsi_kick_cmd(struct virtio_scsi_target_state *tgt,
 			     struct virtio_scsi_cmd *cmd,
 			     size_t req_size, size_t resp_size, gfp_t gfp)
 {
-	unsigned int out_num, in_num;
+	unsigned int out, in;
 	unsigned long flags;
 	int err;
 	bool needs_kick = false;
 
 	spin_lock_irqsave(&tgt->tgt_lock, flags);
-	virtscsi_map_cmd(tgt, cmd, &out_num, &in_num, req_size, resp_size);
+	virtscsi_map_cmd(tgt, cmd, &out, &in, req_size, resp_size);
 
 	spin_lock(&vq->vq_lock);
-	err = virtqueue_add_buf(vq->vq, tgt->sg, out_num, in_num, cmd, gfp);
+	err = virtqueue_add_buf(vq->vq, tgt->sg, tgt->sg + out, cmd, gfp);
 	spin_unlock(&tgt->tgt_lock);
 	if (!err)
 		needs_kick = virtqueue_kick_prepare(vq->vq);
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index d19fe3e..181cef1 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -108,7 +108,7 @@ static void tell_host(struct virtio_balloon *vb, struct virtqueue *vq)
 	sg_init_one(&sg, vb->pfns, sizeof(vb->pfns[0]) * vb->num_pfns);
 
 	/* We should always be able to add one buffer to an empty queue. */
-	if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
+	if (virtqueue_add_buf(vq, &sg, NULL, vb, GFP_KERNEL) < 0)
 		BUG();
 	virtqueue_kick(vq);
 
@@ -256,7 +256,7 @@ static void stats_handle_request(struct virtio_balloon *vb)
 	if (!virtqueue_get_buf(vq, &len))
 		return;
 	sg_init_one(&sg, vb->stats, sizeof(vb->stats));
-	if (virtqueue_add_buf(vq, &sg, 1, 0, vb, GFP_KERNEL) < 0)
+	if (virtqueue_add_buf(vq, &sg, NULL, vb, GFP_KERNEL) < 0)
 		BUG();
 	virtqueue_kick(vq);
 }
@@ -341,7 +341,7 @@ static int init_vqs(struct virtio_balloon *vb)
 		 * use it to signal us later.
 		 */
 		sg_init_one(&sg, vb->stats, sizeof vb->stats);
-		if (virtqueue_add_buf(vb->stats_vq, &sg, 1, 0, vb, GFP_KERNEL)
+		if (virtqueue_add_buf(vb->stats_vq, &sg, NULL, vb, GFP_KERNEL)
 		    < 0)
 			BUG();
 		virtqueue_kick(vb->stats_vq);
diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index ffd7e7d..277021b 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -119,13 +119,18 @@ struct vring_virtqueue
 
 #define to_vvq(_vq) container_of(_vq, struct vring_virtqueue, vq)
 
+/* This doesn't have the counter that for_each_sg() has */
+#define foreach_sg(sglist, i)			\
+	for (i = (sglist); i; i = sg_next(i))
+
 /* Set up an indirect table of descriptors and add it to the queue. */
 static int vring_add_indirect(struct vring_virtqueue *vq,
-			      struct scatterlist sg[],
-			      unsigned int out,
-			      unsigned int in,
+			      unsigned int num,
+			      struct scatterlist *out,
+			      struct scatterlist *in,
 			      gfp_t gfp)
 {
+	struct scatterlist *sg;
 	struct vring_desc *desc;
 	unsigned head;
 	int i;
@@ -137,24 +142,25 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
 	 */
 	gfp &= ~(__GFP_HIGHMEM | __GFP_HIGH);
 
-	desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
+	desc = kmalloc(num * sizeof(struct vring_desc), gfp);
 	if (!desc)
 		return -ENOMEM;
 
 	/* Transfer entries from the sg list into the indirect page */
-	for (i = 0; i < out; i++) {
+	i = 0;
+	foreach_sg(out, sg) {
 		desc[i].flags = VRING_DESC_F_NEXT;
 		desc[i].addr = sg_phys(sg);
 		desc[i].len = sg->length;
 		desc[i].next = i+1;
-		sg++;
+		i++;
 	}
-	for (; i < (out + in); i++) {
+	foreach_sg(in, sg) {
 		desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
 		desc[i].addr = sg_phys(sg);
 		desc[i].len = sg->length;
 		desc[i].next = i+1;
-		sg++;
+		i++;
 	}
 
 	/* Last one doesn't continue. */
@@ -176,12 +182,21 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
 	return head;
 }
 
+static unsigned int count_sg(struct scatterlist *sg)
+{
+	unsigned int count = 0;
+	struct scatterlist *i;
+
+	foreach_sg(sg, i)
+		count++;
+	return count;
+}
+
 /**
  * virtqueue_add_buf - expose buffer to other end
  * @vq: the struct virtqueue we're talking about.
- * @sg: the description of the buffer(s).
- * @out_num: the number of sg readable by other side
- * @in_num: the number of sg which are writable (after readable ones)
+ * @out: the description of the output buffer(s).
+ * @in: the description of the input buffer(s).
  * @data: the token identifying the buffer.
  * @gfp: how to do memory allocations (if necessary).
  *
@@ -191,20 +206,23 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
  * Returns zero or a negative error (ie. ENOSPC, ENOMEM).
  */
 int virtqueue_add_buf(struct virtqueue *_vq,
-		      struct scatterlist sg[],
-		      unsigned int out,
-		      unsigned int in,
+		      struct scatterlist *out,
+		      struct scatterlist *in,
 		      void *data,
 		      gfp_t gfp)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
-	unsigned int i, avail, uninitialized_var(prev);
+	unsigned int i, avail, uninitialized_var(prev), num;
+	struct scatterlist *sg;
 	int head;
 
 	START_USE(vq);
 
 	BUG_ON(data == NULL);
 
+	num = count_sg(out) + count_sg(in);
+	BUG_ON(num == 0);
+
 #ifdef DEBUG
 	{
 		ktime_t now = ktime_get();
@@ -220,18 +238,17 @@ int virtqueue_add_buf(struct virtqueue *_vq,
 
 	/* If the host supports indirect descriptor tables, and we have multiple
 	 * buffers, then go indirect. FIXME: tune this threshold */
-	if (vq->indirect && (out + in) > 1 && vq->vq.num_free) {
-		head = vring_add_indirect(vq, sg, out, in, gfp);
+	if (vq->indirect && num > 1 && vq->vq.num_free) {
+		head = vring_add_indirect(vq, num, out, in, gfp);
 		if (likely(head >= 0))
 			goto add_head;
 	}
 
-	BUG_ON(out + in > vq->vring.num);
-	BUG_ON(out + in == 0);
+	BUG_ON(num > vq->vring.num);
 
-	if (vq->vq.num_free < out + in) {
+	if (vq->vq.num_free < num) {
 		pr_debug("Can't add buf len %i - avail = %i\n",
-			 out + in, vq->vq.num_free);
+			 num, vq->vq.num_free);
 		/* FIXME: for historical reasons, we force a notify here if
 		 * there are outgoing parts to the buffer.  Presumably the
 		 * host should service the ring ASAP. */
@@ -242,22 +259,22 @@ int virtqueue_add_buf(struct virtqueue *_vq,
 	}
 
 	/* We're about to use some buffers from the free list. */
-	vq->vq.num_free -= out + in;
+	vq->vq.num_free -= num;
 
-	head = vq->free_head;
-	for (i = vq->free_head; out; i = vq->vring.desc[i].next, out--) {
+	i = head = vq->free_head;
+	foreach_sg(out, sg) {
 		vq->vring.desc[i].flags = VRING_DESC_F_NEXT;
 		vq->vring.desc[i].addr = sg_phys(sg);
 		vq->vring.desc[i].len = sg->length;
 		prev = i;
-		sg++;
+		i = vq->vring.desc[i].next;
 	}
-	for (; in; i = vq->vring.desc[i].next, in--) {
+	foreach_sg(in, sg) {
 		vq->vring.desc[i].flags = VRING_DESC_F_NEXT|VRING_DESC_F_WRITE;
 		vq->vring.desc[i].addr = sg_phys(sg);
 		vq->vring.desc[i].len = sg->length;
 		prev = i;
-		sg++;
+		i = vq->vring.desc[i].next;
 	}
 	/* Last one doesn't continue. */
 	vq->vring.desc[prev].flags &= ~VRING_DESC_F_NEXT;
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index cf8adb1..69509a8 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -33,10 +33,18 @@ struct virtqueue {
 	void *priv;
 };
 
+static inline void sg_unset_end_markers(struct scatterlist *sg,
+					unsigned int num)
+{
+	unsigned int i;
+
+	for (i = 0; i < num; i++)
+		sg[i].page_link &= ~0x02;
+}
+
 int virtqueue_add_buf(struct virtqueue *vq,
-		      struct scatterlist sg[],
-		      unsigned int out_num,
-		      unsigned int in_num,
+		      struct scatterlist *out,
+		      struct scatterlist *in,
 		      void *data,
 		      gfp_t gfp);
 
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index fd05c81..7c5ac34 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -259,6 +259,7 @@ p9_virtio_request(struct p9_client *client, struct p9_req_t *req)
 	int in, out;
 	unsigned long flags;
 	struct virtio_chan *chan = client->trans;
+	struct scatterlist *outsg = NULL, *insg = NULL;
 
 	p9_debug(P9_DEBUG_TRANS, "9p debug: virtio request\n");
 
@@ -269,12 +270,21 @@ req_retry:
 	/* Handle out VirtIO ring buffers */
 	out = pack_sg_list(chan->sg, 0,
 			   VIRTQUEUE_NUM, req->tc->sdata, req->tc->size);
+	if (out) {
+		sg_unset_end_markers(chan->sg, out - 1);
+		sg_mark_end(&chan->sg[out - 1]);
+		outsg = chan->sg;
+	}
 
 	in = pack_sg_list(chan->sg, out,
 			  VIRTQUEUE_NUM, req->rc->sdata, req->rc->capacity);
+	if (in) {
+		sg_unset_end_markers(chan->sg + out, in - 1);
+		sg_mark_end(&chan->sg[out + in - 1]);
+		insg = chan->sg + out;
+	}
 
-	err = virtqueue_add_buf(chan->vq, chan->sg, out, in, req->tc,
-				GFP_ATOMIC);
+	err = virtqueue_add_buf(chan->vq, outsg, insg, req->tc, GFP_ATOMIC);
 	if (err < 0) {
 		if (err == -ENOSPC) {
 			chan->ring_bufs_avail = 0;
@@ -356,6 +366,7 @@ p9_virtio_zc_request(struct p9_client *client, struct p9_req_t *req,
 	int in_nr_pages = 0, out_nr_pages = 0;
 	struct page **in_pages = NULL, **out_pages = NULL;
 	struct virtio_chan *chan = client->trans;
+	struct scatterlist *insg = NULL, *outsg = NULL;
 
 	p9_debug(P9_DEBUG_TRANS, "virtio request\n");
 
@@ -403,6 +414,13 @@ req_retry_pinned:
 	if (out_pages)
 		out += pack_sg_list_p(chan->sg, out, VIRTQUEUE_NUM,
 				      out_pages, out_nr_pages, uodata, outlen);
+
+	if (out) {
+		sg_unset_end_markers(chan->sg, out - 1);
+		sg_mark_end(&chan->sg[out - 1]);
+		outsg = chan->sg;
+	}
+
 	/*
 	 * Take care of in data
 	 * For example TREAD have 11.
@@ -416,8 +434,13 @@ req_retry_pinned:
 		in += pack_sg_list_p(chan->sg, out + in, VIRTQUEUE_NUM,
 				     in_pages, in_nr_pages, uidata, inlen);
 
-	err = virtqueue_add_buf(chan->vq, chan->sg, out, in, req->tc,
-				GFP_ATOMIC);
+	if (in) {
+		sg_unset_end_markers(chan->sg + out, in - 1);
+		sg_mark_end(&chan->sg[out + in - 1]);
+		insg = chan->sg + out;
+	}
+
+	err = virtqueue_add_buf(chan->vq, outsg, insg, req->tc, GFP_ATOMIC);
 	if (err < 0) {
 		if (err == -ENOSPC) {
 			chan->ring_bufs_avail = 0;
-- 
1.8.1



> 
> Cheers,
> Rusty.
