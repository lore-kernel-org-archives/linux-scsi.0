From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] remove REPORT_LUNS config option
Date: Tue, 2 Sep 2003 12:36:15 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030902023614.GD1941@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:45206 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S263400AbTIBCiH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Sep 2003 22:38:07 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Hi,

REPORT_LUNS is another config option which duplicates functionality we
can have at run time. To turn report luns off at runtime I chose to
use max_scsi_report_luns == 0.

BTW I notice we have 2 potentially overlapping options: max_luns and
max_report_luns. It might be less confusing to instead have max_luns
and disable_report_luns options.

Anton

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1408  -> 1.1409 
#	drivers/scsi/scsi_scan.c	1.104   -> 1.105  
#	drivers/scsi/Kconfig	1.26    -> 1.27   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/02	anton@samba.org	1.1409
# remove SCSI_REPORT_LUNS config option
# --------------------------------------------
#
diff -Nru a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
--- a/drivers/scsi/Kconfig	Tue Sep  2 10:19:59 2003
+++ b/drivers/scsi/Kconfig	Tue Sep  2 10:19:59 2003
@@ -136,20 +136,6 @@
 	  <file:Documentation/scsi/scsi.txt>. The module will be called sg.
 	  If unsure, say N.
 
-comment "Some SCSI devices (e.g. CD jukebox) support multiple LUNs"
-	depends on SCSI
-
-config SCSI_REPORT_LUNS
-	bool "Build with SCSI REPORT LUNS support"
-	depends on SCSI
-	default y
-	help
-	  If you want support for SCSI REPORT LUNS, say Y here.
-	  The REPORT LUNS command is useful for devices (such as disk arrays)
-	  with large numbers of LUNs where the LUN values are not contiguous
-	  (sparse LUN).  REPORT LUNS scanning is done only for SCSI-3 devices.
-	  Most users can safely answer N here.
-
 config SCSI_CONSTANTS
 	bool "Verbose SCSI error reporting (kernel size +=12K)"
 	depends on SCSI
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Tue Sep  2 10:19:59 2003
+++ b/drivers/scsi/scsi_scan.c	Tue Sep  2 10:19:59 2003
@@ -74,21 +74,19 @@
 MODULE_PARM_DESC(max_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
 
-#ifdef CONFIG_SCSI_REPORT_LUNS
 /*
  * max_scsi_report_luns: the maximum number of LUNS that will be
  * returned from the REPORT LUNS command. 8 times this value must
  * be allocated. In theory this could be up to an 8 byte value, but
- * in practice, the maximum number of LUNs suppored by any device
+ * in practice, the maximum number of LUNs supported by any device
  * is about 16k.
  */
-static unsigned int max_scsi_report_luns = 128;
+static unsigned int max_scsi_report_luns = MAX_SCSI_LUNS;
 
 module_param_named(max_report_luns, max_scsi_report_luns, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(max_report_luns,
 		 "REPORT LUNS maximum number of LUNS received (should be"
-		 " between 1 and 16384)");
-#endif
+		 " between 1 and 16384 or 0 to disable use of REPORT LUNS)");
 
 /**
  * scsi_unlock_floptical - unlock device via a special MODE SENSE command
@@ -826,7 +824,6 @@
 			return;
 }
 
-#ifdef CONFIG_SCSI_REPORT_LUNS
 /**
  * scsilun_to_int: convert a scsi_lun to an int
  * @scsilun:	struct scsi_lun to be converted.
@@ -887,6 +884,12 @@
 	char *data;
 
 	/*
+	 * Did we disable the use of REPORT LUNS?
+	 */
+	if (max_scsi_report_luns == 0)
+		return 1;
+
+	/*
 	 * Only support SCSI-3 and up devices.
 	 */
 	if (sdev->scsi_level < SCSI_3)
@@ -1053,9 +1056,6 @@
 	printk(ALLOC_FAILURE_MSG, __FUNCTION__);
 	return 0;
 }
-#else
-# define scsi_report_lun_scan(sdev, blags, rescan)	(1)
-#endif	/* CONFIG_SCSI_REPORT_LUNS */
 
 struct scsi_device *scsi_add_device(struct Scsi_Host *shost,
 				    uint channel, uint id, uint lun)

