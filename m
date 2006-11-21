From: Brian King <brking@us.ibm.com>
Subject: [PATCH 08/10] ipr: Reduce default error log size
Date: Tue, 21 Nov 2006 10:28:42 -0600
Message-ID: <200611211628.kALGSggq020098@d03av02.boulder.ibm.com>
References: <11641264771784-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:42391 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S1031055AbWKUQ2o
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 11:28:44 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALGShfZ002357
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:43 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALGShKO460116
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:28:43 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALGSg11020111
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:28:43 -0700
In-Reply-To: <11641264771784-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Since the default error log size has increased on SAS adapters,
prevent ipr from logging this additional data unless requested
to do so by the user set log level in order to prevent flooding
the logs.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   14 +++++++++-----
 linux-2.6-bjking1/drivers/scsi/ipr.h |    1 +
 2 files changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_reduce_error_log_size drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_reduce_error_log_size	2006-11-20 08:54:05.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-11-21 09:05:34.000000000 -0600
@@ -1249,19 +1249,23 @@ static void ipr_log_array_error(struct i
 
 /**
  * ipr_log_hex_data - Log additional hex IOA error data.
+ * @ioa_cfg:	ioa config struct
  * @data:		IOA error data
  * @len:		data length
  *
  * Return value:
  * 	none
  **/
-static void ipr_log_hex_data(u32 *data, int len)
+static void ipr_log_hex_data(struct ipr_ioa_cfg *ioa_cfg, u32 *data, int len)
 {
 	int i;
 
 	if (len == 0)
 		return;
 
+	if (ioa_cfg->log_level <= IPR_DEFAULT_LOG_LEVEL)
+		len = min_t(int, len, IPR_DEFAULT_MAX_ERROR_DUMP);
+
 	for (i = 0; i < len / 4; i += 4) {
 		ipr_err("%08X: %08X %08X %08X %08X\n", i*4,
 			be32_to_cpu(data[i]),
@@ -1290,7 +1294,7 @@ static void ipr_log_enhanced_dual_ioa_er
 	ipr_err("%s\n", error->failure_reason);
 	ipr_err("Remote Adapter VPD:\n");
 	ipr_log_ext_vpd(&error->vpd);
-	ipr_log_hex_data(error->data,
+	ipr_log_hex_data(ioa_cfg, error->data,
 			 be32_to_cpu(hostrcb->hcam.length) -
 			 (offsetof(struct ipr_hostrcb_error, u) +
 			  offsetof(struct ipr_hostrcb_type_17_error, data)));
@@ -1315,7 +1319,7 @@ static void ipr_log_dual_ioa_error(struc
 	ipr_err("%s\n", error->failure_reason);
 	ipr_err("Remote Adapter VPD:\n");
 	ipr_log_vpd(&error->vpd);
-	ipr_log_hex_data(error->data,
+	ipr_log_hex_data(ioa_cfg, error->data,
 			 be32_to_cpu(hostrcb->hcam.length) -
 			 (offsetof(struct ipr_hostrcb_error, u) +
 			  offsetof(struct ipr_hostrcb_type_07_error, data)));
@@ -1531,7 +1535,7 @@ static void ipr_log_fabric_error(struct 
 			((unsigned long)fabric + be16_to_cpu(fabric->length));
 	}
 
-	ipr_log_hex_data((u32 *)fabric, add_len);
+	ipr_log_hex_data(ioa_cfg, (u32 *)fabric, add_len);
 }
 
 /**
@@ -1545,7 +1549,7 @@ static void ipr_log_fabric_error(struct 
 static void ipr_log_generic_error(struct ipr_ioa_cfg *ioa_cfg,
 				  struct ipr_hostrcb *hostrcb)
 {
-	ipr_log_hex_data(hostrcb->hcam.u.raw.data,
+	ipr_log_hex_data(ioa_cfg, hostrcb->hcam.u.raw.data,
 			 be32_to_cpu(hostrcb->hcam.length));
 }
 
diff -puN drivers/scsi/ipr.h~ipr_reduce_error_log_size drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_reduce_error_log_size	2006-11-20 08:54:05.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2006-11-21 09:05:34.000000000 -0600
@@ -104,6 +104,7 @@
 #define IPR_IOASC_IOA_WAS_RESET			0x10000001
 #define IPR_IOASC_PCI_ACCESS_ERROR			0x10000002
 
+#define IPR_DEFAULT_MAX_ERROR_DUMP			984
 #define IPR_NUM_LOG_HCAMS				2
 #define IPR_NUM_CFG_CHG_HCAMS				2
 #define IPR_NUM_HCAMS	(IPR_NUM_LOG_HCAMS + IPR_NUM_CFG_CHG_HCAMS)
_
