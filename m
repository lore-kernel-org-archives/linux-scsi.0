From: Charles Chiou <ch1102chiou@gmail.com>
Subject: [v2 PATCH 2/2] scsi:stex.c Add S6 support
Date: Tue, 14 Jun 2016 14:22:32 +0800
Message-ID: <1465885352-8602-1-git-send-email-ch1102chiou@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34213 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbcFNGXD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 02:23:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, eva.cheng@tw.promise.com, charles.chiou@tw.promise.com, julian.calaby@gmail.com
Cc: Paul <paul.lyu@tw.promise.com>

From: Charles <charles.chiou@tw.promise.com>

1.Add reboot notifier and register it in stex_probe for all supported device.

2.For all supported device in restart flow, we get a callback from notifier and set S6flag for stex_shutdown & stex_hba_stop to send restart command to FW.

Signed-off-by: Charles <charles.chiou@tw.promise.com>
Signed-off-by: Paul <paul.lyu@tw.promise.com>
---
 drivers/scsi/stex.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 817e895..e1d70b1 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/ktime.h>
+#include <linux/reboot.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/byteorder.h>
@@ -362,6 +363,12 @@ struct st_card_info {
 	u16 sts_count;
 };
 
+int S6flag;
+static int stex_halt(struct notifier_block *nb, ulong event, void *buf);
+static struct notifier_block stex_notifier = {
+	stex_halt, NULL, 0
+};
+
 static int msi;
 module_param(msi, int, 0);
 MODULE_PARM_DESC(msi, "Enable Message Signaled Interrupts(0=off, 1=on)");
@@ -1657,6 +1664,9 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_master(pdev);
 
+	S6flag = 0;
+	register_reboot_notifier(&stex_notifier);
+
 	host = scsi_host_alloc(&driver_template, sizeof(struct st_hba));
 
 	if (!host) {
@@ -1931,15 +1941,20 @@ static void stex_remove(struct pci_dev *pdev)
 	scsi_host_put(hba->host);
 
 	pci_disable_device(pdev);
+
+	unregister_reboot_notifier(&stex_notifier);
 }
 
 static void stex_shutdown(struct pci_dev *pdev)
 {
 	struct st_hba *hba = pci_get_drvdata(pdev);
 
-	if (hba->supports_pm == 0)
+	if (hba->supports_pm == 0) {
 		stex_hba_stop(hba, ST_IGNORED);
-	else
+	} else if (hba->supports_pm == 1 && S6flag) {
+		unregister_reboot_notifier(&stex_notifier);
+		stex_hba_stop(hba, ST_S6);
+	} else
 		stex_hba_stop(hba, ST_S5);
 }
 
@@ -1976,6 +1991,12 @@ static int stex_resume(struct pci_dev *pdev)
 	stex_handshake(hba);
 	return 0;
 }
+
+static int stex_halt(struct notifier_block *nb, unsigned long event, void *buf)
+{
+	S6flag = 1;
+	return NOTIFY_OK;
+}
 MODULE_DEVICE_TABLE(pci, stex_pci_tbl);
 
 static struct pci_driver stex_pci_driver = {
-- 
1.9.1

