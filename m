From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] cleanup device_busy/host_busy handling
Date: Fri, 6 Jun 2003 16:40:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030606144023.GA23557@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:43477 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261411AbTFFO0x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 10:26:53 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

- scsi_host_busy_inc isn't used anymore (and uses broken locking rules),
  kill it.
- scsi_host_busy_dec_and_test gets replace by scsi_device_unbusy that
  also cares for sdev->device_busty.
- there's a new helper, scsi_eh_wakeup, shared by scsi_device_unbusy
  and some EH code.


diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
--- a/drivers/scsi/hosts.c	Thu Jun  5 18:49:12 2003
+++ b/drivers/scsi/hosts.c	Thu Jun  5 18:49:12 2003
@@ -289,29 +289,3 @@
 	class_device_put(&shost->class_dev);
 	put_device(&shost->host_gendev);
 }
-
-void scsi_host_busy_inc(struct Scsi_Host *shost, Scsi_Device *sdev)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->host_busy++;
-	sdev->device_busy++;
-	spin_unlock_irqrestore(shost->host_lock, flags);
-}
-
-void scsi_host_busy_dec_and_test(struct Scsi_Host *shost, Scsi_Device *sdev)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(shost->host_lock, flags);
-	shost->host_busy--;
-	if (shost->in_recovery && shost->host_failed &&
-	    (shost->host_busy == shost->host_failed))
-	{
-		up(shost->eh_wait);
-		SCSI_LOG_ERROR_RECOVERY(5, printk("Waking error handler"
-					  " thread\n"));
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-}
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Thu Jun  5 18:49:12 2003
+++ b/drivers/scsi/scsi.c	Thu Jun  5 18:49:12 2003
@@ -733,16 +733,8 @@
 	struct scsi_device *sdev = cmd->device;
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_request *sreq;
-	unsigned long flags;
 
-	scsi_host_busy_dec_and_test(shost, sdev);
-
-	/*
-	 * XXX(hch): We really want a nice helper for this..
-	 */
-	spin_lock_irqsave(&sdev->sdev_lock, flags);
-	sdev->device_busy--;
-	spin_unlock_irqrestore(&sdev->sdev_lock, flags);
+	scsi_device_unbusy(sdev);
 
         /*
          * Clear the flags which say that the device/host is no longer
diff -Nru a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c	Thu Jun  5 18:49:12 2003
+++ b/drivers/scsi/scsi_error.c	Thu Jun  5 18:49:12 2003
@@ -44,6 +44,16 @@
 #define BUS_RESET_SETTLE_TIME   10*HZ
 #define HOST_RESET_SETTLE_TIME  10*HZ
 
+/* called with shost->host_lock held */
+void scsi_eh_wakeup(struct Scsi_Host *shost)
+{
+	if (shost->host_busy == shost->host_failed) {
+		up(shost->eh_wait);
+		SCSI_LOG_ERROR_RECOVERY(5,
+				printk("Waking error handler thread\n"));
+	}
+}
+
 /**
  * scsi_eh_scmd_add - add scsi cmd to error handling.
  * @scmd:	scmd to run eh on.
@@ -76,14 +86,8 @@
 	list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
 	shost->in_recovery = 1;
 	shost->host_failed++;
-	if (shost->host_busy == shost->host_failed) {
-		up(shost->eh_wait);
-		SCSI_LOG_ERROR_RECOVERY(5, printk("Waking error handler"
-					  " thread\n"));
-	}
-
+	scsi_eh_wakeup(shost);
 	spin_unlock_irqrestore(shost->host_lock, flags);
-
 	return 1;
 }
 
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Thu Jun  5 18:49:12 2003
+++ b/drivers/scsi/scsi_lib.c	Thu Jun  5 18:49:12 2003
@@ -95,7 +95,6 @@
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
-	unsigned long flags;
 
 	SCSI_LOG_MLQUEUE(1,
 		 printk("Inserting command %p into mlqueue\n", cmd));
@@ -134,10 +133,7 @@
 	 * Decrement the counters, since these commands are no longer
 	 * active on the host/device.
 	 */
-	spin_lock_irqsave(device->request_queue->queue_lock, flags);
-	device->device_busy--;
-	spin_unlock_irqrestore(device->request_queue->queue_lock, flags);
-	scsi_host_busy_dec_and_test(host, device);
+	scsi_device_unbusy(device);
 
 	/*
 	 * Insert this command at the head of the queue for it's device.
@@ -312,6 +308,21 @@
 	cmd->cmd_len = cmd->old_cmd_len;
 	cmd->sc_data_direction = cmd->sc_old_data_direction;
 	cmd->underflow = cmd->old_underflow;
+}
+
+void scsi_device_unbusy(struct scsi_device *sdev)
+{
+	struct Scsi_Host *shost = sdev->host;
+	unsigned long flags;
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	shost->host_busy--;
+	if (unlikely(shost->in_recovery && shost->host_failed))
+		scsi_eh_wakeup(shost);
+	spin_unlock(shost->host_lock);
+	spin_lock(&sdev->sdev_lock);
+	sdev->device_busy--;
+	spin_unlock_irqrestore(&sdev->sdev_lock, flags);
 }
 
 /*
diff -Nru a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
--- a/drivers/scsi/scsi_priv.h	Thu Jun  5 18:49:12 2003
+++ b/drivers/scsi/scsi_priv.h	Thu Jun  5 18:49:12 2003
@@ -52,10 +52,6 @@
 };
 
 
-/* hosts.c */
-extern void scsi_host_busy_inc(struct Scsi_Host *, Scsi_Device *);
-extern void scsi_host_busy_dec_and_test(struct Scsi_Host *, Scsi_Device *);
-
 /* scsi.c */
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
@@ -77,11 +73,13 @@
 extern void scsi_times_out(struct scsi_cmnd *cmd);
 extern void scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
+extern void scsi_eh_wakeup(struct Scsi_Host *shost);
 extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
 
 /* scsi_lib.c */
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_setup_cmd_retry(struct scsi_cmnd *cmd);
+extern void scsi_device_unbusy(struct scsi_device *sdev);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
 extern void scsi_next_command(struct scsi_cmnd *cmd);
 extern void scsi_run_host_queues(struct Scsi_Host *shost);
