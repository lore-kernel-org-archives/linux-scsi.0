From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 3/8] mpt fusion: config, Taskmgmt cmd, Internal cmd, Ioctl cmd changes
Date: Thu, 26 Feb 2009 12:32:12 +0530
Message-ID: <20090226070206.GD26209@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og103.obsmtp.com ([64.18.2.159]:33126 "EHLO
	exprod7og103.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZBZHYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Feb 2009 02:24:09 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Sathya.Prakash@lsi.com, eric.moore@lsi.com


1.) mpt_timer_expired is removed.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 7df505a..e7050a1 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -6225,32 +6225,6 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS *pCfg)
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
- *	mpt_timer_expired - Callback for timer process.
- *	Used only internal config functionality.
- *	@data: Pointer to MPT_SCSI_HOST recast as an unsigned long
- */
-static void
-mpt_timer_expired(unsigned long data)
-{
-	MPT_ADAPTER *ioc = (MPT_ADAPTER *) data;
-
-	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_timer_expired! \n", ioc->name));
-
-	/* Perform a FW reload */
-	if (mpt_HardResetHandler(ioc, NO_SLEEP) < 0)
-		printk(MYIOC_s_WARN_FMT "Firmware Reload FAILED!\n", ioc->name);
-
-	/* No more processing.
-	 * Hard reset clean-up will wake up
-	 * process and free all resources.
-	 */
-	dcprintk(ioc, printk(MYIOC_s_DEBUG_FMT "mpt_timer_expired complete!\n", ioc->name));
-
-	return;
-}
-
-/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
-/**
  *	mpt_ioc_reset - Base cleanup for hard reset
  *	@ioc: Pointer to the adapter structure
  *	@reset_phase: Indicates pre- or post-reset functionality
