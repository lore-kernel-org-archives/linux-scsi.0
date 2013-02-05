From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v8 06/10] Avoid saving/restoring interrupt state inside scsi_remove_host()
Date: Tue, 05 Feb 2013 13:49:05 +0100
Message-ID: <5110FFC1.6010402@acm.org>
References: <5110FE98.8030209@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:41694 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab3BEMtG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2013 07:49:06 -0500
In-Reply-To: <5110FE98.8030209@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>

Since it is not allowed to invoke scsi_remove_host() with interrupts
disabled, avoid saving and restoring the interrupt state inside
scsi_remove_host(). This patch does not change the functionality of
the function scsi_remove_host().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <JBottomley@Parallels.com>
---
 drivers/scsi/hosts.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 593085a..6ae16cd 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -156,27 +156,25 @@ EXPORT_SYMBOL(scsi_host_set_state);
  **/
 void scsi_remove_host(struct Scsi_Host *shost)
 {
-	unsigned long flags;
-
 	mutex_lock(&shost->scan_mutex);
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irq(shost->host_lock);
 	if (scsi_host_set_state(shost, SHOST_CANCEL))
 		if (scsi_host_set_state(shost, SHOST_CANCEL_RECOVERY)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
+			spin_unlock_irq(shost->host_lock);
 			mutex_unlock(&shost->scan_mutex);
 			return;
 		}
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irq(shost->host_lock);
 
 	scsi_autopm_get_host(shost);
 	scsi_forget_host(shost);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_proc_host_rm(shost);
 
-	spin_lock_irqsave(shost->host_lock, flags);
+	spin_lock_irq(shost->host_lock);
 	if (scsi_host_set_state(shost, SHOST_DEL))
 		BUG_ON(scsi_host_set_state(shost, SHOST_DEL_RECOVERY));
-	spin_unlock_irqrestore(shost->host_lock, flags);
+	spin_unlock_irq(shost->host_lock);
 
 	transport_unregister_device(&shost->shost_gendev);
 	device_unregister(&shost->shost_dev);
-- 
1.7.10.4

