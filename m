From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] [v2] aha152x cmnd->device oops
Date: Tue, 28 Oct 2003 16:26:10 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028162610.6dcfd06e.rddunlap@osdl.org>
References: <20031027155713.GA28140@lst.de>
	<20031027160101.76d5291b.rddunlap@osdl.org>
	<20031028090600.GA7370@lst.de>
	<20031028124536.3ce82c23.rddunlap@osdl.org>
	<3F9EF2B4.9030708@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:57496 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261842AbTJ2A2g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 19:28:36 -0500
In-Reply-To: <3F9EF2B4.9030708@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, fischer@norbit.de

On Tue, 28 Oct 2003 14:50:28 -0800 Mike Christie <mikenc@us.ibm.com> wrote:

| Hi Randy,
| 
| >  			if(!(DONE_SC->SCp.Status & not_issued)) {
| > -				Scsi_Cmnd *cmnd = kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC);
| > +				Scsi_Cmnd *cmnd = scsi_get_command(DONE_SC->device, GFP_ATOMIC);
| 
| Do you need to add a scsi_put_command to balance this get when the 
| command completes?
| 
| > +					cmnd->device          = ptr->device;
| 
| Don't even need this now. scsi_get_command will set the device for you.
| 
| Mike

Hers's v3 of the aha152x patch.  However, I'm not satisfied with it,
so I'm not asking James to apply it.  I don't know the state machine
or the hardware well enough to understand and patch it.

Things that I don't like about it:

a.  calling aha152x_internal_queue() with cmnd pointer in 2 places.
    Probably the second one should be NULL.
b.  Easy to confuse the state machine by changing just one variable,
    like DONE_SC (i.e., it's risky and I can't test it, although we
    do have a bug report and can ask that reporter to test it).
c.  int result = SCpnt->SCp.Status; /*FIXME*/
    SCp.Status is not valid here AFAIK, and I don't know how to get
    the current command status at this point.

--
~Randy


description:	aha152x oopses when it references cmnd->device->...
		before cmnd->device has been init, so instead of
		allocating a new scsi_cmnd, just reuse the current
		one for the mode sense;
		then in internal_done(), if the command was a special
		REQUEST_SENSE command, restore the "old" command.
maintainer:	Juergen Fischer <fischer@norbit.de>
product_versions: Linux linux-260-test9-pv
patch_name:	aha152x-cmd-ca.patch
author:		Randy.Dunlap <rddunlap@osdl.org>
patch_version:	2003-10-28.16:17:37

diffstat:=
 drivers/scsi/aha152x.c |   75 +++++++++++++++++++++++++++++--------------------
 1 files changed, 45 insertions(+), 30 deletions(-)

diff -Naurp ./drivers/scsi/aha152x.c~aha152xfix ./drivers/scsi/aha152x.c
--- ./drivers/scsi/aha152x.c~aha152xfix	2003-10-25 11:42:50.000000000 -0700
+++ ./drivers/scsi/aha152x.c	2003-10-28 16:15:24.000000000 -0800
@@ -306,6 +306,8 @@
 
 #define DELAY_DEFAULT 1000
 
+#define AHA15_INTERNAL_SENSE_MAGIC	0x42
+
 #if defined(PCMCIA)
 #define IRQ_MIN 0
 #define IRQ_MAX 16
