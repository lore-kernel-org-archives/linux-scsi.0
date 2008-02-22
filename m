From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 2/2] stex: stex_internal_copy should be called with sg_count in struct st_ccb
Date: Fri, 22 Feb 2008 23:11:04 +0900
Message-ID: <1203689464-24591-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1203689464-24591-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:43137 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbYBVOMD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 09:12:03 -0500
In-Reply-To: <1203689464-24591-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ed Lin <ed.lin@promise.com>, James Bottomley <James.Bottomley@SteelEye.com>

stex_internal_copy copies an in-kernel buffer to a sg list by using
scsi_kmap_atomic_sg. Some functions calls stex_internal_copy with
sg_count in struct st_ccb, which is the value that dma_map_sg
returned. However it might be shorter than the actual number of sg
entries (if the IOMMU merged the sg entries).

scsi_kmap_atomic_sg doesn't see sg->dma_length so stex_internal_copy
should be called with the actual number of sg entries
(i.e. scsi_sg_count), because if the sg entries were merged,
stex_direct_copy wrongly think that the data length in the sg list is
shorter than the actual length.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Ed Lin <ed.lin@promise.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/stex.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 4b6861c..654430e 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -467,7 +467,8 @@ static void stex_controller_info(struct st_hba *hba, struct st_ccb *ccb)
 	size_t count = sizeof(struct st_frame);
 
 	p = hba->copy_buffer;
-	stex_internal_copy(ccb->cmd, p, &count, ccb->sg_count, ST_FROM_CMD);
+	stex_internal_copy(ccb->cmd, p, &count, scsi_sg_count(ccb->cmd),
+			   ST_FROM_CMD);
 	memset(p->base, 0, sizeof(u32)*6);
 	*(unsigned long *)(p->base) = pci_resource_start(hba->pdev, 0);
 	p->rom_addr = 0;
@@ -485,7 +486,8 @@ static void stex_controller_info(struct st_hba *hba, struct st_ccb *ccb)
 	p->subid =
 		hba->pdev->subsystem_vendor << 16 | hba->pdev->subsystem_device;
 
-	stex_internal_copy(ccb->cmd, p, &count, ccb->sg_count, ST_TO_CMD);
+	stex_internal_copy(ccb->cmd, p, &count, scsi_sg_count(ccb->cmd),
+			   ST_TO_CMD);
 }
 
 static void
@@ -699,7 +701,7 @@ static void stex_copy_data(struct st_ccb *ccb,
 	if (ccb->cmd == NULL)
 		return;
 	stex_internal_copy(ccb->cmd,
-		resp->variable, &count, ccb->sg_count, ST_TO_CMD);
+		resp->variable, &count, scsi_sg_count(ccb->cmd), ST_TO_CMD);
 }
 
 static void stex_ys_commands(struct st_hba *hba,
@@ -724,7 +726,7 @@ static void stex_ys_commands(struct st_hba *hba,
 
 		count = STEX_EXTRA_SIZE;
 		stex_internal_copy(ccb->cmd, hba->copy_buffer,
-			&count, ccb->sg_count, ST_FROM_CMD);
+			&count, scsi_sg_count(ccb->cmd), ST_FROM_CMD);
 		inq_data = (ST_INQ *)hba->copy_buffer;
 		if (inq_data->DeviceTypeQualifier != 0)
 			ccb->srb_status = SRB_STATUS_SELECTION_TIMEOUT;
-- 
1.5.3.4

