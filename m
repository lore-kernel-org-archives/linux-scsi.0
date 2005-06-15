From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/1] ipr: Fix for adapter shutdown issue
Date: Wed, 15 Jun 2005 11:11:28 -0500
Message-ID: <42B05330.7050406@us.ibm.com>
References: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com>	 <1118849292.5045.27.camel@mulgrave>  <42B04A9C.7050503@us.ibm.com> <1118850458.5045.34.camel@mulgrave>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:18865 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261207AbVFOQLa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 12:11:30 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j5FGBU3o372294
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 12:11:30 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5FGBT0E152322
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 10:11:29 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j5FGBTlk001348
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2005 10:11:29 -0600
In-Reply-To: <1118850458.5045.34.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, haren@us.ibm.com

James Bottomley wrote:
> On Wed, 2005-06-15 at 10:34 -0500, Brian King wrote:
> 
>>For scsi disks attached to an ipr adapter, the SYNCHRONIZE_CACHE command
>>gets sent to the disk and works just like when attached to any other
>>HBA. The ipr disk array devices, however, do not support the SYNC_CACHE command,
>>nor do they support the caching mode page, so SYNC_CACHE never gets sent.
>>So, the shutdown hook is needed to flush the adapter's battery backed write
>>cache for all attached disk arrays on system shutdown.
> 
> 
> Well, that means you have a whole lot more trouble in 2.6.12 than simply
> failing to flush a cache on shutdown.  The barrier code now uses cache
> synchronization commands, so if you crash the on-disk image will not be
> what a journalling filesystem expects.  As long as the battery keeps the
> information alive in the cache, I assume this corrects itself when ipr
> next powers up, but if you trusted this, you wouldn't be fussing about
> the shutdown cache flush, now would you?

System crash and controlled power off are two different things. Yes, if the
adapter is not told about the shutdown so it can flush its cache, the
data will be maintained, but it can only be maintained for as long as
the battery lasts. Currently, with 2.6.12-rc, if you do a normal power off
and leave the system powered off for a long enough period of time (usually
a week or so, depending on the battery on the card), you will suffer data
loss. This is not acceptable. With 2.6.11, the adapter is told to flush
the write cache on a controlled power off, so the system can remain powered
off indefinitely with no data loss.

Regarding supporting the sync cache command to a disk array, I did consider
requesting support be added to the adapter microcode, but decided against it
since it would make a RAID array perform horribly and it did not seem to be
the appropriate model to follow for NV write cache. Some of the ipr adapters
have over 500 MB of write cache, which can take an awful long time to flush,
much longer than you would want for a journal barrier. So, all the barrier/
SYNC_CACHE code works great for a volatile write cache on a disk, but
doesn't necessarily seem like the best model for large non-volatile write
caches for RAID adapters.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
