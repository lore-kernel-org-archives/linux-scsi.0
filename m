From: Kenn Humborg <kenn@linux.ie>
Subject: NCR5380 delayed work fix and locking fix
Date: Thu, 24 Feb 2005 23:30:20 +0000
Message-ID: <20050224233020.GA31958@excalibur.research.wombat.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from mail1.mail.iol.ie ([193.120.142.151]:32942 "EHLO
	mail1.mail.iol.ie") by vger.kernel.org with ESMTP id S262561AbVBXX3u
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Feb 2005 18:29:50 -0500
Received: from dialup371.ts001.bmt.esat.net ([193.203.149.115] helo=excalibur.research.wombat.ie)
	by mail1.mail.iol.ie with esmtp (Exim 3.36 #9)
	id 1D4SQW-0003Ul-00
	for linux-scsi@vger.kernel.org; Thu, 24 Feb 2005 23:29:49 +0000
Received: from excalibur.research.wombat.ie (IDENT:NQ8T0XCINlsd52gpb09mLEavbaw48Gfp@excalibur [127.0.0.1])
	by excalibur.research.wombat.ie (8.12.11/8.12.10) with ESMTP id j1ONULqw032195
	for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2005 23:30:21 GMT
Received: (from kenn@localhost)
	by excalibur.research.wombat.ie (8.12.11/8.12.10/Submit) id j1ONULPm032192
	for linux-scsi@vger.kernel.org; Thu, 24 Feb 2005 23:30:21 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Changes to the NCR5380 driver between 2.6.9 and 2.6.10 replaced the
driver's home-grown delayed work implementation with a call to
schedule_delayed_work().  However, the delay argument was not passed
correctly, so the work was usually scheduled for _way_ too far in
the future.  This patch fixes this.

NCR5380_print_status() is called from NCR5380_abort() and from
NCR5380_bus_reset().  In at least the abort() case, the host lock
has already been acquired by scsi_error.c:scsi_try_to_abort_command().
NCR5380_print_status() calls NCR5380_proc_info() which also acquires
and releases the host lock.  This patch removes the call to 
NCR5380_proc_info() from NCR5380_print_status.

Cosmetic: Remove duplicated lines of code from NCR5380_abort().

Signed-off-by: Kenn Humborg <kenn@linux.ie>

--- src/drivers/scsi/NCR5380.c-2.6.10	2005-02-24 23:16:04.243579058 +0000
+++ src/drivers/scsi/NCR5380.c	2005-02-24 23:17:28.093112646 +0000
@@ -530,13 +530,13 @@
 	}
 }
 
 static void NCR5380_set_timer(struct NCR5380_hostdata *hostdata, unsigned long timeout)
 {
 	hostdata->time_expires = jiffies + timeout;
-	schedule_delayed_work(&hostdata->coroutine, hostdata->time_expires);
+	schedule_delayed_work(&hostdata->coroutine, timeout);
 }
 
 
 static int probe_irq __initdata = 0;
 
 /**
@@ -668,22 +668,14 @@
  *
  *	Locks: called functions disable irqs
  */
 
 static void NCR5380_print_status(struct Scsi_Host *instance)
 {
-	static char pr_bfr[512];
-	char *start;
-	int len;
-
 	NCR5380_dprint(NDEBUG_ANY, instance);
 	NCR5380_dprint_phase(NDEBUG_ANY, instance);
-
-	len = NCR5380_proc_info(instance, pr_bfr, &start, 0, sizeof(pr_bfr), 0);
-	pr_bfr[len] = 0;
-	printk("\n%s\n", pr_bfr);
 }
 
 /******************************************/
 /*
  * /proc/scsi/[dtc pas16 t128 generic]/[0-ASC_NUM_BOARD_SUPPORTED]
  *
@@ -2686,17 +2678,12 @@
 	
 	printk(KERN_WARNING "scsi%d : aborting command\n", instance->host_no);
 	print_Scsi_Cmnd(cmd);
 
 	NCR5380_print_status(instance);
 
-	printk(KERN_WARNING "scsi%d : aborting command\n", instance->host_no);
-	print_Scsi_Cmnd(cmd);
-
-	NCR5380_print_status(instance);
-
 	NCR5380_setup(instance);
 
 	dprintk(NDEBUG_ABORT, ("scsi%d : abort called\n", instance->host_no));
 	dprintk(NDEBUG_ABORT, ("        basr 0x%X, sr 0x%X\n", NCR5380_read(BUS_AND_STATUS_REG), NCR5380_read(STATUS_REG)));
 
 #if 0
