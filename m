From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 6/24] mpt fusion: [2.6.30-rc6] mpt_timer_expired is removed.
Date: Fri, 22 May 2009 16:13:29 +0530
Message-ID: <20090522104329.GH16245@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:33611 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591AbZEVLE2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 07:04:28 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


1.) mpt_timer_expired is removed.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index 0d3fc0a..e63a626 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -6229,32 +6229,6 @@ out:
 
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
