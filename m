From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 06/13] lpfc: Add 64G link speed support
Date: Tue, 13 Feb 2018 11:34:50 -0800
Message-ID: <20180213193457.21206-7-jsmart2021@gmail.com>
References: <20180213193457.21206-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:36814 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965477AbeBMTfl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Feb 2018 14:35:41 -0500
Received: by mail-qt0-f195.google.com with SMTP id q18so4941221qtl.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Feb 2018 11:35:40 -0800 (PST)
In-Reply-To: <20180213193457.21206-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The G7 adapter supports 64G link speeds. Add support to the driver.

In addition, a small cleanup to replace the odd bitmap logic with
a switch case.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
v2:
  address review comment of typo in define name. Define wasn't used
  anywhere yet.
v3:
  reformat printf_log 0469
---
 drivers/scsi/lpfc/lpfc.h         | 14 +++------
 drivers/scsi/lpfc/lpfc_attr.c    | 62 ++++++++++++++++++++++++++++------------
 drivers/scsi/lpfc/lpfc_ct.c      |  5 ++++
 drivers/scsi/lpfc/lpfc_els.c     |  5 ++++
 drivers/scsi/lpfc/lpfc_hbadisc.c |  1 +
 drivers/scsi/lpfc/lpfc_hw.h      | 12 ++++++++
 drivers/scsi/lpfc/lpfc_hw4.h     |  3 ++
 drivers/scsi/lpfc/lpfc_init.c    | 17 +++++++++--
 drivers/scsi/lpfc/lpfc_mbox.c    |  4 +++
 9 files changed, 93 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index 86ffb9756e65..7aad4a717f13 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -544,16 +544,10 @@ struct unsol_rcv_ct_ctx {
 #define LPFC_USER_LINK_SPEED_10G	10	/* 10 Gigabaud */
 #define LPFC_USER_LINK_SPEED_16G	16	/* 16 Gigabaud */
 #define LPFC_USER_LINK_SPEED_32G	32	/* 32 Gigabaud */
-#define LPFC_USER_LINK_SPEED_MAX	LPFC_USER_LINK_SPEED_32G
-#define LPFC_USER_LINK_SPEED_BITMAP  ((1ULL << LPFC_USER_LINK_SPEED_32G) | \
-				     (1 << LPFC_USER_LINK_SPEED_16G) | \
-				     (1 << LPFC_USER_LINK_SPEED_10G) | \
-				     (1 << LPFC_USER_LINK_SPEED_8G) | \
-				     (1 << LPFC_USER_LINK_SPEED_4G) | \
-				     (1 << LPFC_USER_LINK_SPEED_2G) | \
-				     (1 << LPFC_USER_LINK_SPEED_1G) | \
-				     (1 << LPFC_USER_LINK_SPEED_AUTO))
-#define LPFC_LINK_SPEED_STRING "0, 1, 2, 4, 8, 10, 16, 32"
+#define LPFC_USER_LINK_SPEED_64G	64	/* 64 Gigabaud */
+#define LPFC_USER_LINK_SPEED_MAX	LPFC_USER_LINK_SPEED_64G
+
+#define LPFC_LINK_SPEED_STRING "0, 1, 2, 4, 8, 10, 16, 32, 64"
 
 enum nemb_type {
 	nemb_mse = 1,
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index e90d5066f66b..bbed20a39b25 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -4115,23 +4115,32 @@ lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
 	    ((val == LPFC_USER_LINK_SPEED_8G) && !(phba->lmt & LMT_8Gb)) ||
 	    ((val == LPFC_USER_LINK_SPEED_10G) && !(phba->lmt & LMT_10Gb)) ||
 	    ((val == LPFC_USER_LINK_SPEED_16G) && !(phba->lmt & LMT_16Gb)) ||
-	    ((val == LPFC_USER_LINK_SPEED_32G) && !(phba->lmt & LMT_32Gb))) {
+	    ((val == LPFC_USER_LINK_SPEED_32G) && !(phba->lmt & LMT_32Gb)) ||
+	    ((val == LPFC_USER_LINK_SPEED_64G) && !(phba->lmt & LMT_64Gb))) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2879 lpfc_link_speed attribute cannot be set "
 				"to %d. Speed is not supported by this port.\n",
 				val);
 		return -EINVAL;
 	}
