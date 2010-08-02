From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 0/1] Apply segment size and segment boundary to integrity
 data
Date: Mon, 2 Aug 2010 13:05:17 +0200
Message-ID: <20100802110517.GA4556@schmichrtp.mainz.de.ibm.com>
References: <20100715153410.774329000@de.ibm.com>
 <yq1mxtspwab.fsf@sermon.lab.mkp.net>
 <20100716083034.GA7474@schmichrtp.ibm.com>
 <yq1bpa292wy.fsf@sermon.lab.mkp.net>
 <20100720092850.GA4547@schmichrtp.mainz.de.ibm.com>
 <yq1y6d579fy.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:32801 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0HBLFT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2010 07:05:19 -0400
Content-Disposition: inline
In-Reply-To: <yq1y6d579fy.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 12:20:01AM -0400, Martin K. Petersen wrote:
> >>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
> 
> Christof> To have a simple approach that covers the case with one
> Christof> integrity data segment per user data segment, we only report
> Christof> half the size for the scatterlist length when running
> Christof> DIX. This guarantees that the other half can be used for
> Christof> integrity data.
> 
> Yup, a few of our partners did something similar.
> 
> My concern is the scenario where we submit lots of 512-byte writes that
> get merged into (in your case) 4 KB segments.  Each of those 512-byte
> writes could come with an 8-byte integrity metadata tuple.  And so you'd
> need 8 DI scatterlist elements per data element.
> 
> 
> Christof> Meaning the integrity data sg list would have more entries
> Christof> than max_segments? I have not seen this during my experiments,
> Christof> but then i likely have not hit every case of a possible
> Christof> request layout.
> 
> dd to the block device is usually a good way to issue long scatterlists.
> 
> 
> Christof> Ok, i have to look into that as well. It would be an issue
> Christof> with the approach we are looking at now: If there are
> Christof> max_segments data segments, and more than max_segments
> Christof> integrity data segments, we will overrun the hardware
> Christof> constraint.
> 
> Ok.

After looking at the given facts, this seems to be the missing part:
The zfcp hardware interface has an maximum number of data segments
that can be part of one request. In the experimental zfcp DIF/DIX
patch (now in scsi-misc), zfcp reserves half of the data segments
for integrity data. But if small bios have been merged until hitting
queue_max_segments, there may be more integrity data segments.

To summarize the limits i see in the zfcp hardware:
- Maximum size of 4k per segment
- The segments must not cross page boundaries
- The number of segments per request is limited

My preferred approach would be to set the limits on the queue, so that
the request adheres to the hardware limitations and can be passed on
directly to the hardware. I would like to avoid splitting large
segments in the driver code, and i especially want to avoid having to
copy the integrity data to new buffers to adhere to the hardware
constraints.

Looking at the block layer, the number of integrity data segments
could be limited with an additional check in ll_new_hw_segment.

What would be the preferred approach for handling the integrity data
limits in the block layer? Introduce new queue limits for integrity
data, or assume that the limits for integrity data are the same as for
user data? I can update my patch accordingly and include a check for
the maximum number of segments.

Christof
