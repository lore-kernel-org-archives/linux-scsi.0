From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH v3 4/6] [SCSI] Generate uevents for certain Unit
 Attention codes
Date: Mon, 24 Jun 2013 10:11:15 -0400
Message-ID: <1372083075.3871.31.camel@localhost.localdomain>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com>
	 <1371663761-22481-5-git-send-email-emilne@redhat.com>
	 <1371667700.2409.82.camel@dabdike>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab3FXOLS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jun 2013 10:11:18 -0400
In-Reply-To: <1371667700.2409.82.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>

On Wed, 2013-06-19 at 18:48 +0000, James Bottomley wrote:
> On Wed, 2013-06-19 at 13:42 -0400, Ewan D. Milne wrote:
> > From: "Ewan D. Milne" <emilne@redhat.com>
> > 
> > Generate a uevent on the scsi_target object when the following
> > Unit Attention ASC/ASCQ code is received:
> > 
> >     3F/0E  REPORTED LUNS DATA HAS CHANGED
> > 
> > Generate a uevent on the scsi_device object when the following
> > Unit Attention ASC/ASCQ codes are received:
> > 
> >     2A/01  MODE PARAMETERS CHANGED
> >     2A/09  CAPACITY DATA HAS CHANGED
> >     38/07  THIN PROVISIONING SOFT THRESHOLD REACHED
> > 
> > All uevent generation is aggregated and rate-limited so that any
> > individual event is delivered no more than once every 2 seconds.
> 
> Why?  What causes you to think these events would be repeated on a
> massive scale.  Mode and Capacity changes are signalled only once per
> actual change, which doesn't occur very often.  SBC-3 says that the TP
> thresholds are only signalled once but may be signalled again after a
> reset.  In general, T10 treats UA as exceptional conditions ... there's
> no reason to think they keep repeating.

Well, the concern I had is that since a UA can theoretically be reported
on every command, a malfunctioning device could quickly overload udevd.
I have seen cases where udevd gets significantly behind when processing
a flood of events, and didn't want to make that worse.  Kay had concerns
about that when Hannes was working on this a while back, I believe.
I also didn't want other events to get lost if UA events filled up the
NL queue to udevd in userspace.

The other thing that aggregation helps with is when every LUN on a
target says REPORTED LUNS DATA HAS CHANGED.  Some storage arrays allow
hundreds of LUNS on a target, and I think they will all report the UA
if the LUN provisioning to the host is changed.  There is a mode that
can be used to suppress this, and only report one UA, but I don't know
if all storage arrays support it.  Now, granted, the UAs will only be
reported by each LUN when they receive a command, so this could happen
at any time in the future, but unfortunately that is the way SCSI works.

Of course, perhaps it would be better to provide a rate limit or
aggregation mechanism in the uevent code, rather than in its callers.
I'm not sure what it would take to get that to happen, I'll look at it.

> 
> Dumping all the hand rolled rate limit code would simplify the patch
> quite a lot.

Yes, it would be nice if there were a way to avoid it.

> 
> > Log kernel messages when the following Unit Attention ASC/ASCQ
> > codes are received:
> > 
> >     2A/xx  PARAMETERS CHANGED
> >     3F/03  INQUIRY DATA HAS CHANGED
> >     3F/xx  TARGET OPERATING CONDITIONS HAVE CHANGED
> > 
> > Also changed the kernel log messages on existing Unit Attention
> > codes, to remove text that indicates that the conditions were not
> > handled in any way (since they are now handled in some way) and
> > reflect the wording used in SPC-4.
> 
> This isn't a good idea because
> 
>      1. They might not be acted on if there's no actual listener for the
>         uevent
>      2. Anyone currently using a log message reaper to process the event
>         (which is currently the only way of doing it) would now miss it
>         because the log message has changed.

I'll leave the messages alone, then.  It just looked wierd to me.

> 
> > Also log a kernel message when the a scsi device reports a Unit
> > Attention queue overflow, indicating that status has been lost.
> > 
> > These changes are only enabled when the kernel config option
> > CONFIG_SCSI_ENHANCED_UA is set.  Otherwise, the behavior is the
> > same as before, including the existing kernel log messages.
> > However, the detection of these conditions was moved to be earlier
> > in scsi_check_sense(), because the code was not always reached.
> > 
> > Added a new exported function scsi_report_sense() to allow drivers
> > to report sense data that is not associated with a SCSI command.
> 
> No: we don't add APIs until there are consumers.  The refactor into
> scsi_report_sense is fine, just don't add the export or prototype until
> someone comes along with a use case.

Sure, I'll remove the export.  I added it because an earlier reviewer
asked for it, but they can add the export later if they need it.

Thanks for your comments.  I'll send a revised patch.  I'll need to
think about the rate limit concerns a bit more first.

> 
> James
> 


