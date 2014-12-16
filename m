From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [PATCH 3/4 v3] scsi:stex.c Add reboot support
Date: Tue, 16 Dec 2014 14:13:21 +0800
Message-ID: <548FCD81.7030106@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>, Christoph Hellwig <hch@infradead.org>, JBottomley@parallels.com, Oliver Neukum <oneukum@suse.de>
Cc: ed.lin@promise.com, grace.chang@tw.promise.com, linus.chen@tw.promise.com, victor.p@promise.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


 From 72f5b5cbda424a254b0e9672bd4d9d249728fcb9 Mon Sep 17 00:00:00 2001
From: Charles Chiou <charles.chiou@tw.promise.com>
Date: Wed, 5 Nov 2014 19:29:46 +0800
Subject: [PATCH 3/4] scsi:stex.c Add reboot support

1. Add reboot support, Pegasus devices should be notified that
    the host is going to shut down/reboot. I register reboot callback
    function to distinct host is going to shut down or to reboot.

2. Pegasus FW shutdown flow is sensitive to host behavior
    (host is going to S3/S4/shut down/reboot). To this end, I add one
    argument in stex_hba_stop to support various stop command.

Signed-off-by: charles.chiou@tw.promise.com
---
  drivers/scsi/stex.c | 46 ++++++++++++++++++++++++++++++++++++++++++----
  1 file changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 7dc6afe..a536cfb 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -24,6 +24,7 @@
  #include <linux/interrupt.h>
  #include <linux/types.h>
  #include <linux/module.h>
+#include <linux/reboot.h>
  #include <linux/spinlock.h>
  #include <asm/io.h>
  #include <asm/irq.h>
@@ -166,6 +167,13 @@ enum {

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
@@ -344,6 +352,7 @@ struct st_card_info {
  	u16 sts_count;
  };

+static int reboot;
  static int msi;
  module_param(msi, int, 0);
  MODULE_PARM_DESC(msi, "Enable Message Signaled Interrupts(0=off, 1=on)");
@@ -364,6 +373,14 @@ MODULE_AUTHOR("Ed Lin");
  MODULE_DESCRIPTION("Promise Technology SuperTrak EX Controllers");
  MODULE_LICENSE("GPL");
  MODULE_VERSION(ST_DRIVER_VERSION);
+static int stex_reboot_callback(struct notifier_block *self,
+							  unsigned long val,
+							  void *data)
+{
+	if (val == SYS_RESTART)
+		reboot = 1;
+	return NOTIFY_OK;
+}

  static void stex_gettime(__le64 *time)
  {
@@ -1562,6 +1579,7 @@ static int stex_probe(struct pci_dev *pdev, const 
struct pci_device_id *id)
  	u32 sts_offset, cp_offset, scratch_offset;
  	int err;

+	reboot = 0;
  	err = pci_enable_device(pdev);
  	if (err)
  		return err;
@@ -1755,7 +1773,7 @@ out_disable:
  	return err;
  }

-static void stex_hba_stop(struct st_hba *hba)
+static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
  {
  	struct req_msg *req;
  	struct st_msg_header *msg_h;
@@ -1771,11 +1789,18 @@ static void stex_hba_stop(struct st_hba *hba)
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
@@ -1795,10 +1820,12 @@ static void stex_hba_stop(struct st_hba *hba)
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
@@ -1838,7 +1865,14 @@ static void stex_shutdown(struct pci_dev *pdev)
  {
  	struct st_hba *hba = pci_get_drvdata(pdev);

-	stex_hba_stop(hba);
+	if (hba->supports_pm == 0)
+		stex_hba_stop(hba, ST_IGNORED);
+	else {
+		if (reboot)
+			stex_hba_stop(hba, ST_S6);
+		else
+			stex_hba_stop(hba, ST_S5);
+	}
  }

  MODULE_DEVICE_TABLE(pci, stex_pci_tbl);
@@ -1851,18 +1885,22 @@ static struct pci_driver stex_pci_driver = {
  	.shutdown	= stex_shutdown,
  };

+static struct notifier_block stex_reboot_notifier = {
+	stex_reboot_callback, NULL, 0
+};
  static int __init stex_init(void)
  {
  	printk(KERN_INFO DRV_NAME
  		": Promise SuperTrak EX Driver version: %s\n",
  		 ST_DRIVER_VERSION);
-
+	register_reboot_notifier(&stex_reboot_notifier);
  	return pci_register_driver(&stex_pci_driver);
  }

  static void __exit stex_exit(void)
  {
  	pci_unregister_driver(&stex_pci_driver);
+	unregister_reboot_notifier(&stex_reboot_notifier);
  }

  module_init(stex_init);
-- 
1.9.1
