Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65598C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 04:06:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbiDHEIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 00:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbiDHEIk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 00:08:40 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4968C12C9C8
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 21:06:26 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id F08B2204171;
        Fri,  8 Apr 2022 05:57:02 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZvrfTPYRHW3u; Fri,  8 Apr 2022 05:57:01 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 7C03C2041CB;
        Fri,  8 Apr 2022 05:56:57 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@lst.de
Subject: [PATCH 3/6] sg: reinstate cmd_len > 32
Date:   Thu,  7 Apr 2022 23:56:48 -0400
Message-Id: <20220408035651.6472-4-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220408035651.6472-1-dgilbert@interlog.com>
References: <20220408035651.6472-1-dgilbert@interlog.com>
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
 drivers/scsi/sg.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index cbffa712b9f3..96d45550646b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
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

