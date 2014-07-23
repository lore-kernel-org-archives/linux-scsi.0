From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 2/2] scsi: ufs: fix endianness sparse warnings
Date: Wed, 23 Jul 2014 09:31:12 +0300
Message-ID: <1406097072-18148-3-git-send-email-draviv@codeaurora.org>
References: <1406097072-18148-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:35608 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755816AbaGWGbh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jul 2014 02:31:37 -0400
In-Reply-To: <1406097072-18148-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, sthumma@codeaurora.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

Fix many warnings with incorrect endian assumptions
which makes the code unportable to new architectures.

The UFS specification defines the byte order as big-endian
for UPIU structure and little-endian for the host controller
transfer/task management descriptors.

Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a450407..ba27215 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -464,7 +464,8 @@ int ufshcd_copy_query_response(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 		/* data segment length */
 		resp_len = be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_2) &
 						MASK_QUERY_DATA_SEG_LEN;
-		buf_len = hba->dev_cmd.query.request.upiu_req.length;
+		buf_len = be16_to_cpu(
+				hba->dev_cmd.query.request.upiu_req.length);
 		if (likely(buf_len >= resp_len)) {
 			memcpy(hba->dev_cmd.query.descriptor, descp, resp_len);
 		} else {
@@ -1342,7 +1343,7 @@ static int ufshcd_query_descriptor(struct ufs_hba *hba,
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
 	hba->dev_cmd.query.descriptor = desc_buf;
-	request->upiu_req.length = *buf_len;
+	request->upiu_req.length = cpu_to_be16(*buf_len);
 
 	switch (opcode) {
 	case UPIU_QUERY_OPCODE_WRITE_DESC:
@@ -1368,7 +1369,7 @@ static int ufshcd_query_descriptor(struct ufs_hba *hba,
 	}
 
 	hba->dev_cmd.query.descriptor = NULL;
-	*buf_len = response->upiu_res.length;
+	*buf_len = be16_to_cpu(response->upiu_res.length);
 
 out_unlock:
 	mutex_unlock(&hba->dev_cmd.lock);
-- 
1.8.5.2

--
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

