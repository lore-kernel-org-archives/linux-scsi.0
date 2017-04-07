From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH V2] scsi: mpt3sas: remove redundant wmb
Date: Fri,  7 Apr 2017 15:06:18 -0400
Message-ID: <1491591978-17880-1-git-send-email-okaya@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60942 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933069AbdDGTG2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2017 15:06:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, timur@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:LSILOGIC MPT FUSION DRIVERS
        FC/SAS/SPI" <MPT-FusionLinux.pdl@broadcom.com>, open list <linux-kernel@vger.kernel.org>

Due to relaxed ordering requirements on multiple architectures,
drivers are required to use wmb/rmb/mb combinations when they
need to guarantee observability between the memory and the HW.

The mpt3sas driver is already using wmb() for this purpose.
However, it issues a writel following wmb(). writel() function
on arm/arm64 arhictectures have an embedded wmb() call inside.

This results in unnecessary performance loss and code duplication.

writel already guarantees ordering for both cpu and bus. we don't need
additional wmb()

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 5b7aec5..18039bb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1025,7 +1025,6 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 				    0 : ioc->reply_free_host_index + 1;
 				ioc->reply_free[ioc->reply_free_host_index] =
 				    cpu_to_le32(reply);
-				wmb();
 				writel(ioc->reply_free_host_index,
 				    &ioc->chip->ReplyFreeHostIndex);
 			}
@@ -1074,7 +1073,6 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 		return IRQ_NONE;
 	}
 
-	wmb();
 	if (ioc->is_warpdrive) {
 		writel(reply_q->reply_post_host_index,
 		ioc->reply_post_host_index[msix_index]);
-- 
1.9.1
