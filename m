From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 10/14] lpfc: Add support for Lancer G6 and 32G FC links
Date: Mon, 31 Aug 2015 16:48:17 -0400
Message-ID: <55e4bd91.+BVn7eyDWj+myRox%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f178.google.com ([209.85.220.178]:34560 "EHLO
	mail-qk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbHaUse (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:34 -0400
Received: by qkct7 with SMTP id t7so16745433qkc.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:33 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id m75sm4560754qki.21.2015.08.31.13.48.32
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add support for Lancer G6 and 32G FC links

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc.h         |  8 +++++---
 drivers/scsi/lpfc/lpfc_attr.c    | 17 +++++++++++++----
 drivers/scsi/lpfc/lpfc_ct.c      |  6 ++++++
 drivers/scsi/lpfc/lpfc_els.c     |  2 ++
 drivers/scsi/lpfc/lpfc_hbadisc.c |  1 +
 drivers/scsi/lpfc/lpfc_hw.h      |  4 ++++
 drivers/scsi/lpfc/lpfc_init.c    | 18 ++++++++++++++++--
 drivers/scsi/lpfc/lpfc_mbox.c    | 11 +++++++++++
 8 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index a5a56fa..ceee9a3 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -495,15 +495,17 @@ struct unsol_rcv_ct_ctx {
 #define LPFC_USER_LINK_SPEED_8G		8	/* 8 Gigabaud */
 #define LPFC_USER_LINK_SPEED_10G	10	/* 10 Gigabaud */
 #define LPFC_USER_LINK_SPEED_16G	16	/* 16 Gigabaud */
-#define LPFC_USER_LINK_SPEED_MAX	LPFC_USER_LINK_SPEED_16G
-#define LPFC_USER_LINK_SPEED_BITMAP ((1 << LPFC_USER_LINK_SPEED_16G) | \
+#define LPFC_USER_LINK_SPEED_32G	32	/* 32 Gigabaud */
+#define LPFC_USER_LINK_SPEED_MAX	LPFC_USER_LINK_SPEED_32G
+#define LPFC_USER_LINK_SPEED_BITMAP  ((1ULL << LPFC_USER_LINK_SPEED_32G) | \
+				     (1 << LPFC_USER_LINK_SPEED_16G) | \
 				     (1 << LPFC_USER_LINK_SPEED_10G) | \
 				     (1 << LPFC_USER_LINK_SPEED_8G) | \
 				     (1 << LPFC_USER_LINK_SPEED_4G) | \
 				     (1 << LPFC_USER_LINK_SPEED_2G) | \
 				     (1 << LPFC_USER_LINK_SPEED_1G) | \
 				     (1 << LPFC_USER_LINK_SPEED_AUTO))
-#define LPFC_LINK_SPEED_STRING "0, 1, 2, 4, 8, 10, 16"
+#define LPFC_LINK_SPEED_STRING "0, 1, 2, 4, 8, 10, 16, 32"
 
 enum nemb_type {
 	nemb_mse = 1,
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 3c6cc9d..f6446d7 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -3276,15 +3276,20 @@ lpfc_topology_store(struct device *dev, struct device_attribute *attr,
 
 	if (val >= 0 && val <= 6) {
 		prev_val = phba->cfg_topology;
-		phba->cfg_topology = val;
 		if (phba->cfg_link_speed == LPFC_USER_LINK_SPEED_16G &&
 			val == 4) {
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
 				"3113 Loop mode not supported at speed %d\n",
-				phba->cfg_link_speed);
-			phba->cfg_topology = prev_val;
+				val);
 			return -EINVAL;
 		}
+		if (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC &&
+			val == 4) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_INIT,
+				"3114 Loop mode not supported\n");
+			return -EINVAL;
+		}
+		phba->cfg_topology = val;
 		if (nolip)
 			return strlen(buf);
 
@@ -3725,7 +3730,8 @@ lpfc_link_speed_store(struct device *dev, struct device_attribute *attr,
 	    ((val == LPFC_USER_LINK_SPEED_4G) && !(phba->lmt & LMT_4Gb)) ||
 	    ((val == LPFC_USER_LINK_SPEED_8G) && !(phba->lmt & LMT_8Gb)) ||
 	    ((val == LPFC_USER_LINK_SPEED_10G) && !(phba->lmt & LMT_10Gb)) ||
-	    ((val == LPFC_USER_LINK_SPEED_16G) && !(phba->lmt & LMT_16Gb))) {
+	    ((val == LPFC_USER_LINK_SPEED_16G) && !(phba->lmt & LMT_16Gb)) ||
+	    ((val == LPFC_USER_LINK_SPEED_32G) && !(phba->lmt & LMT_32Gb))) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"2879 lpfc_link_speed attribute cannot be set "
 				"to %d. Speed is not supported by this port.\n",
@@ -5261,6 +5267,9 @@ lpfc_get_host_speed(struct Scsi_Host *shost)
 		case LPFC_LINK_SPEED_16GHZ:
 			fc_host_speed(shost) = FC_PORTSPEED_16GBIT;
 			break;
+		case LPFC_LINK_SPEED_32GHZ:
+			fc_host_speed(shost) = FC_PORTSPEED_32GBIT;
+			break;
 		default:
 			fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
 			break;
diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index aaf1cd74..8fded1f 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -55,6 +55,7 @@
 #define HBA_PORTSPEED_10GBIT		0x0004	/* 10 GBit/sec */
 #define HBA_PORTSPEED_8GBIT		0x0010	/* 8 GBit/sec */
 #define HBA_PORTSPEED_16GBIT		0x0020	/* 16 GBit/sec */
+#define HBA_PORTSPEED_32GBIT		0x0040  /* 32 GBit/sec */
 #define HBA_PORTSPEED_UNKNOWN		0x0800	/* Unknown */
 
 #define FOURBYTES	4
@@ -1773,6 +1774,8 @@ hba_out:
 			ad->AttrType = cpu_to_be16(RPRT_SUPPORTED_SPEED);
 			ad->AttrLen = cpu_to_be16(FOURBYTES + 4);
 			ae->un.SupportSpeed = 0;
+			if (phba->lmt & LMT_32Gb)
+				ae->un.SupportSpeed |= HBA_PORTSPEED_32GBIT;
 			if (phba->lmt & LMT_16Gb)
 				ae->un.SupportSpeed |= HBA_PORTSPEED_16GBIT;
 			if (phba->lmt & LMT_10Gb)
@@ -1816,6 +1819,9 @@ hba_out:
 			case LPFC_LINK_SPEED_16GHZ:
 				ae->un.PortSpeed = HBA_PORTSPEED_16GBIT;
 				break;
+			case LPFC_LINK_SPEED_32GHZ:
+				ae->un.PortSpeed = HBA_PORTSPEED_32GBIT;
+				break;
 			default:
 				ae->un.PortSpeed = HBA_PORTSPEED_UNKNOWN;
 				break;
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f9c957d..598313d 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4705,6 +4705,8 @@ lpfc_rdp_res_speed(struct fc_rdp_port_speed_desc *desc, struct lpfc_hba *phba)
 
 	desc->info.port_speed.speed = cpu_to_be16(rdp_speed);
 
+	if (phba->lmt & LMT_32Gb)
+		rdp_cap |= RDP_PS_32GB;
 	if (phba->lmt & LMT_16Gb)
 		rdp_cap |= RDP_PS_16GB;
 	if (phba->lmt & LMT_10Gb)
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 71b9044..614d8e9 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -3029,6 +3029,7 @@ lpfc_mbx_process_link_up(struct lpfc_hba *phba, struct lpfc_mbx_read_top *la)
 	case LPFC_LINK_SPEED_8GHZ:
 	case LPFC_LINK_SPEED_10GHZ:
 	case LPFC_LINK_SPEED_16GHZ:
+	case LPFC_LINK_SPEED_32GHZ:
 		phba->fc_linkspeed = bf_get(lpfc_mbx_read_top_link_spd, la);
 		break;
 	default:
diff --git a/drivers/scsi/lpfc/lpfc_hw.h b/drivers/scsi/lpfc/lpfc_hw.h
index 892c525..f73b6e1 100644
--- a/drivers/scsi/lpfc/lpfc_hw.h
+++ b/drivers/scsi/lpfc/lpfc_hw.h
@@ -1400,6 +1400,7 @@ struct lpfc_fdmi_reg_portattr {
 #define PCI_DEVICE_ID_LANCER_FC_VF  0xe208
 #define PCI_DEVICE_ID_LANCER_FCOE   0xe260
 #define PCI_DEVICE_ID_LANCER_FCOE_VF 0xe268
+#define PCI_DEVICE_ID_LANCER_G6_FC  0xe300
 #define PCI_DEVICE_ID_SAT_SMB       0xf011
 #define PCI_DEVICE_ID_SAT_MID       0xf015
 #define PCI_DEVICE_ID_RFLY          0xf095
@@ -2075,6 +2076,7 @@ typedef struct {
 #define LINK_SPEED_8G   0x8     /* 8 Gigabaud */
 #define LINK_SPEED_10G  0x10    /* 10 Gigabaud */
 #define LINK_SPEED_16G  0x11    /* 16 Gigabaud */
+#define LINK_SPEED_32G  0x14    /* 32 Gigabaud */
 
 } INIT_LINK_VAR;
 
@@ -2246,6 +2248,7 @@ typedef struct {
 #define LMT_8Gb       0x080
 #define LMT_10Gb      0x100
 #define LMT_16Gb      0x200
+#define LMT_32Gb      0x400
 	uint32_t rsvd2;
 	uint32_t rsvd3;
 	uint32_t max_xri;
@@ -2727,6 +2730,7 @@ struct lpfc_mbx_read_top {
 #define LPFC_LINK_SPEED_8GHZ	0x20
 #define LPFC_LINK_SPEED_10GHZ	0x40
 #define LPFC_LINK_SPEED_16GHZ	0x80
+#define LPFC_LINK_SPEED_32GHZ	0x90
 };
 
 /* Structure for MB Command CLEAR_LA (22) */
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 5a97867..db9446c 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -699,7 +699,9 @@ lpfc_hba_init_link_fc_topology(struct lpfc_hba *phba, uint32_t fc_topology,
 	    ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_10G) &&
 	     !(phba->lmt & LMT_10Gb)) ||
 	    ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_16G) &&
-	     !(phba->lmt & LMT_16Gb))) {
+	     !(phba->lmt & LMT_16Gb)) ||
+	    ((phba->cfg_link_speed == LPFC_USER_LINK_SPEED_32G) &&
+	     !(phba->lmt & LMT_32Gb))) {
 		/* Reset link speed to auto */
 		lpfc_printf_log(phba, KERN_ERR, LOG_LINK_EVENT,
 			"1302 Invalid speed for this board:%d "
@@ -2035,7 +2037,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 		&& descp && descp[0] != '\0')
 		return;
 
-	if (phba->lmt & LMT_16Gb)
+	if (phba->lmt & LMT_32Gb)
+		max_speed = 32;
+	else if (phba->lmt & LMT_16Gb)
 		max_speed = 16;
 	else if (phba->lmt & LMT_10Gb)
 		max_speed = 10;
@@ -2229,6 +2233,9 @@ lpfc_get_hba_model_desc(struct lpfc_hba *phba, uint8_t *mdp, uint8_t *descp)
 		m = (typeof(m)){"OCe15100", "PCIe",
 				"Obsolete, Unsupported FCoE"};
 		break;
+	case PCI_DEVICE_ID_LANCER_G6_FC:
+		m = (typeof(m)){"LPe32000", "PCIe", "Fibre Channel Adapter"};
+		break;
 	case PCI_DEVICE_ID_SKYHAWK:
 	case PCI_DEVICE_ID_SKYHAWK_VF:
 		oneConnect = 1;
@@ -3491,6 +3498,8 @@ void lpfc_host_attrib_init(struct Scsi_Host *shost)
 				 sizeof fc_host_symbolic_name(shost));
 
 	fc_host_supported_speeds(shost) = 0;
