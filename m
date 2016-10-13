From: james.smart@broadcom.com (James Smart)
Subject: [PATCH v3 16/17] lpfc: Fix fw download on SLI-4 FC adapters
Date: Thu, 13 Oct 2016 15:06:17 -0700
Message-ID: <58000559.ask9jYTwRrGrLPVO%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([199.3.246.86]:36366 "EHLO
        sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752973AbcJMWHT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 18:07:19 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp2.avagotech.com (Postfix) with SMTP id E150B1209D7
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 15:06:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix fw download on SLI-4 FC adapters

Driver performs a quick validation of magic numbers in the fw
download image. Driver needed to be updated for more recent
magic numbers.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
v3 mods:
 code cleanup: parsing image header fields

 drivers/scsi/lpfc/lpfc_hw4.h  |  3 ++-
 drivers/scsi/lpfc/lpfc_init.c | 20 +++++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index bbdcb5a..5646699 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -3996,7 +3996,8 @@ union lpfc_wqe128 {
 	struct gen_req64_wqe gen_req;
 };
 
-#define LPFC_GROUP_OJECT_MAGIC_NUM		0xfeaa0001
+#define LPFC_GROUP_OJECT_MAGIC_G5		0xfeaa0001
+#define LPFC_GROUP_OJECT_MAGIC_G6		0xfeaa0003
 #define LPFC_FILE_TYPE_GROUP			0xf7
 #define LPFC_FILE_ID_GROUP			0xa2
 struct lpfc_grp_hdr {
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 53227e5..7be9b8a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10312,6 +10312,7 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 	int i, rc = 0;
 	struct lpfc_dmabuf *dmabuf, *next;
 	uint32_t offset = 0, temp_offset = 0;
+	uint32_t magic_number, ftype, fid, fsize;
 
 	/* It can be null in no-wait mode, sanity check */
 	if (!fw) {
@@ -10320,18 +10321,19 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 	}
 	image = (struct lpfc_grp_hdr *)fw->data;
 
+	magic_number = be32_to_cpu(image->magic_number);
+	ftype = bf_get_be32(lpfc_grp_hdr_file_type, image);
+	fid = bf_get_be32(lpfc_grp_hdr_id, image),
+	fsize = be32_to_cpu(image->size);
+
 	INIT_LIST_HEAD(&dma_buffer_list);
-	if ((be32_to_cpu(image->magic_number) != LPFC_GROUP_OJECT_MAGIC_NUM) ||
-	    (bf_get_be32(lpfc_grp_hdr_file_type, image) !=
-	     LPFC_FILE_TYPE_GROUP) ||
-	    (bf_get_be32(lpfc_grp_hdr_id, image) != LPFC_FILE_ID_GROUP) ||
-	    (be32_to_cpu(image->size) != fw->size)) {
+	if ((magic_number != LPFC_GROUP_OJECT_MAGIC_G5 &&
+	     magic_number != LPFC_GROUP_OJECT_MAGIC_G6) ||
+	    ftype != LPFC_FILE_TYPE_GROUP || fsize != fw->size) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3022 Invalid FW image found. "
-				"Magic:%x Type:%x ID:%x\n",
-				be32_to_cpu(image->magic_number),
-				bf_get_be32(lpfc_grp_hdr_file_type, image),
-				bf_get_be32(lpfc_grp_hdr_id, image));
+				"Magic:%x Type:%x ID:%x Size %d %ld\n",
+				magic_number, ftype, fid, fsize, fw->size);
 		rc = -EINVAL;
 		goto release_out;
 	}
-- 
2.5.0


