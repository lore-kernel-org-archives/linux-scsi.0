From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/6] tcm: Convert struct se_device->dev_status_lock to spin_*lock_irq()
Date: Mon,  6 Sep 2010 14:37:36 -0700
Message-ID: <1283809056-13724-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp102.sbc.mail.re3.yahoo.com ([66.196.96.85]:27833 "HELO
	smtp102.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755850Ab0IFVhl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 17:37:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the lock/unlock usage of struct se_device->dev_status_lock
to use spin_*lock_irq() instead of spin_*lock_bh() so that drivers/target/target_core_device.c:
se_dev_check_online() from __transport_get_lun_for_cmd() in interrupt context.

This includes converting se_dev_check_online(), se_dev_check_shutdown() and
the main check in transport_processing_thread().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    |   40 +++----------------------------
 drivers/target/target_core_transport.c |    6 ++--
 include/target/target_core_device.h    |    1 -
 3 files changed, 7 insertions(+), 40 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 7c357a5..665b8e2 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -155,38 +155,6 @@ int linux_blockdevice_check(int major, int minor)
 }
 EXPORT_SYMBOL(linux_blockdevice_check);
 
-/*	se_disable_devices_for_hba():
- *
- *
- */
-void se_disable_devices_for_hba(struct se_hba *hba)
-{
-	struct se_device *dev;
-
-	spin_lock(&hba->device_lock);
-	list_for_each_entry(dev, &hba->hba_dev_list, dev_list) {
-
-		spin_lock(&dev->dev_status_lock);
-		if ((dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) ||
-		    (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED) ||
-		    (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_ACTIVATED) ||
-		    (dev->dev_status & TRANSPORT_DEVICE_OFFLINE_DEACTIVATED)) {
-			dev->dev_status |= TRANSPORT_DEVICE_SHUTDOWN;
-			dev->dev_status &= ~TRANSPORT_DEVICE_ACTIVATED;
-			dev->dev_status &= ~TRANSPORT_DEVICE_DEACTIVATED;
-			dev->dev_status &= ~TRANSPORT_DEVICE_OFFLINE_ACTIVATED;
-			dev->dev_status &=
-					~TRANSPORT_DEVICE_OFFLINE_DEACTIVATED;
-
-			wake_up_interruptible(&dev->dev_queue_obj->thread_wq);
-		}
-		spin_unlock(&dev->dev_status_lock);
-	}
-	spin_unlock(&hba->device_lock);
-
-	return;
-}
-
 extern int __transport_get_lun_for_cmd(
 	struct se_cmd *se_cmd,
 	u32 unpacked_lun)
@@ -1004,10 +972,10 @@ int se_dev_check_online(struct se_device *dev)
 {
 	int ret;
 
-	spin_lock(&dev->dev_status_lock);
+	spin_lock_irq(&dev->dev_status_lock);
 	ret = ((dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) ||
 	       (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED)) ? 0 : 1;
-	spin_unlock(&dev->dev_status_lock);
+	spin_unlock_irq(&dev->dev_status_lock);
 	
 	return ret;
 }
@@ -1016,9 +984,9 @@ int se_dev_check_shutdown(struct se_device *dev)
 {
 	int ret;
 
-	spin_lock(&dev->dev_status_lock);
+	spin_lock_irq(&dev->dev_status_lock);
 	ret = (dev->dev_status & TRANSPORT_DEVICE_SHUTDOWN);
-	spin_unlock(&dev->dev_status_lock);
+	spin_unlock_irq(&dev->dev_status_lock);
 
 	return ret;
 }
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 56ed466..b53ca99 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -8342,13 +8342,13 @@ static int transport_processing_thread(void *param)
 		if (ret < 0)
 			goto out;
 
-		spin_lock(&dev->dev_status_lock);
+		spin_lock_irq(&dev->dev_status_lock);
 		if (dev->dev_status & TRANSPORT_DEVICE_SHUTDOWN) {
-			spin_unlock(&dev->dev_status_lock);
+			spin_unlock_irq(&dev->dev_status_lock);
 			transport_processing_shutdown(dev);
 			continue;
 		}
-		spin_unlock(&dev->dev_status_lock);
+		spin_unlock_irq(&dev->dev_status_lock);
 
 get_cmd:
 		__transport_execute_tasks(dev);
diff --git a/include/target/target_core_device.h b/include/target/target_core_device.h
index 937010c..eb825c3 100644
--- a/include/target/target_core_device.h
+++ b/include/target/target_core_device.h
@@ -7,7 +7,6 @@ extern struct block_device *__linux_blockdevice_claim(int, int, void *, int *);
 extern struct block_device *linux_blockdevice_claim(int, int, void *);
 extern int linux_blockdevice_release(int, int, struct block_device *);
 extern int linux_blockdevice_check(int, int);
-extern void se_disable_devices_for_hba(struct se_hba *);
 extern int transport_get_lun_for_cmd(struct se_cmd *, unsigned char *, u32);
 extern int transport_get_lun_for_tmr(struct se_cmd *, u32);
 extern struct se_dev_entry *core_get_se_deve_from_rtpi(
-- 
1.5.6.5

