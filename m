From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [PATCH 3/3] scsi:stex.c Add S3/S4 support
Date: Thu, 03 Sep 2015 09:50:24 +0800
Message-ID: <55E7A760.1040404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>, Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com, Oliver Neukum <oneukum@suse.de>
Cc: ed.lin@promise.com, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


 From 7d98f8c500de452277e2700a950b23bf4685ed64 Mon Sep 17 00:00:00 2001
From: Charles <charles.chiou@tw.promise.com>
Date: Wed, 2 Sep 2015 20:54:45 +0800
Subject: [PATCH 3/3] scsi:stex.c Add S3/S4 support

Add S3/S4 support, add .suspend and .resume function in pci_driver.
In .suspend handler, driver send S3/S4 signal to the device.

Signed-off-by: Charles Chiou <charles.chiou@tw.promise.com>
---
  drivers/scsi/stex.c | 65 
++++++++++++++++++++++++++++++++++++++++++++++++++---
  1 file changed, 62 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 6578f3d..45482d5 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -166,6 +166,13 @@ enum {

  	ST_ADDITIONAL_MEM			= 0x200000,
  	ST_ADDITIONAL_MEM_MIN			= 0x80000,
+	PMIC_SHUTDOWN				= 0x0D,
+	PMIC_REUMSE					= 0x10,
+	ST_IGNORED					= -1,
+	ST_S3						= 3,
+	ST_S4						= 4,
+	ST_S5						= 5,
+	ST_S6						= 6,
  };

  struct st_sgitem {
@@ -360,6 +367,8 @@ static const char console_inq_page[] =
  	0x0C,0x20,0x20,0x20,0x20,0x20,0x20,0x20
  };

+
+
  MODULE_AUTHOR("Ed Lin");
  MODULE_DESCRIPTION("Promise Technology SuperTrak EX Controllers");
  MODULE_LICENSE("GPL");
@@ -1359,6 +1368,9 @@ static void stex_reset_work(struct work_struct *work)
  	stex_do_reset(hba);
  }

+
+
+
  static int stex_biosparam(struct scsi_device *sdev,
  	struct block_device *bdev, sector_t capacity, int geom[])
  {
@@ -1736,7 +1748,7 @@ out_disable:
  	return err;
  }

-static void stex_hba_stop(struct st_hba *hba)
+static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
  {
  	struct req_msg *req;
  	struct st_msg_header *msg_h;
@@ -1752,11 +1764,18 @@ static void stex_hba_stop(struct st_hba *hba)
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
@@ -1776,10 +1795,12 @@ static void stex_hba_stop(struct st_hba *hba)
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
@@ -1819,9 +1840,45 @@ static void stex_shutdown(struct pci_dev *pdev)
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
+	case PM_EVENT_FREEZE:
+	case PM_EVENT_HIBERNATE:
+		return ST_S4;
+	default:
+		return ST_S4;
+	}
+}
+
+static int stex_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct st_hba *hba = pci_get_drvdata(pdev);
+
+	if (hba->cardtype == st_yel && hba->supports_pm == 1)
+		stex_hba_stop(hba, stex_choice_sleep_mic(state));
+	else
+		stex_hba_stop(hba, ST_IGNORED);
+	return 0;
  }

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
@@ -1830,6 +1887,8 @@ static struct pci_driver stex_pci_driver = {
  	.probe		= stex_probe,
  	.remove		= stex_remove,
  	.shutdown	= stex_shutdown,
+	.suspend	= stex_suspend,
+	.resume		= stex_resume,
  };

  static int __init stex_init(void)
-- 
1.9.1
