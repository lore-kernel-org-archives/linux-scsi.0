From: Viswas G <Viswas.G@pmcs.com>
Subject: [PATCH] pm80xx: Spinlock fix
Date: Wed, 18 Dec 2013 16:58:43 +0530
Message-ID: <1387366123-3950-1-git-send-email-Viswas.G@pmcs.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:46977 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258Ab3LRLer (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Dec 2013 06:34:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, jason.seba42@gmail.com, JBottomley@parallels.com, Vasanthalakshmi.Tharmarajan@pmcs.com, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

>From 9338d4bc92b23b4c283f9bd6812646ab74866a40 Mon Sep 17 00:00:00 2001
From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Date: Mon, 16 Dec 2013 21:15:20 +0530
Subject: [PATCH] pm80xx: Spinlock fix

spin_unlock was used instead of spin_unlock_irqrestore. To fix this 
lock_flags per-adapter is added and used across all the places where pm8001_ha->lock is used.

Reported-by: Jason Seba <jason.seba42@gmail.com>
Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Signed-off-by: Viswas G <Viswas.G@pmcs.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  158 ++++++++++++++++++++++----------------
 drivers/scsi/pm8001/pm8001_sas.c |   50 ++++++------
 drivers/scsi/pm8001/pm8001_sas.h |    1 +
 drivers/scsi/pm8001/pm80xx_hwi.c |   69 ++++++++++-------
 4 files changed, 160 insertions(+), 118 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 0a1296a..3901c40 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -411,7 +411,6 @@ static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
 				     u32 SSCbit)
 {
 	u32 value, offset, i;
-	unsigned long flags;
 
 #define SAS2_SETTINGS_LOCAL_PHY_0_3_SHIFT_ADDR 0x00030000
 #define SAS2_SETTINGS_LOCAL_PHY_4_7_SHIFT_ADDR 0x00040000
@@ -425,10 +424,10 @@ static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
     * Using shifted destination address 0x3_0000:0x1074 + 0x4000*N (N=0:3)
     * Using shifted destination address 0x4_0000:0x1074 + 0x4000*(N-4) (N=4:7)
     */
-	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	if (-1 == pm8001_bar4_shift(pm8001_ha,
 				SAS2_SETTINGS_LOCAL_PHY_0_3_SHIFT_ADDR)) {
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		return;
 	}
 
@@ -439,7 +438,7 @@ static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
 	/* shift membase 3 for SAS2_SETTINGS_LOCAL_PHY 4 - 7 */
 	if (-1 == pm8001_bar4_shift(pm8001_ha,
 				SAS2_SETTINGS_LOCAL_PHY_4_7_SHIFT_ADDR)) {
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		return;
 	}
 	for (i = 4; i < 8; i++) {
@@ -466,7 +465,7 @@ static void mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha,
 
 	/*set the shifted destination address to 0x0 to avoid error operation */
 	pm8001_bar4_shift(pm8001_ha, 0x0);
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+	spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	return;
 }
 
@@ -481,7 +480,6 @@ static void mpi_set_open_retry_interval_reg(struct pm8001_hba_info *pm8001_ha,
 	u32 offset;
 	u32 value;
 	u32 i;
-	unsigned long flags;
 
 #define OPEN_RETRY_INTERVAL_PHY_0_3_SHIFT_ADDR 0x00030000
 #define OPEN_RETRY_INTERVAL_PHY_4_7_SHIFT_ADDR 0x00040000
@@ -490,11 +488,11 @@ static void mpi_set_open_retry_interval_reg(struct pm8001_hba_info *pm8001_ha,
 #define OPEN_RETRY_INTERVAL_REG_MASK 0x0000FFFF
 
 	value = interval & OPEN_RETRY_INTERVAL_REG_MASK;
-	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	/* shift bar and set the OPEN_REJECT(RETRY) interval time of PHY 0 -3.*/
 	if (-1 == pm8001_bar4_shift(pm8001_ha,
 			     OPEN_RETRY_INTERVAL_PHY_0_3_SHIFT_ADDR)) {
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		return;
 	}
 	for (i = 0; i < 4; i++) {
@@ -504,7 +502,7 @@ static void mpi_set_open_retry_interval_reg(struct pm8001_hba_info *pm8001_ha,
 
 	if (-1 == pm8001_bar4_shift(pm8001_ha,
 			     OPEN_RETRY_INTERVAL_PHY_4_7_SHIFT_ADDR)) {
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		return;
 	}
 	for (i = 4; i < 8; i++) {
@@ -513,7 +511,7 @@ static void mpi_set_open_retry_interval_reg(struct pm8001_hba_info *pm8001_ha,
 	}
 	/*set the shifted destination address to 0x0 to avoid error operation */
 	pm8001_bar4_shift(pm8001_ha, 0x0);
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+	spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	return;
 }
 
@@ -768,11 +766,11 @@ static u32 soft_reset_ready_check(struct pm8001_hba_info *pm8001_ha)
 		PM8001_INIT_DBG(pm8001_ha,
 			pm8001_printk("Firmware is ready for reset .\n"));
 	} else {
-		unsigned long flags;
 		/* Trigger NMI twice via RB6 */
-		spin_lock_irqsave(&pm8001_ha->lock, flags);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		if (-1 == pm8001_bar4_shift(pm8001_ha, RB6_ACCESS_REG)) {
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			PM8001_FAIL_DBG(pm8001_ha,
 				pm8001_printk("Shift Bar4 to 0x%x failed\n",
 					RB6_ACCESS_REG));
@@ -798,10 +796,11 @@ static u32 soft_reset_ready_check(struct pm8001_hba_info *pm8001_ha)
 			PM8001_FAIL_DBG(pm8001_ha,
 				pm8001_printk("SCRATCH_PAD3 value = 0x%x\n",
 				pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_3)));
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return -1;
 		}
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	}
 	return 0;
 }
@@ -818,7 +817,6 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	u32	max_wait_count;
 	u32	regVal1, regVal2, regVal3;
 	u32	signature = 0x252acbcd; /* for host scratch pad0 */
-	unsigned long flags;
 
 	/* step1: Check FW is ready for soft reset */
 	if (soft_reset_ready_check(pm8001_ha) != 0) {
@@ -829,9 +827,9 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	/* step 2: clear NMI status register on AAP1 and IOP, write the same
 	value to clear */
 	/* map 0x60000 to BAR4(0x20), BAR2(win) */
-	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	if (-1 == pm8001_bar4_shift(pm8001_ha, MBIC_AAP1_ADDR_BASE)) {
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("Shift Bar4 to 0x%x failed\n",
 			MBIC_AAP1_ADDR_BASE));
@@ -843,7 +841,7 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	pm8001_cw32(pm8001_ha, 2, MBIC_NMI_ENABLE_VPE0_IOP, 0x0);
 	/* map 0x70000 to BAR4(0x20), BAR2(win) */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, MBIC_IOP_ADDR_BASE)) {
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("Shift Bar4 to 0x%x failed\n",
 			MBIC_IOP_ADDR_BASE));
@@ -886,7 +884,7 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	/* read required registers for confirmming */
 	/* map 0x0700000 to BAR4(0x20), BAR2(win) */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, GSM_ADDR_BASE)) {
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("Shift Bar4 to 0x%x failed\n",
 			GSM_ADDR_BASE));
