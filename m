From: mchristi@redhat.com
Subject: [PATCH 18/32] drbd: set bio bi_op to REQ_OP
Date: Wed,  4 Nov 2015 16:08:15 -0600
Message-ID: <1446674909-5371-19-git-send-email-mchristi@redhat.com>
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

This patch has drbd set the bi_op.

For compat reasons, we are still ORing the op into bi_rw. This
will be dropped in later patches in this series when everyone
is updated.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/block/drbd/drbd_actlog.c   |  1 +
 drivers/block/drbd/drbd_bitmap.c   |  1 +
 drivers/block/drbd/drbd_int.h      |  2 +-
 drivers/block/drbd/drbd_receiver.c | 39 ++++++++++++++++++++++++++++----------
 drivers/block/drbd/drbd_worker.c   |  3 ++-
 5 files changed, 34 insertions(+), 12 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 5ad6b09..ed2eafe 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -160,6 +160,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	bio->bi_private = device;
 	bio->bi_end_io = drbd_md_endio;
 	bio->bi_rw = op | op_flags;
+	bio->bi_op = op;
 
 	if (op != REQ_OP_WRITE && device->state.disk == D_DISKLESS && device->ldev == NULL)
 		/* special case, drbd_md_read() during drbd_adm_attach(): no get_ldev */
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index e8c65a4..2ff407a 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1021,6 +1021,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	bio->bi_end_io = drbd_bm_endio;
 
 	if (drbd_insert_fault(device, (rw == REQ_OP_WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
+		bio->bi_op = rw;
 		bio->bi_rw |= rw;
 		bio_io_error(bio);
 	} else {
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 2934481..05eaba8 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1542,7 +1542,7 @@ extern bool drbd_rs_should_slow_down(struct drbd_device *device, sector_t sector
 		bool throttle_if_app_is_waiting);
 extern int drbd_submit_peer_request(struct drbd_device *,
 				    struct drbd_peer_request *, const unsigned,
-				    const int);
+				    const unsigned, const int);
 extern int drbd_free_peer_reqs(struct drbd_device *, struct list_head *);
 extern struct drbd_peer_request *drbd_alloc_peer_req(struct drbd_peer_device *, u64,
 						     sector_t, unsigned int,
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index c097909..4e458bd 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1365,7 +1365,8 @@ void drbd_bump_write_ordering(struct drbd_resource *resource, struct drbd_backin
 /* TODO allocate from our own bio_set. */
 int drbd_submit_peer_request(struct drbd_device *device,
 			     struct drbd_peer_request *peer_req,
-			     const unsigned rw, const int fault_type)
+			     const unsigned op, const unsigned op_flags,
+			     const int fault_type)
 {
 	struct bio *bios = NULL;
 	struct bio *bio;
@@ -1417,7 +1418,8 @@ next_bio:
 	/* > peer_req->i.sector, unless this is the first bio */
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = device->ldev->backing_bdev;
-	bio->bi_rw = rw;
+	bio->bi_rw = op | op_flags;
+	bio->bi_op = op;
 	bio->bi_private = peer_req;
 	bio->bi_end_io = drbd_peer_request_endio;
 
@@ -1425,7 +1427,7 @@ next_bio:
 	bios = bio;
 	++n_bios;
 
-	if (rw & REQ_DISCARD) {
+	if (op & REQ_OP_DISCARD) {
 		bio->bi_iter.bi_size = data_size;
 		goto submit;
 	}
@@ -1803,7 +1805,8 @@ static int recv_resync_read(struct drbd_peer_device *peer_device, sector_t secto
 	spin_unlock_irq(&device->resource->req_lock);
 
 	atomic_add(pi->size >> 9, &device->rs_sect_ev);
-	if (drbd_submit_peer_request(device, peer_req, WRITE, DRBD_FAULT_RS_WR) == 0)
+	if (drbd_submit_peer_request(device, peer_req, REQ_OP_WRITE, 0,
+				     DRBD_FAULT_RS_WR) == 0)
 		return 0;
 
 	/* don't care for the reason here */
@@ -2125,7 +2128,7 @@ static int wait_for_and_update_peer_seq(struct drbd_peer_device *peer_device, co
 /* see also bio_flags_to_wire()
  * DRBD_REQ_*, because we need to semantically map the flags to data packet
  * flags and back. We may replicate to other kernel versions. */
-static unsigned long wire_flags_to_bio(u32 dpf)
+static unsigned long wire_flags_to_bio_flags(u32 dpf)
 {
 	return  (dpf & DP_RW_SYNC ? REQ_SYNC : 0) |
 		(dpf & DP_FUA ? REQ_FUA : 0) |
@@ -2133,6 +2136,14 @@ static unsigned long wire_flags_to_bio(u32 dpf)
 		(dpf & DP_DISCARD ? REQ_DISCARD : 0);
 }
 
+static unsigned long wire_flags_to_bio_op(u32 dpf)
+{
+	if (dpf & DP_DISCARD)
+		return REQ_OP_DISCARD;
+	else
+		return 0;
+}
+
 static void fail_postponed_requests(struct drbd_device *device, sector_t sector,
 				    unsigned int size)
 {
@@ -2276,7 +2287,7 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	struct drbd_peer_request *peer_req;
 	struct p_data *p = pi->data;
 	u32 peer_seq = be32_to_cpu(p->seq_num);
-	int rw = WRITE;
+	int op = REQ_OP_WRITE, op_flags = 0;
 	u32 dp_flags;
 	int err, tp;
 
@@ -2315,14 +2326,20 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 	peer_req->flags |= EE_APPLICATION;
 
 	dp_flags = be32_to_cpu(p->dp_flags);
-	rw |= wire_flags_to_bio(dp_flags);
+	/*
+	 * Tmp compat. We OR it here because other code assumes both the
+	 * discard and write flags are set. In the next patches that
+	 * will be cleaned up.
+	 */
+	op |= wire_flags_to_bio_op(dp_flags);
+	op_flags |= wire_flags_to_bio_flags(dp_flags);
 	if (pi->cmd == P_TRIM) {
 		struct request_queue *q = bdev_get_queue(device->ldev->backing_bdev);
 		peer_req->flags |= EE_IS_TRIM;
 		if (!blk_queue_discard(q))
 			peer_req->flags |= EE_IS_TRIM_USE_ZEROOUT;
 		D_ASSERT(peer_device, peer_req->i.size > 0);
-		D_ASSERT(peer_device, rw & REQ_DISCARD);
+		D_ASSERT(peer_device, op & REQ_OP_DISCARD);
 		D_ASSERT(peer_device, peer_req->pages == NULL);
 	} else if (peer_req->pages == NULL) {
 		D_ASSERT(device, peer_req->i.size == 0);
@@ -2406,7 +2423,8 @@ static int receive_Data(struct drbd_connection *connection, struct packet_info *
 		peer_req->flags |= EE_CALL_AL_COMPLETE_IO;
 	}
 
-	err = drbd_submit_peer_request(device, peer_req, rw, DRBD_FAULT_DT_WR);
+	err = drbd_submit_peer_request(device, peer_req, op, op_flags,
+				       DRBD_FAULT_DT_WR);
 	if (!err)
 		return 0;
 
@@ -2696,7 +2714,8 @@ submit_for_resync:
 submit:
 	update_receiver_timing_details(connection, drbd_submit_peer_request);
 	inc_unacked(device);
-	if (drbd_submit_peer_request(device, peer_req, READ, fault_type) == 0)
+	if (drbd_submit_peer_request(device, peer_req, REQ_OP_READ, 0,
+				     fault_type) == 0)
 		return 0;
 
 	/* don't care for the reason here */
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index 5578c14..23e5500 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -387,7 +387,8 @@ static int read_for_csum(struct drbd_peer_device *peer_device, sector_t sector,
 	spin_unlock_irq(&device->resource->req_lock);
 
 	atomic_add(size >> 9, &device->rs_sect_ev);
-	if (drbd_submit_peer_request(device, peer_req, READ, DRBD_FAULT_RS_RD) == 0)
+	if (drbd_submit_peer_request(device, peer_req, REQ_OP_READ, 0,
+				     DRBD_FAULT_RS_RD) == 0)
 		return 0;
 
 	/* If it failed because of ENOMEM, retry should help.  If it failed
-- 
1.8.3.1
