From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH][RFC] kill scsi_dump_status
Date: Sat, 26 Apr 2003 23:35:29 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030426233529.A22904@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:13576 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S263048AbTDZVXS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 17:23:18 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Is someone still using the echo dump > /proc/scsi/scsi feature?  I think
we should kill it as we're getting much nicer output from sysfs these
days..


--- 1.19/drivers/scsi/scsi_proc.c	Wed Apr 23 04:03:43 2003
+++ edited/drivers/scsi/scsi_proc.c	Sat Apr 26 20:46:26 2003
@@ -312,91 +316,6 @@
 	return (len);
 }
 
-#ifdef CONFIG_SCSI_LOGGING
-/*
- * Function:    scsi_dump_status
- *
- * Purpose:     Brain dump of scsi system, used for problem solving.
- *
- * Arguments:   level - used to indicate level of detail.
- *
- * Notes:       The level isn't used at all yet, but we need to find some
- *		way of sensibly logging varying degrees of information.
- *		A quick one-line display of each command, plus the status
- *		would be most useful.
- *
- *              This does depend upon CONFIG_SCSI_LOGGING - I do want some
- *		way of turning it all off if the user wants a lean and mean
- *		kernel.  It would probably also be useful to allow the user
- *		to specify one single host to be dumped.  A second argument
- *		to the function would be useful for that purpose.
- *
- *              FIXME - some formatting of the output into tables would be
- *		        very handy.
- */
-static void scsi_dump_status(int level)
-{
-	int i;
-	struct Scsi_Host *shpnt;
-	Scsi_Cmnd *SCpnt;
-	Scsi_Device *SDpnt;
-	printk(KERN_INFO "Dump of scsi host parameters:\n");
-	i = 0;
-	for (shpnt = scsi_host_get_next(NULL); shpnt;
-	     shpnt = scsi_host_get_next(shpnt)) {
-		printk(KERN_INFO " %d %d : %d %d\n",
-		       shpnt->host_failed,
-		       shpnt->host_busy,
-		       shpnt->host_blocked,
-		       shpnt->host_self_blocked);
-	}
-
-	printk(KERN_INFO "\n\n");
-	printk(KERN_INFO "Dump of scsi command parameters:\n");
-	for (shpnt = scsi_host_get_next(NULL); shpnt;
-	     shpnt = scsi_host_get_next(shpnt)) {
-		printk(KERN_INFO "h:c:t:l (dev sect nsect cnumsec sg) "
-			"(ret all flg) (to/cmd to ito) cmd snse result\n");
-		list_for_each_entry(SDpnt, &shpnt->my_devices, siblings) {
-			unsigned long flags;
-
-			spin_lock_irqsave(&SDpnt->list_lock, flags);
-			list_for_each_entry(SCpnt, &SDpnt->cmd_list, list) {
-				/*  (0) h:c:t:l (dev sect nsect cnumsec sg) (ret all flg) (to/cmd to ito) cmd snse result %d %x      */
-				printk(KERN_INFO "(%3d) %2d:%1d:%2d:%2d (%6s %4llu %4ld %4ld %4x %1d) (%1d %1d 0x%2x) (%4d %4d %4d) 0x%2.2x 0x%2.2x 0x%8.8x\n",
-				       i++,
-
-				       SCpnt->device->host->host_no,
-				       SCpnt->device->channel,
-                                       SCpnt->device->id,
-                                       SCpnt->device->lun,
-
-                                       SCpnt->request->rq_disk ?
-                                       SCpnt->request->rq_disk->disk_name : "?",
-                                       (unsigned long long)SCpnt->request->sector,
-				       SCpnt->request->nr_sectors,
-				       (long)SCpnt->request->current_nr_sectors,
-				       SCpnt->request->rq_status,
-				       SCpnt->use_sg,
-
-				       SCpnt->retries,
-				       SCpnt->allowed,
-				       SCpnt->flags,
-
-				       SCpnt->timeout_per_command,
-				       SCpnt->timeout,
-				       SCpnt->internal_timeout,
-
-				       SCpnt->cmnd[0],
-				       SCpnt->sense_buffer[2],
-				       SCpnt->result);
-			}
-			spin_unlock_irqrestore(&SDpnt->list_lock, flags);
-		}
-	}
-}
-#endif	/* CONFIG_SCSI_LOGGING */ 
-
 static int scsi_add_single_device(uint host, uint channel, uint id, uint lun)
 {
 	struct Scsi_Host *shost;
@@ -470,22 +389,6 @@
 		goto out;
 
 #ifdef CONFIG_SCSI_LOGGING
-	/*
-	 * Usage: echo "scsi dump #N" > /proc/scsi/scsi
-	 * to dump status of all scsi commands.  The number is used to
-	 * specify the level of detail in the dump.
-	 */
-	if (!strncmp("dump", buffer + 5, 4)) {
-		unsigned int level;
-
-		p = buffer + 10;
-
-		if (*p == '\0')
-			goto out;
-
-		level = simple_strtoul(p, NULL, 0);
-		scsi_dump_status(level);
-	}
 	/*
 	 * Usage: echo "scsi log token #N" > /proc/scsi/scsi
 	 * where token is one of [error,scan,mlqueue,mlcomplete,llqueue,
