From: Roland Dreier <roland@kernel.org>
Subject: [PATCH] target: Make se_dev_check_online() locking IRQ-safe
Date: Mon, 13 Jun 2011 20:55:06 -0700
Message-ID: <1308023706-7255-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:51226 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751495Ab1FNDzN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2011 23:55:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

se_dev_check_online() is called from transport_lookup_cmd_lun(), which
as discussed before may be called from interrupt context.  So it needs
to use spin_lock_irqsave() instead of spin_lock_irq() to avoid
enabling interrupts at the wrong time.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_device.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index fcb8161..f2a4bf2 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -815,12 +815,13 @@ static void se_dev_stop(struct se_device *dev)
 
 int se_dev_check_online(struct se_device *dev)
 {
+	unsigned long flags;
 	int ret;
 
-	spin_lock_irq(&dev->dev_status_lock);
+	spin_lock_irqsave(&dev->dev_status_lock, flags);
 	ret = ((dev->dev_status & TRANSPORT_DEVICE_ACTIVATED) ||
 	       (dev->dev_status & TRANSPORT_DEVICE_DEACTIVATED)) ? 0 : 1;
-	spin_unlock_irq(&dev->dev_status_lock);
+	spin_unlock_irqrestore(&dev->dev_status_lock, flags);
 
 	return ret;
 }
