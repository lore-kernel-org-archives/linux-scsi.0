From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] fix __FUNCTION__ pasting in wd7000.c
Date: Wed, 18 Sep 2002 06:28:51 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020917213227.1BF042C42D@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Arnaldo Carvalho de Melo <acme@conectiva.com.br>

[ acme: you touched it last... ]

From:  Paul Larson <plars@linuxtestproject.org>

  Trivial fix for __FUNCTION__ pasting in wd7000.c against current bk tree.
  
  -Paul Larson
  
  # This is a BitKeeper generated patch for the following project:
  # Project Name: Linux kernel tree
  # This patch format is intended for GNU patch command version 2.5 or higher.
  # This patch includes the following deltas:
  #	           ChangeSet	1.556   -> 1.557  
  #	drivers/scsi/wd7000.c	1.8     -> 1.9    
  #
  # The following is the BitKeeper ChangeSet Log
  # --------------------------------------------
  # 02/08/29	plars@austin.ibm.com	1.557
  # fix __FUNCTION__ pasting in wd7000
  # --------------------------------------------
  #

--- trivial-2.5.35/drivers/scsi/wd7000.c.orig	2002-09-18 05:53:23.000000000 +1000
+++ trivial-2.5.35/drivers/scsi/wd7000.c	2002-09-18 05:53:23.000000000 +1000
@@ -621,16 +621,16 @@
 	(void)get_options(str, ARRAY_SIZE(ints), ints);
 
 	if (wd7000_card_num >= NUM_CONFIGS) {
-		printk(KERN_ERR __FUNCTION__
-			": Too many \"wd7000=\" configurations in "
-			"command line!\n");
+		printk(KERN_ERR
+			"%s: Too many \"wd7000=\" configurations in "
+			"command line!\n", __FUNCTION__);
 		return 0;
 	}
 
 	if ((ints[0] < 3) || (ints[0] > 5)) {
-		printk(KERN_ERR __FUNCTION__ ": Error in command line!  "
+		printk(KERN_ERR "%s: Error in command line!  "
 			"Usage: wd7000=<IRQ>,<DMA>,IO>[,<BUS_ON>"
-			"[,<BUS_OFF>]]\n");
+			"[,<BUS_OFF>]]\n", __FUNCTION__ );
 	} else {
 		for (i = 0; i < NUM_IRQS; i++)
 			if (ints[1] == wd7000_irq[i])
@@ -1743,8 +1743,8 @@
 	    ip[2] = info[2];
 
 	    if (info[0] == 255)
-		printk(KERN_INFO __FUNCTION__ ": current partition table is "
-			"using extended translation.\n");
+		printk(KERN_INFO "%s: current partition table is "
+			"using extended translation.\n", __FUNCTION__ );
 	}
     }
 
-- 
  Don't blame me: the Monkey is driving
  File: Paul Larson <plars@linuxtestproject.org>: [TRIVIAL][PATCH] fix __FUNCTION__ pasting in wd7000.c
