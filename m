Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE48C56201
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 04:51:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99D5C223AC
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 04:51:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgKTEvj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 23:51:39 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52650 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbgKTEvg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 23:51:36 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id A38082A451; Thu, 19 Nov 2020 23:51:35 -0500 (EST)
To:     Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <af25163257796b50bb99d4ede4025cea55787b8f.1605847196.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] scsi/atari_scsi: Fix race condition between .queuecommand and
 EH
Date:   Fri, 20 Nov 2020 15:39:56 +1100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is possible that bus_reset_cleanup() or .eh_abort_handler could
be invoked during NCR5380_queuecommand(). If that takes place before
the new command is enqueued and after the ST-DMA "lock" has been
acquired, the ST-DMA "lock" will be released again. This will result
in a lost DMA interrupt and a command timeout. Fix this by excluding
EH and interrupt handlers while the new command is enqueued.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
Michael, would you please send your Acked-by or Reviewed-and-tested-by?
These two patches taken together should be equivalent to the one you tested
recently. I've split it into two as that seemed to make more sense.
---
 drivers/scsi/NCR5380.c    |  9 ++++++---
 drivers/scsi/atari_scsi.c | 10 +++-------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index d654a6cc4162..ea4b5749e7da 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -580,11 +580,14 @@ static int NCR5380_queue_command(struct Scsi_Host *instance,
 
 	cmd->result = 0;
 
-	if (!NCR5380_acquire_dma_irq(instance))
-		return SCSI_MLQUEUE_HOST_BUSY;
-
 	spin_lock_irqsave(&hostdata->lock, flags);
 
+	if (!NCR5380_acquire_dma_irq(instance)) {
+		spin_unlock_irqrestore(&hostdata->lock, flags);
+
+		return SCSI_MLQUEUE_HOST_BUSY;
+	}
+
 	/*
 	 * Insert the cmd into the issue queue. Note that REQUEST SENSE
 	 * commands are added to the head of the queue since any command will
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index a82b63a66635..95d7a3586083 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -376,15 +376,11 @@ static int falcon_get_lock(struct Scsi_Host *instance)
 	if (IS_A_TT())
 		return 1;
 
-	if (stdma_is_locked_by(scsi_falcon_intr) &&
-	    instance->hostt->can_queue > 1)
+	if (stdma_is_locked_by(scsi_falcon_intr))
 		return 1;
 
-	if (in_interrupt())
-		return stdma_try_lock(scsi_falcon_intr, instance);
-
-	stdma_lock(scsi_falcon_intr, instance);
-	return 1;
+	/* stdma_lock() may sleep which means it can't be used here */
+	return stdma_try_lock(scsi_falcon_intr, instance);
 }
 
 #ifndef MODULE
-- 
2.26.2

