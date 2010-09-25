From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [RFC/PATCH] Re: scsi.h: please rename the status_byte() macro
Date: Fri, 24 Sep 2010 18:17:40 -0700
Message-ID: <20100924181740.6105a694.randy.dunlap@oracle.com>
References: <4C912F14.8000706@interlog.com>
	<4C92821D.1000903@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:43626 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab0IYBTW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Sep 2010 21:19:22 -0400
In-Reply-To: <4C92821D.1000903@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 16 Sep 2010 16:46:21 -0400 Douglas Gilbert wrote:

> On 10-09-15 04:39 PM, Douglas Gilbert wrote:
> > ... to something like:
> > scsi_status_byte_div2()
> > or:
> > scsi_broken_status_byte()

There are many names that could be chosen for the new macro.
I don't particularly like the ones above.  How about something
simple, like status_value() or status_bits()?

> The bug in the bsg driver with its SCSI status byte
> brought this to my attention. If memory serves about
> 10 years ago some of us tried to kill the status_byte()
> macro.
> 
> But it is still there in the kernel's scsi/scsi.h
> ready to trip up another generation of programmers:
> #define status_byte(result) (((result) >> 1) & 0x7f)
> 
> with no explanation that it does NOT yield the SCSI
> status byte but the right shifted (once) equivalent.
> 
> The correct macro (or inline function) for obtaining the
> SCSI status byte from the 32 bit "result" from a LLD would
> be:
> #define scsi_status_byte(result) ((result) & 0xff)
> 
> [Long ago (20 years) something silly was put in bit 0
>   so masking with 0xfe would work as well.]
> 
> Another thought, these macros are associated with the
> mid-level or a ULD deciding whether a SCSI command has
> succeeded; so scsi_cmnd.h would be a more appropriate
> header.

It makes sense to me to leave it where it is, along with
msg_byte(), host_byte(), and driver_byte().

> Happily the version of scsi.h shown to the user space
> (typically /usr/include/scsi/scsi.h) does not include
> these defective macros. So any API breakage is limited
> to the kernel.

Anyway, here is a cut at it.  (patch is against linux-next)

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Rename the misnamed status_byte() macro to status_bits()
and convert all users of it.
Retain the former macro as status_full_byte(), although it
has no users for now, so it could just go away.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 block/bsg.c                  |    2 +-
 block/scsi_ioctl.c           |    2 +-
 drivers/scsi/53c700.c        |    6 +++---
 drivers/scsi/NCR5380.c       |    4 ++--
 drivers/scsi/advansys.c      |    4 ++--
 drivers/scsi/aic7xxx_old.c   |    2 +-
 drivers/scsi/arm/acornscsi.c |    2 +-
 drivers/scsi/arm/fas216.c    |    6 +++---
 drivers/scsi/atari_NCR5380.c |    6 +++---
 drivers/scsi/dc395x.c        |    8 ++++----
 drivers/scsi/eata.c          |    2 +-
 drivers/scsi/scsi.c          |    2 +-
 drivers/scsi/scsi_error.c    |   10 +++++-----
 drivers/scsi/sg.c            |    2 +-
 drivers/scsi/sun3_NCR5380.c  |    6 +++---
 drivers/scsi/u14-34f.c       |    2 +-
 include/scsi/scsi.h          |    3 ++-
 17 files changed, 35 insertions(+), 34 deletions(-)

