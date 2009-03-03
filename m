From: Ingo Molnar <mingo@elte.hu>
Subject: Re: Large amount of scsi-sgpool objects
Date: Tue, 3 Mar 2009 21:56:37 +0100
Message-ID: <20090303205637.GA26196@elte.hu>
References: <49AD59B4.1060304@panasas.com> <Pine.LNX.4.44L0.0903031256300.3274-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0903031256300.3274-100000@iolanthe.rowland.org>
Sender: linux-rt-users-owner@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jan Engelhardt <jengelh@medozas.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


* Alan Stern <stern@rowland.harvard.edu> wrote:

> On Tue, 3 Mar 2009, Boaz Harrosh wrote:
> 
> > Jan Engelhardt wrote:
> > > On Tuesday 2009-03-03 16:21, James Bottomley wrote:
> > >>>> $ slabtop
> > >>>>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
> > >>>> 818616 818616 100%    0.16K  34109       24    136436K sgpool-8
> > >>>> 253692 253692 100%    0.62K  42282        6    169128K sgpool-32
> > >>>>  52017  52016  99%    2.50K  17339        3    138712K sgpool-128
> > >>>>  26220  26219  99%    0.31K   2185       12      8740K sgpool-16
> > >>>>   8927   8574  96%    0.03K     79      113       316K size-32
> > >>> Looks like a leak, by failing to call scsi_release_buffers()
> > >>> somehow. (Which was changed recently)
> > >> Firstly, I have to say I don't see this in the mainline tree, so could
> > >> you try that with your setup just to verify (git head at 2.6.29-rc6).
> > > 
> > > Yes, looking at the rt patch (in broken-out it's in origin.diff),
> > > it seems a bit obvious - the scsi_release_buffers is not called anymore:
> > > 
> > > 
> > > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > > index 940dc32..d4c6ac3 100644
> > > --- a/drivers/scsi/scsi_lib.c
> > > +++ b/drivers/scsi/scsi_lib.c
> > > @@ -703,71 +703,6 @@ void scsi_run_host_queues(struct Scsi_Host *shost)
> > >  
> > >  static void __scsi_release_buffers(struct scsi_cmnd *, int);
> > >  
> > > -/*
> > > - * Function:    scsi_end_request()
> > > - *
> > > - * Purpose:     Post-processing of completed commands (usually invoked at end
> > > - *		of upper level post-processing and scsi_io_completion).
> > > - *
> > > - * Arguments:   cmd	 - command that is complete.
> > > - *              error    - 0 if I/O indicates success, < 0 for I/O error.
> > > - *              bytes    - number of bytes of completed I/O
> > > - *		requeue  - indicates whether we should requeue leftovers.
> > > - *
> > > - * Lock status: Assumed that lock is not held upon entry.
> > > - *
> > > - * Returns:     cmd if requeue required, NULL otherwise.
> > > - *
> > > - * Notes:       This is called for block device requests in order to
> > > - *              mark some number of sectors as complete.
> > > - * 
> > > - *		We are guaranteeing that the request queue will be goosed
> > > - *		at some point during this call.
> > > - * Notes:	If cmd was requeued, upon return it will be a stale pointer.
> > > - */
> > > -static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int error,
> > > -					  int bytes, int requeue)
> > > -{
> > > -	struct request_queue *q = cmd->device->request_queue;
> > > -	struct request *req = cmd->request;
> > > -
> > > -	/*
> > > -	 * If there are blocks left over at the end, set up the command
> > > -	 * to queue the remainder of them.
> > > -	 */
> > > -	if (blk_end_request(req, error, bytes)) {
> > > -		int leftover = (req->hard_nr_sectors << 9);
> > > -
> > > -		if (blk_pc_request(req))
> > > -			leftover = req->data_len;
> > > -
> > > -		/* kill remainder if no retrys */
> > > -		if (error && scsi_noretry_cmd(cmd))
> > > -			blk_end_request(req, error, leftover);
> > > -		else {
> > > -			if (requeue) {
> > > -				/*
> > > -				 * Bleah.  Leftovers again.  Stick the
> > > -				 * leftovers in the front of the
> > > -				 * queue, and goose the queue again.
> > > -				 */
> > > -				scsi_release_buffers(cmd);
> > > -				scsi_requeue_command(q, cmd);
> > > -				cmd = NULL;
> > > -			}
> > > -			return cmd;
> > > -		}
> > > -	}
> > > -
> > > -	/*
> > > -	 * This will goose the queue request function at the end, so we don't
> > > -	 * need to worry about launching another command.
> > > -	 */
> > > -	__scsi_release_buffers(cmd, 0);
> > > -	scsi_next_command(cmd);
> > > -	return NULL;
> > > -}
> > > -
> > >  static inline unsigned int scsi_sgtable_index(unsigned short nents)
> > >  {
> > >  	unsigned int index;
> > > @@ -929,7 +864,6 @@ static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
> > >  void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
> > >  {
> > >  	int result = cmd->result;
> > > -	int this_count;
> > >  	struct request_queue *q = cmd->device->request_queue;
> > >  	struct request *req = cmd->request;
> > >  	int error = 0;
> > > @@ -980,18 +914,30 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
> > >  	SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, "
> > >  				      "%d bytes done.\n",
> > >  				      req->nr_sectors, good_bytes));
> > > -
> > > -	/* A number of bytes were successfully read.  If there
> > > -	 * are leftovers and there is some kind of error
> > > -	 * (result != 0), retry the rest.
> > > -	 */
> > > -	if (scsi_end_request(cmd, error, good_bytes, result == 0) == NULL)
> > > +	if (blk_end_request(req, error, good_bytes) == 0) {
> > > +		/* This request is completely finished; start the next one */
> > > +		scsi_next_command(cmd);
> > >  		return;
> > > -	this_count = blk_rq_bytes(req);
> > > +	}
> 
> > You lost me. Why does rt needs to patch scsi_io_completion at all?
> > You should remove any rt patches that modify scsi_lib.c and revert to
> > vanilla 2.6.29-rc6 (scsi wise that is).
> > 
> > The above diff looks like something that was sent in the past to the mailing
> > list, but only half of it. It was sent by Alan Stern. It might patch but
> > it is not applicable any more because of changes made since. 
> 
> That's right; it is an old version of a patch which no longer applies 
> to the current kernel (the __scsi_release_buffers() call was added 
> after that patch was written).  An updated version of the patch has 
> been submitted here:
> 
> 	http://marc.info/?l=linux-scsi&m=123507641620649&w=2

