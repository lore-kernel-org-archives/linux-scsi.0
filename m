From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 4/7] smartpqi: cleanup doorbell register usage.
Date: Thu, 10 Aug 2017 13:46:57 -0500
Message-ID: <150239081738.23771.11820093998217303225.stgit@brunhilda>
References: <150239072706.23771.1380444570336852695.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0049.outbound.protection.outlook.com ([104.47.42.49]:26144
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753027AbdHJSrV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 14:47:21 -0400
In-Reply-To: <150239072706.23771.1380444570336852695.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   11 ++-
 drivers/scsi/smartpqi/smartpqi_sis.c  |  105 +++------------------------------
 drivers/scsi/smartpqi/smartpqi_sis.h  |    3 -
 3 files changed, 17 insertions(+), 102 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 3b05f28..70b1f97 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -3008,11 +3008,9 @@ static void pqi_change_irq_mode(struct pqi_ctrl_info *ctrl_info,
 			break;
 		case IRQ_MODE_INTX:
 			pqi_configure_legacy_intx(ctrl_info, true);
-			sis_disable_msix(ctrl_info);
 			sis_enable_intx(ctrl_info);
 			break;
 		case IRQ_MODE_NONE:
-			sis_disable_msix(ctrl_info);
 			break;
 		}
 		break;
@@ -3020,14 +3018,12 @@ static void pqi_change_irq_mode(struct pqi_ctrl_info *ctrl_info,
 		switch (new_mode) {
 		case IRQ_MODE_MSIX:
 			pqi_configure_legacy_intx(ctrl_info, false);
-			sis_disable_intx(ctrl_info);
 			sis_enable_msix(ctrl_info);
 			break;
 		case IRQ_MODE_INTX:
 			break;
 		case IRQ_MODE_NONE:
 			pqi_configure_legacy_intx(ctrl_info, false);
-			sis_disable_intx(ctrl_info);
 			break;
 		}
 		break;
@@ -6046,7 +6042,12 @@ static int pqi_revert_to_sis_mode(struct pqi_ctrl_info *ctrl_info)
 	rc = pqi_reset(ctrl_info);
 	if (rc)
 		return rc;
-	sis_reenable_sis_mode(ctrl_info);
+	rc = sis_reenable_sis_mode(ctrl_info);
+	if (rc) {
+		dev_err(&ctrl_info->pci_dev->dev,
+			"re-enabling SIS mode failed with error %d\n", rc);
+		return rc;
+	}
 	pqi_save_ctrl_mode(ctrl_info, SIS_MODE);
 
 	return 0;
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.c b/drivers/scsi/smartpqi/smartpqi_sis.c
index 9abbace..5141bd4 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.c
+++ b/drivers/scsi/smartpqi/smartpqi_sis.c
@@ -34,12 +34,13 @@
 #define SIS_REENABLE_SIS_MODE			0x1
 #define SIS_ENABLE_MSIX				0x40
 #define SIS_ENABLE_INTX				0x80
-#define SIS_SOFT_RESET				0x100
+#define SIS_CMD_READY				0x200
 #define SIS_TRIGGER_SHUTDOWN			0x800000
 #define SIS_PQI_RESET_QUIESCE			0x1000000
-#define SIS_CMD_READY				0x200
+
 #define SIS_CMD_COMPLETE			0x1000
 #define SIS_CLEAR_CTRL_TO_HOST_DOORBELL		0x1000
+
 #define SIS_CMD_STATUS_SUCCESS			0x1
 #define SIS_CMD_COMPLETE_TIMEOUT_SECS		30
 #define SIS_CMD_COMPLETE_POLL_INTERVAL_MSECS	10
@@ -373,66 +374,21 @@ static int sis_wait_for_doorbell_bit_to_clear(
 	return rc;
 }
 
-/* Enable MSI-X interrupts on the controller. */
-
-void sis_enable_msix(struct pqi_ctrl_info *ctrl_info)
+static inline int sis_set_doorbell_bit(struct pqi_ctrl_info *ctrl_info, u32 bit)
 {
-	u32 doorbell_register;
-
-	doorbell_register =
-		readl(&ctrl_info->registers->sis_host_to_ctrl_doorbell);
-	doorbell_register |= SIS_ENABLE_MSIX;
+	writel(bit, &ctrl_info->registers->sis_host_to_ctrl_doorbell);
 
-	writel(doorbell_register,
-		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
-
-	sis_wait_for_doorbell_bit_to_clear(ctrl_info, SIS_ENABLE_MSIX);
+	return sis_wait_for_doorbell_bit_to_clear(ctrl_info, bit);
 }
 
-/* Disable MSI-X interrupts on the controller. */
-
-void sis_disable_msix(struct pqi_ctrl_info *ctrl_info)
+void sis_enable_msix(struct pqi_ctrl_info *ctrl_info)
 {
-	u32 doorbell_register;
-
-	doorbell_register =
-		readl(&ctrl_info->registers->sis_host_to_ctrl_doorbell);
-	doorbell_register &= ~SIS_ENABLE_MSIX;
-
-	writel(doorbell_register,
-		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
+	sis_set_doorbell_bit(ctrl_info, SIS_ENABLE_MSIX);
 }
 
 void sis_enable_intx(struct pqi_ctrl_info *ctrl_info)
 {
-	u32 doorbell_register;
-
-	doorbell_register =
-		readl(&ctrl_info->registers->sis_host_to_ctrl_doorbell);
-	doorbell_register |= SIS_ENABLE_INTX;
-
-	writel(doorbell_register,
-		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
-
-	sis_wait_for_doorbell_bit_to_clear(ctrl_info, SIS_ENABLE_INTX);
-}
-
-void sis_disable_intx(struct pqi_ctrl_info *ctrl_info)
-{
-	u32 doorbell_register;
-
-	doorbell_register =
-		readl(&ctrl_info->registers->sis_host_to_ctrl_doorbell);
-	doorbell_register &= ~SIS_ENABLE_INTX;
-
-	writel(doorbell_register,
-		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
-}
-
-void sis_soft_reset(struct pqi_ctrl_info *ctrl_info)
-{
-	writel(SIS_SOFT_RESET,
-		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
+	sis_set_doorbell_bit(ctrl_info, SIS_ENABLE_INTX);
 }
 
 void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info)
@@ -447,51 +403,12 @@ void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info)
 
 int sis_pqi_reset_quiesce(struct pqi_ctrl_info *ctrl_info)
 {
-	u32 doorbell_register;
-
-	doorbell_register =
-		readl(&ctrl_info->registers->sis_host_to_ctrl_doorbell);
-	doorbell_register |= SIS_PQI_RESET_QUIESCE;
-
-	writel(doorbell_register,
-		&ctrl_info->registers->sis_host_to_ctrl_doorbell);
-
-	return sis_wait_for_doorbell_bit_to_clear(ctrl_info,
-		SIS_PQI_RESET_QUIESCE);
+	return sis_set_doorbell_bit(ctrl_info, SIS_PQI_RESET_QUIESCE);
 }
 
-#define SIS_MODE_READY_TIMEOUT_SECS	30
-
 int sis_reenable_sis_mode(struct pqi_ctrl_info *ctrl_info)
 {
-	int rc;
-	unsigned long timeout;
-	struct pqi_ctrl_registers __iomem *registers;
-	u32 doorbell;
-
-	registers = ctrl_info->registers;
-
-	writel(SIS_REENABLE_SIS_MODE,
-		&registers->sis_host_to_ctrl_doorbell);
-
-	rc = 0;
-	timeout = (SIS_MODE_READY_TIMEOUT_SECS * HZ) + jiffies;
-
-	while (1) {
-		doorbell = readl(&registers->sis_ctrl_to_host_doorbell);
-		if ((doorbell & SIS_REENABLE_SIS_MODE) == 0)
-			break;
-		if (time_after(jiffies, timeout)) {
-			rc = -ETIMEDOUT;
-			break;
-		}
-	}
-
-	if (rc)
-		dev_err(&ctrl_info->pci_dev->dev,
-			"re-enabling SIS mode failed\n");
-
-	return rc;
+	return sis_set_doorbell_bit(ctrl_info, SIS_REENABLE_SIS_MODE);
 }
 
 void sis_write_driver_scratch(struct pqi_ctrl_info *ctrl_info, u32 value)
diff --git a/drivers/scsi/smartpqi/smartpqi_sis.h b/drivers/scsi/smartpqi/smartpqi_sis.h
index 394b16e..2bf889d 100644
--- a/drivers/scsi/smartpqi/smartpqi_sis.h
+++ b/drivers/scsi/smartpqi/smartpqi_sis.h
@@ -27,10 +27,7 @@ int sis_get_ctrl_properties(struct pqi_ctrl_info *ctrl_info);
 int sis_get_pqi_capabilities(struct pqi_ctrl_info *ctrl_info);
 int sis_init_base_struct_addr(struct pqi_ctrl_info *ctrl_info);
 void sis_enable_msix(struct pqi_ctrl_info *ctrl_info);
-void sis_disable_msix(struct pqi_ctrl_info *ctrl_info);
 void sis_enable_intx(struct pqi_ctrl_info *ctrl_info);
-void sis_disable_intx(struct pqi_ctrl_info *ctrl_info);
-void sis_soft_reset(struct pqi_ctrl_info *ctrl_info);
 void sis_shutdown_ctrl(struct pqi_ctrl_info *ctrl_info);
 int sis_pqi_reset_quiesce(struct pqi_ctrl_info *ctrl_info);
 int sis_reenable_sis_mode(struct pqi_ctrl_info *ctrl_info);
