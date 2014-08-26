From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Debugging scsi abort handling ?
Date: Tue, 26 Aug 2014 11:34:38 -0700
Message-ID: <1409078078.3812.25.camel@jarvis.lan>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com>
		 <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org>
		 <53FB1ACD.1040208@redhat.com> <53FB1D4F.5070606@redhat.com>
		 <53FB2083.9000208@redhat.com> <1408981299.17968.27.camel@jarvis.lan>
	 <53FC4193.4010808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50169 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752114AbaHZSek (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Aug 2014 14:34:40 -0400
In-Reply-To: <53FC4193.4010808@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Tue, 2014-08-26 at 10:13 +0200, Hans de Goede wrote:
> Hi,
> 
> On 08/25/2014 05:41 PM, James Bottomley wrote:
> > On Mon, 2014-08-25 at 13:39 +0200, Paolo Bonzini wrote:
> >> Il 25/08/2014 13:26, Hans de Goede ha scritto:
> >>> Thanks Bart and Paolo, your insights into this are greatly appreciated.
> >>>
> >>> So with uas there are separate usb transaction for cmd, data in, data out
> >>> and sense for each tag. At the time of abort, usually one of data in / data
> >>> out and a sense usb transaction will be outstanding.
> >>>
> >>> There already is logic in the driver to kill the data in / out transactions
> >>> if a sense gets returned (usually with an error) before they are done.
> >>>
> >>> So if I'm reading this correctly, then on a successful abort, the sense
> >>> transaction (if not already completed by the target) should be cancelled as
> >>> it will never complete, correct ?
> >>
> >> Yes.  More precisely, once the response IU comes back for the abort,
> >> there should be no more IUs for that task.  Figure 13 ("Multiple Command
> >> Example") in the UAS spec actually shows that.
> >>
> >> At least, that's what it should be like in theory.  I suspect firmware
> >> bugs will abound in this area, but at least you shouldn't be actively
> >> expecting an IU for an aborted task.
> > 
> > Just a note on this.  The abort area in all devices is where we have
> > scope for spec compliance issues.  Also in the old days abort itself
> > could trigger a firmware crash on some devices (including arrays).  The
> > problem is actually that the system is usually groaning because it's out
> > of memory within the controller.  That actually means that sending in
> > another task (the abort) causes greater pressure.  For this reason, some
> > device drivers choose to skip the abort step and head straight to reset.
> > For reset, you guarantee that all outstanding tasks for the unit are
> > killed.
> 
> Hmm, I like this idea, given the finickiness of the abort path in the uas
> driver, and that:
> 
> 1) We really have no proper way to test this
> 2) We already have some known issues there (we don't kill sense urbs atm,
>    and I've a note somewhere about a double free on some corner case
>    where an urb submit fails)
> 3)
> 3) In all the cases where I've managed to trip op an uas device the only
>    thing which actually worked to recover things was doing a usb reset
> 4) Aborts should not happen in the first place, so using a big hammer
>    when they do is not really a big problem, instead we should focus
>    on figuring out why they happen and fix the cause
> 
> I think that just dropping abort handling altogether is a good idea actually,
> so if there are no objections I'm just going to do that.
> 
> I can simply not set eh_abort_handler (aka set it to NULL), right ?

Just so you know, if you do this, error handling becomes much more
painful.  The abort handler can now handle aborting and retrying without
pausing the host.  The reset definitely stops the host and causes a big
and noticeable burp in processing.  However, there are hosts which have
to do it.

> ###
> 
> What about a logical unit reset ? Is that worth trying first? Or is that
> likely to just trip up more firmware bugs (uas == usb == cheap == lots of
> those) ?
> 
> Going straight to an usb device reset would significantly simplify the code,
> but is not really friendly toward other usb drivers for a multi-function
> uas device (of which I've seen no so far, but they are bound to happen).
> 
> So I guess that trying a logical unit reset first would probably be a good
> idea.

Yes, that's the eh_device_reset_handler() callback.

> I know that it works in non error conditions as I've inserted one (in my
> local tree only) in the probe path to test task management functions in
> general. It has never really been tested under error conditions since the
> uas code can only run one task management function at a time (there is 1
> tag reserved for task management functions)

Wait, could this also be your abort problem?  In the running abort
handler, we could get a scenario where we abort a bunch of commands at
the same time.

>  and in all error scenarios
> I've been able to test so far, the abort timed out, so the
> eh_device_reset_handler would always return FAILED (-EBUSY).
> 
> So showing my greeness wrt scsi again, what should I do with outstanding
> scsi commands at this time. Can I simply cancel all outstanding usb transactions
> (ie data in/out, sense) for all outstanding commands on the lun in question,
> wait for the cancellations to complete, and then issue the logical unit reset ?

For successful aborts, you can cancel the aborted commands (the device
should have forgotten about them).  For a successful device (lun) reset,
you can cancel all the commands on that LUN; for a target reset you
cancel all the commands on every LUN and so on.

> IOW will the lun have forgotten about any outstanding scsi commands after
> a successful logical unit reset ?

Yes.

> And what should I do with regards to calling the scsi_done function for the
> outstanding commands. I assume that when eh_device_reset_handler gets called,
> the scsi_done function for any outstanding commands should not be called,
> correct ?

correct ... although it won't matter if you do, the completion will be
treated as spurious (at least until the command is reissued).

> And what about a race when a command completes after all just before
> eh_device_reset_handler gets called, I assume that that is handled properly
> by the scsi core ?

Yes, it's actually mediated in the block layer.  As soon as the command
timeout fires, all normal completions are treated as spurious and error
handling begins (I don't have the command you're talking about is a
legitimate condition in the eh ... we treat it as success).

James


