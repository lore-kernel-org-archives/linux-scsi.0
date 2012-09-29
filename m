From: James Smart <james.smart@emulex.com>
Subject: [PATCH 08/16] lpfc 8.3.35: Correct request_firmware use that was
 increasing boot times
Date: Sat, 29 Sep 2012 11:30:56 -0400
Message-ID: <1348932656.23909.27.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:35018 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab2I2Pg3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Sep 2012 11:36:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Correct request_firmware use that was increasing boot times


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   57 +++++++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 26 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 21:11:37.227153927 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2012-09-26 21:11:40.048153996 -0400
@@ -9309,23 +9309,28 @@ lpfc_sli4_get_els_iocb_cnt(struct lpfc_h
 
 /**
  * lpfc_write_firmware - attempt to write a firmware image to the port
- * @phba: pointer to lpfc hba data structure.
  * @fw: pointer to firmware image returned from request_firmware.
+ * @phba: pointer to lpfc hba data structure.
  *
- * returns the number of bytes written if write is successful.
- * returns a negative error value if there were errors.
- * returns 0 if firmware matches currently active firmware on port.
  **/
-int
-lpfc_write_firmware(struct lpfc_hba *phba, const struct firmware *fw)
+static void
+lpfc_write_firmware(const struct firmware *fw, void *context)
 {
+	struct lpfc_hba *phba = (struct lpfc_hba *)context;
 	char fwrev[FW_REV_STR_SIZE];
-	struct lpfc_grp_hdr *image = (struct lpfc_grp_hdr *)fw->data;
+	struct lpfc_grp_hdr *image;
 	struct list_head dma_buffer_list;
 	int i, rc = 0;
 	struct lpfc_dmabuf *dmabuf, *next;
 	uint32_t offset = 0, temp_offset = 0;
 
+	/* It can be null, sanity check */
+	if (!fw) {
+		rc = -ENXIO;
+		goto out;
+	}
+	image = (struct lpfc_grp_hdr *)fw->data;
+
 	INIT_LIST_HEAD(&dma_buffer_list);
 	if ((be32_to_cpu(image->magic_number) != LPFC_GROUP_OJECT_MAGIC_NUM) ||
 	    (bf_get_be32(lpfc_grp_hdr_file_type, image) !=
@@ -9338,12 +9343,13 @@ lpfc_write_firmware(struct lpfc_hba *phb
 				be32_to_cpu(image->magic_number),
 				bf_get_be32(lpfc_grp_hdr_file_type, image),
 				bf_get_be32(lpfc_grp_hdr_id, image));
-		return -EINVAL;
+		rc = -EINVAL;
+		goto release_out;
 	}
 	lpfc_decode_firmware_rev(phba, fwrev, 1);
 	if (strncmp(fwrev, image->revision, strnlen(image->revision, 16))) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3023 Updating Firmware. Current Version:%s "
+				"3023 Updating Firmware, Current Version:%s "
 				"New Version:%s\n",
 				fwrev, image->revision);
 		for (i = 0; i < LPFC_MBX_WR_CONFIG_MAX_BDE; i++) {
@@ -9351,7 +9357,7 @@ lpfc_write_firmware(struct lpfc_hba *phb
 					 GFP_KERNEL);
 			if (!dmabuf) {
 				rc = -ENOMEM;
-				goto out;
+				goto release_out;
 			}
 			dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
 							  SLI4_PAGE_SIZE,
@@ -9360,7 +9366,7 @@ lpfc_write_firmware(struct lpfc_hba *phb
 			if (!dmabuf->virt) {
 				kfree(dmabuf);
 				rc = -ENOMEM;
-				goto out;
+				goto release_out;
 			}
 			list_add_tail(&dmabuf->list, &dma_buffer_list);
 		}
@@ -9380,23 +9386,24 @@ lpfc_write_firmware(struct lpfc_hba *phb
 			}
 			rc = lpfc_wr_object(phba, &dma_buffer_list,
 				    (fw->size - offset), &offset);
-			if (rc) {
-				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-						"3024 Firmware update failed. "
-						"%d\n", rc);
-				goto out;
-			}
+			if (rc)
+				goto release_out;
 		}
 		rc = offset;
 	}
-out:
+
+release_out:
 	list_for_each_entry_safe(dmabuf, next, &dma_buffer_list, list) {
 		list_del(&dmabuf->list);
 		dma_free_coherent(&phba->pcidev->dev, SLI4_PAGE_SIZE,
 				  dmabuf->virt, dmabuf->phys);
 		kfree(dmabuf);
 	}
-	return rc;
+	release_firmware(fw);
+out:
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"3024 Firmware update done: %d.", rc);
+	return;
 }
 
 /**
@@ -9423,11 +9430,10 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	struct lpfc_hba   *phba;
 	struct lpfc_vport *vport = NULL;
 	struct Scsi_Host  *shost = NULL;
-	int error;
+	int error, ret;
 	uint32_t cfg_mode, intr_mode;
 	int mcnt;
 	int adjusted_fcp_io_channel;
-	const struct firmware *fw;
 	uint8_t file_name[ELX_MODEL_NAME_SIZE];
 
 	/* Allocate memory for HBA structure */
@@ -9576,11 +9582,10 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	    LPFC_SLI_INTF_IF_TYPE_2) {
 		snprintf(file_name, ELX_MODEL_NAME_SIZE, "%s.grp",
 			 phba->ModelName);
-		error = request_firmware(&fw, file_name, &phba->pcidev->dev);
-		if (!error) {
-			lpfc_write_firmware(phba, fw);
-			release_firmware(fw);
-		}
+		ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
+					file_name, &phba->pcidev->dev,
+					GFP_KERNEL, (void *)phba,
+					lpfc_write_firmware);
 	}
 
 	/* Check if there are static vports to be created. */



