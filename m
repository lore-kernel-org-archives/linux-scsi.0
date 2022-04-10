Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D203C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Apr 2022 17:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243748AbiDJRj0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 13:39:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243745AbiDJRjR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 13:39:17 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4429728E13
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 10:37:06 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9AD072041C0;
        Sun, 10 Apr 2022 19:37:05 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id yHhWbP3PqKbc; Sun, 10 Apr 2022 19:37:04 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 23CAB204179;
        Sun, 10 Apr 2022 19:37:03 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@lst.de
Subject: [PATCH v2 6/6] st,sr,stex: use scsi_cmnd cdb access functions
Date:   Sun, 10 Apr 2022 13:36:52 -0400
Message-Id: <20220410173652.313016-7-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220410173652.313016-1-dgilbert@interlog.com>
References: <20220410173652.313016-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sr.c   | 40 ++++++++++++++++++++++------------------
 drivers/scsi/st.c   | 12 +++++++-----
 drivers/scsi/stex.c | 22 +++++++++++++---------
 3 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5ba9df334968..1d76fd309501 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -358,7 +358,9 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	int block = 0, this_count, s_size;
 	struct scsi_cd *cd;
 	struct request *rq = scsi_cmd_to_rq(SCpnt);
+	u8 *cdb;
 	blk_status_t ret;
+	static const unsigned int read_write_10_cdb_len = 10;
 
 	ret = scsi_alloc_sgtables(SCpnt);
 	if (ret != BLK_STS_OK)
@@ -390,15 +392,17 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 		goto out;
 	}
 
+	/* scsi_cmnd_set_cdb() zeros out returned buffer */
+	cdb = scsi_cmnd_set_cdb(SCpnt, NULL, read_write_10_cdb_len);
 	switch (req_op(rq)) {
 	case REQ_OP_WRITE:
 		if (!cd->writeable)
 			goto out;
-		SCpnt->cmnd[0] = WRITE_10;
+		cdb[0] = WRITE_10;
 		cd->cdi.media_written = 1;
 		break;
 	case REQ_OP_READ:
-		SCpnt->cmnd[0] = READ_10;
+		cdb[0] = READ_10;
 		break;
 	default:
 		blk_dump_rq_flags(rq, "Unknown sr command");
@@ -439,7 +443,7 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 					"writing" : "reading",
 					this_count, blk_rq_sectors(rq)));
 
-	SCpnt->cmnd[1] = 0;
+	cdb[1] = 0;
 	block = (unsigned int)blk_rq_pos(rq) / (s_size >> 9);
 
 	if (this_count > 0xffff) {
@@ -447,9 +451,8 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 		SCpnt->sdb.length = this_count * s_size;
 	}
 
