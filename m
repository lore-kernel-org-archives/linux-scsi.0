From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: 15 Jun 2004 14:54:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087329285.2048.94.camel@mulgrave>
References: <40CF0F9F.4050902@adaptec.com>
	<1087313492.1796.37.camel@mulgrave>  <40CF4A15.9060005@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:729 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265900AbUFOTys (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 15:54:48 -0400
In-Reply-To: <40CF4A15.9060005@adaptec.com>
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-06-15 at 14:12, Luben Tuikov wrote:
> > But what this basically does is force any implementor of
> > eh_cmd_timed_out to handle all timers themselves.  Given that a large
> > number of driver writers who try to do this get it wrong (mostly around
> > del_timer() and del_timer_sync()), I don't think this is such a good
> > idea.
> 
> True, it is not a good idea for all LLDD to use this interface.
> But a few capable LLDD exist who can make use of it (including
> non-native interconnect subsystems).
> 
> Also we can include a comment in there that in order to use
> this interface the driver has to <funny quote here>. ;-)

Really, no.  An "experts only" interface is asking for trouble.  A major
point about cleaning up the SCSI API is to encourage better driver
writing by making it difficult to user the API incorrectly.

> > Since we also already have the ability to modify the command times in
> > slave configure, is it really necessary to encourage the alteration of
> > SCSI timers in this way?
> 
> Keywords: optional, non-intrusive patch.  It merely adds an alternative
> to capable only drivers.  This patch DOES NOT modify SCSI Core.
> 
> I'm not talking about an overhaul of SCSI Core here, just an optional
> method which a capable driver could use.  It has no effect to the rest
> of SCSI Core or LLDDs.

I'm less interested in the amount of perturbation to the mid-layer than
I am in getting the API right.  I've really heard no arguments that
persuade me that turning over timer management to the LLDs is a good
thing to do.

What the argument has centered around is the fact that LLDs wish to do
operations to effect error recovery on their own.

The original proposal (by Christoph) was a simple notify that error
recovery was about to happen.

In the ensuing discussion there have been various changes to this
suggested, which seem to provide a framework for the solution:

1. Timer handling would still all be done in the mid-layer

2. Any driver supplying the notify function would have it called on
timer expiry.

3. The LLD communicates what action it wishes to be taken based on the
return value from the notify.  I suggest 3 possible return actions:

a. Do nothing and continue with error handling

b. I fixed the problem, complete the command immediately and proceed as
though nothing went wrong.

c. I need more time, reset the timer and notify me again when it fails.

For (c), I propose that we use the same timeout period, but increment
the retry count (and do this up to allowed retries plus one [so that
no-retry commands have one crack at being recovered by the LLD]) when
retries are exhausted, normal error handling would proceed on timer
expiry leading to certain failure of the command since it would be
ineligible to be retried.

what additional features do you need beyond this proposal?

James


