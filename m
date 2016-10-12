From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 16/17 v2] lpfc: Fix fw download on SLI-4 FC adapters
Date: Wed, 12 Oct 2016 13:14:19 -0700
Message-ID: <57fe999b.LkhVzK2phIyu2/YN%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([202.86.248.61]:53794 "EHLO
        sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934068AbcJLUOs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2016 16:14:48 -0400
Received: from flash (fx9xs32.emulex.com [10.230.226.120])
        by sgpsmtp1.avagotech.com (Postfix) with SMTP id 99C2F10070B
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 13:14:21 -0700 (PDT)
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
 drivers/scsi/lpfc/lpfc_hw4.h  |  3 ++-
 drivers/scsi/lpfc/lpfc_init.c | 15 ++++++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

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
index 53227e5..442bbb8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10321,17 +10321,18 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 	image = (struct lpfc_grp_hdr *)fw->data;
 
 	INIT_LIST_HEAD(&dma_buffer_list);
-	if ((be32_to_cpu(image->magic_number) != LPFC_GROUP_OJECT_MAGIC_NUM) ||
-	    (bf_get_be32(lpfc_grp_hdr_file_type, image) !=
-	     LPFC_FILE_TYPE_GROUP) ||
-	    (bf_get_be32(lpfc_grp_hdr_id, image) != LPFC_FILE_ID_GROUP) ||
-	    (be32_to_cpu(image->size) != fw->size)) {
+	if (((be32_to_cpu(image->magic_number) != LPFC_GROUP_OJECT_MAGIC_G5) &&
+	     (be32_to_cpu(image->magic_number) != LPFC_GROUP_OJECT_MAGIC_G6)) ||
+	   (bf_get_be32(lpfc_grp_hdr_file_type, image) !=
+	    LPFC_FILE_TYPE_GROUP) ||
+	   (be32_to_cpu(image->size) != fw->size)) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3022 Invalid FW image found. "
-				"Magic:%x Type:%x ID:%x\n",
+				"Magic:%x Type:%x ID:%x Size %d %ld\n",
 				be32_to_cpu(image->magic_number),
 				bf_get_be32(lpfc_grp_hdr_file_type, image),
-				bf_get_be32(lpfc_grp_hdr_id, image));
+				bf_get_be32(lpfc_grp_hdr_id, image),
+				be32_to_cpu(image->size), fw->size);
 		rc = -EINVAL;
 		goto release_out;
 	}
-- 
2.5.0