@@ -953,7 +951,7 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	udelay(10);
 	/* step 5-b: set GPIO-0 output control to tristate anyway */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, GPIO_ADDR_BASE)) {
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		PM8001_INIT_DBG(pm8001_ha,
 				pm8001_printk("Shift Bar4 to 0x%x failed\n",
 				GPIO_ADDR_BASE));
@@ -970,7 +968,7 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	/* Step 6: Reset the IOP and AAP1 */
 	/* map 0x00000 to BAR4(0x20), BAR2(win) */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, SPC_TOP_LEVEL_ADDR_BASE)) {
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("SPC Shift Bar4 to 0x%x failed\n",
 			SPC_TOP_LEVEL_ADDR_BASE));
@@ -1008,7 +1006,7 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	/* step 11: reads and sets the GSM Configuration and Reset Register */
 	/* map 0x0700000 to BAR4(0x20), BAR2(win) */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, GSM_ADDR_BASE)) {
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("SPC Shift Bar4 to 0x%x failed\n",
 			GSM_ADDR_BASE));
@@ -1062,7 +1060,7 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 	/* step 13: bring the IOP and AAP1 out of reset */
 	/* map 0x00000 to BAR4(0x20), BAR2(win) */
 	if (-1 == pm8001_bar4_shift(pm8001_ha, SPC_TOP_LEVEL_ADDR_BASE)) {
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		PM8001_FAIL_DBG(pm8001_ha,
 			pm8001_printk("Shift Bar4 to 0x%x failed\n",
 			SPC_TOP_LEVEL_ADDR_BASE));
@@ -1104,7 +1102,8 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 				pm8001_printk("SCRATCH_PAD3 value = 0x%x\n",
 				pm8001_cr32(pm8001_ha, 0,
 				MSGU_SCRATCH_PAD_3)));
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return -1;
 		}
 
