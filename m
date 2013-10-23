From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 6/8] scsi: remove check for 'resetting'
Date: Wed, 23 Oct 2013 10:51:20 +0200
Message-ID: <1382518282-107606-7-git-send-email-hare@suse.de>
References: <1382518282-107606-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55175 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab3JWIv3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Oct 2013 04:51:29 -0400
In-Reply-To: <1382518282-107606-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Hannes Reinecke <hare@suse.de>

Field is now unused, so this is dead code.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi.c | 28 ----------------------------
 1 file changed, 28 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index eaa808e..fe0bcb1 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -78,11 +78,6 @@ static void scsi_done(struct scsi_cmnd *cmd);
  * Definitions and constants.
  */
 
-#define MIN_RESET_DELAY (2*HZ)
-
-/* Do not call reset on error if we just did a reset within 15 sec. */
-#define MIN_RESET_PERIOD (15*HZ)
-
 /*
  * Note - the initial logging level can be set here to log events at boot time.
  * After the system is up, you may enable logging via the /proc interface.
@@ -658,7 +653,6 @@ EXPORT_SYMBOL(scsi_cmd_get_serial);
 int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 {
 	struct Scsi_Host *host = cmd->device->host;
-	unsigned long timeout;
 	int rtn = 0;
 
 	atomic_inc(&cmd->device->iorequest_cnt);
@@ -704,28 +698,6 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
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
-- 
1.8.1.4

