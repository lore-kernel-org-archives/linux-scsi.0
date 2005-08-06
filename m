From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] add global timeout to the scsi mid-layer
Date: Fri, 05 Aug 2005 21:45:40 -0500
Message-ID: <1123296340.5437.4.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:61395 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263153AbVHFCpm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2005 22:45:42 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j762jfA23466
	for <linux-scsi@vger.kernel.org>; Fri, 5 Aug 2005 22:45:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

There are certain rogue devices (and the aic7xxx driver) that return
BUSY or QUEUE_FULL forever.  This code will apply a global timeout (of
the total number of retries times the per command timer) to a given
command.  If it is exceeded, the command is completed regardless of its
state.

The patch also removes the unused field in the command: timeout and
timeout_total.

This solves the problem of detecting an endless loop in the mid-layer
because of BUSY/QUEUE_FULL bouncing, but will not recover the device.
In the aic7xxx case, the driver can be recovered by sending a bus reset,
so possibly this should be tied into the error handler?

James

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -9200,8 +9200,8 @@ asc_prt_scsi_cmnd(struct scsi_cmnd *s)
         (unsigned) s->serial_number, s->retries, s->allowed);
 
     printk(
-" timeout_per_command %d, timeout_total %d, timeout %d\n",
-        s->timeout_per_command, s->timeout_total, s->timeout);
+" timeout_per_command %d\n",
+        s->timeout_per_command);
 
     printk(
 " scsi_done 0x%lx, done 0x%lx, host_scribble 0x%lx, result 0x%x\n",
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -268,6 +268,7 @@ struct scsi_cmnd *scsi_get_command(struc
 	} else
 		put_device(&dev->sdev_gendev);
 
+	cmd->jiffies_at_alloc = jiffies;
 	return cmd;
 }				
 EXPORT_SYMBOL(scsi_get_command);
@@ -798,9 +799,23 @@ static void scsi_softirq(struct softirq_
 	while (!list_empty(&local_q)) {
 		struct scsi_cmnd *cmd = list_entry(local_q.next,
 						   struct scsi_cmnd, eh_entry);
+		/* The longest time any command should be outstanding is the
+		 * per command timeout multiplied by the number of retries.
+		 *
+		 * For a typical command, this is 2.5 minutes */
+		unsigned long wait_for 
+			= cmd->allowed * cmd->timeout_per_command;
 		list_del_init(&cmd->eh_entry);
 
 		disposition = scsi_decide_disposition(cmd);
+		if (disposition != SUCCESS &&
+		    time_before(cmd->jiffies_at_alloc + wait_for, jiffies)) {
+			dev_printk(KERN_ERR, &cmd->device->sdev_gendev, 
+				   "timing out command, waited %ds\n",
+				   wait_for/HZ);
+			disposition = SUCCESS;
+		}
+			
 		scsi_log_completion(cmd, disposition);
 		switch (disposition) {
 		case SUCCESS:
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -51,12 +51,16 @@ struct scsi_cmnd {
 	 * printk's to use ->pid, so that we can kill this field.
 	 */
 	unsigned long serial_number;
+	/*
+	 * This is set to jiffies as it was when the command was first
+	 * allocated.  It is used to time how long the command has
+	 * been outstanding
+	 */
+	unsigned long jiffies_at_alloc;
 
 	int retries;
 	int allowed;
 	int timeout_per_command;
-	int timeout_total;
-	int timeout;
 
 	unsigned char cmd_len;
 	unsigned char old_cmd_len;


