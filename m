From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: possible use-after-free in 2.5.44 scsi changes
Date: Sat, 26 Oct 2002 19:50:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210270050.g9R0oQe04795@localhost.localdomain>
References: <axboe@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed ;
	boundary="==_Exmh_19752686880"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id RAA06869
	for <linux-scsi@vger.kernel.org>; Sat, 26 Oct 2002 17:50:37 -0700
In-Reply-To: Message from Jens Axboe <axboe@suse.de>
   of "Sat, 26 Oct 2002 11:29:43 +0200." <20021026092943.GB14976@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Badari Pulavarty <pbadari@us.ibm.com>, Andrew Morton <akpm@digeo.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin J. Bligh" <Martin.Bligh@us.ibm.com>, Doug Ledford <dledford@redhat.com>

This is a multipart MIME message.

--==_Exmh_19752686880
Content-Type: text/plain; charset=us-ascii

axboe@suse.de said:
> Irk no, you cannot just clear valid information! This is _not_ a fix,
> it's a hack.

> Use a different flag, or maybe use REQ_DONTPREP or similar. 

OK, what about this.  It uses REQ_DONTPREP, and could be a precursor to moving 
the SCSI subsystem to using the request prep function.

James


--==_Exmh_19752686880
Content-Type: text/plain ; name="tmp.diff"; charset=us-ascii
Content-Description: tmp.diff
Content-Disposition: attachment; filename="tmp.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.823   -> 1.824  
#	 drivers/scsi/scsi.h	1.30    -> 1.31   
#	drivers/scsi/scsi_lib.c	1.36    -> 1.37   
#	 drivers/scsi/scsi.c	1.50    -> 1.51   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 02/10/26	jejb@mulgrave.(none)	1.824
# [SCSI] fix memory etc. leak caused by double preparing requeued commands
# --------------------------------------------
#
diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Sat Oct 26 19:46:01 2002
+++ b/drivers/scsi/scsi.c	Sat Oct 26 19:46:01 2002
@@ -658,7 +658,7 @@
  * Notes:       This could be called either from an interrupt context or a
  *              normal process context.
  */
-static int scsi_mlqueue_insert(Scsi_Cmnd * cmd, int reason)
+int scsi_mlqueue_insert(Scsi_Cmnd * cmd, int reason)
 {
 	struct Scsi_Host *host = cmd->host;
 	unsigned long flags;
diff -Nru a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
--- a/drivers/scsi/scsi.h	Sat Oct 26 19:46:01 2002
+++ b/drivers/scsi/scsi.h	Sat Oct 26 19:46:01 2002
@@ -480,6 +480,7 @@
 			void (*done) (struct scsi_cmnd *),
 			int timeout, int retries);
 extern int scsi_dev_init(void);
+extern int scsi_mlqueue_insert(struct scsi_cmnd *, int);
 
 /*
  * Newer request-based interfaces.
diff -Nru a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c	Sat Oct 26 19:46:01 2002
+++ b/drivers/scsi/scsi_lib.c	Sat Oct 26 19:46:01 2002
@@ -1005,7 +1005,8 @@
 		req = NULL;
 		spin_unlock_irq(q->queue_lock);
 
-		if (SCpnt->request->flags & (REQ_CMD | REQ_BLOCK_PC)) {
+		if (!(SCpnt->request->flags & REQ_DONTPREP)
+		    && (SCpnt->request->flags & (REQ_CMD | REQ_BLOCK_PC))) {
 			/*
 			 * This will do a couple of things:
 			 *  1) Fill in the actual SCSI command.
@@ -1026,18 +1027,8 @@
 			 * required).
 			 */
 			if (!scsi_init_io(SCpnt)) {
+				scsi_mlqueue_insert(SCpnt, SCSI_MLQUEUE_DEVICE_BUSY);
 				spin_lock_irq(q->queue_lock);
-				SHpnt->host_busy--;
-				SDpnt->device_busy--;
-				if (SDpnt->device_busy == 0) {
-					SDpnt->starved = 1;
-					SHpnt->some_device_starved = 1;
-				}
-				SCpnt->request->special = SCpnt;
-				SCpnt->request->flags |= REQ_SPECIAL;
-				if(blk_rq_tagged(SCpnt->request))
-					blk_queue_end_tag(q, SCpnt->request);
-				_elv_add_request(q, SCpnt->request, 0, 0);
 				break;
 			}
 
@@ -1058,6 +1049,7 @@
 				continue;
 			}
 		}
+		SCpnt->request->flags |= REQ_DONTPREP;
 		/*
 		 * Finally, initialize any error handling parameters, and set up
 		 * the timers for timeouts.

--==_Exmh_19752686880--


