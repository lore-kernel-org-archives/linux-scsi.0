From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 14/15] block/bsg: move queue creation into bsg_setup_queue
Date: Wed, 11 Jan 2017 17:08:14 -0500
Message-ID: <20170111220813.GB19051@redhat.com>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
 <1484060780-15592-15-git-send-email-hch@lst.de>
 <20170111084218.GB6286@linux-x5ow.site>
 <20170111084512.GA6937@lst.de>
 <8810984d-9929-8937-e82c-94639fd0b8ea@suse.de>
 <20170111090112.GA7239@lst.de>
 <69ad74c4-2741-058a-97fa-3aa2b69571f4@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56638 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752234AbdAKWIO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 17:08:14 -0500
Content-Disposition: inline
In-Reply-To: <69ad74c4-2741-058a-97fa-3aa2b69571f4@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

On Wed, Jan 11 2017 at  4:37am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 01/11/2017 10:01 AM, Christoph Hellwig wrote:
> > On Wed, Jan 11, 2017 at 09:59:17AM +0100, Hannes Reinecke wrote:
> >> I'd advocate to discuss this at LSF.
> >> Now that Mike moved the bio-based mpath stuff back in things got even
> >> more complex.
> > 
> > Yeah.  If we'd _only_ have bio based support it would simplify things
> > a lot, but as a third parallel path it's not exactly making things easier.
> > 
> >> I'll be posting a patchset for reimplementing multipath as a stand-alone
> >> driver shortly; that'll give us a good starting point on how we want
> >> multipath to evolve.
> >>
> >> Who knows; we might even manage to move multipath out of device-mapper
> >> altogether.
> >> That would make Mike very happy, and I wouldn't mind, either :-)
> > 
> > Heh.  I'm curious how you want to do that while keeping existing setups
> > working, though.
> 
> which will become challenging, indeed.
> 
> ATM it's just a testbed on how things could work; we've got most of the
> required infrastucture in the kernel nowadays, so that we can just drop
> most of the complexity from the present multipath-tools mess.
> 
> In the end it might even boil down to update the existing device-mapper
> multipath implementation. We'll see.

Honestly, at this point I'm pretty confident you guys will never
actually produce a new NIH multipath.  You'll just threaten to for
_years_.

Joking aside, I think DM multipath would benefit from a more focused
separation from all the SCSI cruft that wormed its way in.  Factoring
that stuff out so that multipath can be more easily adapted/optimized
for use with leaner transports like NVMe-over-fabrics.

But NVMe-over-fabrics setups are still pretty rare (only a handful of
vendors are stepping up with requirements to support it) so details on
what change is needed to DM multipath is largely unknown to me.  But may
become clearer in the coming month.

Mike
