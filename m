From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [PATCH 4/5] Add P3 support, acpi s3 & s4
Date: Fri,  3 Jun 2016 20:13:51 +0800
Message-ID: <1464956031-16884-1-git-send-email-ch1102chiou@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:33013 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161075AbcFCMN5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2016 08:13:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, eva.cheng@tw.promise.com, charles.chiou@tw.promise.com
Cc: Paul <paul.lyu@tw.promise.com>

From: Paul <paul.lyu@tw.promise.com>

1.In suspend, add p3 type as yel
2.For s4, use msi_lock to prevent msi reg set again
3.When send shutdown mic, add p3 type as yel

Signed-off-by: Paul <paul.lyu@tw.promise.com>
---
 drivers/scsi/stex.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 4d74905..b18c434 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -347,6 +347,7 @@ struct st_hba {
 	u16 rq_size;
 	u16 sts_count;
 	u8  supports_pm;
+	int msi_lock;
 };
 
 struct st_card_info {
@@ -1165,7 +1166,11 @@ static int stex_ss_handshake(struct st_hba *hba)
 		data &= ~(1 << 0);
 		data &= ~(1 << 2);
 		writel(data, base + YINT_EN);
-		writel((1 << 6), base + YH2I_INT);
+		if (hba->msi_lock == 0) {
+			/* P3 MSI Register cannot access twice */
+			writel((1 << 6), base + YH2I_INT);
+			hba->msi_lock  = 1;
+		}
 		writel((hba->dma_handle >> 16) >> 16, base + YH2I_REQ_HI);
 		writel(hba->dma_handle, base + YH2I_REQ);
 	}
@@ -1771,6 +1776,7 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	hba->map_sg = ci->map_sg;
 	hba->send = ci->send;
 	hba->mu_status = MU_STATE_STARTING;
+	hba->msi_lock = 0;
 
 	if (hba->cardtype == st_yel || hba->cardtype == st_P3)
 		host->sg_tablesize = 38;
@@ -1854,28 +1860,29 @@ static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 
-	if (hba->cardtype == st_yel && hba->supports_pm == 1)
-	{
-		if(st_sleep_mic == ST_NOTHANDLED)
-		{
+	if ((hba->cardtype == st_yel && hba->supports_pm == 1)
+		|| (hba->cardtype == st_P3 && hba->supports_pm == 1)) {
+		if (st_sleep_mic == ST_NOTHANDLED) {
 			spin_unlock_irqrestore(hba->host->host_lock, flags);
 			return;
 		}
 	}
 	req = hba->alloc_rq(hba);
-	if (hba->cardtype == st_yel) {
+	if (hba->cardtype == st_yel || hba->cardtype == st_P3) {
 		msg_h = (struct st_msg_header *)req - 1;
 		memset(msg_h, 0, hba->rq_size);
 	} else
 		memset(req, 0, hba->rq_size);
 
-	if ((hba->cardtype == st_yosemite || hba->cardtype == st_yel)
+	if ((hba->cardtype == st_yosemite || hba->cardtype == st_yel
+		|| hba->cardtype == st_P3)
 		&& st_sleep_mic == ST_IGNORED) {
 		req->cdb[0] = MGT_CMD;
 		req->cdb[1] = MGT_CMD_SIGNATURE;
 		req->cdb[2] = CTLR_CONFIG_CMD;
 		req->cdb[3] = CTLR_SHUTDOWN;
-	} else if (hba->cardtype == st_yel && st_sleep_mic != ST_IGNORED) {
+	} else if ((hba->cardtype == st_yel || hba->cardtype == st_P3)
+		&& st_sleep_mic != ST_IGNORED) {
 		req->cdb[0] = MGT_CMD;
 		req->cdb[1] = MGT_CMD_SIGNATURE;
 		req->cdb[2] = CTLR_CONFIG_CMD;
@@ -1886,16 +1893,14 @@ static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
 		req->cdb[1] = CTLR_POWER_STATE_CHANGE;
 		req->cdb[2] = CTLR_POWER_SAVING;
 	}
-
 	hba->ccb[tag].cmd = NULL;
 	hba->ccb[tag].sg_count = 0;
 	hba->ccb[tag].sense_bufflen = 0;
 	hba->ccb[tag].sense_buffer = NULL;
 	hba->ccb[tag].req_type = PASSTHRU_REQ_TYPE;
-
 	hba->send(hba, req, tag);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	before = jiffies;
 	while (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE) {
 		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ)) {
@@ -1951,12 +1956,13 @@ static void stex_shutdown(struct pci_dev *pdev)
 		stex_hba_stop(hba, ST_S5);
 }
 
-static int stex_choice_sleep_mic(pm_message_t state)
+static int stex_choice_sleep_mic(struct st_hba *hba, pm_message_t state)
 {
 	switch (state.event) {
 	case PM_EVENT_SUSPEND:
 		return ST_S3;
 	case PM_EVENT_HIBERNATE:
+		hba->msi_lock = 0;
 		return ST_S4;
 	default:
 		return ST_NOTHANDLED;
@@ -1967,8 +1973,9 @@ static int stex_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	struct st_hba *hba = pci_get_drvdata(pdev);
 
-	if (hba->cardtype == st_yel && hba->supports_pm == 1)
-		stex_hba_stop(hba, stex_choice_sleep_mic(state));
+	if ((hba->cardtype == st_yel || hba->cardtype == st_P3)
+		&& hba->supports_pm == 1)
+		stex_hba_stop(hba, stex_choice_sleep_mic(hba, state));
 	else
 		stex_hba_stop(hba, ST_IGNORED);
 	return 0;
-- 
1.9.1

