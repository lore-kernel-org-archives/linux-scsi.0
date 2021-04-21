Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9133AC43460
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EA8761409
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244946AbhDURvH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:51:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:52396 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245075AbhDURtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F1523B2E6;
        Wed, 21 Apr 2021 17:48:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 30/42] acornscsi: use standard macros to set SCSI result
Date:   Wed, 21 Apr 2021 19:47:37 +0200
Message-Id: <20210421174749.11221-31-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use standard macros to set the SCSI result to avoid shift and mask
error.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/arm/acornscsi.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 248a5bfad153..6a49a75e94ff 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -794,7 +794,9 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 
 	acornscsi_dma_cleanup(host);
 
-	SCpnt->result = result << 16 | host->scsi.SCp.Message << 8 | host->scsi.SCp.Status;
+	set_host_byte(SCpnt, result);
+	set_msg_byte(SCpnt, host->scsi.SCp.Message);
+	set_status_byte(SCpnt, host->scsi.SCp.Status);
 
 	/*
 	 * In theory, this should not happen.  In practice, it seems to.
@@ -844,7 +846,8 @@ static void acornscsi_done(AS_Host *host, struct scsi_cmnd **SCpntp,
 		    default:
 			scmd_printk(KERN_ERR, SCpnt,
 				    "incomplete data transfer detected: "
-				    "result=%08X", SCpnt->result);
+				    "result=%08X",
+				    scsi_get_compat)result(SCpnt));
 			scsi_print_command(SCpnt);
 			acornscsi_dumpdma(host, "done");
 			acornscsi_dumplog(host, SCpnt->device->id);
@@ -2466,11 +2469,14 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
 	return -EINVAL;
     }
 
+    set_host_byte(SCpnt, DID_OK);
+    set_status_byte(SCpnt, SAM_STAT_GOOD);
+
 #if (DEBUG & DEBUG_NO_WRITE)
     if (acornscsi_cmdtype(SCpnt->cmnd[0]) == CMD_WRITE && (NO_WRITE & (1 << SCpnt->device->id))) {
 	printk(KERN_CRIT "scsi%d.%c: WRITE attempted with NO_WRITE flag set\n",
 	    host->host->host_no, '0' + SCpnt->device->id);
-	SCpnt->result = DID_NO_CONNECT << 16;
+	set_host_byte(SCpnt, DID_NO_CONNECT);
 	done(SCpnt);
 	return 0;
     }
@@ -2478,7 +2484,6 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
 
     SCpnt->scsi_done = done;
     SCpnt->host_scribble = NULL;
-    SCpnt->result = 0;
     SCpnt->tag = 0;
     SCpnt->SCp.phase = (int)acornscsi_datadirection(SCpnt->cmnd[0]);
     SCpnt->SCp.sent_command = 0;
@@ -2492,7 +2497,7 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd *SCpnt,
 	unsigned long flags;
 
 	if (!queue_add_cmd_ordered(&host->queues.issue, SCpnt)) {
-	    SCpnt->result = DID_ERROR << 16;
+		set_host_byte(SCpnt, DID_ERROR);
 	    done(SCpnt);
 	    return 0;
 	}
-- 
2.29.2