@@ -1134,12 +1133,13 @@ pm8001_chip_soft_rst(struct pm8001_hba_info *pm8001_ha)
 				pm8001_printk("SCRATCH_PAD3 value = 0x%x\n",
 				pm8001_cr32(pm8001_ha, 0,
 				MSGU_SCRATCH_PAD_3)));
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return -1;
 		}
 	}
 	pm8001_bar4_shift(pm8001_ha, 0);
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+	spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 
 	PM8001_INIT_DBG(pm8001_ha,
 		pm8001_printk("SPC soft reset Complete\n"));
@@ -1517,18 +1517,19 @@ void pm8001_work_fn(struct work_struct *work)
 		u32 tag;
 		struct pm8001_ccb_info *ccb;
 		struct pm8001_hba_info *pm8001_ha = pw->pm8001_ha;
-		unsigned long flags, flags1;
+		unsigned long flags1;
 		struct task_status_struct *ts;
 		int i;
 
 		if (pm8001_query_task(t) == TMF_RESP_FUNC_SUCC)
 			break; /* Task still on lu */
-		spin_lock_irqsave(&pm8001_ha->lock, flags);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 
 		spin_lock_irqsave(&t->task_state_lock, flags1);
 		if (unlikely((t->task_state_flags & SAS_TASK_STATE_DONE))) {
 			spin_unlock_irqrestore(&t->task_state_lock, flags1);
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			break; /* Task got completed by another */
 		}
 		spin_unlock_irqrestore(&t->task_state_lock, flags1);
@@ -1541,7 +1542,8 @@ void pm8001_work_fn(struct work_struct *work)
 				break;
 		}
 		if (!ccb) {
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			break; /* Task got freed by another */
 		}
 		ts = &t->task_status;
@@ -1562,12 +1564,14 @@ void pm8001_work_fn(struct work_struct *work)
 				" aborted by upper layer!\n",
 				t, pw->handler, ts->resp, ts->stat));
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 		} else {
 			spin_unlock_irqrestore(&t->task_state_lock, flags1);
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/* in order to force CPU ordering */
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
 		}
 	}	break;
@@ -1577,7 +1581,7 @@ void pm8001_work_fn(struct work_struct *work)
 		u32 tag;
 		struct pm8001_ccb_info *ccb;
 		struct pm8001_hba_info *pm8001_ha = pw->pm8001_ha;
-		unsigned long flags, flags1;
+		unsigned long flags1;
 		int i, ret = 0;
 
 		PM8001_IO_DBG(pm8001_ha,
@@ -1600,13 +1604,14 @@ void pm8001_work_fn(struct work_struct *work)
 				break;
 			});
 
