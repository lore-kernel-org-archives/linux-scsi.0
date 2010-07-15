From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [patch 0/1] Apply segment size and segment boundary to integrity
 data
Date: Thu, 15 Jul 2010 10:14:56 -0600
Message-ID: <4C3F3400.7060005@kernel.dk>
References: <20100715153410.774329000@de.ibm.com> <yq1mxtspwab.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43028 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933646Ab0GOQPE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2010 12:15:04 -0400
In-Reply-To: <yq1mxtspwab.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 07/15/2010 10:03 AM, Martin K. Petersen wrote:
>>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
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

That sounds like a very batch design decision. Either the limits are
explicitly given and different, or if not we have to assume that they
are the same as the data limits at least.

So do they have limits or not? Essentially indefinite, what does that
mean? If they are limited, then we must have settings to cope and map
around those. If these limits are not the same as the regular data
limits, then those limits could be separate.

> Christof> It appears to me that the right way would be to apply the same
> Christof> restrictions that are in place for data segments also to
> Christof> integrity data segments. The patch works for my experiments
> Christof> and applies on top of the current Linux tree (2.6.35-rc5).
> 
> Who says constraints on the integrity scatterlist are the same as on the
> data ditto?  In my experience they are not.  If you must do this, then
> the DI constraints should be separate from the data segmentation ones.
> But I'm interested in what motivated this change to begin with.

Yes me too, what bug triggered this patch?

-- 
Jens Axboe

