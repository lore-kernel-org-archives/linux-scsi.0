From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2 2/4] target: Fix interrupt context bug with stats_lock and core_tmr_alloc_req
Date: Tue, 10 May 2011 21:35:33 -0700
Message-ID: <1305088535-27486-3-git-send-email-nab@linux-iscsi.org>
References: <1305088535-27486-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm27.access.bullet.mail.sp2.yahoo.com ([98.139.44.154]:28611
	"HELO nm27.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750818Ab1EKSwi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2011 14:52:38 -0400
In-Reply-To: <1305088535-27486-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Kiran Patil <kiran.patil@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes two bugs wrt to the interrupt context usage of target
core with HW target mode drivers.  It first converts the usage of struct
se_device->stats_lock in transport_get_lun_for_cmd() and core_tmr_lun_reset()
to properly use spin_lock_irq() to address an BUG with CONFIG_LOCKDEP_SUPPORT=y
enabled.

This patch also adds a 'in_interrupt()' check to allow GFP_ATOMIC usage from
core_tmr_alloc_req() to fix a 'sleeping in interrupt context' BUG with HW
target fabrics that require this logic to function.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    4 ++--
 drivers/target/target_core_tmr.c    |    7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index d25e208..fc10ed4 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -150,13 +150,13 @@ out:
 
 	{
 	struct se_device *dev = se_lun->lun_se_dev;
-	spin_lock(&dev->stats_lock);
+	spin_lock_irq(&dev->stats_lock);
 	dev->num_cmds++;
 	if (se_cmd->data_direction == DMA_TO_DEVICE)
 		dev->write_bytes += se_cmd->data_length;
 	else if (se_cmd->data_direction == DMA_FROM_DEVICE)
 		dev->read_bytes += se_cmd->data_length;
-	spin_unlock(&dev->stats_lock);
+	spin_unlock_irq(&dev->stats_lock);
 	}
 
 	/*
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 4a10983..59b8b9c 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -55,7 +55,8 @@ struct se_tmr_req *core_tmr_alloc_req(
 {
 	struct se_tmr_req *tmr;
 
-	tmr = kmem_cache_zalloc(se_tmr_req_cache, GFP_KERNEL);
+	tmr = kmem_cache_zalloc(se_tmr_req_cache, (in_interrupt()) ?
+					GFP_ATOMIC : GFP_KERNEL);
 	if (!(tmr)) {
 		printk(KERN_ERR "Unable to allocate struct se_tmr_req\n");
 		return ERR_PTR(-ENOMEM);
@@ -398,9 +399,9 @@ int core_tmr_lun_reset(
 		printk(KERN_INFO "LUN_RESET: SCSI-2 Released reservation\n");
 	}
 
-	spin_lock(&dev->stats_lock);
+	spin_lock_irq(&dev->stats_lock);
 	dev->num_resets++;
-	spin_unlock(&dev->stats_lock);
+	spin_unlock_irq(&dev->stats_lock);
 
 	DEBUG_LR("LUN_RESET: %s for [%s] Complete\n",
 			(preempt_and_abort_list) ? "Preempt" : "TMR",
-- 
1.7.5.1