-		spin_lock_irqsave(&pm8001_ha->lock, flags);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 
 		spin_lock_irqsave(&t->task_state_lock, flags1);
 
 		if (unlikely((t->task_state_flags & SAS_TASK_STATE_DONE))) {
 			spin_unlock_irqrestore(&t->task_state_lock, flags1);
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			if (ret == TMF_RESP_FUNC_SUCC) /* task on lu */
 				(void)pm8001_abort_task(t);
 			break; /* Task got completed by another */
@@ -1622,7 +1627,8 @@ void pm8001_work_fn(struct work_struct *work)
 				break;
 		}
 		if (!ccb) {
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			if (ret == TMF_RESP_FUNC_SUCC) /* task on lu */
 				(void)pm8001_abort_task(t);
 			break; /* Task got freed by another */
@@ -1634,7 +1640,8 @@ void pm8001_work_fn(struct work_struct *work)
 		switch (ret) {
 		case TMF_RESP_FUNC_SUCC: /* task on lu */
 			ccb->open_retry = 1; /* Snub completion */
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			ret = pm8001_abort_task(t);
 			ccb->open_retry = 0;
 			switch (ret) {
@@ -1651,12 +1658,14 @@ void pm8001_work_fn(struct work_struct *work)
 			break;
 
 		case TMF_RESP_FUNC_COMPLETE: /* task not on lu */
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			/* Do we need to abort the task locally? */
 			break;
 
 		default: /* device misbehavior */
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			ret = TMF_RESP_FUNC_FAILED;
 			PM8001_IO_DBG(pm8001_ha,
 				pm8001_printk("...Reset phy\n"));
@@ -2504,9 +2513,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*in order to force CPU ordering*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2524,9 +2535,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2552,9 +2565,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/* ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2619,9 +2634,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2643,9 +2660,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2678,16 +2697,16 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	} else if (!t->uldd_task) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	}
 }
 
@@ -2798,9 +2817,11 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2913,16 +2934,16 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	} else if (!t->uldd_task) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	}
 }
 
@@ -4194,9 +4215,8 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	void *pMsg1 = NULL;
 	u8 uninitialized_var(bc);
 	u32 ret = MPI_IO_STATUS_FAIL;
-	unsigned long flags;
 
-	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	circularQ = &pm8001_ha->outbnd_q_tbl[vec];
 	do {
 		ret = pm8001_mpi_msg_consume(pm8001_ha, circularQ, &pMsg1, &bc);
@@ -4217,7 +4237,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 				break;
 		}
 	} while (1);
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+	spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	return ret;
 }
 
@@ -4472,18 +4492,22 @@ static int pm8001_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 							flags);
 				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
 				mb();/* ditto */
-				spin_unlock_irq(&pm8001_ha->lock);
+				spin_unlock_irqrestore(&pm8001_ha->lock,
+							pm8001_ha->lock_flags);
 				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
+				spin_lock_irqsave(&pm8001_ha->lock,
+							pm8001_ha->lock_flags);
 				return 0;
 			} else if (!task->uldd_task) {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
 				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
 				mb();/*ditto*/
-				spin_unlock_irq(&pm8001_ha->lock);
+				spin_unlock_irqrestore(&pm8001_ha->lock,
+							pm8001_ha->lock_flags);
 				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
+				spin_lock_irqsave(&pm8001_ha->lock,
+							pm8001_ha->lock_flags);
 				return 0;
 			}
 		}
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index f50ac44..eac1b81 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -166,7 +166,6 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 	struct pm8001_hba_info *pm8001_ha = NULL;
 	struct sas_phy_linkrates *rates;
 	DECLARE_COMPLETION_ONSTACK(completion);
-	unsigned long flags;
 	pm8001_ha = sas_phy->ha->lldd_ha;
 	pm8001_ha->phy[phy_id].enable_completion = &completion;
 	switch (func) {
@@ -211,11 +210,12 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		PM8001_CHIP_DISP->phy_stop_req(pm8001_ha, phy_id);
 		break;
 	case PHY_FUNC_GET_EVENTS:
-		spin_lock_irqsave(&pm8001_ha->lock, flags);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		if (pm8001_ha->chip_id == chip_8001) {
 			if (-1 == pm8001_bar4_shift(pm8001_ha,
 					(phy_id < 4) ? 0x30000 : 0x40000)) {
-				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+				spin_unlock_irqrestore(&pm8001_ha->lock,
+							pm8001_ha->lock_flags);
 				return -EINVAL;
 			}
 		}
@@ -232,7 +232,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 		}
 		if (pm8001_ha->chip_id == chip_8001)
 			pm8001_bar4_shift(pm8001_ha, 0);
-		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		return 0;
 	default:
 		rc = -EOPNOTSUPP;
@@ -369,7 +369,6 @@ static int pm8001_task_exec(struct sas_task *task, const int num,
 	struct pm8001_ccb_info *ccb;
 	u32 tag = 0xdeadbeef, rc, n_elem = 0;
 	u32 n = num;
-	unsigned long flags = 0;
 
 	if (!dev->port) {
 		struct task_status_struct *tsm = &t->task_status;
@@ -380,8 +379,8 @@ static int pm8001_task_exec(struct sas_task *task, const int num,
 		return 0;
 	}
 	pm8001_ha = pm8001_find_ha_by_dev(task->dev);
-	PM8001_IO_DBG(pm8001_ha, pm8001_printk("pm8001_task_exec device \n "));
-	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	PM8001_IO_DBG(pm8001_ha, pm8001_printk("pm8001_task_exec device\n"));
+	spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	do {
 		dev = t->dev;
 		pm8001_dev = dev->lldd_dev;
@@ -392,9 +391,11 @@ static int pm8001_task_exec(struct sas_task *task, const int num,
 				ts->resp = SAS_TASK_UNDELIVERED;
 				ts->stat = SAS_PHY_DOWN;
 
-				spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+				spin_unlock_irqrestore(&pm8001_ha->lock,
+							pm8001_ha->lock_flags);
 				t->task_done(t);
-				spin_lock_irqsave(&pm8001_ha->lock, flags);
+				spin_lock_irqsave(&pm8001_ha->lock,
+							pm8001_ha->lock_flags);
 				if (n > 1)
 					t = list_entry(t->list.next,
 							struct sas_task, list);
@@ -482,7 +483,7 @@ err_out:
 			dma_unmap_sg(pm8001_ha->dev, t->scatter, n_elem,
 				t->data_dir);
 out_done:
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+	spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	return rc;
 }
 
@@ -607,7 +608,6 @@ static void pm8001_free_dev(struct pm8001_device *pm8001_dev)
   */
 static int pm8001_dev_found_notify(struct domain_device *dev)
 {
-	unsigned long flags = 0;
 	int res = 0;
 	struct pm8001_hba_info *pm8001_ha = NULL;
 	struct domain_device *parent_dev = dev->parent;
@@ -615,7 +615,7 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u32 flag = 0;
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
-	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 
 	pm8001_device = pm8001_alloc_dev(pm8001_ha);
 	if (!pm8001_device) {
@@ -654,14 +654,14 @@ static int pm8001_dev_found_notify(struct domain_device *dev)
 	} /*register this device to HBA*/
 	PM8001_DISC_DBG(pm8001_ha, pm8001_printk("Found device\n"));
 	PM8001_CHIP_DISP->reg_dev_req(pm8001_ha, pm8001_device, flag);
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+	spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	wait_for_completion(&completion);
 	if (dev->dev_type == SAS_END_DEVICE)
 		msleep(50);
 	pm8001_ha->flags = PM8001F_RUN_TIME;
 	return 0;
 found_out:
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+	spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	return res;
 }
 
@@ -864,13 +864,12 @@ ex_err:
   */
 static void pm8001_dev_gone_notify(struct domain_device *dev)
 {
-	unsigned long flags = 0;
 	u32 tag;
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
 
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
-	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	pm8001_tag_alloc(pm8001_ha, &tag);
 	if (pm8001_dev) {
 		u32 device_id = pm8001_dev->device_id;
@@ -879,10 +878,12 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			pm8001_printk("found dev[%d:%x] is gone.\n",
 			pm8001_dev->device_id, pm8001_dev->dev_type));
 		if (pm8001_dev->running_req) {
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			pm8001_exec_internal_task_abort(pm8001_ha, pm8001_dev ,
 				dev, 1, 0);
-			spin_lock_irqsave(&pm8001_ha->lock, flags);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
 		pm8001_free_dev(pm8001_dev);
@@ -891,7 +892,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			pm8001_printk("Found dev has gone.\n"));
 	}
 	dev->lldd_dev = NULL;
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+	spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 }
 
 void pm8001_dev_gone(struct domain_device *dev)
@@ -918,12 +919,11 @@ void pm8001_open_reject_retry(
 	struct pm8001_device *device_to_close)
 {
 	int i;
-	unsigned long flags;
 
 	if (pm8001_ha == NULL)
 		return;
 
-	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 
 	for (i = 0; i < PM8001_MAX_CCB; i++) {
 		struct sas_task *task;
@@ -973,13 +973,15 @@ void pm8001_open_reject_retry(
 				flags1);
 			pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
 			mb();/* in order to force CPU ordering */
-			spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			task->task_done(task);
-			spin_lock_irqsave(&pm8001_ha->lock, flags);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 		}
 	}
 
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+	spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 }
 
 /**
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 6c5fd5e..2b8065c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -475,6 +475,7 @@ struct pm8001_hba_info {
 	struct list_head	list;
 	unsigned long		flags;
 	spinlock_t		lock;/* host-wide lock */
+	unsigned long		lock_flags;
 	struct pci_dev		*pdev;/* our device */
 	struct device		*dev;
 	struct pm8001_hba_memspace io_mem[6];
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index c950dc5..3ac024a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2177,9 +2177,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*in order to force CPU ordering*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2197,9 +2199,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2223,9 +2227,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/* ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2290,9 +2296,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2314,9 +2322,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2349,16 +2359,16 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	} else if (!t->uldd_task) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	}
 }
 
@@ -2472,9 +2482,11 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 			ts->stat = SAS_QUEUE_FULL;
 			pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 			mb();/*ditto*/
-			spin_unlock_irq(&pm8001_ha->lock);
+			spin_unlock_irqrestore(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			t->task_done(t);
-			spin_lock_irq(&pm8001_ha->lock);
+			spin_lock_irqsave(&pm8001_ha->lock,
+						pm8001_ha->lock_flags);
 			return;
 		}
 		break;
@@ -2600,16 +2612,16 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/* ditto */
-		spin_unlock_irq(&pm8001_ha->lock);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	} else if (!t->uldd_task) {
 		spin_unlock_irqrestore(&t->task_state_lock, flags);
 		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
 		mb();/*ditto*/
-		spin_unlock_irq(&pm8001_ha->lock);
+		spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 		t->task_done(t);
-		spin_lock_irq(&pm8001_ha->lock);
+		spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	}
 }
 
