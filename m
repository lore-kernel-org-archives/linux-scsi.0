From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCHSET] block: fix PIO cache coherency bug, take 2
Date: Mon, 05 Jun 2006 09:27:36 -0500
Message-ID: <1149517656.3489.15.camel@mulgrave.il.steeleye.com>
References: <1149392479501-git-send-email-htejun@gmail.com>
	 <20060604204444.GF4484@flint.arm.linux.org.uk>
	 <20060604222347.GG4484@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20060604222347.GG4484@flint.arm.linux.org.uk>
Sender: linux-ide-owner@vger.kernel.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Tejun Heo <htejun@gmail.com>, Jens Axboe <axboe@suse.de>, Dave Miller <davem@redhat.com>, bzolnier@gmail.com, james.steward@dynamicratings.com, jgarzik@pobox.com, mattjreimer@gmail.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, lkml <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2006-06-04 at 23:23 +0100, Russell King wrote:
> I'll add to this statement that the cache flushing on ARM is only
> ever required when the page ends up in userspace - if we're reading
> a page into the page cache to throw it out via NFS or sendfile then
> the cache flush is a complete waste of time.

Right .. and this is the scenario.  There are two cases where devices
kmap a user page into kernel space and then proceed to read from or
write to it (flush_dcache_page() is specifically for the latter because
the user won't see the data the kernel just wrote unless this happens
because kernel and user addresses aren't congruent on parisc).

The first case is manufactured data (such as command emulation) and the
second is pio data rather than DMA (such as command re-completion or
IDE).

> In this respect, I continue to believe that the way ARM (in principle)
> does flush_dcache_page() is what is required here - if the page has
> not been mapped into userspace, it merely marks the page as containing
> dirty cache lines, and the resulting cache maintainence will only
> happen when (and if) the page really does get mapped into userspace.

For this particular scenario, the page is almost always mapped initially
in user space because the user is requesting the I/O to a given
userspace address ... get_user_pages() ensures that it is allocated and
flushed before being passed to IDE or SCSI.

The problem on parisc, however, is not that userspace doesn't see the
page as dirty, it's that we've dirtied the page through the kernel
mappings, so userspace itself cannot possibly see the change until the
cache over the kernel address is flushed (the userspace and kernel space
addresses are not congruent in our cache scheme, so get separate cache
lines).

James


