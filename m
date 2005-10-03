From: brking@us.ibm.com
Subject: [PATCH 1/1] scsi: scsi inquiry timeout config option
Date: Mon, 03 Oct 2005 15:26:30 -0500
Message-ID: <200510032026.j93KQViR015934@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:8915 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932686AbVJCU0g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2005 16:26:36 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j93KQWNb031679
	for <linux-scsi@vger.kernel.org>; Mon, 3 Oct 2005 16:26:32 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j93KQWVc090692
	for <linux-scsi@vger.kernel.org>; Mon, 3 Oct 2005 16:26:32 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j93KQVqW015956
	for <linux-scsi@vger.kernel.org>; Mon, 3 Oct 2005 16:26:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org, brking@us.ibm.com


Add a .config option to default the scsi scan inquiry timeout.
Due to a broken device (SCSI/ATA converter card) that is very
common on IBM iSeries/pSeries machines, these architectures
need a longer default inquiry timeout.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/arch/ppc64/configs/iSeries_defconfig |    1 +
 linux-2.6-bjking1/arch/ppc64/configs/pSeries_defconfig |    1 +
 linux-2.6-bjking1/drivers/scsi/Kconfig                 |    8 ++++++++
 linux-2.6-bjking1/drivers/scsi/scsi_scan.c             |    2 +-
 4 files changed, 11 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/Kconfig~scsi_inq_timeout_config drivers/scsi/Kconfig
--- linux-2.6/drivers/scsi/Kconfig~scsi_inq_timeout_config	2005-10-03 11:15:08.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/Kconfig	2005-10-03 11:17:37.000000000 -0500
@@ -209,6 +209,14 @@ config SCSI_LOGGING
 	  there should be no noticeable performance impact as long as you have
 	  logging turned off.
 
+config SCSI_INQUIRY_TIMEOUT
+	int "default timeout in seconds for INQUIRY scan"
+	depends on SCSI
+	default "5"
+	---help---
+	  Timeout (in seconds) waiting for devices to answer INQUIRY.
+	  Default is 5. Some non-compliant devices need more.
+
 menu "SCSI Transport Attributes"
 	depends on SCSI
 
diff -puN drivers/scsi/scsi_scan.c~scsi_inq_timeout_config drivers/scsi/scsi_scan.c
--- linux-2.6/drivers/scsi/scsi_scan.c~scsi_inq_timeout_config	2005-10-03 11:17:44.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/scsi_scan.c	2005-10-03 11:18:58.000000000 -0500
@@ -102,7 +102,7 @@ MODULE_PARM_DESC(max_report_luns,
 		 "REPORT LUNS maximum number of LUNS received (should be"
 		 " between 1 and 16384)");
 
-static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+3;
+static unsigned int scsi_inq_timeout = CONFIG_SCSI_INQUIRY_TIMEOUT;
 
 module_param_named(inq_timeout, scsi_inq_timeout, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(inq_timeout, 
diff -puN arch/ppc64/configs/pSeries_defconfig~scsi_inq_timeout_config arch/ppc64/configs/pSeries_defconfig
--- linux-2.6/arch/ppc64/configs/pSeries_defconfig~scsi_inq_timeout_config	2005-10-03 11:19:18.000000000 -0500
+++ linux-2.6-bjking1/arch/ppc64/configs/pSeries_defconfig	2005-10-03 11:21:18.000000000 -0500
@@ -436,6 +436,7 @@ CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
 # CONFIG_SCSI_LOGGING is not set
+CONFIG_SCSI_INQUIRY_TIMEOUT=30
 
 #
 # SCSI Transport Attributes
diff -puN arch/ppc64/configs/iSeries_defconfig~scsi_inq_timeout_config arch/ppc64/configs/iSeries_defconfig
--- linux-2.6/arch/ppc64/configs/iSeries_defconfig~scsi_inq_timeout_config	2005-10-03 11:24:14.000000000 -0500
+++ linux-2.6-bjking1/arch/ppc64/configs/iSeries_defconfig	2005-10-03 11:24:29.000000000 -0500
@@ -343,6 +343,7 @@ CONFIG_CHR_DEV_SG=y
 CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
 # CONFIG_SCSI_LOGGING is not set
+CONFIG_SCSI_INQUIRY_TIMEOUT=30
 
 #
 # SCSI Transport Attributes
_
