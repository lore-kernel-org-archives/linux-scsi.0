From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 1/2] qla1280: Unify common code in
 qla1280_load_firmware_{dma,pio}()
Date: Sun, 23 Aug 2009 16:34:42 +0100
Message-ID: <1251041682.16001.247.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51298 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933746AbZHWPep (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Aug 2009 11:34:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

The verification and copying of metadata from the firmware is
identical in the two functions, and can be done in their caller.

As a side-effect, this fixes a leak when DUMP_IT_BACK is defined and
request_firmware() fails.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/qla1280.c |   78 ++++++++++++++++++------------------------------
 1 files changed, 29 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 8371d91..4951344 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1632,33 +1632,13 @@ qla1280_chip_diag(struct scsi_qla_host *ha)
 }
 
 static int
-qla1280_load_firmware_pio(struct scsi_qla_host *ha)
+qla1280_load_firmware_pio(struct scsi_qla_host *ha, const struct firmware *fw)
 {
-	const struct firmware *fw;
 	const __le16 *fw_data;
 	uint16_t risc_address, risc_code_size;
 	uint16_t mb[MAILBOX_REGISTER_COUNT], i;
 	int err;
 
-	err = request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
-			       &ha->pdev->dev);
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
-	fw_data = (const __le16 *)&fw->data[0];
-	ha->fwstart = __le16_to_cpu(fw_data[2]);
-
 	/* Load RISC code. */
 	risc_address = ha->fwstart;
 	fw_data = (const __le16 *)&fw->data[6];
@@ -1673,19 +1653,16 @@ qla1280_load_firmware_pio(struct scsi_qla_host *ha)
 		if (err) {
 			printk(KERN_ERR "scsi(%li): Failed to load firmware\n",
 					ha->host_no);
-			goto out;
+			return err;
 		}
 	}
-out:
-	release_firmware(fw);
-	return err;
+	return 0;
 }
 
 #define DUMP_IT_BACK 0		/* for debug of RISC loading */
 static int
-qla1280_load_firmware_dma(struct scsi_qla_host *ha)
+qla1280_load_firmware_dma(struct scsi_qla_host *ha, const struct firmware *fw)
 {
-	const struct firmware *fw;
 	const __le16 *fw_data;
 	uint16_t risc_address, risc_code_size;
 	uint16_t mb[MAILBOX_REGISTER_COUNT], cnt;
@@ -1699,25 +1676,6 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 		return -ENOMEM;
 #endif
 
-	err = request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
-			       &ha->pdev->dev);
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
-	fw_data = (const __le16 *)&fw->data[0];
-	ha->fwstart = __le16_to_cpu(fw_data[2]);
-
 	/* Load RISC code. */
 	risc_address = ha->fwstart;
 	fw_data = (const __le16 *)&fw->data[6];
@@ -1799,7 +1757,6 @@ qla1280_load_firmware_dma(struct scsi_qla_host *ha)
 #if DUMP_IT_BACK
 	pci_free_consistent(ha->pdev, 8000, tbuf, p_tbuf);
 #endif
-	release_firmware(fw);
 	return err;
 }
 
@@ -1838,19 +1795,42 @@ qla1280_start_firmware(struct scsi_qla_host *ha)
 static int
 qla1280_load_firmware(struct scsi_qla_host *ha)
 {
+	const struct firmware *fw;
+	const __le16 *fw_data;
 	int err;
 
 	err = qla1280_chip_diag(ha);
 	if (err)
+		return err;
+
+	err = request_firmware(&fw, ql1280_board_tbl[ha->devnum].fwname,
+			       &ha->pdev->dev);
+	if (err) {
+		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
+		       ql1280_board_tbl[ha->devnum].fwname, err);
+		return err;
+	}
+	if ((fw->size % 2) || (fw->size < 6)) {
+		printk(KERN_ERR "Bogus length %zu in image \"%s\"\n",
+		       fw->size, ql1280_board_tbl[ha->devnum].fwname);
+		err = -EINVAL;
 		goto out;
+	}
+	ha->fwver1 = fw->data[0];
+	ha->fwver2 = fw->data[1];
+	ha->fwver3 = fw->data[2];
+	fw_data = (const __le16 *)&fw->data[0];
+	ha->fwstart = __le16_to_cpu(fw_data[2]);
+
 	if (IS_ISP1040(ha))
-		err = qla1280_load_firmware_pio(ha);
+		err = qla1280_load_firmware_pio(ha, fw);
 	else
-		err = qla1280_load_firmware_dma(ha);
+		err = qla1280_load_firmware_dma(ha, fw);
 	if (err)
 		goto out;
 	err = qla1280_start_firmware(ha);
  out:
+	release_firmware(fw);
 	return err;
 }
 
-- 
1.6.3.3


