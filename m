From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] add back single_lun support
Date: Thu, 6 Feb 2003 14:27:54 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206142754.A10377@infradead.org>
References: <20030205145104.A6169@beaverton.ibm.com> <1044486842.1773.89.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1044486842.1773.89.camel@mulgrave>; from James.Bottomley@steeleye.com on Wed, Feb 05, 2003 at 05:14:00PM -0600
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Feb 05, 2003 at 05:14:00PM -0600, James Bottomley wrote:
> I don't see device_active getting set anywhere.

The same is true for host_active, btw..


--- 1.49/drivers/scsi/hosts.c	Tue Feb  4 17:27:21 2003
+++ edited/drivers/scsi/hosts.c	Thu Feb  6 15:01:27 2003
@@ -392,7 +392,6 @@
 
 	spin_lock_init(&shost->default_lock);
 	scsi_assign_lock(shost, &shost->default_lock);
-	atomic_set(&shost->host_active,0);
 	INIT_LIST_HEAD(&shost->my_devices);
 
 	init_waitqueue_head(&shost->host_wait);
===== drivers/scsi/hosts.h 1.51 vs edited =====
--- 1.51/drivers/scsi/hosts.h	Tue Feb  4 17:27:21 2003
+++ edited/drivers/scsi/hosts.h	Thu Feb  6 14:58:38 2003
@@ -396,7 +396,6 @@
     unsigned int            eh_kill:1; /* set when killing the eh thread */
     wait_queue_head_t       host_wait;
     Scsi_Host_Template    * hostt;
-    atomic_t                host_active; /* commands checked out */
     volatile unsigned short host_busy;   /* commands actually active on low-level */
     volatile unsigned short host_failed; /* commands that failed. */
     
===== drivers/scsi/scsi.c 1.87 vs edited =====
--- 1.87/drivers/scsi/scsi.c	Wed Feb  5 17:14:41 2003
+++ edited/drivers/scsi/scsi.c	Thu Feb  6 14:59:16 2003
@@ -994,11 +994,11 @@
 				 * Here we have a fatal error of some sort.
 				 * Turn it over to the error handler.
 				 */
-				SCSI_LOG_MLCOMPLETE(3, printk("Command failed %p %x active=%d busy=%d failed=%d\n",
-						    SCpnt, SCpnt->result,
-				  atomic_read(&SCpnt->device->host->host_active),
-						  SCpnt->device->host->host_busy,
-					      SCpnt->device->host->host_failed));
+				SCSI_LOG_MLCOMPLETE(3,
+					printk("Command failed %p %x busy=%d failed=%d\n",
+						SCpnt, SCpnt->result,
+						SCpnt->device->host->host_busy,
+						SCpnt->device->host->host_failed));
 
 				/*
 				 * Dump the sense information too.
===== drivers/scsi/scsi_error.c 1.29 vs edited =====
--- 1.29/drivers/scsi/scsi_error.c	Tue Jan 28 17:19:34 2003
+++ edited/drivers/scsi/scsi_error.c	Thu Feb  6 15:00:33 2003
@@ -131,23 +131,22 @@
  **/
 void scsi_times_out(Scsi_Cmnd *scmd)
 {
+	struct Scsi_Host *shost = scmd->device->host;
+
 	/* Set the serial_number_at_timeout to the current serial_number */
 	scmd->serial_number_at_timeout = scmd->serial_number;
 
 	scsi_eh_eflags_set(scmd, SCSI_EH_CMD_TIMEOUT | SCSI_EH_CMD_ERR);
 
-	if( scmd->device->host->eh_wait == NULL ) {
+	if (unlikely(shost->eh_wait == NULL)) {
 		panic("Error handler thread not present at %p %p %s %d",
-		      scmd, scmd->device->host, __FILE__, __LINE__);
+		      scmd, shost, __FILE__, __LINE__);
 	}
 
-	scsi_host_failed_inc_and_test(scmd->device->host);
+	scsi_host_failed_inc_and_test(shost);
 
-	SCSI_LOG_TIMEOUT(3, printk("Command timed out active=%d busy=%d "
-				   " failed=%d\n",
-				   atomic_read(&scmd->device->host->host_active),
-				   scmd->device->host->host_busy,
-				   scmd->device->host->host_failed));
+	SCSI_LOG_TIMEOUT(3, printk("Command timed out busy=%d failed=%d\n",
+				   shost->host_busy, shost->host_failed));
 }
 
 /**
--- 1.14/drivers/scsi/scsi_proc.c	Fri Jan  3 19:58:50 2003
+++ edited/drivers/scsi/scsi_proc.c	Thu Feb  6 15:01:02 2003
@@ -345,10 +345,9 @@
 	i = 0;
 	for (shpnt = scsi_host_get_next(NULL); shpnt;
 	     shpnt = scsi_host_get_next(shpnt)) {
-		printk(KERN_INFO " %d %d %d : %d %d\n",
+		printk(KERN_INFO " %d %d : %d %d\n",
 		       shpnt->host_failed,
 		       shpnt->host_busy,
-		       atomic_read(&shpnt->host_active),
 		       shpnt->host_blocked,
 		       shpnt->host_self_blocked);
 	}
