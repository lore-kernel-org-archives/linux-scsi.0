From: Brian King <brking@us.ibm.com>
Subject: [PATCH 07/10] ipr: Add support for logging SAS fabric errors
Date: Tue, 21 Nov 2006 10:28:35 -0600
Message-ID: <200611211628.kALGSZeH017537@d03av03.boulder.ibm.com>
References: <11641264771784-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:63426 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1031057AbWKUQ2r
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 11:28:47 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALGSkuP003145
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:46 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALGSb6K346864
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:28:37 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALGSasB017588
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:28:36 -0700
In-Reply-To: <11641264771784-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Adds support for logging SAS fabric errors logged by
the ipr firmware.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |  225 +++++++++++++++++++++++++++++++++--
 linux-2.6-bjking1/drivers/scsi/ipr.h |   72 +++++++++++
 2 files changed, 290 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_sas_fabric_errors drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_sas_fabric_errors	2006-11-15 17:04:03.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2006-11-16 12:35:31.000000000 -0600
@@ -737,6 +737,64 @@ struct ipr_hostrcb_type_17_error {
 	u32 data[476];
 }__attribute__((packed, aligned (4)));
 
+struct ipr_hostrcb_config_element {
+	u8 type_status;
+#define IPR_PATH_CFG_TYPE_MASK	0xF0
+#define IPR_PATH_CFG_NOT_EXIST	0x00
+#define IPR_PATH_CFG_IOA_PORT		0x10
+#define IPR_PATH_CFG_EXP_PORT		0x20
+#define IPR_PATH_CFG_DEVICE_PORT	0x30
+#define IPR_PATH_CFG_DEVICE_LUN	0x40
+
+#define IPR_PATH_CFG_STATUS_MASK	0x0F
+#define IPR_PATH_CFG_NO_PROB		0x00
+#define IPR_PATH_CFG_DEGRADED		0x01
+#define IPR_PATH_CFG_FAILED		0x02
+#define IPR_PATH_CFG_SUSPECT		0x03
+#define IPR_PATH_NOT_DETECTED		0x04
+#define IPR_PATH_INCORRECT_CONN	0x05
+
+	u8 cascaded_expander;
+	u8 phy;
+	u8 link_rate;
+#define IPR_PHY_LINK_RATE_MASK	0x0F
+
+	__be32 wwid[2];
+}__attribute__((packed, aligned (4)));
+
+struct ipr_hostrcb_fabric_desc {
+	__be16 length;
+	u8 ioa_port;
+	u8 cascaded_expander;
+	u8 phy;
+	u8 path_state;
+#define IPR_PATH_ACTIVE_MASK		0xC0
+#define IPR_PATH_NO_INFO		0x00
+#define IPR_PATH_ACTIVE			0x40
+#define IPR_PATH_NOT_ACTIVE		0x80
+
+#define IPR_PATH_STATE_MASK		0x0F
+#define IPR_PATH_STATE_NO_INFO	0x00
+#define IPR_PATH_HEALTHY		0x01
+#define IPR_PATH_DEGRADED		0x02
+#define IPR_PATH_FAILED			0x03
+
+	__be16 num_entries;
+	struct ipr_hostrcb_config_element elem[1];
+}__attribute__((packed, aligned (4)));
+
+#define for_each_fabric_cfg(fabric, cfg) \
+		for (cfg = (fabric)->elem; \
+			cfg < ((fabric)->elem + be16_to_cpu((fabric)->num_entries)); \
+			cfg++)
+
+struct ipr_hostrcb_type_20_error {
+	u8 failure_reason[64];
+	u8 reserved[3];
+	u8 num_entries;
+	struct ipr_hostrcb_fabric_desc desc[1];
+}__attribute__((packed, aligned (4)));
+
 struct ipr_hostrcb_error {
 	__be32 failing_dev_ioasc;
 	struct ipr_res_addr failing_dev_res_addr;
@@ -753,6 +811,7 @@ struct ipr_hostrcb_error {
 		struct ipr_hostrcb_type_13_error type_13_error;
 		struct ipr_hostrcb_type_14_error type_14_error;
 		struct ipr_hostrcb_type_17_error type_17_error;
+		struct ipr_hostrcb_type_20_error type_20_error;
 	} u;
 }__attribute__((packed, aligned (4)));
 
