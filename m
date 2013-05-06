From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/5] dc395: Move 'last_reset' into internal host structure
Date: Mon,  6 May 2013 09:20:39 +0200
Message-ID: <1367824841-47767-4-git-send-email-hare@suse.de>
References: <1367824841-47767-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753112Ab3EFHUp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 May 2013 03:20:45 -0400
In-Reply-To: <1367824841-47767-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

'last_reset' is only used internally, so move it into the
internal host structure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/dc395x.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 694e13c..42e8624 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -308,6 +308,8 @@ struct AdapterCtlBlk {
 	struct timer_list waiting_timer;
 	struct timer_list selto_timer;
 
+	unsigned long last_reset;
+
 	u16 srb_count;
 
 	u8 sel_timeout;
@@ -860,9 +862,9 @@ static void waiting_set_timer(struct AdapterCtlBlk *acb, unsigned long to)
 	init_timer(&acb->waiting_timer);
 	acb->waiting_timer.function = waiting_timeout;
 	acb->waiting_timer.data = (unsigned long) acb;
-	if (time_before(jiffies + to, acb->scsi_host->last_reset - HZ / 2))
+	if (time_before(jiffies + to, acb->last_reset - HZ / 2))
 		acb->waiting_timer.expires =
-		    acb->scsi_host->last_reset - HZ / 2 + 1;
+		    acb->last_reset - HZ / 2 + 1;
 	else
 		acb->waiting_timer.expires = jiffies + to + 1;
 	add_timer(&acb->waiting_timer);
@@ -1319,7 +1321,7 @@ static int __dc395x_eh_bus_reset(struct scsi_cmnd *cmd)
 	udelay(500);
 
 	/* We may be in serious trouble. Wait some seconds */
-	acb->scsi_host->last_reset =
+	acb->last_reset =
 	    jiffies + 3 * HZ / 2 +
 	    HZ * acb->eeprom.delay_time;
 
@@ -1462,9 +1464,9 @@ static void selto_timer(struct AdapterCtlBlk *acb)
 	acb->selto_timer.function = selection_timeout_missed;
 	acb->selto_timer.data = (unsigned long) acb;
 	if (time_before
-	    (jiffies + HZ, acb->scsi_host->last_reset + HZ / 2))
+	    (jiffies + HZ, acb->last_reset + HZ / 2))
 		acb->selto_timer.expires =
-		    acb->scsi_host->last_reset + HZ / 2 + 1;
+		    acb->last_reset + HZ / 2 + 1;
 	else
 		acb->selto_timer.expires = jiffies + HZ + 1;
 	add_timer(&acb->selto_timer);
@@ -1535,7 +1537,7 @@ static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 	}
 	/* Allow starting of SCSI commands half a second before we allow the mid-level
 	 * to queue them again after a reset */
-	if (time_before(jiffies, acb->scsi_host->last_reset - HZ / 2)) {
+	if (time_before(jiffies, acb->last_reset - HZ / 2)) {
 		dprintkdbg(DBG_KG, "start_scsi: Refuse cmds (reset wait)\n");
 		return 1;
 	}
@@ -3031,7 +3033,7 @@ static void disconnect(struct AdapterCtlBlk *acb)
 		dprintkl(KERN_ERR, "disconnect: No such device\n");
 		udelay(500);
 		/* Suspend queue for a while */
-		acb->scsi_host->last_reset =
+		acb->last_reset =
 		    jiffies + HZ / 2 +
 		    HZ * acb->eeprom.delay_time;
 		clear_fifo(acb, "disconnectEx");
@@ -3053,7 +3055,7 @@ static void disconnect(struct AdapterCtlBlk *acb)
 		waiting_process_next(acb);
 	} else if (srb->state & SRB_ABORT_SENT) {
 		dcb->flag &= ~ABORT_DEV_;
-		acb->scsi_host->last_reset = jiffies + HZ / 2 + 1;
+		acb->last_reset = jiffies + HZ / 2 + 1;
 		dprintkl(KERN_ERR, "disconnect: SRB_ABORT_SENT\n");
 		doing_srb_done(acb, DID_ABORT, srb->cmd, 1);
 		waiting_process_next(acb);
@@ -3649,7 +3651,7 @@ static void scsi_reset_detect(struct AdapterCtlBlk *acb)
 	/*DC395x_write8(acb, TRM_S1040_DMA_CONTROL,STOPDMAXFER); */
 	udelay(500);
 	/* Maybe we locked up the bus? Then lets wait even longer ... */
-	acb->scsi_host->last_reset =
+	acb->last_reset =
 	    jiffies + 5 * HZ / 2 +
 	    HZ * acb->eeprom.delay_time;
 
@@ -4426,7 +4428,7 @@ static void adapter_init_scsi_host(struct Scsi_Host *host)
 	host->dma_channel = -1;
 	host->unique_id = acb->io_port_base;
 	host->irq = acb->irq_level;
-	host->last_reset = jiffies;
+	acb->last_reset = jiffies;
 
 	host->max_id = 16;
 	if (host->max_id - 1 == eeprom->scsi_id)
@@ -4484,7 +4486,7 @@ static void adapter_init_chip(struct AdapterCtlBlk *acb)
 		/*spin_unlock_irq (&io_request_lock); */
 		udelay(500);
 
-		acb->scsi_host->last_reset =
+		acb->last_reset =
 		    jiffies + HZ / 2 +
 		    HZ * acb->eeprom.delay_time;
 
-- 
1.7.12.4

