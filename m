From: "Adam Radford" <aradford@amcc.com>
Subject: [PATCH] 3ware 9000 driver update for 2.6.7-rc2-mm3
Date: Thu, 3 Jun 2004 17:29:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <HYRDDJ03.YDP@hadar.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hadar.amcc.com ([192.195.69.168]:18594 "EHLO hadar.amcc.com")
	by vger.kernel.org with ESMTP id S264518AbUFDA3o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2004 20:29:44 -0400
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, james.bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Andrew, James,

This small patch fixes the broken schedule_timeout() usage in the 3w-9xxx driver,
and replaces the calls with msleep().

--
Adam Radford
Staff Software Engineer
AMCC

diff -Naur linux-2.6.7-rc2-mm2/drivers/scsi/3w-9xxx.c linux-2.6.7-rc2-mm3/drivers/scsi/3w-9xxx.c
--- linux-2.6.7-rc2-mm2/drivers/scsi/3w-9xxx.c	2004-06-03 15:22:18.000000000 -0700
+++ linux-2.6.7-rc2-mm3/drivers/scsi/3w-9xxx.c	2004-06-03 17:22:06.000000000 -0700
@@ -50,6 +50,7 @@
    History
    -------
    2.26.02.000 - Driver cleanup for kernel submission.
+   2.26.02.001 - Replace schedule_timeout() calls with msleep().
 */
 
 #include <linux/module.h>
@@ -72,7 +73,7 @@
 #include "3w-9xxx.h"
 
 /* Globals */
-static const char *twa_driver_version="2.26.02.000";
+static const char *twa_driver_version="2.26.02.001";
 static TW_Device_Extension *twa_device_extension_list[TW_MAX_SLOT];
 static unsigned int twa_device_extension_count;
 static int twa_major = -1;
@@ -1445,7 +1446,7 @@
 		if (time_after(jiffies, before + HZ * seconds))
 			goto out;
 
-		schedule_timeout(1);
+		msleep(50);
 	}
 	retval = 0;
 out:
@@ -1473,7 +1474,7 @@
 		if (time_after(jiffies, before + HZ * seconds))
 			goto out;
 
-		schedule_timeout(1);
+		msleep(50);
 	}
 	retval = 0;
 out:

