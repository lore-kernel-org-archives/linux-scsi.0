From: Matthew Wilcox <willy@debian.org>
Subject: Kill SCSI_BH
Date: Sun, 16 Jun 2002 04:01:11 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020616040111.P9435@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from willy by www.linux.org.uk with local (Exim 3.33 #5)
	id 17JQHv-0006rY-00
	for linux-scsi@vger.kernel.org; Sun, 16 Jun 2002 04:01:11 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I'm not exactly clueful about the linux SCSI layer, but I'd really like
to see old-style bottom halves die before 2.6.  Is there any reason why
SCSI_BH can't simply be comverted to a tasklet?

Andrew Morton kindly tested this patch for me and reports it works fine.
I'd expect the Enterprise people to be thrilled by this as it increases
scalability a touch (eg, SCSI handling is now not serialised against
the serial port).

--- linux-2.5.21/drivers/scsi/scsi.c	Sun Jun  2 18:44:50 2002
+++ linux-2.5.21-flock/drivers/scsi/scsi.c	Sat Jun 15 19:45:45 2002
@@ -1090,6 +1090,9 @@
 	SCSI_LOG_MLQUEUE(3, printk("Leaving scsi_do_cmd()\n"));
 }
 
+void scsi_tasklet_func(unsigned long);
+static DECLARE_TASKLET(scsi_tasklet, scsi_tasklet_func, 0);
+
 /*
  * This function is the mid-level interrupt routine, which decides how
  *  to handle error conditions.  Each invocation of this function must
@@ -1187,7 +1190,7 @@
 	/*
 	 * Mark the bottom half handler to be run.
 	 */
-	mark_bh(SCSI_BH);
+	tasklet_hi_schedule(&scsi_tasklet);
 }
 
 /*
@@ -1213,7 +1216,7 @@
  * half queue.  Thus the only time we hold the lock here is when
  * we wish to atomically remove the contents of the queue.
  */
-void scsi_bottom_half_handler(void)
+void scsi_tasklet_func(unsigned long ignore)
 {
 	Scsi_Cmnd *SCpnt;
 	Scsi_Cmnd *SCnext;
@@ -2545,11 +2548,6 @@
         if (scsihosts)
 		printk(KERN_INFO "scsi: host order: %s\n", scsihosts);	
 	scsi_host_no_init (scsihosts);
-	/*
-	 * This is where the processing takes place for most everything
-	 * when commands are completed.
-	 */
-	init_bh(SCSI_BH, scsi_bottom_half_handler);
 
 	return 0;
 }
@@ -2559,7 +2557,7 @@
 	Scsi_Host_Name *shn, *shn2 = NULL;
 	int i;
 
-	remove_bh(SCSI_BH);
+	tasklet_kill(&scsi_tasklet);
 
         devfs_unregister (scsi_devfs_handle);
         for (shn = scsi_host_no_list;shn;shn = shn->next) {

-- 
Revolutions do not require corporate support.
