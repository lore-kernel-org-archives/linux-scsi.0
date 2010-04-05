From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.34-rc3
Date: Mon, 05 Apr 2010 17:21:58 -0500
Message-ID: <1270506118.2790.152.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is the first round of bug fixes ... accidentally got incubated a
bit longer than I expected in -next.  Mainly qla vport issues, but some
notable ones (including the lockdep problem with all the transport
classes).

Patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is

Andrew Vasquez (1):
      qla2xxx: Correct vp_idx checking during PORT_UPDATE processing.

Ben Hutchings (1):
      qla2xxx: Disable MSI on qla24xx chips other than QLA2432.

Giridhar Malavali (1):
      qla2xxx: Updated version number to 8.03.02-k2.

Herton Ronaldo Krzesinski (1):
      advansys: fix regression with request_firmware change

James Bottomley (1):
      attirbute_container: Initialize sysfs attributes with sysfs_attr_init

Michael Hernandez (1):
      qla2xxx: Check to make sure multique and CPU affinity support is not enabled at the same time.

Michael Reed (1):
      qla1280: retain firmware for error recovery

Mike Christie (1):
      libiscsi: Fix recovery slowdown regression

Santosh Vernekar (2):
      qla2xxx: Prevent sending mbx commands from sysfs during isp reset.
      qla2xxx: Honour "Extended BB credits" bit for CNAs.

Sarang Radke (1):
      scsi_transport_fc: Make sure commands are completed when rport is offline

And the diffstat

 drivers/base/attribute_container.c |    1 
 drivers/scsi/advansys.c            |    8 +
 drivers/scsi/libiscsi.c            |    5 -
 drivers/scsi/qla1280.c             |  161 +++++++++++++++++++++++++------------
 drivers/scsi/qla2xxx/qla_attr.c    |    6 +
 drivers/scsi/qla2xxx/qla_fw.h      |   18 +++-
 drivers/scsi/qla2xxx/qla_isr.c     |   37 +++-----
 drivers/scsi/qla2xxx/qla_mbx.c     |    8 +
 drivers/scsi/qla2xxx/qla_os.c      |    4 
 drivers/scsi/qla2xxx/qla_version.h |    4 
 drivers/scsi/scsi_transport_fc.c   |    4 
 11 files changed, 172 insertions(+), 84 deletions(-)

The full diff is attached.

James

---
diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index b9cda05..8fc200b 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -328,6 +328,7 @@ attribute_container_add_attrs(struct device *classdev)
 		return sysfs_create_group(&classdev->kobj, cont->grp);
 
 	for (i = 0; attrs[i]; i++) {
+		sysfs_attr_init(&attrs[i]->attr);
 		error = device_create_file(classdev, attrs[i]);
 		if (error)
 			return error;
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 22626ab..9201afe 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -4781,12 +4781,14 @@ static ushort AscInitAsc1000Driver(ASC_DVC_VAR *asc_dvc)
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       fwname, err);
+		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
 		return err;
 	}
 	if (fw->size < 4) {
 		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
+		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
 		return -EINVAL;
 	}
 	chksum = (fw->data[3] << 24) | (fw->data[2] << 16) |
@@ -5110,12 +5112,14 @@ static int AdvInitAsc3550Driver(ADV_DVC_VAR *asc_dvc)
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       fwname, err);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return err;
 	}
 	if (fw->size < 4) {
 		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return -EINVAL;
 	}
 	chksum = (fw->data[3] << 24) | (fw->data[2] << 16) |
@@ -5624,12 +5628,14 @@ static int AdvInitAsc38C0800Driver(ADV_DVC_VAR *asc_dvc)
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       fwname, err);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return err;
 	}
 	if (fw->size < 4) {
 		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return -EINVAL;
 	}
 	chksum = (fw->data[3] << 24) | (fw->data[2] << 16) |
@@ -6124,12 +6130,14 @@ static int AdvInitAsc38C1600Driver(ADV_DVC_VAR *asc_dvc)
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       fwname, err);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return err;
 	}
 	if (fw->size < 4) {
 		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
 		       fw->size, fwname);
 		release_firmware(fw);
+		asc_dvc->err_code = ASC_IERR_MCODE_CHKSUM;
 		return -EINVAL;
 	}
 	chksum = (fw->data[3] << 24) | (fw->data[2] << 16) |
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 685eaec..7688b8f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3087,14 +3087,15 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 		session->state = ISCSI_STATE_TERMINATE;
 	else if (conn->stop_stage != STOP_CONN_RECOVER)
 		session->state = ISCSI_STATE_IN_RECOVERY;
