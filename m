From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [PATCH 1/1] limit recovery retries
Date: Mon, 17 Dec 2007 14:11:47 +0100
Message-ID: <200712171411.48173.bs@q-leap.de>
References: <200712171410.28139.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:56876 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbXLQNLt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2007 08:11:49 -0500
Received: from lanczos (lanczos [192.168.55.86])
	by mail.q-leap.de (Postfix) with ESMTP id ADEA0642D
	for <linux-scsi@vger.kernel.org>; Mon, 17 Dec 2007 14:11:48 +0100 (CET)
In-Reply-To: <200712171410.28139.bs@q-leap.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Index: linux-2.6.22/drivers/scsi/scsi_error.c
===================================================================
--- linux-2.6.22.orig/drivers/scsi/scsi_error.c	2007-12-17 13:51:15.000000000 
+0100
+++ linux-2.6.22/drivers/scsi/scsi_error.c	2007-12-17 13:56:25.000000000 +0100
@@ -1444,6 +1444,9 @@ static void scsi_restart_operations(stru
 
 	wake_up(&shost->host_wait);
 
+	/* before starting the queues save the time of recovery */
+	shost->last_recovery = jiffies;
+
 	/*
 	 * finally we need to re-initiate requests that may be pending.  we will
 	 * have had everything blocked while error handling is taking place, and
@@ -1550,6 +1553,30 @@ static void scsi_unjam_host(struct Scsi_
 }
 
 /**
+  * deactivate_host - deactiave all devices.
+  * @shost:	Host for which we are deactivating the devices
+  *
+  */
+static void deactivate_host (struct Scsi_Host *shost)
+{
+	unsigned long flags;
+	LIST_HEAD(eh_work_q);
+	LIST_HEAD(eh_done_q);
+
+	spin_lock_irqsave(shost->host_lock, flags);
+	list_splice_init(&shost->eh_cmd_q, &eh_work_q);
+	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	printk (KERN_WARNING "Too many errors for this scsi host, "
+		"deactivating its devices\n");
+
+	scsi_eh_offline_sdevs (&eh_work_q, &eh_done_q);
+
+	wake_up(&shost->host_wait);
+	scsi_run_host_queues(shost);
+}
+
+/**
  * scsi_error_handler - SCSI error handler thread
  * @data:	Host for which we are running.
  *
@@ -1586,6 +1613,19 @@ int scsi_error_handler(void *data)
 			printk("Error handler scsi_eh_%d waking up\n",
 				shost->host_no));
 
+		if (shost->last_recovery < jiffies + 300 * HZ)
+			shost->n_errors++;
+		else
+			shost->n_errors = 1;
+
+		if (shost->n_errors > 5) {
+			deactivate_host(shost);
+			goto out;
+		}
+
+		printk (KERN_WARNING "Starting device recovery %d\n",
+		        shost->n_errors);
+
 		/*
 		 * We have a host that is failing for some reason.  Figure out
 		 * what we need to do to get it up and online again (if we can).
@@ -1603,6 +1643,8 @@ int scsi_error_handler(void *data)
 		 * restart, we restart any I/O to any other devices on the bus
 		 * which are still online.
 		 */
+
+out:
 		scsi_restart_operations(shost);
 		set_current_state(TASK_INTERRUPTIBLE);
 	}
Index: linux-2.6.22/include/scsi/scsi_host.h
===================================================================
--- linux-2.6.22.orig/include/scsi/scsi_host.h	2007-12-17 13:56:49.000000000 
+0100
+++ linux-2.6.22/include/scsi/scsi_host.h	2007-12-17 13:57:55.000000000 +0100
@@ -518,6 +518,9 @@ struct Scsi_Host {
 	struct task_struct    * ehandler;  /* Error recovery thread. */
 	struct completion     * eh_action; /* Wait for specific actions on the
 					      host. */
+	time_t			last_recovery;  /* last time eh completed */
+	int			n_errors;     /* number failures within
+				                 time limit */
 	wait_queue_head_t       host_wait;
 	struct scsi_host_template *hostt;
 	struct scsi_transport_template *transportt;


-- 
Bernd Schubert
Q-Leap Networks GmbH
