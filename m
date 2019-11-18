Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF820C33C99
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C832073A
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:22:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfKRJWe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 04:22:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:54664 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726795AbfKRJWd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Nov 2019 04:22:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4073BB1E5;
        Mon, 18 Nov 2019 09:22:31 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Balsundar P <balsundar.p@microsemi.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH 7/9] aacraid: use scsi_host_busy_iter() in aac_wait_for_io_completion()
Date:   Mon, 18 Nov 2019 10:22:06 +0100
Message-Id: <20191118092208.54521-8-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191118092208.54521-1-hare@suse.de>
References: <20191118092208.54521-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the midlayer helper function to traverse outstanding commands.

Cc: Balsundar P <balsundar.p@microsemi.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/comminit.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index f75878d773cf..89c0ca339ef5 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -272,29 +272,25 @@ static void aac_queue_init(struct aac_dev * dev, struct aac_queue * q, u32 *mem,
 	q->entries = qsize;
 }
 
+static bool wait_for_io_iter(struct scsi_cmnd *cmd, void *data, bool reserved)
+{
+	int *active = data;
+
+	if (cmd->SCp.phase == AAC_OWNER_FIRMWARE)
+		*active = 1;
+	return true;
+}
+
+/* scsi_block_requests() has been called, so no new request can be issued */
 static void aac_wait_for_io_completion(struct aac_dev *aac)
 {
-	unsigned long flagv = 0;
-	int i = 0;
+	int i;
 
 	for (i = 60; i; --i) {
-		struct scsi_device *dev;
-		struct scsi_cmnd *command;
 		int active = 0;
 
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
-
-		}
+		scsi_host_busy_iter(aac->scsi_host_ptr,
+				    wait_for_io_iter, &active);
 		/*
 		 * We can exit If all the commands are complete
 		 */
-- 
2.16.4

