From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi_eh_flush_done_q return status
Date: Fri, 16 Jan 2004 12:11:17 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116201117.GD1053@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:8610 "EHLO e35.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S265859AbUAPUGL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 15:06:11 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ishii.hironobu@jp.fujitsu.com

This is a refresh of a patch for a previously reported problem with the
scsi_eh_flush_done_q. The original thread is located here:

http://marc.theaimsgroup.com/?l=linux-scsi&m=107043398314649&w=2

This patch has a one line difference than the one previously posted in
response to the thread. In the previous patch I was unconditionally
setting result in the finish case.

I verified the patch using scsi_debug + gov, but could only cover the
retry path of the patch. I ran out of time to tweak scsi_debug to give
me the right failure signature. If Hironobu has some free time may be
the patch could be verified on the original failing system.

-andmike
--
Michael Anderson
andmike@us.ibm.com

DESC
This patch fixes a bug in scsi_eh_flush_done_q when the allowed count has
been exceeded and the command errored for a timeout. The bug is that the
result will be left at zero and the command finished.

author: Mike Anderson <andmike@us.ibm.com>
patch_version: Thu Jan 15 20:27:10 UTC 2004
EDESC


 patched-scsi-misc-2.7-andmike/drivers/scsi/scsi_error.c |   28 +++++++---------
 1 files changed, 13 insertions(+), 15 deletions(-)

diff -puN drivers/scsi/scsi_error.c~scsi_error_retry drivers/scsi/scsi_error.c
--- patched-scsi-misc-2.7/drivers/scsi/scsi_error.c~scsi_error_retry	Thu Jan 15 22:14:40 2004
+++ patched-scsi-misc-2.7-andmike/drivers/scsi/scsi_error.c	Thu Jan 15 22:14:40 2004
@@ -1420,23 +1420,21 @@ static void scsi_eh_flush_done_q(struct 
 	list_for_each_safe(lh, lh_sf, done_q) {
 		scmd = list_entry(lh, struct scsi_cmnd, eh_entry);
 		list_del_init(lh);
-		if (!scmd->device->online) {
-			 scmd->result |= (DRIVER_TIMEOUT << 24);
-		} else {
-			if (++scmd->retries < scmd->allowed) {
-				SCSI_LOG_ERROR_RECOVERY(3,
-					printk("%s: flush retry"
-					       " cmd: %p\n",
-						  current->comm,
-						  scmd));
+		if (scmd->device->online &&
+		    	(++scmd->retries < scmd->allowed)) {
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush"
+							  " retry cmd: %p\n",
+							  current->comm,
+							  scmd));
 				scsi_queue_insert(scmd, SCSI_MLQUEUE_EH_RETRY);
-				continue;
-			}
+		} else {
+			if (!scmd->result)
+				scmd->result |= (DRIVER_TIMEOUT << 24);
+			SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
+							" cmd: %p\n",
+							current->comm, scmd));
+			scsi_finish_command(scmd);
 		}
-		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: flush finish"
-				       " cmd: %p\n",
-					  current->comm, scmd));
-		scsi_finish_command(scmd);
 	}
 }
 

_

