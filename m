From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 7/7] be2iscsi: Alloc only one EQ if intr mode V2
Date: Sat, 20 Feb 2010 08:05:43 +0530
Message-ID: <20100220023533.GA13762@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:53659 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755104Ab0BTCfm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 21:35:42 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   This patch ensures that we alloc only one EQ
if we are if we are not in msix mode

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 5887d7a..fcfb29e 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3190,14 +3190,18 @@ static unsigned char hwi_enable_intr(struct beiscsi_hba *phba)
 		reg |= MEMBAR_CTRL_INT_CTRL_HOSTINTR_MASK;
 		SE_DEBUG(DBG_LVL_8, "reg =x%08x addr=%p \n", reg, addr);
 		iowrite32(reg, addr);
-		for (i = 0; i <= phba->num_cpus; i++) {
-			eq = &phwi_context->be_eq[i].q;
+		if (!phba->msix_enabled) {
+			eq = &phwi_context->be_eq[0].q;
 			SE_DEBUG(DBG_LVL_8, "eq->id=%d \n", eq->id);
 			hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
+		} else {
+			for (i = 0; i <= phba->num_cpus; i++) {
+				eq = &phwi_context->be_eq[i].q;
+				SE_DEBUG(DBG_LVL_8, "eq->id=%d \n", eq->id);
+				hwi_ring_eq_db(phba, eq->id, 0, 0, 1, 1);
+			}
 		}
-	} else
-		shost_printk(KERN_WARNING, phba->shost,
-			     "In hwi_enable_intr, Not Enabled \n");
+	}
 	return true;
 }
 
-- 
1.6.4