+
+	old_stop_stage = conn->stop_stage;
+	conn->stop_stage = flag;
 	spin_unlock_bh(&session->lock);
 
 	del_timer_sync(&conn->transport_timer);
 	iscsi_suspend_tx(conn);
 
 	spin_lock_bh(&session->lock);
-	old_stop_stage = conn->stop_stage;
-	conn->stop_stage = flag;
 	conn->c_stage = ISCSI_CONN_STOPPED;
 	spin_unlock_bh(&session->lock);
 
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 49ac414..66e2dd4 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -17,9 +17,11 @@
 * General Public License for more details.
 *
 ******************************************************************************/
-#define QLA1280_VERSION      "3.27"
+#define QLA1280_VERSION      "3.27.1"
 /*****************************************************************************
     Revision History:
+    Rev  3.27.1, February 8, 2010, Michael Reed
+	- Retain firmware image for error recovery.
     Rev  3.27, February 10, 2009, Michael Reed
 	- General code cleanup.
 	- Improve error recovery.
@@ -538,9 +540,9 @@ __setup("qla1280=", qla1280_setup);
 /*****************************************/
 
 struct qla_boards {
-	unsigned char name[9];	/* Board ID String */
+	char *name;		/* Board ID String */
 	int numPorts;		/* Number of SCSI ports */
-	char *fwname;		/* firmware name        */
+	int fw_index;		/* index into qla1280_fw_tbl for firmware */
 };
 
 /* NOTE: the last argument in each entry is used to index ql1280_board_tbl */
@@ -561,15 +563,30 @@ static struct pci_device_id qla1280_pci_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pci, qla1280_pci_tbl);
 
+DEFINE_MUTEX(qla1280_firmware_mutex);
+
+struct qla_fw {
+	char *fwname;
+	const struct firmware *fw;
+};
+
+#define QL_NUM_FW_IMAGES 3
+
+struct qla_fw qla1280_fw_tbl[QL_NUM_FW_IMAGES] = {
+	{"qlogic/1040.bin",  NULL},	/* image 0 */
+	{"qlogic/1280.bin",  NULL},	/* image 1 */
+	{"qlogic/12160.bin", NULL},	/* image 2 */
+};
+
+/* NOTE: Order of boards in this table must match order in qla1280_pci_tbl */
 static struct qla_boards ql1280_board_tbl[] = {
-	/* Name ,  Number of ports, FW details */
-	{"QLA12160",	2, "qlogic/12160.bin"},
-	{"QLA1040",	1, "qlogic/1040.bin"},
-	{"QLA1080",	1, "qlogic/1280.bin"},
-	{"QLA1240",	2, "qlogic/1280.bin"},
-	{"QLA1280",	2, "qlogic/1280.bin"},
-	{"QLA10160",	1, "qlogic/12160.bin"},
-	{"        ",	0, "   "},
+	{.name = "QLA12160", .numPorts = 2, .fw_index = 2},
+	{.name = "QLA1040" , .numPorts = 1, .fw_index = 0},
+	{.name = "QLA1080" , .numPorts = 1, .fw_index = 1},
+	{.name = "QLA1240" , .numPorts = 2, .fw_index = 1},
+	{.name = "QLA1280" , .numPorts = 2, .fw_index = 1},
+	{.name = "QLA10160", .numPorts = 1, .fw_index = 2},
+	{.name = "        ", .numPorts = 0, .fw_index = -1},
 };
 
 static int qla1280_verbose = 1;