@@ -792,6 +851,7 @@ struct ipr_hcam {
 #define IPR_HOST_RCB_OVERLAY_ID_14				0x14
 #define IPR_HOST_RCB_OVERLAY_ID_16				0x16
 #define IPR_HOST_RCB_OVERLAY_ID_17				0x17
+#define IPR_HOST_RCB_OVERLAY_ID_20				0x20
 #define IPR_HOST_RCB_OVERLAY_ID_DEFAULT			0xFF
 
 	u8 reserved1[3];
@@ -811,6 +871,7 @@ struct ipr_hostrcb {
 	struct ipr_hcam hcam;
 	dma_addr_t hostrcb_dma;
 	struct list_head queue;
+	struct ipr_ioa_cfg *ioa_cfg;
 };
 
 /* IPR smart dump table structures */
@@ -1289,6 +1350,17 @@ struct ipr_ucode_image_header {
 	}								\
 }
 
+#define ipr_hcam_err(hostrcb, fmt, ...)					\
+{													\
+	if (ipr_is_device(&(hostrcb)->hcam.u.error.failing_dev_res_addr)) {		\
+		ipr_ra_err((hostrcb)->ioa_cfg,							\
+				(hostrcb)->hcam.u.error.failing_dev_res_addr,			\
+				fmt, ##__VA_ARGS__);							\
+	} else {											\
+		dev_err(&(hostrcb)->ioa_cfg->pdev->dev, fmt, ##__VA_ARGS__);		\
+	}												\
+}
+
 #define ipr_trace ipr_dbg("%s: %s: Line: %d\n",\
 	__FILE__, __FUNCTION__, __LINE__)
 
diff -puN drivers/scsi/ipr.c~ipr_sas_fabric_errors drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_sas_fabric_errors	2006-11-15 17:04:03.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-11-16 12:36:18.000000000 -0600
@@ -1321,6 +1321,219 @@ static void ipr_log_dual_ioa_error(struc
 			  offsetof(struct ipr_hostrcb_type_07_error, data)));
 }
 
