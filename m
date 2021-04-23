Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F42C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68F7D61139
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Apr 2021 11:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242390AbhDWLlB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Apr 2021 07:41:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:47184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242270AbhDWLkl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Apr 2021 07:40:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 895DAB1D5;
        Fri, 23 Apr 2021 11:39:55 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 24/39] wd33c93: translate message byte to host byte
Date:   Fri, 23 Apr 2021 13:39:29 +0200
Message-Id: <20210423113944.42672-25-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210423113944.42672-1-hare@suse.de>
References: <20210423113944.42672-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of setting the message byte translate it to the appropriate
host byte. As error recovery would return DID_ERROR for any non-zero
message byte the translation doesn't change the error handling.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/wd33c93.c | 46 ++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index a23277bb870e..187b363db00e 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1176,13 +1176,14 @@ wd33c93_intr(struct Scsi_Host *instance)
 			if (cmd->SCp.Status == ILLEGAL_STATUS_BYTE)
 				cmd->SCp.Status = lun;
 			if (cmd->cmnd[0] == REQUEST_SENSE
-			    && cmd->SCp.Status != SAM_STAT_GOOD)
-				cmd->result =
-				    (cmd->
-				     result & 0x00ffff) | (DID_ERROR << 16);
-			else
-				cmd->result =
-				    cmd->SCp.Status | (cmd->SCp.Message << 8);
+			    && cmd->SCp.Status != SAM_STAT_GOOD) {
+				set_host_byte(cmd, DID_ERROR);
+				set_status_byte(cmd, SAM_STAT_GOOD);
+			} else {
+				set_host_byte(cmd, DID_OK);
+				translate_msg_byte(cmd, cmd->SCp.Message);
+				set_status_byte(cmd, cmd->SCp.Status);
+			}
 			cmd->scsi_done(cmd);
 
 /* We are no longer  connected to a target - check to see if
@@ -1262,11 +1263,15 @@ wd33c93_intr(struct Scsi_Host *instance)
 		    hostdata->connected = NULL;
 		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 		hostdata->state = S_UNCONNECTED;
-		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != SAM_STAT_GOOD)
-			cmd->result =
-			    (cmd->result & 0x00ffff) | (DID_ERROR << 16);
-		else
-			cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
+		if (cmd->cmnd[0] == REQUEST_SENSE &&
+		    cmd->SCp.Status != SAM_STAT_GOOD) {
+			set_host_byte(cmd, DID_ERROR);
+			set_status_byte(cmd, SAM_STAT_GOOD);
+		} else {
+			set_host_byte(cmd, DID_OK);
+			translate_msg_byte(cmd, cmd->SCp.Message);
+			set_status_byte(cmd, cmd->SCp.Status);
+		}
 		cmd->scsi_done(cmd);
 
 /* We are no longer connected to a target - check to see if
@@ -1295,14 +1300,15 @@ wd33c93_intr(struct Scsi_Host *instance)
 			hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 			hostdata->state = S_UNCONNECTED;
 			DB(DB_INTR, printk(":%d", cmd->SCp.Status))
-			    if (cmd->cmnd[0] == REQUEST_SENSE
-				&& cmd->SCp.Status != SAM_STAT_GOOD)
-				cmd->result =
-				    (cmd->
-				     result & 0x00ffff) | (DID_ERROR << 16);
-			else
-				cmd->result =
-				    cmd->SCp.Status | (cmd->SCp.Message << 8);
+			if (cmd->cmnd[0] == REQUEST_SENSE
+			    && cmd->SCp.Status != SAM_STAT_GOOD) {
+				set_host_byte(cmd, DID_ERROR);
+				set_status_byte(cmd, SAM_STAT_GOOD);
+			} else {
+				set_host_byte(cmd, DID_OK);
+				translate_msg_byte(cmd, cmd->SCp.Message);
+				set_status_byte(cmd, cmd->SCp.Status);
+			}
 			cmd->scsi_done(cmd);
 			break;
 		case S_PRE_TMP_DISC:
-- 
2.29.2

