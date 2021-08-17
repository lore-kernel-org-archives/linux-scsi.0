Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0219AC4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFD3360FA0
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:17:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239855AbhHQJSA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:18:00 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33374 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239478AbhHQJRT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:19 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C448821D94;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191802; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=62DbAeL6E9OpiRbBzPXF4p/G/dd/IQPP352bnvG02Os=;
        b=zKFX+RZJK6QJMRZ60trsMwK/Lbzu3iplwSp4YGy9TTitc7xoBtg23OjR7yRGTCWBoxZGgU
        W8NaFK94f8TiaGxB05PerECJn4baDf+TKJUd34/T7Abh0++I0gK7fumySwmCid7gHvar7e
        ybPPiPPkTtrnJqi6BZ3JYyCmMCyvKSc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191802;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=62DbAeL6E9OpiRbBzPXF4p/G/dd/IQPP352bnvG02Os=;
        b=RXfrhkE+rqBQP4GBFcBs6n3DGZSRnomfRz3CusM0d6ra5IEM3fvz1cbaJ63Rdiu1U3wOk6
        5z4JKXjC3beLuVDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id BDE26A3BBB;
        Tue, 17 Aug 2021 09:16:42 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id BAD89518CEB9; Tue, 17 Aug 2021 11:16:42 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 45/51] fas216: Rework device reset to not rely on SCSI command pointer
Date:   Tue, 17 Aug 2021 11:14:50 +0200
Message-Id: <20210817091456.73342-46-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The device reset code should not rely on the SCSI command pointer;
it will be going away with the device reset handler rework.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/arm/fas216.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index 4f17b24a291f..e08aa01006ea 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -1990,7 +1990,6 @@ static void fas216_devicereset_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 {
 	fas216_log(info, LOG_ERROR, "fas216 device reset complete");
 
-	info->rstSCpnt = NULL;
 	info->rst_dev_status = 1;
 	wake_up(&info->eh_wait);
 }
@@ -2145,12 +2144,12 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 
 	fas216_checkmagic(info);
 
-	if (!info->SCpnt)
+	if (!info->SCpnt && info->rst_dev_status)
 		goto no_command;
 
 	SCpnt = info->SCpnt;
 	info->SCpnt = NULL;
-    	info->scsi.phase = PHASE_IDLE;
+	info->scsi.phase = PHASE_IDLE;
 
 	if (info->scsi.aborting) {
 		fas216_log(info, 0, "uncaught abort - returning DID_ABORT");
@@ -2162,7 +2161,7 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 	 * Sanity check the completion - if we have zero bytes left
 	 * to transfer, we should not have a valid pointer.
 	 */
-	if (info->scsi.SCp.ptr && info->scsi.SCp.this_residual == 0) {
+	if (SCpnt && info->scsi.SCp.ptr && info->scsi.SCp.this_residual == 0) {
 		scmd_printk(KERN_INFO, SCpnt,
 			    "zero bytes left to transfer, but buffer pointer still valid: ptr=%p len=%08x\n",
 			    info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
@@ -2175,12 +2174,18 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 	 * the sense information, fas216_kick will re-assert the busy
 	 * status.
 	 */
-	info->device[SCpnt->device->id].parity_check = 0;
-	clear_bit(SCpnt->device->id * 8 +
-		  (u8)(SCpnt->device->lun & 0x7), info->busyluns);
-
-	fn = (void (*)(FAS216_Info *, struct scsi_cmnd *, unsigned int))SCpnt->host_scribble;
-	fn(info, SCpnt, result);
+	if (SCpnt) {
+		info->device[SCpnt->device->id].parity_check = 0;
+		clear_bit(SCpnt->device->id * 8 +
+			  (u8)(SCpnt->device->lun & 0x7), info->busyluns);
+	}
+	if (!info->rst_dev_status) {
+		info->rst_dev_status = 1;
+		wake_up(&info->eh_wait);
+	} else {
+		fn = (void (*)(FAS216_Info *, struct scsi_cmnd *, unsigned int))SCpnt->host_scribble;
+		fn(info, SCpnt, result);
+	}
 
 	if (info->scsi.irq) {
 		spin_lock_irqsave(&info->host_lock, flags);
@@ -2477,9 +2482,10 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
  */
 int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
 {
-	FAS216_Info *info = (FAS216_Info *)SCpnt->device->host->hostdata;
+	struct scsi_device *sdev = SCpnt->device;
+	FAS216_Info *info = (FAS216_Info *)sdev->host->hostdata;
 	unsigned long flags;
-	int i, res = FAILED, target = SCpnt->device->id;
+	int i, res = FAILED, target = sdev->id;
 
 	fas216_log(info, LOG_ERROR, "device reset for target %d", target);
 
@@ -2493,7 +2499,7 @@ int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
 		 * and we need a bus reset.
 		 */
 		if (info->SCpnt && !info->scsi.disconnectable &&
-		    info->SCpnt->device->id == SCpnt->device->id)
+		    info->SCpnt->device->id == sdev->id)
 			break;
 
 		/*
@@ -2511,14 +2517,7 @@ int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
 		for (i = 0; i < 8; i++)
 			clear_bit(target * 8 + i, info->busyluns);
 
-		/*
-		 * Hijack this SCSI command structure to send
-		 * a bus device reset message to this device.
-		 */
-		SCpnt->host_scribble = (void *)fas216_devicereset_done;
-
 		info->rst_dev_status = 0;
-		info->rstSCpnt = SCpnt;
 
 		if (info->scsi.phase == PHASE_IDLE)
 			fas216_kick(info);
-- 
2.29.2

