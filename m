From: Andi Kleen <ak@suse.de>
Subject: [PATCH] Fix selection of command serial numbers and pids
Date: Sun, 6 Feb 2005 20:41:23 +0100
Message-ID: <20050206194123.GF18245@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mail-ex.suse.de ([195.135.220.2]:2776 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S261288AbVBFTl3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Feb 2005 14:41:29 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org


This patch fixes one of Christroph's fixme comments in the SCSI midlayer.

The selection of the serial number and pid for commands was done
by a global variable and not SMP safe. The race was not very
serious because it was only used for error handling, but it's
still better to fix it.

I audited all the drivers and none seemed to use them 
for anything interesting, so I just made it a per host counter
protected by host lock.

(in fact they could be probably removed because they only see
to be used as a flag in exception handling and for debugging.
The patch would be unfortunately quite big because a lot
of driver printks use them) 

This should be slight faster on SMP too because the cache line of
the counter won't bounce around the machine. 

Signed-off-by: Andi Kleen <ak@suse.de>

diff -u linux-2.6.11rc3/drivers/scsi/scsi.c-SCSISER linux-2.6.11rc3/drivers/scsi/scsi.c
--- linux-2.6.11rc3/drivers/scsi/scsi.c-SCSISER	2005-02-04 09:13:14.000000000 +0100
+++ linux-2.6.11rc3/drivers/scsi/scsi.c	2005-02-05 12:02:50.000000000 +0100
@@ -88,12 +88,6 @@
 				COMMAND_SIZE((cmd)->cmnd[0]) : (cmd)->cmd_len)
 
 /*
- * Data declarations.
- */
-unsigned long scsi_pid;
-static unsigned long serial_number;
-
-/*
  * Note - the initial logging level can be set here to log events at boot time.
  * After the system is up, you may enable logging via the /proc interface.
  */
@@ -510,6 +504,21 @@
 }
 #endif
 
+/* 
+ * Assign a serial number and pid to the request for error recovery
+ * and debugging purposes.  Protected by the Host_Lock of host.
+ */
+static void scsi_cmd_get_serial(struct Scsi_Host *host, struct scsi_cmnd *cmd)
+{
+	cmd->serial_number = host->cmd_serial_number++;
+	if (cmd->serial_number == 0) 
+		cmd->serial_number = host->cmd_serial_number++;
+	
+	cmd->pid = host->cmd_pid++;
+	if (cmd->pid == 0)
+		cmd->pid = host->cmd_pid++;
+}
+
 /*
  * Function:    scsi_dispatch_command
  *
@@ -556,13 +565,6 @@
 		goto out;
 	}
 
-	/* Assign a unique nonzero serial_number. */
-	/* XXX(hch): this is racy */
-	if (++serial_number == 0)
-		serial_number = 1;
-	cmd->serial_number = serial_number;
-	cmd->pid = scsi_pid++;
-
 	/* 
 	 * If SCSI-2 or lower, store the LUN value in cmnd.
 	 */
@@ -593,6 +595,10 @@
 		host->resetting = 0;
 	}
 
+	/* 
+	 * AK: unlikely race here: for some reason the timer could
+	 * expire before the serial number is set up below.
+	 */
 	scsi_add_timer(cmd, cmd->timeout_per_command, scsi_times_out);
 
 	scsi_log_send(cmd);
@@ -619,6 +625,8 @@
 	}
 
 	spin_lock_irqsave(host->host_lock, flags);
+	scsi_cmd_get_serial(host, cmd); 
+
 	if (unlikely(test_bit(SHOST_CANCEL, &host->shost_state))) {
 		cmd->result = (DID_NO_CONNECT << 16);
 		scsi_done(cmd);
diff -u linux-2.6.11rc3/include/scsi/scsi_cmnd.h-SCSISER linux-2.6.11rc3/include/scsi/scsi_cmnd.h
--- linux-2.6.11rc3/include/scsi/scsi_cmnd.h-SCSISER	2004-05-10 09:44:25.000000000 +0200
+++ linux-2.6.11rc3/include/scsi/scsi_cmnd.h	2005-02-05 09:28:31.000000000 +0100
@@ -54,6 +54,7 @@
 	 * completed and the SCSI Command structure has already being reused
 	 * for another command, so that we can avoid incorrectly aborting or
 	 * resetting the new command.
+	 * The serial number is only unique per host.
 	 */
 	unsigned long serial_number;
 	unsigned long serial_number_at_timeout;
@@ -139,7 +140,7 @@
 	int result;		/* Status code from lower level driver */
 
 	unsigned char tag;	/* SCSI-II queued command tag */
-	unsigned long pid;	/* Process ID, starts at 0 */
+	unsigned long pid;	/* Process ID, starts at 0. Unique per host. */
 };
 
 /*
diff -u linux-2.6.11rc3/include/scsi/scsi_host.h-SCSISER linux-2.6.11rc3/include/scsi/scsi_host.h
--- linux-2.6.11rc3/include/scsi/scsi_host.h-SCSISER	2005-02-04 09:13:50.000000000 +0100
+++ linux-2.6.11rc3/include/scsi/scsi_host.h	2005-02-05 12:02:17.000000000 +0100
@@ -468,7 +468,7 @@
 
 	/*
 	 * The maximum length of SCSI commands that this host can accept.
-	 * Probably 12 for most host adapters, but could be 16 for others.
+	 * Probably 12 for most host adaptersm , but could be 16 for others.
 	 * For drivers that don't set this field, a value of 12 is
 	 * assumed.  I am leaving this as a number rather than a bit
 	 * because you never know what subsequent SCSI standards might do
@@ -483,7 +483,12 @@
 	short unsigned int sg_tablesize;
 	short unsigned int max_sectors;
 	unsigned long dma_boundary;
-
+	/* 
+	 * Used to assign serial numbers to the cmds.
+	 * Protected by the host lock.
+	 */
+	unsigned long cmd_serial_number, cmd_pid; 
+	
 	unsigned unchecked_isa_dma:1;
 	unsigned use_clustering:1;
 	unsigned use_blk_tcq:1;
