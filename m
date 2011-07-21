From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 076/103] target: Make se_dev_check_online() locking IRQ-safe
Date: Thu, 21 Jul 2011 00:11:59 -0700
Message-ID: <1311232346-6674-77-git-send-email-nab@linux-iscsi.org>
References: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm10.bullet.mail.bf1.yahoo.com ([98.139.212.169]:36298 "HELO
	nm10.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751926Ab1GUHIH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:07 -0400
In-Reply-To: <1311232346-6674-63-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

se_dev_check_online() is called from transport_lookup_cmd_lun(), which
as discussed before may be called from interrupt context.  So it needs
to use spin_lock_irqsave() instead of spin_lock_irq() to avoid
enabling interrupts at the wrong time.

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e25df3b..6d93d96 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -813,12 +813,13 @@ static void se_dev_stop(struct se_device *dev)
 
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
-- 
1.7.6