-	if (val == LPFC_USER_LINK_SPEED_16G &&
-		 phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
+	if (val >= LPFC_USER_LINK_SPEED_16G &&
+	    phba->fc_topology == LPFC_TOPOLOGY_LOOP) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3112 lpfc_link_speed attribute cannot be set "
 				"to %d. Speed is not supported in loop mode.\n",
 				val);
 		return -EINVAL;
 	}
-	if ((val >= 0) && (val <= LPFC_USER_LINK_SPEED_MAX) &&
-	    (LPFC_USER_LINK_SPEED_BITMAP & (1 << val))) {
+
+	switch (val) {
+	case LPFC_USER_LINK_SPEED_AUTO:
+	case LPFC_USER_LINK_SPEED_1G:
+	case LPFC_USER_LINK_SPEED_2G:
+	case LPFC_USER_LINK_SPEED_4G:
+	case LPFC_USER_LINK_SPEED_8G:
+	case LPFC_USER_LINK_SPEED_16G:
+	case LPFC_USER_LINK_SPEED_32G:
+	case LPFC_USER_LINK_SPEED_64G:
 		prev_val = phba->cfg_link_speed;
 		phba->cfg_link_speed = val;
 		if (nolip)
@@ -4141,13 +4150,18 @@ lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
 		if (err) {
 			phba->cfg_link_speed = prev_val;
 			return -EINVAL;
-		} else
-			return strlen(buf);
+		}
+		return strlen(buf);
+	default:
+		break;
 	}
+
 	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-		"0469 lpfc_link_speed attribute cannot be set to %d, "
-		"allowed values are ["LPFC_LINK_SPEED_STRING"]\n", val);
+			"0469 lpfc_link_speed attribute cannot be set to %d, "
+			"allowed values are [%s]\n",
+			val, LPFC_LINK_SPEED_STRING);
 	return -EINVAL;
+
 }
 
 static int lpfc_link_speed = 0;
@@ -4174,24 +4188,33 @@ lpfc_param_show(link_speed)
 static int
 lpfc_link_speed_init(struct lpfc_hba *phba, int val)
 {
-	if (val == LPFC_USER_LINK_SPEED_16G && phba->cfg_topology == 4) {
+	if (val >= LPFC_USER_LINK_SPEED_16G && phba->cfg_topology == 4) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 			"3111 lpfc_link_speed of %d cannot "
 			"support loop mode, setting topology to default.\n",
 			 val);
 		phba->cfg_topology = 0;
 	}
-	if ((val >= 0) && (val <= LPFC_USER_LINK_SPEED_MAX) &&
-	    (LPFC_USER_LINK_SPEED_BITMAP & (1 << val))) {
+
+	switch (val) {
+	case LPFC_USER_LINK_SPEED_AUTO:
+	case LPFC_USER_LINK_SPEED_1G:
+	case LPFC_USER_LINK_SPEED_2G:
+	case LPFC_USER_LINK_SPEED_4G:
+	case LPFC_USER_LINK_SPEED_8G:
+	case LPFC_USER_LINK_SPEED_16G:
+	case LPFC_USER_LINK_SPEED_32G:
+	case LPFC_USER_LINK_SPEED_64G:
 		phba->cfg_link_speed = val;
 		return 0;
+	default:
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0405 lpfc_link_speed attribute cannot "
+				"be set to %d, allowed values are "
+				"["LPFC_LINK_SPEED_STRING"]\n", val);
+		phba->cfg_link_speed = LPFC_USER_LINK_SPEED_AUTO;
+		return -EINVAL;
 	}
-	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-			"0405 lpfc_link_speed attribute cannot "
-			"be set to %d, allowed values are "
-			"["LPFC_LINK_SPEED_STRING"]\n", val);
-	phba->cfg_link_speed = LPFC_USER_LINK_SPEED_AUTO;
-	return -EINVAL;
 }
 
 static DEVICE_ATTR_RW(lpfc_link_speed);
@@ -5720,6 +5743,9 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
 		case LPFC_LINK_SPEED_32GHZ:
 			fc_host_speed(shost) = FC_PORTSPEED_32GBIT;
 			break;
