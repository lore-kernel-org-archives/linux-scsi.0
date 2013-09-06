From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [RESEND PATCH v5 2/2] block,scsi: convert and handle ERR_PTR from
 blk_get_request
Date: Fri, 6 Sep 2013 17:47:14 -0400
Message-ID: <20130906174714.033be300@jlaw-desktop.mno.stratus.com>
References: <20130906174405.7ee1edb5@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.18]:59182 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3IFVrR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 17:47:17 -0400
In-Reply-To: <20130906174405.7ee1edb5@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>

The blk_get_request function may fail in low-memory conditions or during
device removal (even if __GFP_WAIT is set). To distinguish between these
errors, modify the blk_get_request call stack to return the appropriate
ERR_PTR. Verify that all callers check the return status and consider
IS_ERR instead of a simple NULL pointer check.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
---
 block/blk-core.c                            | 34 ++++++++++++++---------------
 block/bsg.c                                 |  8 +++----
 block/scsi_ioctl.c                          | 12 +++++-----
 drivers/block/paride/pd.c                   |  4 ++--
 drivers/block/pktcdvd.c                     |  4 ++--
 drivers/block/sx8.c                         |  2 +-
 drivers/cdrom/cdrom.c                       |  4 ++--
 drivers/ide/ide-park.c                      |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |  2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  2 +-
 drivers/scsi/osd/osd_initiator.c            |  4 ++--
 drivers/scsi/osst.c                         |  2 +-
 drivers/scsi/scsi_error.c                   |  2 +-
 drivers/scsi/scsi_lib.c                     |  2 +-
 drivers/scsi/scsi_tgt_lib.c                 |  2 +-
 drivers/scsi/sg.c                           |  4 ++--
 drivers/scsi/st.c                           |  2 +-
 drivers/target/target_core_pscsi.c          |  4 ++--
 20 files changed, 51 insertions(+), 51 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c045053..e3f67a5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -887,9 +887,9 @@ static struct io_context *rq_ioc(struct bio *bio)
  * Get a free request from @q.  This function may fail under memory
  * pressure or if @q is dead.
  *
- * Must be callled with @q->queue_lock held and,
- * Returns %NULL on failure, with @q->queue_lock held.
- * Returns !%NULL on success, with @q->queue_lock *not held*.
+ * Must be called with @q->queue_lock held and,
+ * Returns ERR_PTR on failure, with @q->queue_lock held.
+ * Returns request pointer on success, with @q->queue_lock *not held*.
  */
 static struct request *__get_request(struct request_list *rl, int rw_flags,
 				     struct bio *bio, gfp_t gfp_mask)
@@ -903,7 +903,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 	int may_queue;
 
 	if (unlikely(blk_queue_dying(q)))
-		return NULL;
+		return ERR_PTR(-ENODEV);
 
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
@@ -928,7 +928,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 					 * process is not a "batcher", and not
 					 * exempted by the IO scheduler
 					 */
-					return NULL;
+					return ERR_PTR(-ENOMEM);
 				}
 			}
 		}
@@ -946,7 +946,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 	 * allocated with any setting of ->nr_requests
 	 */
 	if (rl->count[is_sync] >= (3 * q->nr_requests / 2))
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	q->nr_rqs[is_sync]++;
 	rl->count[is_sync]++;
@@ -1051,7 +1051,7 @@ fail_alloc:
 rq_starved:
 	if (unlikely(rl->count[is_sync] == 0))
 		rl->starved[is_sync] = 1;
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 /**
@@ -1064,9 +1064,9 @@ rq_starved:
  * Get a free request from @q.  If %__GFP_WAIT is set in @gfp_mask, this
  * function keeps retrying under memory pressure and fails iff @q is dead.
  *
- * Must be callled with @q->queue_lock held and,
- * Returns %NULL on failure, with @q->queue_lock held.
- * Returns !%NULL on success, with @q->queue_lock *not held*.
+ * Must be called with @q->queue_lock held and,
+ * Returns ERR_PTR on failure, with @q->queue_lock held.
+ * Returns request pointer on success, with @q->queue_lock *not held*.
  */
 static struct request *get_request(struct request_queue *q, int rw_flags,
 				   struct bio *bio, gfp_t gfp_mask)
@@ -1079,12 +1079,12 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
 	rl = blk_get_rl(q, bio);	/* transferred to @rq on success */
 retry:
 	rq = __get_request(rl, rw_flags, bio, gfp_mask);
-	if (rq)
+	if (!IS_ERR(rq))
 		return rq;
 
 	if (!(gfp_mask & __GFP_WAIT) || unlikely(blk_queue_dying(q))) {
 		blk_put_rl(rl);
-		return NULL;
+		return rq;
 	}
 
 	/* wait on @rl and retry */
