Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D024C433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:42:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D9B964E4F
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 11:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhBGLmB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 06:42:01 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12484 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbhBGLlD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 06:41:03 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DYRx04QLPzjKpG;
        Sun,  7 Feb 2021 19:38:12 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Sun, 7 Feb 2021 19:39:26 +0800
From:   Xiaofei Tan <tanxiaofei@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@openeuler.org>, Xiaofei Tan <tanxiaofei@huawei.com>
Subject: [PATCH for-next 03/32] scsi: lpfc: Replace spin_lock_irqsave with spin_lock in hard IRQ
Date:   Sun, 7 Feb 2021 19:36:34 +0800
Message-ID: <1612697823-8073-4-git-send-email-tanxiaofei@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
References: <1612697823-8073-1-git-send-email-tanxiaofei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It is redundant to do irqsave and irqrestore in hardIRQ context, where
it has been in a irq-disabled context.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 49 +++++++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index fa1a714..6928750 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12792,7 +12792,6 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 	uint32_t ha_copy, hc_copy;
 	uint32_t work_ha_copy;
 	unsigned long status;
-	unsigned long iflag;
 	uint32_t control;
 
 	MAILBOX_t *mbox, *pmbox;
@@ -12820,7 +12819,7 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 		if (lpfc_intr_state_check(phba))
 			return IRQ_NONE;
 		/* Need to read HA REG for slow-path events */
-		spin_lock_irqsave(&phba->hbalock, iflag);
+		spin_lock(&phba->hbalock);
 		if (lpfc_readl(phba->HAregaddr, &ha_copy))
 			goto unplug_error;
 		/* If somebody is waiting to handle an eratt don't process it
@@ -12843,7 +12842,7 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 		 * interrupt.
 		 */
 		if (unlikely(phba->hba_flag & DEFER_ERATT)) {
-			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			spin_unlock(&phba->hbalock);
 			return IRQ_NONE;
 		}
 
@@ -12858,7 +12857,7 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 			phba->HAregaddr);
 		writel(hc_copy, phba->HCregaddr);
 		readl(phba->HAregaddr); /* flush */
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		spin_unlock(&phba->hbalock);
 	} else
 		ha_copy = phba->ha_copy;
 
@@ -12871,14 +12870,14 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 				 * Turn off Link Attention interrupts
 				 * until CLEAR_LA done
 				 */
-				spin_lock_irqsave(&phba->hbalock, iflag);
+				spin_lock(&phba->hbalock);
 				phba->sli.sli_flag &= ~LPFC_PROCESS_LA;
 				if (lpfc_readl(phba->HCregaddr, &control))
 					goto unplug_error;
 				control &= ~HC_LAINT_ENA;
 				writel(control, phba->HCregaddr);
 				readl(phba->HCregaddr); /* flush */
-				spin_unlock_irqrestore(&phba->hbalock, iflag);
+				spin_unlock(&phba->hbalock);
 			}
 			else
 				work_ha_copy &= ~HA_LATT;
@@ -12893,7 +12892,7 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 				(HA_RXMASK  << (4*LPFC_ELS_RING)));
 			status >>= (4*LPFC_ELS_RING);
 			if (status & HA_RXMASK) {
-				spin_lock_irqsave(&phba->hbalock, iflag);
+				spin_lock(&phba->hbalock);
 				if (lpfc_readl(phba->HCregaddr, &control))
 					goto unplug_error;
 
@@ -12923,10 +12922,10 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 						(uint32_t)((unsigned long)
 						&phba->work_waitq));
 				}
-				spin_unlock_irqrestore(&phba->hbalock, iflag);
+				spin_unlock(&phba->hbalock);
 			}
 		}
-		spin_lock_irqsave(&phba->hbalock, iflag);
+		spin_lock(&phba->hbalock);
 		if (work_ha_copy & HA_ERATT) {
 			if (lpfc_sli_read_hs(phba))
 				goto unplug_error;
@@ -12954,7 +12953,7 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 			/* First check out the status word */
 			lpfc_sli_pcimem_bcopy(mbox, pmbox, sizeof(uint32_t));
 			if (pmbox->mbxOwner != OWN_HOST) {
-				spin_unlock_irqrestore(&phba->hbalock, iflag);
+				spin_unlock(&phba->hbalock);
 				/*
 				 * Stray Mailbox Interrupt, mbxCommand <cmd>
 				 * mbxStatus <status>
@@ -12970,7 +12969,7 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 				work_ha_copy &= ~HA_MBATT;
 			} else {
 				phba->sli.mbox_active = NULL;
-				spin_unlock_irqrestore(&phba->hbalock, iflag);
+				spin_unlock(&phba->hbalock);
 				phba->last_completion_time = jiffies;
 				del_timer(&phba->sli.mbox_tmo);
 				if (pmb->mbox_cmpl) {
@@ -13026,14 +13025,10 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 							goto send_current_mbox;
 					}
 				}
-				spin_lock_irqsave(
-						&phba->pport->work_port_lock,
-						iflag);
+				spin_lock(&phba->pport->work_port_lock);
 				phba->pport->work_port_events &=
 					~WORKER_MBOX_TMO;
-				spin_unlock_irqrestore(
-						&phba->pport->work_port_lock,
-						iflag);
+				spin_unlock(&phba->pport->work_port_lock);
 
 				/* Do NOT queue MBX_HEARTBEAT to the worker
 				 * thread for processing.
@@ -13051,7 +13046,7 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 				}
 			}
 		} else
-			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			spin_unlock(&phba->hbalock);
 
 		if ((work_ha_copy & HA_MBATT) &&
 		    (phba->sli.mbox_active == NULL)) {
@@ -13068,14 +13063,14 @@ lpfc_sli_sp_intr_handler(int irq, void *dev_id)
 						"MBX_SUCCESS\n");
 		}
 
-		spin_lock_irqsave(&phba->hbalock, iflag);
+		spin_lock(&phba->hbalock);
 		phba->work_ha |= work_ha_copy;
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		spin_unlock(&phba->hbalock);
 		lpfc_worker_wake_up(phba);
 	}
 	return IRQ_HANDLED;
 unplug_error:
-	spin_unlock_irqrestore(&phba->hbalock, iflag);
+	spin_unlock(&phba->hbalock);
 	return IRQ_HANDLED;
 
 } /* lpfc_sli_sp_intr_handler */
@@ -13105,7 +13100,6 @@ lpfc_sli_fp_intr_handler(int irq, void *dev_id)
 	struct lpfc_hba  *phba;
 	uint32_t ha_copy;
 	unsigned long status;
-	unsigned long iflag;
 	struct lpfc_sli_ring *pring;
 
 	/* Get the driver's phba structure from the dev_id and
@@ -13128,19 +13122,19 @@ lpfc_sli_fp_intr_handler(int irq, void *dev_id)
 		if (lpfc_readl(phba->HAregaddr, &ha_copy))
 			return IRQ_HANDLED;
 		/* Clear up only attention source related to fast-path */
-		spin_lock_irqsave(&phba->hbalock, iflag);
+		spin_lock(&phba->hbalock);
 		/*
 		 * If there is deferred error attention, do not check for
 		 * any interrupt.
 		 */
 		if (unlikely(phba->hba_flag & DEFER_ERATT)) {
-			spin_unlock_irqrestore(&phba->hbalock, iflag);
+			spin_unlock(&phba->hbalock);
 			return IRQ_NONE;
 		}
 		writel((ha_copy & (HA_R0_CLR_MSK | HA_R1_CLR_MSK)),
 			phba->HAregaddr);
 		readl(phba->HAregaddr); /* flush */
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		spin_unlock(&phba->hbalock);
 	} else
 		ha_copy = phba->ha_copy;
 
@@ -14790,7 +14784,6 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	struct lpfc_hba *phba;
 	struct lpfc_hba_eq_hdl *hba_eq_hdl;
 	struct lpfc_queue *fpeq;
-	unsigned long iflag;
 	int ecount = 0;
 	int hba_eqidx;
 	struct lpfc_eq_intr_info *eqi;
@@ -14813,11 +14806,11 @@ lpfc_sli4_hba_intr_handler(int irq, void *dev_id)
 	/* Check device state for handling interrupt */
 	if (unlikely(lpfc_intr_state_check(phba))) {
 		/* Check again for link_state with lock held */
-		spin_lock_irqsave(&phba->hbalock, iflag);
+		spin_lock(&phba->hbalock);
 		if (phba->link_state < LPFC_LINK_DOWN)
 			/* Flush, clear interrupt, and rearm the EQ */
 			lpfc_sli4_eqcq_flush(phba, fpeq);
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		spin_unlock(&phba->hbalock);
 		return IRQ_NONE;
 	}
 
-- 
2.8.1

