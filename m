From: Venkatraman S <svenkatr@ti.com>
Subject: [PATCH v2] scsi/ufs: Fix evaluation of UTP task completion code
Date: Thu, 19 Apr 2012 11:46:22 +0530
Message-ID: <1334816182-16268-1-git-send-email-svenkatr@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53204 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab2DSGK0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Apr 2012 02:10:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Venkatraman S <svenkatr@ti.com>, James Bottomley <James.Bottomley@hansenpartnership.com>

While interpreting the result of UTP task completion status,
by using boolean &&, the evaluation would fail when the
UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED was received.

Either UPIU_TASK_MANAGEMENT_FUNC_COMPL or
UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED should be
considered as a success result.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>
---
	v1 -> v2: Update subject, description as suggested by Andrew Morton
 drivers/scsi/ufs/ufshcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index aa97200..cd59f6f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1160,7 +1160,7 @@ static int ufshcd_task_req_compl(struct ufs_hba *hba, u32 index)
 		task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
 		task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
 
-		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL ||
+		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
 		    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
 			task_result = FAILED;
 	} else {
-- 
1.7.5.4

