From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 10:51:48 -0500
Message-ID: <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
References: <4468B596.9090508@garzik.org>
	 <1147789098.3505.19.camel@mulgrave.il.steeleye.com>
	 <4469F2B2.703@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4469F2B2.703@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2006-05-16 at 11:41 -0400, Jeff Garzik wrote:
> I can't see a case _in libata operation_ where a set of circumstances 
> arises that causes missed wakeups, can you elaborate?

This is scsi_eh_wakeup():

void scsi_eh_wakeup(struct Scsi_Host *shost)
{
	if (shost->host_busy == shost->host_failed) {
		wake_up_process(shost->ehandler);

so if you try a wakeup with no failed commands and the host still busy,
nothing happens.

> > move the prototype out of scsi_priv.h ... it should only be used by
> > transport classes, anyway.
> 
> We're talking about all ->eh_strategy_handler() users, which is a valid 
> EH API for an LLDD to choose.  Granted libata is really the only one 
> right now.

We're busy revoking the LLDD driver, so in future it will be transport
classes only.

> Long term, ->eh_strategy_handler and transport classes are block layer 
> not SCSI level anyway, so scsi_priv.h is clearly inappropriate.

That can be sorted out if someone actually gets around to moving error
handling to the block level.  In the meantime, it's SCSI that we're
discussing.

> > 2) This scsi_req_abort_cmd() is fundamentally the wrong logic.
> > Everything else is communicated back as a result code from the command
> > in done().  This should be no different ... A status return of
> > DID_FAILED which scsi_decide_disposition() always translates to FAILED
> > would seem to do exactly what you want without all the overhead.
> 
> Inigo sez[1]:  I do not think "fundamentally wrong" means what you think 
> it means.
> 
> You miss the fact that the timer may have already fired, in which 
> completing a command gets you...... not a damned thing.  scsi_done() 
> will simply return, if the timeout has fired.  This has always been an 
> annoying problem to work around.

No ... in that case the eh is already active, and your API does this:

void scsi_req_abort_cmd(struct scsi_cmnd *cmd)
{
	if (!scsi_delete_timer(cmd))
		return;
		^^^^^^^
	scsi_times_out(cmd);
}

Which likewise does nothing if the timer has already fired, so they both
have the same effect.

James


