From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 4/4] scsi: cleanup usages of scsi_complete_async_scans
Date: Fri, 25 May 2012 00:50:43 -0700
Message-ID: <20120525075043.21933.3650.stgit@dwillia2-linux.jf.intel.com>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39270 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737Ab2EYHfl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 May 2012 03:35:41 -0400
In-Reply-To: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mroos@linux.ee
Cc: Len Brown <len.brown@intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@linux.intel.com>

Now that scsi registers its async scan work with the async subsystem,
wait_for_device_probe() is sufficient for ensuring all scanning is
complete.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: James Bottomley <JBottomley@parallels.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_scan.c      |   12 ------------
 drivers/scsi/scsi_wait_scan.c |   15 +++++----------
 include/scsi/scsi_scan.h      |   11 -----------
 kernel/power/hibernate.c      |    8 --------
 kernel/power/user.c           |    2 --
 5 files changed, 5 insertions(+), 43 deletions(-)
 delete mode 100644 include/scsi/scsi_scan.h

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index fb42aa0..20c7108 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -184,18 +184,6 @@ int scsi_complete_async_scans(void)
 	return 0;
 }
 
-/* Only exported for the benefit of scsi_wait_scan */
-EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
-
-#ifndef MODULE
-/*
- * For async scanning we need to wait for all the scans to complete before
- * trying to mount the root fs.  Otherwise non-modular drivers may not be ready
- * yet.
- */
-late_initcall(scsi_complete_async_scans);
-#endif
-
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
  * @sdev:	scsi device to send command to
diff --git a/drivers/scsi/scsi_wait_scan.c b/drivers/scsi/scsi_wait_scan.c
index 74708fc..57de24a 100644
--- a/drivers/scsi/scsi_wait_scan.c
+++ b/drivers/scsi/scsi_wait_scan.c
@@ -12,21 +12,16 @@
 
 #include <linux/module.h>
 #include <linux/device.h>
-#include <scsi/scsi_scan.h>
 
 static int __init wait_scan_init(void)
 {
 	/*
-	 * First we need to wait for device probing to finish;
-	 * the drivers we just loaded might just still be probing
-	 * and might not yet have reached the scsi async scanning
+	 * This will not return until all async work (system wide) is
+	 * quiesced.  Probing queues host-scanning work to the async
+	 * queue which is why we don't need a separate call to
+	 * scsi_complete_async_scans()
 	 */
 	wait_for_device_probe();
-	/*
-	 * and then we wait for the actual asynchronous scsi scan
-	 * to finish.
-	 */
-	scsi_complete_async_scans();
 	return 0;
 }
 
@@ -38,5 +33,5 @@ MODULE_DESCRIPTION("SCSI wait for scans");
 MODULE_AUTHOR("James Bottomley");
 MODULE_LICENSE("GPL");
 
-late_initcall(wait_scan_init);
+module_init(wait_scan_init);
 module_exit(wait_scan_exit);
diff --git a/include/scsi/scsi_scan.h b/include/scsi/scsi_scan.h
deleted file mode 100644
index 7889888..0000000
--- a/include/scsi/scsi_scan.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef _SCSI_SCSI_SCAN_H
-#define _SCSI_SCSI_SCAN_H
-
-#ifdef CONFIG_SCSI
-/* drivers/scsi/scsi_scan.c */
-extern int scsi_complete_async_scans(void);
-#else
-static inline int scsi_complete_async_scans(void) { return 0; }
-#endif
-
-#endif /* _SCSI_SCSI_SCAN_H */
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index e09dfbf..821114a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -25,7 +25,6 @@
 #include <linux/freezer.h>
 #include <linux/gfp.h>
 #include <linux/syscore_ops.h>
-#include <scsi/scsi_scan.h>
 
 #include "power.h"
 
@@ -735,13 +734,6 @@ static int software_resume(void)
 			async_synchronize_full();
 		}
 
-		/*
-		 * We can't depend on SCSI devices being available after loading
-		 * one of their modules until scsi_complete_async_scans() is
-		 * called and the resume device usually is a SCSI one.
-		 */
-		scsi_complete_async_scans();
-
 		swsusp_resume_device = name_to_dev_t(resume_file);
 		if (!swsusp_resume_device) {
 			error = -ENODEV;
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 91b0fd0..4ed81e7 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -24,7 +24,6 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
-#include <scsi/scsi_scan.h>
 
 #include <asm/uaccess.h>
 
@@ -84,7 +83,6 @@ static int snapshot_open(struct inode *inode, struct file *filp)
 		 * appear.
 		 */
 		wait_for_device_probe();
-		scsi_complete_async_scans();
 
 		data->swap = -1;
 		data->mode = O_WRONLY;

