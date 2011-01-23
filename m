From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 3/3] libata: fix eh locking
Date: Sun, 23 Jan 2011 08:31:14 -0600
Message-ID: <1295793074.3007.18.camel@mulgrave.site>
References: <1295792806.3007.12.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56967 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972Ab1AWObR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Jan 2011 09:31:17 -0500
In-Reply-To: <1295792806.3007.12.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-ide <linux-ide@vger.kernel.org>

The SCSI host eh_cmd_q should be protected by the host lock (not the
port lock).  This probably doesn't matter that much at the moment,
since we try to serialise the add and eh pieces, but it might matter
in future for more convenient error handling.  Plus this switches
libata to the standard eh pattern where you lock, remove from the cmd
queue to a local list and unlock and then operate on the local list.

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
---
 drivers/ata/libata-eh.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 17a6378..fc3f339 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -589,9 +589,14 @@ void ata_scsi_error(struct Scsi_Host *host)
 	struct ata_port *ap = ata_shost_to_port(host);
 	int i;
 	unsigned long flags;
+	LIST_HEAD(eh_work_q);
 
 	DPRINTK("ENTER\n");
 
+	spin_lock_irqsave(host->host_lock, flags);
+	list_splice_init(&host->eh_cmd_q, &eh_work_q);
+	spin_unlock_irqrestore(host->host_lock, flags);
+
 	/* make sure sff pio task is not running */
 	ata_sff_flush_pio_task(ap);
 
@@ -627,7 +632,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 		if (ap->ops->lost_interrupt)
 			ap->ops->lost_interrupt(ap);
 
-		list_for_each_entry_safe(scmd, tmp, &host->eh_cmd_q, eh_entry) {
+		list_for_each_entry_safe(scmd, tmp, &eh_work_q, eh_entry) {
 			struct ata_queued_cmd *qc;
 
 			for (i = 0; i < ATA_MAX_QUEUE; i++) {
@@ -762,7 +767,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 	}
 
 	/* finish or retry handled scmd's and clean up */
-	WARN_ON(host->host_failed || !list_empty(&host->eh_cmd_q));
+	WARN_ON(host->host_failed || !list_empty(&eh_work_q));
 
 	scsi_eh_flush_done_q(&ap->eh_done_q);
 
-- 
1.7.2.3



