From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 1/3] scsi: ufs: Use devm_kcalloc() in ufshcd_memory_alloc()
Date: Tue, 25 Apr 2017 22:26:05 +0200
Message-ID: <ac344c69-44ef-07e3-a039-ad4e9a99b1d6@users.sourceforge.net>
References: <75622f45-f46c-e52f-2b9e-6ff5ce32184a@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:63279 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1949816AbdDYU0V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 16:26:21 -0400
In-Reply-To: <75622f45-f46c-e52f-2b9e-6ff5ce32184a@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 25 Apr 2017 21:45:25 +0200

* A multiplication for the size determination of a memory allocation
  indicated that an array data structure should be processed.
  Thus use the corresponding function "devm_kcalloc".

* Replace the specification of a data structure by a pointer dereference
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9ef8ce7f01a2..ce385911a20e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3270,8 +3270,7 @@ static int ufshcd_memory_alloc(struct ufs_hba *hba)
 	}
 
 	/* Allocate memory for local reference block */
-	hba->lrb = devm_kzalloc(hba->dev,
-				hba->nutrs * sizeof(struct ufshcd_lrb),
+	hba->lrb = devm_kcalloc(hba->dev, hba->nutrs, sizeof(*hba->lrb),
 				GFP_KERNEL);
 	if (!hba->lrb) {
 		dev_err(hba->dev, "LRB Memory allocation failed\n");
-- 
2.12.2
