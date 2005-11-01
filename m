From: brking@us.ibm.com
Subject: [PATCH 03/26] ipr: Physical resource error logging macro
Date: Tue, 01 Nov 2005 17:00:27 -0600
Message-ID: <200511012300.jA1N0SKt025826@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:4226 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751399AbVKAXA3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:00:29 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N0TWN018708
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:00:29 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jA1N1XDC539308
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:01:33 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N0TQp025854
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:00:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Adds a macro in the ipr driver for logging a physical device location.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   35 ++++++-----------------------------
 linux-2.6-bjking1/drivers/scsi/ipr.h |   11 +++++++++++
 2 files changed, 17 insertions(+), 29 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_phys_res_err drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_phys_res_err	2005-10-19 11:24:18.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-10-19 12:45:41.000000000 -0500
@@ -1124,6 +1124,17 @@ struct ipr_ucode_image_header {
 #define ipr_res_dbg(ioa_cfg, res, fmt, ...) \
 	IPR_DBG_CMD(ipr_res_printk(KERN_INFO, ioa_cfg, res, fmt, ##__VA_ARGS__))
 
+#define ipr_phys_res_err(ioa_cfg, res, fmt, ...)			\
+{									\
+	if ((res).bus >= IPR_MAX_NUM_BUSES) {				\
+		ipr_err(fmt": unknown\n", ##__VA_ARGS__);		\
+	} else {							\
+		ipr_err(fmt": %d:%d:%d:%d\n",				\
+			##__VA_ARGS__, (ioa_cfg)->host->host_no,	\
+			(res).bus, (res).target, (res).lun);		\
+	}								\
+}
+
 #define ipr_trace ipr_dbg("%s: %s: Line: %d\n",\
 	__FILE__, __FUNCTION__, __LINE__)
 
diff -puN drivers/scsi/ipr.c~ipr_phys_res_err drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_phys_res_err	2005-10-19 11:24:18.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-19 12:44:50.000000000 -0500
@@ -968,13 +968,7 @@ static void ipr_log_config_error(struct 
 	for (i = 0; i < errors_logged; i++, dev_entry++) {
 		ipr_err_separator;
 
-		if (dev_entry->dev_res_addr.bus >= IPR_MAX_NUM_BUSES) {
-			ipr_err("Device %d: missing\n", i + 1);
-		} else {
-			ipr_err("Device %d: %d:%d:%d:%d\n", i + 1,
-				ioa_cfg->host->host_no, dev_entry->dev_res_addr.bus,
-				dev_entry->dev_res_addr.target, dev_entry->dev_res_addr.lun);
-		}
+		ipr_phys_res_err(ioa_cfg, dev_entry->dev_res_addr, "Device %d", i + 1);
 		ipr_log_vpd(&dev_entry->vpd);
 
 		ipr_err("-----New Device Information-----\n");
@@ -1030,33 +1024,16 @@ static void ipr_log_array_error(struct i
 		if (!memcmp(array_entry->vpd.sn, zero_sn, IPR_SERIAL_NUM_LEN))
 			continue;
 
-		if (be32_to_cpu(error->exposed_mode_adn) == i) {
+		if (be32_to_cpu(error->exposed_mode_adn) == i)
 			ipr_err("Exposed Array Member %d:\n", i);
-		} else {
+		else
 			ipr_err("Array Member %d:\n", i);
-		}
 
 		ipr_log_vpd(&array_entry->vpd);
 
-		if (array_entry->dev_res_addr.bus >= IPR_MAX_NUM_BUSES) {
-			ipr_err("Current Location: unknown\n");
-		} else {
-			ipr_err("Current Location: %d:%d:%d:%d\n",
-				ioa_cfg->host->host_no,
-				array_entry->dev_res_addr.bus,
-				array_entry->dev_res_addr.target,
-				array_entry->dev_res_addr.lun);
-		}
-
-		if (array_entry->expected_dev_res_addr.bus >= IPR_MAX_NUM_BUSES) {
-			ipr_err("Expected Location: unknown\n");
-		} else {
-			ipr_err("Expected Location: %d:%d:%d:%d\n",
-				ioa_cfg->host->host_no,
-				array_entry->expected_dev_res_addr.bus,
-				array_entry->expected_dev_res_addr.target,
-				array_entry->expected_dev_res_addr.lun);
-		}
+		ipr_phys_res_err(ioa_cfg, array_entry->dev_res_addr, "Current Location");
+		ipr_phys_res_err(ioa_cfg, array_entry->expected_dev_res_addr,
+				 "Expected Location");
 
 		ipr_err_separator;
 
_
