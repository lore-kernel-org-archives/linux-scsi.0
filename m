From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 0/1] Apply segment size and segment boundary to integrity
 data
Date: Fri, 16 Jul 2010 10:30:34 +0200
Message-ID: <20100716083034.GA7474@schmichrtp.ibm.com>
References: <20100715153410.774329000@de.ibm.com>
 <yq1mxtspwab.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:50333 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935847Ab0GPIai (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2010 04:30:38 -0400
Content-Disposition: inline
In-Reply-To: <yq1mxtspwab.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 12:03:24PM -0400, Martin K. Petersen wrote:
> >>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
> 
> Christof> While experimenting with the data integrity support in the
> Christof> Linux kernel, i found that the block layer integrity code can
> Christof> send integrity data segments for a request that do not adhere
> Christof> to the queue limits.  The integrity data segment can be larger
> Christof> than queue_max_segment_size and the segment does not adhere to
> Christof> the queue_segment_boundary.
> 
> Correct.  That was a deliberate design decision.
> 
> Modern HBAs allow essentially indefinite chaining and our block layer
> segmentation controls are to some extent legacy baggage.  I did not want
> to put in a set of constraints on the DI scatterlist because I was
> afraid it would encourage vendors to actually them.
> 
> 
> Christof> It appears to me that the right way would be to apply the same
> Christof> restrictions that are in place for data segments also to
> Christof> integrity data segments. The patch works for my experiments
> Christof> and applies on top of the current Linux tree (2.6.35-rc5).
> 
> Who says constraints on the integrity scatterlist are the same as on the
> data ditto?  In my experience they are not.  If you must do this, then
> the DI constraints should be separate from the data segmentation ones.
> But I'm interested in what motivated this change to begin with.

The motivation stems from research how the integrity data can be
mapped to the hardware interface used by the zfcp driver. When passing
data segments to the zfcp hardware controller, there is the constraint
that each data segment has a maximum size of 4k and a segment must not
cross a 4k boundary. Right now, this is done by reporting the
maximum segment size and segment boundary accordingly from zfcp. When
issuing a request, zfcp simply walks the sg list and passes the
segments to the hardware controller, no mapping or readjustment is
necessary in the driver.

Adding integrity data to this interface implies that the integrity
data segments are passed the same way and with the same restrictions.
integrity data segments.  In fact, i am planning to post an
experimental patch for zfcp for upstream inclusion. While this is
still research, it does not affect non-integrity I/O and it will ease
future work on the integrity data mapping for zfcp.

Maybe my thinking is too much with the zfcp hardware interface where
it is obvious to have the same constraints for everything passed along
to the hardware. Another motivation is that i do not want to have the
need in the driver to re-map or copy data segments, when the block
layer already has a generic method of doing this.

What would be the right approach for hardware that has specific
constraints for integrity data? Add an interface for reporting
integrity data constraints independently of constraints for regular
data?

> Your change also has repercussions when merging requests and bios.  We'd
> need to honor the DI segmentation constraints when merging.  Otherwise
> we may end up going beyond the controller limits when mapping the sgl.

Meaning the integrity data sg list would have more entries than
max_segments? I have not seen this during my experiments, but then i
likely have not hit every case of a possible request layout.

Christof
