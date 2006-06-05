From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCHSET] block: fix PIO cache coherency bug, take 2
Date: Mon, 05 Jun 2006 08:43:52 -0500
Message-ID: <1149515032.3489.4.camel@mulgrave.il.steeleye.com>
References: <1149392479501-git-send-email-htejun@gmail.com>
	 <20060604204444.GF4484@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060604204444.GF4484@flint.arm.linux.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, Jens Axboe <axboe@suse.de>, Dave Miller <davem@redhat.com>, bzolnier@gmail.com, james.steward@dynamicratings.com, jgarzik@pobox.com, mattjreimer@gmail.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2006-06-04 at 21:44 +0100, Russell King wrote:
> > I tried to implement flush_anon_page() too but didn't know what to
> do
> > with anon_vma object.
> 
> I'm not sure what this is about...

This was for fuse on parisc.  It should have no bearing on the current
IDE problem.  What it's trying to solve is the fact that
flush_dcache_page() doesn't necessarily flush anonymous pages (because
of the way the mappings list works).  However, in order to make an
anonymous page in user space visible via the kernel address, we have to
have it flushed (this is what fuse does to transfer data into pages).
So this API was introduced into the right places to permit that to
happen.   Most VIPT architectures are CAM based, so flush_dcache_page()
actually sweeps up all the anon pages as well.  However, if the
implementation (like parisc's) has to loop over page_mapping(page) then
it will likely need to implement flush_anon_page() for fuse to work.

James


