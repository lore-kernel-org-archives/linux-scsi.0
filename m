From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/8] drbd: drop REQ_OP_WRITE_SAME support
Date: Wed, 12 Apr 2017 10:48:02 +0200
Message-ID: <20170412084809.8245-2-hch@lst.de>
References: <20170412084809.8245-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753494AbdDLIsR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2017 04:48:17 -0400
In-Reply-To: <20170412084809.8245-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, target-devel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com

Linux only used it for zeroing, for which we have better methods now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_main.c     | 28 ++----------------
 drivers/block/drbd/drbd_nl.c       | 60 --------------------------------------
 drivers/block/drbd/drbd_receiver.c | 38 +++---------------------
 drivers/block/drbd/drbd_req.c      |  1 -
 drivers/block/drbd/drbd_worker.c   |  4 ---
 5 files changed, 7 insertions(+), 124 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 84455c365f57..183468e0b959 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -931,7 +931,7 @@ void assign_p_sizes_qlim(struct drbd_device *device, struct p_sizes *p, struct r
 		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
 		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
 		p->qlim->discard_enabled = blk_queue_discard(q);
-		p->qlim->write_same_capable = !!q->limits.max_write_same_sectors;
+		p->qlim->write_same_capable = 0;
 	} else {
 		q = device->rq_queue;
 		p->qlim->physical_block_size = cpu_to_be32(queue_physical_block_size(q));
@@ -1610,9 +1610,6 @@ static int _drbd_send_bio(struct drbd_peer_device *peer_device, struct bio *bio)
 					 ? 0 : MSG_MORE);
 		if (err)
 			return err;
-		/* REQ_OP_WRITE_SAME has only one segment */
-		if (bio_op(bio) == REQ_OP_WRITE_SAME)
-			break;
 	}
 	return 0;
 }
@@ -1631,9 +1628,6 @@ static int _drbd_send_zc_bio(struct drbd_peer_device *peer_device, struct bio *b
 				      bio_iter_last(bvec, iter) ? 0 : MSG_MORE);
 		if (err)
 			return err;
-		/* REQ_OP_WRITE_SAME has only one segment */
-		if (bio_op(bio) == REQ_OP_WRITE_SAME)
-			break;
 	}
 	return 0;
 }
@@ -1665,7 +1659,6 @@ static u32 bio_flags_to_wire(struct drbd_connection *connection,
 		return  (bio->bi_opf & REQ_SYNC ? DP_RW_SYNC : 0) |
 			(bio->bi_opf & REQ_FUA ? DP_FUA : 0) |
 			(bio->bi_opf & REQ_PREFLUSH ? DP_FLUSH : 0) |
-			(bio_op(bio) == REQ_OP_WRITE_SAME ? DP_WSAME : 0) |
 			(bio_op(bio) == REQ_OP_DISCARD ? DP_DISCARD : 0) |
 			(bio_op(bio) == REQ_OP_WRITE_ZEROES ? DP_DISCARD : 0);
 	else
@@ -1680,7 +1673,6 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 	struct drbd_device *device = peer_device->device;
 	struct drbd_socket *sock;
 	struct p_data *p;
-	struct p_wsame *wsame = NULL;
 	void *digest_out;
 	unsigned int dp_flags = 0;
 	int digest_size;
@@ -1717,27 +1709,13 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 		err = __send_command(peer_device->connection, device->vnr, sock, P_TRIM, sizeof(*t), NULL, 0);
 		goto out;
 	}
-	if (dp_flags & DP_WSAME) {
-		/* this will only work if DRBD_FF_WSAME is set AND the
-		 * handshake agreed that all nodes and backend devices are
-		 * WRITE_SAME capable and agree on logical_block_size */
-		wsame = (struct p_wsame*)p;
-		digest_out = wsame + 1;
-		wsame->size = cpu_to_be32(req->i.size);
-	} else
-		digest_out = p + 1;
+	digest_out = p + 1;
 
 	/* our digest is still only over the payload.
 	 * TRIM does not carry any payload. */
 	if (digest_size)
 		drbd_csum_bio(peer_device->connection->integrity_tfm, req->master_bio, digest_out);
-	if (wsame) {
-		err =
-		    __send_command(peer_device->connection, device->vnr, sock, P_WSAME,
-				   sizeof(*wsame) + digest_size, NULL,
-				   bio_iovec(req->master_bio).bv_len);
-	} else
-		err =
+	err =
 		    __send_command(peer_device->connection, device->vnr, sock, P_DATA,
 				   sizeof(*p) + digest_size, NULL, req->i.size);
 	if (!err) {
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 02255a0d68b9..53aeed040eb4 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1234,65 +1234,6 @@ static void fixup_discard_if_not_supported(struct request_queue *q)
 	}
 }
 