+static const struct {
+	u8 active;
+	char *desc;
+} path_active_desc[] = {
+	{ IPR_PATH_NO_INFO, "Path" },
+	{ IPR_PATH_ACTIVE, "Active path" },
+	{ IPR_PATH_NOT_ACTIVE, "Inactive path" }
+};
+
+static const struct {
+	u8 state;
+	char *desc;
+} path_state_desc[] = {
+	{ IPR_PATH_STATE_NO_INFO, "has no path state information available" },
+	{ IPR_PATH_HEALTHY, "is healthy" },
+	{ IPR_PATH_DEGRADED, "is degraded" },
+	{ IPR_PATH_FAILED, "is failed" }
+};
+
+/**
+ * ipr_log_fabric_path - Log a fabric path error
+ * @hostrcb:	hostrcb struct
+ * @fabric:		fabric descriptor
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_fabric_path(struct ipr_hostrcb *hostrcb,
+				struct ipr_hostrcb_fabric_desc *fabric)
+{
+	int i, j;
+	u8 path_state = fabric->path_state;
+	u8 active = path_state & IPR_PATH_ACTIVE_MASK;
+	u8 state = path_state & IPR_PATH_STATE_MASK;
+
+	for (i = 0; i < ARRAY_SIZE(path_active_desc); i++) {
+		if (path_active_desc[i].active != active)
+			continue;
+
+		for (j = 0; j < ARRAY_SIZE(path_state_desc); j++) {
+			if (path_state_desc[j].state != state)
+				continue;
+
+			if (fabric->cascaded_expander == 0xff && fabric->phy == 0xff) {
+				ipr_hcam_err(hostrcb, "%s %s: IOA Port=%d\n",
+					     path_active_desc[i].desc, path_state_desc[j].desc,
+					     fabric->ioa_port);
+			} else if (fabric->cascaded_expander == 0xff) {
+				ipr_hcam_err(hostrcb, "%s %s: IOA Port=%d, Phy=%d\n",
+					     path_active_desc[i].desc, path_state_desc[j].desc,
+					     fabric->ioa_port, fabric->phy);
+			} else if (fabric->phy == 0xff) {
+				ipr_hcam_err(hostrcb, "%s %s: IOA Port=%d, Cascade=%d\n",
+					     path_active_desc[i].desc, path_state_desc[j].desc,
+					     fabric->ioa_port, fabric->cascaded_expander);
+			} else {
+				ipr_hcam_err(hostrcb, "%s %s: IOA Port=%d, Cascade=%d, Phy=%d\n",
+					     path_active_desc[i].desc, path_state_desc[j].desc,
+					     fabric->ioa_port, fabric->cascaded_expander, fabric->phy);
+			}
+			return;
+		}
+	}
+
+	ipr_err("Path state=%02X IOA Port=%d Cascade=%d Phy=%d\n", path_state,
+		fabric->ioa_port, fabric->cascaded_expander, fabric->phy);
+}
+
+static const struct {
+	u8 type;
+	char *desc;
+} path_type_desc[] = {
+	{ IPR_PATH_CFG_IOA_PORT, "IOA port" },
+	{ IPR_PATH_CFG_EXP_PORT, "Expander port" },
+	{ IPR_PATH_CFG_DEVICE_PORT, "Device port" },
+	{ IPR_PATH_CFG_DEVICE_LUN, "Device LUN" }
+};
+
+static const struct {
+	u8 status;
+	char *desc;
+} path_status_desc[] = {
+	{ IPR_PATH_CFG_NO_PROB, "Functional" },
+	{ IPR_PATH_CFG_DEGRADED, "Degraded" },
+	{ IPR_PATH_CFG_FAILED, "Failed" },
+	{ IPR_PATH_CFG_SUSPECT, "Suspect" },
+	{ IPR_PATH_NOT_DETECTED, "Missing" },
+	{ IPR_PATH_INCORRECT_CONN, "Incorrectly connected" }
+};
+
+static const char *link_rate[] = {
+	"unknown",
+	"disabled",
+	"phy reset problem",
+	"spinup hold",
+	"port selector",
+	"unknown",
+	"unknown",
+	"unknown",
+	"1.5Gbps",
+	"3.0Gbps",
+	"unknown",
+	"unknown",
+	"unknown",
+	"unknown",
+	"unknown",
+	"unknown"
+};
+
+/**
+ * ipr_log_path_elem - Log a fabric path element.
+ * @hostrcb:	hostrcb struct
+ * @cfg:		fabric path element struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_path_elem(struct ipr_hostrcb *hostrcb,
+			      struct ipr_hostrcb_config_element *cfg)
+{
+	int i, j;
+	u8 type = cfg->type_status & IPR_PATH_CFG_TYPE_MASK;
+	u8 status = cfg->type_status & IPR_PATH_CFG_STATUS_MASK;
+
+	if (type == IPR_PATH_CFG_NOT_EXIST)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(path_type_desc); i++) {
+		if (path_type_desc[i].type != type)
+			continue;
+
+		for (j = 0; j < ARRAY_SIZE(path_status_desc); j++) {
+			if (path_status_desc[j].status != status)
+				continue;
+
+			if (type == IPR_PATH_CFG_IOA_PORT) {
+				ipr_hcam_err(hostrcb, "%s %s: Phy=%d, Link rate=%s, WWN=%08X%08X\n",
+					     path_status_desc[j].desc, path_type_desc[i].desc,
+					     cfg->phy, link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
+					     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
+			} else {
+				if (cfg->cascaded_expander == 0xff && cfg->phy == 0xff) {
+					ipr_hcam_err(hostrcb, "%s %s: Link rate=%s, WWN=%08X%08X\n",
+						     path_status_desc[j].desc, path_type_desc[i].desc,
+						     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
+						     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
+				} else if (cfg->cascaded_expander == 0xff) {
+					ipr_hcam_err(hostrcb, "%s %s: Phy=%d, Link rate=%s, "
+						     "WWN=%08X%08X\n", path_status_desc[j].desc,
+						     path_type_desc[i].desc, cfg->phy,
+						     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
+						     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
+				} else if (cfg->phy == 0xff) {
+					ipr_hcam_err(hostrcb, "%s %s: Cascade=%d, Link rate=%s, "
+						     "WWN=%08X%08X\n", path_status_desc[j].desc,
+						     path_type_desc[i].desc, cfg->cascaded_expander,
+						     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
+						     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
+				} else {
+					ipr_hcam_err(hostrcb, "%s %s: Cascade=%d, Phy=%d, Link rate=%s "
+						     "WWN=%08X%08X\n", path_status_desc[j].desc,
+						     path_type_desc[i].desc, cfg->cascaded_expander, cfg->phy,
+						     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
+						     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
+				}
+			}
+			return;
+		}
+	}
+
+	ipr_hcam_err(hostrcb, "Path element=%02X: Cascade=%d Phy=%d Link rate=%s "
+		     "WWN=%08X%08X\n", cfg->type_status, cfg->cascaded_expander, cfg->phy,
+		     link_rate[cfg->link_rate & IPR_PHY_LINK_RATE_MASK],
+		     be32_to_cpu(cfg->wwid[0]), be32_to_cpu(cfg->wwid[1]));
+}
+
+/**
+ * ipr_log_fabric_error - Log a fabric error.
+ * @ioa_cfg:	ioa config struct
+ * @hostrcb:	hostrcb struct
+ *
+ * Return value:
+ * 	none
+ **/
+static void ipr_log_fabric_error(struct ipr_ioa_cfg *ioa_cfg,
+				 struct ipr_hostrcb *hostrcb)
+{
+	struct ipr_hostrcb_type_20_error *error;
+	struct ipr_hostrcb_fabric_desc *fabric;
+	struct ipr_hostrcb_config_element *cfg;
+	int i, add_len;
+
+	error = &hostrcb->hcam.u.error.u.type_20_error;
+	error->failure_reason[sizeof(error->failure_reason) - 1] = '\0';
+	ipr_hcam_err(hostrcb, "%s\n", error->failure_reason);
+
+	add_len = be32_to_cpu(hostrcb->hcam.length) -
+		(offsetof(struct ipr_hostrcb_error, u) +
+		 offsetof(struct ipr_hostrcb_type_20_error, desc));
+
+	for (i = 0, fabric = error->desc; i < error->num_entries; i++) {
+		ipr_log_fabric_path(hostrcb, fabric);
+		for_each_fabric_cfg(fabric, cfg)
+			ipr_log_path_elem(hostrcb, cfg);
+
+		add_len -= be16_to_cpu(fabric->length);
+		fabric = (struct ipr_hostrcb_fabric_desc *)
+			((unsigned long)fabric + be16_to_cpu(fabric->length));
+	}
+
+	ipr_log_hex_data((u32 *)fabric, add_len);
+}
+
 /**
  * ipr_log_generic_error - Log an adapter error.
  * @ioa_cfg:	ioa config struct
@@ -1394,13 +1607,7 @@ static void ipr_handle_log_data(struct i
 	if (!ipr_error_table[error_index].log_hcam)
 		return;
 
-	if (ipr_is_device(&hostrcb->hcam.u.error.failing_dev_res_addr)) {
-		ipr_ra_err(ioa_cfg, hostrcb->hcam.u.error.failing_dev_res_addr,
-			   "%s\n", ipr_error_table[error_index].error);
-	} else {
-		dev_err(&ioa_cfg->pdev->dev, "%s\n",
-			ipr_error_table[error_index].error);
-	}
+	ipr_hcam_err(hostrcb, "%s\n", ipr_error_table[error_index].error);
 
 	/* Set indication we have logged an error */
 	ioa_cfg->errors_logged++;
@@ -1437,6 +1644,9 @@ static void ipr_handle_log_data(struct i
 	case IPR_HOST_RCB_OVERLAY_ID_17:
 		ipr_log_enhanced_dual_ioa_error(ioa_cfg, hostrcb);
 		break;
+	case IPR_HOST_RCB_OVERLAY_ID_20:
+		ipr_log_fabric_error(ioa_cfg, hostrcb);
+		break;
 	case IPR_HOST_RCB_OVERLAY_ID_1:
 	case IPR_HOST_RCB_OVERLAY_ID_DEFAULT:
 	default:
@@ -6812,6 +7022,7 @@ static int __devinit ipr_alloc_mem(struc
 
 		ioa_cfg->hostrcb[i]->hostrcb_dma =
 			ioa_cfg->hostrcb_dma[i] + offsetof(struct ipr_hostrcb, hcam);
+		ioa_cfg->hostrcb[i]->ioa_cfg = ioa_cfg;
 		list_add_tail(&ioa_cfg->hostrcb[i]->queue, &ioa_cfg->hostrcb_free_q);
 	}
 
_
