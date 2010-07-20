From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 0/1] Apply segment size and segment boundary to integrity
 data
Date: Tue, 20 Jul 2010 11:28:50 +0200
Message-ID: <20100720092850.GA4547@schmichrtp.mainz.de.ibm.com>
References: <20100715153410.774329000@de.ibm.com>
 <yq1mxtspwab.fsf@sermon.lab.mkp.net>
 <20100716083034.GA7474@schmichrtp.ibm.com>
 <yq1bpa292wy.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:40328 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab0GTJ2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Jul 2010 05:28:53 -0400
Content-Disposition: inline
In-Reply-To: <yq1bpa292wy.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 12:45:49AM -0400, Martin K. Petersen wrote:
> >>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
> 
> Christof,
> 
> Christof> The motivation stems from research how the integrity data can
> Christof> be mapped to the hardware interface used by the zfcp
> Christof> driver. When passing data segments to the zfcp hardware
> Christof> controller, there is the constraint that each data segment has
> Christof> a maximum size of 4k and a segment must not cross a 4k
> Christof> boundary.
> 
> Ok.
> 
> 
> Christof> Right now, this is done by reporting the maximum segment size
> Christof> and segment boundary accordingly from zfcp. When issuing a
> Christof> request, zfcp simply walks the sg list and passes the segments
> Christof> to the hardware controller, no mapping or readjustment is
> Christof> necessary in the driver.
> 
> In that case I don't really have a problem with adhering to the queue
> segment size and segment boundary for the integrity metadata.  As long
> as we avoid using the max number of data segments to cap the integrity
> scatterlist because that'll definitely break a lot of stuff.
> 
> Does the zfcp hardware have scatterlist length constraints?

Yes. There is a hardware limit for the maximum number of scatterlist
entries the driver can send to the hardware at the same time. For
adding integrity data, we have to come up with a way to map both,
integrity data and user data in the same hardware request.

This is the experimental zfcp integrity data patch i sent for upstream
inclusion: http://marc.info/?l=linux-scsi&m=127928781200392&w=2 The
approach is that the driver has to adhere to the hardware constraint
of sum of all data segments (user plus integrity data). To have a
simple approach that covers the case with one integrity data segment
per user data segment, we only report half the size for the
scatterlist length when running DIX. This guarantees that the other
half can be used for integrity data.

> >> Your change also has repercussions when merging requests and bios.
> >> We'd need to honor the DI segmentation constraints when merging.
> >> Otherwise we may end up going beyond the controller limits when
> >> mapping the sgl.
> 
> Christof> Meaning the integrity data sg list would have more entries
> Christof> than max_segments? I have not seen this during my experiments,
> Christof> but then i likely have not hit every case of a possible
> Christof> request layout.
> 
> It happens all the time.

Ok, i have to look into that as well. It would be an issue with the
approach we are looking at now: If there are max_segments data
segments, and more than max_segments integrity data segments, we will
overrun the hardware constraint.

Christof
