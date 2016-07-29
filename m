From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] ipr: Fix error return code in ipr_probe_ioa()
Date: Fri, 29 Jul 2016 16:00:45 +0000
Message-ID: <1469808045-1821-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33278 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbcG2QAv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jul 2016 12:00:51 -0400
Received: by mail-pf0-f193.google.com with SMTP id i6so5671795pfe.0
        for <linux-scsi@vger.kernel.org>; Fri, 29 Jul 2016 09:00:51 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, linux-scsi@vger.kernel.org

Fix to return error code -ENOMEM from the workqueue alloc error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <weiyj.lk@gmail.com>
---
 drivers/scsi/ipr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 95e4834..bf85974 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -10219,6 +10219,7 @@ static int ipr_probe_ioa(struct pci_dev *pdev,
 
 		if (!ioa_cfg->reset_work_q) {
 			dev_err(&pdev->dev, "Couldn't register reset workqueue\n");
+			rc = -ENOMEM;
 			goto out_free_irq;
 		}
 	} else