@@ -1512,6 +1529,63 @@ qla1280_initialize_adapter(struct scsi_qla_host *ha)
 }
 
 /*
+ * qla1280_request_firmware
+ *      Acquire firmware for chip.  Retain in memory
+ *      for error recovery.
+ *
+ * Input:
+ *      ha = adapter block pointer.
+ *
+ * Returns:
+ *      Pointer to firmware image or an error code
+ *      cast to pointer via ERR_PTR().
+ */
+static const struct firmware *
+qla1280_request_firmware(struct scsi_qla_host *ha)
+{
+	const struct firmware *fw;
+	int err;
+	int index;
+	char *fwname;
+
+	spin_unlock_irq(ha->host->host_lock);
+	mutex_lock(&qla1280_firmware_mutex);
+
+	index = ql1280_board_tbl[ha->devnum].fw_index;
+	fw = qla1280_fw_tbl[index].fw;
+	if (fw)
+		goto out;
+
+	fwname = qla1280_fw_tbl[index].fwname;
+	err = request_firmware(&fw, fwname, &ha->pdev->dev);
+
+	if (err) {
+		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
+		       fwname, err);
+		fw = ERR_PTR(err);
+		goto unlock;
+	}
+	if ((fw->size % 2) || (fw->size < 6)) {
+		printk(KERN_ERR "Invalid firmware length %zu in image \"%s\"\n",
+		       fw->size, fwname);
+		release_firmware(fw);
+		fw = ERR_PTR(-EINVAL);
+		goto unlock;
+	}
+
+	qla1280_fw_tbl[index].fw = fw;
+
+ out:
+	ha->fwver1 = fw->data[0];
+	ha->fwver2 = fw->data[1];
+	ha->fwver3 = fw->data[2];
+ unlock:
+	mutex_unlock(&qla1280_firmware_mutex);
+	spin_lock_irq(ha->host->host_lock);
+	return fw;
+}
+
+/*
  * Chip diagnostics
  *      Test chip for proper operation.
  *
@@ -1634,30 +1708,18 @@ qla1280_chip_diag(struct scsi_qla_host *ha)
 static int
 qla1280_load_firmware_pio(struct scsi_qla_host *ha)
 {
+	/* enter with host_lock acquired */
+
 	const struct firmware *fw;
 	const __le16 *fw_data;
 	uint16_t risc_address, risc_code_size;
 	uint16_t mb[MAILBOX_REGISTER_COUNT], i;
-	int err;
+	int err = 0;
+
+	fw = qla1280_request_firmware(ha);
+	if (IS_ERR(fw))
+		return PTR_ERR(fw);
 
-	spin_unlock_irq(ha->host->host_lock);
-	err = request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
-			       &ha->pdev->dev);
-	spin_lock_irq(ha->host->host_lock);
-	if (err) {
-		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
-		       ql1280_board_tbl[ha->devnum].fwname, err);
-		return err;
-	}
-	if ((fw->size % 2) || (fw->size < 6)) {
-		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
-		       fw->size, ql1280_board_tbl[ha->devnum].fwname);
-		err = -EINVAL;
-		goto out;
-	}
-	ha->fwver1 = fw->data[0];
-	ha->fwver2 = fw->data[1];
-	ha->fwver3 = fw->data[2];
 	fw_data = (const __le16 *)&fw->data[0];
 	ha->fwstart = __le16_to_cpu(fw_data[2]);
 
@@ -1675,11 +1737,10 @@ qla1280_load_firmware_pio(struct scsi_qla_host *ha)
 		if (err) {
 			printk(KERN_ERR "scsi(%li): Failed to load firmware\n",
 					ha->host_no);
-			goto out;
+			break;
 		}
 	}
-out:
-	release_firmware(fw);
+
 	return err;
 }
 
@@ -1687,6 +1748,7 @@ out:
 static int
 qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 {
+	/* enter with host_lock acquired */
 	const struct firmware *fw;
 	const __le16 *fw_data;
 	uint16_t risc_address, risc_code_size;
@@ -1701,24 +1763,10 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 		return -ENOMEM;
 #endif
 
-	spin_unlock_irq(ha->host->host_lock);
-	err = request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
-			       &ha->pdev->dev);
-	spin_lock_irq(ha->host->host_lock);
-	if (err) {
-		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
-		       ql1280_board_tbl[ha->devnum].fwname, err);
-		return err;
-	}
-	if ((fw->size % 2) || (fw->size < 6)) {
-		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
-		       fw->size, ql1280_board_tbl[ha->devnum].fwname);
-		err = -EINVAL;
-		goto out;
-	}
-	ha->fwver1 = fw->data[0];
-	ha->fwver2 = fw->data[1];
-	ha->fwver3 = fw->data[2];
+	fw = qla1280_request_firmware(ha);
+	if (IS_ERR(fw))
+		return PTR_ERR(fw);
+
 	fw_data = (const __le16 *)&fw->data[0];
 	ha->fwstart = __le16_to_cpu(fw_data[2]);
 
@@ -1803,7 +1851,6 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 #if DUMP_IT_BACK
 	pci_free_consistent(ha->pdev, 8000, tbuf, p_tbuf);
 #endif
