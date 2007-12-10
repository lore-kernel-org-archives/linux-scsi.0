From: Bernd Schubert <bs@q-leap.de>
Subject: device error handler
Date: Mon, 10 Dec 2007 21:42:17 +0100
Message-ID: <200712102142.18150.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:37193 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbXLJUmU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Dec 2007 15:42:20 -0500
Received: from lanczos (lanczos [192.168.55.86])
	by mail.q-leap.de (Postfix) with ESMTP id 971CE625E
	for <linux-scsi@vger.kernel.org>; Mon, 10 Dec 2007 21:42:18 +0100 (CET)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

below is my initial attempt to write a device error handler. Unfortunately, it 
still doesn't do what I want.


[  278.750971] sd 5:0:2:0: DID_NO_CONNECT
[  278.754942] sd 5:0:2:0: waiting 10s to settle device
[  278.754947] Buffer I/O error on device sda1, logical block 8552498
[  278.754952] Buffer I/O error on device sda1, logical block 8552499

Once it tells "waiting 10s to settle device" all i/o to the troublesome device 
should be suspended. For that purpose I introduced the SDEV_RECOVERY flag, 
only I still didn't figure out yet where to test for this flag... 
scsi_dispatch_cmd() doesn't seem to be suffient.

I would be greatful for any hints.


Signed-off-by: Bernd Schubert <bs@q-leap.de>


Index: linux-2.6.22/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.22.orig/drivers/scsi/scsi_error.c	2007-12-10 19:58:04.000000000 
+0100
+++ linux-2.6.22/drivers/scsi/scsi_error.c	2007-12-10 21:21:00.000000000 +0100
@@ -1589,6 +1589,125 @@ int scsi_error_handler(void *data)
 	return 0;
 }
 