--- linux-next-20100924.orig/include/scsi/scsi.h
+++ linux-next-20100924/include/scsi/scsi.h
@@ -451,7 +451,8 @@ static inline int scsi_is_wlun(unsigned 
  *      host_byte   = set by low-level driver to indicate status.
  *      driver_byte = set by mid-level.
  */
-#define status_byte(result) (((result) >> 1) & 0x7f)
+#define status_full_byte(result) ((result) & 0xff)
+#define status_bits(result) (((result) >> 1) & 0x7f)
 #define msg_byte(result)    (((result) >> 8) & 0xff)
 #define host_byte(result)   (((result) >> 16) & 0xff)
 #define driver_byte(result) (((result) >> 24) & 0xff)
--- linux-next-20100924.orig/block/bsg.c
+++ linux-next-20100924/block/bsg.c
@@ -425,7 +425,7 @@ static int blk_complete_sgv4_hdr_rq(stru
 	/*
 	 * fill in all the output members
 	 */
-	hdr->device_status = status_byte(rq->errors);
+	hdr->device_status = status_bits(rq->errors);
 	hdr->transport_status = host_byte(rq->errors);
 	hdr->driver_status = driver_byte(rq->errors);
 	hdr->info = 0;
--- linux-next-20100924.orig/block/scsi_ioctl.c
+++ linux-next-20100924/block/scsi_ioctl.c
@@ -253,7 +253,7 @@ static int blk_complete_sghdr_rq(struct 
 	 * fill in all the output members
 	 */
 	hdr->status = rq->errors & 0xff;
-	hdr->masked_status = status_byte(rq->errors);
+	hdr->masked_status = status_bits(rq->errors);
 	hdr->msg_status = msg_byte(rq->errors);
 	hdr->host_status = host_byte(rq->errors);
 	hdr->driver_status = driver_byte(rq->errors);
--- linux-next-20100924.orig/drivers/scsi/arm/acornscsi.c
+++ linux-next-20100924/drivers/scsi/arm/acornscsi.c
@@ -852,7 +852,7 @@ static void acornscsi_done(AS_Host *host
 			xfer_warn = 0;
 
 		if (xfer_warn) {
-		    switch (status_byte(SCpnt->result)) {
+		    switch (status_bits(SCpnt->result)) {
 		    case CHECK_CONDITION:
 		    case COMMAND_TERMINATED:
 		    case BUSY:
--- linux-next-20100924.orig/drivers/scsi/arm/fas216.c
+++ linux-next-20100924/drivers/scsi/arm/fas216.c
@@ -2052,15 +2052,15 @@ fas216_std_done(FAS216_Info *info, struc
 	 * If the command returned CHECK_CONDITION or COMMAND_TERMINATED
 	 * status, request the sense information.
 	 */
-	if (status_byte(SCpnt->result) == CHECK_CONDITION ||
-	    status_byte(SCpnt->result) == COMMAND_TERMINATED)
+	if (status_bits(SCpnt->result) == CHECK_CONDITION ||
+	    status_bits(SCpnt->result) == COMMAND_TERMINATED)
 		goto request_sense;
 
 	/*
 	 * If the command did not complete with GOOD status,
 	 * we are all done here.
 	 */
-	if (status_byte(SCpnt->result) != GOOD)
+	if (status_bits(SCpnt->result) != GOOD)
 		goto done;
 
 	/*
--- linux-next-20100924.orig/drivers/scsi/atari_NCR5380.c
+++ linux-next-20100924/drivers/scsi/atari_NCR5380.c
@@ -2188,7 +2188,7 @@ static void NCR5380_information_transfer
 						  "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef SUPPORT_TAGS
 					cmd_free_tag(cmd);
-					if (status_byte(cmd->SCp.Status) == QUEUE_FULL) {
+					if (status_bits(cmd->SCp.Status) == QUEUE_FULL) {
 						/* Turn a QUEUE FULL status into BUSY, I think the
 						 * mid level cannot handle QUEUE FULL :-( (The
 						 * command is retried after BUSY). Also update our
@@ -2229,7 +2229,7 @@ static void NCR5380_information_transfer
 
 					if (cmd->cmnd[0] != REQUEST_SENSE)
 						cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					else if (status_byte(cmd->SCp.Status) != GOOD)
+					else if (status_bits(cmd->SCp.Status) != GOOD)
 						cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
 
 #ifdef AUTOSENSE
@@ -2240,7 +2240,7 @@ static void NCR5380_information_transfer
 					}
 
 					if ((cmd->cmnd[0] != REQUEST_SENSE) &&
-					    (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
+					    (status_bits(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
 						ASEN_PRINTK("scsi%d: performing request sense\n", HOSTNO);
--- linux-next-20100924.orig/drivers/scsi/sun3_NCR5380.c
+++ linux-next-20100924/drivers/scsi/sun3_NCR5380.c
@@ -2209,7 +2209,7 @@ static void NCR5380_information_transfer
 			      "completed\n", HOSTNO, cmd->device->id, cmd->device->lun);
 #ifdef SUPPORT_TAGS
 		    cmd_free_tag( cmd );
-		    if (status_byte(cmd->SCp.Status) == QUEUE_FULL) {
+		    if (status_bits(cmd->SCp.Status) == QUEUE_FULL) {
 			/* Turn a QUEUE FULL status into BUSY, I think the
 			 * mid level cannot handle QUEUE FULL :-( (The
 			 * command is retried after BUSY). Also update our
@@ -2250,7 +2250,7 @@ static void NCR5380_information_transfer
 
 		    if (cmd->cmnd[0] != REQUEST_SENSE) 
 			cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8); 
-		    else if (status_byte(cmd->SCp.Status) != GOOD)
+		    else if (status_bits(cmd->SCp.Status) != GOOD)
 			cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
 		    
 #ifdef AUTOSENSE
@@ -2261,7 +2261,7 @@ static void NCR5380_information_transfer
 		    }
 
 		    if ((cmd->cmnd[0] != REQUEST_SENSE) && 
-			(status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
+			(status_bits(cmd->SCp.Status) == CHECK_CONDITION)) {
 			scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 			ASEN_PRINTK("scsi%d: performing request sense\n",
 				    HOSTNO);
--- linux-next-20100924.orig/drivers/scsi/dc395x.c
+++ linux-next-20100924/drivers/scsi/dc395x.c
@@ -3403,10 +3403,10 @@ static void srb_done(struct AdapterCtlBl
 		/*
 		 * target status..........................
 		 */
-		if (status_byte(status) == CHECK_CONDITION) {
+		if (status_bits(status) == CHECK_CONDITION) {
 			request_sense(acb, dcb, srb);
 			return;
-		} else if (status_byte(status) == QUEUE_FULL) {
+		} else if (status_bits(status) == QUEUE_FULL) {
 			tempcnt = (u8)list_size(&dcb->srb_going_list);
 			dprintkl(KERN_INFO, "QUEUE_FULL for dev <%02i-%i> with %i cmnds\n",
 			     dcb->target_id, dcb->target_lun, tempcnt);
@@ -3475,9 +3475,9 @@ static void srb_done(struct AdapterCtlBl
 			dcb->inquiry7 = ptr->Flags;
 
 	/*if( srb->cmd->cmnd[0] == INQUIRY && */
-	/*  (host_byte(cmd->result) == DID_OK || status_byte(cmd->result) & CHECK_CONDITION) ) */
+	/*  (host_byte(cmd->result) == DID_OK || status_bits(cmd->result) & CHECK_CONDITION) ) */
 		if ((cmd->result == (DID_OK << 16)
-		     || status_byte(cmd->result) &
+		     || status_bits(cmd->result) &
 		     CHECK_CONDITION)) {
 			if (!dcb->init_tcq_flag) {
 				add_dev(acb, dcb, ptr);
--- linux-next-20100924.orig/drivers/scsi/NCR5380.c
+++ linux-next-20100924/drivers/scsi/NCR5380.c
@@ -2275,7 +2275,7 @@ static void NCR5380_information_transfer
 
 					if (cmd->cmnd[0] != REQUEST_SENSE)
 						cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					else if (status_byte(cmd->SCp.Status) != GOOD)
+					else if (status_bits(cmd->SCp.Status) != GOOD)
 						cmd->result = (cmd->result & 0x00ffff) | (DID_ERROR << 16);
 
 #ifdef AUTOSENSE
@@ -2285,7 +2285,7 @@ static void NCR5380_information_transfer
 						hostdata->ses.cmd_len = 0 ;
 					}
 
-					if ((cmd->cmnd[0] != REQUEST_SENSE) && (status_byte(cmd->SCp.Status) == CHECK_CONDITION)) {
+					if ((cmd->cmnd[0] != REQUEST_SENSE) && (status_bits(cmd->SCp.Status) == CHECK_CONDITION)) {
 						scsi_eh_prep_cmnd(cmd, &hostdata->ses, NULL, 0, ~0);
 
 						dprintk(NDEBUG_AUTOSENSE, ("scsi%d : performing request sense\n", instance->host_no));
--- linux-next-20100924.orig/drivers/scsi/aic7xxx_old.c
+++ linux-next-20100924/drivers/scsi/aic7xxx_old.c
@@ -4241,7 +4241,7 @@ aic7xxx_handle_seqint(struct aic7xxx_hos
 
           cmd->result = hscb->target_status;
 
-          switch (status_byte(hscb->target_status))
+          switch (status_bits(hscb->target_status))
           {
             case GOOD:
               if (aic7xxx_verbose & VERBOSE_SEQINT)
--- linux-next-20100924.orig/drivers/scsi/advansys.c
+++ linux-next-20100924/drivers/scsi/advansys.c
@@ -6725,7 +6725,7 @@ static void adv_isr_callback(ADV_DVC_VAR
 				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
 						  SCSI_SENSE_BUFFERSIZE);
 				/*
-				 * Note: The 'status_byte()' macro used by
+				 * Note: The 'status_bits()' macro used by
 				 * target drivers defined in scsi.h shifts the
 				 * status byte returned by host drivers right
 				 * by 1 bit.  This is why target drivers also
@@ -7658,7 +7658,7 @@ static void asc_isr_callback(ASC_DVC_VAR
 				ASC_DBG_PRT_SENSE(2, scp->sense_buffer,
 						  SCSI_SENSE_BUFFERSIZE);
 				/*
-				 * Note: The 'status_byte()' macro used by
+				 * Note: The 'status_bits()' macro used by
 				 * target drivers defined in scsi.h shifts the
 				 * status byte returned by host drivers right
 				 * by 1 bit.  This is why target drivers also
--- linux-next-20100924.orig/drivers/scsi/53c700.c
+++ linux-next-20100924/drivers/scsi/53c700.c
@@ -975,8 +975,8 @@ process_script_interrupt(__u32 dsps, __u
 						  NCR_700_FINISHED_TAG_NEGOTIATION);
 			
 		/* check for contingent allegiance contitions */
-		if(status_byte(hostdata->status[0]) == CHECK_CONDITION ||
-		   status_byte(hostdata->status[0]) == COMMAND_TERMINATED) {
+		if(status_bits(hostdata->status[0]) == CHECK_CONDITION ||
+		   status_bits(hostdata->status[0]) == COMMAND_TERMINATED) {
 			struct NCR_700_command_slot *slot =
 				(struct NCR_700_command_slot *)SCp->host_scribble;
 			if(slot->flags == NCR_700_FLAG_AUTOSENSE) {
@@ -1042,7 +1042,7 @@ process_script_interrupt(__u32 dsps, __u
 			// Currently rely on the mid layer evaluation
 			// of the tag queuing capability
 			//
-			//if(status_byte(hostdata->status[0]) == GOOD &&
+			//if(status_bits(hostdata->status[0]) == GOOD &&
 			//   SCp->cmnd[0] == INQUIRY && SCp->use_sg == 0) {
 			//	/* Piggy back the tag queueing support
 			//	 * on this command */
--- linux-next-20100924.orig/drivers/scsi/eata.c
+++ linux-next-20100924/drivers/scsi/eata.c
@@ -2411,7 +2411,7 @@ static irqreturn_t ihdlr(struct Scsi_Hos
 	    && TLDEV(SCpnt->device->type))
 		flush_dev(SCpnt->device, blk_rq_pos(SCpnt->request), ha, 1);
 
-	tstatus = status_byte(spp->target_status);
+	tstatus = status_bits(spp->target_status);
 
 #if defined(DEBUG_GENERATE_ERRORS)
 	if ((ha->iocount > 500) && ((ha->iocount % 200) < 2))
--- linux-next-20100924.orig/drivers/scsi/scsi.c
+++ linux-next-20100924/drivers/scsi/scsi.c
@@ -614,7 +614,7 @@ void scsi_log_completion(struct scsi_cmn
 			}
 			scsi_print_result(cmd);
 			scsi_print_command(cmd);
-			if (status_byte(cmd->result) & CHECK_CONDITION)
+			if (status_bits(cmd->result) & CHECK_CONDITION)
 				scsi_print_sense("", cmd);
 			if (level > 3)
 				scmd_printk(KERN_INFO, cmd,
--- linux-next-20100924.orig/drivers/scsi/sg.c
+++ linux-next-20100924/drivers/scsi/sg.c
@@ -1294,7 +1294,7 @@ static void sg_rq_end_io(struct request 
 		struct scsi_sense_hdr sshdr;
 
 		srp->header.status = 0xff & result;
-		srp->header.masked_status = status_byte(result);
+		srp->header.masked_status = status_bits(result);
 		srp->header.msg_status = msg_byte(result);
 		srp->header.host_status = host_byte(result);
 		srp->header.driver_status = driver_byte(result);
--- linux-next-20100924.orig/drivers/scsi/u14-34f.c
+++ linux-next-20100924/drivers/scsi/u14-34f.c
@@ -1804,7 +1804,7 @@ static irqreturn_t ihdlr(unsigned int j)
                                      && TLDEV(SCpnt->device->type))
       flush_dev(SCpnt->device, blk_rq_pos(SCpnt->request), j, TRUE);
 
-   tstatus = status_byte(spp->target_status);
+   tstatus = status_bits(spp->target_status);
 
 #if defined(DEBUG_GENERATE_ERRORS)
    if ((HD(j)->iocount > 500) && ((HD(j)->iocount % 200) < 2))
--- linux-next-20100924.orig/drivers/scsi/scsi_error.c
+++ linux-next-20100924/drivers/scsi/scsi_error.c
@@ -458,7 +458,7 @@ static int scsi_eh_completed_normally(st
 	 * now, check the status byte to see if this indicates
 	 * anything special.
 	 */
-	switch (status_byte(scmd->result)) {
+	switch (status_bits(scmd->result)) {
 	case GOOD:
 		scsi_handle_queue_ramp_up(scmd->device);
 	case COMMAND_TERMINATED:
@@ -1339,14 +1339,14 @@ int scsi_noretry_cmd(struct scsi_cmnd *s
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
 	case DID_ERROR:
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
-		    status_byte(scmd->result) == RESERVATION_CONFLICT)
+		    status_bits(scmd->result) == RESERVATION_CONFLICT)
 			return 0;
 		/* fall through */
 	case DID_SOFT_ERROR:
 		return (scmd->request->cmd_flags & REQ_FAILFAST_DRIVER);
 	}
 
-	switch (status_byte(scmd->result)) {
+	switch (status_bits(scmd->result)) {
 	case CHECK_CONDITION:
 		/*
 		 * assume caller has checked sense and determinted
@@ -1449,7 +1449,7 @@ int scsi_decide_disposition(struct scsi_
 		return SUCCESS;
 	case DID_ERROR:
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
-		    status_byte(scmd->result) == RESERVATION_CONFLICT)
+		    status_bits(scmd->result) == RESERVATION_CONFLICT)
 			/*
 			 * execute reservation conflict processing code
 			 * lower down
@@ -1487,7 +1487,7 @@ int scsi_decide_disposition(struct scsi_
 	/*
 	 * check the status byte to see if this indicates anything special.
 	 */
-	switch (status_byte(scmd->result)) {
+	switch (status_bits(scmd->result)) {
 	case QUEUE_FULL:
 		scsi_handle_queue_full(scmd->device);
 		/*
