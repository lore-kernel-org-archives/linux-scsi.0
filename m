Return-Path: <SRS0=SaCo=ZM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D06FC43215
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 10:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21B802243E
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Nov 2019 10:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfKTKbb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Nov 2019 05:31:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:49322 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728709AbfKTKba (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Nov 2019 05:31:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BD73CB40C;
        Wed, 20 Nov 2019 10:31:28 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Balsundar P <balsundar.p@microsemi.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Subject: [PATCH 08/11] aacraid: use scsi_host_quiesce() to wait for I/O to complete
Date:   Wed, 20 Nov 2019 11:31:11 +0100
Message-Id: <20191120103114.24723-9-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191120103114.24723-1-hare@suse.de>
References: <20191120103114.24723-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of waiting for all I/O to complete by monitoring the
request tags we can as well call scsi_host_quiesce() and drop
the hand-crafted helpers.

Cc: Balsundar P <balsundar.p@microsemi.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/aacraid/comminit.c | 35 ++---------------------------------
 1 file changed, 2 insertions(+), 33 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index f75878d773cf..a01dca86eb37 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -272,38 +272,6 @@ static void aac_queue_init(struct aac_dev * dev, struct aac_queue * q, u32 *mem,
 	q->entries = qsize;
 }
 
-static void aac_wait_for_io_completion(struct aac_dev *aac)
-{
-	unsigned long flagv = 0;
-	int i = 0;
-
-	for (i = 60; i; --i) {
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
-
-		}
-		/*
-		 * We can exit If all the commands are complete
-		 */
-		if (active == 0)
-			break;
-		ssleep(1);
-	}
-}
-
 /**
  *	aac_send_shutdown		-	shutdown an adapter
  *	@dev: Adapter to shutdown
@@ -326,7 +294,7 @@ int aac_send_shutdown(struct aac_dev * dev)
 		mutex_unlock(&dev->ioctl_mutex);
 	}
 
-	aac_wait_for_io_completion(dev);
+	scsi_host_quiesce(dev->scsi_host_ptr);
 
 	fibctx = aac_fib_alloc(dev);
 	if (!fibctx)
@@ -352,6 +320,7 @@ int aac_send_shutdown(struct aac_dev * dev)
 	if (aac_is_src(dev) &&
 	     dev->msi_enabled)
 		aac_set_intx_mode(dev);
+	scsi_host_resume(dev->scsi_host_ptr);
 	return status;
 }
 
-- 
2.16.4

