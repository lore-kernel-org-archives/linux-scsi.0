From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Thu, 6 Nov 2003 09:36:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031106093600.A14526@infradead.org>
References: <B179AE41C1147041AA1121F44614F0B060ED62@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED62@AVEXCH02.qlogic.org>; from andrew.vasquez@qlogic.com on Tue, Nov 04, 2003 at 05:15:33PM -0800
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> 	o Slab cache allocations for driver SRBs.

this one is broken.  You kall kmem_cache_alloc and kmem_cache_free
under a spinlock which is not wrong (at least with GFP_ATOMIC) but useless.
You don't have a mempool so you will deadlock under load.
You have a kmem_cache_t per host which is unessecary, one in the driver is
enough.

> the source-type tarball format.  It's not worth the extra effort of
> building a separate drop-in kernel tarball, given the varying release
> periods of the driver.  Similar drop-in-kernel-tarball results can be
> had by:


Would be nice to unpack into a directory instead of CWD, like almost any
tarball does..

> Failover functionality is present in this distribution, at this time I
> do not foresee a policy change regarding its presence in the 8.x
> series driver.  The next beta release of 8.x will be failover-feature
> resync'd with our latest 6.x beta (6.07.xx).

So it won't get merged into 2.6.x.  Not that it would be likely given your
complete ignorance of the other TODO items.  Sometimes I really wish to
get some funding to work on a mergeable qla2xxx driver as it seems impossible
to get one from qlogic..

--
Christoph Hellwig <hch@lst.de>		-	Freelance Hacker
Contact me for driver hacking and kernel development consulting
