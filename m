From: James Bottomley <James.Bottomley@suse.de>
Subject: [PATCH 1/2] libata: separate error handler into usable components
Date: Sun, 23 Jan 2011 09:42:50 -0600
Message-ID: <1295797370.3007.120.camel@mulgrave.site>
References: <1295797260.3007.118.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1295797260.3007.118.camel@mulgrave.site>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: linux-ide <linux-ide@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>, Robert Jennings <rcj@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Right at the moment, the libata error handler is incredibly
monolithic.  This makes it impossible to use from composite drivers
like libsas and ipr which have to handle error themselves in the first
instance.

The essence of the change is to split the monolithic error handler
into two components: one which handles a queue of ata commands for
processing and the other which handles the back end of readying a
port.  This allows the upper error handler fine grained control in
calling libsas functions (and making sure they only get called for ATA
commands whose lower errors have been fixed up).

Signed-off-by: James Bottomley <James.Bottomley@suse.de>
---
 drivers/ata/libata-eh.c |   53 +++++++++++++++++++++++++++++++++++++++--------
 include/linux/libata.h  |    2 +
 2 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index fc3f339..e02455b 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -587,7 +587,6 @@ static void ata_eh_unload(struct ata_port *ap)
 void ata_scsi_error(struct Scsi_Host *host)
 {
 	struct ata_port *ap = ata_shost_to_port(host);
-	int i;
 	unsigned long flags;
 	LIST_HEAD(eh_work_q);
 
@@ -597,6 +596,34 @@ void ata_scsi_error(struct Scsi_Host *host)
 	list_splice_init(&host->eh_cmd_q, &eh_work_q);
 	spin_unlock_irqrestore(host->host_lock, flags);
 
+	ata_scsi_cmd_error_handler(host, ap, &eh_work_q);
+
+	/* If we timed raced normal completion and there is nothing to
+	   recover nr_timedout == 0 why exactly are we doing error recovery ? */
+	ata_scsi_port_error_handler(host, ap);
+
+	/* finish or retry handled scmd's and clean up */
+	WARN_ON(host->host_failed || !list_empty(&eh_work_q));
+
+	DPRINTK("EXIT\n");
+}
+
+/**
+ * ata_scsi_cmd_error_handler - error callback for a list of commands
+ * @host:	scsi host containing the port
+ * @ap:		ATA port within the host
+ * @eh_work_q:	list of commands to process
+ *
+ * process the given list of commands and return those finished to the
+ * ap->eh_done_q.  This function is the first part of the libata error
+ * handler which processes a given list of failed commands.
+ */
+void ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap,
+				struct list_head *eh_work_q)
+{
+	int i;
+	unsigned long flags;
+
 	/* make sure sff pio task is not running */
 	ata_sff_flush_pio_task(ap);
 
@@ -632,7 +659,7 @@ void ata_scsi_error(struct Scsi_Host *host)
 		if (ap->ops->lost_interrupt)
 			ap->ops->lost_interrupt(ap);
 
-		list_for_each_entry_safe(scmd, tmp, &eh_work_q, eh_entry) {
+		list_for_each_entry_safe(scmd, tmp, eh_work_q, eh_entry) {
 			struct ata_queued_cmd *qc;
 
 			for (i = 0; i < ATA_MAX_QUEUE; i++) {
@@ -676,8 +703,20 @@ void ata_scsi_error(struct Scsi_Host *host)
 	} else
 		spin_unlock_wait(ap->lock);
 
-	/* If we timed raced normal completion and there is nothing to
-	   recover nr_timedout == 0 why exactly are we doing error recovery ? */
+}
+EXPORT_SYMBOL(ata_scsi_cmd_error_handler);
+
+/**
+ * ata_scsi_port_error_handler - recover the port after the commands
+ * @host:	SCSI host containing the port
+ * @ap:		the ATA port
+ *
+ * Handle the recovery of the port @ap after all the commands
+ * have been recovered.
+ */
+void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap)
+{
+	unsigned long flags;
 
 	/* invoke error handler */
 	if (ap->ops->error_handler) {
@@ -766,9 +805,6 @@ void ata_scsi_error(struct Scsi_Host *host)
 		ap->ops->eng_timeout(ap);
 	}
 
-	/* finish or retry handled scmd's and clean up */
-	WARN_ON(host->host_failed || !list_empty(&eh_work_q));
-
 	scsi_eh_flush_done_q(&ap->eh_done_q);
 
 	/* clean up */
@@ -789,9 +825,8 @@ void ata_scsi_error(struct Scsi_Host *host)
 	wake_up_all(&ap->eh_wait_q);
 
 	spin_unlock_irqrestore(ap->lock, flags);
-
-	DPRINTK("EXIT\n");
 }
+EXPORT_SYMBOL_GPL(ata_scsi_port_error_handler);
 
 /**
  *	ata_port_wait_eh - Wait for the currently pending EH to complete
diff --git a/include/linux/libata.h b/include/linux/libata.h
index c9c5d7a..9739317 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1050,6 +1050,8 @@ extern int ata_scsi_change_queue_depth(struct scsi_device *sdev,
 				       int queue_depth, int reason);
 extern struct ata_device *ata_dev_pair(struct ata_device *adev);
 extern int ata_do_set_mode(struct ata_link *link, struct ata_device **r_failed_dev);
+extern void ata_scsi_port_error_handler(struct Scsi_Host *host, struct ata_port *ap);
+extern void ata_scsi_cmd_error_handler(struct Scsi_Host *host, struct ata_port *ap, struct list_head *eh_q);
 
 extern int ata_cable_40wire(struct ata_port *ap);
 extern int ata_cable_80wire(struct ata_port *ap);
-- 
1.7.2.3



