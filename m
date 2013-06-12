From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v11 5/9] Avoid saving/restoring interrupt state inside scsi_remove_host()
Date: Wed, 12 Jun 2013 14:54:15 +0200
Message-ID: <51B86F77.7010208@acm.org>
References: <51B86E26.6030108@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:46884 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3FLMyQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jun 2013 08:54:16 -0400
In-Reply-To: <51B86E26.6030108@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Joe Lawrence <jdl1291@gmail.com>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>, David Milburn <dmilburn@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

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
index df0c3c7..034a567 100644
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

