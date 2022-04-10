Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31E33C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Apr 2022 17:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243746AbiDJRjS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 13:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239935AbiDJRjQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 13:39:16 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 12A8E28E23
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 10:37:03 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E886F2041D4;
        Sun, 10 Apr 2022 19:37:02 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id liJH3SjVh4Uk; Sun, 10 Apr 2022 19:37:01 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 55E49204179;
        Sun, 10 Apr 2022 19:36:59 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@lst.de
Subject: [PATCH v2 3/6] sg: reinstate cmd_len > 32
Date:   Sun, 10 Apr 2022 13:36:49 -0400
Message-Id: <20220410173652.313016-4-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220410173652.313016-1-dgilbert@interlog.com>
References: <20220410173652.313016-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the changes to include/scsi/scsi_cmnd.h in earlier patch
to use the scsi_cmnd_set_cdb() function to place a SCSI CDB
in the struct scsi_cmnd object.

When free-ing up a struct request, or its attached scsi_cmnd
sub-object, call scsi_free_cmnd() which ensures that if a
long cdb used its own heap allocation, then that heap is freed.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index cbffa712b9f3..653c172a6338 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -77,7 +77,7 @@ static int sg_proc_init(void);
  * of sg_io_hdr::cmd_len can only represent 255. All SCSI commands greater
  * than 16 bytes are "variable length" whose length is a multiple of 4
  */
-#define SG_MAX_CDB_SIZE 252
+#define SG_MAX_CDB_SIZE SCSI_MAX_RUN_TIME_8BIT_CDB_LEN
 
 #define SG_DEFAULT_TIMEOUT mult_frac(SG_DEFAULT_TIMEOUT_USER, HZ, USER_HZ)
 
@@ -813,7 +813,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	}
 	if (atomic_read(&sdp->detaching)) {
 		if (srp->bio) {
-			blk_mq_free_request(srp->rq);
+			scsi_free_cmnd(blk_mq_rq_to_pdu(srp->rq));
 			srp->rq = NULL;
 		}
 
@@ -1387,7 +1387,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 	 * blk_rq_unmap_user() can be called from user context.
 	 */
 	srp->rq = NULL;
-	blk_mq_free_request(rq);
+	scsi_free_cmnd(scmd);
 
 	write_lock_irqsave(&sfp->rq_list_lock, iflags);
 	if (unlikely(srp->orphan)) {
@@ -1753,14 +1753,14 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 		return PTR_ERR(rq);
 	scmd = blk_mq_rq_to_pdu(rq);
 
-	if (hp->cmd_len > sizeof(scmd->cmnd)) {
-		blk_mq_free_request(rq);
+	if (unlikely(hp->cmd_len > SCSI_MAX_RUN_TIME_CDB_LEN)) {
+		scsi_free_cmnd(scmd);
 		return -EINVAL;
 	}
-
-	memcpy(scmd->cmnd, cmd, hp->cmd_len);
-	scmd->cmd_len = hp->cmd_len;
-
+	if (unlikely(!scsi_cmnd_set_cdb(scmd, cmd, hp->cmd_len))) {
+		scsi_free_cmnd(scmd);
+		return -ENOMEM;
+	}
 	srp->rq = rq;
 	rq->end_io_data = srp;
 	scmd->allowed = SG_DEFAULT_RETRIES;
@@ -1845,6 +1845,7 @@ sg_finish_rem_req(Sg_request *srp)
 
 	Sg_fd *sfp = srp->parentfp;
 	Sg_scatter_hold *req_schp = &srp->data;
+	struct request *rq = srp->rq;
 
 	SCSI_LOG_TIMEOUT(4, sg_printk(KERN_INFO, sfp->parentdp,
 				      "sg_finish_rem_req: res_used=%d\n",
@@ -1852,8 +1853,8 @@ sg_finish_rem_req(Sg_request *srp)
 	if (srp->bio)
 		ret = blk_rq_unmap_user(srp->bio);
 
-	if (srp->rq)
-		blk_mq_free_request(srp->rq);
+	if (rq)
+		scsi_free_cmnd(blk_mq_rq_to_pdu(rq));
 
 	if (srp->res_used)
 		sg_unlink_reserve(sfp, srp);
-- 
2.25.1

