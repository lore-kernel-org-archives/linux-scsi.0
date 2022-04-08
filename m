Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9E1C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 04:06:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234268AbiDHEIo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 00:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiDHEIj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 00:08:39 -0400
X-Greylist: delayed 561 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Apr 2022 21:06:26 PDT
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B7712C6DC
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 21:06:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B0FCE2041CB;
        Fri,  8 Apr 2022 05:57:06 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hupTYdwN+SI0; Fri,  8 Apr 2022 05:57:04 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 5FC562041D7;
        Fri,  8 Apr 2022 05:57:01 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@lst.de
Subject: [PATCH 6/6] st,sr: use scsi_cmnd cdb access functions and dtor
Date:   Thu,  7 Apr 2022 23:56:51 -0400
Message-Id: <20220408035651.6472-7-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408035651.6472-1-dgilbert@interlog.com>
References: <20220408035651.6472-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sr.c | 24 +++++++++++++-----------
 drivers/scsi/st.c | 12 +++++++-----
 2 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 5ba9df334968..f51c8e1bdb2e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -929,6 +929,7 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
 	struct scsi_cmnd *scmd;
 	struct request *rq;
 	struct bio *bio;
+	u8 *cdb;
 	int ret;
 
 	rq = scsi_alloc_request(disk->queue, REQ_OP_DRV_IN, 0);
@@ -940,17 +941,18 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
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
 
@@ -967,7 +969,7 @@ static int sr_read_cdda_bpc(struct cdrom_device_info *cdi, void __user *ubuf,
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
-- 
2.25.1

