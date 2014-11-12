From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [V2 PATCH 3/4] scsi:stex.c Add reboot support
Date: Wed, 12 Nov 2014 11:38:20 +0800
Message-ID: <5462D62C.50602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

 From 5eac0f3209e0857c983c986786a68eac0d67247b Mon Sep 17 00:00:00 2001
From: Charles Chiou <charles.chiou@tw.promise.com>
Date: Wed, 5 Nov 2014 19:29:46 +0800
Subject: [PATCH 3/4] scsi:stex.c Add reboot support

1. Add reboot support, Pegasus devices should be notified that
    the host is going to shutdown/reboot. I register reboot callback
    function to distinct host is going to shutdown or to reboot.

2. Pegasus FW shutdown flow is sensitive to host behavior
    (host is going to S3/S4/shutdown/reboot). To this, I add one
    argument in stex_hba_stop to support various stop command.

3. For backward compatibility, I used ST_IGNORED
    variable to specified shutdown should be the old flow.

4. Sometimes Pegasus need to more time to start. Expand
    delay time from 120 to 240.

Signed-off-by: Charles Chiou <charles.chiou@tw.promise.com>

---
  drivers/scsi/stex.c | 48 +++++++++++++++++++++++++++++++++++++++++++-----
  1 file changed, 43 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index c0bbbbd..7a66a931 100644
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
@@ -86,7 +87,7 @@ enum {
  	MU_STATE_STOP				= 5,
  	MU_STATE_NOCONNECT			= 6,

-	MU_MAX_DELAY				= 120,
+	MU_MAX_DELAY				= 240,
  	MU_HANDSHAKE_SIGNATURE			= 0x55aaaa55,
  	MU_HANDSHAKE_SIGNATURE_HALF		= 0x5a5a0000,
  	MU_HARD_RESET_WAIT			= 30000,
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

+static int isRestart;
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
+		isRestart = 1;
+	return NOTIFY_OK;
+}

  static void stex_gettime(__le64 *time)
  {
@@ -1563,6 +1580,7 @@ static int stex_probe(struct pci_dev *pdev, const 
struct pci_device_id *id)
  	u32 subID;
  	int err;

+	isRestart = 0;
  	err = pci_enable_device(pdev);
  	if (err)
  		return err;
@@ -1749,7 +1767,7 @@ out_disable:
  	return err;
  }

-static void stex_hba_stop(struct st_hba *hba)
+static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
  {
  	struct req_msg *req;
  	struct st_msg_header *msg_h;
@@ -1765,11 +1783,18 @@ static void stex_hba_stop(struct st_hba *hba)
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
@@ -1789,10 +1814,12 @@ static void stex_hba_stop(struct st_hba *hba)
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
@@ -1832,7 +1859,14 @@ static void stex_shutdown(struct pci_dev *pdev)
  {
  	struct st_hba *hba = pci_get_drvdata(pdev);

-	stex_hba_stop(hba);
+	if (hba->yellowstone == 1)
+		stex_hba_stop(hba, ST_IGNORED);
+	else {
+		if (isRestart)
+			stex_hba_stop(hba, ST_S6);
+		else
+			stex_hba_stop(hba, ST_S5);
+	}
  }

  MODULE_DEVICE_TABLE(pci, stex_pci_tbl);
@@ -1845,18 +1879,22 @@ static struct pci_driver stex_pci_driver = {
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
