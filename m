From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: ahc_linux_map_seg() compile/style/data corruption fixes
Date: Wed, 14 May 2003 00:18:57 -0600
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <498302704.1052893137@aslan.scsiguy.com>
References: <20030514044934.GC29926@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030514044934.GC29926@holomorphy.com>
Content-Disposition: inline
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> ahc_linux_map_seg() has several style and compile-time issues:
> 
> (1) if (sizeof(bus_addr_t) > 4 && ...) linewraps oddly

See my other email.  Style is a personal issue.  I personally
think that trying to determine logical groupings by following a
jagged right column is much harder than following a formatted left
collumn.  In other words:

if ((*period == 0)
 || (syncrate->rate == NULL)
 || ((ahc->features & AHC_ULTRA2) != 0
  && (syncrate->sxfr_u2 == 0)))

Visually indicates the logical operator grouping, while this:

if ((*period == 0) ||
    (syncrate->rate == NULL) ||
    ((ahc->features & AHC_ULTRA2) != 0 &&
    (syncrate->sxfr_u2 == 0)))

Does not.

The driver is consistent in its use of this style.

> (2) ~0xFFFFFFFF is always 0; the check for being above 4GB never succeeds

Yes.

> (3) 0x100000000 overflows int and hence vanishes, causing a compile error
> 	on gcc-3.3 and effectively being identical to its replacement here

Actually, it overflows long and causes an error.  It must be promoted
to ULL.  Yes, this is a C99 thing, but this has been supported by GCC
for a very long time and much of the kernel already uses it.

> (4) constants describing the upper byte of the length are not used

In this function, no.  They are used elsewhere in the driver.  This
has been corrected in my patch.

> (5) return is a keyword, not a function

I'm fully aware of this.  You are again complaining about style.

> (6) uint32_t used instead of u32 (contrary to Linux conventions)

uint32_t is portable to any C99 compliant system.  u32 is not.  These
types were chosen to match those used by the driver core.  The driver
core must compile on systems other than Linux.

> (7) it's randomly panicking in a driver; at least complain in a comment

It's not random.  The case that it tests should never happen since Linux
claims that segments that cross a 4GB boundary will never be presented
to a PCI driver.

> This is basically a compilefix for axel@pearbough.net's compile failure,
> with some added cleanup. (2) should cause data corruption on x440,
> NUMA-Q, and ES7000 almost every time this is called, so I guess this
> qualifies as a runtime bugfix too. Oddly, I'm not seeing any even on
> 64GB NUMA-Q, so it's probably bouncing due to some other bug.

The driver does not bounce.  The reason you don't see this is because
Linux is not sending segments that cross a 4GB boundary.

> For the connoisseur, I've attached before/after disassemblies
> demonstrating that the if () whose failure is caused by (2) is a very,
> very, very real problem.

This was obvious from code inspection.

--
Justin
