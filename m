From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] dm-mpath: always return reservation conflict
Date: Wed, 15 Jul 2015 15:01:14 +0300
Message-ID: <1436961674.31121.48.camel@HansenPartnership.com>
References: <1436959404-14035-1-git-send-email-hare@suse.de>
	 <1436960108.31121.41.camel@HansenPartnership.com>
	 <55A64980.3070304@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49663 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751796AbbGOMBV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2015 08:01:21 -0400
In-Reply-To: <55A64980.3070304@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Wed, 2015-07-15 at 13:52 +0200, Hannes Reinecke wrote:
> On 07/15/2015 01:35 PM, James Bottomley wrote:
> > On Wed, 2015-07-15 at 13:23 +0200, Hannes Reinecke wrote:
> >> If dm-mpath encounters an reservation conflict it should not
> >> fail the path (as communication with the target is not affected)
> >> but should rather retry on another path.
> >> However, in doing so we might be inducing a ping-pong between
> >> paths, with no guarantee of any forward progress.
> >> And arguably a reservation conflict is an unexpected error,
> >> so we should be passing it upwards to allow the application
> >> to take appropriate steps.
> > 
> > If I interpret the code correctly, you've changed the behaviour from the
> > current try all paths and fail them, ultimately passing the reservation
> > conflict up if all paths fail to return reservation conflict
> > immediately, keeping all paths running.  This assumes that the
> > reservation isn't path specific because if we encounter a path specific
> > reservation, you've altered the behaviour from route around to fail.
> > 
> That is correct.
> As mentioned in the path, the 'correct' solution would be to retry
> the offending I/O on another path.
> However, the current multipath design doesn't allow us to do that
> without failing the path first.
> If we were just retrying I/O on another path without failing the
> path first (and all paths would return a reservation conflict) we
> wouldn't know when we've exhausted all paths.
> 
> > The case I think the original code was for is SAN Volume controllers
> > which use path specific SCSI-3 reservations effectively to do traffic
> > control and allow favoured paths.  Have you verified that nothing we
> > encounter in the enterprise uses path specific reservations for
> > multipath shaping any more?
> > 
> Ah. That was some input I was looking for.
> With that patch I've assumed that persistent reservations are done
> primarily from userland / filesystem, where the reservation would
> effectively be done on a per-LUN basis.
> If it's being used from the storage array internally this is a
> different matter.
> (Although I'd be very interested how this behaviour would play
> together with applications which use persistent reservations
> internally; GPFS springs to mind here ...)
> 
> But apparently this specific behaviour wasn't seen that often in the
> field; I certainly never got any customer reports about mysteriously
> failing paths.

Have you already got this patch in SLES, if so, for how long?

> Anyway. I'll see if I can come up with something to restore the
> original behaviour.

Or a way of verifying that nothing in the current enterprise uses path
specific reservations ...  we can change the current behaviour as long
as nothing notices.

James


