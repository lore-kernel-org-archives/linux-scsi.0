From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Large amount of scsi-sgpool objects
Date: Tue, 3 Mar 2009 17:08:00 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903030220050.2438@fbirervta.pbzchgretzou.qr>  <49ACF8FE.2020904@panasas.com> <1236093718.3263.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <1236093718.3263.3.camel@localhost.localdomain>
Sender: linux-rt-users-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Tuesday 2009-03-03 16:21, James Bottomley wrote:
>> > $ slabtop
>> >   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
>> > 818616 818616 100%    0.16K  34109       24    136436K sgpool-8
>> > 253692 253692 100%    0.62K  42282        6    169128K sgpool-32
>> >  52017  52016  99%    2.50K  17339        3    138712K sgpool-128
>> >  26220  26219  99%    0.31K   2185       12      8740K sgpool-16
>> >   8927   8574  96%    0.03K     79      113       316K size-32
>> 
>> Looks like a leak, by failing to call scsi_release_buffers()
>> somehow. (Which was changed recently)
>
>Firstly, I have to say I don't see this in the mainline tree, so could
>you try that with your setup just to verify (git head at 2.6.29-rc6).

Yes, looking at the rt patch (in broken-out it's in origin.diff),
it seems a bit obvious - the scsi_release_buffers is not called anymore:


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 940dc32..d4c6ac3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -703,71 +703,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
 
 static void __scsi_release_buffers(struct scsi_cmnd *, int);
 
-/*
- * Function:    scsi_end_request()
- *
- * Purpose:     Post-processing of completed commands (usually invoked at end
- *		of upper level post-processing and scsi_io_completion).
- *
- * Arguments:   cmd	 - command that is complete.
- *              error    - 0 if I/O indicates success, < 0 for I/O error.
- *              bytes    - number of bytes of completed I/O
- *		requeue  - indicates whether we should requeue leftovers.
- *
- * Lock status: Assumed that lock is not held upon entry.
- *
- * Returns:     cmd if requeue required, NULL otherwise.
- *
- * Notes:       This is called for block device requests in order to
- *              mark some number of sectors as complete.
- * 
- *		We are guaranteeing that the request queue will be goosed
- *		at some point during this call.
- * Notes:	If cmd was requeued, upon return it will be a stale pointer.
- */
-static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
-					  int bytes, int requeue)
-{
-	struct request_queue *q = cmd->device->request_queue;
-	struct request *req = cmd->request;
-
-	/*
-	 * If there are blocks left over at the end, set up the command
-	 * to queue the remainder of them.
-	 */
-	if (blk_end_request(req, error, bytes)) {
-		int leftover = (req->hard_nr_sectors << 9);
-
-		if (blk_pc_request(req))
-			leftover = req->data_len;
-
-		/* kill remainder if no retrys */
-		if (error && scsi_noretry_cmd(cmd))
-			blk_end_request(req, error, leftover);
-		else {
-			if (requeue) {
-				/*
-				 * Bleah.  Leftovers again.  Stick the
-				 * leftovers in the front of the
-				 * queue, and goose the queue again.
-				 */
-				scsi_release_buffers(cmd);
-				scsi_requeue_command(q, cmd);
-				cmd = NULL;
-			}
-			return cmd;
-		}
-	}
-
-	/*
-	 * This will goose the queue request function at the end, so we don't
-	 * need to worry about launching another command.
-	 */
-	__scsi_release_buffers(cmd, 0);
-	scsi_next_command(cmd);
-	return NULL;
-}
-
 static inline unsigned int scsi_sgtable_index(unsigned short nents)
 {
 	unsigned int index;
@@ -929,7 +864,6 @@ static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
 void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 {
 	int result = cmd->result;
-	int this_count;
 	struct request_queue *q = cmd->device->request_queue;
 	struct request *req = cmd->request;
 	int error = 0;
@@ -980,18 +914,30 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
 				      "%d bytes done.\n",
 				      req->nr_sectors, good_bytes));
-
-	/* A number of bytes were successfully read.  If there
-	 * are leftovers and there is some kind of error
-	 * (result != 0), retry the rest.
-	 */
-	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
+	if (blk_end_request(req, error, good_bytes) == 0) {
+		/* This request is completely finished; start the next one */
+		scsi_next_command(cmd);
 		return;
-	this_count = blk_rq_bytes(req);
+	}
 
 	error = -EIO;
 
-	if (host_byte(result) == DID_RESET) {
+	/* The request isn't finished yet.  Figure out what to do next. */
+	if (result == 0) {
+		/* No error, so carry out the remainder of the request.
+		 * Failure to make forward progress counts against the
+		 * the number of retries.
+		 */
+		if (good_bytes > 0 || --req->retries >= 0)
+			action = ACTION_REPREP;
+		else {
+			action = ACTION_FAIL;
+			description = "Retries exhausted";
+		}
+	} else if (error && scsi_noretry_cmd(cmd)) {
+		/* Retrys are disallowed, so kill the remainder. */
+		action = ACTION_FAIL;
+	} else if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
 		 * reasons.  Just retry the command and see what
 		 * happens.



Would you happen to know where I have to reinsert them in the
rt modification shown here?

>If this holds true, there must be a bad patch in the -rt tree.  You
>should be able to diff scsi_lib.c to see if there's something missing.
>
>Finally, there are one or two drivers (SCSI target) that do their own
>buffer management, so what drivers are you using?


ata1.00: ATA-5: WDC WD400EB-00CPF0, 06.04G06, max UDMA/100
ata1.00: 78165360 sectors, multi 16: LBA
ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-4160B, A301, max UDMA/66
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/66
scsi 0:0:0:0: Direct-Access     ATA      WDC WD400EB-00CP 06.0 PQ: 0 ANSI: 5
scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-4160B A301 PQ: 0 ANSI: 5
ata2.00: ATA-7: DIAMOND  250G 2B5400, RAMB1TU0, max UDMA/133
ata2.00: 490234752 sectors, multi 16: LBA48
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      DIAMOND  250G 2B RAMB PQ: 0 ANSI: 5




Jan
