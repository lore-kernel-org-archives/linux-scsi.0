From: brking@us.ibm.com
Subject: [PATCH 02/26] ipr: Cleanup error structures
Date: Tue, 01 Nov 2005 17:00:18 -0600
Message-ID: <200511012300.jA1N0L6J010112@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60362 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751398AbVKAXAX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:00:23 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N0M2h014142
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:00:22 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N0Mbn057144
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:00:22 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N0M2V010245
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:00:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Simplify the ipr error structures a bit by removing some duplication.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   37 ++++++++++--------------
 linux-2.6-bjking1/drivers/scsi/ipr.h |   52 +++++++++++++----------------------
 2 files changed, 36 insertions(+), 53 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_cleanup_error_types drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_cleanup_error_types	2005-08-30 10:17:43.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2005-08-30 10:17:43.000000000 -0500
@@ -261,6 +261,11 @@ struct ipr_std_inq_vpids {
 	u8 product_id[IPR_PROD_ID_LEN];
 }__attribute__((packed));
 
+struct ipr_vpd {
+	struct ipr_std_inq_vpids vpids;
+	u8 sn[IPR_SERIAL_NUM_LEN];
+}__attribute__((packed));
+
 struct ipr_std_inq_data {
 	u8 peri_qual_dev_type;
 #define IPR_STD_INQ_PERI_QUAL(peri) ((peri) >> 5)
@@ -537,21 +542,16 @@ struct ipr_inquiry_page3 {
 }__attribute__((packed));
 
 struct ipr_hostrcb_device_data_entry {
-	struct ipr_std_inq_vpids dev_vpids;
-	u8 dev_sn[IPR_SERIAL_NUM_LEN];
+	struct ipr_vpd vpd;
 	struct ipr_res_addr dev_res_addr;
-	struct ipr_std_inq_vpids new_dev_vpids;
-	u8 new_dev_sn[IPR_SERIAL_NUM_LEN];
-	struct ipr_std_inq_vpids ioa_last_with_dev_vpids;
-	u8 ioa_last_with_dev_sn[IPR_SERIAL_NUM_LEN];
-	struct ipr_std_inq_vpids cfc_last_with_dev_vpids;
-	u8 cfc_last_with_dev_sn[IPR_SERIAL_NUM_LEN];
+	struct ipr_vpd new_vpd;
+	struct ipr_vpd ioa_last_with_dev_vpd;
+	struct ipr_vpd cfc_last_with_dev_vpd;
 	__be32 ioa_data[5];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_array_data_entry {
-	struct ipr_std_inq_vpids vpids;
-	u8 serial_num[IPR_SERIAL_NUM_LEN];
+	struct ipr_vpd vpd;
 	struct ipr_res_addr expected_dev_res_addr;
 	struct ipr_res_addr dev_res_addr;
 }__attribute__((packed, aligned (4)));
@@ -568,47 +568,35 @@ struct ipr_hostrcb_type_01_error {
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_type_02_error {
-	struct ipr_std_inq_vpids ioa_vpids;
-	u8 ioa_sn[IPR_SERIAL_NUM_LEN];
-	struct ipr_std_inq_vpids cfc_vpids;
-	u8 cfc_sn[IPR_SERIAL_NUM_LEN];
-	struct ipr_std_inq_vpids ioa_last_attached_to_cfc_vpids;
-	u8 ioa_last_attached_to_cfc_sn[IPR_SERIAL_NUM_LEN];
-	struct ipr_std_inq_vpids cfc_last_attached_to_ioa_vpids;
-	u8 cfc_last_attached_to_ioa_sn[IPR_SERIAL_NUM_LEN];
+	struct ipr_vpd ioa_vpd;
+	struct ipr_vpd cfc_vpd;
+	struct ipr_vpd ioa_last_attached_to_cfc_vpd;
+	struct ipr_vpd cfc_last_attached_to_ioa_vpd;
 	__be32 ioa_data[3];
-	u8 reserved[844];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_type_03_error {
-	struct ipr_std_inq_vpids ioa_vpids;
-	u8 ioa_sn[IPR_SERIAL_NUM_LEN];
-	struct ipr_std_inq_vpids cfc_vpids;
-	u8 cfc_sn[IPR_SERIAL_NUM_LEN];
+	struct ipr_vpd ioa_vpd;
+	struct ipr_vpd cfc_vpd;
 	__be32 errors_detected;
 	__be32 errors_logged;
 	u8 ioa_data[12];
-	struct ipr_hostrcb_device_data_entry dev_entry[3];
-	u8 reserved[444];
+	struct ipr_hostrcb_device_data_entry dev[3];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_type_04_error {
-	struct ipr_std_inq_vpids ioa_vpids;
-	u8 ioa_sn[IPR_SERIAL_NUM_LEN];
-	struct ipr_std_inq_vpids cfc_vpids;
-	u8 cfc_sn[IPR_SERIAL_NUM_LEN];
+	struct ipr_vpd ioa_vpd;
+	struct ipr_vpd cfc_vpd;
 	u8 ioa_data[12];
 	struct ipr_hostrcb_array_data_entry array_member[10];
 	__be32 exposed_mode_adn;
 	__be32 array_id;
-	struct ipr_std_inq_vpids incomp_dev_vpids;
-	u8 incomp_dev_sn[IPR_SERIAL_NUM_LEN];
+	struct ipr_vpd incomp_dev_vpd;
 	__be32 ioa_data2;
 	struct ipr_hostrcb_array_data_entry array_member2[8];
 	struct ipr_res_addr last_func_vset_res_addr;
 	u8 vset_serial_num[IPR_SERIAL_NUM_LEN];
 	u8 protection_level[8];
-	u8 reserved[124];
 }__attribute__((packed, aligned (4)));
 
 struct ipr_hostrcb_error {
diff -puN drivers/scsi/ipr.c~ipr_cleanup_error_types drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_cleanup_error_types	2005-08-30 10:17:43.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-08-30 10:17:43.000000000 -0500
@@ -889,24 +889,23 @@ static void ipr_process_ccn(struct ipr_c
 
 /**
  * ipr_log_vpd - Log the passed VPD to the error log.
- * @vpids:			vendor/product id struct
- * @serial_num:		serial number string
+ * @vpd:		vendor/product id/sn struct
  *
  * Return value:
  * 	none
  **/
-static void ipr_log_vpd(struct ipr_std_inq_vpids *vpids, u8 *serial_num)
+static void ipr_log_vpd(struct ipr_vpd *vpd)
 {
 	char buffer[IPR_VENDOR_ID_LEN + IPR_PROD_ID_LEN
 		    + IPR_SERIAL_NUM_LEN];
 
-	memcpy(buffer, vpids->vendor_id, IPR_VENDOR_ID_LEN);
-	memcpy(buffer + IPR_VENDOR_ID_LEN, vpids->product_id,
+	memcpy(buffer, vpd->vpids.vendor_id, IPR_VENDOR_ID_LEN);
+	memcpy(buffer + IPR_VENDOR_ID_LEN, vpd->vpids.product_id,
 	       IPR_PROD_ID_LEN);
 	buffer[IPR_VENDOR_ID_LEN + IPR_PROD_ID_LEN] = '\0';
 	ipr_err("Vendor/Product ID: %s\n", buffer);
 
-	memcpy(buffer, serial_num, IPR_SERIAL_NUM_LEN);
+	memcpy(buffer, vpd->sn, IPR_SERIAL_NUM_LEN);
 	buffer[IPR_SERIAL_NUM_LEN] = '\0';
 	ipr_err("    Serial Number: %s\n", buffer);
 }
@@ -927,17 +926,15 @@ static void ipr_log_cache_error(struct i
 
 	ipr_err("-----Current Configuration-----\n");
 	ipr_err("Cache Directory Card Information:\n");
-	ipr_log_vpd(&error->ioa_vpids, error->ioa_sn);
+	ipr_log_vpd(&error->ioa_vpd);
 	ipr_err("Adapter Card Information:\n");
-	ipr_log_vpd(&error->cfc_vpids, error->cfc_sn);
+	ipr_log_vpd(&error->cfc_vpd);
 
 	ipr_err("-----Expected Configuration-----\n");
 	ipr_err("Cache Directory Card Information:\n");
-	ipr_log_vpd(&error->ioa_last_attached_to_cfc_vpids,
-		    error->ioa_last_attached_to_cfc_sn);
+	ipr_log_vpd(&error->ioa_last_attached_to_cfc_vpd);
 	ipr_err("Adapter Card Information:\n");
-	ipr_log_vpd(&error->cfc_last_attached_to_ioa_vpids,
-		    error->cfc_last_attached_to_ioa_sn);
+	ipr_log_vpd(&error->cfc_last_attached_to_ioa_vpd);
 
 	ipr_err("Additional IOA Data: %08X %08X %08X\n",
 		     be32_to_cpu(error->ioa_data[0]),
@@ -966,7 +963,7 @@ static void ipr_log_config_error(struct 
 	ipr_err("Device Errors Detected/Logged: %d/%d\n",
 		be32_to_cpu(error->errors_detected), errors_logged);
 
-	dev_entry = error->dev_entry;
+	dev_entry = error->dev;
 
 	for (i = 0; i < errors_logged; i++, dev_entry++) {
 		ipr_err_separator;
@@ -978,18 +975,16 @@ static void ipr_log_config_error(struct 
 				ioa_cfg->host->host_no, dev_entry->dev_res_addr.bus,
 				dev_entry->dev_res_addr.target, dev_entry->dev_res_addr.lun);
 		}
-		ipr_log_vpd(&dev_entry->dev_vpids, dev_entry->dev_sn);
+		ipr_log_vpd(&dev_entry->vpd);
 
 		ipr_err("-----New Device Information-----\n");
-		ipr_log_vpd(&dev_entry->new_dev_vpids, dev_entry->new_dev_sn);
+		ipr_log_vpd(&dev_entry->new_vpd);
 
 		ipr_err("Cache Directory Card Information:\n");
-		ipr_log_vpd(&dev_entry->ioa_last_with_dev_vpids,
-			    dev_entry->ioa_last_with_dev_sn);
+		ipr_log_vpd(&dev_entry->ioa_last_with_dev_vpd);
 
 		ipr_err("Adapter Card Information:\n");
-		ipr_log_vpd(&dev_entry->cfc_last_with_dev_vpids,
-			    dev_entry->cfc_last_with_dev_sn);
+		ipr_log_vpd(&dev_entry->cfc_last_with_dev_vpd);
 
 		ipr_err("Additional IOA Data: %08X %08X %08X %08X %08X\n",
 			be32_to_cpu(dev_entry->ioa_data[0]),
@@ -1032,7 +1027,7 @@ static void ipr_log_array_error(struct i
 	array_entry = error->array_member;
 
 	for (i = 0; i < 18; i++) {
-		if (!memcmp(array_entry->serial_num, zero_sn, IPR_SERIAL_NUM_LEN))
+		if (!memcmp(array_entry->vpd.sn, zero_sn, IPR_SERIAL_NUM_LEN))
 			continue;
 
 		if (be32_to_cpu(error->exposed_mode_adn) == i) {
@@ -1041,7 +1036,7 @@ static void ipr_log_array_error(struct i
 			ipr_err("Array Member %d:\n", i);
 		}
 
-		ipr_log_vpd(&array_entry->vpids, array_entry->serial_num);
+		ipr_log_vpd(&array_entry->vpd);
 
 		if (array_entry->dev_res_addr.bus >= IPR_MAX_NUM_BUSES) {
 			ipr_err("Current Location: unknown\n");
_
