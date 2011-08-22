From: James Smart <james.smart@emulex.com>
Subject: [PATCH 2/4] lpfc 8.3.26: Fix HBA initialization issues
Date: Sun, 21 Aug 2011 21:48:49 -0400
Message-ID: <1313977730.21906.5.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:6398 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756391Ab1HVBtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2011 21:49:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix HBA initialization issues

- Swap all values that come from the firmware image on little endian systems.
  Created a new bf_get_be macro that does the same as the bf_get_le macro but
  for big endian data instead of little endian data.
- Moved the incrementing of temp_offset after the copy
  fixed the write object loop to use temp_offset to figure out where the end
  of the image is instead of offset.
- Added the necessary codes for properly bringing the driver instance offline
  and then trying to bring the port back online with the PCI function IP reset.
  If it fails to bring the SLI port back online, it will fall through to
  bringing the SLI port to HBA error offline.
- Add a call in the probe_one_s3 and probe_one_s4 routines to get the Modeldesc
- Change OCe50100 to OCe15100
- Made the error log also include the PCI BAR bitmap returned from kernel call
  pci_select_bars().


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_hw4.h  |    2 ++
 lpfc_init.c |   60 +++++++++++++++++++++++++++++++++---------------------------
 2 files changed, 35 insertions(+), 27 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-08-10 14:34:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-08-19 23:24:18.000000000 -0400
@@ -41,6 +41,8 @@
  * Or clear that bit field:
  *	bf_set(example_bit_field, &t1, 0);
  */
