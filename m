From: Maninder Singh <maninder1.s@samsung.com>
Subject: [PATCH 1/1] scsi: use kzalloc for allocating one thing
Date: Thu, 18 Jun 2015 10:06:34 +0530
Message-ID: <1434602194-14484-1-git-send-email-maninder1.s@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:37611 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309AbbFREhE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Jun 2015 00:37:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, hare@suse.de, hch@lst.de, michaelc@cs.wisc.edu, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: pankaj.m@samsung.com, Maninder Singh <maninder1.s@samsung.com>

Use kzalloc rather than kcalloc(1,...) for allocating one thing

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
Reviewed-by: Vaneet Narang <v.narang@samsung.com>
---
 drivers/scsi/mvsas/mv_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index d40d734..65e47eb 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -558,7 +558,7 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	chip = &mvs_chips[ent->driver_data];
 	SHOST_TO_SAS_HA(shost) =
-		kcalloc(1, sizeof(struct sas_ha_struct), GFP_KERNEL);
+		kzalloc(sizeof(struct sas_ha_struct), GFP_KERNEL);
 	if (!SHOST_TO_SAS_HA(shost)) {
 		kfree(shost);
 		rc = -ENOMEM;
-- 
1.7.1

