From: michaelc@cs.wisc.edu
Subject: [PATCH 1/3] be2iscsi: fix boot hang due to interrupts not getting rearmed
Date: Fri, 29 Apr 2011 14:30:06 -0500
Message-ID: <1304105408-2710-2-git-send-email-michaelc@cs.wisc.edu>
References: <1304105408-2710-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760825Ab1D2Ta0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2011 15:30:26 -0400
In-Reply-To: <1304105408-2710-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This patch fixes a bug where the interrupts were not rearmed if
the Interrupt Mask was enabled. This patch checks for Interrupt mask
enabled and still rearms interrupt generation even if the Interrupt
mask was enabled

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d834136..cea9b27 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3465,23 +3465,23 @@ static void hwi_enable_intr(struct beiscsi_hba *phba)
 	addr = (u8 __iomem *) ((u8 __iomem *) ctrl->pcicfg +
 			PCICFG_MEMBAR_CTRL_INT_CTRL_OFFSET);
 	reg = ioread32(addr);
-	SE_DEBUG(DBG_LVL_8, "reg =x%08x\n", reg);
 
 	enabled = reg & MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
 	if (!enabled) {
 		reg |= MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
 		SE_DEBUG(DBG_LVL_8, "reg =x%08x addr=%p\n", reg, addr);
 		iowrite32(reg, addr);
-		if (!phba->msix_enabled) {
-			eq = &phwi_context->be_eq[0].q;
+	}
+
+	if (!phba->msix_enabled) {
+		eq = &phwi_context->be_eq[0].q;
+		SE_DEBUG(DBG_LVL_8, "eq->id=%d\n", eq->id);
+		hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
+	} else {
+		for (i = 0; i <= phba->num_cpus; i++) {
+			eq = &phwi_context->be_eq[i].q;
 			SE_DEBUG(DBG_LVL_8, "eq->id=%d\n", eq->id);
 			hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
-		} else {
-			for (i = 0; i <= phba->num_cpus; i++) {
-				eq = &phwi_context->be_eq[i].q;
-				SE_DEBUG(DBG_LVL_8, "eq->id=%d\n", eq->id);
-				hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
-			}
 		}
 	}
 }
-- 
1.7.2.3