+	if (phba->lmt & LMT_32Gb)
+		fc_host_supported_speeds(shost) |= FC_PORTSPEED_32GBIT;
 	if (phba->lmt & LMT_16Gb)
 		fc_host_supported_speeds(shost) |= FC_PORTSPEED_16GBIT;
 	if (phba->lmt & LMT_10Gb)
@@ -3854,6 +3863,9 @@ lpfc_sli4_port_speed_parse(struct lpfc_hba *phba, uint32_t evt_code,
 		case LPFC_FC_LA_SPEED_16G:
 			port_speed = 16000;
 			break;
+		case LPFC_FC_LA_SPEED_32G:
+			port_speed = 32000;
+			break;
 		default:
 			port_speed = 0;
 		}
@@ -11349,6 +11361,8 @@ static struct pci_device_id lpfc_id_table[] = {
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_FCOE_VF,
 		PCI_ANY_ID, PCI_ANY_ID, },
+	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_LANCER_G6_FC,
+		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK,
 		PCI_ANY_ID, PCI_ANY_ID, },
 	{PCI_VENDOR_ID_EMULEX, PCI_DEVICE_ID_SKYHAWK_VF,
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 18838ea..f87f90e 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -506,6 +506,13 @@ lpfc_init_link(struct lpfc_hba * phba,
 		break;
 	}
 
+	if (phba->pcidev->device == PCI_DEVICE_ID_LANCER_G6_FC &&
+		mb->un.varInitLnk.link_flags & FLAGS_TOPOLOGY_MODE_LOOP) {
+		/* Failover is not tried for Lancer G6 */
+		mb->un.varInitLnk.link_flags = FLAGS_TOPOLOGY_MODE_PT_PT;
+		phba->cfg_topology = FLAGS_TOPOLOGY_MODE_PT_PT;
+	}
+
 	/* Enable asynchronous ABTS responses from firmware */
 	mb->un.varInitLnk.link_flags |= FLAGS_IMED_ABORT;
 
@@ -539,6 +546,10 @@ lpfc_init_link(struct lpfc_hba * phba,
 			mb->un.varInitLnk.link_flags |=	FLAGS_LINK_SPEED;
 			mb->un.varInitLnk.link_speed = LINK_SPEED_16G;
 			break;
+		case LPFC_USER_LINK_SPEED_32G:
+			mb->un.varInitLnk.link_flags |= FLAGS_LINK_SPEED;
+			mb->un.varInitLnk.link_speed = LINK_SPEED_32G;
+			break;
 		case LPFC_USER_LINK_SPEED_AUTO:
 		default:
 			mb->un.varInitLnk.link_speed = LINK_SPEED_AUTO;
-- 
1.7.11.7

