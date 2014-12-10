From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [V3 PATCH 4/4] scsi:stex.c Add S3/S4 support
Date: Wed, 10 Dec 2014 09:38:14 +0800
Message-ID: <5487A406.8060902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, ed.lin@promise.com
List-Id: linux-scsi@vger.kernel.org

 From 91868d4afe10533b8a4496075109e411100217bb Mon Sep 17 00:00:00 2001
From: Charles Chiou <charles.chiou@tw.promise.com>
Date: Fri, 7 Nov 2014 10:15:18 +0800
Subject: [PATCH 4/4] scsi:stex.c Add S3/S4 support

Add S3/S4 support, add .suspend and .resume function in pci_driver.

Pegasus need 30~40 seconds to boot up. We don't want to OS wait
in .resume function. Create a thread to handle device boot up.

Signed-off-by: charles.chiou@tw.promise.com
---
  drivers/scsi/stex.c | 60 
++++++++++++++++++++++++++++++++++++++++++++++++++++-
  1 file changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index a536cfb..797eb2f 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -369,6 +369,11 @@ static const char console_inq_page[] =
  	0x0C,0x20,0x20,0x20,0x20,0x20,0x20,0x20
  };

+struct hba_handshake_workstruct {
+	struct st_hba *hba;
+	struct work_struct handshake_work;
+};
+
  MODULE_AUTHOR("Ed Lin");
  MODULE_DESCRIPTION("Promise Technology SuperTrak EX Controllers");
  MODULE_LICENSE("GPL");
@@ -630,7 +635,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void 
(*done)(struct scsi_cmnd *))
  		done(cmd);
  		return 0;
  	}
-	if (unlikely(hba->mu_status == MU_STATE_RESETTING))
+	if (unlikely(hba->mu_status != MU_STATE_STARTED))
  		return SCSI_MLQUEUE_HOST_BUSY;

  	switch (cmd->cmnd[0]) {
@@ -1397,6 +1402,19 @@ static void stex_reset_work(struct work_struct *work)
  	stex_do_reset(hba);
  }

+
+static void resume_handshake(struct work_struct *work)
+{
+	struct st_hba *hba;
+	struct hba_handshake_workstruct *hswork;
+
+	hswork = container_of(work, struct hba_handshake_workstruct,
+				handshake_work);
+	hba = hswork->hba;
+	stex_handshake(hba);
+}
+
+
  static int stex_biosparam(struct scsi_device *sdev,
  	struct block_device *bdev, sector_t capacity, int geom[])
  {
@@ -1875,6 +1893,44 @@ static void stex_shutdown(struct pci_dev *pdev)
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
+	if (hba->cardtype == st_yel && hba->supports_pm == 1)
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
+	hba->mu_status = MU_STATE_STARTING;
+	hswork = kzalloc(sizeof(struct hba_handshake_workstruct), GFP_KERNEL);
+	INIT_WORK(&hswork->handshake_work, resume_handshake);
+	hswork->hba = hba;
+	sts = schedule_work(&hswork->handshake_work);
+	return 0;
+}
  MODULE_DEVICE_TABLE(pci, stex_pci_tbl);

  static struct pci_driver stex_pci_driver = {
@@ -1883,6 +1939,8 @@ static struct pci_driver stex_pci_driver = {
  	.probe		= stex_probe,
  	.remove		= stex_remove,
  	.shutdown	= stex_shutdown,
+	.suspend	= stex_suspend,
+	.resume		= stex_resume,
  };

  static struct notifier_block stex_reboot_notifier = {
-- 
1.9.1
