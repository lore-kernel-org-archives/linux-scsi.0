From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Multipath failover handling (Was: Re: 2.6.24-rc3-mm1)
Date: Mon, 07 Jan 2008 11:57:47 -0600
Message-ID: <1199728667.3126.32.camel@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	 <47462F3C.3040700@googlemail.com>
	 <20071122201250.f957e280.akpm@linux-foundation.org>
	 <47466B5D.90607@googlemail.com>
	 <20071126221509.8f437b61.akpm@linux-foundation.org>
	 <1197390783.3812.19.camel@localhost.localdomain> <47624649.3040209@suse.de>
	 <1197642405.3154.71.camel@localhost.localdomain> <478231B7.7080508@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35908 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754708AbYAGR5y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 12:57:54 -0500
In-Reply-To: <478231B7.7080508@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, 2008-01-07 at 15:05 +0100, Hannes Reinecke wrote:
> James Bottomley wrote:
> > On Fri, 2007-12-14 at 10:00 +0100, Hannes Reinecke wrote:
> >> James Bottomley wrote:
> >>> On Mon, 2007-11-26 at 22:15 -0800, Andrew Morton wrote:
> >>>> OK, thanks.  I'll assume that James and Hannes have this in hand (or will
> >>>> have, by mid-week) and I won't do anything here.
> >>> Just to confirm what I think I'm going to be doing:  rebasing the
> >>> scsi-misc tree to remove this commit:
> >>>
> >>> commit 8655a546c83fc43f0a73416bbd126d02de7ad6c0
> >>> Author: Hannes Reinecke <hare@suse.de>
> >>> Date:   Tue Nov 6 09:23:40 2007 +0100
> >>>
> >>>     [SCSI] Do not requeue requests if REQ_FAILFAST is set
> >>>
> >>> And its allied fix ups:
> >>>
> >>> commit 983289045faa96fba8841d3c51b98bb8623d9504
> >>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> >>> Date:   Sat Nov 24 19:47:25 2007 +0200
> >>>
> >>>     [SCSI] fix up REQ_FASTFAIL not to fail when state is QUIESCE
> >>>
> >>> commit 9dd15a13b332e9f5c8ee752b1ccd9b84cb5bdf17
> >>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
> >>> Date:   Sat Nov 24 19:55:53 2007 +0200
> >>>
> >>>     [SCSI] fix domain validation to work again
> >>>
> >>> James
> >>>
> >>>
> >> Or just apply my latest patch (cf Undo __scsi_kill_request).
> >> The main point is that we shouldn't retry requests
> >> with FAILFAST set when the queue is blocked. AFAICS
> >> only FC and iSCSI transports set the queue to blocked,
> >> and use this to indicate a loss of connection. So any
> >> retry with queue blocked is futile.
> > 
> > I still don't think this is the right approach.
> > 
> > For link up/down events, those are direct pathing events and should be
> > signalled along a kernel notifier, not by mucking with the SCSI state
> > machine.
> Of course they will be signalled. And eventually we should patch up
> mutltipath-tools to read the exising events from the uevent socket.
> But even with that patch there is a quite largish window during
> which IOs will be sent to the blocked device, and hence will be
> stuck in the request queue until the timer expires.

But the assumption your code makes is that if REQ_FAILFAST is set then
it's a dm request ... and that's not true.  The code in question
negatively impacts other users of REQ_FAILFAST.  For every user other
than dm, the right thing to do is to wait out the block.

> > However, there's still devloss_tmo to consider ... even in
> > multipath, I don't think you want to signal path failure until
> > devloss_tmo has fired otherwise you'll get too many transient up/down
> > events which damage performance if the array has an expensive failover
> > model.
> > 
> Yes. But currently we have a very high failover latency as we always have
> to wait for the requeued commands to time-out.
> Hence we're damaging performance on arrays with inexpensive failover.

If it's a either/or choice between the two that's showing our current
approach to multi-path is broken.

> > The other problem is what to do with in-flight commands at the time the
> > link went down.  With your current patch, they're still stuck until they
> > time out ... surely there needs to be some type of recovery mechanism
> > for these?
> > 
> Well, the in-flight commands are owned by the HBA driver, which should
> have the proper code to terminate / return those commands with the
> appriopriate codes. They will then be rescheduled and will be caught
> like 'normal' IO requests.

But my point is that if a driver goes blocked, those commands will be
forced to wait the blocked timeout anyway, so your proposed patch does
nothing to improve the case for dm anyway ... you only avoid commands
stuck when a device goes blocked if by chance its request queue was
empty.

James


