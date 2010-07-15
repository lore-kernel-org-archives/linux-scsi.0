From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 0/1] Apply segment size and segment boundary to integrity data
Date: Thu, 15 Jul 2010 12:03:24 -0400
Message-ID: <yq1mxtspwab.fsf@sermon.lab.mkp.net>
References: <20100715153410.774329000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:32629 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834Ab0GOQEf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jul 2010 12:04:35 -0400
In-Reply-To: <20100715153410.774329000@de.ibm.com> (Christof Schmitt's message
	of "Thu, 15 Jul 2010 17:34:10 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

>>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:

Christof> While experimenting with the data integrity support in the
Christof> Linux kernel, i found that the block layer integrity code can
Christof> send integrity data segments for a request that do not adhere
Christof> to the queue limits.  The integrity data segment can be larger
Christof> than queue_max_segment_size and the segment does not adhere to
Christof> the queue_segment_boundary.

Correct.  That was a deliberate design decision.

Modern HBAs allow essentially indefinite chaining and our block layer
segmentation controls are to some extent legacy baggage.  I did not want
to put in a set of constraints on the DI scatterlist because I was
afraid it would encourage vendors to actually them.


Christof> It appears to me that the right way would be to apply the same
Christof> restrictions that are in place for data segments also to
Christof> integrity data segments. The patch works for my experiments
Christof> and applies on top of the current Linux tree (2.6.35-rc5).

Who says constraints on the integrity scatterlist are the same as on the
data ditto?  In my experience they are not.  If you must do this, then
the DI constraints should be separate from the data segmentation ones.
But I'm interested in what motivated this change to begin with.

Your change also has repercussions when merging requests and bios.  We'd
need to honor the DI segmentation constraints when merging.  Otherwise
we may end up going beyond the controller limits when mapping the sgl.

-- 
Martin K. Petersen	Oracle Linux Engineering