-static void decide_on_write_same_support(struct drbd_device *device,
-			struct request_queue *q,
-			struct request_queue *b, struct o_qlim *o)
-{
-	struct drbd_peer_device *peer_device = first_peer_device(device);
-	struct drbd_connection *connection = peer_device->connection;
-	bool can_do = b ? b->limits.max_write_same_sectors : true;
-
-	if (can_do && connection->cstate >= C_CONNECTED && !(connection->agreed_features & DRBD_FF_WSAME)) {
-		can_do = false;
-		drbd_info(peer_device, "peer does not support WRITE_SAME\n");
-	}
-
-	if (o) {
-		/* logical block size; queue_logical_block_size(NULL) is 512 */
-		unsigned int peer_lbs = be32_to_cpu(o->logical_block_size);
-		unsigned int me_lbs_b = queue_logical_block_size(b);
-		unsigned int me_lbs = queue_logical_block_size(q);
-
-		if (me_lbs_b != me_lbs) {
-			drbd_warn(device,
-				"logical block size of local backend does not match (drbd:%u, backend:%u); was this a late attach?\n",
-				me_lbs, me_lbs_b);
-			/* rather disable write same than trigger some BUG_ON later in the scsi layer. */
-			can_do = false;
-		}
-		if (me_lbs_b != peer_lbs) {
-			drbd_warn(peer_device, "logical block sizes do not match (me:%u, peer:%u); this may cause problems.\n",
-				me_lbs, peer_lbs);
-			if (can_do) {
-				drbd_dbg(peer_device, "logical block size mismatch: WRITE_SAME disabled.\n");
-				can_do = false;
-			}
-			me_lbs = max(me_lbs, me_lbs_b);
-			/* We cannot change the logical block size of an in-use queue.
-			 * We can only hope that access happens to be properly aligned.
-			 * If not, the peer will likely produce an IO error, and detach. */
-			if (peer_lbs > me_lbs) {
-				if (device->state.role != R_PRIMARY) {
-					blk_queue_logical_block_size(q, peer_lbs);
-					drbd_warn(peer_device, "logical block size set to %u\n", peer_lbs);
-				} else {
-					drbd_warn(peer_device,
-						"current Primary must NOT adjust logical block size (%u -> %u); hope for the best.\n",
-						me_lbs, peer_lbs);
-				}
-			}
-		}
-		if (can_do && !o->write_same_capable) {
-			/* If we introduce an open-coded write-same loop on the receiving side,
-			 * the peer would present itself as "capable". */
-			drbd_dbg(peer_device, "WRITE_SAME disabled (peer device not capable)\n");
-			can_do = false;
-		}
-	}
-
-	blk_queue_max_write_same_sectors(q, can_do ? DRBD_MAX_BBIO_SECTORS : 0);
-}
-
 static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backing_dev *bdev,
 				   unsigned int max_bio_size, struct o_qlim *o)
 {
@@ -1321,7 +1262,6 @@ static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backi
 	blk_queue_max_segments(q, max_segments ? max_segments : BLK_MAX_SEGMENTS);
 	blk_queue_segment_boundary(q, PAGE_SIZE-1);
 	decide_on_discard_support(device, q, b, discard_zeroes_if_aligned);
-	decide_on_write_same_support(device, q, b, o);
 
 	if (b) {
 		blk_queue_stack_limits(q, b);
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 1b0a2be24f39..980d53793007 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1459,18 +1459,6 @@ static void drbd_issue_peer_discard(struct drbd_device *device, struct drbd_peer
 	drbd_endio_write_sec_final(peer_req);
 }
 
-static void drbd_issue_peer_wsame(struct drbd_device *device,
-				  struct drbd_peer_request *peer_req)
-{
-	struct block_device *bdev = device->ldev->backing_bdev;
-	sector_t s = peer_req->i.sector;
-	sector_t nr = peer_req->i.size >> 9;
-	if (blkdev_issue_write_same(bdev, s, nr, GFP_NOIO, peer_req->pages))
-		peer_req->flags |= EE_WAS_ERROR;
-	drbd_endio_write_sec_final(peer_req);
-}
-
-
 /**
  * drbd_submit_peer_request()
  * @device:	DRBD device.
@@ -1508,7 +1496,7 @@ int drbd_submit_peer_request(struct drbd_device *device,
 	 * Correctness first, performance later.  Next step is to code an
 	 * asynchronous variant of the same.
 	 */
-	if (peer_req->flags & (EE_IS_TRIM|EE_WRITE_SAME)) {
+	if (peer_req->flags & EE_IS_TRIM) {
 		/* wait for all pending IO completions, before we start
 		 * zeroing things out. */
 		conn_wait_active_ee_empty(peer_req->peer_device->connection);
@@ -1527,8 +1515,6 @@ int drbd_submit_peer_request(struct drbd_device *device,
 
 		if (peer_req->flags & EE_IS_TRIM)
 			drbd_issue_peer_discard(device, peer_req);
-		else /* EE_WRITE_SAME */
-			drbd_issue_peer_wsame(device, peer_req);
 		return 0;
 	}
 
@@ -1723,7 +1709,6 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 	void *dig_vv = peer_device->connection->int_dig_vv;
 	unsigned long *data;
 	struct p_trim *trim = (pi->cmd == P_TRIM) ? pi->data : NULL;
-	struct p_trim *wsame = (pi->cmd == P_WSAME) ? pi->data : NULL;
 
 	digest_size = 0;
 	if (!trim && peer_device->connection->peer_integrity_tfm) {
@@ -1738,29 +1723,17 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 		data_size -= digest_size;
 	}
 
-	/* assume request_size == data_size, but special case trim and wsame. */
+	/* assume request_size == data_size, but special case trim. */
 	ds = data_size;
 	if (trim) {
 		if (!expect(data_size == 0))
 			return NULL;
 		ds = be32_to_cpu(trim->size);
-	} else if (wsame) {
-		if (data_size != queue_logical_block_size(device->rq_queue)) {
-			drbd_err(peer_device, "data size (%u) != drbd logical block size (%u)\n",
-				data_size, queue_logical_block_size(device->rq_queue));
-			return NULL;
-		}
-		if (data_size != bdev_logical_block_size(device->ldev->backing_bdev)) {
-			drbd_err(peer_device, "data size (%u) != backend logical block size (%u)\n",
-				data_size, bdev_logical_block_size(device->ldev->backing_bdev));
-			return NULL;
-		}
-		ds = be32_to_cpu(wsame->size);
 	}
 
 	if (!expect(IS_ALIGNED(ds, 512)))
 		return NULL;
-	if (trim || wsame) {
+	if (trim) {
 		if (!expect(ds <= (DRBD_MAX_BBIO_SECTORS << 9)))
 			return NULL;
 	} else if (!expect(ds <= DRBD_MAX_BIO_SIZE))
@@ -1788,8 +1761,6 @@ read_in_block(struct drbd_peer_device *peer_device, u64 id, sector_t sector,
 		peer_req->flags |= EE_IS_TRIM;
 		return peer_req;
 	}
-	if (wsame)
-		peer_req->flags |= EE_WRITE_SAME;
 
 	/* receive payload size bytes into page chain */
 	ds = data_size;
@@ -2545,7 +2516,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	 * we wait for all pending requests, respectively wait for
 	 * active_ee to become empty in drbd_submit_peer_request();
 	 * better not add ourselves here. */
-	if ((peer_req->flags & (EE_IS_TRIM|EE_WRITE_SAME)) == 0)
+	if ((peer_req->flags & EE_IS_TRIM) == 0)
 		list_add_tail(&peer_req->w.list, &device->active_ee);
 	spin_unlock_irq(&device->resource->req_lock);
 
@@ -4869,7 +4840,6 @@ static struct data_cmd drbd_cmd_handler[] = {
 	[P_PROTOCOL_UPDATE] = { 1, sizeof(struct p_protocol), receive_protocol },
 	[P_TRIM]	    = { 0, sizeof(struct p_trim), receive_Data },
 	[P_RS_DEALLOCATED]  = { 0, sizeof(struct p_block_desc), receive_rs_deallocated },
-	[P_WSAME]	    = { 1, sizeof(struct p_wsame), receive_Data },
 };
 
 static void drbdd(struct drbd_connection *connection)
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index b5730e17b455..3d3fba937a92 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -58,7 +58,6 @@ static struct drbd_request *drbd_req_new(struct drbd_device *device, struct bio
 
 	drbd_req_make_private_bio(req, bio_src);
 	req->rq_state = (bio_data_dir(bio_src) == WRITE ? RQ_WRITE : 0)
-		      | (bio_op(bio_src) == REQ_OP_WRITE_SAME ? RQ_WSAME : 0)
 		      | (bio_op(bio_src) == REQ_OP_WRITE_ZEROES ? RQ_UNMAP : 0)
 		      | (bio_op(bio_src) == REQ_OP_DISCARD ? RQ_UNMAP : 0);
 	req->device = device;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 1afcb4e02d8d..9fad03491250 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -330,10 +330,6 @@ void drbd_csum_bio(struct crypto_ahash *tfm, struct bio *bio, void *digest)
 		sg_set_page(&sg, bvec.bv_page, bvec.bv_len, bvec.bv_offset);
 		ahash_request_set_crypt(req, &sg, NULL, sg.length);
 		crypto_ahash_update(req);
-		/* REQ_OP_WRITE_SAME has only one segment,
-		 * checksum the payload only once. */
-		if (bio_op(bio) == REQ_OP_WRITE_SAME)
-			break;
 	}
 	ahash_request_set_crypt(req, NULL, digest, 0);
 	crypto_ahash_final(req);
-- 
2.11.0
