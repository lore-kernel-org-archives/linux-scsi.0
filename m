From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] unexport scsi_add_timer/scsi_delete_timer
Date: Tue, 6 Sep 2005 14:15:37 +0200
Message-ID: <20050906121537.GA22347@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37509 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S964839AbVIFMPk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Sep 2005 08:15:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Index: scsi-misc-2.6/drivers/scsi/scsi_error.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_error.c	2005-09-06 14:25:35.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_error.c	2005-09-06 14:25:36.000000000 +0200
@@ -116,7 +116,6 @@
 
 	add_timer(&scmd->eh_timeout);
 }
-EXPORT_SYMBOL(scsi_add_timer);
 
 /**
  * scsi_delete_timer - Delete/cancel timer for a given function.
@@ -144,7 +143,6 @@
 
 	return rtn;
 }
-EXPORT_SYMBOL(scsi_delete_timer);
 
 /**
  * scsi_times_out - Timeout function for normal scsi commands.
Index: scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt
===================================================================
--- scsi-misc-2.6.orig/Documentation/scsi/scsi_mid_low_api.txt	2005-09-06 14:24:08.000000000 +0200
+++ scsi-misc-2.6/Documentation/scsi/scsi_mid_low_api.txt	2005-09-06 14:25:36.000000000 +0200
@@ -373,13 +373,11 @@
    scsi_activate_tcq - turn on tag command queueing
    scsi_add_device - creates new scsi device (lu) instance
    scsi_add_host - perform sysfs registration and SCSI bus scan.
-   scsi_add_timer - (re-)start timer on a SCSI command.
    scsi_adjust_queue_depth - change the queue depth on a SCSI device
    scsi_assign_lock - replace default host_lock with given lock
    scsi_bios_ptable - return copy of block device's partition table
    scsi_block_requests - prevent further commands being queued to given host
    scsi_deactivate_tcq - turn off tag command queueing
-   scsi_delete_timer - cancel timer on a SCSI command.
    scsi_host_alloc - return a new scsi_host instance whose refcount==1
    scsi_host_get - increments Scsi_Host instance's refcount
    scsi_host_put - decrements Scsi_Host instance's refcount (free if 0)
@@ -458,27 +456,6 @@
 
 
 /**
- * scsi_add_timer - (re-)start timer on a SCSI command.
- * @scmd:    pointer to scsi command instance
- * @timeout: duration of timeout in "jiffies"
- * @complete: pointer to function to call if timeout expires
- *
- *      Returns nothing
- *
- *      Might block: no
- *
- *      Notes: Each scsi command has its own timer, and as it is added
- *      to the queue, we set up the timer. When the command completes, 
- *      we cancel the timer. An LLD can use this function to change
- *      the existing timeout value.
- *
- *      Defined in: drivers/scsi/scsi_error.c
- **/
-void scsi_add_timer(struct scsi_cmnd *scmd, int timeout, 
-                    void (*complete)(struct scsi_cmnd *))
-
-
-/**
  * scsi_adjust_queue_depth - allow LLD to change queue depth on a SCSI device
  * @sdev:       pointer to SCSI device to change queue depth on
  * @tagged:     0 - no tagged queuing
@@ -566,24 +543,6 @@
 
 
 /**
- * scsi_delete_timer - cancel timer on a SCSI command.
- * @scmd:    pointer to scsi command instance
- *
- *      Returns 1 if able to cancel timer else 0 (i.e. too late or already
- *      cancelled).
- *
- *      Might block: no [may in the future if it invokes del_timer_sync()]
- *
- *      Notes: All commands issued by upper levels already have a timeout
- *      associated with them. An LLD can use this function to cancel the
- *      timer.
- *
- *      Defined in: drivers/scsi/scsi_error.c
- **/
-int scsi_delete_timer(struct scsi_cmnd *scmd)
-
-
-/**
  * scsi_host_alloc - create a scsi host adapter instance and perform basic
  *                   initialization.
  * @sht:        pointer to scsi host template
Index: scsi-misc-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_priv.h	2005-09-06 14:24:08.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/scsi_priv.h	2005-09-06 14:25:36.000000000 +0200
@@ -63,6 +63,9 @@
 extern void scsi_exit_devinfo(void);
 
 /* scsi_error.c */
+extern void scsi_add_timer(struct scsi_cmnd *, int,
+		void (*)(struct scsi_cmnd *));
+extern int scsi_delete_timer(struct scsi_cmnd *);
 extern void scsi_times_out(struct scsi_cmnd *cmd);
 extern int scsi_error_handler(void *host);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
Index: scsi-misc-2.6/include/scsi/scsi_eh.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_eh.h	2005-09-06 14:24:08.000000000 +0200
+++ scsi-misc-2.6/include/scsi/scsi_eh.h	2005-09-06 14:25:36.000000000 +0200
@@ -27,9 +27,6 @@
 };
 
 
-extern void scsi_add_timer(struct scsi_cmnd *, int,
-		void (*)(struct scsi_cmnd *));
-extern int scsi_delete_timer(struct scsi_cmnd *);
 extern void scsi_report_bus_reset(struct Scsi_Host *, int);
 extern void scsi_report_device_reset(struct Scsi_Host *, int, int);
 extern int scsi_block_when_processing_errors(struct scsi_device *);
