From: scameron@beardog.cce.hp.com
Subject: Re: SCSI mid layer and high IOPS capable devices
Date: Fri, 14 Dec 2012 15:06:45 -0600
Message-ID: <20121214210645.GV20898@beardog.cce.hp.com>
References: <20121211000013.GI23107@beardog.cce.hp.com> <50C9F2B9.4050500@acm.org> <20121213172513.GH20898@beardog.cce.hp.com> <50CA0692.2010903@acm.org> <20121213164912.GA28496@infradead.org> <50CAF502.3070300@acm.org> <20121214164421.GQ20898@beardog.cce.hp.com> <50CB50A9.1050202@acm.org> <20121214195533.GS20898@beardog.cce.hp.com> <50CB7DF8.5020002@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:22532 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab2LNUGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2012 15:06:46 -0500
Content-Disposition: inline
In-Reply-To: <50CB7DF8.5020002@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, dab@hp.com, scameron@beardog.cce.hp.com

On Fri, Dec 14, 2012 at 08:28:56PM +0100, Bart Van Assche wrote:
> On 12/14/12 20:55, scameron@beardog.cce.hp.com wrote:
> >It's not so much that they are re-ordered as that there is no controlled
> >ordering to begin with because multiple cpus are submitting to multiple
> >hardware queues concurrently.  If you have 12 requests coming in on 12
> >cpus to 12 hardware queues to the device, it's going to be racy as to
> >which request is processed first by the device -- and this is fine, the
> >hardware queues are independent of one another and do not need to worry
> >about each other.  This is all to provide a means of getting enough 
> >commands
> >on the device to actually keep it busy.  A single cpu can't do it, the
> >device is too fast.  If you have ordering dependencies such that request
> >A must complete before request B completes, then don't submit A and B
> >concurrently, because if you do submit them concurrently, you cannot tell
> >whether A or B will arrive into the device first because they may go into
> >it via different hardware queues.
> 
> It depends on how these multiple queues are used. If each queue would 
> e.g. be associated with a disjoint LBA range of the storage device then 
> there wouldn't be a risk of request reordering due to using multiple 
> hardware queues.

They are not associated with disjoint LBA ranges. They are associated
with CPUs on the submission side, there's a submit queue per cpu, and
msix vectors on the completion side (also a completion queue per cpu).

The point of the queues is only to provide a wide enough highway to
allow enough requests to be shoved down to the device fast enough
and completed back to the host fast enough that the device can be kept
reasonably busy, instead of being starved for work to do.  There is
no distinction about what the requests may do based on what hardware
i/o queue they come in on (e.g. no lba range partitioning). All the
i/o queues are equivalent.

Pretty much all current storage devices, disk drives and the devices I'm
talking about in particular do depend on the low level driver and storage
devices being permitted to re-order requests.  So I don't think the discussion
about drivers and devices that *do not* reorder requests (which drivers and devices
would those be?) is very related to the topic of how to get the scsi mid layer
to provide a wide enough highway for requests destined for very low latency
devices.

-- steve

