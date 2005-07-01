From: Jens Axboe <axboe@suse.de>
Subject: Re: Write cache on SATA drives?
Date: Fri, 1 Jul 2005 10:33:10 +0200
Message-ID: <20050701083308.GZ2243@suse.de>
References: <C664ABFF405D6A458806C03AA2E0FF6B0560E7CC@MKEMLVEM01.e2k.ad.ge.com> <20050701062416.GQ2243@suse.de> <m3acl7ym7f.fsf@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:9710 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263280AbVGAIbs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2005 04:31:48 -0400
Content-Disposition: inline
In-Reply-To: <m3acl7ym7f.fsf@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthias Andree <matthias.andree@gmx.de>
Cc: "Edwards, Scott (GE Healthcare)" <J.Scott.Edwards@ge.com>, linux-scsi@vger.kernel.org

On Fri, Jul 01 2005, Matthias Andree wrote:
> Jens Axboe <axboe@suse.de> writes:
> 
> > On Thu, Jun 30 2005, Edwards, Scott (GE Healthcare) wrote:
> >> Hello,
> >> 
> >> Can anyone tell me if the write cache on SATA drives are handled such
> >> that journaling file systems work correctly?  Back in the 2.6.5 -
> >> 2.6.7 time frame I had to disable the write cache to get ext3 to not
> >> trash things when the power was lost.  With kernel 2.6.10 would I
> >> still need to disable the write cache?
> >
> > With 2.6.12.x it should work, if you use ext3 or reiser and the
> > appropriate mount options (-o barrier=1 for ext3, barrier=flush for
> > reiserfs). 2.6.11 and earlier does not work on SATA.
> 
> I presume this means "libata" exclusively, no?

It means "SCSI without queueing" which I'm assuming is basically only
libata at this moment, at least if you count setups that have a non-zero
userbase :)

> Which is the oldest version where this works
> 
> 1. for SCSI (perhaps by adaptor)?

2.6.12, with the above restriction. I hope to lift that for .13/14, with
Tejuns barrier updates.

> 2. for traditional IDE (such as VIA 82*, PIIX_*)?

In SUSE kernels, for many years. Since 2.6.7/8'ish in Linus' kernels.

> 3. for RAID?

Not really safe, only for fsync.

> 4. for XFS or JFS?

XFS and JFS need minor updates, similar to what ext3 and reiser got.
Should take someone familiar with the code no more than an hour to do,
nobody has done it yet though.

> <http://home.pages.de/~mandree/linux/kernel/safe-write-caches.html>

One important update, the 'oe' in my name is not an ascii safe variant
of the real name, it really is spelled that way :)

-- 
Jens Axboe

