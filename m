From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI t128.c: remove an unused function
Date: Mon, 15 Nov 2004 03:38:59 +0100
Message-ID: <20041115023859.GE2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59147 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261498AbUKOCuj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:50:39 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below removes the unused function t128_setup.

Please review whether it's correct.


diffstat output:
 drivers/scsi/t128.c |   28 ----------------------------
 1 files changed, 28 deletions(-)


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/t128.c.old	2004-11-14 01:31:48.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/t128.c	2004-11-14 01:37:27.000000000 +0100
@@ -154,34 +154,6 @@
 
 #define NO_SIGNATURES (sizeof (signatures) /  sizeof (struct signature))
 
-/*
- * Function : t128_setup(char *str, int *ints)
- *
- * Purpose : LILO command line initialization of the overrides array,
- * 
- * Inputs : str - unused, ints - array of integer parameters with ints[0]
- *	equal to the number of ints.
- *
- */
-
-void __init t128_setup(char *str, int *ints){
-    static int commandline_current = 0;
-    int i;
-    if (ints[0] != 2) 
-	printk("t128_setup : usage t128=address,irq\n");
-    else 
-	if (commandline_current < NO_OVERRIDES) {
-	    overrides[commandline_current].address = ints[1];
-	    overrides[commandline_current].irq = ints[2];
-	    for (i = 0; i < NO_BASES; ++i)
-		if (bases[i].address == ints[1]) {
-		    bases[i].noauto = 1;
-		    break;
-		}
-	    ++commandline_current;
-	}
-}
-
 /* 
  * Function : int t128_detect(Scsi_Host_Template * tpnt)
  *