-	put_unaligned_be32(block, &SCpnt->cmnd[2]);
-	SCpnt->cmnd[6] = SCpnt->cmnd[9] = 0;
-	put_unaligned_be16(this_count, &SCpnt->cmnd[7]);
+	put_unaligned_be32(block, &cdb[2]);
+	put_unaligned_be16(this_count, &cdb[7]);
 
 	/*
 	 * We shouldn't disconnect in the middle of a sector, so with a dumb
@@ -459,7 +462,6 @@ static blk_status_t sr_init_command(struct scsi_cmnd *SCpnt)
 	SCpnt->transfersize = cd->device->sector_size;
 	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = MAX_RETRIES;
-	SCpnt->cmd_len = 10;
 
 	/*
 	 * This indicates that the command is ready from our end to be queued.
@@ -929,6 +931,7 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	struct scsi_cmnd *scmd;
 	struct request *rq;
 	struct bio *bio;
+	u8 *cdb;
 	int ret;
 
 	rq = scsi_alloc_request(disk->queue, REQ_OP_DRV_IN, 0);
@@ -940,17 +943,18 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	if (ret)
 		goto out_put_request;
 
-	scmd->cmnd[0] = GPCMD_READ_CD;
-	scmd->cmnd[1] = 1 << 2;
-	scmd->cmnd[2] = (lba >> 24) & 0xff;
-	scmd->cmnd[3] = (lba >> 16) & 0xff;
-	scmd->cmnd[4] = (lba >>  8) & 0xff;
-	scmd->cmnd[5] = lba & 0xff;
-	scmd->cmnd[6] = (nr >> 16) & 0xff;
-	scmd->cmnd[7] = (nr >>  8) & 0xff;
-	scmd->cmnd[8] = nr & 0xff;
-	scmd->cmnd[9] = 0xf8;
 	scmd->cmd_len = 12;
+	cdb = scsi_cmnd_set_cdb(scmd, NULL, scmd->cmd_len);
+	cdb[0] = GPCMD_READ_CD;
+	cdb[1] = 1 << 2;
+	cdb[2] = (lba >> 24) & 0xff;
+	cdb[3] = (lba >> 16) & 0xff;
+	cdb[4] = (lba >>  8) & 0xff;
+	cdb[5] = lba & 0xff;
+	cdb[6] = (nr >> 16) & 0xff;
+	cdb[7] = (nr >>  8) & 0xff;
+	cdb[8] = nr & 0xff;
+	cdb[9] = 0xf8;
 	rq->timeout = 60 * HZ;
 	bio = rq->bio;
 
@@ -967,7 +971,7 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	if (blk_rq_unmap_user(bio))
 		ret = -EFAULT;
 out_put_request:
-	blk_mq_free_request(rq);
+	scsi_free_cmnd(scmd);
 	return ret;
 }
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 56a093a90b92..801486c9b411 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -473,10 +473,11 @@ static void st_release_request(struct st_request *streq)
 static void st_do_stats(struct scsi_tape *STp, struct request *req)
 {
 	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
+	const u8 *cdb = scsi_cmnd_get_cdb(scmd);
 	ktime_t now;
 
 	now = ktime_get();
-	if (scmd->cmnd[0] == WRITE_6) {
+	if (cdb[0] == WRITE_6) {
 		now = ktime_sub(now, STp->stats->write_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_write_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
@@ -490,7 +491,7 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 		} else
 			atomic64_add(atomic_read(&STp->stats->last_write_size),
 				&STp->stats->write_byte_cnt);
-	} else if (scmd->cmnd[0] == READ_6) {
+	} else if (cdb[0] == READ_6) {
 		now = ktime_sub(now, STp->stats->read_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_read_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
@@ -531,7 +532,7 @@ static void st_scsi_execute_end(struct request *req, blk_status_t status)
 		complete(SRpnt->waiting);
 
 	blk_rq_unmap_user(tmp);
-	blk_mq_free_request(req);
+	scsi_free_cmnd(scmd);
 }
 
 static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
@@ -558,7 +559,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 		err = blk_rq_map_user(req->q, req, mdata, NULL, bufflen,
 				      GFP_KERNEL);
 		if (err) {
-			blk_mq_free_request(req);
+			scsi_free_cmnd(scmd);
 			return err;
 		}
 	}
@@ -576,7 +577,8 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 
 	SRpnt->bio = req->bio;
 	scmd->cmd_len = COMMAND_SIZE(cmd[0]);
-	memcpy(scmd->cmnd, cmd, scmd->cmd_len);
+	/* Don't check for NULL return as extremely unlikely */
+	scsi_cmnd_set_cdb(scmd, cmd, scmd->cmd_len);
 	req->timeout = timeout;
 	scmd->allowed = retries;
 	req->end_io_data = SRpnt;
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index e6420f2127ce..8f0d28ef2963 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -597,6 +597,7 @@ static int stex_queuecommand_lck(struct scsi_cmnd *cmd)
 	struct Scsi_Host *host;
 	unsigned int id, lun;
 	struct req_msg *req;
+	const u8 *cdb;
 	u16 tag;
 
 	host = cmd->device->host;
