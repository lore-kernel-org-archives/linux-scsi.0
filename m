From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Very slow throughput when using cdparanoia on two SATA CDROM
 drives with /dev/sr but not /dev/sg
Date: Fri, 21 Nov 2014 02:02:10 -0800
Message-ID: <20141121100210.GC8866@infradead.org>
References: <545B76B2.1020906@buttersideup.com>
 <20141107213723.GA5088@animx.eu.org>
 <20141120063420.GA18238@infradead.org>
 <546DA346.7050507@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42023 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaKUKCP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Nov 2014 05:02:15 -0500
Content-Disposition: inline
In-Reply-To: <546DA346.7050507@buttersideup.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tim Small <tim@buttersideup.com>
Cc: Wakko Warner <wakko@animx.eu.org>, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>

On Thu, Nov 20, 2014 at 08:16:06AM +0000, Tim Small wrote:
> On 20/11/14 06:34, Christoph Hellwig wrote:
> > Wakko, any chance you could resend a patch to remove the mutex from the
> > ioctl path?
> 
> I'm trying out some local changes which removes the ex-BKL mutex from
> sr_block_ioctl() in sr.c, and instead uses a per-drive mutex which I've
> added to cdrom_device_info (as per Arnd Bergmann/ James Bottomley's
> discussion here https://lkml.org/lkml/2012/2/28/305 ).
> 
> This seems to work in a quick test testing (simultaneous cdparanoia on
> 8-or-so drives took ~10 minutes, whereas last time I tried that it took
> more than 18 hours), but I've been short on time to do much more.
> 
> At first inspection, it looks like it's just the cdrom-specific ioctls
> in drivers/cdrom/cdrom.c which aren't safely preemptible (my conclusion
> based on the fact that scsi_ioctl etc. is called elsewhere without
> locking (e.g. from /dev/sg and /dev/sd devices - I haven't looked at ).

Yes, they are safe.  Even inside cdrom_ioctl very little locking is
required, but it might not be worth a lot of effort to go for fine
grained locking there.

> As a result, I was wondering about moving the mutex_lock / unlock, so
> that they wrap just the cdrom-specific ioctl calls instead, although I
> suspect there won't be a huge performance benefit from doing so, it
> would have the advantage that all the code related to the new mutex to
> be moved into cdrom.c

That sounds fine.  It gets the performance critical SG_IO out of the
critical region, and replaces the silly global lock in all the CDROM
drivers with a per-device lock colocated with the data protected.


Totally offtopic:  Jens, is it time to drop the silly paride driver?