+		case LPFC_LINK_SPEED_64GHZ:
+			fc_host_speed(shost) = FC_PORTSPEED_64GBIT;
+			break;
 		default:
 			fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 			break;
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 9d20d2c208c7..03a7e13a049d 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2130,6 +2130,8 @@ lpfc_fdmi_port_attr_support_speed(struct lpfc_vport *vport,
 
 	ae->un.AttrInt = 0;
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
+		if (phba->lmt & LMT_64Gb)
+			ae->un.AttrInt |= HBA_PORTSPEED_64GFC;
 		if (phba->lmt & LMT_32Gb)
 			ae->un.AttrInt |= HBA_PORTSPEED_32GFC;
 		if (phba->lmt & LMT_16Gb)
@@ -2201,6 +2203,9 @@ lpfc_fdmi_port_attr_speed(struct lpfc_vport *vport,
 		case LPFC_LINK_SPEED_32GHZ:
 			ae->un.AttrInt = HBA_PORTSPEED_32GFC;
 			break;
+		case LPFC_LINK_SPEED_64GHZ:
+			ae->un.AttrInt = HBA_PORTSPEED_64GFC;
+			break;
 		default:
 			ae->un.AttrInt = HBA_PORTSPEED_UNKNOWN;
 			break;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index ba896554a14f..09e4eb9fbc69 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5270,6 +5270,9 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 	case LPFC_LINK_SPEED_32GHZ:
 		rdp_speed = RDP_PS_32GB;
 		break;
+	case LPFC_LINK_SPEED_64GHZ:
+		rdp_speed = RDP_PS_64GB;
+		break;
 	default:
 		rdp_speed = RDP_PS_UNKNOWN;
 		break;
@@ -5277,6 +5280,8 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 
 	desc->info.port_speed.speed = cpu_to_be16(rdp_speed);
 
+	if (phba->lmt & LMT_64Gb)
+		rdp_cap |= RDP_PS_64GB;
 	if (phba->lmt & LMT_32Gb)
 		rdp_cap |= RDP_PS_32GB;
 	if (phba->lmt & LMT_16Gb)
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f5bbac3cadbb..7855afa13568 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3084,6 +3084,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 		case LPFC_LINK_SPEED_10GHZ:
 		case LPFC_LINK_SPEED_16GHZ:
 		case LPFC_LINK_SPEED_32GHZ:
+		case LPFC_LINK_SPEED_64GHZ:
 			break;
 		default:
 			phba->fc_linkspeed = LPFC_LINK_SPEED_UNKNOWN;
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index d07d2fcbea34..cf83322cd4fe 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1177,6 +1177,9 @@ struct fc_rdp_link_error_status_desc {
 #define RDP_PS_8GB             0x0800
 #define RDP_PS_16GB            0x0400
 #define RDP_PS_32GB            0x0200
+#define RDP_PS_64GB            0x0100
+#define RDP_PS_128GB           0x0080
+#define RDP_PS_256GB           0x0040
 
 #define RDP_CAP_USER_CONFIGURED 0x0002
 #define RDP_CAP_UNKNOWN         0x0001
@@ -2258,6 +2261,9 @@ typedef struct {
 #define LINK_SPEED_10G  0x10    /* 10 Gigabaud */
 #define LINK_SPEED_16G  0x11    /* 16 Gigabaud */
 #define LINK_SPEED_32G  0x14    /* 32 Gigabaud */
+#define LINK_SPEED_64G  0x17    /* 64 Gigabaud */
+#define LINK_SPEED_128G 0x1A    /* 128 Gigabaud */
+#define LINK_SPEED_256G 0x1D    /* 256 Gigabaud */
 
 } INIT_LINK_VAR;
 
@@ -2442,6 +2448,9 @@ typedef struct {
 #define LMT_10Gb      0x100
 #define LMT_16Gb      0x200
 #define LMT_32Gb      0x400
+#define LMT_64Gb      0x800
+#define LMT_128Gb     0x1000
+#define LMT_256Gb     0x2000
 	uint32_t rsvd2;
 	uint32_t rsvd3;
 	uint32_t max_xri;
@@ -2966,6 +2975,9 @@ struct lpfc_mbx_read_top {
 #define LPFC_LINK_SPEED_10GHZ	0x40
 #define LPFC_LINK_SPEED_16GHZ	0x80
 #define LPFC_LINK_SPEED_32GHZ	0x90
+#define LPFC_LINK_SPEED_64GHZ	0xA0
+#define LPFC_LINK_SPEED_128GHZ	0xB0
+#define LPFC_LINK_SPEED_256GHZ	0xC0
 };
 
 /* Structure for MB Command CLEAR_LA (22) */
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index 60ccff6fa8b0..0c33510fe75c 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3961,6 +3961,9 @@ struct lpfc_acqe_fc_la {
 #define LPFC_FC_LA_SPEED_10G		0xA
 #define LPFC_FC_LA_SPEED_16G		0x10
 #define LPFC_FC_LA_SPEED_32G            0x20
+#define LPFC_FC_LA_SPEED_64G            0x21
+#define LPFC_FC_LA_SPEED_128G           0x22
+#define LPFC_FC_LA_SPEED_256G           0x23
 #define lpfc_acqe_fc_la_topology_SHIFT		16
 #define lpfc_acqe_fc_la_topology_MASK		0x000000FF
 #define lpfc_acqe_fc_la_topology_WORD		word0
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4ae32a764f4b..0666f91bbbe1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -731,7 +731,9 @@ lpfc_hba_init_link_fc_topology(struct lpfc_hba *phba, uint32_t fc_topology,
 	    ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_16G) &&
 	     !(phba->lmt & LMT_16Gb)) ||
 	    ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_32G) &&
-	     !(phba->lmt & LMT_32Gb))) {
+	     !(phba->lmt & LMT_32Gb)) ||
+	    ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_64G) &&
+	     !(phba->lmt & LMT_64Gb))) {
 		/* Reset link speed to auto */
 		lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 			"1302 Invalid speed for this board:%d "
@@ -2274,7 +2276,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 		&& descp && descp[0] != '\0')
 		return;
 
