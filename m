From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH 2.5.31] cli clean up for 53c700
Date: Wed, 14 Aug 2002 09:23:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208141423.g7EEN3402521@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_-2800804480"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA30728
	for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2002 07:23:08 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id HAA30591
	for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2002 07:23:05 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g7EEN3402521
	for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2002 09:23:03 -0500
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multipart MIME message.

--==_Exmh_-2800804480
Content-Type: text/plain; charset=us-ascii

This is a trivial fix to remove the 53c700 driver's reliance on 
cli/restore_flags.

James


--==_Exmh_-2800804480
Content-Type: text/plain ; name="53c700-2.5.31.diff"; charset=us-ascii
Content-Description: 53c700-2.5.31.diff
Content-Disposition: attachment; filename="53c700-2.5.31.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.543   -> 1.544  
#	drivers/scsi/53c700.c	1.11    -> 1.12   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/08/04	jejb@mulgrave.(none)	1.544
# [SCSI 53c700] clean up cli code
# --------------------------------------------
#
diff -Nru a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
--- a/drivers/scsi/53c700.c	Wed Aug 14 09:20:48 2002
+++ b/drivers/scsi/53c700.c	Wed Aug 14 09:20:48 2002
@@ -1360,6 +1360,8 @@
 }
 
 
+/* The queue lock with interrupts disabled must be held on entry to
+ * this function */
 STATIC int
 NCR_700_start_command(Scsi_Cmnd *SCp)
 {
@@ -1367,17 +1369,13 @@
 		(struct NCR_700_command_slot *)SCp->host_scribble;
 	struct NCR_700_Host_Parameters *hostdata =
 		(struct NCR_700_Host_Parameters *)SCp->host->hostdata[0];
-	unsigned long flags;
 	__u16 count = 1;	/* for IDENTIFY message */
 	
-	save_flags(flags);
-	cli();
 	if(hostdata->state != NCR_700_HOST_FREE) {
 		/* keep this inside the lock to close the race window where
 		 * the running command finishes on another CPU while we don't
 		 * change the state to queued on this one */
 		slot->state = NCR_700_SLOT_QUEUED;
-		restore_flags(flags);
 
 		DEBUG(("scsi%d: host busy, queueing command %p, slot %p\n",
 		       SCp->host->host_no, slot->cmnd, slot));
@@ -1443,12 +1441,6 @@
 		       SCp->host, SXFER_REG);
 	NCR_700_writel(slot->temp, SCp->host, TEMP_REG);
 	NCR_700_writel(slot->resume_offset, SCp->host, DSP_REG);
-
-	/* allow interrupts here so that if we're selected we can take
-	 * a selection interrupt.  The script start may not be
-	 * effective in this case, but the selection interrupt will
-	 * save our command in that case */
-	restore_flags(flags);
 
 	return 1;
 }

--==_Exmh_-2800804480--