-	release_firmware(fw);
 	return err;
 }
 
@@ -1842,6 +1889,7 @@ qla1280_start_firmware(struct scsi_qla_host *ha)
 static int
 qla1280_load_firmware(struct scsi_qla_host *ha)
 {
+	/* enter with host_lock taken */
 	int err;
 
 	err = qla1280_chip_diag(ha);
@@ -4420,7 +4468,16 @@ qla1280_init(void)
 static void __exit
 qla1280_exit(void)
 {
+	int i;
+
 	pci_unregister_driver(&qla1280_pci_driver);
+	/* release any allocated firmware images */
+	for (i = 0; i < QL_NUM_FW_IMAGES; i++) {
+		if (qla1280_fw_tbl[i].fw) {
+			release_firmware(qla1280_fw_tbl[i].fw);
+			qla1280_fw_tbl[i].fw = NULL;
+		}
+	}
 }
 
 module_init(qla1280_init);
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 90d1e06..35a3252 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1274,7 +1274,11 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
 	int rval = QLA_FUNCTION_FAILED;
 	uint16_t state[5];
 
-	if (!vha->hw->flags.eeh_busy)
+	if (test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
+		test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags))
+		DEBUG2_3_11(printk("%s(%ld): isp reset in progress.\n",
+			__func__, vha->host_no));
+	else if (!vha->hw->flags.eeh_busy)
 		rval = qla2x00_get_firmware_state(vha, state);
 	if (rval != QLA_SUCCESS)
 		memset(state, -1, sizeof(state));
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index cebf4f1..42c5587 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1592,10 +1592,22 @@ struct nvram_81xx {
 
 	/* Offset 384. */
 	uint8_t reserved_21[16];
-	uint16_t reserved_22[8];
+	uint16_t reserved_22[3];
+
+	/*
+	 * BIT 0 = Extended BB credits for LR
+	 * BIT 1 = Virtual Fabric Enable
+	 * BIT 2 = Enhanced Features Unused
+	 * BIT 3-7 = Enhanced Features Reserved
+	 */
+	/* Enhanced Features */
+	uint8_t enhanced_features;
+
+	uint8_t reserved_23;
+	uint16_t reserved_24[4];
 
 	/* Offset 416. */
-	uint16_t reserved_23[32];
+	uint16_t reserved_25[32];
 
 	/* Offset 480. */
 	uint8_t model_name[16];
@@ -1603,7 +1615,7 @@ struct nvram_81xx {
 	/* Offset 496. */
 	uint16_t feature_mask_l;
 	uint16_t feature_mask_h;
-	uint16_t reserved_24[2];
+	uint16_t reserved_26[2];
 
 	uint16_t subsystem_vendor_id;
 	uint16_t subsystem_device_id;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index ab90329..44df0b7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -620,11 +620,10 @@ skip_rio:
 		 *           vp_idx does not match
 		 *       Event is not global, vp_idx does not match
 		 */
-		if ((mb[1] == 0xffff && (mb[3] & 0xff) != 0xff)
-			|| (mb[1] != 0xffff)) {
-			if (vha->vp_idx != (mb[3] & 0xff))
-				break;
-		}
+		if (IS_QLA2XXX_MIDTYPE(ha) &&
+		    ((mb[1] == 0xffff && (mb[3] & 0xff) != 0xff) ||
+			(mb[1] != 0xffff)) && vha->vp_idx != (mb[3] & 0xff))
+			break;
 
 		/* Global event -- port logout or port unavailable. */
 		if (mb[1] == 0xffff && mb[2] == 0x7) {
@@ -2272,30 +2271,28 @@ qla2x00_request_irqs(struct qla_hw_data *ha, struct rsp_que *rsp)
 
 	/* If possible, enable MSI-X. */
 	if (!IS_QLA2432(ha) && !IS_QLA2532(ha) &&
-	    !IS_QLA8432(ha) && !IS_QLA8001(ha))
-		goto skip_msix;
+		!IS_QLA8432(ha) && !IS_QLA8001(ha))
+		goto skip_msi;
+
+	if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
+		(ha->pdev->subsystem_device == 0x7040 ||
+		ha->pdev->subsystem_device == 0x7041 ||
+		ha->pdev->subsystem_device == 0x1705)) {
+		DEBUG2(qla_printk(KERN_WARNING, ha,
+			"MSI-X: Unsupported ISP2432 SSVID/SSDID (0x%X,0x%X).\n",
+			ha->pdev->subsystem_vendor,
+			ha->pdev->subsystem_device));
+		goto skip_msi;
+	}
 
 	if (IS_QLA2432(ha) && (ha->pdev->revision < QLA_MSIX_CHIP_REV_24XX ||
 		!QLA_MSIX_FW_MODE_1(ha->fw_attributes))) {
 		DEBUG2(qla_printk(KERN_WARNING, ha,
 		"MSI-X: Unsupported ISP2432 (0x%X, 0x%X).\n",
 			ha->pdev->revision, ha->fw_attributes));
-
 		goto skip_msix;
 	}
 
-	if (ha->pdev->subsystem_vendor == PCI_VENDOR_ID_HP &&
-	    (ha->pdev->subsystem_device == 0x7040 ||
-		ha->pdev->subsystem_device == 0x7041 ||
-		ha->pdev->subsystem_device == 0x1705)) {
-		DEBUG2(qla_printk(KERN_WARNING, ha,
-		    "MSI-X: Unsupported ISP2432 SSVID/SSDID (0x%X, 0x%X).\n",
-		    ha->pdev->subsystem_vendor,
-		    ha->pdev->subsystem_device));
-
-		goto skip_msi;
-	}
-
 	ret = qla24xx_enable_msix(ha, rsp);
 	if (!ret) {
 		DEBUG2(qla_printk(KERN_INFO, ha,
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 6e53bdb..3ba9a2b 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -339,6 +339,7 @@ qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t risc_addr,
 	return rval;
 }
 
+#define	EXTENDED_BB_CREDITS	BIT_0
 /*
  * qla2x00_execute_fw
  *     Start adapter firmware.
@@ -371,7 +372,12 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 		mcp->mb[1] = MSW(risc_addr);
 		mcp->mb[2] = LSW(risc_addr);
 		mcp->mb[3] = 0;
-		mcp->mb[4] = 0;
+		if (IS_QLA81XX(ha)) {
+			struct nvram_81xx *nv = ha->nvram;
+			mcp->mb[4] = (nv->enhanced_features &
+			    EXTENDED_BB_CREDITS);
+		} else
+			mcp->mb[4] = 0;
 		mcp->out_mb |= MBX_4|MBX_3|MBX_2|MBX_1;
 		mcp->in_mb |= MBX_1;
 	} else {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 46720b2..be3f1d3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1676,9 +1676,11 @@ skip_pio:
 
 	/* Determine queue resources */
 	ha->max_req_queues = ha->max_rsp_queues = 1;
-	if ((ql2xmaxqueues <= 1 || ql2xmultique_tag < 1) &&
+	if ((ql2xmaxqueues <= 1 && !ql2xmultique_tag) ||
+		(ql2xmaxqueues > 1 && ql2xmultique_tag) ||
 		(!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
 		goto mqiobase_exit;
+
 	ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 3),
 			pci_resource_len(ha->pdev, 3));
 	if (ha->mqiobase) {
diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
index 8d2fc2f..109068d 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.03.02-k1"
+#define QLA2XXX_VERSION      "8.03.02-k2"
 
 #define QLA_DRIVER_MAJOR_VER	8
 #define QLA_DRIVER_MINOR_VER	3
 #define QLA_DRIVER_PATCH_VER	2
-#define QLA_DRIVER_BETA_VER	1
+#define QLA_DRIVER_BETA_VER	2
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index 1d5b721..e37aeeb 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -3852,7 +3852,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
 		if (rport && (rport->port_state != FC_PORTSTATE_ONLINE)) {
 			req->errors = -ENXIO;
 			spin_unlock_irq(q->queue_lock);
-			blk_end_request(req, -ENXIO, blk_rq_bytes(req));
+			blk_end_request_all(req, -ENXIO);
 			spin_lock_irq(q->queue_lock);
 			continue;
 		}
@@ -3862,7 +3862,7 @@ fc_bsg_request_handler(struct request_queue *q, struct Scsi_Host *shost,
 		ret = fc_req_to_bsgjob(shost, rport, req);
 		if (ret) {
 			req->errors = ret;
-			blk_end_request(req, ret, blk_rq_bytes(req));
+			blk_end_request_all(req, ret);
 			spin_lock_irq(q->queue_lock);
 			continue;
 		}