-	if (phba->lmt & LMT_32Gb)
+	if (phba->lmt & LMT_64Gb)
+		max_speed = 64;
+	else if (phba->lmt & LMT_32Gb)
 		max_speed = 32;
 	else if (phba->lmt & LMT_16Gb)
 		max_speed = 16;
@@ -4112,6 +4116,8 @@ void lpfc_host_attrib_init(struct Scsi_Host *shost)
 				 sizeof fc_host_symbolic_name(shost));
 
 	fc_host_supported_speeds(shost) = 0;
+	if (phba->lmt & LMT_64Gb)
+		fc_host_supported_speeds(shost) |= FC_PORTSPEED_64GBIT;
 	if (phba->lmt & LMT_32Gb)
 		fc_host_supported_speeds(shost) |= FC_PORTSPEED_32GBIT;
 	if (phba->lmt & LMT_16Gb)
@@ -4448,6 +4454,9 @@ lpfc_sli4_port_speed_parse(struct lpfc_hba *phba, uint32_t evt_code,
 		case LPFC_FC_LA_SPEED_32G:
 			port_speed = 32000;
 			break;
+		case LPFC_FC_LA_SPEED_64G:
+			port_speed = 64000;
+			break;
 		default:
 			port_speed = 0;
 		}
@@ -7814,6 +7823,10 @@ lpfc_sli4_read_config(struct lpfc_hba *phba)
 				phba->cfg_link_speed =
 					LPFC_USER_LINK_SPEED_32G;
 				break;
+			case LINK_SPEED_64G:
+				phba->cfg_link_speed =
+					LPFC_USER_LINK_SPEED_64G;
+				break;
 			case 0xffff:
 				phba->cfg_link_speed =
 					LPFC_USER_LINK_SPEED_AUTO;
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 7313ceb0f23b..47c02da11f01 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -557,6 +557,10 @@ lpfc_init_link(struct lpfc_hba * phba,
 			mb->un.varInitLnk.link_flags |= FLAGS_LINK_SPEED;
 			mb->un.varInitLnk.link_speed = LINK_SPEED_32G;
 			break;
+		case LPFC_USER_LINK_SPEED_64G:
+			mb->un.varInitLnk.link_flags |= FLAGS_LINK_SPEED;
+			mb->un.varInitLnk.link_speed = LINK_SPEED_64G;
+			break;
 		case LPFC_USER_LINK_SPEED_AUTO:
 		default:
 			mb->un.varInitLnk.link_speed = LINK_SPEED_AUTO;
-- 
2.13.1
