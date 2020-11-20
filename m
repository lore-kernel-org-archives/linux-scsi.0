Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCE5C64E8A
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 04:52:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DA0D223C6
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Nov 2020 04:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbgKTEvi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Nov 2020 23:51:38 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52672 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgKTEvg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Nov 2020 23:51:36 -0500
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id BE34E2A452; Thu, 19 Nov 2020 23:51:35 -0500 (EST)
To:     Michael Schmitz <schmitzmic@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <c1317ae8fdcb498460de5d7ea0bd62a42f5eeca8.1605847196.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] scsi/NCR5380: Reduce NCR5380_maybe_release_dma_irq() call
 sites
Date:   Fri, 20 Nov 2020 15:39:56 +1100
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Refactor to avoid needless calls to NCR5380_maybe_release_dma_irq().
This makes the machine code smaller and the source more readable.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/NCR5380.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index ea4b5749e7da..d597d7493a62 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -725,7 +725,6 @@ static void NCR5380_main(struct work_struct *work)
 
 			if (!NCR5380_select(instance, cmd)) {
 				dsprintk(NDEBUG_MAIN, instance, "main: select complete\n");
-				maybe_release_dma_irq(instance);
 			} else {
 				dsprintk(NDEBUG_MAIN | NDEBUG_QUEUES, instance,
 				         "main: select failed, returning %p to queue\n", cmd);
@@ -737,8 +736,10 @@ static void NCR5380_main(struct work_struct *work)
 			NCR5380_information_transfer(instance);
 			done = 0;
 		}
-		if (!hostdata->connected)
+		if (!hostdata->connected) {
 			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
+			maybe_release_dma_irq(instance);
+		}
 		spin_unlock_irq(&hostdata->lock);
 		if (!done)
 			cond_resched();
@@ -1844,7 +1845,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					 */
 					NCR5380_write(TARGET_COMMAND_REG, 0);
 
-					maybe_release_dma_irq(instance);
 					return;
 				case MESSAGE_REJECT:
 					/* Accept message by clearing ACK */
@@ -1976,7 +1976,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					hostdata->busy[scmd_id(cmd)] &= ~(1 << cmd->device->lun);
 					cmd->result = DID_ERROR << 16;
 					complete_cmd(instance, cmd);
-					maybe_release_dma_irq(instance);
 					return;
 				}
 				msgout = NOP;
@@ -2312,7 +2311,6 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
 	}
 
 	queue_work(hostdata->work_q, &hostdata->main_task);
-	maybe_release_dma_irq(instance);
 	spin_unlock_irqrestore(&hostdata->lock, flags);
 
 	return result;
@@ -2368,7 +2366,6 @@ static void bus_reset_cleanup(struct Scsi_Host *instance)
 	hostdata->dma_len = 0;
 
 	queue_work(hostdata->work_q, &hostdata->main_task);
-	maybe_release_dma_irq(instance);
 }
 
 /**
-- 
2.26.2

