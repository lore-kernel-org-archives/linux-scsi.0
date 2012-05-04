From: akpm@linux-foundation.org
Subject: [patch 3/5] drivers/scsi/ufs: fix evaluation of task_failed status
Date: Fri, 04 May 2012 14:35:09 -0700
Message-ID: <20120504213510.081AEA0367@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f202.google.com ([209.85.212.202]:55556 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759942Ab2EDVfM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 17:35:12 -0400
Received: by wibhj13 with SMTP id hj13so113942wib.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 May 2012 14:35:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, svenkatr@ti.com, joe@perches.com, linkinjeon@gmail.com, santoshsy@gmail.com

From: Venkatraman S <svenkatr@ti.com>
Subject: drivers/scsi/ufs: fix evaluation of task_failed status

Else FAILED would be set even if task_result was originally equal to
UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED.

Reported-by: Joe Perches <joe@perches.com>
Signed-off-by: Venkatraman S <svenkatr@ti.com>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ufs/ufshcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-fix-evaluation-of-task_failed-status drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-fix-evaluation-of-task_failed-status
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -1160,7 +1160,7 @@ static int ufshcd_task_req_compl(struct 
 		task_result = be32_to_cpu(task_rsp_upiup->header.dword_1);
 		task_result = ((task_result & MASK_TASK_RESPONSE) >> 8);
 
-		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL ||
+		if (task_result != UPIU_TASK_MANAGEMENT_FUNC_COMPL &&
 		    task_result != UPIU_TASK_MANAGEMENT_FUNC_SUCCEEDED)
 			task_result = FAILED;
 	} else {
_
