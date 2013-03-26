From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: [PATCH v3] block: handle pointer error from blk_get_request
Date: Tue, 26 Mar 2013 18:34:26 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1303261826270.26171@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1303171328250.1736@jlaw-desktop.mno.stratus.com> <alpine.DEB.2.02.1303261438130.26171@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:49958 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3CZWiM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Mar 2013 18:38:12 -0400
In-Reply-To: <alpine.DEB.2.02.1303261438130.26171@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Bart Van Assche <bvanassche@acm.org>, Joe Lawrence <joe.lawrence@stratus.com>

... one more caller to update (how did blk_make_request hide? :)  ...

Changes from v2:
 - Updated blk_make_request to check IS_ERR from blk_get_request

That should account for all the callers of blk_get_request, save for the
IDE drivers, which I left alone but for the lone caller in ide-park.c
that does bother to check the return pointer.

Regards,

-- Joe

>From 05646b66021df447207e327e3c7c8692a506cd4b Mon Sep 17 00:00:00 2001
From: Joe Lawrence <joe.lawrence@stratus.com>
Date: Tue, 26 Mar 2013 18:03:26 -0400
Subject: [PATCH v3] block: handle pointer error from blk_get_request

The blk_get_request function may fail in low-memory conditions or during
device removal (even if __GFP_WAIT is set). To distinguish between these
errors, modify the blk_get_request call stack to return the appropriate
error pointer. Verify that all callers check the return status and
consider IS_ERR instead of a simple NULL pointer check.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
---
 block/blk-core.c                            | 34 ++++++++++++++---------------
 block/bsg.c                                 |  8 +++----
 block/scsi_ioctl.c                          |  8 +++++--
 drivers/block/paride/pd.c                   |  2 ++
 drivers/block/pktcdvd.c                     |  3 ++-
 drivers/block/sx8.c                         |  2 +-
 drivers/cdrom/cdrom.c                       |  4 ++--
 drivers/ide/ide-park.c                      |  2 +-
 drivers/scsi/device_handler/scsi_dh_alua.c  |  2 +-
 drivers/scsi/device_handler/scsi_dh_emc.c   |  2 +-
 drivers/scsi/device_handler/scsi_dh_hp_sw.c |  4 ++--
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  2 +-
 drivers/scsi/osd/osd_initiator.c            |  4 ++--
 drivers/scsi/osst.c                         |  2 +-
 drivers/scsi/scsi_error.c                   |  2 ++
 drivers/scsi/scsi_lib.c                     |  2 +-
 drivers/scsi/scsi_tgt_lib.c                 |  2 +-
 drivers/scsi/sg.c                           |  4 ++--
 drivers/scsi/st.c                           |  2 +-
 drivers/target/target_core_pscsi.c          |  4 ++--
 20 files changed, 52 insertions(+), 43 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f224d17..9e254e4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -886,9 +886,9 @@ static struct io_context *rq_ioc(struct bio *bio)
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
@@ -902,7 +902,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 	int may_queue;
 
 	if (unlikely(blk_queue_dying(q)))
-		return NULL;
+		return ERR_PTR(-ENODEV);
 
 	may_queue = elv_may_queue(q, rw_flags);
 	if (may_queue == ELV_MQUEUE_NO)
@@ -927,7 +927,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 					 * process is not a "batcher", and not
 					 * exempted by the IO scheduler
 					 */
-					return NULL;
+					return ERR_PTR(-ENOMEM);
 				}
 			}
 		}
@@ -945,7 +945,7 @@ static struct request *__get_request(struct request_list *rl, int rw_flags,
 	 * allocated with any setting of ->nr_requests
 	 */
 	if (rl->count[is_sync] >= (3 * q->nr_requests / 2))
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	q->nr_rqs[is_sync]++;
 	rl->count[is_sync]++;
@@ -1050,7 +1050,7 @@ fail_alloc:
 rq_starved:
 	if (unlikely(rl->count[is_sync] == 0))
 		rl->starved[is_sync] = 1;
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 /**
@@ -1063,9 +1063,9 @@ rq_starved:
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
@@ -1078,12 +1078,12 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
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
@@ -1119,7 +1119,7 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
 
 	spin_lock_irq(q->queue_lock);
 	rq = get_request(q, rw, NULL, gfp_mask);
-	if (!rq)
+	if (unlikely(IS_ERR(rq)))
 		spin_unlock_irq(q->queue_lock);
 	/* q->queue_lock is unlocked at this point */
 
@@ -1163,8 +1163,8 @@ struct request *blk_make_request(struct request_queue *q, struct bio *bio,
 {
 	struct request *rq = blk_get_request(q, bio_data_dir(bio), gfp_mask);
 
-	if (unlikely(!rq))
-		return ERR_PTR(-ENOMEM);
+	if (unlikely(IS_ERR(rq)))
+		return rq;
 
 	for_each_bio(bio) {
 		struct bio *bounce_bio = bio;
@@ -1528,8 +1528,8 @@ get_rq:
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
index 9a87daa..014b92a 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -311,8 +311,8 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		}
 
 	rq = blk_get_request(q, writing ? WRITE : READ, GFP_KERNEL);
-	if (!rq)
-		return -ENOMEM;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	if (blk_fill_sghdr_rq(q, rq, hdr, mode)) {
 		blk_put_request(rq);
@@ -458,6 +458,8 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 	}
 
 	rq = blk_get_request(q, in_len ? WRITE : READ, __GFP_WAIT);
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	cmdlen = COMMAND_SIZE(opcode);
 
@@ -544,6 +546,8 @@ static int __blk_send_generic(struct request_queue *q, struct gendisk *bd_disk,
 	int err;
 
 	rq = blk_get_request(q, WRITE, __GFP_WAIT);
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
 	rq->cmd[0] = cmd;
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 831e3ac..0d4e530 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -722,6 +722,8 @@ static int pd_special_command(struct pd_unit *disk,
 	int err = 0;
 
 	rq = blk_get_request(disk->gd->queue, READ, __GFP_WAIT);
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	rq->cmd_type = REQ_TYPE_SPECIAL;
 	rq->special = func;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 1119042..25ab3bd 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -711,7 +711,8 @@ static int pkt_generic_packet(struct pktcdvd_device *pd, struct packet_command *
 
 	rq = blk_get_request(q, (cgc->data_direction == CGC_DATA_WRITE) ?
 			     WRITE : READ, __GFP_WAIT);
-
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 	if (cgc->buflen) {
 		if (blk_rq_map_kern(q, rq, cgc->buffer, cgc->buflen, __GFP_WAIT))
 			goto out;
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
index d620b44..999d852 100644
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
index 6f4d8e6..f07f152 100644
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
index d8293f2..b4cd56b 100644
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
index c1b05a8..7b248fb 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1635,6 +1635,8 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	 * request becomes available
 	 */
 	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
+	if (IS_ERR(req))
+		return;
 
 	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
 	req->cmd[1] = 0;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c31187d..cad055b 100644
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
index 9f0c465..5d39fec 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1649,8 +1649,8 @@ static int sg_start_req(Sg_request *srp, unsigned char *cmd)
 				   dxfer_len));
 
 	rq = blk_get_request(q, rw, GFP_ATOMIC);
-	if (!rq)
-		return -ENOMEM;
+	if (IS_ERR(rq))
+		return PTR_ERR(rq);
 
 	memcpy(rq->cmd, cmd, hp->cmd_len);
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 8697447..5fca9cb 100644
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
index 82e78d7..8cd953a 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1045,9 +1045,9 @@ pscsi_execute_cmd(struct se_cmd *cmd)
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
1.8.1.4

