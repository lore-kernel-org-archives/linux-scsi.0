From: Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 3/4] 2.4 SCSI error handling fixes
Date: Thu, 12 Sep 2002 19:15:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020912191554.C4739@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from flint.arm.linux.org.uk ([3ffe:8260:2002:1:201:2ff:fe14:8fad])
	by caramon.arm.linux.org.uk with asmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.04)
	id 17pYVQ-0005C3-00
	for linux-scsi@vger.kernel.org; Thu, 12 Sep 2002 19:15:56 +0100
Received: from rmk by flint.arm.linux.org.uk with local (Exim 4.04)
	id 17pYVO-0001LJ-00
	for linux-scsi@vger.kernel.org; Thu, 12 Sep 2002 19:15:54 +0100
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I've been chasing a few SCSI problems today, and here's 4 patches to
address the issues I found.  These patches are against 2.4.19.

My main aim here was to solve the bad behaviour with a medium error.
Some problems were found in my HBA driver, but some were found in
the error handling code.

Problems found were:

a) retrying a command with stale or invalid command information.
   (Patches 1 and 2)
b) reporting the wrong command on IO error.
   (Patch 3)
c) drives behaving badly in error condition, reporting success without
   data transfer.
   (Patch 4)

Results of investigation into these issues can be found at in my lkml
messages at:

  http://marc.theaimsgroup.com/?l=linux-kernel&m=103184937214222&w=2

Patch 4 is the one I'm least happy about; we shouldn't unconditionally
set the FUA bit in READ10 commands.  It seems that we need to set this
bit only after receiving an error, and only when we try to read the
remaining blocks which we believe are good.

Patch 3: when reporting an error, display the ultimate command,
not the last command that was issued.  This is important for HBA
drivers that automatically send REQUEST SENSE to the drive;
reporting that the command was REQUEST SENSE is nonsense.

--- orig/drivers/scsi/scsi_lib.c	Thu Sep 12 18:00:15 2002
+++ linux/drivers/scsi/scsi_lib.c	Thu Sep 12 18:00:40 2002
@@ -750,7 +750,7 @@
 			printk("scsi%d: ERROR on channel %d, id %d, lun %d, CDB: ",
 			       SCpnt->host->host_no, (int) SCpnt->channel,
 			       (int) SCpnt->target, (int) SCpnt->lun);
-			print_command(SCpnt->cmnd);
+			print_command(SCpnt->data_cmnd);
 			print_sense("sd", SCpnt);
 			SCpnt = scsi_end_request(SCpnt, 0, block_sectors);
 			return;

-- 
Russell King (rmk@arm.linux.org.uk)                The developer of ARM Linux
             http://www.arm.linux.org.uk/personal/aboutme.html

