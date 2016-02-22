From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [v2 PATCH 3/3] scsi:stex.c Add S3/S4 support
Date: Mon, 22 Feb 2016 20:07:09 +0800
Message-ID: <1456142829-25375-1-git-send-email-ch1102chiou@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36188 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbcBVMHQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2016 07:07:16 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, martin.petersen@oracle.com, jthumshirn@suse.de, hch@infradead.org, oneukum@suse.de, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, eva.cheng@tw.promise.com, charles.chiou@tw.promise.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Charles <charles.chiou@tw.promise.com>

Add S3/S4 support, add .suspend and .resume function in pci_driver.
In .suspend handler, driver send S3/S4 signal to the device.

Signed-off-by: Charles Chiou <charles.chiou@tw.promise.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/stex.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 1994603..5b23175 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -167,6 +167,14 @@ enum {
 
 	ST_ADDITIONAL_MEM			= 0x200000,
 	ST_ADDITIONAL_MEM_MIN			= 0x80000,
+	PMIC_SHUTDOWN				= 0x0D,
+	PMIC_REUMSE					= 0x10,
+	ST_IGNORED					= -1,
+	ST_NOTHANDLED				= 7,
+	ST_S3						= 3,
+	ST_S4						= 4,
+	ST_S5						= 5,
+	ST_S6						= 6,
 };
 
 struct st_sgitem {
@@ -1718,7 +1726,7 @@ out_disable:
 	return err;
 }
 
-static void stex_hba_stop(struct st_hba *hba)
+static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
 {
 	struct req_msg *req;
 	struct st_msg_header *msg_h;
@@ -1727,6 +1735,15 @@ static void stex_hba_stop(struct st_hba *hba)
 	u16 tag = 0;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
+
+	if (hba->cardtype == st_yel && hba->supports_pm == 1)
+	{
+		if(st_sleep_mic == ST_NOTHANDLED)
+		{
+			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			return;
+		}
+	}
 	req = hba->alloc_rq(hba);
 	if (hba->cardtype == st_yel) {
 		msg_h = (struct st_msg_header *)req - 1;
@@ -1734,11 +1751,18 @@ static void stex_hba_stop(struct st_hba *hba)
 	} else
 		memset(req, 0, hba->rq_size);
 
-	if (hba->cardtype == st_yosemite || hba->cardtype == st_yel) {
+	if ((hba->cardtype == st_yosemite || hba->cardtype == st_yel)
+		&& st_sleep_mic == ST_IGNORED) {
 		req->cdb[0] = MGT_CMD;
 		req->cdb[1] = MGT_CMD_SIGNATURE;
 		req->cdb[2] = CTLR_CONFIG_CMD;
 		req->cdb[3] = CTLR_SHUTDOWN;
+	} else if (hba->cardtype == st_yel && st_sleep_mic != ST_IGNORED) {
+		req->cdb[0] = MGT_CMD;
+		req->cdb[1] = MGT_CMD_SIGNATURE;
+		req->cdb[2] = CTLR_CONFIG_CMD;
+		req->cdb[3] = PMIC_SHUTDOWN;
+		req->cdb[4] = st_sleep_mic;
 	} else {
 		req->cdb[0] = CONTROLLER_CMD;
 		req->cdb[1] = CTLR_POWER_STATE_CHANGE;
@@ -1758,10 +1782,12 @@ static void stex_hba_stop(struct st_hba *hba)
 	while (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE) {
 		if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ)) {
 			hba->ccb[tag].req_type = 0;
+			hba->mu_status = MU_STATE_STOP;
 			return;
 		}
 		msleep(1);
 	}
+	hba->mu_status = MU_STATE_STOP;
 }
 
 static void stex_hba_free(struct st_hba *hba)
@@ -1801,9 +1827,43 @@ static void stex_shutdown(struct pci_dev *pdev)
 {
 	struct st_hba *hba = pci_get_drvdata(pdev);
 
-	stex_hba_stop(hba);
+	if (hba->supports_pm == 0)
+		stex_hba_stop(hba, ST_IGNORED);
+	else
+		stex_hba_stop(hba, ST_S5);
+}
+
+static int stex_choice_sleep_mic(pm_message_t state)
+{
+	switch (state.event) {
+	case PM_EVENT_SUSPEND:
+		return ST_S3;
+	case PM_EVENT_HIBERNATE:
+		return ST_S4;
+	default:
+		return ST_NOTHANDLED;
+	}
 }
 
+static int stex_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct st_hba *hba = pci_get_drvdata(pdev);
+
+	if (hba->cardtype == st_yel && hba->supports_pm == 1)
+		stex_hba_stop(hba, stex_choice_sleep_mic(state));
+	else
+		stex_hba_stop(hba, ST_IGNORED);
+	return 0;
+}
+
+static int stex_resume(struct pci_dev *pdev)
+{
+	struct st_hba *hba = pci_get_drvdata(pdev);
+
+	hba->mu_status = MU_STATE_STARTING;
+	stex_handshake(hba);
+	return 0;
+}
 MODULE_DEVICE_TABLE(pci, stex_pci_tbl);
 
 static struct pci_driver stex_pci_driver = {
@@ -1812,6 +1872,8 @@ static struct pci_driver stex_pci_driver = {
 	.probe		= stex_probe,
 	.remove		= stex_remove,
 	.shutdown	= stex_shutdown,
+	.suspend	= stex_suspend,
+	.resume		= stex_resume,
 };
 
 static int __init stex_init(void)
-- 
1.9.1

