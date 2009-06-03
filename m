From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 06/20] qla2xxx: Fallback to 'golden-firmware' operation on supported ISPs.
Date: Wed,  3 Jun 2009 09:55:17 -0700
Message-ID: <1244048131-56590-7-git-send-email-andrew.vasquez@qlogic.com>
References: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:4799 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527AbZFCQzi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2009 12:55:38 -0400
In-Reply-To: <1244048131-56590-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

In case the onboard firmware is unable to be read or loaded for
operation, attempt to fallback to a limited-operational firmware
image stored in a different flash region.  This will allow a user
to reflash and correct a board with proper operational firmware.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    2 ++
 drivers/scsi/qla2xxx/qla_fw.h   |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   33 +++++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c   |    7 +++++++
 drivers/scsi/qla2xxx/qla_sup.c  |    3 +++
 5 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 4e846ae..88ddae0 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2223,6 +2223,7 @@ struct qla_hw_data {
 		uint32_t	fac_supported		:1;
 		uint32_t	chip_reset_done		:1;
 		uint32_t	port0			:1;
+		uint32_t	running_gold_fw		:1;
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
@@ -2523,6 +2524,7 @@ struct qla_hw_data {
 	uint32_t        flt_region_vpd;
 	uint32_t        flt_region_nvram;
 	uint32_t        flt_region_npiv_conf;
+	uint32_t	flt_region_gold_fw;
 
 	/* Needed for BEACON */
 	uint16_t        beacon_blink_led;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 152d16c..9e56d4a 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1241,6 +1241,7 @@ struct qla_flt_header {
 #define FLT_REG_HW_EVENT_1	0x1f
 #define FLT_REG_NPIV_CONF_0	0x29
 #define FLT_REG_NPIV_CONF_1	0x2a
+#define FLT_REG_GOLD_FW		0x2f
 
 struct qla_flt_region {
 	uint32_t code;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index a7abc10..34e6508 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3806,11 +3806,11 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 }
 
 static int
-qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr)
+qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr,
+    uint32_t faddr)
 {
 	int	rval = QLA_SUCCESS;
 	int	segments, fragment;
-	uint32_t faddr;
 	uint32_t *dcode, dlen;
 	uint32_t risc_addr;
 	uint32_t risc_size;
@@ -3819,12 +3819,11 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	struct req_que *req = ha->req_q_map[0];
 
 	qla_printk(KERN_INFO, ha,
-	    "FW: Loading from flash (%x)...\n", ha->flt_region_fw);
+	    "FW: Loading from flash (%x)...\n", faddr);
 
 	rval = QLA_SUCCESS;
 
 	segments = FA_RISC_CODE_SEGMENTS;
-	faddr = ha->flt_region_fw;
 	dcode = (uint32_t *)req->ring;
 	*srisc_addr = 0;
 
@@ -4124,27 +4123,45 @@ qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	if (rval == QLA_SUCCESS)
 		return rval;
 
-	return qla24xx_load_risc_flash(vha, srisc_addr);
+	return qla24xx_load_risc_flash(vha, srisc_addr,
+	    vha->hw->flt_region_fw);
 }
 
 int
 qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 {
 	int rval;
+	struct qla_hw_data *ha = vha->hw;
 
 	if (ql2xfwloadbin == 2)
-		return qla24xx_load_risc(vha, srisc_addr);
+		goto try_blob_fw;
 
 	/*
 	 * FW Load priority:
 	 * 1) Firmware residing in flash.
 	 * 2) Firmware via request-firmware interface (.bin file).
+	 * 3) Golden-Firmware residing in flash -- limited operation.
 	 */
-	rval = qla24xx_load_risc_flash(vha, srisc_addr);
+	rval = qla24xx_load_risc_flash(vha, srisc_addr, ha->flt_region_fw);
 	if (rval == QLA_SUCCESS)
 		return rval;
 
-	return qla24xx_load_risc_blob(vha, srisc_addr);
+try_blob_fw:
+	rval = qla24xx_load_risc_blob(vha, srisc_addr);
+	if (rval == QLA_SUCCESS || !ha->flt_region_gold_fw)
+		return rval;
+
+	qla_printk(KERN_ERR, ha,
+	    "FW: Attempting to fallback to golden firmware...\n");
+	rval = qla24xx_load_risc_flash(vha, srisc_addr, ha->flt_region_gold_fw);
+	if (rval != QLA_SUCCESS)
+		return rval;
+
+	qla_printk(KERN_ERR, ha,
+	    "FW: Please update operational firmware...\n");
+	ha->flags.running_gold_fw = 1;
+
+	return rval;
 }
 
 void
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 181ed97..128b3d5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1690,6 +1690,9 @@ qla2xxx_scan_start(struct Scsi_Host *shost)
 {
 	scsi_qla_host_t *vha = shost_priv(shost);
 
+	if (vha->hw->flags.running_gold_fw)
+		return;
+
 	set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 	set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 	set_bit(RSCN_UPDATE, &vha->dpc_flags);
@@ -1962,6 +1965,9 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 				"Can't create queues, falling back to single"
 				" queue mode\n");
 
+	if (ha->flags.running_gold_fw)
+		goto skip_dpc;
+
 	/*
 	 * Startup the kernel thread for this host adapter
 	 */
@@ -1974,6 +1980,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto probe_failed;
 	}
 
+skip_dpc:
 	list_add_tail(&base_vha->list, &ha->vp_list);
 	base_vha->host->irq = ha->pdev->irq;
 
diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index e239203..6260505 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -728,6 +728,9 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 			if (!ha->flags.port0)
 				ha->flt_region_npiv_conf = start;
 			break;
+		case FLT_REG_GOLD_FW:
+			ha->flt_region_gold_fw = start;
+			break;
 		}
 	}
 	goto done;
-- 
1.6.3.1.244.gf9275

