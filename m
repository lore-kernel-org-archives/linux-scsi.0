From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V2 2/5] scsi: ufs: fix endianness sparse warnings
Date: Tue, 22 Jul 2014 17:23:47 +0300
Message-ID: <1406039030-14246-3-git-send-email-draviv@codeaurora.org>
References: <1406039030-14246-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:39198 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaGVOYQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jul 2014 10:24:16 -0400
In-Reply-To: <1406039030-14246-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
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
 drivers/scsi/ufs/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 694c8cc..514f65a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1325,7 +1325,7 @@ static int ufshcd_query_descriptor(struct ufs_hba *hba,
 	ufshcd_init_query(hba, &request, &response, opcode, idn, index,
 			selector);
 	hba->dev_cmd.query.descriptor = desc_buf;
-	request->upiu_req.length = *buf_len;
+	request->upiu_req.length = cpu_to_be16(*buf_len);
 
 	switch (opcode) {
 	case UPIU_QUERY_OPCODE_WRITE_DESC:
@@ -1351,7 +1351,7 @@ static int ufshcd_query_descriptor(struct ufs_hba *hba,
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

