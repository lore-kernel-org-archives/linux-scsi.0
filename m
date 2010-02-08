From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 2/2] qla1280: retain firmware for error recovery
Date: Mon, 08 Feb 2010 15:21:59 -0600
Message-ID: <4B708077.8010709@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay2.sgi.com ([192.48.179.30]:36410 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751390Ab0BHVWG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2010 16:22:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Jeremy Higdon <jeremy@sgi.com>, Jes Sorensen <jes@sgi.com>, Jes Sorensen <jes@trained-monkey.org>, Tony Ernst <tee@sgi.com>


The qla1280 driver acquires its firmware via udev.  During boot the firmware
is located in the initrd.  If, after root is mounted, the adapter needs to
reload firmware (host reset), the firmware load may fail if the root device
is on the adapter being reset.  This patch modifies qla1280 to retain the
firmware loaded via the initial request_firmware() for use during error
recovery.

Signed-off-by: Michael Reed <mdr@sgi.com>


--- linux-2.6.32.5-0.1/drivers/scsi/qla1280.c	2010-02-04 16:23:10.831352910 -0600
+++ linux-2.6.32.5-0.1-modified/drivers/scsi/qla1280.c	2010-02-08 15:05:42.402094235 -0600
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
@@ -561,15 +563,30 @@ static struct pci_device_id qla1280_pci_
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
+	{.name="QLA12160", .numPorts=2, .fw_index=2},
+	{.name="QLA1040" , .numPorts=1, .fw_index=0},
+	{.name="QLA1080" , .numPorts=1, .fw_index=1},
+	{.name="QLA1240" , .numPorts=2, .fw_index=1},
+	{.name="QLA1280" , .numPorts=2, .fw_index=1},
+	{.name="QLA10160", .numPorts=1, .fw_index=2},
+	{.name="        ", .numPorts=0, .fw_index=-1},
 };
 
 static int qla1280_verbose = 1;
@@ -1512,6 +1529,63 @@ qla1280_initialize_adapter(struct scsi_q
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
@@ -1634,30 +1708,18 @@ qla1280_chip_diag(struct scsi_qla_host *
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
+	int err=0;
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
 
@@ -1675,11 +1737,10 @@ qla1280_load_firmware_pio(struct scsi_ql
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
@@ -1701,24 +1763,10 @@ qla1280_load_firmware_dma(struct scsi_ql
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
 
@@ -1803,7 +1851,6 @@ qla1280_load_firmware_dma(struct scsi_ql
 #if DUMP_IT_BACK
 	pci_free_consistent(ha->pdev, 8000, tbuf, p_tbuf);
 #endif
-	release_firmware(fw);
 	return err;
 }
 
@@ -1842,6 +1889,7 @@ qla1280_start_firmware(struct scsi_qla_h
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
+	for (i=0; i<QL_NUM_FW_IMAGES; i++) {
+		if (qla1280_fw_tbl[i].fw) {
+			release_firmware(qla1280_fw_tbl[i].fw);
+			qla1280_fw_tbl[i].fw = NULL;
+		}
+	}
 }
 
 module_init(qla1280_init);
