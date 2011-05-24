From: James Smart <james.smart@emulex.com>
Subject: [PATCH 4/8] lpfc 8.3.24: Add request-firmware support
Date: Tue, 24 May 2011 11:42:45 -0400
Message-ID: <1306251765.6335.16.camel@wookie>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:23149 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753624Ab1EXPnM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 May 2011 11:43:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add request-firmware support:
- Add support for request_firmware interface for INTF2 SLI4 ports.
- Add ability to reset SLI4 INTF2 ports.


 Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_attr.c |   33 ++++++++++++-------
 lpfc_crtn.h |    1 
 lpfc_hw4.h  |   44 +++++++++++++++++++++++++
 lpfc_init.c |  102 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lpfc_sli.c  |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 259 insertions(+), 11 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2011-05-23 17:01:19.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2011-05-23 17:02:32.000000000 -0400
@@ -755,18 +755,18 @@ lpfc_issue_reset(struct device *dev, str
 }
 
 /**
- * lpfc_sli4_fw_dump_request - Request firmware to perform a firmware dump
+ * lpfc_sli4_pdev_reg_request - Request physical dev to perform a register acc
  * @phba: lpfc_hba pointer.
  *
  * Description:
- * Request SLI4 interface type-2 device to perform a dump of firmware dump
- * object into it's /dbg directory of the flash file system.
+ * Request SLI4 interface type-2 device to perform a physical register set
+ * access.
  *
  * Returns:
  * zero for success
  **/
 static ssize_t
