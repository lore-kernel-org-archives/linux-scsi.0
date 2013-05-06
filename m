From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/5] scsi: remove 'resetting' field from struct Scsi_Host
Date: Mon,  6 May 2013 09:20:37 +0200
Message-ID: <1367824841-47767-2-git-send-email-hare@suse.de>
References: <1367824841-47767-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38798 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061Ab3EFHUp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 May 2013 03:20:45 -0400
In-Reply-To: <1367824841-47767-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

struct Scsi_Host has a field 'resetting' which is only ever used
in dpt_i2o. And even there the usage is questionable.
So remove the field and have dpt_i2o use the standard mechanism
for delaying I/O.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/dpt_i2o.c   | 22 +++-------------------
 drivers/scsi/scsi.c      | 25 +------------------------
 include/scsi/scsi_host.h |  1 -
 3 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 19e1b42..943d9c0 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -448,18 +448,8 @@ static int adpt_queue_lck(struct scsi_cmnd * cmd, void (*done) (struct scsi_cmnd
 	}
 
 	rmb();
-	/*
-	 * TODO: I need to block here if I am processing ioctl cmds
-	 * but if the outstanding cmds all finish before the ioctl,
-	 * the scsi-core will not know to start sending cmds to me again.
-	 * I need to a way to restart the scsi-cores queues or should I block
-	 * calling scsi_done on the outstanding cmds instead
-	 * for now we don't set the IOCTL state
-	 */
-	if(((pHba->state) & DPTI_STATE_IOCTL) || ((pHba->state) & DPTI_STATE_RESET)) {
-		pHba->host->last_reset = jiffies;
-		pHba->host->resetting = 1;
-		return 1;
+	if(((pHba->state) & DPTI_STATE_RESET)) {
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	// TODO if the cmd->device if offline then I may need to issue a bus rescan
@@ -1813,19 +1803,13 @@ static int adpt_i2o_passthru(adpt_hba* pHba, u32 __user *arg)
 	do {
 		if(pHba->host)
 			spin_lock_irqsave(pHba->host->host_lock, flags);
-		// This state stops any new commands from enterring the
-		// controller while processing the ioctl
-//		pHba->state |= DPTI_STATE_IOCTL;
-//		We can't set this now - The scsi subsystem sets host_blocked and
-//		the queue empties and stops.  We need a way to restart the queue
 		rcode = adpt_i2o_post_wait(pHba, msg, size, FOREVER);
 		if (rcode != 0)
 			printk("adpt_i2o_passthru: post wait failed %d %p\n",
 					rcode, reply);
-//		pHba->state &= ~DPTI_STATE_IOCTL;
 		if(pHba->host)
 			spin_unlock_irqrestore(pHba->host->host_lock, flags);
-	} while(rcode == -ETIMEDOUT);  
+	} while(rcode == -ETIMEDOUT);
 
 	if(rcode){
 		goto cleanup;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 2c0d0ec..173c6bc 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -658,7 +658,6 @@ EXPORT_SYMBOL(scsi_cmd_get_serial);
 int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
-	unsigned long timeout;
 	int rtn = 0;
 
 	atomic_inc(&cmd->device->iorequest_cnt);
@@ -695,7 +694,7 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 		goto out;
 	}
 
-	/* 
+	/*
 	 * If SCSI-2 or lower, store the LUN value in cmnd.
 	 */
 	if (cmd->device->scsi_level <= SCSI_2 &&
@@ -704,28 +703,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 			       (cmd->device->lun << 5 & 0xe0);
 	}
 
-	/*
-	 * We will wait MIN_RESET_DELAY clock ticks after the last reset so
-	 * we can avoid the drive not being ready.
-	 */
-	timeout = host->last_reset + MIN_RESET_DELAY;
-
-	if (host->resetting && time_before(jiffies, timeout)) {
-		int ticks_remaining = timeout - jiffies;
-		/*
-		 * NOTE: This may be executed from within an interrupt
-		 * handler!  This is bad, but for now, it'll do.  The irq
-		 * level of the interrupt handler has been masked out by the
-		 * platform dependent interrupt handling code already, so the
-		 * sti() here will not cause another call to the SCSI host's
-		 * interrupt handler (assuming there is one irq-level per
-		 * host).
-		 */
-		while (--ticks_remaining >= 0)
-			mdelay(1 + 999 / HZ);
-		host->resetting = 0;
-	}
-
 	scsi_log_send(cmd);
 
 	/*
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 7552435..af7ad0e 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -598,7 +598,6 @@ struct Scsi_Host {
 	unsigned int host_eh_scheduled;    /* EH scheduled without command */
     
 	unsigned int host_no;  /* Used for IOCTL_GET_IDLUN, /proc/scsi et al. */
-	int resetting; /* if set, it means that last_reset is a valid value */
 	unsigned long last_reset;
 
 	/*
-- 
1.7.12.4