@@ -3705,9 +3717,8 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	void *pMsg1 = NULL;
 	u8 uninitialized_var(bc);
 	u32 ret = MPI_IO_STATUS_FAIL;
-	unsigned long flags;
 
-	spin_lock_irqsave(&pm8001_ha->lock, flags);
+	spin_lock_irqsave(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	circularQ = &pm8001_ha->outbnd_q_tbl[vec];
 	do {
 		ret = pm8001_mpi_msg_consume(pm8001_ha, circularQ, &pMsg1, &bc);
@@ -3728,7 +3739,7 @@ static int process_oq(struct pm8001_hba_info *pm8001_ha, u8 vec)
 				break;
 		}
 	} while (1);
-	spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+	spin_unlock_irqrestore(&pm8001_ha->lock, pm8001_ha->lock_flags);
 	return ret;
 }
 
@@ -4309,18 +4320,22 @@ static int pm80xx_chip_sata_req(struct pm8001_hba_info *pm8001_ha,
 							flags);
 				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
 				mb();/* ditto */
-				spin_unlock_irq(&pm8001_ha->lock);
+				spin_unlock_irqrestore(&pm8001_ha->lock,
+							pm8001_ha->lock_flags);
 				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
+				spin_lock_irqsave(&pm8001_ha->lock,
+							pm8001_ha->lock_flags);
 				return 0;
 			} else if (!task->uldd_task) {
 				spin_unlock_irqrestore(&task->task_state_lock,
 							flags);
 				pm8001_ccb_task_free(pm8001_ha, task, ccb, tag);
 				mb();/*ditto*/
-				spin_unlock_irq(&pm8001_ha->lock);
+				spin_unlock_irqrestore(&pm8001_ha->lock,
+							pm8001_ha->lock_flags);
 				task->task_done(task);
-				spin_lock_irq(&pm8001_ha->lock);
+				spin_lock_irqsave(&pm8001_ha->lock,
+							pm8001_ha->lock_flags);
 				return 0;
 			}
 		}
-- 
1.7.6