@@ -1513,6 +1515,21 @@ static void internal_done(Scsi_Cmnd *SCp
 
 	DPRINTK(debug_eh, INFO_LEAD "internal_done called\n", CMDINFO(SCpnt));
 #endif
+	if (SCpnt && SCpnt->cmnd[0] == REQUEST_SENSE && SCpnt->cmnd[6] == AHA15_INTERNAL_SENSE_MAGIC) {
+		int result = SCpnt->SCp.Status; /*FIXME*/
+		/* restore old result if the request sense was successful */
+		if (result == 0)
+			result = SCpnt->cmnd[7];
+		/* now restore the original command */
+		memcpy((void *) SCpnt->cmnd, (void *) SCpnt->data_cmnd,
+		       sizeof(SCpnt->data_cmnd));
+		SCpnt->request_buffer = SCpnt->buffer;
+		SCpnt->request_bufflen = SCpnt->bufflen;
+		SCpnt->use_sg = SCpnt->old_use_sg;
+		SCpnt->cmd_len = SCpnt->old_cmd_len;
+		SCpnt->sc_data_direction = SCpnt->sc_old_data_direction;
+		SCpnt->underflow = SCpnt->old_underflow;
+	}
 	if(SCSEM(SCpnt))
 		up(SCSEM(SCpnt));
 }
@@ -2001,38 +2018,36 @@ static void busfree_run(struct Scsi_Host
 #endif
 
 			if(!(DONE_SC->SCp.Status & not_issued)) {
-				Scsi_Cmnd *cmnd = kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC);
-
-				if(cmnd) {
-					Scsi_Cmnd *ptr=DONE_SC;
-					DONE_SC=0;
-
+				Scsi_Cmnd *cmnd = DONE_SC;
+				int status = DONE_SC->SCp.Status;
+				DONE_SC=0;
 #if 0
-					DPRINTK(debug_eh, ERR_LEAD "requesting sense\n", CMDINFO(ptr));
+				DPRINTK(debug_eh, ERR_LEAD "requesting sense\n",
+						CMDINFO(ptr));
 #endif
-
-					cmnd->cmnd[0]         = REQUEST_SENSE;
-					cmnd->cmnd[1]         = 0;
-					cmnd->cmnd[2]         = 0;
-					cmnd->cmnd[3]         = 0;
-					cmnd->cmnd[4]         = sizeof(ptr->sense_buffer);
-					cmnd->cmnd[5]         = 0;
-					cmnd->cmd_len	      = 6;
-					cmnd->device->host    = ptr->device->host;
-					cmnd->device->id      = ptr->device->id;
-					cmnd->device->lun     = ptr->device->lun;
-					cmnd->use_sg          = 0; 
-					cmnd->request_buffer  = ptr->sense_buffer;
-					cmnd->request_bufflen = sizeof(ptr->sense_buffer);
-			
-					DO_UNLOCK(flags);
-					aha152x_internal_queue(cmnd, 0, 0, ptr, internal_done);
-					DO_LOCK(flags);
-				} else {
-					printk(ERR_LEAD "allocation failed\n", CMDINFO(CURRENT_SC));
-					if(cmnd)
-						kfree(cmnd);
-				}
+				cmnd->cmnd[0] = REQUEST_SENSE;
+				cmnd->cmnd[1] = 0;
+				cmnd->cmnd[2] = 0;
+				cmnd->cmnd[3] = 0;
+				cmnd->cmnd[4] = sizeof(cmnd->sense_buffer);
+				cmnd->cmnd[5] = 0;
+				cmnd->cmd_len = 6;
+				/* Here's a quiet hack [from 53c700.c]: the
+				 * REQUEST_SENSE command is six bytes,
+				 * so store a flag indicating that
+				 * this was an internal sense request
+				 * and the original status at the end
+				 * of the command */
+				cmnd->cmnd[6] = AHA15_INTERNAL_SENSE_MAGIC;
+				cmnd->cmnd[7] = status;
+				cmnd->use_sg  = 0; 
+				cmnd->sc_data_direction = SCSI_DATA_READ;
+				cmnd->request_buffer  = cmnd->sense_buffer;
+				cmnd->request_bufflen = sizeof(cmnd->sense_buffer);
+
+				DO_UNLOCK(flags);
+				aha152x_internal_queue(cmnd, 0, 0, cmnd, internal_done);
+				DO_LOCK(flags);
 			} else {
 #if 0
 				DPRINTK(debug_eh, ERR_LEAD "command not issued - CHECK CONDITION ignored\n", CMDINFO(DONE_SC));
