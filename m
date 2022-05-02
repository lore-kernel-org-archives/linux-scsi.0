Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD084C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:54:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387778AbiEBV6M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387807AbiEBV5y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:57:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD8AFD1E
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:54:24 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id B31011F898;
        Mon,  2 May 2022 21:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651528460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2d8LJL3Vp30/OmWmdxHDLXE94qU4q5I/myWf8eq0bM=;
        b=ABULQIuFctWdQXSQTZ3ug3gYSlaMxgTaEdZ/FLNBHxH/uX3rZ4+5+zaFKUCTD6p5ht5Dbf
        UR6QNcw+rhPbBRxks4iw4UnqbnXkUj2WevDFveZJhnxcH8Lbe4YjM/QXh0Urdyd0DfuW4z
        AdFhY1bsvLXsQh/jswWZPmJmeHZistY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651528460;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p2d8LJL3Vp30/OmWmdxHDLXE94qU4q5I/myWf8eq0bM=;
        b=zQ8mJYB6FIbyFH/12zNhykiMGFpfaKa7WSFyeStxLBCEmokCqvJKwhEgJwFV6T4Ihuy78J
        1RHmv7Q0+5ZrflBQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id A8CE92C152;
        Mon,  2 May 2022 21:54:20 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id A1A7E519413A; Mon,  2 May 2022 23:54:20 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 10/11] fas216: Rework device reset to not rely on SCSI command pointer
Date:   Mon,  2 May 2022 23:54:15 +0200
Message-Id: <20220502215416.5351-11-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502215416.5351-1-hare@suse.de>
References: <20220502215416.5351-1-hare@suse.de>
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
index 4ce0b2d73614..e6289c6af5ef 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -1985,7 +1985,6 @@ static void fas216_devicereset_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 {
 	fas216_log(info, LOG_ERROR, "fas216 device reset complete");
 
-	info->rstSCpnt = NULL;
 	info->rst_dev_status = 1;
 	wake_up(&info->eh_wait);
 }
@@ -2143,12 +2142,12 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 
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
@@ -2160,7 +2159,7 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
 	 * Sanity check the completion - if we have zero bytes left
 	 * to transfer, we should not have a valid pointer.
 	 */
-	if (info->scsi.SCp.ptr && info->scsi.SCp.this_residual == 0) {
+	if (SCpnt && info->scsi.SCp.ptr && info->scsi.SCp.this_residual == 0) {
 		scmd_printk(KERN_INFO, SCpnt,
 			    "zero bytes left to transfer, but buffer pointer still valid: ptr=%p len=%08x\n",
 			    info->scsi.SCp.ptr, info->scsi.SCp.this_residual);
@@ -2173,12 +2172,18 @@ static void fas216_done(FAS216_Info *info, unsigned int result)
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
@@ -2478,9 +2483,10 @@ int fas216_eh_abort(struct scsi_cmnd *SCpnt)
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
 
@@ -2494,7 +2500,7 @@ int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
 		 * and we need a bus reset.
 		 */
 		if (info->SCpnt && !info->scsi.disconnectable &&
-		    info->SCpnt->device->id == SCpnt->device->id)
+		    info->SCpnt->device->id == sdev->id)
 			break;
 
 		/*
@@ -2512,14 +2518,7 @@ int fas216_eh_device_reset(struct scsi_cmnd *SCpnt)
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

