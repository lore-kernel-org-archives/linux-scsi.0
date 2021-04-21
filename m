Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB32C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 059886141C
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245043AbhDURvI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:51:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:52394 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245074AbhDURtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DE542B2E4;
        Wed, 21 Apr 2021 17:48:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 26/42] wd33c93: use standard macros to set SCSI result
Date:   Wed, 21 Apr 2021 19:47:33 +0200
Message-Id: <20210421174749.11221-27-hare@suse.de>
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
 drivers/scsi/wd33c93.c | 45 +++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index a23277bb870e..0a5bb238f001 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -381,7 +381,8 @@ wd33c93_queuecommand_lck(struct scsi_cmnd *cmd,
  */
 	cmd->host_scribble = NULL;
 	cmd->scsi_done = done;
-	cmd->result = 0;
+	set_host_byte(cmd, DID_OK);
+	set_status_byte(cmd, SAM_STAT_GOOD);
 
 /* We use the Scsi_Pointer structure that's included with each command
  * as a scratchpad (as it's intended to be used!). The handy thing about
@@ -853,7 +854,7 @@ wd33c93_intr(struct Scsi_Host *instance)
 			hostdata->selecting = NULL;
 		}
 
-		cmd->result = DID_NO_CONNECT << 16;
+		set_host_byte(cmd, DID_NO_CONNECT);
 		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 		hostdata->state = S_UNCONNECTED;
 		cmd->scsi_done(cmd);
@@ -1177,12 +1178,11 @@ wd33c93_intr(struct Scsi_Host *instance)
 				cmd->SCp.Status = lun;
 			if (cmd->cmnd[0] == REQUEST_SENSE
 			    && cmd->SCp.Status != SAM_STAT_GOOD)
-				cmd->result =
-				    (cmd->
-				     result & 0x00ffff) | (DID_ERROR << 16);
-			else
-				cmd->result =
-				    cmd->SCp.Status | (cmd->SCp.Message << 8);
+				set_host_byte(cmd, DID_ERROR);
+			else {
+				set_status_byte(cmd, cmd->SCp.Status);
+				set_msg_byte(cmd, cmd->SCp.Message);
+			}
 			cmd->scsi_done(cmd);
 
 /* We are no longer  connected to a target - check to see if
@@ -1262,11 +1262,13 @@ wd33c93_intr(struct Scsi_Host *instance)
 		    hostdata->connected = NULL;
 		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 		hostdata->state = S_UNCONNECTED;
-		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != SAM_STAT_GOOD)
-			cmd->result =
-			    (cmd->result & 0x00ffff) | (DID_ERROR << 16);
-		else
-			cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
+		if (cmd->cmnd[0] == REQUEST_SENSE &&
+		    cmd->SCp.Status != SAM_STAT_GOOD)
+			set_host_byte(cmd, DID_ERROR);
+		else {
+			set_status_byte(cmd, cmd->SCp.Status);
+			set_msg_byte(cmd, cmd->SCp.Message);
+		}
 		cmd->scsi_done(cmd);
 
 /* We are no longer connected to a target - check to see if
@@ -1297,12 +1299,11 @@ wd33c93_intr(struct Scsi_Host *instance)
 			DB(DB_INTR, printk(":%d", cmd->SCp.Status))
 			    if (cmd->cmnd[0] == REQUEST_SENSE
 				&& cmd->SCp.Status != SAM_STAT_GOOD)
-				cmd->result =
-				    (cmd->
-				     result & 0x00ffff) | (DID_ERROR << 16);
-			else
-				cmd->result =
-				    cmd->SCp.Status | (cmd->SCp.Message << 8);
+				    set_host_byte(cmd, DID_ERROR);
+			    else {
+				    set_status_byte(cmd, cmd->SCp.Status);
+				    set_msg_byte(cmd, cmd->SCp.Message);
+			    }
 			cmd->scsi_done(cmd);
 			break;
 		case S_PRE_TMP_DISC:
@@ -1593,7 +1594,7 @@ wd33c93_host_reset(struct scsi_cmnd * SCpnt)
 	hostdata->outgoing_len = 0;
 
 	reset_wd33c93(instance);
-	SCpnt->result = DID_RESET << 16;
+	set_host_byte(SCpnt, DID_RESET);
 	enable_irq(instance->irq);
 	spin_unlock_irq(instance->host_lock);
 	return SUCCESS;
@@ -1628,7 +1629,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 				hostdata->input_Q =
 				    (struct scsi_cmnd *) cmd->host_scribble;
 			cmd->host_scribble = NULL;
-			cmd->result = DID_ABORT << 16;
+			set_host_byte(cmd, DID_ABORT);
 			printk
 			    ("scsi%d: Abort - removing command from input_Q. ",
 			     instance->host_no);
@@ -1702,7 +1703,7 @@ wd33c93_abort(struct scsi_cmnd * cmd)
 		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 		hostdata->connected = NULL;
 		hostdata->state = S_UNCONNECTED;
-		cmd->result = DID_ABORT << 16;
+		set_host_byte(cmd, DID_ABORT);
 
 /*      sti();*/
 		wd33c93_execute(instance);
-- 
2.29.2

