From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fix parameter naming
Date: Fri, 6 Jun 2003 09:59:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606075950.GA18838@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:9169 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265388AbTFFHqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 03:46:21 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

use module_param_named to avoid the the superflous scsi strings
in the option names.


diff -Nru a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
--- a/drivers/scsi/scsi_devinfo.c	Thu Jun  5 12:04:51 2003
+++ b/drivers/scsi/scsi_devinfo.c	Thu Jun  5 12:04:51 2003
@@ -451,14 +451,14 @@
 	return err;
 }
 
-module_param_string(scsi_dev_flags, scsi_dev_flags, sizeof(scsi_dev_flags), 0);
-MODULE_PARM_DESC(scsi_dev_flags,
+module_param_string(dev_flags, scsi_dev_flags, sizeof(scsi_dev_flags), 0);
+MODULE_PARM_DESC(dev_flags,
 	 "Given scsi_dev_flags=vendor:model:flags[,v:m:f] add black/white"
 	 " list entries for vendor and model with an integer value of flags"
 	 " to the scsi device info list");
 
-module_param(scsi_default_dev_flags, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(scsi_default_dev_flags,
+module_param_named(default_dev_flags, scsi_default_dev_flags, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(default_dev_flags,
 		 "scsi default device flag integer value");
 
 /**
diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c	Thu Jun  5 12:04:51 2003
+++ b/drivers/scsi/scsi_scan.c	Thu Jun  5 12:04:51 2003
@@ -73,8 +73,8 @@
 static unsigned int max_scsi_luns = 1;
 #endif
 
-module_param(max_scsi_luns, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(max_scsi_luns,
+module_param_named(max_luns, max_scsi_luns, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(max_luns,
 		 "last scsi LUN (should be between 1 and 2^32-1)");
 
 #ifdef CONFIG_SCSI_REPORT_LUNS
@@ -87,8 +87,8 @@
  */
 static unsigned int max_scsi_report_luns = 128;
 
-module_param(max_scsi_report_luns, int, S_IRUGO|S_IWUSR);
-MODULE_PARM_DESC(max_scsi_report_luns,
+module_param_named(max_report_luns, max_scsi_report_luns, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(max_report_luns,
 		 "REPORT LUNS maximum number of LUNS received (should be"
 		 " between 1 and 16384)");
 #endif
