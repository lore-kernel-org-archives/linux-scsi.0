From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/8] qla2xxx: Add NPIV-Config Table support.
Date: Thu, 11 Sep 2008 21:22:50 -0700
Message-ID: <1221193374-77635-5-git-send-email-andrew.vasquez@qlogic.com>
References: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46751 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbYILEW7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2008 00:22:59 -0400
In-Reply-To: <1221193374-77635-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

To instatiate pre-configured vport entities defined within an
HBA's flash memory.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h |    2 +
 drivers/scsi/qla2xxx/qla_fw.h  |   26 +++++++++++
 drivers/scsi/qla2xxx/qla_gbl.h |    2 +
 drivers/scsi/qla2xxx/qla_os.c  |    7 +++
 drivers/scsi/qla2xxx/qla_sup.c |   98 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 133 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 880e711..83c8192 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2239,6 +2239,7 @@ typedef struct scsi_qla_host {
 #define FCPORT_UPDATE_NEEDED	27
 #define VP_DPC_NEEDED		28	/* wake up for VP dpc handling */
 #define UNLOADING		29
+#define NPIV_CONFIG_NEEDED	30
 
 	uint32_t	device_flags;
 #define DFLG_LOCAL_DEVICES		BIT_0
@@ -2559,6 +2560,7 @@ typedef struct scsi_qla_host {
 	uint32_t	flt_region_fw;
 	uint32_t	flt_region_vpd_nvram;
 	uint32_t	flt_region_hw_event;
+	uint32_t	flt_region_npiv_conf;
 
 	/* Needed for BEACON */
 	uint16_t	beacon_blink_led;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 2ec986b..d1d1420 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -791,6 +791,8 @@ struct device_reg_24xx {
 
 #define FA_FLASH_DESCR_ADDR_24	0x11000
 #define FA_FLASH_LAYOUT_ADDR_24	0x11400
+#define FA_NPIV_CONF0_ADDR_24	0x16000
+#define FA_NPIV_CONF1_ADDR_24	0x17000
 
 #define FA_FW_AREA_ADDR		0x40000
 #define FA_VPD_NVRAM_ADDR	0x48000
@@ -801,6 +803,9 @@ struct device_reg_24xx {
 #define FA_HW_EVENT1_ADDR	0x54400
 #define FA_HW_EVENT_SIZE	0x200
 #define FA_HW_EVENT_ENTRY_SIZE	4
+#define FA_NPIV_CONF0_ADDR	0x5C000
+#define FA_NPIV_CONF1_ADDR	0x5D000
+
 /*
  * Flash Error Log Event Codes.
  */
@@ -1230,6 +1235,8 @@ struct qla_flt_header {
 #define FLT_REG_FLT		0x1c
 #define FLT_REG_HW_EVENT_0	0x1d
 #define FLT_REG_HW_EVENT_1	0x1f
+#define FLT_REG_NPIV_CONF_0	0x29
+#define FLT_REG_NPIV_CONF_1	0x2a
 
 struct qla_flt_region {
 	uint32_t code;
@@ -1238,6 +1245,25 @@ struct qla_flt_region {
 	uint32_t end;
 };
 
+/* Flash NPIV Configuration Table ********************************************/
+
+struct qla_npiv_header {
+	uint8_t sig[2];
+	uint16_t version;
+	uint16_t entries;
+	uint16_t unused[4];
+	uint16_t checksum;
+};
+
+struct qla_npiv_entry {
+	uint16_t flags;
+	uint16_t vf_id;
+	uint16_t qos;
+	uint16_t unused1;
+	uint8_t port_name[WWN_SIZE];
+	uint8_t node_name[WWN_SIZE];
+};
+
 /* 84XX Support **************************************************************/
 
 #define MBA_ISP84XX_ALERT	0x800f  /* Alert Notification. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index dbd9f93..753dbe6 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -316,6 +316,8 @@ extern int qla2xxx_hw_event_log(scsi_qla_host_t *, uint16_t , uint16_t,
 extern int qla2xxx_get_flash_info(scsi_qla_host_t *);
 extern int qla2xxx_get_vpd_field(scsi_qla_host_t *, char *, char *, size_t);
 
+extern void qla2xxx_flash_npiv_conf(scsi_qla_host_t *);
+
 /*
  * Global Function Prototypes in qla_dbg.c source file.
  */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f89f292..fcbcd44 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1517,6 +1517,7 @@ qla2xxx_scan_start(struct Scsi_Host *shost)
 	set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
 	set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
 	set_bit(RSCN_UPDATE, &ha->dpc_flags);
+	set_bit(NPIV_CONFIG_NEEDED, &ha->dpc_flags);
 }
 
 static int
@@ -2429,6 +2430,12 @@ qla2x00_do_dpc(void *data)
 			    ha->host_no));
 		}
 
+		if (test_bit(NPIV_CONFIG_NEEDED, &ha->dpc_flags) &&
+		    atomic_read(&ha->loop_state) == LOOP_READY) {
+			clear_bit(NPIV_CONFIG_NEEDED, &ha->dpc_flags);
+			qla2xxx_flash_npiv_conf(ha);
+		}
+
 		if (!ha->interrupts_on)
 			ha->isp_ops->enable_intrs(ha);
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 6de1e3b..e2432ef 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -686,6 +686,14 @@ qla2xxx_get_flt_info(scsi_qla_host_t *ha, uint32_t flt_addr)
 			if (PCI_FUNC(ha->pdev->devfn))
 				ha->flt_region_hw_event = start;
 			break;
+		case FLT_REG_NPIV_CONF_0:
+			if (!PCI_FUNC(ha->pdev->devfn))
+				ha->flt_region_npiv_conf = start;
+			break;
+		case FLT_REG_NPIV_CONF_1:
+			if (PCI_FUNC(ha->pdev->devfn))
+				ha->flt_region_npiv_conf = start;
+			break;
 		}
 	}
 	goto done;
