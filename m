From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 09/19] qla2xxx: Check for device state before unloading the driver.
Date: Wed, 6 Jul 2016 11:14:25 -0400
Message-ID: <1467818075-15246-10-git-send-email-himanshu.madhani@qlogic.com>
References: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:18927 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754184AbcGFP77 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 11:59:59 -0400
In-Reply-To: <1467818075-15246-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

During hot swap of PCI device, there can be PCI error on device,
during normal driver unload. The race between normal driver unload and
driver unload due to PCI error, can lead to system crash.Fix is to check
if there is unload going on and allow that function to unload the driver.

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |  2 +-
 drivers/scsi/qla2xxx/qla_def.h |  1 +
 drivers/scsi/qla2xxx/qla_mbx.c | 41 +++++++++++++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c  | 21 +++++++++++++++++----
 4 files changed, 52 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index c6ccc8a..2790e5f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -14,7 +14,7 @@
  * | Module Init and Probe        |       0x018f       | 0x0146         |
  * |                              |                    | 0x015b-0x0160	|
  * |                              |                    | 0x016e		|
- * | Mailbox commands             |       0x1192       |		|
+ * | Mailbox commands             |       0x1191       | 		|
  * |                              |                    |		|
  * | Device Discovery             |       0x2003       | 0x2016		|
  * |                              |                    | 0x2011-0x2012, |
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index a73ecc7..7d4bd7d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3658,6 +3658,7 @@ typedef struct scsi_qla_host {
 #define PFLG_DISCONNECTED	0	/* PCI device removed */
 #define PFLG_DRIVER_REMOVING	1	/* PCI driver .remove */
 #define PFLG_DRIVER_PROBING	2	/* PCI driver .probe */
+#define PCI_ERR			30
 
 	uint32_t	device_flags;
 #define SWITCH_FOUND		BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 583ad62..97099ce 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -64,6 +64,13 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
+	 /* if PCI error, then avoid mbx processing.*/
+	 if (test_bit(PCI_ERR, &base_vha->dpc_flags)) {
+		ql_log(ql_log_warn, vha, 0x1191,
+		    "PCI error, exiting.\n");
+		return QLA_FUNCTION_TIMEOUT;
+	 }
+
 	reg = ha->iobase;
 	io_lock_on = base_vha->flags.init_done;
 
@@ -266,6 +273,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 
 		uint16_t mb0;
 		uint32_t ictrl;
+		uint16_t        w;
 
 		if (IS_FWI2_CAPABLE(ha)) {
 			mb0 = RD_REG_WORD(&reg->isp24.mailbox0);
@@ -279,15 +287,32 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		    "mb[0]=0x%x\n", command, ictrl, jiffies, mb0);
 		ql_dump_regs(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1019);
 
-		/*
-		 * Attempt to capture a firmware dump for further analysis
-		 * of the current firmware state.  We do not need to do this
-		 * if we are intentionally generating a dump.
-		 */
-		if (mcp->mb[0] != MBC_GEN_SYSTEM_ERROR)
-			ha->isp_ops->fw_dump(vha, 0);
+		/* Capture FW dump only, if PCI device active */
+		if (!pci_channel_offline(vha->hw->pdev)) {
+			pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);
+			if (w == 0xffff || ictrl == 0xffffffff) {
+				/* This is special case if there is unload
+				 * of driver happening and if PCI device go
+				 * into bad state due to PCI error condition
+				 * then only PCI ERR flag would be set.
+				 * we will do premature exit for above case.
+				 */
+				if (test_bit(UNLOADING, &base_vha->dpc_flags))
+					set_bit(PCI_ERR, &base_vha->dpc_flags);
+				ha->flags.mbox_busy = 0;
+				rval = QLA_FUNCTION_TIMEOUT;
+				goto premature_exit;
+			}
 
-		rval = QLA_FUNCTION_TIMEOUT;
+			/* Attempt to capture firmware dump for further
+			 * anallysis of the current formware state. we do not
+			 * need to do this if we are intentionally generating
+			 * a dump
+			 */
+			if (mcp->mb[0] != MBC_GEN_SYSTEM_ERROR)
+				ha->isp_ops->fw_dump(vha, 0);
+			rval = QLA_FUNCTION_TIMEOUT;
+		 }
 	}
 
 	ha->flags.mbox_busy = 0;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f1a2394..fde7ee1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -897,12 +897,16 @@ static void
 qla2x00_wait_for_hba_ready(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	while (((qla2x00_reset_active(vha)) || ha->dpc_active ||
 	    ha->flags.mbox_busy) ||
 		test_bit(FX00_RESET_RECOVERY, &vha->dpc_flags) ||
-		test_bit(FX00_TARGET_SCAN, &vha->dpc_flags))
+		test_bit(FX00_TARGET_SCAN, &vha->dpc_flags)) {
+			if (test_bit(UNLOADING, &base_vha->dpc_flags))
+				break;
 		msleep(1000);
+	}
 }
 
 int
@@ -2954,10 +2958,7 @@ iospace_config_failed:
 	ha = NULL;
 
 probe_out:
-	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
-	if (test_bit(UNLOADING, &base_vha->dpc_flags))
-		return -ENODEV;
 	return ret;
 }
 
@@ -3138,6 +3139,12 @@ qla2x00_remove_one(struct pci_dev *pdev)
 
 	qla2x00_wait_for_hba_ready(base_vha);
 
+	/* if UNLOAD flag is already set, then continue unload,
+	 * where it was set first.
+	 */
+	if (test_bit(UNLOADING, &base_vha->dpc_flags))
+		return;
+
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 
 	if (IS_QLAFX00(ha))
@@ -4917,6 +4924,12 @@ qla2x00_disable_board_on_pci_error(struct work_struct *work)
 	struct pci_dev *pdev = ha->pdev;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
+	/* if UNLOAD flag is already set, then continue unload,
+	 * where it was set first.
+	 */
+	if (test_bit(UNLOADING, &base_vha->dpc_flags))
+		return;
+
 	ql_log(ql_log_warn, base_vha, 0x015b,
 	    "Disabling adapter.\n");
 
-- 
2.7.2

