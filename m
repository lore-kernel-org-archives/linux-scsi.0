From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi: Allow error handling timeout to be specified
Date: Fri, 10 May 2013 12:59:00 -0400
Message-ID: <1368205140.3319.70.camel@localhost.localdomain>
References: <yq1fvxvedg6.fsf@sermon.lab.mkp.net>
	 <1368189791.3319.31.camel@localhost.localdomain>
	 <CAC9+an+UBY3Cbxryn3O0KMVMuwdXBpf9EsVJ08tV=5Y0dpkjdA@mail.gmail.com>
	 <1368194460.3319.40.camel@localhost.localdomain> <518D0311.9010208@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59508 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab3EJQ7i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 May 2013 12:59:38 -0400
In-Reply-To: <518D0311.9010208@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Baruch Even <baruch@ev-en.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, michaelc <michaelc@cs.wisc.edu>

On Fri, 2013-05-10 at 16:24 +0200, Hannes Reinecke wrote: 
> On 05/10/2013 04:01 PM, Ewan Milne wrote:
> > On Fri, 2013-05-10 at 16:22 +0300, Baruch Even wrote:
> >> On Fri, May 10, 2013 at 3:43 PM, Ewan Milne <emilne@redhat.com> wrote:
> >>>
> >>> On Thu, 2013-05-09 at 23:11 -0400, Martin K. Petersen wrote:
> >>>> Introduce eh_timeout which can be used for error handling purposes. This
> >>>> was previously hardcoded to 10 seconds in the SCSI error handling
> >>>> code. However, for some fast-fail scenarios it is necessary to be able
> >>>> to tune this as it can take several iterations (bus device, target, bus,
> >>>> controller) before we give up.
> >>>>
> >>>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> >>>>
> >>>
> >>> Thanks for posting this.  It will be very helpful to have this
> >>> capability, particularly when alternate paths to the device exist.
> >>>
> >>> Acked-by: Ewan D. Milne <emilne@redhat.com>
> >>
> >>
> >> I would argue that waiting for the eh to timeout before you switch to
> >> another path is most likely to be wrong. If you did the first pass of
> >> error recovery (task abort) and that failed the
> >> path/hba/logical-device is doomed. If you will switch to another path
> >> it will either work (meaning the path/hba were bad) or not (logical
> >> device was the culprit).
> > 
> > It is necessary to either know the disposition of a command or
> > else wait for a defined amount of time before retrying the command on
> > another path.  Otherwise you run the risk that the command will
> > eventually complete on the first path.  So yes, we need to do the abort
> > (and its timeout).
> > 
> Strictly speaking that's not true.
> Yes, we do need to wait for a certain amount of time for the command
> completion to come in.
> 
> However, this time is only defined _on the initiator_.
> The specification does _NOT_ have any fixed timeout values for _any_
> command. As such it could in theory (and does, if you happen to run
> against certain arrays under certain conditions) take several
> minutes to return a completion.

Granted.  (e.g. in the case of WRITE SAME, it could be a while before
the command completes, and retrying it on another path too quickly,
followed by other WRITE commands could be a disaster).  So the timeout
used for the original command has to be appropriate for the command.
Reducing that timeout and issuing an abort / lun reset / target reset
to try to fail over to another path earlier won't work if the device
never gets the abort / lun reset / target reset and the command is still
executing.

In the case of commands / TMFs issued by the error handling, the timeout
needs to be long enough to account for the delay in the driver / HBA,
switches (i.e. in an FC environment), and the target's device server.
But this time might very well be much shorter than the worst case for
other commands.  So I think allowing EH timeouts to be specified is a
good thing.  They just have to be set properly, the same as timeouts
for other commands (which can already be adjusted, but are overridden
for SYNCHRONIZE CACHE and WRITE SAME).

> 
> So we have to accept that a command completion might happen in
> between the time we take between deciding that a command abort has
> to be send and the actual submission of the command abort by the
> HBA. Which is totally independent of any command timeout we set.
> It's just that a short command timeout increases the likelyhood of
> the race to happen; the race itself is always present.
> 
> >>
> >> Actually reducing the timeouts is probably not a good approach since
> >> it will cause the host to take a more radical approach without waiting
> >> sufficiently for a potential recovery. In addition the more radical
> >> error handlings such as host reset will destroy other paths for
> >> completely unrelated devices/links, from my experience a host reset is
> >> usually not required and the Linux kernel currently reaches to this
> >> big hammer too fast.
> > 
> > I believe that Hannes is working on a better error handling algorithm
> > that e.g. does not cause an emulated bus reset in an FC environment
> > by resetting all the targets (and affecting I/O to unrelated targets in
> > the process).
> > 
> Yes, that was the idea.
> Which I'll get down to eventually; if only customers wouldn't have
> all these obnoxious issues no-one has ever seen...
> 
> And there is nothing wrong with reducing the timeout per se. It's
> just that the current error recovery strategy isn't well equipped to
> handle it :-)
> 
> Cheers,
> 
> Hannes


