From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-mpath: always return reservation conflict
Date: Wed, 15 Jul 2015 09:20:45 -0400
Message-ID: <20150715132045.GA13054@redhat.com>
References: <1436959404-14035-1-git-send-email-hare@suse.de>
 <1436960108.31121.41.camel@HansenPartnership.com>
 <55A64980.3070304@suse.de>
 <1436961674.31121.48.camel@HansenPartnership.com>
 <55A64EDC.1090600@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbbGONUr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jul 2015 09:20:47 -0400
Content-Disposition: inline
In-Reply-To: <55A64EDC.1090600@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@lst.de>, dm-devel@redhat.com, linux-scsi@vger.kernel.org, Ryan O'Hara <rohara@redhat.com>

On Wed, Jul 15 2015 at  8:15am -0400,
Hannes Reinecke <hare@suse.de> wrote:

> On 07/15/2015 02:01 PM, James Bottomley wrote:
> > On Wed, 2015-07-15 at 13:52 +0200, Hannes Reinecke wrote:
> >> On 07/15/2015 01:35 PM, James Bottomley wrote:
> >>> On Wed, 2015-07-15 at 13:23 +0200, Hannes Reinecke wrote:
> >>>> If dm-mpath encounters an reservation conflict it should not
> >>>> fail the path (as communication with the target is not affected)
> >>>> but should rather retry on another path.
> >>>> However, in doing so we might be inducing a ping-pong between
> >>>> paths, with no guarantee of any forward progress.
> >>>> And arguably a reservation conflict is an unexpected error,
> >>>> so we should be passing it upwards to allow the application
> >>>> to take appropriate steps.
> >>>
> >>> If I interpret the code correctly, you've changed the behaviour from the
> >>> current try all paths and fail them, ultimately passing the reservation
> >>> conflict up if all paths fail to return reservation conflict
> >>> immediately, keeping all paths running.  This assumes that the
> >>> reservation isn't path specific because if we encounter a path specific
> >>> reservation, you've altered the behaviour from route around to fail.
> >>>
> >> That is correct.
> >> As mentioned in the path, the 'correct' solution would be to retry
> >> the offending I/O on another path.
> >> However, the current multipath design doesn't allow us to do that
> >> without failing the path first.
> >> If we were just retrying I/O on another path without failing the
> >> path first (and all paths would return a reservation conflict) we
> >> wouldn't know when we've exhausted all paths.
> >>
> >>> The case I think the original code was for is SAN Volume controllers
> >>> which use path specific SCSI-3 reservations effectively to do traffic
> >>> control and allow favoured paths.  Have you verified that nothing we
> >>> encounter in the enterprise uses path specific reservations for
> >>> multipath shaping any more?
> >>>
> >> Ah. That was some input I was looking for.
> >> With that patch I've assumed that persistent reservations are done
> >> primarily from userland / filesystem, where the reservation would
> >> effectively be done on a per-LUN basis.
> >> If it's being used from the storage array internally this is a
> >> different matter.
> >> (Although I'd be very interested how this behaviour would play
> >> together with applications which use persistent reservations
> >> internally; GPFS springs to mind here ...)
> >>
> >> But apparently this specific behaviour wasn't seen that often in the
> >> field; I certainly never got any customer reports about mysteriously
> >> failing paths.
> > 
> > Have you already got this patch in SLES, if so, for how long?
> > 
> We haven't as of yet; I've come across this behaviour due to another
> issue. And before I were to put this into SLES I thought I should be
> asking those in the know ... persistent reservations _is_ an arcane
> topic, after all.
> I was just referring to the fact that I rarely got customer issues
> with persistent reservations; and those I get tend to be tape-centric.
> 
> >> Anyway. I'll see if I can come up with something to restore the
> >> original behaviour.
> > 
> > Or a way of verifying that nothing in the current enterprise uses path
> > specific reservations ...  we can change the current behaviour as long
> > as nothing notices.
> > 
> The only instance I know of is GPFS; someone in our company once
> wrote an HA agent using persistent reservations, but I'm not sure if
> it's deployed anywhere. But that agent is certainly aware of
> multipathing, and doesn't issue per-path reservations.
> (Well, actually it does, but it does it for every path :-)
> I would think the same goes for GPFS.
> 
> Incidentally, the SVC docs have a section about persistent
> reservations, but do not mention anything about internal use.
> So if it does it'll be opaque to the user, otherwise I would assume
> it to be mentioned there.

The main consumer of SCSI PR that I'm aware of is fence_scsi.  I don't
have specifics on whether the Clustering layers that use fence_scsi
(e.g. pacemaker) ever make use of per-path SCSI PR (cc'ing Ryan O'hara
who AFAIK mainatins fence_scsi).

Mike
