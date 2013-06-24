From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v3 4/6] [SCSI] Generate uevents for certain Unit
 Attention codes
Date: Mon, 24 Jun 2013 14:58:40 +0000
Message-ID: <1372085919.2013.25.camel@dabdike.int.hansenpartnership.com>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com>
	 <1371663761-22481-5-git-send-email-emilne@redhat.com>
	 <1371667700.2409.82.camel@dabdike>
	 <1372083075.3871.31.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:51363 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3FXO6l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jun 2013 10:58:41 -0400
In-Reply-To: <1372083075.3871.31.camel@localhost.localdomain>
Content-Language: en-US
Content-ID: <39B4A3A48705224C91DE9A4B989B2D54@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>

On Mon, 2013-06-24 at 10:11 -0400, Ewan Milne wrote:
> On Wed, 2013-06-19 at 18:48 +0000, James Bottomley wrote:
> > On Wed, 2013-06-19 at 13:42 -0400, Ewan D. Milne wrote:
> > > From: "Ewan D. Milne" <emilne@redhat.com>
> > > 
> > > Generate a uevent on the scsi_target object when the following
> > > Unit Attention ASC/ASCQ code is received:
> > > 
> > >     3F/0E  REPORTED LUNS DATA HAS CHANGED
> > > 
> > > Generate a uevent on the scsi_device object when the following
> > > Unit Attention ASC/ASCQ codes are received:
> > > 
> > >     2A/01  MODE PARAMETERS CHANGED
> > >     2A/09  CAPACITY DATA HAS CHANGED
> > >     38/07  THIN PROVISIONING SOFT THRESHOLD REACHED
> > > 
> > > All uevent generation is aggregated and rate-limited so that any
> > > individual event is delivered no more than once every 2 seconds.
> > 
> > Why?  What causes you to think these events would be repeated on a
> > massive scale.  Mode and Capacity changes are signalled only once per
> > actual change, which doesn't occur very often.  SBC-3 says that the TP
> > thresholds are only signalled once but may be signalled again after a
> > reset.  In general, T10 treats UA as exceptional conditions ... there's
> > no reason to think they keep repeating.
> 
> Well, the concern I had is that since a UA can theoretically be reported
> on every command, a malfunctioning device could quickly overload udevd.

We had devices in the 1990s that did this ... I haven't seen any for
years.  I take it the qualifier "theoretical" means you haven't actually
seen this behaviour from a current device in the field?

> I have seen cases where udevd gets significantly behind when processing
> a flood of events, and didn't want to make that worse.  Kay had concerns
> about that when Hannes was working on this a while back, I believe.
> I also didn't want other events to get lost if UA events filled up the
> NL queue to udevd in userspace.

The events you're reporting are infrequent in normal operation.  If the
device goes rogue and floods them, udev issues are likely to be the
least of our concerns.

The fact that we may generate a flood because we have a massive number
of LUNs which each report the infrequent event is a concern, but it
should be fixed without rate limiting, see below:

> The other thing that aggregation helps with is when every LUN on a
> target says REPORTED LUNS DATA HAS CHANGED.  Some storage arrays allow
> hundreds of LUNS on a target, and I think they will all report the UA
> if the LUN provisioning to the host is changed.  There is a mode that
> can be used to suppress this, and only report one UA, but I don't know
> if all storage arrays support it.  Now, granted, the UAs will only be
> reported by each LUN when they receive a command, so this could happen
> at any time in the future, but unfortunately that is the way SCSI works.

So fixing this problem is what's needed rather than a generic rate limit
mechanism.  We already have a rudimentary mechanism for suppressing the
flood of UAs we get on target reset ... reuse the same thing to make
sure we only get one REPORTED LUNS DATA HAS CHANGED per target.

Note there are some fixes required to the current mechanism:  Firstly it
should clear expecting_cc_ua on the first successful command that
doesn't return a UA to prevent spurious memory (just in case arrays try
to be clever) with an

if (unlikely(scmd->device->expecting_cc_ua))
        scmd->device->expecting_cc_ua = 0;

just so we don't dirty a cache line if it's unnecessary

> Of course, perhaps it would be better to provide a rate limit or
> aggregation mechanism in the uevent code, rather than in its callers.
> I'm not sure what it would take to get that to happen, I'll look at it.

My point is that once we get to rate limiting, we've lost ... we're
already dropping stuff that may be important, so lets begin without the
ratelimit code and instead fix the problems that may cause data floods
instead.

James

