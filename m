Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A58DDC3B18B
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 14:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73281222C2
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 14:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730192AbgBMOFc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 09:05:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:46228 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730079AbgBMOF3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 09:05:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6E7E9AF8C;
        Thu, 13 Feb 2020 14:05:27 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/13] aacraid: use scsi_host_complete_all_commands() to terminate outstanding commands
Date:   Thu, 13 Feb 2020 15:04:14 +0100
Message-Id: <20200213140422.128382-6-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200213140422.128382-1-hare@suse.de>
References: <20200213140422.128382-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use scsi_host_complete_all_commands() to terminate all outstanding commands
instead, and change the command result for terminated commands to
the more common 'DID_RESET' instead of 'QUEUE_FULL'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Balsundar P <balsundar.p@microchip.com>
---
 drivers/scsi/aacraid/commsup.c | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 5a8a999606ea..8736a540a048 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1478,8 +1478,6 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	int retval;
 	struct Scsi_Host *host;
 	struct scsi_device *dev;
-	struct scsi_cmnd *command;
-	struct scsi_cmnd *command_list;
 	int jafo = 0;
 	int bled;
 	u64 dmamask;
@@ -1607,26 +1605,8 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 * This is where the assumption that the Adapter is quiesced
 	 * is important.
 	 */
-	command_list = NULL;
-	__shost_for_each_device(dev, host) {
-		unsigned long flags;
-		spin_lock_irqsave(&dev->list_lock, flags);
-		list_for_each_entry(command, &dev->cmd_list, list)
-			if (command->SCp.phase == AAC_OWNER_FIRMWARE) {
-				command->SCp.buffer = (struct scatterlist *)command_list;
-				command_list = command;
-			}
-		spin_unlock_irqrestore(&dev->list_lock, flags);
-	}
-	while ((command = command_list)) {
-		command_list = (struct scsi_cmnd *)command->SCp.buffer;
-		command->SCp.buffer = NULL;
-		command->result = DID_OK << 16
-		  | COMMAND_COMPLETE << 8
-		  | SAM_STAT_TASK_SET_FULL;
-		command->SCp.phase = AAC_OWNER_ERROR_HANDLER;
-		command->scsi_done(command);
-	}
+	scsi_host_complete_all_commands(host, DID_RESET);
+
 	/*
 	 * Any Device that was already marked offline needs to be marked
 	 * running
-- 
2.16.4

