From: Dave Chinner <david@fromorbit.com>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Fri, 4 Jun 2010 12:02:43 +1000
Message-ID: <20100604020243.GE19651__6417.6244232387$1275617010$gmane$org@dastard>
References: <20100601162929.GC32708@parisc-linux.org>
 <20100601164750.GQ8980@think>
 <1275411293.21962.387.camel@mulgrave.site>
 <20100601180905.GR8980@think>
 <20100601184649.GE9453@laptop>
 <20100601193528.GV8980@think>
 <20100602032030.GF9453@laptop>
 <yq17hmhbmkb.fsf@sermon.lab.mkp.net>
 <20100602134121.GD6152@laptop>
 <20100603154634.GC8980@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bld-mail17.adl2.internode.on.net ([150.101.137.102]:35082 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751677Ab0FDCC7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2010 22:02:59 -0400
Content-Disposition: inline
In-Reply-To: <20100603154634.GC8980@think>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Matthew Wilcox <mat>

On Thu, Jun 03, 2010 at 11:46:34AM -0400, Chris Mason wrote:
> On Wed, Jun 02, 2010 at 11:41:21PM +1000, Nick Piggin wrote:
> > Closing the while it is dirty, while it is being written back window
> > still leaves a pretty big window. Also, how do you handle mmap writes?
> > Write protect and checksum the destination page after every store? Or
> > leave some window between when the pagecache is dirtied and when it is
> > written back? So I don't know whether it's worth putting a lot of effort
> > into this case.
> 
> So, changing gears to how do we protect filesystem page cache pages
> instead of the generic idea of dif/dix, btrfs crcs just before writing,
> which does leave a pretty big window for the page to get corrupted.
> The storage layer shouldn't care or know about that though, we hand it a
> crc and it makes sure data matching that crc goes to the media.

I think the only way to get accurate CRCs is to stop modifications
from occurring while the page is under writeback. i.e. when a page
transitions from dirty to writeback we need to unmap any writable
mappings on the page, and then any new modifications (either by the
write() path or through ->fault) need to block waiting for
page writeback to complete before they can proceed...

If we can lock out modification during writeback, we can calculate
CRCs safely at any point in time the page is not mapped. e.g. we
could do the CRC calculation at copy-in time and store it on new
pages. During writeback, if the page has not been mapped then the
stored CRC can be used. If it has been mapped (say writeable
mappings clear the stored CRC during ->fault) then we can
recalculate the CRC once we've transitioned the page to being under
writeback...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
