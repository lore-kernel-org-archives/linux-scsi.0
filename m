From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/wd33c93.c: cleanups
Date: Mon, 21 Aug 2006 12:43:57 +0200
Message-ID: <20060821104357.GH11651@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:3079 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1751854AbWHUKn5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 06:43:57 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- #include <linux/irq.h> for getting the prototypes of
  {dis,en}able_irq()
- make the needlessly global wd33c93_setup() static

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.18-rc4-mm2/drivers/scsi/wd33c93.c.old	2006-08-21 03:16:42.000000000 +0200
+++ linux-2.6.18-rc4-mm2/drivers/scsi/wd33c93.c	2006-08-21 03:17:10.000000000 +0200
@@ -79,6 +79,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/blkdev.h>
+#include <linux/irq.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1710,7 +1711,7 @@
 static char setup_used[MAX_SETUP_ARGS];
 static int done_setup = 0;
 
-int
+static int
 wd33c93_setup(char *str)
 {
 	int i;