-lpfc_sli4_fw_dump_request(struct lpfc_hba *phba)
+lpfc_sli4_pdev_reg_request(struct lpfc_hba *phba, uint32_t opcode)
 {
 	struct completion online_compl;
 	uint32_t reg_val;
@@ -776,6 +776,11 @@ lpfc_sli4_fw_dump_request(struct lpfc_hb
 	if (!phba->cfg_enable_hba_reset)
 		return -EIO;
 
+	if ((phba->sli_rev < LPFC_SLI_REV4) ||
+	    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
+	     LPFC_SLI_INTF_IF_TYPE_2))
+		return -EPERM;
+
 	status = lpfc_do_offline(phba, LPFC_EVT_OFFLINE);
 
 	if (status != 0)
@@ -786,7 +791,14 @@ lpfc_sli4_fw_dump_request(struct lpfc_hb
 
 	reg_val = readl(phba->sli4_hba.conf_regs_memmap_p +
 			LPFC_CTL_PDEV_CTL_OFFSET);
-	reg_val |= LPFC_FW_DUMP_REQUEST;
+
+	if (opcode == LPFC_FW_DUMP)
+		reg_val |= LPFC_FW_DUMP_REQUEST;
+	else if (opcode == LPFC_FW_RESET)
+		reg_val |= LPFC_CTL_PDEV_CTL_FRST;
+	else if (opcode == LPFC_DV_RESET)
+		reg_val |= LPFC_CTL_PDEV_CTL_DRST;
+
 	writel(reg_val, phba->sli4_hba.conf_regs_memmap_p +
 	       LPFC_CTL_PDEV_CTL_OFFSET);
 	/* flush */
@@ -904,12 +916,11 @@ lpfc_board_mode_store(struct device *dev
 		else
 			status = lpfc_do_offline(phba, LPFC_EVT_KILL);
 	else if (strncmp(buf, "dump", sizeof("dump") - 1) == 0)
-		if ((phba->sli_rev < LPFC_SLI_REV4) ||
-		    (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) !=
-		     LPFC_SLI_INTF_IF_TYPE_2))
-			return -EPERM;
-		else
-			status = lpfc_sli4_fw_dump_request(phba);
+		status = lpfc_sli4_pdev_reg_request(phba, LPFC_FW_DUMP);
+	else if (strncmp(buf, "fw_reset", sizeof("fw_reset") - 1) == 0)
+		status = lpfc_sli4_pdev_reg_request(phba, LPFC_FW_RESET);
+	else if (strncmp(buf, "dv_reset", sizeof("dv_reset") - 1) == 0)
+		status = lpfc_sli4_pdev_reg_request(phba, LPFC_DV_RESET);
 	else
 		return -EINVAL;
 
diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2011-05-23 17:01:19.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2011-05-23 17:02:32.000000000 -0400
@@ -430,5 +430,6 @@ void lpfc_cleanup_wt_rrqs(struct lpfc_hb
 void lpfc_cleanup_vports_rrqs(struct lpfc_vport *, struct lpfc_nodelist *);
 struct lpfc_node_rrq *lpfc_get_active_rrq(struct lpfc_vport *, uint16_t,
 	uint32_t);
+int lpfc_wr_object(struct lpfc_hba *, struct list_head *, uint32_t, uint32_t *);
 /* functions to support SR-IOV */
 int lpfc_sli_probe_sriov_nr_virtfn(struct lpfc_hba *, int);
diff -upNr a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
--- a/drivers/scsi/lpfc/lpfc_hw4.h	2011-05-23 17:01:19.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hw4.h	2011-05-23 17:02:32.000000000 -0400
@@ -821,6 +821,7 @@ struct mbox_header {
 #define LPFC_MBOX_OPCODE_MQ_CREATE_EXT		0x5A
 #define LPFC_MBOX_OPCODE_GET_FUNCTION_CONFIG    0xA0
 #define LPFC_MBOX_OPCODE_GET_PROFILE_CONFIG	0xA4
+#define LPFC_MBOX_OPCODE_WRITE_OBJECT		0xAC
 #define LPFC_MBOX_OPCODE_GET_SLI4_PARAMETERS	0xB5
 
 /* FCoE Opcodes */
@@ -2372,6 +2373,29 @@ struct lpfc_mbx_get_prof_cfg {
 #define MB_CEQ_STATUS_QUEUE_FLUSHING		0x4
 #define MB_CQE_STATUS_DMA_FAILED		0x5
 
+#define LPFC_MBX_WR_CONFIG_MAX_BDE		8
+struct lpfc_mbx_wr_object {
+	struct mbox_header header;
+	union {
+		struct {
+			uint32_t word4;
+#define lpfc_wr_object_eof_SHIFT		31
+#define lpfc_wr_object_eof_MASK			0x00000001
+#define lpfc_wr_object_eof_WORD			word4
+#define lpfc_wr_object_write_length_SHIFT	0
+#define lpfc_wr_object_write_length_MASK	0x00FFFFFF
+#define lpfc_wr_object_write_length_WORD	word4
+			uint32_t write_offset;
+			uint32_t object_name[26];
+			uint32_t bde_count;
+			struct ulp_bde64 bde[LPFC_MBX_WR_CONFIG_MAX_BDE];
+		} request;
+		struct {
+			uint32_t actual_write_length;
+		} response;
+	} u;
+};
+
 /* mailbox queue entry structure */
 struct lpfc_mqe {
 	uint32_t word0;
@@ -2421,6 +2445,7 @@ struct lpfc_mqe {
 		struct lpfc_mbx_get_func_cfg get_func_cfg;
 		struct lpfc_mbx_get_prof_cfg get_prof_cfg;
 		struct lpfc_mbx_nop nop;
+		struct lpfc_mbx_wr_object wr_object;
 	} un;
 };
 
@@ -2966,9 +2991,28 @@ union lpfc_wqe {
 	struct gen_req64_wqe gen_req;
 };
 
+#define LPFC_GROUP_OJECT_MAGIC_NUM		0xfeaa0001
+#define LPFC_FILE_TYPE_GROUP			0xf7
+#define LPFC_FILE_ID_GROUP			0xa2
+struct lpfc_grp_hdr {
+	uint32_t size;
+	uint32_t magic_number;
+	uint32_t word2;
+#define lpfc_grp_hdr_file_type_SHIFT	24
+#define lpfc_grp_hdr_file_type_MASK	0x000000FF
+#define lpfc_grp_hdr_file_type_WORD	word2
+#define lpfc_grp_hdr_id_SHIFT		16
+#define lpfc_grp_hdr_id_MASK		0x000000FF
+#define lpfc_grp_hdr_id_WORD		word2
+	uint8_t rev_name[128];
+};
+
 #define FCP_COMMAND 0x0
 #define FCP_COMMAND_DATA_OUT 0x1
 #define ELS_COMMAND_NON_FIP 0xC
 #define ELS_COMMAND_FIP 0xD
 #define OTHER_COMMAND 0x8
 
+#define LPFC_FW_DUMP	1
+#define LPFC_FW_RESET	2
+#define LPFC_DV_RESET	3
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2011-05-23 17:01:19.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2011-05-23 17:02:32.000000000 -0400
@@ -30,6 +30,7 @@
 #include <linux/ctype.h>
 #include <linux/aer.h>
 #include <linux/slab.h>
+#include <linux/firmware.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -8775,6 +8776,97 @@ lpfc_sli4_get_els_iocb_cnt(struct lpfc_h
 }
 
 /**
+ * lpfc_write_firmware - attempt to write a firmware image to the port
+ * @phba: pointer to lpfc hba data structure.
+ * @fw: pointer to firmware image returned from request_firmware.
+ *
+ * returns the number of bytes written if write is successful.
+ * returns a negative error value if there were errors.
+ * returns 0 if firmware matches currently active firmware on port.
+ **/
+int
+lpfc_write_firmware(struct lpfc_hba *phba, const struct firmware *fw)
+{
+	char fwrev[32];
+	struct lpfc_grp_hdr *image = (struct lpfc_grp_hdr *)fw->data;
+	struct list_head dma_buffer_list;
+	int i, rc = 0;
+	struct lpfc_dmabuf *dmabuf, *next;
+	uint32_t offset = 0, temp_offset = 0;
+
+	INIT_LIST_HEAD(&dma_buffer_list);
+	if ((image->magic_number != LPFC_GROUP_OJECT_MAGIC_NUM) ||
+	    (bf_get(lpfc_grp_hdr_file_type, image) != LPFC_FILE_TYPE_GROUP) ||
+	    (bf_get(lpfc_grp_hdr_id, image) != LPFC_FILE_ID_GROUP) ||
+	    (image->size != fw->size)) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3022 Invalid FW image found. "
+				"Magic:%d Type:%x ID:%x\n",
+				image->magic_number,
+				bf_get(lpfc_grp_hdr_file_type, image),
+				bf_get(lpfc_grp_hdr_id, image));
+		return -EINVAL;
+	}
+	lpfc_decode_firmware_rev(phba, fwrev, 1);
+	if (strncmp(fwrev, image->rev_name, strnlen(fwrev, 16))) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3023 Updating Firmware. Current Version:%s "
+				"New Version:%s\n",
+				fwrev, image->rev_name);
+		for (i = 0; i < LPFC_MBX_WR_CONFIG_MAX_BDE; i++) {
+			dmabuf = kzalloc(sizeof(struct lpfc_dmabuf),
+					 GFP_KERNEL);
+			if (!dmabuf) {
+				rc = -ENOMEM;
+				goto out;
+			}
+			dmabuf->virt = dma_alloc_coherent(&phba->pcidev->dev,
+							  SLI4_PAGE_SIZE,
+							  &dmabuf->phys,
+							  GFP_KERNEL);
+			if (!dmabuf->virt) {
+				kfree(dmabuf);
+				rc = -ENOMEM;
+				goto out;
+			}
+			list_add_tail(&dmabuf->list, &dma_buffer_list);
+		}
+		while (offset < fw->size) {
+			temp_offset = offset;
+			list_for_each_entry(dmabuf, &dma_buffer_list, list) {
+				if (offset + SLI4_PAGE_SIZE > fw->size) {
+					temp_offset += fw->size - offset;
+					memcpy(dmabuf->virt,
+					       fw->data + temp_offset,
+					       fw->size - offset);
+					break;
+				}
+				temp_offset += SLI4_PAGE_SIZE;
+				memcpy(dmabuf->virt, fw->data + temp_offset,
+				       SLI4_PAGE_SIZE);
+			}
+			rc = lpfc_wr_object(phba, &dma_buffer_list,
+				    (fw->size - offset), &offset);
+			if (rc) {
+				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+						"3024 Firmware update failed. "
+						"%d\n", rc);
+				goto out;
+			}
+		}
+		rc = offset;
+	}
+out:
+	list_for_each_entry_safe(dmabuf, next, &dma_buffer_list, list) {
+		list_del(&dmabuf->list);
+		dma_free_coherent(&phba->pcidev->dev, SLI4_PAGE_SIZE,
+				  dmabuf->virt, dmabuf->phys);
+		kfree(dmabuf);
+	}
+	return rc;
+}
+
+/**
  * lpfc_pci_probe_one_s4 - PCI probe func to reg SLI-4 device to PCI subsys
  * @pdev: pointer to PCI device
  * @pid: pointer to PCI device identifier
@@ -8803,6 +8895,8 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	int mcnt;
 	int adjusted_fcp_eq_count;
 	int fcp_qidx;
+	const struct firmware *fw;
+	uint8_t file_name[16];
 
 	/* Allocate memory for HBA structure */
 	phba = lpfc_hba_alloc(pdev);
