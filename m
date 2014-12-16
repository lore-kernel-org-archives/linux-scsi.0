From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [PATCH 4/4 v4] scsi:stex.c Add S3/S4 support
Date: Tue, 16 Dec 2014 14:14:32 +0800
Message-ID: <548FCDC8.1010900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>, Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com, Oliver Neukum <oneukum@suse.de>
Cc: ed.lin@promise.com, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


 From f9d84df080c16097218092630db9b5df31d487b5 Mon Sep 17 00:00:00 2001
From: Charles Chiou <charles.chiou@tw.promise.com>
Date: Fri, 7 Nov 2014 10:15:18 +0800
Subject: [PATCH 4/4] scsi:stex.c Add S3/S4 support

Add S3/S4 support, add .suspend and .resume function in pci_driver.

Pegasus need 30~40 seconds to boot up. We don't want to OS wait
in .resume function. Create a thread to handle device boot up.

Signed-off-by: charles.chiou@tw.promise.com
---
  drivers/scsi/stex.c | 65 
++++++++++++++++++++++++++++++++++++++++++++++++++++-
  1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index a536cfb..264dcd8 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -301,6 +301,11 @@ struct st_ccb {
  	u8 reserved[2];
  };

+struct hba_handshake_workstruct {
+	struct st_hba *hba;
+	struct work_struct handshake_work;
+};
+
  struct st_hba {
  	void __iomem *mmio_base;	/* iomapped PCI memory space */
  	void *dma_mem;
@@ -328,6 +333,7 @@ struct st_hba {
  	char work_q_name[20];
  	struct workqueue_struct *work_q;
  	struct work_struct reset_work;
+	struct hba_handshake_workstruct *resumework;
  	wait_queue_head_t reset_waitq;
  	unsigned int mu_status;
  	unsigned int cardtype;
@@ -369,6 +375,8 @@ static const char console_inq_page[] =
  	0x0C,0x20,0x20,0x20,0x20,0x20,0x20,0x20
  };

+
+
  MODULE_AUTHOR("Ed Lin");
  MODULE_DESCRIPTION("Promise Technology SuperTrak EX Controllers");
  MODULE_LICENSE("GPL");
@@ -630,7 +638,7 @@ stex_queuecommand_lck(struct scsi_cmnd *cmd, void 
(*done)(struct scsi_cmnd *))
  		done(cmd);
  		return 0;
  	}
-	if (unlikely(hba->mu_status == MU_STATE_RESETTING))
+	if (unlikely(hba->mu_status != MU_STATE_STARTED))
  		return SCSI_MLQUEUE_HOST_BUSY;

  	switch (cmd->cmnd[0]) {
@@ -1397,6 +1405,19 @@ static void stex_reset_work(struct work_struct *work)
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
@@ -1620,6 +1641,12 @@ static int stex_probe(struct pci_dev *pdev, const 
struct pci_device_id *id)
  		goto out_iounmap;
  	}

+	hba->resumework = kzalloc(sizeof(struct hba_handshake_workstruct),
+						GFP_KERNEL);
+	hba->resumework->hba = hba;
+	INIT_WORK(&hba->resumework->handshake_work, resume_handshake);
+
+
  	hba->cardtype = (unsigned int) id->driver_data;
  	ci = &stex_card_info[hba->cardtype];
  	switch (id->subdevice) {
@@ -1875,6 +1902,40 @@ static void stex_shutdown(struct pci_dev *pdev)
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
+	int sts;
+
+	hba->mu_status = MU_STATE_STARTING;
+	sts = schedule_work(&hba->resumework->handshake_work);
+	return 0;
+}
  MODULE_DEVICE_TABLE(pci, stex_pci_tbl);

  static struct pci_driver stex_pci_driver = {
@@ -1883,6 +1944,8 @@ static struct pci_driver stex_pci_driver = {
  	.probe		= stex_probe,
  	.remove		= stex_remove,
  	.shutdown	= stex_shutdown,
+	.suspend	= stex_suspend,
+	.resume		= stex_resume,
  };

  static struct notifier_block stex_reboot_notifier = {
-- 
1.9.1
