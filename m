From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 04/43] qla2xxx: Use chip reset to bring down laser on unload.
Date: Tue, 19 Dec 2017 22:56:05 -0800
Message-ID: <20171220065644.21511-5-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0073.outbound.protection.outlook.com ([104.47.34.73]:24389
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932372AbdLTG5B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:01 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Current code uses Stop Firmware MB cmd to stop the chip before
driver unload.  This will leave the laser in its current state.
This give the illusion of this adapter is still alive.
For 8G & newer adapters, use chip reset to stop the chip and
bring down the laser.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 52 ++++++++++++++-----------------------------
 1 file changed, 17 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 789030c9dd26..987bade1c606 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -294,7 +294,6 @@ static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
 
 static void qla2x00_clear_drv_active(struct qla_hw_data *);
 static void qla2x00_free_device(scsi_qla_host_t *);
-static void qla83xx_disable_laser(scsi_qla_host_t *vha);
 static int qla2xxx_map_queues(struct Scsi_Host *shost);
 static void qla2x00_destroy_deferred_work(struct qla_hw_data *);
 
@@ -3449,8 +3448,13 @@ qla2x00_shutdown(struct pci_dev *pdev)
 	if (ha->eft)
 		qla2x00_disable_eft_trace(vha);
 
-	/* Stop currently executing firmware. */
-	qla2x00_try_to_stop_firmware(vha);
+	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha)) {
+		if (ha->flags.fw_started)
+			qla2x00_abort_isp_cleanup(vha);
+	} else {
+		/* Stop currently executing firmware. */
+		qla2x00_try_to_stop_firmware(vha);
+	}
 
 	/* Turn adapter off line */
 	vha->flags.online = 0;
@@ -3629,10 +3633,6 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla84xx_put_chip(base_vha);
 
-	/* Laser should be disabled only for ISP2031 */
-	if (IS_QLA2031(ha))
-		qla83xx_disable_laser(base_vha);
-
 	/* Disable timer */
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
@@ -3693,8 +3693,16 @@ qla2x00_free_device(scsi_qla_host_t *vha)
 	if (ha->eft)
 		qla2x00_disable_eft_trace(vha);
 
-	/* Stop currently executing firmware. */
-	qla2x00_try_to_stop_firmware(vha);
+	if (IS_QLA25XX(ha) ||  IS_QLA2031(ha) || IS_QLA27XX(ha)) {
+		if (ha->flags.fw_started)
+			qla2x00_abort_isp_cleanup(vha);
+	} else {
+		if (ha->flags.fw_started) {
+			/* Stop currently executing firmware. */
+			qla2x00_try_to_stop_firmware(vha);
+			ha->flags.fw_started = 0;
+		}
+	}
 
 	vha->flags.online = 0;
 
@@ -6617,32 +6625,6 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
 	ha->flags.eeh_busy = 0;
 }
 
-static void
-qla83xx_disable_laser(scsi_qla_host_t *vha)
-{
-	uint32_t reg, data, fn;
-	struct qla_hw_data *ha = vha->hw;
-	struct device_reg_24xx __iomem *isp_reg = &ha->iobase->isp24;
-
-	/* pci func #/port # */
-	ql_dbg(ql_dbg_init, vha, 0x004b,
-	    "Disabling Laser for hba: %p\n", vha);
-
-	fn = (RD_REG_DWORD(&isp_reg->ctrl_status) &
-		(BIT_15|BIT_14|BIT_13|BIT_12));
-
-	fn = (fn >> 12);
-
-	if (fn & 1)
-		reg = PORT_1_2031;
-	else
-		reg = PORT_0_2031;
-
-	data = LASER_OFF_2031;
-
-	qla83xx_wr_reg(vha, reg, data);
-}
-
 static int qla2xxx_map_queues(struct Scsi_Host *shost)
 {
 	int rc;
-- 
2.12.0
