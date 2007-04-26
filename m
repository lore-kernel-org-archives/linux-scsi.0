From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 7/8] ipr: Improved dual adapter errors
Date: Thu, 26 Apr 2007 16:00:14 -0500
Message-ID: <200704262101.l3QL1Q3C007790@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:46714 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbXDZVB3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Apr 2007 17:01:29 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QL1SRc005040
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 17:01:28 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QL1Rcn200320
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 15:01:27 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QL1RLr007883
	for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2007 15:01:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


Formats ipr dual adapter errors so that they are more compact.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.c |   78 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 72 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_improved_dual_adapter_errors drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_improved_dual_adapter_errors	2007-04-26 09:18:12.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-04-26 09:31:38.000000000 -0500
@@ -953,6 +953,53 @@ static void ipr_process_ccn(struct ipr_c
 }
 
 /**
+ * strip_and_pad_whitespace - Strip and pad trailing whitespace.
+ * @i:		index into buffer
+ * @buf:		string to modify
+ *
+ * This function will strip all trailing whitespace, pad the end
+ * of the string with a single space, and NULL terminate the string.
+ *
+ * Return value:
+ * 	new length of string
+ **/
+static int strip_and_pad_whitespace(int i, char *buf)
+{
+	while (i && buf[i] == ' ')
+		i--;
+	buf[i+1] = ' ';
+	buf[i+2] = '\0';
+	return i + 2;
+}
+
+/**
+ * ipr_log_vpd_compact - Log the passed extended VPD compactly.
+ * @prefix:		string to print at start of printk
+ * @hostrcb:	hostrcb pointer
+ * @vpd:		vendor/product id/sn struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_vpd_compact(char *prefix, struct ipr_hostrcb *hostrcb,
+				struct ipr_vpd *vpd)
+{
+	char buffer[IPR_VENDOR_ID_LEN + IPR_PROD_ID_LEN + IPR_SERIAL_NUM_LEN + 3];
+	int i = 0;
+
+	memcpy(buffer, vpd->vpids.vendor_id, IPR_VENDOR_ID_LEN);
+	i = strip_and_pad_whitespace(IPR_VENDOR_ID_LEN - 1, buffer);
+
+	memcpy(&buffer[i], vpd->vpids.product_id, IPR_PROD_ID_LEN);
+	i = strip_and_pad_whitespace(i + IPR_PROD_ID_LEN - 1, buffer);
+
+	memcpy(&buffer[i], vpd->sn, IPR_SERIAL_NUM_LEN);
+	buffer[IPR_SERIAL_NUM_LEN + i] = '\0';
+
+	ipr_hcam_err(hostrcb, "%s VPID/SN: %s\n", prefix, buffer);
+}
+
+/**
  * ipr_log_vpd - Log the passed VPD to the error log.
  * @vpd:		vendor/product id/sn struct
  *
@@ -976,6 +1023,23 @@ static void ipr_log_vpd(struct ipr_vpd *
 }
 
 /**
+ * ipr_log_ext_vpd_compact - Log the passed extended VPD compactly.
+ * @prefix:		string to print at start of printk
+ * @hostrcb:	hostrcb pointer
+ * @vpd:		vendor/product id/sn/wwn struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_ext_vpd_compact(char *prefix, struct ipr_hostrcb *hostrcb,
+				    struct ipr_ext_vpd *vpd)
+{
+	ipr_log_vpd_compact(prefix, hostrcb, &vpd->vpd);
+	ipr_hcam_err(hostrcb, "%s WWN: %08X%08X\n", prefix,
+		     be32_to_cpu(vpd->wwid[0]), be32_to_cpu(vpd->wwid[1]));
+}
+
+/**
  * ipr_log_ext_vpd - Log the passed extended VPD to the error log.
  * @vpd:		vendor/product id/sn/wwn struct
  *
@@ -1289,10 +1353,11 @@ static void ipr_log_enhanced_dual_ioa_er
 
 	error = &hostrcb->hcam.u.error.u.type_17_error;
 	error->failure_reason[sizeof(error->failure_reason) - 1] = '\0';
+	strstrip(error->failure_reason);
 
-	ipr_err("%s\n", error->failure_reason);
-	ipr_err("Remote Adapter VPD:\n");
-	ipr_log_ext_vpd(&error->vpd);
+	ipr_hcam_err(hostrcb, "%s [PRC: %08X]\n", error->failure_reason,
+		     be32_to_cpu(hostrcb->hcam.u.error.prc));
+	ipr_log_ext_vpd_compact("Remote IOA", hostrcb, &error->vpd);
 	ipr_log_hex_data(ioa_cfg, error->data,
 			 be32_to_cpu(hostrcb->hcam.length) -
 			 (offsetof(struct ipr_hostrcb_error, u) +
@@ -1314,10 +1379,11 @@ static void ipr_log_dual_ioa_error(struc
 
 	error = &hostrcb->hcam.u.error.u.type_07_error;
 	error->failure_reason[sizeof(error->failure_reason) - 1] = '\0';
+	strstrip(error->failure_reason);
 
-	ipr_err("%s\n", error->failure_reason);
-	ipr_err("Remote Adapter VPD:\n");
-	ipr_log_vpd(&error->vpd);
+	ipr_hcam_err(hostrcb, "%s [PRC: %08X]\n", error->failure_reason,
+		     be32_to_cpu(hostrcb->hcam.u.error.prc));
+	ipr_log_vpd_compact("Remote IOA", hostrcb, &error->vpd);
 	ipr_log_hex_data(ioa_cfg, error->data,
 			 be32_to_cpu(hostrcb->hcam.length) -
 			 (offsetof(struct ipr_hostrcb_error, u) +
_
