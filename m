From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 24/35] qla2xxx: Disable laser for ISP2031 while unloading driver.
Date: Wed, 24 Sep 2014 03:08:27 -0400
Message-ID: <1411542518-2477-25-git-send-email-saurav.kashyap@qlogic.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:3393 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbaIXHmr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2014 03:42:47 -0400
In-Reply-To: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Himanshu Madhani <himanshu.madhani@qlogic.com>

Nameserver data on FC switch is not refreshed when
qla2xxx driver is unloaded. Disabling laser for
ISP2031 will force FC switch to rescan ports and
clear fdmi entries from Nameserver.

Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 drivers/scsi/qla2xxx/qla_def.h |    5 +++++
 drivers/scsi/qla2xxx/qla_os.c  |   31 +++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 6e52a45..1a43228 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,7 +11,7 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x017d       | 0x004b,0x0141	|
+ * | Module Init and Probe        |       0x017d       | 0x0141		|
  * |                              |                    | 0x0144,0x0146	|
  * |                              |                    | 0x015b-0x0160	|
  * |                              |                    | 0x016e-0x0170	|
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f416c5b..62c902c 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -191,6 +191,11 @@
 					     * reset-recovery completion is
 					     * second
 					     */
+/* ISP2031: Values for laser on/off */
+#define PORT_0_2031	0x00201340
+#define PORT_1_2031	0x00201350
+#define LASER_ON_2031	0x01800100
+#define LASER_OFF_2031	0x01800180
 
 /*
  * The ISP2312 v2 chip cannot access the FLASH/GPIO registers via MMIO in an
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index b9523dc..bf78127 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -239,6 +239,7 @@ static int qla2xxx_eh_host_reset(struct scsi_cmnd *);
 static int qla2x00_change_queue_depth(struct scsi_device *, int, int);
 static int qla2x00_change_queue_type(struct scsi_device *, int);
 static void qla2x00_free_device(scsi_qla_host_t *);
+static void qla83xx_disable_laser(scsi_qla_host_t *vha);
 
 struct scsi_host_template qla2xxx_driver_template = {
 	.module			= THIS_MODULE,
@@ -3174,6 +3175,10 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla84xx_put_chip(base_vha);
 
+	/* Laser should be disabled only for ISP2031 */
+	if (IS_QLA2031(ha))
+		qla83xx_disable_laser(base_vha);
+
 	/* Disable timer */
 	if (base_vha->timer_active)
 		qla2x00_stop_timer(base_vha);
@@ -5707,6 +5712,32 @@ qla2xxx_pci_resume(struct pci_dev *pdev)
 	ha->flags.eeh_busy = 0;
 }
 
+static void
+qla83xx_disable_laser(scsi_qla_host_t *vha)
+{
+	uint32_t reg, data, fn;
+	struct qla_hw_data *ha = vha->hw;
+	struct device_reg_24xx __iomem *isp_reg = &ha->iobase->isp24;
+
+	/* pci func #/port # */
+	ql_dbg(ql_dbg_init, vha, 0x004b,
+	    "Disabling Laser for hba: %p\n", vha);
+
+	fn = (RD_REG_DWORD(&isp_reg->ctrl_status) &
+		(BIT_15|BIT_14|BIT_13|BIT_12));
+
+	fn = (fn >> 12);
+
+	if (fn & 1)
+		reg = PORT_1_2031;
+	else
+		reg = PORT_0_2031;
+
+	data = LASER_OFF_2031;
+
+	qla83xx_wr_reg(vha, reg, data);
+}
+
 static const struct pci_error_handlers qla2xxx_err_handler = {
 	.error_detected = qla2xxx_pci_error_detected,
 	.mmio_enabled = qla2xxx_pci_mmio_enabled,
-- 
1.7.7

