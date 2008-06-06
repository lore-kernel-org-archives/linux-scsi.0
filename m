From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Fri, 6 Jun 2008 15:02:05 +0100
Message-ID: <20080606140205.GF19246@shareable.org>
References: <patchbomb.1212643369@sermon.lab.mkp.net> <20080605062754.GQ2961@webber.adilger.int> <yq1od6fml2q.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:50902 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343AbYFFOCI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 10:02:08 -0400
Content-Disposition: inline
In-Reply-To: <yq1od6fml2q.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

Martin K. Petersen wrote:
> The phys_off value I export for the MD device is the offset for the
> first device.  But that does not imply that the other devices in the
> stripe have the same alignment.

There are setups where the offsets of subdevices are modulo-aligned
well for performance, and when they aren't.

When they conflict for poor performance, it's useful to be informed.

> I considered taking an approach similar to blk_queue_stack_limits()
> where you clamp using the existing values as you add more devices.

Makes some sense.

> The downside to that is that you really want to let the user know that
> there's a potential problem.

As long as the measurement presented is one which looks worse and
worse when you combine subdevices, they will see from the bad-looking
value.  A flag is a nice bonus, but the main thing is, e.g. "the
largest combined stripe size for the device is 8 sectors" due to
poor offset skew, instead of 1024 sectors, say.

> And requiring the user to scrounge
> through syslog to look for complaints isn't so happening.  I'd much
> rather do that in libdisk where it's easy to print a message about
> "Suboptimal layout, proceed with caution".

I agree, that is good.

Where it is due to specific values being not exactly right - like the
subdevice offset (or modulo-offset) in MD because it doesn't represent
all subdevices - it would be good for the info to have flags saying
which _specific_ values are not exactly right.

So that programs can choose their heuristics appropriately.  After
all, users will use suboptimal layouts, and still want the best
performance it can do.

-- Jamie
