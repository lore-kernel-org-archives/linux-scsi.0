From: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: [PATCH] lpfc: replace spin_lock with spin_lock_irqsave
Date: Sun, 07 Feb 2010 18:53:17 +0900
Message-ID: <4B6E8D8D.60308@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33826 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab0BGJw4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2010 04:52:56 -0500
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id o179qsDH020654
	for <linux-scsi@vger.kernel.org> (envelope-from kusumi.tomohiro@jp.fujitsu.com);
	Sun, 7 Feb 2010 18:52:55 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id A7A0245DE4F
	for <linux-scsi@vger.kernel.org>; Sun,  7 Feb 2010 18:52:54 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 8C5EB45DE4E
	for <linux-scsi@vger.kernel.org>; Sun,  7 Feb 2010 18:52:54 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 711431DB8038
	for <linux-scsi@vger.kernel.org>; Sun,  7 Feb 2010 18:52:54 +0900 (JST)
Received: from m021.s.css.fujitsu.com (m021.s.css.fujitsu.com [10.0.81.61])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 2E8621DB8037
	for <linux-scsi@vger.kernel.org>; Sun,  7 Feb 2010 18:52:51 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@emulex.com, linux-scsi@vger.kernel.org
Cc: kusumi.tomohiro@jp.fujitsu.com

Hi

lpfc_sli_intr_handler() takes spinlock phba->hbalock without disabling irq on
local cpu. This patch replaces normal spin_lock/unlock with irqsave/restore.

Although current code won't cause any deadlock (since this is interrupt context),
the code looks strange to me because all the other intr handlers (sp,fp and s4
handlers) use irqsave/restore. Especially where the code takes the spinlock with
spin_lock and release it with spin_unlock_irq when DEFER_ERATT bit is set.

thanks,
Tomohiro Kusumi


Signed-off-by: Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
---

diff -aNur linux-2.6.33-rc7.org/drivers/scsi/lpfc/lpfc_sli.c linux-2.6.33-rc7/drivers/scsi/lpfc/lpfc_sli.c
--- linux-2.6.33-rc7.org/drivers/scsi/lpfc/lpfc_sli.c	2010-02-07 07:17:12.000000000 +0900
+++ linux-2.6.33-rc7/drivers/scsi/lpfc/lpfc_sli.c	2010-02-07 17:58:49.831703434 +0900
@@ -8213,7 +8213,7 @@
 {
 	struct lpfc_hba  *phba;
 	irqreturn_t sp_irq_rc, fp_irq_rc;
-	unsigned long status1, status2;
+	unsigned long status1, status2, iflag;
 	uint32_t hc_copy;
 
 	/*
@@ -8229,10 +8229,10 @@
 	if (lpfc_intr_state_check(phba))
 		return IRQ_NONE;
 
-	spin_lock(&phba->hbalock);
+	spin_lock_irqsave(&phba->hbalock, iflag);
 	phba->ha_copy = readl(phba->HAregaddr);
 	if (unlikely(!phba->ha_copy)) {
-		spin_unlock(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		return IRQ_NONE;
 	} else if (phba->ha_copy & HA_ERATT) {
 		if (phba->hba_flag & HBA_ERATT_HANDLED)
@@ -8247,7 +8247,7 @@
 	 * If there is deferred error attention, do not check for any interrupt.
 	 */
 	if (unlikely(phba->hba_flag & DEFER_ERATT)) {
-		spin_unlock_irq(&phba->hbalock);
+		spin_unlock_irqrestore(&phba->hbalock, iflag);
 		return IRQ_NONE;
 	}
 
@@ -8259,7 +8259,7 @@
 	writel((phba->ha_copy & ~(HA_LATT | HA_ERATT)), phba->HAregaddr);
 	writel(hc_copy, phba->HCregaddr);
 	readl(phba->HAregaddr); /* flush */
-	spin_unlock(&phba->hbalock);
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
 
 	/*
 	 * Invokes slow-path host attention interrupt handling as appropriate.