@@ -8957,6 +9051,14 @@ lpfc_pci_probe_one_s4(struct pci_dev *pd
 	/* Perform post initialization setup */
 	lpfc_post_init_setup(phba);
 
+	/* check for firmware upgrade or downgrade */
+	snprintf(file_name, 16, "%s.grp", phba->ModelName);
+	error = request_firmware(&fw, file_name, &phba->pcidev->dev);
+	if (!error) {
+		lpfc_write_firmware(phba, fw);
+		release_firmware(fw);
+	}
+
 	/* Check if there are static vports to be created. */
 	lpfc_create_static_vport(phba);
 
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2011-05-23 16:51:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2011-05-23 17:02:32.000000000 -0400
@@ -13500,6 +13500,96 @@ out:
 }
 
 /**
+ * lpfc_wr_object - write an object to the firmware
+ * @phba: HBA structure that indicates port to create a queue on.
+ * @dmabuf_list: list of dmabufs to write to the port.
+ * @size: the total byte value of the objects to write to the port.
+ * @offset: the current offset to be used to start the transfer.
+ *
+ * This routine will create a wr_object mailbox command to send to the port.
+ * the mailbox command will be constructed using the dma buffers described in
+ * @dmabuf_list to create a list of BDEs. This routine will fill in as many
+ * BDEs that the imbedded mailbox can support. The @offset variable will be
+ * used to indicate the starting offset of the transfer and will also return
+ * the offset after the write object mailbox has completed. @size is used to
+ * determine the end of the object and whether the eof bit should be set.
+ *
+ * Return 0 is successful and offset will contain the the new offset to use
+ * for the next write.
+ * Return negative value for error cases.
+ **/
+int
+lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
+	       uint32_t size, uint32_t *offset)
+{
+	struct lpfc_mbx_wr_object *wr_object;
+	LPFC_MBOXQ_t *mbox;
+	int rc = 0, i = 0;
+	uint32_t shdr_status, shdr_add_status;
+	uint32_t mbox_tmo;
+	union lpfc_sli4_cfg_shdr *shdr;
+	struct lpfc_dmabuf *dmabuf;
+	uint32_t written = 0;
+
+	mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+	if (!mbox)
+		return -ENOMEM;
+
+	lpfc_sli4_config(phba, mbox, LPFC_MBOX_SUBSYSTEM_COMMON,
+			LPFC_MBOX_OPCODE_WRITE_OBJECT,
+			sizeof(struct lpfc_mbx_wr_object) -
+			sizeof(struct lpfc_sli4_cfg_mhdr), LPFC_SLI4_MBX_EMBED);
+
+	wr_object = (struct lpfc_mbx_wr_object *)&mbox->u.mqe.un.wr_object;
+	wr_object->u.request.write_offset = *offset;
+	sprintf((uint8_t *)wr_object->u.request.object_name, "/");
+	wr_object->u.request.object_name[0] =
+		cpu_to_le32(wr_object->u.request.object_name[0]);
+	bf_set(lpfc_wr_object_eof, &wr_object->u.request, 0);
+	list_for_each_entry(dmabuf, dmabuf_list, list) {
+		if (i >= LPFC_MBX_WR_CONFIG_MAX_BDE || written >= size)
+			break;
+		wr_object->u.request.bde[i].addrLow = putPaddrLow(dmabuf->phys);
+		wr_object->u.request.bde[i].addrHigh =
+			putPaddrHigh(dmabuf->phys);
+		if (written + SLI4_PAGE_SIZE >= size) {
+			wr_object->u.request.bde[i].tus.f.bdeSize =
+				(size - written);
+			written += (size - written);
+			bf_set(lpfc_wr_object_eof, &wr_object->u.request, 1);
+		} else {
+			wr_object->u.request.bde[i].tus.f.bdeSize =
+				SLI4_PAGE_SIZE;
+			written += SLI4_PAGE_SIZE;
+		}
+		i++;
+	}
+	wr_object->u.request.bde_count = i;
+	bf_set(lpfc_wr_object_write_length, &wr_object->u.request, written);
+	if (!phba->sli4_hba.intr_enable)
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+	else {
+		mbox_tmo = lpfc_mbox_tmo_val(phba, MBX_SLI4_CONFIG);
+		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+	}
+	/* The IOCTL status is embedded in the mailbox subheader. */
+	shdr = (union lpfc_sli4_cfg_shdr *) &wr_object->header.cfg_shdr;
+	shdr_status = bf_get(lpfc_mbox_hdr_status, &shdr->response);
+	shdr_add_status = bf_get(lpfc_mbox_hdr_add_status, &shdr->response);
+	if (rc != MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	if (shdr_status || shdr_add_status || rc) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3025 Write Object mailbox failed with "
+				"status x%x add_status x%x, mbx status x%x\n",
+				shdr_status, shdr_add_status, rc);
+		rc = -ENXIO;
+	} else
+		*offset += wr_object->u.response.actual_write_length;
+	return rc;
+}
+
+/**
  * lpfc_cleanup_pending_mbox - Free up vport discovery mailbox commands.
  * @vport: pointer to vport data structure.
  *