@@ -700,11 +708,15 @@ no_flash_data:
 	    FA_FLASH_DESCR_ADDR;
 	ha->flt_region_hw_event = !PCI_FUNC(ha->pdev->devfn) ?
 	    FA_HW_EVENT0_ADDR: FA_HW_EVENT1_ADDR;
+	ha->flt_region_npiv_conf = !PCI_FUNC(ha->pdev->devfn) ?
+	    (IS_QLA24XX_TYPE(ha) ? FA_NPIV_CONF0_ADDR_24: FA_NPIV_CONF0_ADDR):
+	    (IS_QLA24XX_TYPE(ha) ? FA_NPIV_CONF1_ADDR_24: FA_NPIV_CONF1_ADDR);
 done:
 	DEBUG2(qla_printk(KERN_DEBUG, ha, "FLT[%s]: boot=0x%x fw=0x%x "
-	    "vpd_nvram=0x%x fdt=0x%x flt=0x%x hwe=0x%x.\n", loc,
+	    "vpd_nvram=0x%x fdt=0x%x flt=0x%x hwe=0x%x npiv=0x%x.\n", loc,
 	    ha->flt_region_boot, ha->flt_region_fw, ha->flt_region_vpd_nvram,
-	    ha->flt_region_fdt, ha->flt_region_flt, ha->flt_region_hw_event));
+	    ha->flt_region_fdt, ha->flt_region_flt, ha->flt_region_hw_event,
+	    ha->flt_region_npiv_conf));
 }
 
 static void
@@ -814,6 +826,88 @@ qla2xxx_get_flash_info(scsi_qla_host_t *ha)
 	return QLA_SUCCESS;
 }
 
+void
+qla2xxx_flash_npiv_conf(scsi_qla_host_t *ha)
+{
+#define NPIV_CONFIG_SIZE	(16*1024)
+	void *data;
+	uint16_t *wptr;
+	uint16_t cnt, chksum;
+	struct qla_npiv_header hdr;
+	struct qla_npiv_entry *entry;
+
+	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha))
+		return;
+
+	ha->isp_ops->read_optrom(ha, (uint8_t *)&hdr,
+	    ha->flt_region_npiv_conf << 2, sizeof(struct qla_npiv_header));
+	if (hdr.version == __constant_cpu_to_le16(0xffff))
+		return;
+	if (hdr.version != __constant_cpu_to_le16(1)) {
+		DEBUG2(qla_printk(KERN_INFO, ha, "Unsupported NPIV-Config "
+		    "detected: version=0x%x entries=0x%x checksum=0x%x.\n",
+		    le16_to_cpu(hdr.version), le16_to_cpu(hdr.entries),
+		    le16_to_cpu(hdr.checksum)));
+		return;
+	}
+
+	data = kmalloc(NPIV_CONFIG_SIZE, GFP_KERNEL);
+	if (!data) {
+		DEBUG2(qla_printk(KERN_INFO, ha, "NPIV-Config: Unable to "
+		    "allocate memory.\n"));
+		return;
+	}
+
+	ha->isp_ops->read_optrom(ha, (uint8_t *)data,
+	    ha->flt_region_npiv_conf << 2, NPIV_CONFIG_SIZE);
+
+	cnt = (sizeof(struct qla_npiv_header) + le16_to_cpu(hdr.entries) *
+	    sizeof(struct qla_npiv_entry)) >> 1;
+	for (wptr = data, chksum = 0; cnt; cnt--)
+		chksum += le16_to_cpu(*wptr++);
+	if (chksum) {
+		DEBUG2(qla_printk(KERN_INFO, ha, "Inconsistent NPIV-Config "
+		    "detected: version=0x%x entries=0x%x checksum=0x%x.\n",
+		    le16_to_cpu(hdr.version), le16_to_cpu(hdr.entries),
+		    chksum));
+		goto done;
+	}
+
+	entry = data + sizeof(struct qla_npiv_header);
+	cnt = le16_to_cpu(hdr.entries);
+	for ( ; cnt; cnt--, entry++) {
+		uint16_t flags;
+		struct fc_vport_identifiers vid;
+		struct fc_vport *vport;
+
+		flags = le16_to_cpu(entry->flags);
+		if (flags == 0xffff)
+			continue;
+		if ((flags & BIT_0) == 0)
+			continue;
+
+		memset(&vid, 0, sizeof(vid));
+		vid.roles = FC_PORT_ROLE_FCP_INITIATOR;
+		vid.vport_type = FC_PORTTYPE_NPIV;
+		vid.disable = false;
+		vid.port_name = wwn_to_u64(entry->port_name);
+		vid.node_name = wwn_to_u64(entry->node_name);
+
+		DEBUG2(qla_printk(KERN_DEBUG, ha, "NPIV[%02x]: wwpn=%llx "
+		    "wwnn=%llx vf_id=0x%x qos=0x%x.\n", cnt, vid.port_name,
+		    vid.node_name, le16_to_cpu(entry->vf_id),
+		    le16_to_cpu(entry->qos)));
+
+		vport = fc_vport_create(ha->host, 0, &vid);
+		if (!vport)
+			qla_printk(KERN_INFO, ha, "NPIV-Config: Failed to "
+			    "create vport [%02x]: wwpn=%llx wwnn=%llx.\n", cnt,
+			    vid.port_name, vid.node_name);
+	}
+done:
+	kfree(data);
+}
+
 static void
 qla24xx_unprotect_flash(scsi_qla_host_t *ha)
 {
-- 
1.6.0.1.294.gda06a

