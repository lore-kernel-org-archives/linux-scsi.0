From: Maurizio Lombardi <mlombard@redhat.com>
Subject: [PATCH] megaraid: fix null pointer check in megasas_detach_one().
Date: Fri, 22 Jan 2016 13:41:42 +0100
Message-ID: <1453466502-9335-1-git-send-email-mlombard@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753547AbcAVMlr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2016 07:41:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sumit.saxena@avagotech.com
Cc: kashyap.desai@avagotech.com, uday.lingala@avagotech.com, linux-scsi@vger.kernel.org, jbottomley@parallels.com, thenzl@redhat.com

The pd_seq_sync pointer can't be NULL, we have to check
its entries instead.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 97a1c1c..f083e74 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5941,11 +5941,11 @@ static void megasas_detach_one(struct pci_dev *pdev)
 			if (fusion->ld_drv_map[i])
 				free_pages((ulong)fusion->ld_drv_map[i],
 					fusion->drv_map_pages);
-				if (fusion->pd_seq_sync)
-					dma_free_coherent(&instance->pdev->dev,
-						pd_seq_map_sz,
-						fusion->pd_seq_sync[i],
-						fusion->pd_seq_phys[i]);
+			if (fusion->pd_seq_sync[i])
+				dma_free_coherent(&instance->pdev->dev,
+					pd_seq_map_sz,
+					fusion->pd_seq_sync[i],
+					fusion->pd_seq_phys[i]);
 		}
 		free_pages((ulong)instance->ctrl_context,
 			instance->ctrl_context_pages);
-- 
Maurizio Lombardi

