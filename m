Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B7E7C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12E0C6140D
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 17:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245012AbhDURu7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 13:50:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:52390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245072AbhDURtN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Apr 2021 13:49:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D7D32B2E3;
        Wed, 21 Apr 2021 17:48:01 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/42] wd33c93: translate message byte to host byte
Date:   Wed, 21 Apr 2021 19:47:34 +0200
Message-Id: <20210421174749.11221-28-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
References: <20210421174749.11221-1-hare@suse.de>
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
 drivers/scsi/wd33c93.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index 0a5bb238f001..e886e17fbf45 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1168,7 +1168,6 @@ wd33c93_intr(struct Scsi_Host *instance)
 		write_wd33c93(regs, WD_SOURCE_ID, SRCID_ER);
 		if (phs == 0x60) {
 			DB(DB_INTR, printk("SX-DONE"))
-			    cmd->SCp.Message = COMMAND_COMPLETE;
 			lun = read_wd33c93(regs, WD_TARGET_LUN);
 			DB(DB_INTR, printk(":%d.%d", cmd->SCp.Status, lun))
 			    hostdata->connected = NULL;
@@ -1180,8 +1179,8 @@ wd33c93_intr(struct Scsi_Host *instance)
 			    && cmd->SCp.Status != SAM_STAT_GOOD)
 				set_host_byte(cmd, DID_ERROR);
 			else {
+				set_host_byte(cmd, DID_OK);
 				set_status_byte(cmd, cmd->SCp.Status);
-				set_msg_byte(cmd, cmd->SCp.Message);
 			}
 			cmd->scsi_done(cmd);
 
@@ -1266,8 +1265,9 @@ wd33c93_intr(struct Scsi_Host *instance)
 		    cmd->SCp.Status != SAM_STAT_GOOD)
 			set_host_byte(cmd, DID_ERROR);
 		else {
+			set_host_byte(cmd, DID_OK);
+			translate_msg_byte(cmd, cmd->SCp.Message);
 			set_status_byte(cmd, cmd->SCp.Status);
-			set_msg_byte(cmd, cmd->SCp.Message);
 		}
 		cmd->scsi_done(cmd);
 
@@ -1301,8 +1301,9 @@ wd33c93_intr(struct Scsi_Host *instance)
 				&& cmd->SCp.Status != SAM_STAT_GOOD)
 				    set_host_byte(cmd, DID_ERROR);
 			    else {
+				    set_host_byte(cmd, DID_OK);
+				    translate_msg_byte(cmd, cmd->SCp.Message);
 				    set_status_byte(cmd, cmd->SCp.Status);
-				    set_msg_byte(cmd, cmd->SCp.Message);
 			    }
 			cmd->scsi_done(cmd);
 			break;
-- 
2.29.2

