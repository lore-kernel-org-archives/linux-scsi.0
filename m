From: mchristi@redhat.com
Subject: [PATCH 30/32] drbd: don't use bi_rw for operations
Date: Wed,  4 Nov 2015 16:08:27 -0600
Message-ID: <1446674909-5371-31-git-send-email-mchristi@redhat.com>
References: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1446674909-5371-1-git-send-email-mchristi@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

This removes drbd's bi_rw use for operations read, write,
discard, write same, etc (REQ_OPs).

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/block/drbd/drbd_actlog.c   |  2 +-
 drivers/block/drbd/drbd_bitmap.c   |  1 -
 drivers/block/drbd/drbd_main.c     | 15 ++++++++-------
 drivers/block/drbd/drbd_receiver.c | 22 ++++++++--------------
 drivers/block/drbd/drbd_worker.c   |  4 ++--
 5 files changed, 19 insertions(+), 25 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index ed2eafe..fc96a3c 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -159,7 +159,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 		goto out;
 	bio->bi_private = device;
 	bio->bi_end_io = drbd_md_endio;
-	bio->bi_rw = op | op_flags;
+	bio->bi_rw = op_flags;
 	bio->bi_op = op;
 
 	if (op != REQ_OP_WRITE && device->state.disk == D_DISKLESS && device->ldev == NULL)
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 2ff407a..173a3d6 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1022,7 +1022,6 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 
 	if (drbd_insert_fault(device, (rw == REQ_OP_WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
 		bio->bi_op = rw;
-		bio->bi_rw |= rw;
 		bio_io_error(bio);
 	} else {
 		submit_bio(rw, 0, bio);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 9eb8039..d74178c 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1602,15 +1602,16 @@ static int _drbd_send_zc_ee(struct drbd_peer_device *peer_device,
 	return 0;
 }
 
-static u32 bio_flags_to_wire(struct drbd_connection *connection, unsigned long bi_rw)
+static u32 bio_flags_to_wire(struct drbd_connection *connection,
+			     struct bio *bio)
 {
 	if (connection->agreed_pro_version >= 95)
-		return  (bi_rw & REQ_SYNC ? DP_RW_SYNC : 0) |
-			(bi_rw & REQ_FUA ? DP_FUA : 0) |
-			(bi_rw & REQ_FLUSH ? DP_FLUSH : 0) |
-			(bi_rw & REQ_DISCARD ? DP_DISCARD : 0);
+		return  (bio->bi_rw & REQ_SYNC ? DP_RW_SYNC : 0) |
+			(bio->bi_rw & REQ_FUA ? DP_FUA : 0) |
+			(bio->bi_rw & REQ_FLUSH ? DP_FLUSH : 0) |
+			(bio->bi_op == REQ_OP_DISCARD ? DP_DISCARD : 0);
 	else
-		return bi_rw & REQ_SYNC ? DP_RW_SYNC : 0;
+		return bio->bi_rw & REQ_SYNC ? DP_RW_SYNC : 0;
 }
 
 /* Used to send write or TRIM aka REQ_DISCARD requests
@@ -1635,7 +1636,7 @@ int drbd_send_dblock(struct drbd_peer_device *peer_device, struct drbd_request *
 	p->sector = cpu_to_be64(req->i.sector);
 	p->block_id = (unsigned long)req;
 	p->seq_num = cpu_to_be32(atomic_inc_return(&device->packet_seq));
-	dp_flags = bio_flags_to_wire(peer_device->connection, req->master_bio->bi_rw);
+	dp_flags = bio_flags_to_wire(peer_device->connection, req->master_bio);
 	if (device->state.conn >= C_SYNC_SOURCE &&
 	    device->state.conn <= C_PAUSED_SYNC_T)
 		dp_flags |= DP_MAY_SET_IN_SYNC;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 4e458bd..44193da 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1418,7 +1418,7 @@ next_bio:
 	/* > peer_req->i.sector, unless this is the first bio */
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = device->ldev->backing_bdev;
-	bio->bi_rw = op | op_flags;
+	bio->bi_rw = op_flags;
 	bio->bi_op = op;
 	bio->bi_private = peer_req;
 	bio->bi_end_io = drbd_peer_request_endio;
@@ -1427,7 +1427,7 @@ next_bio:
 	bios = bio;
 	++n_bios;
 
-	if (op & REQ_OP_DISCARD) {
+	if (op == REQ_OP_DISCARD) {
 		bio->bi_iter.bi_size = data_size;
 		goto submit;
 	}
@@ -2132,8 +2132,7 @@ static unsigned long wire_flags_to_bio_flags(u32 dpf)
 {
 	return  (dpf & DP_RW_SYNC ? REQ_SYNC : 0) |
 		(dpf & DP_FUA ? REQ_FUA : 0) |
-		(dpf & DP_FLUSH ? REQ_FLUSH : 0) |
-		(dpf & DP_DISCARD ? REQ_DISCARD : 0);
+		(dpf & DP_FLUSH ? REQ_FLUSH : 0);
 }
 
 static unsigned long wire_flags_to_bio_op(u32 dpf)
@@ -2141,7 +2140,7 @@ static unsigned long wire_flags_to_bio_op(u32 dpf)
 	if (dpf & DP_DISCARD)
 		return REQ_OP_DISCARD;
 	else
-		return 0;
+		return REQ_OP_WRITE;;
 }
 
 static void fail_postponed_requests(struct drbd_device *device, sector_t sector,
@@ -2287,7 +2286,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	struct drbd_peer_request *peer_req;
 	struct p_data *p = pi->data;
 	u32 peer_seq = be32_to_cpu(p->seq_num);
-	int op = REQ_OP_WRITE, op_flags = 0;
+	int op, op_flags;
 	u32 dp_flags;
 	int err, tp;
 
@@ -2326,20 +2325,15 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	peer_req->flags |= EE_APPLICATION;
 
 	dp_flags = be32_to_cpu(p->dp_flags);
-	/*
-	 * Tmp compat. We OR it here because other code assumes both the
-	 * discard and write flags are set. In the next patches that
-	 * will be cleaned up.
-	 */
-	op |= wire_flags_to_bio_op(dp_flags);
-	op_flags |= wire_flags_to_bio_flags(dp_flags);
+	op = wire_flags_to_bio_op(dp_flags);
+	op_flags = wire_flags_to_bio_flags(dp_flags);
 	if (pi->cmd == P_TRIM) {
 		struct request_queue *q = bdev_get_queue(device->ldev->backing_bdev);
 		peer_req->flags |= EE_IS_TRIM;
 		if (!blk_queue_discard(q))
 			peer_req->flags |= EE_IS_TRIM_USE_ZEROOUT;
 		D_ASSERT(peer_device, peer_req->i.size > 0);
-		D_ASSERT(peer_device, op & REQ_OP_DISCARD);
+		D_ASSERT(peer_device, op == REQ_OP_DISCARD);
 		D_ASSERT(peer_device, peer_req->pages == NULL);
 	} else if (peer_req->pages == NULL) {
 		D_ASSERT(device, peer_req->i.size == 0);
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 23e5500..f1c63d2 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -175,7 +175,7 @@ void drbd_peer_request_endio(struct bio *bio)
 	struct drbd_peer_request *peer_req = bio->bi_private;
 	struct drbd_device *device = peer_req->peer_device->device;
 	int is_write = bio_data_dir(bio) == WRITE;
-	int is_discard = !!(bio->bi_rw & REQ_DISCARD);
+	int is_discard = (bio->bi_op == REQ_OP_DISCARD);
 
 	if (bio->bi_error && __ratelimit(&drbd_ratelimit_state))
 		drbd_warn(device, "%s: error=%d s=%llus\n",
@@ -243,7 +243,7 @@ void drbd_request_endio(struct bio *bio)
 
 	/* to avoid recursion in __req_mod */
 	if (unlikely(bio->bi_error)) {
-		if (bio->bi_rw & REQ_DISCARD)
+		if (bio->bi_op == REQ_OP_DISCARD)
 			what = (bio->bi_error == -EOPNOTSUPP)
 				? DISCARD_COMPLETED_NOTSUPP
 				: DISCARD_COMPLETED_WITH_ERROR;
-- 
1.8.3.1
