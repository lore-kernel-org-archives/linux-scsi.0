From: syamsidhardh@gmail.com
Subject: [PATCH v1] lpfc 8.3.37: Remove redundant NULL check before kfree
Date: Thu,  7 Mar 2013 01:42:34 +0530
Message-ID: <1362600754-6139-1-git-send-email-s.syam@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f52.google.com ([209.85.160.52]:65499 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3CFUMm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Mar 2013 15:12:42 -0500
Received: by mail-pb0-f52.google.com with SMTP id ma3so6509421pbc.39
        for <linux-scsi@vger.kernel.org>; Wed, 06 Mar 2013 12:12:41 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: syamsidhardh@gmail.com, JBottomley@parallels.com, james.smart@emulex.com, Syam Sidhardhan <s.syam@samsung.com>

From: Syam Sidhardhan <s.syam@samsung.com>

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
v1-> Corrected the from address.

 drivers/scsi/lpfc/lpfc_bsg.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 32d5683..2166097 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -1129,8 +1129,7 @@ lpfc_bsg_hba_set_event(struct fc_bsg_job *job)
 	return 0; /* call job done later */
 
 job_error:
-	if (dd_data != NULL)
-		kfree(dd_data);
+	kfree(dd_data);
 
 	job->dd_data = NULL;
 	return rc;
-- 
1.7.9.5

