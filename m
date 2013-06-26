From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 05/10] scsi: ufs: Fix the response UPIU length setting
Date: Wed, 26 Jun 2013 22:34:01 +0530
Message-ID: <1372266246-2725-6-git-send-email-santoshsy@gmail.com>
References: <1372266246-2725-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:63127 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3FZRE6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jun 2013 13:04:58 -0400
Received: by mail-pb0-f47.google.com with SMTP id rr13so14464385pbb.20
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2013 10:04:58 -0700 (PDT)
In-Reply-To: <1372266246-2725-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 00james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Sujit Reddy Thumma <sthumma@codeaurora.org>, Maya Erez <merez@codeaurora.org>, Santosh Y <santoshsy@gmail.com>

From: Sujit Reddy Thumma <sthumma@codeaurora.org>

The response UPIU length should be in DWORD and not in bytes.

Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 48a7645..2230f14 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -802,7 +802,7 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 		utrdlp[i].prd_table_offset =
 				cpu_to_le16((prdt_offset >> 2));
 		utrdlp[i].response_upiu_length =
-				cpu_to_le16(ALIGNED_UPIU_SIZE);
+				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 
 		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
 		hba->lrb[i].ucd_cmd_ptr =
-- 
1.8.3.1