+/**
+  * scsi_unjam_sdev - try to revover a failed scsi-device
+  * @sdev:	scsi device we are recovering
+  */
+static int scsi_unjam_sdev(struct scsi_device *sdev)
+{
+	int rtn;
+
+	sdev_printk(KERN_CRIT, sdev, "resetting device\n");
+	rtn = scsi_reset_provider(sdev, SCSI_TRY_RESET_DEVICE);
+	if (rtn == SUCCESS)
+		sdev_printk(KERN_INFO, sdev, "device reset succeeded, "
+		            "set device to running state\n");
+	return SUCCESS;
+}
+
+/**
+ * scsi_schedule_deh - schedule EH for SCSI device
+ * @sdev:	SCSI device to invoke error handling on.
+ *
+ **/
+void scsi_schedule_deh(struct scsi_device *sdev)
+{
+#if 0
+	if (sdev->deh.error) {
+		/* blocking the device does not work! another recovery was
+		 * scheduled, though no i/o should go to the device now! */
+		sdev_printk(KERN_CRIT, sdev,
+		            "device already in recovery, but another recovery "
+		            "was scheduled\n");
+		dump_stack();
+	}
+#endif
+
+	if (sdev->deh.error &&  sdev->deh.count == 5
+	&& jiffies < sdev->deh.last_recovery + 60 * HZ) {
+		sdev_printk(KERN_WARNING, sdev,
+		            "too many errors within time limit, setting "
+		            "device offline\n");
+		scsi_device_set_state(sdev, SDEV_OFFLINE);
+		return;
+	} else if (jiffies < sdev->deh.last_recovery + 60 * HZ)
+		sdev->deh.count++;
+	else
+		sdev->deh.count = 1;
+
+	if (scsi_device_set_state(sdev, SDEV_RECOVERY) == 0) {
+		sdev->deh.error = 1;
+		wake_up_process(sdev->deh.ehandler);
+	}
+}
+EXPORT_SYMBOL_GPL(scsi_schedule_deh);
+
+/**
+ * scsi_device_error_handler - SCSI error handler thread
+ * @data:	Device for which we are running.
+ *
+ * Notes:
+ *    This is the main device error handling loop.  This is run as a kernel 
thread
+ *    for every SCSI device and handles all device error handling activity.
+ **/
+int scsi_device_error_handler(void *data)
+{
+	struct scsi_device *sdev = data;
+	int sleeptime = 10;
+
+	current->flags |= PF_NOFREEZE;
+
+	/*
+	 * We use TASK_INTERRUPTIBLE so that the thread is not
+	 * counted against the load average as a running process.
+	 * We never actually get interrupted because kthread_run
+	 * disables singal delivery for the created thread.
+	 */
+	set_current_state(TASK_INTERRUPTIBLE);
+	while (!kthread_should_stop()) {
+		if (sdev->deh.error == 0) {
+			SCSI_LOG_ERROR_RECOVERY(1,
+				printk("Error handler scsi_deh sleeping\n"));
+			schedule();
+			set_current_state(TASK_INTERRUPTIBLE);
+			continue;
+		}
+
+		__set_current_state(TASK_RUNNING);
+		SCSI_LOG_ERROR_RECOVERY(1,
+			printk("Error handler scsi_deh waking up\n"));
+
+		sdev_printk(KERN_CRIT, sdev, "waiting %ds to settle device\n",
+		            sleeptime);
+		msleep (sleeptime * 1000);
+
+		/*
+		 * We have a device that is failing for some reason.  Figure out
+		 * what we need to do to get it up and online again (if we can).
+		 * If we fail, we call host recovery
+		 */
+		if (scsi_unjam_sdev(sdev) != SUCCESS) {
+			sdev_printk(KERN_CRIT, sdev, "device recovery failed,"
+			            " initiating host recovery\n");
+			scsi_schedule_eh(sdev->host);
+			/* scsi_schedule_eh() doesn't know about deh.error */
+			scsi_device_set_state(sdev, SDEV_RUNNING);
+			sdev->deh.error = 0;
+		} else {
+			sdev->deh.error = 0;
+			scsi_device_set_state(sdev, SDEV_RUNNING);
+		}
+
+		sdev->deh.last_recovery = jiffies;
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
+
+	sdev_printk(KERN_CRIT, sdev, "Error handler scsi_deh exiting\n");
+	sdev->deh.ehandler = NULL;
+	return 0;
+}
+
 /*
  * Function:    scsi_report_bus_reset()
  *
Index: linux-2.6.22/include/scsi/scsi_device.h
===================================================================
--- linux-2.6.22.orig/include/scsi/scsi_device.h	2007-12-10 19:58:04.000000000 
+0100
+++ linux-2.6.22/include/scsi/scsi_device.h	2007-12-10 19:58:25.000000000 
+0100
@@ -44,6 +44,7 @@ enum scsi_device_state {
 	SDEV_BLOCK,		/* Device blocked by scsi lld.  No scsi 
 				 * commands from user or midlayer should be issued
 				 * to the scsi lld. */
+	SDEV_RECOVERY		/* Device in revovery, TODO: which command allowd? */
 };
 
 struct scsi_device {
@@ -145,6 +146,13 @@ struct scsi_device {
 
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
+
+	struct device_error_handler {
+		unsigned error;
+		struct task_struct * ehandler;	/* Error recovery thread. */
+		time_t	last_recovery; 		/* time on last error recovery */
+		unsigned count;			/* error count */
+	} deh;
 } __attribute__((aligned(sizeof(unsigned long))));
 #define	to_scsi_device(d)	\
 	container_of(d, struct scsi_device, sdev_gendev)
Index: linux-2.6.22/drivers/scsi/scsi_scan.c
===================================================================
--- linux-2.6.22.orig/drivers/scsi/scsi_scan.c	2007-12-10 19:58:04.000000000 
+0100
+++ linux-2.6.22/drivers/scsi/scsi_scan.c	2007-12-10 20:18:35.000000000 +0100
@@ -1313,6 +1313,12 @@ static int scsi_report_lun_scan(struct s
 			return 0;
 	}
 
+	if (!sdev->deh.ehandler)
+		sdev->deh.ehandler = kthread_run(scsi_device_error_handler,
+		                                 sdev, "sdeh_%d_%d_%d_%d",
+	                                         shost->host_no, sdev->channel,
+	                                         sdev->id, sdev->lun);
+
 	sprintf(devname, "host %d channel %d id %d",
 		shost->host_no, sdev->channel, sdev->id);
 
@@ -1489,8 +1495,13 @@ struct scsi_device *__scsi_add_device(st
 		scsi_probe_and_add_lun(starget, lun, NULL, &sdev, 1, hostdata);
 	mutex_unlock(&shost->scan_mutex);
 	scsi_target_reap(starget);
-	put_device(&starget->dev);
 
+	if (!sdev->deh.ehandler)
+		sdev->deh.ehandler = kthread_run(scsi_device_error_handler,
+		                                 sdev, "sdeh_%d_%d_%d_%d",
+	                                         shost->host_no, sdev->channel,
+	                                         sdev->id, sdev->lun);
+	put_device(&starget->dev);
 	return sdev;
 }
 EXPORT_SYMBOL(__scsi_add_device);
Index: linux-2.6.22/drivers/scsi/scsi_priv.h
===================================================================
--- linux-2.6.22.orig/drivers/scsi/scsi_priv.h	2007-12-10 19:58:04.000000000 
+0100
+++ linux-2.6.22/drivers/scsi/scsi_priv.h	2007-12-10 19:58:25.000000000 +0100
@@ -54,6 +54,7 @@ extern void scsi_add_timer(struct scsi_c
 extern int scsi_delete_timer(struct scsi_cmnd *);
 extern void scsi_times_out(struct scsi_cmnd *cmd);
 extern int scsi_error_handler(void *host);
+extern int scsi_device_error_handler(void *sdev);
 extern int scsi_decide_disposition(struct scsi_cmnd *cmd);
 extern void scsi_eh_wakeup(struct Scsi_Host *shost);
 extern int scsi_eh_scmd_add(struct scsi_cmnd *, int);
Index: linux-2.6.22/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.22.orig/drivers/scsi/scsi_sysfs.c	2007-12-10 19:58:04.000000000 
+0100
+++ linux-2.6.22/drivers/scsi/scsi_sysfs.c	2007-12-10 19:58:25.000000000 +0100
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/device.h>
+#include <linux/kthread.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -31,6 +32,7 @@ static const struct {
 	{ SDEV_QUIESCE, "quiesce" },
 	{ SDEV_OFFLINE,	"offline" },
 	{ SDEV_BLOCK,	"blocked" },
+	{ SDEV_RECOVERY, "recovery" },
 };
 
 const char *scsi_device_state_name(enum scsi_device_state state)
@@ -798,6 +800,9 @@ void __scsi_remove_device(struct scsi_de
 	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
 		return;
 
+	if (sdev->deh.ehandler)
+		kthread_stop(sdev->deh.ehandler);
+
 	class_device_unregister(&sdev->sdev_classdev);
 	transport_remove_device(dev);
 	device_del(dev);
Index: linux-2.6.22/drivers/scsi/scsi_lib.c
===================================================================
--- linux-2.6.22.orig/drivers/scsi/scsi_lib.c	2007-12-10 19:58:04.000000000 
+0100
+++ linux-2.6.22/drivers/scsi/scsi_lib.c	2007-12-10 20:34:24.000000000 +0100
@@ -28,6 +28,7 @@
 
 #include "scsi_priv.h"
 #include "scsi_logging.h"
+#include "scsi_transport_api.h"
 
 
 #define SG_MEMPOOL_NR		ARRAY_SIZE(scsi_sg_pools)
@@ -820,6 +821,7 @@ void scsi_io_completion(struct scsi_cmnd
 	int this_count = cmd->request_bufflen;
 	request_queue_t *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
+	struct scsi_device *sdev = cmd->device;
 	int clear_errors = 1;
 	struct scsi_sense_hdr sshdr;
 	int sense_valid = 0;
@@ -958,13 +960,26 @@ void scsi_io_completion(struct scsi_cmnd
 			break;
 		}
 	}
-	if (host_byte(result) == DID_RESET) {
+	switch (host_byte(result)) {
+	case DID_OK:
+		break;
+	case DID_RESET:
 		/* Third party bus reset or reset for error recovery
 		 * reasons.  Just retry the request and see what
 		 * happens.
 		 */
 		scsi_requeue_command(q, cmd);
 		return;
+	case DID_NO_CONNECT:
+		sdev_printk(KERN_CRIT, sdev, "DID_NO_CONNECT\n");
+		scsi_schedule_deh(sdev);
+		scsi_requeue_command(q, cmd);
+		return;
+	case DID_SOFT_ERROR:
+		sdev_printk(KERN_CRIT, sdev, "DID_SOFT_ERROR\n");
+		scsi_schedule_deh(sdev);
+		scsi_requeue_command(q, cmd);
+		return;
 	}
 	if (result) {
 		if (!(req->cmd_flags & REQ_QUIET)) {
@@ -1945,6 +1960,7 @@ scsi_device_set_state(struct scsi_device
 		case SDEV_OFFLINE:
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
+		case SDEV_RECOVERY:
 			break;
 		default:
 			goto illegal;
@@ -1967,6 +1983,7 @@ scsi_device_set_state(struct scsi_device
 		case SDEV_RUNNING:
 		case SDEV_QUIESCE:
 		case SDEV_BLOCK:
+		case SDEV_RECOVERY:
 			break;
 		default:
 			goto illegal;
@@ -2007,18 +2024,26 @@ scsi_device_set_state(struct scsi_device
 			goto illegal;
 		}
 		break;
+	case SDEV_RECOVERY:
+		switch (oldstate) {
+		case SDEV_RUNNING:
+			break;
+		default:
+			goto illegal;
+		}
 
 	}
 	sdev->sdev_state = state;
 	return 0;
 
  illegal:
-	SCSI_LOG_ERROR_RECOVERY(1, 
+	SCSI_LOG_ERROR_RECOVERY(1,
 				sdev_printk(KERN_ERR, sdev,
 					    "Illegal state transition %s->%s\n",
 					    scsi_device_state_name(oldstate),
 					    scsi_device_state_name(state))
 				);
+	dump_stack();
 	return -EINVAL;
 }
 EXPORT_SYMBOL(scsi_device_set_state);
Index: linux-2.6.22/drivers/scsi/scsi_transport_api.h
===================================================================
--- linux-2.6.22.orig/drivers/scsi/scsi_transport_api.h	2007-12-10 
19:58:04.000000000 +0100
+++ linux-2.6.22/drivers/scsi/scsi_transport_api.h	2007-12-10 
19:58:25.000000000 +0100
@@ -2,5 +2,6 @@
 #define _SCSI_TRANSPORT_API_H
 
 void scsi_schedule_eh(struct Scsi_Host *shost);
+void scsi_schedule_deh(struct scsi_device *sdev);
 
 #endif /* _SCSI_TRANSPORT_API_H */
Index: linux-2.6.22/drivers/scsi/scsi.c
===================================================================
--- linux-2.6.22.orig/drivers/scsi/scsi.c	2007-12-10 19:58:04.000000000 +0100
+++ linux-2.6.22/drivers/scsi/scsi.c	2007-12-10 19:58:25.000000000 +0100
@@ -485,7 +485,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 	}
 
 	/* Check to see if the scsi lld put this device into state SDEV_BLOCK. */
-	if (unlikely(cmd->device->sdev_state == SDEV_BLOCK)) {
+	if (unlikely(cmd->device->sdev_state == SDEV_BLOCK ||
+	             cmd->device->sdev_state == SDEV_RECOVERY)) {
 		/* 
 		 * in SDEV_BLOCK, the command is just put back on the device
 		 * queue.  The suspend state has already blocked the queue so
@@ -494,7 +495,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
 		 */
 		scsi_queue_insert(cmd, SCSI_MLQUEUE_DEVICE_BUSY);
 
-		SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked \n"));
+		SCSI_LOG_MLQUEUE(3, printk("queuecommand : device blocked or "
+		                           "in recovery\n"));
 
 		/*
 		 * NOTE: rtn is still zero here because we don't need the




-- 
Bernd Schubert
Q-Leap Networks GmbH
