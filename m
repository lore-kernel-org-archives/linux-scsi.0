From: Charles Chiou <ch1102chiou@gmail.com>
Subject: Need to distinct shut down or restart on driver side.
Date: Tue, 08 Sep 2015 15:26:29 +0800
Message-ID: <55EE8DA5.1090001@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34527 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbbIHH0h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2015 03:26:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-pm@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org
Cc: grace.chang@tw.promise.com, linus.chen@tw.promise.com

Hi, we need to get the information that specified the host is going to 
shut down or restart. Ideally, our device can reference the HW signal to 
know the host is going to shut down or restart, unfortunately, we face 
the HW signal issue on various motherboards.

We experiment on many motherboards, and we observe that the restart
signal is different on different motherboard. If device misses the
signal, PCI loss or volume disappearance might happen.


Currently, stex.c cannot send reboot signal to the fw because the only 
way to distinct shut down and restart on driver side is 
register_reboot_notifier() which is not allow to SCSI driver.

Could you provide some suggestions?


Add reboot feature is the forth patch in stex.c patch series.
Patch 1~3 have been sent to Linux-SCSI mailing list. Patch 4 is the 
reboot patch and I don't sent it to Linux-SCSI mailing list.
Attach patch 4 as following.
BRS
Charles


 From 35a709ea3ae213bef9982706e9a95ffb26e04e1e Mon Sep 17 00:00:00 2001
From: Charles <charles.chiou@tw.promise.com>
Date: Tue, 8 Sep 2015 15:09:42 +0800
Subject: [PATCH 4/4] scsi:stex.c Add reboot support

1. Add reboot support, Pegasus devices should be notified that
    the host is going to shutdown/restart. I register reboot callback
    function to distinct host is going to shutdown or to restart.

Signed-off-by: Charles Chiou <charles.chiou@tw.promise.com>
---
  drivers/scsi/stex.c | 25 +++++++++++++++++++++++--
  1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index c96a86d..63ca921 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -25,6 +25,7 @@
  #include <linux/types.h>
  #include <linux/module.h>
  #include <linux/spinlock.h>
+#include <linux/reboot.h>
  #include <asm/io.h>
  #include <asm/irq.h>
  #include <asm/byteorder.h>
@@ -351,6 +352,7 @@ struct st_card_info {
  	u16 sts_count;
  };

+static int isRestart;
  static int msi;
  module_param(msi, int, 0);
  MODULE_PARM_DESC(msi, "Enable Message Signaled Interrupts(0=off, 1=on)");
@@ -372,6 +374,14 @@ MODULE_DESCRIPTION("Promise Technology SuperTrak EX 
Controllers");
  MODULE_LICENSE("GPL");
  MODULE_VERSION(ST_DRIVER_VERSION);

+static int stex_reboot_callback(struct notifier_block *self,
+	unsigned long val, void *data)
+{
+	if (val == SYS_RESTART)
+		isRestart = 1;
+	return NOTIFY_OK;
+}
+
  static void stex_gettime(__le64 *time)
  {
  	struct timeval tv;
@@ -1547,6 +1557,7 @@ static int stex_probe(struct pci_dev *pdev, const 
struct pci_device_id *id)
  	u32 sts_offset, cp_offset, scratch_offset;
  	int err;

+	isRestart = 0;
  	err = pci_enable_device(pdev);
  	if (err)
  		return err;
@@ -1834,8 +1845,12 @@ static void stex_shutdown(struct pci_dev *pdev)

  	if (hba->supports_pm == 0)
  		stex_hba_stop(hba, ST_IGNORED);
-	else
-		stex_hba_stop(hba, ST_S5);
+	else {
+		if (isRestart)
+			stex_hba_stop(hba, ST_S6);
+		else
+			stex_hba_stop(hba, ST_S5);
+	}
  }

  static int stex_choice_sleep_mic(pm_message_t state)
@@ -1882,18 +1897,24 @@ static struct pci_driver stex_pci_driver = {
  	.resume		= stex_resume,
  };

+static struct notifier_block stex_reboot_notifier = {
+	stex_reboot_callback, NULL, 0
+};
+
  static int __init stex_init(void)
  {
  	printk(KERN_INFO DRV_NAME
  		": Promise SuperTrak EX Driver version: %s\n",
  		 ST_DRIVER_VERSION);

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



