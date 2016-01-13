From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 13 Jan 2016 11:54:13 -0500
Message-ID: <20160113165413.GB2933@redhat.com>
References: <56961493.5010901@suse.de>
 <56962BDB.4080509@dev.mellanox.co.il>
 <20160113154243.GA2563@redhat.com>
 <569678EA.3000000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbcAMQyP (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 11:54:15 -0500
Content-Disposition: inline
In-Reply-To: <569678EA.3000000@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On Wed, Jan 13 2016 at 11:18am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 01/13/2016 04:42 PM, Mike Snitzer wrote:
> >On Wed, Jan 13 2016 at  5:50am -0500,
> >Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
> >
> >>Another (adjacent) topic is multipath performance with blk-mq.
> >>
> >>As I said, I've been looking at nvme multipathing support and
> >>initial measurements show huge contention on the multipath lock
> >>which really defeats the entire point of blk-mq...
> >>
> >>I have yet to report this as my work is still in progress. I'm not sure
> >>if it's a topic on it's own but I'd love to talk about that as well...
> >
> >This sounds like you aren't actually using blk-mq for the top-level DM
> >multipath queue.  And your findings contradicts what I heard from Keith
> >Busch when I developed request-based DM's blk-mq support, from commit
> >bfebd1cdb497 ("dm: add full blk-mq support to request-based DM"):
> >
> >      "Just providing a performance update. All my fio tests are getting
> >       roughly equal performance whether accessed through the raw block
> >       device or the multipath device mapper (~470k IOPS). I could only push
> >       ~20% of the raw iops through dm before this conversion, so this latest
> >       tree is looking really solid from a performance standpoint."
> >
> >>>But in the end we should be able to do strip down the current (rather
> >>>complex) multipath-tools to just handle topology changes; everything
> >>>else will be done internally.
> >>
> >>I'd love to see that happening.
> >
> >Honestly, this needs to be a hardened plan that is hashed out _before_
> >LSF and then findings presented.  It is a complete waste of time to
> >debate nuance with Hannes in a one hour session.
> >
> >Until I implemented the above DM core changes hch and Hannes were very
> >enthusiastic to throw away the existing DM multipath and multipath-tools
> >code (the old .request_fn queue lock bottleneck being the straw that
> >broke the camel's back).  Seems Hannes' enthusiasm hasn't tempered but
> >his hand-waving is still in full form.
> >
> >Details matter.  I have no doubts aspects of what we have could be
> >improved but I really fail to see how moving multipathing to blk-mq is a
> >constructive way forward.
> >
> So what is your plan?
> Move the full blk-mq infrastructure into device-mapper?

1.
Identify what the bottleneck(s) are in current request-based DM blk-mq
support (could be training top-level blk_mq request_queue capabilities
based on underlying devices). 

2.
Get blk-mq to be the primary mode of operation (scsi-mq has a role here)
and then eliminate/deprecate the old .request_fn IO path in blk-core.
- this is a secondary concern, DM can happily continue to carry all
permutations of request_fn on blk-mq path(s), blk-mq on request_fn
path(s) and, blk-mq on blk-mq path(s)... but maybe a start is to make
the top-level request-based DM queue _only_ blk-mq -- so effectively 
set CONFIG_DM_MQ_DEFAULT=Y (and eliminate code that supports
CONFIG_DM_MQ_DEFAULT=N).

IMHO, we don't yet have justification to warrant the relatively drastic
change you're floating (pushing multipathing down into blk-mq).

If/when justification is made we'll go from there.

> From my perspective, blk-mq and multipath I/O handling have a lot in
> common (the ->map_queue callback is in effect the same ->map_rq
> does), so I still think it should be possible to leverage that
> directly.
> But for that to happen we would need to address some of the
> mentioned issues like individual queue failures and dynamic queue
> remapping; my hope is that they'll be implemented in the course of
> NVMe over fabrics.
> 
> Also note that my proposal is more with the infrastructure
> surrounding multipathing (ie topology detection and setup), so it's
> somewhat orthogonal to your proposal.

Sure, it is probabky best if focus is placed on where our current
offering can be incrementally improved.  If that means pushing some
historically userspace (multipath-tools) responsibilities down to the
kernel then we can look at it.

What I want to avoid is a shotgun blast of drastic changes.  That
doesn't serve a _very_ enterprise-oriented layer well at all.
