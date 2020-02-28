Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E38EAC3F2D1
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 07:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA1092467B
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 07:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgB1Hx2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 02:53:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:59830 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727002AbgB1HxY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 02:53:24 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6108BB21D;
        Fri, 28 Feb 2020 07:53:21 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/13] aacraid: use scsi_host_busy_iter() to wait for outstanding commands
Date:   Fri, 28 Feb 2020 08:53:16 +0100
Message-Id: <20200228075318.91255-12-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200228075318.91255-1-hare@suse.de>
References: <20200228075318.91255-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of traversing the list of possible commands by hands we
should be using scsi_host_busy_iter() to figure out if there are
outstanding commands.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Acked-by: Balsundar P < Balsundar.P@microchip.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/aacraid/comminit.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index f75878d773cf..355b16f0b145 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -272,36 +272,35 @@ static void aac_queue_init(struct aac_dev * dev, struct aac_queue * q, u32 *mem,
 	q->entries = qsize;
 }
 
+static bool wait_for_io_iter(struct scsi_cmnd *cmd, void *data, bool rsvd)
+{
+	int *active = data;
+
+	if (cmd->SCp.phase == AAC_OWNER_FIRMWARE)
+		*active = *active + 1;
+	return true;
+}
 static void aac_wait_for_io_completion(struct aac_dev *aac)
 {
-	unsigned long flagv = 0;
-	int i = 0;
+	int i = 0, active;
 
 	for (i = 60; i; --i) {
-		struct scsi_device *dev;
-		struct scsi_cmnd *command;
-		int active = 0;
-
-		__shost_for_each_device(dev, aac->scsi_host_ptr) {
-			spin_lock_irqsave(&dev->list_lock, flagv);
-			list_for_each_entry(command, &dev->cmd_list, list) {
-				if (command->SCp.phase == AAC_OWNER_FIRMWARE) {
-					active++;
-					break;
-				}
-			}
-			spin_unlock_irqrestore(&dev->list_lock, flagv);
-			if (active)
-				break;
 
-		}
+		active = 0;
+		scsi_host_busy_iter(aac->scsi_host_ptr,
+				    wait_for_io_iter, &active);
 		/*
 		 * We can exit If all the commands are complete
 		 */
 		if (active == 0)
 			break;
+		dev_info(&aac->pdev->dev,
+			 "Wait for %d commands to complete\n", active);
 		ssleep(1);
 	}
+	if (active)
+		dev_err(&aac->pdev->dev,
+			"%d outstanding commands during shutdown\n", active);
 }
 
 /**
-- 
2.16.4

