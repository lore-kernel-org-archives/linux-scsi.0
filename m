Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9692C43470
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A349061409
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242312AbhDWLlL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:41:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:47544 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242326AbhDWLkw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 07:40:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DC1A5B1FD;
        Fri, 23 Apr 2021 11:39:55 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 36/39] scsi: drop message byte helper
Date:   Fri, 23 Apr 2021 13:39:41 +0200
Message-Id: <20210423113944.42672-37-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423113944.42672-1-hare@suse.de>
References: <20210423113944.42672-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The message byte is now unused, so we can drop the helper to set
the message byte and the check for message bytes during error recovery.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 block/scsi_ioctl.c         |  2 +-
 drivers/scsi/scsi_error.c  | 18 ++----------------
 drivers/scsi/sg.c          |  2 +-
 drivers/xen/xen-scsiback.c |  2 +-
 include/scsi/scsi.h        |  3 +--
 include/scsi/scsi_cmnd.h   |  5 -----
 6 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index a297976ccc08..1ab8f5290e08 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -254,7 +254,7 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
 	 */
 	hdr->status = req->result & 0xff;
 	hdr->masked_status = status_byte(req->result);
-	hdr->msg_status = msg_byte(req->result);
+	hdr->msg_status = COMMAND_COMPLETE;
 	hdr->host_status = host_byte(req->result);
 	hdr->driver_status = 0;
 	if (hdr->status == SAM_STAT_CHECK_CONDITION)
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 689ee628eff9..3e6e456816fc 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -741,12 +741,6 @@ static enum scsi_disposition scsi_eh_completed_normally(struct scsi_cmnd *scmd)
 	if (host_byte(scmd->result) != DID_OK)
 		return FAILED;
 
-	/*
-	 * next, check the message byte.
-	 */
-	if (msg_byte(scmd->result) != COMMAND_COMPLETE)
-		return FAILED;
-
 	/*
 	 * now, check the status byte to see if this indicates
 	 * anything special.
@@ -1766,8 +1760,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
 	case DID_PARITY:
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
 	case DID_ERROR:
-		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
-		    status_byte(scmd->result) == RESERVATION_CONFLICT)
+		if (status_byte(scmd->result) == RESERVATION_CONFLICT)
 			return 0;
 		fallthrough;
 	case DID_SOFT_ERROR:
@@ -1883,8 +1876,7 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		 */
 		return SUCCESS;
 	case DID_ERROR:
-		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
-		    status_byte(scmd->result) == RESERVATION_CONFLICT)
+		if (status_byte(scmd->result) == RESERVATION_CONFLICT)
 			/*
 			 * execute reservation conflict processing code
 			 * lower down
@@ -1912,12 +1904,6 @@ enum scsi_disposition scsi_decide_disposition(struct scsi_cmnd *scmd)
 		return FAILED;
 	}
 
-	/*
-	 * next, check the message byte.
-	 */
-	if (msg_byte(scmd->result) != COMMAND_COMPLETE)
-		return FAILED;
-
 	/*
 	 * check the status byte to see if this indicates anything special.
 	 */
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 9122d05563d0..658a3538d69b 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1376,7 +1376,7 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
 
 		srp->header.status = 0xff & result;
 		srp->header.masked_status = status_byte(result);
-		srp->header.msg_status = msg_byte(result);
+		srp->header.msg_status = COMMAND_COMPLETE;
 		srp->header.host_status = host_byte(result);
 		srp->header.driver_status = driver_byte(result);
 		if ((sdp->sgdebug > 0) &&
diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index a6bb2600a2d7..bea22f71c782 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -224,7 +224,7 @@ static void scsiback_print_status(char *sense_buffer, int errors,
 
 	pr_err("[%s:%d] cmnd[0]=%02x -> st=%02x msg=%02x host=%02x\n",
 	       tpg->tport->tport_name, pending_req->v2p->lun,
-	       pending_req->cmnd[0], status_byte(errors), msg_byte(errors),
+	       pending_req->cmnd[0], status_byte(errors), COMMAND_COMPLETE,
 	       host_byte(errors));
 }
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index e06433d78df4..bd1d1bc5d1b7 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -209,11 +209,10 @@ enum scsi_disposition {
  *  These are set by:
  *
  *      status byte = set from target device
- *      msg_byte    = return status from host adapter itself.
+ *      msg_byte    (unused)
  *      host_byte   = set by low-level driver to indicate status.
  */
 #define status_byte(result) (((result) >> 1) & 0x7f)
-#define msg_byte(result)    (((result) >> 8) & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
 
 #define sense_class(sense)  (((sense) >> 4) & 0x7)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 348bfa568f72..e118dc1c9d4a 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -321,11 +321,6 @@ static inline unsigned char get_status_byte(struct scsi_cmnd *cmd)
 	return cmd->result & 0xff;
 }
 
-static inline void set_msg_byte(struct scsi_cmnd *cmd, char status)
-{
-	cmd->result = (cmd->result & 0xffff00ff) | (status << 8);
-}
-
 static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
 {
 	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
-- 
2.29.2

