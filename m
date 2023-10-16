Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F43CDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 09:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbjJPJZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 05:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbjJPJYv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 05:24:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BC2ED
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 02:24:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AD8B221C47;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 190312CB4C;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CF17E51EBDC9; Mon, 16 Oct 2023 11:24:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 06/17] fas216: Rework device reset to not rely on SCSI command pointer
Date:   Mon, 16 Oct 2023 11:24:19 +0200
Message-Id: <20231016092430.55557-7-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231016092430.55557-1-hare@suse.de>
References: <20231016092430.55557-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++++
Authentication-Results: smtp-out1.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out1.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [8.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[5];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_SPAM_LONG(3.00)[1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-3.00)[100.00%]
X-Rspamd-Queue-Id: AD8B221C47
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The device reset code should not rely on the SCSI command pointer;
it will be going away with the device reset handler rework.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
2.35.3

