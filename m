From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [V2 PATCH 4/4] scsi:stex.c Add S3/S4 support
Date: Wed, 12 Nov 2014 11:41:37 +0800
Message-ID: <5462D6F1.7050006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59280 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaKLDlk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Nov 2014 22:41:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

 From d0bc6b814e5a16bea639bbdfad992a5593bf3420 Mon Sep 17 00:00:00 2001
From: Charles Chiou <charles.chiou@tw.promise.com>
Date: Fri, 7 Nov 2014 10:15:18 +0800
Subject: [PATCH 4/4] scsi:stex.c Add S3/S4 support

1. Add S3/S4 support, add .suspend and .resume function in pci_driver.

2. Pegasus take some to init, I create one thread to finish handshake
    to make OS can start faster.

3. According to (2), OS might send command to driver before handshake.
    Return SCSI_MLQUEUE_HOST_BUSY.

Signed-off-by: Charles Chiou <charles.chiou@tw.promise.com>

---
  drivers/scsi/stex.c | 57 
++++++++++++++++++++++++++++++++++++++++++++++++++++-
  1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 7a66a931..1e0b37e 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -369,6 +369,10 @@ static const char console_inq_page[] =
  	0x0C,0x20,0x20,0x20,0x20,0x20,0x20,0x20
  };

+struct hba_handshake_workstruct {
+	struct st_hba *hba;
+	struct work_struct handshake_work;
+};
  MODULE_AUTHOR("Ed Lin");
  MODULE_DESCRIPTION("Promise Technology SuperTrak EX Controllers");
  MODULE_LICENSE("GPL");
@@ -630,7 +634,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void 
(*done)(struct scsi_cmnd *))
  		done(cmd);
  		return 0;
  	}
-	if (unlikely(hba->mu_status == MU_STATE_RESETTING))
+	if (unlikely(hba->mu_status != MU_STATE_STARTED))
  		return SCSI_MLQUEUE_HOST_BUSY;

  	switch (cmd->cmnd[0]) {
@@ -1396,6 +1400,17 @@ static void stex_reset_work(struct work_struct *work)

  	stex_do_reset(hba);
  }
+static void resume_handshake(struct work_struct *work)
+{
+	struct st_hba *hba;
+	struct hba_handshake_workstruct *hswork;
+
+	hswork = container_of(work,
+		struct hba_handshake_workstruct,
+		handshake_work);
+	hba = hswork->hba;
+	stex_handshake(hba);
+}

  static int stex_biosparam(struct scsi_device *sdev,
  	struct block_device *bdev, sector_t capacity, int geom[])
@@ -1869,6 +1884,44 @@ static void stex_shutdown(struct pci_dev *pdev)
  	}
  }

+static int stex_choice_sleep_MIC(pm_message_t state)
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
+	if (hba->cardtype == st_yel && hba->yellowstone == 0)
+		stex_hba_stop(hba, stex_choice_sleep_MIC(state));
+	else
+		stex_hba_stop(hba, ST_IGNORED);
+	return 0;
+}
+
+
+static int stex_resume(struct pci_dev *pdev)
+{
+	struct st_hba *hba = pci_get_drvdata(pdev);
+	struct hba_handshake_workstruct *hswork;
+	int sts;
+
+
+	hswork = kzalloc(sizeof(struct hba_handshake_workstruct), GFP_KERNEL);
+	INIT_WORK(&hswork->handshake_work, resume_handshake);
+	hswork->hba = hba;
+	sts = schedule_work(&hswork->handshake_work);
+	return 0;
+}
  MODULE_DEVICE_TABLE(pci, stex_pci_tbl);

  static struct pci_driver stex_pci_driver = {
@@ -1877,6 +1930,8 @@ static struct pci_driver stex_pci_driver = {
  	.probe		= stex_probe,
  	.remove		= stex_remove,
  	.shutdown	= stex_shutdown,
+	.suspend	= stex_suspend,
+	.resume	= stex_resume,
  };

  static struct notifier_block stex_reboot_notifier = {
-- 
1.9.1

