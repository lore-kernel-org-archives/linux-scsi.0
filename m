From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH 2/2] scsi: Do not complete timed-out command
Date: Thu, 19 Jun 2014 10:43:07 -0400
Message-ID: <1403188987.6423.152.camel@localhost.localdomain>
References: <1402660906-74661-1-git-send-email-hare@suse.de>
	 <1402660906-74661-3-git-send-email-hare@suse.de>
	 <1402943010.6423.67.camel@localhost.localdomain> <539FD7BC.6060602@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45307 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbaFSOnM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Jun 2014 10:43:12 -0400
In-Reply-To: <539FD7BC.6060602@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org

On Tue, 2014-06-17 at 07:53 +0200, Hannes Reinecke wrote:
> On 06/16/2014 08:23 PM, Ewan Milne wrote:
> > On Fri, 2014-06-13 at 14:01 +0200, Hannes Reinecke wrote:
> >> There is a possible race between scsi_times_out() and scsi_done();
> >> the LLDD is only notified about a timed out command by calling
> >> scsi_try_to_abort_command(). Anytime before that the LLDD is
> >> free to complete the command via scsi_done().
> >> By this time, however, the command might've been timed-out already,
> >> leaving us with a stale command in the error handler.
> >> Fix this by separating out the two meanings of the
> >> SCSI_EH_ABORT_SCHEDULED flag; it's used to signal that
> >> a) the asynchronous abort has been schedule
> >> and
> >> b) that an asynchronous abourt had been running, the command
> >>     has been retried, and has timed out again.
> >>
> >> This patch implements a new flag SCSI_EH_CMD_TIMEOUT to signal
> >> that a command has run into a timeout (and thus can be used
> >> to detect case b) above). The existing flag
> >> SCSI_EH_CMD_ABORT_SCHEDULED is now restricted to signal
> >> 'the asynchronous abort has been scheduled', and thus should be
> >> checked in scsi_done() to avoid the mentioned race.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> ---
> >>   drivers/scsi/scsi.c       | 2 ++
> >>   drivers/scsi/scsi_error.c | 6 ++++--
> >>   drivers/scsi/scsi_priv.h  | 1 +
> >>   3 files changed, 7 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> >> index 88d46fe..7a58fbe 100644
> >> --- a/drivers/scsi/scsi.c
> >> +++ b/drivers/scsi/scsi.c
> >> @@ -739,6 +739,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
> >>    */
> >>   static void scsi_done(struct scsi_cmnd *cmd)
> >>   {
> >> +	if (WARN_ON_ONCE(cmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED))
> >> +		return;
> >>   	trace_scsi_dispatch_cmd_done(cmd);
> >>   	blk_complete_request(cmd->request);
> >>   }
> >> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> >> index ff176a6..cde9c11 100644
> >> --- a/drivers/scsi/scsi_error.c
> >> +++ b/drivers/scsi/scsi_error.c
> >> @@ -125,11 +125,13 @@ scmd_eh_abort_handler(struct work_struct *work)
> >>   			scmd_printk(KERN_INFO, scmd,
> >>   				    "scmd %p eh timeout, not aborting\n",
> >>   				    scmd));
> >> +		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> >>   	} else {
> >>   		SCSI_LOG_ERROR_RECOVERY(3,
> >>   			scmd_printk(KERN_INFO, scmd,
> >>   				    "aborting command %p\n", scmd));
> >>   		rtn = scsi_try_to_abort_cmd(sdev->host->hostt, scmd);
> >> +		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> >>   		if (rtn == SUCCESS) {
> >>   			scmd->result |= DID_TIME_OUT << 16;
> >>   			if (scsi_host_eh_past_deadline(sdev->host)) {
> >> @@ -185,17 +187,17 @@ scsi_abort_command(struct scsi_cmnd *scmd)
> >>   	struct Scsi_Host *shost = sdev->host;
> >>   	unsigned long flags;
> >>
> >> -	if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
> >> +	if (scmd->eh_eflags & SCSI_EH_CMD_TIMEOUT) {
> >>   		/*
> >>   		 * Retry after abort failed, escalate to next level.
> >>   		 */
> >> -		scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
> >>   		SCSI_LOG_ERROR_RECOVERY(3,
> >>   			scmd_printk(KERN_INFO, scmd,
> >>   				    "scmd %p previous abort failed\n", scmd));
> >>   		cancel_delayed_work(&scmd->abort_work);
> >>   		return FAILED;
> >>   	}
> >> +	scmd->eh_eflags |= SCSI_EH_CMD_TIMEOUT;
> >>
> >>   	/*
> >>   	 * Do not try a command abort if
> >> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> >> index 48e5b65..66b387d 100644
> >> --- a/drivers/scsi/scsi_priv.h
> >> +++ b/drivers/scsi/scsi_priv.h
> >> @@ -20,6 +20,7 @@ struct scsi_nl_hdr;
> >>    */
> >>   #define SCSI_EH_CANCEL_CMD	0x0001	/* Cancel this cmd */
> >>   #define SCSI_EH_ABORT_SCHEDULED	0x0002	/* Abort has been scheduled */
> >> +#define SCSI_EH_CMD_TIMEOUT	0x0004	/* Command has timed out */
> >>
> >>   #define SCSI_SENSE_VALID(scmd) \
> >>   	(((scmd)->sense_buffer[0] & 0x70) == 0x70)
> >
> > So, let me see if I follow the logic here...
> >
> > This patch changes the meaning of the SCSI_EH_ABORT_SCHEDULED flag
> > so that this flag is set during the time the queue_delayed_work() item
> > is pending, until the LLD returns from the ->eh_abort_handler() call.
> > It also adds a new flag SCSI_EH_CMD_TIMEOUT which is set (essentially)
> > when the scmd has timed out, and prevent scsi_abort_command() from
> > doing anything more than once (until scmd->eh_eflags is reset).
> >
> > I don't quite get why scsi_eh_scmd_add() tests SCSI_EH_ABORT_SCHEDULED:
> >
> >>         if (shost->eh_deadline != -1 && !shost->last_reset)
> >>                 shost->last_reset = jiffies;
> >>
> >>         ret = 1;
> >>         if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED)
> >>                 eh_flag &= ~SCSI_EH_CANCEL_CMD;
> >>         scmd->eh_eflags |= eh_flag;
> >>         list_add_tail(&scmd->eh_entry, &shost->eh_cmd_q);
> >>         shost->host_failed++;
> >>         scsi_eh_wakeup(shost);
> >
> > ...since it seems like that flag wouldn't still be set by the time we
> > get to the point where we are adding the scmd to the eh_cmd_q list.
> >
> > I'm also not sure why this case in scsi_decide_disposition():
> >
> >>         case DID_ABORT:
> >>                 if (scmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED) {
> >>                         scmd->result |= DID_TIME_OUT << 16;
> >>                         return SUCCESS;
> >>                 }
> >
> > ...is looking at SCSI_EH_ABORT_SCHEDULED, for similar reasons.
> >
> > The WARN_ON_ONCE() case in scsi_done():
> >
> >> static void scsi_done(struct scsi_cmnd *cmd)
> >> {
> >>         if (WARN_ON_ONCE(cmd->eh_eflags & SCSI_EH_ABORT_SCHEDULED))
> >>                 return;
> >>         trace_scsi_dispatch_cmd_done(cmd);
> >>         blk_complete_request(cmd->request);
> >> }
> >
> > ...seems like it should never go off because of the REQ_ATOM_COMPLETE
> > logic in the block layer, assuming that logic is working.
> >
> > Can you verify this is the intended behavior, or perhaps explain
> > what hole this patch is attempting to plug?  It seems like it is
> > dealing with the case of scsi_done() being called after a timeout
> > but before the delayed_work abort mechanism runs.  Is this actually
> > what is happening?
> >
> > Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> >
> After the explanation from James B. it might indeed be handled by 
> REQ_ATOM_COMPLETE, and the real reason were the missing USB fixes.
> I've sent a test kernel with the USB fixes to our customer and wait
> for feedback there.
> 
> I'll be retracting this patchset for the time being.
> 
> Cheers,
> 
> Hannes

Just as a data point, I have a report that a kernel with these 2
patches, as well as the other 4 recent USB deadlock fixes, seems
to have resolved a duplicate completion crash.  Will try to retest
with only the first patch in this set and see what happens.

A duplicate completion crash *was* seen with just the USB fixes.

-Ewan




