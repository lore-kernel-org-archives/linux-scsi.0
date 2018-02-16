From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH v4 08/13] lpfc: Enable fw download on if_type=6 devices
Date: Fri, 16 Feb 2018 09:28:22 -0800
Message-ID: <20180216172827.3739-9-jsmart2021@gmail.com>
References: <20180216172827.3739-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:43807 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1161052AbeBPRc2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Feb 2018 12:32:28 -0500
Received: by mail-pl0-f67.google.com with SMTP id f4so2024215plr.10
        for <linux-scsi@vger.kernel.org>; Fri, 16 Feb 2018 09:32:28 -0800 (PST)
In-Reply-To: <20180216172827.3739-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

Current code is very explicit in what it allows to be downloaded.
The driver checking prevented G7 firmware download. The driver
checking is unnecessary as the device will validate what it receives.

Revise the firmware download interface checking.
Added a little debug support in case there is still a failure.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_hw4.h  |  5 +----
 drivers/scsi/lpfc/lpfc_init.c | 44 ++++++++++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_sli.c  |  1 +
 3 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index dba724e1f5ee..be8227dfa086 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -2241,6 +2241,7 @@ struct lpfc_mbx_redisc_fcf_tbl {
  * command.
  */
 #define ADD_STATUS_OPERATION_ALREADY_ACTIVE		0x67
+#define ADD_STATUS_FW_NOT_SUPPORTED			0xEB
 
 struct lpfc_mbx_sli4_config {
 	struct mbox_header header;
@@ -4603,10 +4604,6 @@ union lpfc_wqe128 {
 	struct gen_req64_wqe gen_req;
 };
 
-#define LPFC_GROUP_OJECT_MAGIC_G5		0xfeaa0001
-#define LPFC_GROUP_OJECT_MAGIC_G6		0xfeaa0003
-#define LPFC_FILE_TYPE_GROUP			0xf7
-#define LPFC_FILE_ID_GROUP			0xa2
 struct lpfc_grp_hdr {
 	uint32_t size;
 	uint32_t magic_number;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 96a37e4e127d..af92c3c681f7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11297,6 +11297,27 @@ lpfc_sli4_get_iocb_cnt(struct lpfc_hba *phba)
 }
 
 
+static void
+lpfc_log_write_firmware_error(struct lpfc_hba *phba, uint32_t offset,
+	uint32_t magic_number, uint32_t ftype, uint32_t fid, uint32_t fsize,
+	const struct firmware *fw)
+{
+	if (offset == ADD_STATUS_FW_NOT_SUPPORTED)
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"3030 This firmware version is not supported on "
+			"this HBA model. Device:%x Magic:%x Type:%x "
+			"ID:%x Size %d %zd\n",
+			phba->pcidev->device, magic_number, ftype, fid,
+			fsize, fw->size);
+	else
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"3022 FW Download failed. Device:%x Magic:%x Type:%x "
+			"ID:%x Size %d %zd\n",
+			phba->pcidev->device, magic_number, ftype, fid,
+			fsize, fw->size);
+}
+
+
 /**
  * lpfc_write_firmware - attempt to write a firmware image to the port
  * @fw: pointer to firmware image returned from request_firmware.
@@ -11324,20 +11345,10 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 
 	magic_number = be32_to_cpu(image->magic_number);
 	ftype = bf_get_be32(lpfc_grp_hdr_file_type, image);
-	fid = bf_get_be32(lpfc_grp_hdr_id, image),
+	fid = bf_get_be32(lpfc_grp_hdr_id, image);
 	fsize = be32_to_cpu(image->size);
 
 	INIT_LIST_HEAD(&dma_buffer_list);
-	if ((magic_number != LPFC_GROUP_OJECT_MAGIC_G5 &&
-	     magic_number != LPFC_GROUP_OJECT_MAGIC_G6) ||
-	    ftype != LPFC_FILE_TYPE_GROUP || fsize != fw->size) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"3022 Invalid FW image found. "
-				"Magic:%x Type:%x ID:%x Size %d %zd\n",
-				magic_number, ftype, fid, fsize, fw->size);
-		rc = -EINVAL;
-		goto release_out;
-	}
 	lpfc_decode_firmware_rev(phba, fwrev, 1);
 	if (strncmp(fwrev, image->revision, strnlen(image->revision, 16))) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
@@ -11378,11 +11389,18 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 			}
 			rc = lpfc_wr_object(phba, &dma_buffer_list,
 				    (fw->size - offset), &offset);
-			if (rc)
+			if (rc) {
+				lpfc_log_write_firmware_error(phba, offset,
+					magic_number, ftype, fid, fsize, fw);
 				goto release_out;
+			}
 		}
 		rc = offset;
-	}
+	} else
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"3029 Skipped Firmware update, Current "
+				"Version:%s New Version:%s\n",
+				fwrev, image->revision);
 
 release_out:
 	list_for_each_entry_safe(dmabuf, next, &dma_buffer_list, list) {
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 6735959f21cf..dc5208021603 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18876,6 +18876,7 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 				"status x%x add_status x%x, mbx status x%x\n",
 				shdr_status, shdr_add_status, rc);
 		rc = -ENXIO;
+		*offset = shdr_add_status;
 	} else
 		*offset += wr_object->u.response.actual_write_length;
 	return rc;
-- 
2.13.1
