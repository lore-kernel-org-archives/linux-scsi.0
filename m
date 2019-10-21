Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FD5CA9EB7
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 09:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A118E2070B
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 09:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727892AbfJUJxb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 05:53:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:48794 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727867AbfJUJxa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 05:53:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A3244BA7C;
        Mon, 21 Oct 2019 09:53:28 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/24] wd33c93: use SCSI status
Date:   Mon, 21 Oct 2019 11:53:01 +0200
Message-Id: <20191021095322.137969-4-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191021095322.137969-1-hare@suse.de>
References: <20191021095322.137969-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use standard SCSI status and drop usage of the linux-specific ones.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/wd33c93.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
index f81046f0e68a..98e04a7b9d63 100644
--- a/drivers/scsi/wd33c93.c
+++ b/drivers/scsi/wd33c93.c
@@ -1176,10 +1176,8 @@ wd33c93_intr(struct Scsi_Host *instance)
 			if (cmd->SCp.Status == ILLEGAL_STATUS_BYTE)
 				cmd->SCp.Status = lun;
 			if (cmd->cmnd[0] == REQUEST_SENSE
-			    && cmd->SCp.Status != GOOD)
-				cmd->result =
-				    (cmd->
-				     result & 0x00ffff) | (DID_ERROR << 16);
+			    && cmd->SCp.Status != SAM_STAT_GOOD)
+				set_host_byte(cmd, DID_ERROR);
 			else
 				cmd->result =
 				    cmd->SCp.Status | (cmd->SCp.Message << 8);
@@ -1262,9 +1260,8 @@ wd33c93_intr(struct Scsi_Host *instance)
 		    hostdata->connected = NULL;
 		hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 		hostdata->state = S_UNCONNECTED;
-		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != GOOD)
-			cmd->result =
-			    (cmd->result & 0x00ffff) | (DID_ERROR << 16);
+		if (cmd->cmnd[0] == REQUEST_SENSE && cmd->SCp.Status != SAM_STAT_GOOD)
+			set_host_byte(cmd, DID_ERROR);
 		else
 			cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
 		cmd->scsi_done(cmd);
@@ -1294,12 +1291,10 @@ wd33c93_intr(struct Scsi_Host *instance)
 			hostdata->connected = NULL;
 			hostdata->busy[cmd->device->id] &= ~(1 << (cmd->device->lun & 0xff));
 			hostdata->state = S_UNCONNECTED;
-			DB(DB_INTR, printk(":%d", cmd->SCp.Status))
-			    if (cmd->cmnd[0] == REQUEST_SENSE
-				&& cmd->SCp.Status != GOOD)
-				cmd->result =
-				    (cmd->
-				     result & 0x00ffff) | (DID_ERROR << 16);
+			DB(DB_INTR, printk(":%d", cmd->SCp.Status));
+			if (cmd->cmnd[0] == REQUEST_SENSE
+			    && cmd->SCp.Status != SAM_STAT_GOOD)
+				set_host_byte(cmd->result, DID_ERROR);
 			else
 				cmd->result =
 				    cmd->SCp.Status | (cmd->SCp.Message << 8);
-- 
2.16.4

