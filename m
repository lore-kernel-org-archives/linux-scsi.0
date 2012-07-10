From: Dan Williams <dan.j.williams@intel.com>
Subject: [set4 resend PATCH 4/5] scsi: cleanup usages of
 scsi_complete_async_scans
Date: Mon, 09 Jul 2012 19:33:40 -0700
Message-ID: <20120710023340.26249.88941.stgit@dwillia2-linux.jf.intel.com>
References: <20120710023241.26249.13718.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120710023241.26249.13718.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com, JBottomley@parallels.com
Cc: Len Brown <len.brown@intel.com>, linux-scsi@vger.kernel.org, Eldad Zack <eldad@fogrefinery.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, linux-ide@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

Now that scsi registers its async scan work with the async subsystem,
wait_for_device_probe() is sufficient for ensuring all scanning is
complete.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: James Bottomley <JBottomley@parallels.com>
Tested-by: Eldad Zack <eldad@fogrefinery.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_scan.c |   12 ------------
 include/scsi/scsi_scan.h |   11 -----------
 kernel/power/hibernate.c |    8 --------
 kernel/power/user.c      |    2 --
 4 files changed, 33 deletions(-)
 delete mode 100644 include/scsi/scsi_scan.h

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index dff17c1..a0bc663 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -187,18 +187,6 @@ int scsi_complete_async_scans(void)
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
index 8b53db3..238025f 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -27,7 +27,6 @@
 #include <linux/syscore_ops.h>
 #include <linux/ctype.h>
 #include <linux/genhd.h>
-#include <scsi/scsi_scan.h>
 
 #include "power.h"
 
@@ -748,13 +747,6 @@ static int software_resume(void)
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