@@ -1120,7 +1120,7 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 
 	spin_lock_irq(q->queue_lock);
 	rq = get_request(q, rw, NULL, gfp_mask);
-	if (!rq)
+	if (unlikely(IS_ERR(rq)))
 		spin_unlock_irq(q->queue_lock);
 	/* q->queue_lock is unlocked at this point */
 
@@ -1164,8 +1164,8 @@ struct request *blk_make_request(struct request_queue *q, struct bio *bio,
 {
 	struct request *rq = blk_get_request(q, bio_data_dir(bio), gfp_mask);
 
-	if (unlikely(!rq))
-		return ERR_PTR(-ENOMEM);
+	if (unlikely(IS_ERR(rq)))
+		return rq;
 
 	for_each_bio(bio) {
 		struct bio *bounce_bio = bio;
@@ -1529,8 +1529,8 @@ get_rq:
 	 * Returns with the queue unlocked.
 	 */
 	req = get_request(q, rw_flags, bio, GFP_NOIO);
-	if (unlikely(!req)) {
-		bio_endio(bio, -ENODEV);	/* @q is dead */
+	if (unlikely(IS_ERR(req))) {
+		bio_endio(bio, PTR_ERR(req));	/* @q is dead */
 		goto out_unlock;
 	}
 
diff --git a/block/bsg.c b/block/bsg.c
index 420a5a9..2b1c322 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -271,8 +271,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 	 * map scatter-gather elements separately and string them to request
 	 */
 	rq = blk_get_request(q, rw, GFP_KERNEL);
-	if (!rq)
-		return ERR_PTR(-ENOMEM);
+	if (IS_ERR(rq))
+		return rq;
 	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, has_write_perm);
 	if (ret)
 		goto out;
@@ -284,8 +284,8 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm,
 		}
 
 		next_rq = blk_get_request(q, READ, GFP_KERNEL);
-		if (!next_rq) {
-			ret = -ENOMEM;
+		if (IS_ERR(next_rq)) {
+			ret = PTR_ERR(rq);
 			goto out;
 		}
 		rq->next_rq = next_rq;
diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index dd1810d..6b97c27 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -312,8 +312,8 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		}
 
 	rq = blk_get_request(q, writing ? WRITE : READ, GFP_KERNEL);
-	if (!rq)
-		return -ENOMEM;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	if (blk_fill_sghdr_rq(q, rq, hdr, mode)) {
 		blk_put_request(rq);
@@ -459,8 +459,8 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	}
 
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
-	if (!rq) {
-		err = -ENODEV;
+	if (IS_ERR(rq)) {
+		err = PTR_ERR(rq);
 		goto error_free_buffer;
 	}
 
@@ -550,8 +550,8 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	int err;
 
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
-	if (!rq)
-		return -ENODEV;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	rq->cmd[0] = cmd;
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 856178a..2af4101 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -722,8 +722,8 @@ static int pd_special_command(struct pd_unit *disk,
 	int err = 0;
 
 	rq = blk_get_request(disk->gd->queue, READ, __GFP_WAIT);
-	if (!rq)
-		return -ENODEV;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = func;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 1a83718..73b2566 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -712,8 +712,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
 			     WRITE : READ, __GFP_WAIT);
-	if (!rq)
-		return -ENODEV;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	if (cgc->buflen) {
 		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 3fb6ab4..911b7fc 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -568,7 +568,7 @@ static struct carm_request *carm_get_special(struct carm_host *host)
 		return NULL;
 
 	rq = blk_get_request(host->oob_q, WRITE /* bogus */, GFP_KERNEL);
-	if (!rq) {
+	if (IS_ERR(rq)) {
 		spin_lock_irqsave(&host->lock, flags);
 		carm_put_request(host, crq);
 		spin_unlock_irqrestore(&host->lock, flags);
diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 8a3aff7..85e63d3 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2161,8 +2161,8 @@ static int cdrom_read_cdda_bpc(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		len = nr * CD_FRAMESIZE_RAW;
 
 		rq = blk_get_request(q, READ, GFP_KERNEL);
-		if (!rq) {
-			ret = -ENOMEM;
+		if (IS_ERR(rq)) {
+			ret = PTR_ERR(rq);
 			break;
 		}
 
diff --git a/drivers/ide/ide-park.c b/drivers/ide/ide-park.c
index 6ab9ab2..fd432de 100644
--- a/drivers/ide/ide-park.c
+++ b/drivers/ide/ide-park.c
@@ -46,7 +46,7 @@ static void issue_park_cmd(ide_drive_t *drive, unsigned long timeout)
 	 * timeout has expired, so power management will be reenabled.
 	 */
 	rq = blk_get_request(q, READ, GFP_NOWAIT);
-	if (unlikely(!rq))
+	if (unlikely(IS_ERR(rq)))
 		goto out;
 
 	rq->cmd[0] = REQ_UNPARK_HEADS;
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 68adb89..125650c 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -115,7 +115,7 @@ static struct request *get_alua_req(struct scsi_device *sdev,
 
 	rq = blk_get_request(q, rw, GFP_NOIO);
 
-	if (!rq) {
+	if (IS_ERR(rq)) {
 		sdev_printk(KERN_INFO, sdev,
 			    "%s: blk_get_request failed\n", __func__);
 		return NULL;
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index e1c8be0..2ec3261 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -275,7 +275,7 @@ static struct request *get_req(struct scsi_device *sdev, int cmd,
 
 	rq = blk_get_request(sdev->request_queue,
 			(cmd != INQUIRY) ? WRITE : READ, GFP_NOIO);
-	if (!rq) {
+	if (IS_ERR(rq)) {
 		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
 		return NULL;
 	}
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 084062b..1cf4019 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -117,7 +117,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 
 retry:
 	req = blk_get_request(sdev->request_queue, WRITE, GFP_NOIO);
-	if (!req)
+	if (IS_ERR(req))
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
@@ -247,7 +247,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	struct request *req;
 
 	req = blk_get_request(h->sdev->request_queue, WRITE, GFP_ATOMIC);
-	if (!req)
+	if (IS_ERR(req))
 		return SCSI_DH_RES_TEMP_UNAVAIL;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 69c915a..009bd8f 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -274,7 +274,7 @@ static struct request *get_rdac_req(struct scsi_device *sdev,
 
 	rq = blk_get_request(q, rw, GFP_NOIO);
 
-	if (!rq) {
+	if (IS_ERR(rq)) {
 		sdev_printk(KERN_INFO, sdev,
 				"get_rdac_req: blk_get_request failed.\n");
 		return NULL;
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index aa66361..0250efd 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1567,8 +1567,8 @@ static struct request *_make_request(struct request_queue *q, bool has_write,
 		struct request *req;
 
 		req = blk_get_request(q, has_write ? WRITE : READ, flags);
-		if (unlikely(!req))
-			return ERR_PTR(-ENOMEM);
+		if (unlikely(IS_ERR(req)))
+			return req;
 
 		return req;
 	}
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 21883a2..826cda9 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -362,7 +362,7 @@ static int osst_execute(struct osst_request *SRpnt, const unsigned char *cmd,
 	int write = (data_direction == DMA_TO_DEVICE);
 
 	req = blk_get_request(SRpnt->stp->device->request_queue, write, GFP_KERNEL);
-	if (!req)
+	if (IS_ERR(req))
 		return DRIVER_ERROR << 24;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index af6f2c44..b21c6c9 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1709,7 +1709,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	 * request becomes available
 	 */
 	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
-	if (!req)
+	if (IS_ERR(req))
 		return;
 
 	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d545931..0fd3382 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -236,7 +236,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	int ret = DRIVER_ERROR << 24;
 
 	req = blk_get_request(sdev->request_queue, write, __GFP_WAIT);
-	if (!req)
+	if (IS_ERR(req))
 		return ret;
 
 	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index 84a1fdf..d300620 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -97,7 +97,7 @@ struct scsi_cmnd *scsi_host_get_command(struct Scsi_Host *shost,
 	 * we are in target mode we want the opposite.
 	 */
 	rq = blk_get_request(shost->uspace_req_q, !write, gfp_mask);
-	if (!rq)
+	if (IS_ERR(rq))
 		goto free_tcmd;
 
 	cmd = __scsi_get_command(shost, gfp_mask);
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5cbc4bb..1f0ee70 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1629,8 +1629,8 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 				   dxfer_len));
 
 	rq = blk_get_request(q, rw, GFP_ATOMIC);
-	if (!rq)
-		return -ENOMEM;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	memcpy(rq->cmd, cmd, hp->cmd_len);
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index ff44b3c..c54d28d 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -481,7 +481,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 
 	req = blk_get_request(SRpnt->stp->device->request_queue, write,
 			      GFP_KERNEL);
-	if (!req)
+	if (IS_ERR(req))
 		return DRIVER_ERROR << 24;
 
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index e992b27..bb5a811 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1050,9 +1050,9 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 		req = blk_get_request(pdv->pdv_sd->request_queue,
 				(data_direction == DMA_TO_DEVICE),
 				GFP_KERNEL);
-		if (!req || IS_ERR(req)) {
+		if (IS_ERR(req)) {
 			pr_err("PSCSI: blk_get_request() failed: %ld\n",
-					req ? IS_ERR(req) : -ENOMEM);
+					PTR_ERR(req));
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 			goto fail;
 		}
-- 
1.8.3.1

