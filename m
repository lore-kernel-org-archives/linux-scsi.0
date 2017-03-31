From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 24/25] drbd: implement REQ_OP_WRITE_ZEROES
Date: Fri, 31 Mar 2017 18:33:12 +0200
Message-ID: <20170331163313.31821-25-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57474 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933498AbdCaQe0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2017 12:34:26 -0400
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

It seems like DRBD assumes its on the wire TRIM request always zeroes data.
Use that fact to implement REQ_OP_WRITE_ZEROES.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_main.c     | 3 ++-
 drivers/block/drbd/drbd_nl.c       | 2 ++
 drivers/block/drbd/drbd_receiver.c | 6 +++---
 drivers/block/drbd/drbd_req.c      | 7 +++++--
 drivers/block/drbd/drbd_worker.c   | 4 +++-
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 92c60cbd04ee..8e62d9f65510 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1668,7 +1668,8 @@ static u32 bio_flags_to_wire(struct drbd_connection *connection,
 			(bio->bi_opf & REQ_FUA ? DP_FUA : 0) |
 			(bio->bi_opf & REQ_PREFLUSH ? DP_FLUSH : 0) |
 			(bio_op(bio) == REQ_OP_WRITE_SAME ? DP_WSAME : 0) |
-			(bio_op(bio) == REQ_OP_DISCARD ? DP_DISCARD : 0);
+			(bio_op(bio) == REQ_OP_DISCARD ? DP_DISCARD : 0) |
+			(bio_op(bio) == REQ_OP_WRITE_ZEROES ? DP_DISCARD : 0);
 	else
 		return bio->bi_opf & REQ_SYNC ? DP_RW_SYNC : 0;
 }
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 908c704e20aa..e4516d3b971d 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1217,10 +1217,12 @@ static void decide_on_discard_support(struct drbd_device *device,
 		blk_queue_discard_granularity(q, 512);
 		q->limits.max_discard_sectors = drbd_max_discard_sectors(connection);
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
+		q->limits.max_write_zeroes_sectors = drbd_max_discard_sectors(connection);
 	} else {
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
 		blk_queue_discard_granularity(q, 0);
 		q->limits.max_discard_sectors = 0;
+		q->limits.max_write_zeroes_sectors = 0;
 	}
 }
 
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index bc1d296581f9..1b0a2be24f39 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2285,7 +2285,7 @@ static unsigned long wire_flags_to_bio_flags(u32 dpf)
 static unsigned long wire_flags_to_bio_op(u32 dpf)
 {
 	if (dpf & DP_DISCARD)
-		return REQ_OP_DISCARD;
+		return REQ_OP_WRITE_ZEROES;
 	else
 		return REQ_OP_WRITE;
 }
@@ -2476,7 +2476,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	op_flags = wire_flags_to_bio_flags(dp_flags);
 	if (pi->cmd == P_TRIM) {
 		D_ASSERT(peer_device, peer_req->i.size > 0);
-		D_ASSERT(peer_device, op == REQ_OP_DISCARD);
+		D_ASSERT(peer_device, op == REQ_OP_WRITE_ZEROES);
 		D_ASSERT(peer_device, peer_req->pages == NULL);
 	} else if (peer_req->pages == NULL) {
 		D_ASSERT(device, peer_req->i.size == 0);
@@ -4789,7 +4789,7 @@ static int receive_rs_deallocated(struct drbd_connection *connection, struct pac
 
 	if (get_ldev(device)) {
 		struct drbd_peer_request *peer_req;
-		const int op = REQ_OP_DISCARD;
+		const int op = REQ_OP_WRITE_ZEROES;
 
 		peer_req = drbd_alloc_peer_req(peer_device, ID_SYNCER, sector,
 					       size, 0, GFP_NOIO);
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 6da9ea8c48b6..b5730e17b455 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -59,6 +59,7 @@ static struct drbd_request *drbd_req_new(struct drbd_device *device, struct bio
 	drbd_req_make_private_bio(req, bio_src);
 	req->rq_state = (bio_data_dir(bio_src) == WRITE ? RQ_WRITE : 0)
 		      | (bio_op(bio_src) == REQ_OP_WRITE_SAME ? RQ_WSAME : 0)
+		      | (bio_op(bio_src) == REQ_OP_WRITE_ZEROES ? RQ_UNMAP : 0)
 		      | (bio_op(bio_src) == REQ_OP_DISCARD ? RQ_UNMAP : 0);
 	req->device = device;
 	req->master_bio = bio_src;
@@ -1180,7 +1181,8 @@ drbd_submit_req_private_bio(struct drbd_request *req)
 	if (get_ldev(device)) {
 		if (drbd_insert_fault(device, type))
 			bio_io_error(bio);
-		else if (bio_op(bio) == REQ_OP_DISCARD)
+		else if (bio_op(bio) == REQ_OP_WRITE_ZEROES ||
+			 bio_op(bio) == REQ_OP_DISCARD)
 			drbd_process_discard_req(req);
 		else
 			generic_make_request(bio);
@@ -1234,7 +1236,8 @@ drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long
 	_drbd_start_io_acct(device, req);
 
 	/* process discards always from our submitter thread */
-	if (bio_op(bio) & REQ_OP_DISCARD)
+	if ((bio_op(bio) & REQ_OP_WRITE_ZEROES) ||
+	    (bio_op(bio) & REQ_OP_DISCARD))
 		goto queue_for_submitter_thread;
 
 	if (rw == WRITE && req->private_bio && req->i.size
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 3bff33f21435..1afcb4e02d8d 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -174,7 +174,8 @@ void drbd_peer_request_endio(struct bio *bio)
 	struct drbd_peer_request *peer_req = bio->bi_private;
 	struct drbd_device *device = peer_req->peer_device->device;
 	bool is_write = bio_data_dir(bio) == WRITE;
-	bool is_discard = !!(bio_op(bio) == REQ_OP_DISCARD);
+	bool is_discard = bio_op(bio) == REQ_OP_WRITE_ZEROES ||
+			  bio_op(bio) == REQ_OP_DISCARD;
 
 	if (bio->bi_error && __ratelimit(&drbd_ratelimit_state))
 		drbd_warn(device, "%s: error=%d s=%llus\n",
@@ -249,6 +250,7 @@ void drbd_request_endio(struct bio *bio)
 	/* to avoid recursion in __req_mod */
 	if (unlikely(bio->bi_error)) {
 		switch (bio_op(bio)) {
+		case REQ_OP_WRITE_ZEROES:
 		case REQ_OP_DISCARD:
 			if (bio->bi_error == -EOPNOTSUPP)
 				what = DISCARD_COMPLETED_NOTSUPP;
-- 
2.11.0
