From: Sujit Reddy Thumma <sthumma@codeaurora.org>
Subject: [PATCH 2/2] scsi: ufs: Fix the response UPIU length setting
Date: Fri, 10 May 2013 10:18:38 +0530
Message-ID: <1368161318-22190-2-git-send-email-sthumma@codeaurora.org>
References: <1368161318-22190-1-git-send-email-sthumma@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53204 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3EJEtC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 May 2013 00:49:02 -0400
In-Reply-To: <1368161318-22190-1-git-send-email-sthumma@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>, Santosh Y <santoshsy@gmail.com>, linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, linux-arm-msm@vger.kernel.org, Maya Erez <merez@codeaurora.org>

The response UPIU length should be in DWORD and not in bytes.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f244812..b8ad85a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -911,7 +911,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 		utrdlp[i].prd_table_offset =
 				cpu_to_le16((prdt_offset >> 2));
 		utrdlp[i].response_upiu_length =
-				cpu_to_le16(ALIGNED_UPIU_SIZE);
+				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 
 		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
 		hba->lrb[i].ucd_req_ptr =
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation.

