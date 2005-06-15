From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] ipr: Fix for adapter shutdown issue
Date: Wed, 15 Jun 2005 11:44:59 -0500
Message-ID: <1118853899.5045.39.camel@mulgrave>
References: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com>
	 <1118849292.5045.27.camel@mulgrave>  <42B04A9C.7050503@us.ibm.com>
	 <1118850458.5045.34.camel@mulgrave>  <42B05330.7050406@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:7593 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261218AbVFOQpD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 12:45:03 -0400
In-Reply-To: <42B05330.7050406@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, haren@us.ibm.com

On Wed, 2005-06-15 at 11:11 -0500, Brian King wrote:
> System crash and controlled power off are two different things. Yes, if the
> adapter is not told about the shutdown so it can flush its cache, the
> data will be maintained, but it can only be maintained for as long as
> the battery lasts. Currently, with 2.6.12-rc, if you do a normal power off
> and leave the system powered off for a long enough period of time (usually
> a week or so, depending on the battery on the card), you will suffer data
> loss. This is not acceptable. With 2.6.11, the adapter is told to flush
> the write cache on a controlled power off, so the system can remain powered
> off indefinitely with no data loss.
> 
> Regarding supporting the sync cache command to a disk array, I did consider
> requesting support be added to the adapter microcode, but decided against it
> since it would make a RAID array perform horribly and it did not seem to be
> the appropriate model to follow for NV write cache. Some of the ipr adapters
> have over 500 MB of write cache, which can take an awful long time to flush,
> much longer than you would want for a journal barrier. So, all the barrier/
> SYNC_CACHE code works great for a volatile write cache on a disk, but
> doesn't necessarily seem like the best model for large non-volatile write
> caches for RAID adapters.

Well, I still think you're operating unsafely ... some people let these
batteries run out, you know ...

To fix this, add a

blk_queue_ordered(sdev->request_queue, QUEUE_ORDERED_NONE);

to the slave configure routine for each of the devices that doesn't
synchronize the cache.  That should correct the SCSI layer assumptions.

James


