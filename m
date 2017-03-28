From: kusumi.tomohiro@gmail.com
Subject: [PATCH 6/6] scsi: ufs: just use sizeof() for snprintf()
Date: Tue, 28 Mar 2017 16:49:29 +0300
Message-ID: <20170328134929.25599-6-tkusumi@tuxera.com>
References: <20170328134929.25599-1-tkusumi@tuxera.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33447 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932736AbdC1NuJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2017 09:50:09 -0400
Received: by mail-lf0-f65.google.com with SMTP id r36so10601627lfi.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2017 06:50:02 -0700 (PDT)
In-Reply-To: <20170328134929.25599-1-tkusumi@tuxera.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, vinholikatti@gmail.com, linux-scsi@vger.kernel.org
Cc: Tomohiro Kusumi <tkusumi@tuxera.com>

From: Tomohiro Kusumi <tkusumi@tuxera.com>

Not much reason to use ARRAY_SIZE() when we know it's for a C string.

Signed-off-by: Tomohiro Kusumi <tkusumi@tuxera.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 109a762..790c19c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7880,7 +7880,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		INIT_WORK(&hba->clk_scaling.resume_work,
 			  ufshcd_clk_scaling_resume_work);
 
-		snprintf(wq_name, ARRAY_SIZE(wq_name), "ufs_clkscaling_%d",
+		snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
 			 host->host_no);
 		hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
 
-- 
2.9.3
