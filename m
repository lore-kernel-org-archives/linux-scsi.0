From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] convert scsi core to use module_param interfaces
Date: Wed, 4 Jun 2003 14:57:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030604145717.A8394@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:18864 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264152AbTFDVro (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jun 2003 17:47:44 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

This patch converts scsi core to use the module_param interfaces
(except for the hosts.c scsihosts usage).

With this applied, boot time (non-module) command line setting of scsi
parameters must be prefixed by what the scsi module name would be
(scsi_mod), for example:

	scsi_mod.scsi_logging_level=0x180 scsi_mod.scsi_default_dev_flags=0x1
	scsi_mod.max_scsi_luns=5

Usage of scsi_mod as above is a bit ugly and long - if this patch is
applied, we should consider renaming scsi.c to scsi_main.c or similiar,
and scsi_mod.o to scsi.o. Or, somehow get our prefix set to "scsi".

diff -purNX /home/patman/dontdiff bleed-2.5/drivers/scsi/scsi.c modp-log-bl-2.5/drivers/scsi/scsi.c
--- bleed-2.5/drivers/scsi/scsi.c	Wed Jun  4 08:08:41 2003
+++ modp-log-bl-2.5/drivers/scsi/scsi.c	Thu Jun  5 03:12:44 2003
@@ -38,6 +38,7 @@
 
 #include <linux/config.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/timer.h>
@@ -108,26 +109,6 @@ const char *const scsi_device_types[MAX_
 	"Enclosure        ",
 };
 
-MODULE_PARM(scsi_logging_level, "i");
-MODULE_PARM_DESC(scsi_logging_level, "SCSI logging level; should be zero or nonzero");
-
-#ifndef MODULE
-static int __init scsi_logging_setup(char *str)
-{
-	int tmp;
-
-	if (get_option(&str, &tmp) == 1) {
-		scsi_logging_level = (tmp ? ~0 : 0);
-		return 1;
-	} else {
-		printk(KERN_INFO "scsi_logging_setup : usage scsi_logging_level=n "
-		       "(n should be 0 or non-zero)\n");
-		return 0;
-	}
-}
-__setup("scsi_logging=", scsi_logging_setup);
-#endif
-
 /*
  * Function:    scsi_allocate_request
  *
@@ -983,6 +964,9 @@ void scsi_set_device_offline(struct scsi
 MODULE_DESCRIPTION("SCSI core");
 MODULE_LICENSE("GPL");
 
+module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
+
 static int __init init_scsi(void)
 {
 	int error, i;
diff -purNX /home/patman/dontdiff bleed-2.5/drivers/scsi/scsi_devinfo.c modp-log-bl-2.5/drivers/scsi/scsi_devinfo.c
--- bleed-2.5/drivers/scsi/scsi_devinfo.c	Wed May 28 23:14:52 2003
+++ modp-log-bl-2.5/drivers/scsi/scsi_devinfo.c	Thu Jun  5 03:18:39 2003
@@ -3,6 +3,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 
@@ -23,9 +24,9 @@ struct scsi_dev_info_list {
 
 
 static const char spaces[] = "                "; /* 16 of them */
-static char *scsi_dev_flags;
 static unsigned scsi_default_dev_flags;
 static LIST_HEAD(scsi_dev_info_list);
+static __init char scsi_dev_flags[256];
 
 /*
  * scsi_static_device_list: deprecated list of devices that require
@@ -450,36 +451,16 @@ out:
 	return err;
 }
 
-MODULE_PARM(scsi_dev_flags, "s");
+module_param_string(scsi_dev_flags, scsi_dev_flags, sizeof(scsi_dev_flags), 0);
 MODULE_PARM_DESC(scsi_dev_flags,
-	 "Given scsi_dev_flags=vendor:model:flags, add a black/white list"
-	 " entry for vendor and model with an integer value of flags"
+	 "Given scsi_dev_flags=vendor:model:flags[,v:m:f] add black/white"
+	 " list entries for vendor and model with an integer value of flags"
 	 " to the scsi device info list");
-MODULE_PARM(scsi_default_dev_flags, "i");
+
+module_param(scsi_default_dev_flags, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scsi_default_dev_flags,
 		 "scsi default device flag integer value");
 
-static int __init setup_scsi_dev_flags(char *str)
-{
-	scsi_dev_flags = str;
-	return 1;
-}
-
-static int __init setup_scsi_default_dev_flags(char *str)
-{
-	unsigned int tmp;
-	if (get_option(&str, &tmp) == 1) {
-		scsi_default_dev_flags = tmp;
-		printk(KERN_WARNING "%s %d\n", __FUNCTION__,
-		       scsi_default_dev_flags);
-		return 1;
-	} else {
-		printk(KERN_WARNING "%s: usage scsi_default_dev_flags=intr\n",
-		       __FUNCTION__);
-		return 0;
-	}
-}
-
 /**
  * scsi_dev_info_list_delete: called from scsi.c:exit_scsi to remove
  * 	the scsi_dev_info_list.
@@ -540,6 +521,3 @@ int scsi_init_devinfo(void)
 		scsi_exit_devinfo();
 	return error;
 }
-
-__setup("scsi_dev_flags=", setup_scsi_dev_flags);
-__setup("scsi_default_dev_flags=", setup_scsi_default_dev_flags);
diff -purNX /home/patman/dontdiff bleed-2.5/drivers/scsi/scsi_scan.c modp-log-bl-2.5/drivers/scsi/scsi_scan.c
--- bleed-2.5/drivers/scsi/scsi_scan.c	Wed Jun  4 08:08:41 2003
+++ modp-log-bl-2.5/drivers/scsi/scsi_scan.c	Thu Jun  5 03:12:44 2003
@@ -27,6 +27,7 @@
 
 #include <linux/config.h>
 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/blk.h>
 
@@ -72,29 +73,9 @@ static unsigned int max_scsi_luns = MAX_
 static unsigned int max_scsi_luns = 1;
 #endif
 
-#ifdef MODULE
-MODULE_PARM(max_scsi_luns, "i");
+module_param(max_scsi_luns, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_scsi_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
-#else
-
-static int __init scsi_luns_setup(char *str)
-{
-	unsigned int tmp;
-
-	if (get_option(&str, &tmp) == 1) {
-		max_scsi_luns = tmp;
-		return 1;
-	} else {
-		printk(KERN_WARNING "scsi_luns_setup: usage max_scsi_luns=n "
-		       "(n should be between 1 and 2^32-1)\n");
-		return 0;
-	}
-}
-
-__setup("max_scsi_luns=", scsi_luns_setup);
-
-#endif
 
 #ifdef CONFIG_SCSI_REPORT_LUNS
 /*
@@ -106,29 +87,10 @@ __setup("max_scsi_luns=", scsi_luns_setu
  */
 static unsigned int max_scsi_report_luns = 128;
 
-#ifdef MODULE
-MODULE_PARM(max_scsi_report_luns, "i");
+module_param(max_scsi_report_luns, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_scsi_report_luns,
 		 "REPORT LUNS maximum number of LUNS received (should be"
 		 " between 1 and 16384)");
-#else
-static int __init scsi_report_luns_setup(char *str)
-{
-	unsigned int tmp;
-
-	if (get_option(&str, &tmp) == 1) {
-		max_scsi_report_luns = tmp;
-		return 1;
-	} else {
-		printk(KERN_WARNING "scsi_report_luns_setup: usage"
-		       " max_scsi_report_luns=n (n should be between 1"
-		       " and 16384)\n");
-		return 0;
-	}
-}
-
-__setup("max_scsi_report_luns=", scsi_report_luns_setup);
-#endif
 #endif
 
 /**
