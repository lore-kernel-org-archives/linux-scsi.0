From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 5/22] mpt fusion: RESEND [2.6.30-rc6] mpt_timer_expired is removed.
Date: Wed, 27 May 2009 17:52:58 +0530
Message-ID: <20090527122253.GF20010@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og111.obsmtp.com ([64.18.2.175]:59739 "EHLO
	exprod7og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759354AbZE0M4q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 May 2009 08:56:46 -0400
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
