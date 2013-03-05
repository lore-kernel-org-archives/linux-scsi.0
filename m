From: Syam Sidhardhan <syamsidhardh@gmail.com>
Subject: [PATCH] lpfc 8.3.37: Remove redundant NULL check before kfree
Date: Wed,  6 Mar 2013 00:59:59 +0530
Message-ID: <1362511799-3693-1-git-send-email-s.syam@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48943 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3CETaL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Mar 2013 14:30:11 -0500
Received: by mail-pb0-f54.google.com with SMTP id rr4so4875164pbb.27
        for <linux-scsi@vger.kernel.org>; Tue, 05 Mar 2013 11:30:10 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: syamsidhardh@gmail.com, JBottomley@parallels.com, james.smart@emulex.com

kfree on NULL pointer is a no-op.

Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
---
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