@@ -611,14 +612,15 @@ static int stex_queuecommand_lck(struct scsi_cmnd *cmd)
 	if (unlikely(hba->mu_status != MU_STATE_STARTED))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	switch (cmd->cmnd[0]) {
+	cdb = scsi_cmnd_get_cdb(cmd);
+	switch (cdb[0]) {
 	case MODE_SENSE_10:
 	{
 		static char ms10_caching_page[12] =
 			{ 0, 0x12, 0, 0, 0, 0, 0, 0, 0x8, 0xa, 0x4, 0 };
 		unsigned char page;
 
-		page = cmd->cmnd[2] & 0x3f;
+		page = cdb[2] & 0x3f;
 		if (page == 0x8 || page == 0x3f) {
 			scsi_sg_copy_from_buffer(cmd, ms10_caching_page,
 						 sizeof(ms10_caching_page));
@@ -655,7 +657,7 @@ static int stex_queuecommand_lck(struct scsi_cmnd *cmd)
 		if (id != host->max_id - 1)
 			break;
 		if (!lun && !cmd->device->channel &&
-			(cmd->cmnd[1] & INQUIRY_EVPD) == 0) {
+			(cdb[1] & INQUIRY_EVPD) == 0) {
 			scsi_sg_copy_from_buffer(cmd, (void *)console_inq_page,
 						 sizeof(console_inq_page));
 			cmd->result = DID_OK << 16;
@@ -664,7 +666,7 @@ static int stex_queuecommand_lck(struct scsi_cmnd *cmd)
 			stex_invalid_field(cmd, done);
 		return 0;
 	case PASSTHRU_CMD:
-		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
+		if (cdb[1] == PASSTHRU_GET_DRVVER) {
 			struct st_drvver ver;
 			size_t cp_len = sizeof(ver);
 
@@ -699,7 +701,7 @@ static int stex_queuecommand_lck(struct scsi_cmnd *cmd)
 	req->target = id;
 
 	/* cdb */
-	memcpy(req->cdb, cmd->cmnd, STEX_CDB_LENGTH);
+	memcpy(req->cdb, cdb, STEX_CDB_LENGTH);
 
 	if (cmd->sc_data_direction == DMA_FROM_DEVICE)
 		req->data_dir = MSG_DATA_DIR_IN;
@@ -783,8 +785,8 @@ static void stex_copy_data(struct st_ccb *ccb,
 static void stex_check_cmd(struct st_hba *hba,
 	struct st_ccb *ccb, struct status_msg *resp)
 {
-	if (ccb->cmd->cmnd[0] == MGT_CMD &&
-		resp->scsi_status != SAM_STAT_CHECK_CONDITION)
+	if (scsi_cmnd_get_cdb(ccb->cmd)[0] == MGT_CMD &&
+	    resp->scsi_status != SAM_STAT_CHECK_CONDITION)
 		scsi_set_resid(ccb->cmd, scsi_bufflen(ccb->cmd) -
 			le32_to_cpu(*(__le32 *)&resp->variable[0]));
 }
@@ -858,11 +860,13 @@ static void stex_mu_intr(struct st_hba *hba, u32 doorbell)
 		ccb->scsi_status = resp->scsi_status;
 
 		if (likely(ccb->cmd != NULL)) {
+			const u8 *cdb = scsi_cmnd_get_cdb(ccb->cmd);
+
 			if (hba->cardtype == st_yosemite)
 				stex_check_cmd(hba, ccb, resp);
 
-			if (unlikely(ccb->cmd->cmnd[0] == PASSTHRU_CMD &&
-				ccb->cmd->cmnd[1] == PASSTHRU_GET_ADAPTER))
+			if (unlikely(cdb[0] == PASSTHRU_CMD &&
+				     cdb[1] == PASSTHRU_GET_ADAPTER))
 				stex_controller_info(hba, ccb);
 
 			scsi_dma_unmap(ccb->cmd);
-- 
2.25.1

