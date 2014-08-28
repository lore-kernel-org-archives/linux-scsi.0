From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 07:09:43 -0700
Message-ID: <1409234983.2475.2.camel@jarvis.lan>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com>
	 <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org>
	 <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de>
	 <53FF1EB8.9010700@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33687 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750756AbaH1OJo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 10:09:44 -0400
In-Reply-To: <53FF1EB8.9010700@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Paolo Bonzini <pbonzini@redhat.com>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2014-08-28 at 14:21 +0200, Hans de Goede wrote:
> Hi,
> 
> On 08/28/2014 02:04 PM, Hannes Reinecke wrote:
> > On 08/25/2014 01:15 PM, Paolo Bonzini wrote:
> >> Il 25/08/2014 12:28, Bart Van Assche ha scritto:
> >>>
> >>>  From SPC-4: "7.5.8 Control mode page [ ... ] A task aborted status (TAS)
> >>> bit set to zero specifies that aborted commands shall be terminated by
> >>> the device server without any response to the application client. A TAS
> >>> bit set to one specifies that commands aborted by the actions of an I_T
> >>> nexus other than the I_T nexus on which the command was received shall
> >>> be completed with TASK ABORTED status (see SAM-5)."
> >>
> >> Note the "aborted by the actions of an I_T nexus other than the I_T
> >> nexus on which the command was received".
> >>
> >> In practice, this means that TASK ABORTED should only happen if you use
> >> the CLEAR TASK SET tmf and TST is not set to 001b (i.e. _not_ to "per
> >> I_T nexus") in the Control mode page.  It should never happen for a pen
> >> drive.
> >>
> >> Setting TASK ABORTED aside, the important part is that an abort can do
> >> one of two things:
> >>
> >> - complete the command, and then eh_abort should return after the driver
> >> has noticed the completion and called the ->scsi_done callback for the
> >> Scsi_Cmnd*.
> >>
> >> - abort the command, and then the driver should never call the
> >> ->scsi_done callback for the Scsi_Cmnd*.
> >>
> > In practice we rely on the latter behaviour; when ->scsi_done is called while the command is under eh_abort _really bad things_
> > will happen.
> 
> Interesting, those very bad things may very well be exactly the things
> some uas users are seeing. But this sounds racy, I can stop a command
> from completing as the very first thing inside eh_abort, but I cannot
> stop it from completing when the scsi core is getting ready to call
> eh_abort, but eh_abort is not yet called.
> 
> Is there some flag I should check before calling scsi_done to avoid this
> race? And if so which locks should I hold (and why does scsi_done not do
> this check itself) ?
> 
> > As soon as eh_abort is called control is transferred back to the
> > SCSI midlayer, so any LLDD should never send completions for these
> > commands back to the midlayer.
> 
> I'm fine with not calling scsi_done from eh_abort, but I cannot guarantee
> that another thread will not complete the cmnd in the mean time before hand.

This is expected.  After error handling begins, the block layer ignores
all done callbacks for commands under EH.  You can get the situation
where we try to abort (or do other EH) on a command you think you've
already completed, but you just return success for that.

James