ah, i missed that patch because you used the exact same subject 
line. (The standard lkml convention is to use "v2, v3" 
postfixes, to make sure people notice that it's an update. It 
helps avoid such mistakes.)

I've picked up the v2 delta below into tip:out-of-tree - thanks 
Alan! This will also get into the next -rt release.

Both patches will go away from the tip:out-of-tree hot-fixes 
branch once the fix is upstream via the SCSI tree.

Any ETA for that? The lockup bug it fixes is very serious.

	Ingo

-------------------->
>From 6b1f22c4418f4684806b4ee499f2c623f5ed998b Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 3 Mar 2009 21:52:16 +0100
Subject: [PATCH] fix "scsi: aic7xxx hang since v2.6.28-rc1", v2

updated "SCSI: remove scsi_end_request()" patch.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/scsi/scsi_lib.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 8388b4e..abd2652 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -916,12 +916,11 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				      req->nr_sectors, good_bytes));
 	if (blk_end_request(req, error, good_bytes) == 0) {
 		/* This request is completely finished; start the next one */
+		 __scsi_release_buffers(cmd, 0);
 		scsi_next_command(cmd);
 		return;
 	}
 
-	error = -EIO;
-
 	/* The request isn't finished yet.  Figure out what to do next. */
 	if (result == 0) {
 		/* No error, so carry out the remainder of the request.
@@ -931,8 +930,9 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		if (good_bytes > 0 || --req->retries >= 0)
 			action = ACTION_REPREP;
 		else {
-			action = ACTION_FAIL;
 			description = "Retries exhausted";
+			action = ACTION_FAIL;
+			error = -EIO;
 		}
 	} else if (error && scsi_noretry_cmd(cmd)) {
 		/* Retrys are disallowed, so kill the remainder. */
@@ -944,6 +944,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 		 */
 		action = ACTION_RETRY;
 	} else if (sense_valid && !sense_deferred) {
+		error = -EIO;
 		switch (sshdr.sense_key) {
 		case UNIT_ATTENTION:
 			if (cmd->device->removable) {
@@ -1043,7 +1044,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);
 		}
-		blk_end_request(req, -EIO, blk_rq_bytes(req));
+		blk_end_request(req, error, blk_rq_bytes(req));
 		scsi_next_command(cmd);
 		break;
 	case ACTION_REPREP:
