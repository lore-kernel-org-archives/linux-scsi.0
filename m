From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update NCR5380 comments
Date: Sun, 29 Aug 2004 02:11:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040829001156.GB21743@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:3238 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267438AbUH2AL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 20:11:59 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.27/drivers/scsi/NCR5380.c	2004-08-25 01:42:28 +02:00
+++ edited/drivers/scsi/NCR5380.c	2004-08-29 00:10:12 +02:00
@@ -113,32 +113,18 @@
 
 /*
  * Design
- * Issues :
  *
- * The other Linux SCSI drivers were written when Linux was Intel PC-only,
- * and specifically for each board rather than each chip.  This makes their
- * adaptation to platforms like the Mac (Some of which use NCR5380's)
- * more difficult than it has to be.
- *
- * Also, many of the SCSI drivers were written before the command queuing
- * routines were implemented, meaning their implementations of queued 
- * commands were hacked on rather than designed in from the start.
- *
- * When I designed the Linux SCSI drivers I figured that 
- * while having two different SCSI boards in a system might be useful
- * for debugging things, two of the same type wouldn't be used.
- * Well, I was wrong and a number of users have mailed me about running
- * multiple high-performance SCSI boards in a server.
- *
- * Finally, when I get questions from users, I have no idea what 
- * revision of my driver they are running.
- *
- * This driver attempts to address these problems :
  * This is a generic 5380 driver.  To use it on a different platform, 
  * one simply writes appropriate system specific macros (ie, data
  * transfer - some PC's will use the I/O bus, 68K's must use 
  * memory mapped) and drops this file in their 'C' wrapper.
  *
+ * (Note from hch:  unfortunately it was not enough for the different
+ * m68k folks and instead of improving this driver they copied it
+ * and hacked it up for their needs.  As a consequence they lost
+ * most updates to this driver.  Maybe someone will fix all these
+ * drivers to use a common core one day..)
+ *
  * As far as command queueing, two queues are maintained for 
  * each 5380 in the system - commands that haven't been issued yet,
  * and commands that are currently executing.  This means that an 
@@ -148,17 +134,6 @@
  * allowing multiple commands to propagate all the way to a SCSI-II device 
  * while a command is already executing.
  *
- * To solve the multiple-boards-in-the-same-system problem, 
- * there is a separate instance structure for each instance
- * of a 5380 in the system.  So, multiple NCR5380 drivers will
- * be able to coexist with appropriate changes to the high level
- * SCSI code.  
- *
- * A NCR5380_PUBLIC_REVISION macro is provided, with the release
- * number (updated for each public release) printed by the 
- * NCR5380_print_options command, which should be called from the 
- * wrapper detect function, so that I know what release of the driver
- * users are using.
  *
  * Issues specific to the NCR5380 : 
  *
@@ -183,11 +158,10 @@
  * Architecture :
  *
  * At the heart of the design is a coroutine, NCR5380_main,
- * which is started when not running by the interrupt handler,
- * timer, and queue command function.  It attempts to establish
- * I_T_L or I_T_L_Q nexuses by removing the commands from the 
- * issue queue and calling NCR5380_select() if a nexus 
- * is not established. 
+ * which is started from a workqueue for each NCR5380 host in the
+ * system.  It attempts to establish I_T_L or I_T_L_Q nexuses by
+ * removing the commands from the issue queue and calling
+ * NCR5380_select() if a nexus is not established. 
  *
  * Once a nexus is established, the NCR5380_information_transfer()
  * phase goes through the various phases as instructed by the target.
@@ -289,27 +263,12 @@
  * NCR5380_pwrite(instance, src, count)
  * NCR5380_pread(instance, dst, count);
  *
- * If nothing specific to this implementation needs doing (ie, with external
- * hardware), you must also define 
- *  
- * NCR5380_queue_command
- * NCR5380_reset
- * NCR5380_abort
- * NCR5380_proc_info
- *
- * to be the global entry points into the specific driver, ie 
- * #define NCR5380_queue_command t128_queue_command.
- *
- * If this is not done, the routines will be defined as static functions
- * with the NCR5380* names and the user must provide a globally
- * accessible wrapper function.
- *
  * The generic driver is initialized by calling NCR5380_init(instance),
  * after setting the appropriate host specific fields and ID.  If the 
  * driver wishes to autoprobe for an IRQ line, the NCR5380_probe_irq(instance,
- * possible) function may be used.  Before the specific driver initialization
- * code finishes, NCR5380_print_options should be called.
+ * possible) function may be used.
  */
+
 static int do_abort(struct Scsi_Host *host);
 static void do_reset(struct Scsi_Host *host);
 
