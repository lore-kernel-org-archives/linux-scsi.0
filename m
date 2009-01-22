From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 05/12] qla2xxx: Modify firmware-load order precedence for ISP81XX parts.
Date: Thu, 22 Jan 2009 09:45:32 -0800
Message-ID: <1232646339-32503-6-git-send-email-andrew.vasquez@qlogic.com>
References: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:46489 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735AbZAVRpp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 12:45:45 -0500
In-Reply-To: <1232646339-32503-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Pre-ISP81XX parts (including ISP24xx and ISP25xx) could contain a
firmware image within a segment of flash, driver would fallback
to loading this firmware if the request-firmware interface failed
(userspace .bin file).  Moving forward, all ISP81XX parts will
ship with a suggested-to-be-used firmware image within flash
which all driver should first attempt to load.  If the flash
firmware load fails, the driver will then fallback to loading
firmware via the request-firmware interface (ql8100_fw.bin).

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   50 ++++++++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_os.c   |    2 +-
 3 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ba49133..a336b4b 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -34,6 +34,7 @@ extern void qla24xx_update_fw_options(scsi_qla_host_t *);
 extern void qla81xx_update_fw_options(scsi_qla_host_t *);
 extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
 extern int qla24xx_load_risc(scsi_qla_host_t *, uint32_t *);
+extern int qla81xx_load_risc(scsi_qla_host_t *, uint32_t *);
 
 extern int qla2x00_loop_resync(scsi_qla_host_t *);
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index da9700f..f6368a1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3850,6 +3850,10 @@ qla24xx_load_risc_flash(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 	uint32_t i;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = ha->req_q_map[0];
+
+	qla_printk(KERN_INFO, ha,
+	    "FW: Loading from flash (%x)...\n", ha->flt_region_fw);
+
 	rval = QLA_SUCCESS;
 
 	segments = FA_RISC_CODE_SEGMENTS;
@@ -4025,8 +4029,8 @@ fail_fw_integrity:
 	return QLA_FUNCTION_FAILED;
 }
 
-int
-qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
+static int
+qla24xx_load_risc_blob(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 {
 	int	rval;
 	int	segments, fragment;
@@ -4046,12 +4050,12 @@ qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
 		qla_printk(KERN_ERR, ha, "Firmware images can be retrieved "
 		    "from: " QLA_FW_URL ".\n");
 
-		/* Try to load RISC code from flash. */
-		qla_printk(KERN_ERR, ha, "Attempting to load (potentially "
-		    "outdated) firmware from flash.\n");
-		return qla24xx_load_risc_flash(vha, srisc_addr);
+		return QLA_FUNCTION_FAILED;
 	}
 
+	qla_printk(KERN_INFO, ha,
+	    "FW: Loading via request-firmware...\n");
+
 	rval = QLA_SUCCESS;
 
 	segments = FA_RISC_CODE_SEGMENTS;
@@ -4136,6 +4140,40 @@ fail_fw_integrity:
 	return QLA_FUNCTION_FAILED;
 }
 
+int
+qla24xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
+{
+	int rval;
+
+	/*
+	 * FW Load priority:
+	 * 1) Firmware via request-firmware interface (.bin file).
+	 * 2) Firmware residing in flash.
+	 */
+	rval = qla24xx_load_risc_blob(vha, srisc_addr);
+	if (rval == QLA_SUCCESS)
+		return rval;
+
+	return qla24xx_load_risc_flash(vha, srisc_addr);
+}
+
+int
+qla81xx_load_risc(scsi_qla_host_t *vha, uint32_t *srisc_addr)
+{
+	int rval;
+
+	/*
+	 * FW Load priority:
+	 * 1) Firmware residing in flash.
+	 * 2) Firmware via request-firmware interface (.bin file).
+	 */
+	rval = qla24xx_load_risc_flash(vha, srisc_addr);
+	if (rval == QLA_SUCCESS)
+		return rval;
+
+	return qla24xx_load_risc_blob(vha, srisc_addr);
+}
+
 void
 qla2x00_try_to_stop_firmware(scsi_qla_host_t *vha)
 {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 185ea8b..cbf377f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1480,7 +1480,7 @@ static struct isp_operations qla81xx_isp_ops = {
 	.reset_adapter		= qla24xx_reset_adapter,
 	.nvram_config		= qla81xx_nvram_config,
 	.update_fw_options	= qla81xx_update_fw_options,
-	.load_risc		= qla24xx_load_risc,
+	.load_risc		= qla81xx_load_risc,
 	.pci_info_str		= qla24xx_pci_info_str,
 	.fw_version_str		= qla24xx_fw_version_str,
 	.intr_handler		= qla24xx_intr_handler,
-- 
1.6.1.48.ge9b8

