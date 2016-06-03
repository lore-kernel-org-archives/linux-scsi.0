From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [PATCH 3/5] Add P3 support, modify IO & reset
Date: Fri,  3 Jun 2016 20:13:24 +0800
Message-ID: <1464956004-16836-1-git-send-email-ch1102chiou@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36829 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161094AbcFCMNc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2016 08:13:32 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, eva.cheng@tw.promise.com, charles.chiou@tw.promise.com
Cc: Paul <paul.lyu@tw.promise.com>

From: Paul <paul.lyu@tw.promise.com>

1.Send command add P3 write reg
2.In get intr, read P3 reg & clear interrupt reg
3.Abort read & clear reg same as getting intr
4.Reset flow add P3 reset function because P3 don't need read back reg

Signed-off-by: Paul <paul.lyu@tw.promise.com>
---
 drivers/scsi/stex.c | 68 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 921f4e3..4d74905 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -548,11 +548,15 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
 
 	++hba->req_head;
 	hba->req_head %= hba->rq_count+1;
-
-	writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
-	readl(hba->mmio_base + YH2I_REQ_HI); /* flush */
-	writel(addr, hba->mmio_base + YH2I_REQ);
-	readl(hba->mmio_base + YH2I_REQ); /* flush */
+	if (hba->cardtype == st_P3) {
+		writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
+		writel(addr, hba->mmio_base + YH2I_REQ);
+	} else {
+		writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
+		readl(hba->mmio_base + YH2I_REQ_HI); /* flush */
+		writel(addr, hba->mmio_base + YH2I_REQ);
+		readl(hba->mmio_base + YH2I_REQ); /* flush */
+	}
 }
 
 static void return_abnormal_state(struct st_hba *hba, int status)
@@ -982,15 +986,31 @@ static irqreturn_t stex_ss_intr(int irq, void *__hba)
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 
-	data = readl(base + YI2H_INT);
-	if (data && data != 0xffffffff) {
-		/* clear the interrupt */
-		writel(data, base + YI2H_INT_C);
-		stex_ss_mu_intr(hba);
-		spin_unlock_irqrestore(hba->host->host_lock, flags);
-		if (unlikely(data & SS_I2H_REQUEST_RESET))
-			queue_work(hba->work_q, &hba->reset_work);
-		return IRQ_HANDLED;
+	if (hba->cardtype == st_yel) {
+		data = readl(base + YI2H_INT);
+		if (data && data != 0xffffffff) {
+			/* clear the interrupt */
+			writel(data, base + YI2H_INT_C);
+			stex_ss_mu_intr(hba);
+			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			if (unlikely(data & SS_I2H_REQUEST_RESET))
+				queue_work(hba->work_q, &hba->reset_work);
+			return IRQ_HANDLED;
+		}
+	} else {
+		data = readl(base + PSCRATCH4);
+		if (data != 0xffffffff) {
+			if (data != 0) {
+				/* clear the interrupt */
+				writel(data, base + PSCRATCH1);
+				writel((1 << 22), base + YH2I_INT);
+			}
+			stex_ss_mu_intr(hba);
+			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			if (unlikely(data & SS_I2H_REQUEST_RESET))
+				queue_work(hba->work_q, &hba->reset_work);
+			return IRQ_HANDLED;
+		}
 	}
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -1240,6 +1260,15 @@ static int stex_abort(struct scsi_cmnd *cmd)
 
 		writel(data, base + YI2H_INT_C);
 		stex_ss_mu_intr(hba);
+	} else if (hba->cardtype == st_P3) {
+		data = readl(base + PSCRATCH4);
+		if (data == 0xffffffff)
+			goto fail_out;
+		if (data != 0) {
+			writel(data, base + PSCRATCH1);
+			writel((1 << 22), base + YH2I_INT);
+		}
+		stex_ss_mu_intr(hba);
 	} else {
 		data = readl(base + ODBL);
 		if (data == 0 || data == 0xffffffff)
@@ -1247,9 +1276,9 @@ static int stex_abort(struct scsi_cmnd *cmd)
 
 		writel(data, base + ODBL);
 		readl(base + ODBL); /* flush */
-
 		stex_mu_intr(hba, data);
 	}
+
 	if (hba->wait_ccb == NULL) {
 		printk(KERN_WARNING DRV_NAME
 			"(%s): lost interrupt\n", pci_name(hba->pdev));
@@ -1343,6 +1372,12 @@ static void stex_ss_reset(struct st_hba *hba)
 	ssleep(5);
 }
 
+static void stex_p3_reset(struct st_hba *hba)
+{
+	writel(SS_H2I_INT_RESET, hba->mmio_base + YH2I_INT);
+	ssleep(5);
+}
+
 static int stex_do_reset(struct st_hba *hba)
 {
 	unsigned long flags;
@@ -1379,7 +1414,8 @@ static int stex_do_reset(struct st_hba *hba)
 		stex_hard_reset(hba);
 	else if (hba->cardtype == st_yel)
 		stex_ss_reset(hba);
-
+	else if (hba->cardtype == st_P3)
+		stex_p3_reset(hba);
 
 	return_abnormal_state(hba, DID_RESET);
 
-- 
1.9.1

