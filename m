From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill FusionInitCalled
Date: Sat, 2 Oct 2004 10:11:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041002081148.GA13609@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37277 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267345AbUJBIMC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Oct 2004 04:12:02 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Emoore@lsil.com
Cc: linux-scsi@vger.kernel.org

the scsi early init problem is long gone, so no need to work around it
anymore.


--- 1.33/drivers/message/fusion/mptbase.c	2004-09-29 04:47:31 +02:00
+++ edited/drivers/message/fusion/mptbase.c	2004-10-01 12:02:37 +02:00
@@ -155,7 +155,6 @@
 static MPT_RESETHANDLER		 MptResetHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 static struct mpt_pci_driver 	*MptDeviceDriverHandlers[MPT_MAX_PROTOCOL_DRIVERS];
 
-static int	FusionInitCalled = 0;
 static int	mpt_base_index = -1;
 static int	last_drv_idx = -1;
 
@@ -603,22 +602,6 @@
 
 	last_drv_idx = -1;
 
-#ifndef MODULE
-	/*
-	 *  Handle possibility of the mptscsih_detect() routine getting
-	 *  called *before* fusion_init!
-	 */
-	if (!FusionInitCalled) {
-		dprintk((KERN_INFO MYNAM ": Hmmm, calling fusion_init from mpt_register!\n"));
-		/*
-		 *  NOTE! We'll get recursion here, as fusion_init()
-		 *  calls mpt_register()!
-		 */
-		fusion_init();
-		FusionInitCalled++;
-	}
-#endif
-
 	/*
 	 *  Search for empty callback slot in this order: {N,...,7,6,5,...,1}
 	 *  (slot/handle 0 is reserved!)
@@ -5933,11 +5916,6 @@
 {
 	int i;
 	int r;
-
-	if (FusionInitCalled++) {
-		dprintk((KERN_INFO MYNAM ": INFO - Driver late-init entry point called\n"));
-		return 0;
-	}
 
 	show_mptmod_ver(my_NAME, my_VERSION);
 	printk(KERN_INFO COPYRIGHT "\n");
===== drivers/message/fusion/mptscsih.c 1.50 vs edited =====
