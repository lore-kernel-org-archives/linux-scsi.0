From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [Fwd: [RFT] major libata update]
Date: Tue, 16 May 2006 11:28:53 -0700 (PDT)
Message-ID: <20060516182853.79223.qmail@web31809.mail.mud.yahoo.com>
References: <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:38005 "HELO
	web31809.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S932499AbWEPS2x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 14:28:53 -0400
In-Reply-To: <1147794708.3505.30.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jeff@garzik.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Tue, 2006-05-16 at 11:41 -0400, Jeff Garzik wrote:
> > You miss the fact that the timer may have already fired, in which 
> > completing a command gets you...... not a damned thing.  scsi_done() 
> > will simply return, if the timeout has fired.  This has always been an 
> > annoying problem to work around.
> 
> No ... in that case the eh is already active, and your API does this:
> 
> void scsi_req_abort_cmd(struct scsi_cmnd *cmd)
> {
> 	if (!scsi_delete_timer(cmd))
> 		return;
> 		^^^^^^^
> 	scsi_times_out(cmd);
> }
> 
> Which likewise does nothing if the timer has already fired, so they both
> have the same effect.

I think I just explained this.  Let me try again.

They don't both have the same effect.  What you're suggesting. calling done()
with status so that, EH can turn around and recover the command, as in this thread
and in this thread: http://marc.theaimsgroup.com/?l=linux-scsi&m=113833937421677&w=2,
_terminates_ the command nexus with the driver!

Secondly, this function, solves races between the transport telling you "I want
to abort this command" and the command timing out.  When the driver get transport
notification that this command should be aborted, it doesn't need to care
where and in what state with SCSI Core the command is.  As long as it has nexus
it can call this function and then the command would be recovered with
ABORT TASK or another TMF as it pertinent to the transport.

Calling scsi_req_abort_cmd() _guaranees_ that this command would be recovered
either way.  This gives LLDD and interconnects guarantee that ABORT TASK
would be called and then they can do recovert for the command/device.

    Luben