+#define bf_get_be32(name, ptr) \
+	((be32_to_cpu((ptr)->name##_WORD) >> name##_SHIFT) & name##_MASK)
 #define bf_get_le32(name, ptr) \
 	((le32_to_cpu((ptr)->name##_WORD) >> name##_SHIFT) & name##_MASK)
 #define bf_get(name, ptr) \
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-08-10 14:34:51.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-08-19 23:24:18.000000000 -0400
@@ -1481,15 +1481,18 @@ lpfc_handle_eratt_s4(struct lpfc_hba *ph
 			return;
 		}
 		if (bf_get(lpfc_sliport_status_rn, &portstat_reg)) {
-			/*
-			 * TODO: Attempt port recovery via a port reset.
-			 * When fully implemented, the driver should
-			 * attempt to recover the port here and return.
-			 * For now, log an error and take the port offline.
-			 */
+			/* need reset: attempt for port recovery */
 			lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 					"2887 Port Error: Attempting "
 					"Port Recovery\n");
+			lpfc_offline_prep(phba);
+			lpfc_offline(phba);
+			lpfc_sli_brdrestart(phba);
+			if (lpfc_online(phba) == 0) {
+				lpfc_unblock_mgmt_io(phba);
+				return;
+			}
+			/* fall through for not able to recover */
 		}
 		lpfc_sli4_offline_eratt(phba);
 		break;
@@ -1958,7 +1961,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 	case PCI_DEVICE_ID_LANCER_FCOE:
 	case PCI_DEVICE_ID_LANCER_FCOE_VF:
 		oneConnect = 1;
-		m = (typeof(m)){"OCe50100", "PCIe", "FCoE"};
+		m = (typeof(m)){"OCe15100", "PCIe", "FCoE"};
 		break;
 	default:
 		m = (typeof(m)){"Unknown", "", ""};
@@ -3949,7 +3952,7 @@ static int
 lpfc_enable_pci_dev(struct lpfc_hba *phba)
 {
 	struct pci_dev *pdev;
-	int bars;
+	int bars = 0;
 
 	/* Obtain PCI device reference */
 	if (!phba->pcidev)
@@ -3978,6 +3981,8 @@ lpfc_enable_pci_dev(struct lpfc_hba *phb
 out_disable_device:
 	pci_disable_device(pdev);
 out_error:
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"1401 Failed to enable pci device, bars:x%x\n", bars);
 	return -ENODEV;
 }
 
@@ -8271,11 +8276,8 @@ lpfc_pci_probe_one_s3(struct pci_dev *pd
 
 	/* Perform generic PCI device enabling operation */
 	error = lpfc_enable_pci_dev(phba);
-	if (error) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1401 Failed to enable pci device.\n");
+	if (error)
 		goto out_free_phba;
-	}
 
 	/* Set up SLI API function jump table for PCI-device group-0 HBAs */
 	error = lpfc_api_table_setup(phba, LPFC_PCI_DEV_LP);
@@ -8322,6 +8324,9 @@ lpfc_pci_probe_one_s3(struct pci_dev *pd
 		goto out_free_iocb_list;
 	}
 
+	/* Get the default values for Model Name and Description */
+	lpfc_get_hba_model_desc(phba, phba->ModelName, phba->ModelDesc);
+
 	/* Create SCSI host to the physical port */
 	error = lpfc_create_shost(phba);
 	if (error) {
@@ -8885,16 +8890,17 @@ lpfc_write_firmware(struct lpfc_hba *phb
 	uint32_t offset = 0, temp_offset = 0;
 
 	INIT_LIST_HEAD(&dma_buffer_list);
-	if ((image->magic_number != LPFC_GROUP_OJECT_MAGIC_NUM) ||
-	    (bf_get(lpfc_grp_hdr_file_type, image) != LPFC_FILE_TYPE_GROUP) ||
-	    (bf_get(lpfc_grp_hdr_id, image) != LPFC_FILE_ID_GROUP) ||
-	    (image->size != fw->size)) {
+	if ((be32_to_cpu(image->magic_number) != LPFC_GROUP_OJECT_MAGIC_NUM) ||
+	    (bf_get_be32(lpfc_grp_hdr_file_type, image) !=
+	     LPFC_FILE_TYPE_GROUP) ||
+	    (bf_get_be32(lpfc_grp_hdr_id, image) != LPFC_FILE_ID_GROUP) ||
+	    (be32_to_cpu(image->size) != fw->size)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3022 Invalid FW image found. "
-				"Magic:%d Type:%x ID:%x\n",
-				image->magic_number,
-				bf_get(lpfc_grp_hdr_file_type, image),
-				bf_get(lpfc_grp_hdr_id, image));
+				"Magic:%x Type:%x ID:%x\n",
+				be32_to_cpu(image->magic_number),
+				bf_get_be32(lpfc_grp_hdr_file_type, image),
+				bf_get_be32(lpfc_grp_hdr_id, image));
 		return -EINVAL;
 	}
 	lpfc_decode_firmware_rev(phba, fwrev, 1);
@@ -8924,11 +8930,11 @@ lpfc_write_firmware(struct lpfc_hba *phb
 		while (offset < fw->size) {
 			temp_offset = offset;
 			list_for_each_entry(dmabuf, &dma_buffer_list, list) {
-				if (offset + SLI4_PAGE_SIZE > fw->size) {
-					temp_offset += fw->size - offset;
+				if (temp_offset + SLI4_PAGE_SIZE > fw->size) {
 					memcpy(dmabuf->virt,
 					       fw->data + temp_offset,
-					       fw->size - offset);
+					       fw->size - temp_offset);
+					temp_offset = fw->size;
 					break;
 				}
 				memcpy(dmabuf->virt, fw->data + temp_offset,
@@ -8995,11 +9001,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 
 	/* Perform generic PCI device enabling operation */
 	error = lpfc_enable_pci_dev(phba);
-	if (error) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"1409 Failed to enable pci device.\n");
+	if (error)
 		goto out_free_phba;
-	}
 
 	/* Set up SLI API function jump table for PCI-device group-1 HBAs */
 	error = lpfc_api_table_setup(phba, LPFC_PCI_DEV_OC);
@@ -9054,6 +9057,9 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 		goto out_free_iocb_list;
 	}
 
+	/* Get the default values for Model Name and Description */
+	lpfc_get_hba_model_desc(phba, phba->ModelName, phba->ModelDesc);
+
 	/* Create SCSI host to the physical port */
 	error = lpfc_create_shost(phba);
 	if (error) {



