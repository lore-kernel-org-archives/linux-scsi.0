From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [RESEND][PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an
	actual Kconfig
Date: Mon, 24 Mar 2014 10:45:10 +0000
Message-ID: <20140324104510.GQ7528@n2100.arm.linux.org.uk>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org> <1395512032-20575-2-git-send-email-lauraa@codeaurora.org> <1395523881.2143.58.camel@dabdike.int.hansenpartnership.com> <20140322222306.GM7528@n2100.arm.linux.org.uk> <1395527860.2143.61.camel@dabdike.int.hansenpartnership.com> <20140322225201.GN7528@n2100.arm.linux.org.uk> <1395529151.2143.64.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:36341 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752515AbaCXKpt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Mar 2014 06:45:49 -0400
Content-Disposition: inline
In-Reply-To: <1395529151.2143.64.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Laura Abbott <lauraa@codeaurora.org>, Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, x86@kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux390@de.ibm.com, sparclinux@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org

On Sat, Mar 22, 2014 at 03:59:11PM -0700, James Bottomley wrote:
> On Sat, 2014-03-22 at 22:52 +0000, Russell King - ARM Linux wrote:
> > And I'm disagreeing with that statement which implies that it's something
> > that is an architecture wide property for any particular architecture.
> > 
> > Right now in mainline, if ARM has IOMMU support enabled, then SG_CHAIN
> > support will also be enabled.  I've a patch out of tree which I've been
> > using for years which enables SG_CHAIN for a particular SoC (Dove).
> > Otherwise, it doesn't have support for SG_CHAIN.
> > 
> > PARISC on the other hand (as you list) has no support to enable SG_CHAIN
> > under any circumstances.
> > 
> > Where we're disagreeing is whether this is something that is always-on or
> > always-off for any particular architecture.
> 
> Actually, I don't disagree with that.  PA used to share sb_iommu with
> ia64 (it's the same chipset for the HP versions), but we can't now
> because ia64 is chained and we're not and there's no way to say chained
> for this platform but not for these other more legacy ones.  If you have
> a proposal for this, I'd be interested, so I don't have to do an all or
> nothing conversion, but the config option isn't it because our platform
> configuration is runtime determined (we usually select every driver and
> let the actual one be chosen at runtime from the config table).

At runtime, it's obviously a lot harder to resolve.  However, that's not
what we're trying to do with this patch.

The main issue is that Laura is trying to add SG chain support to ARM64.
At the moment, ARM64 uses the asm-generic version of scatterlist.h
directly.

Her first spin of the patch involved creating
arch/arm64/include/asm/scatterlist.h, which was nothing more than an
include of the asm-generic header file of the same name, and the
definition of ARCH_HAS_SG_CHAIN.  That seemed to be extremely wasteful
and sub-optimal way to handle this.

Moving this symbol into the Kconfig means that ARM64 no longer has to
have this additional file (and probably a bunch of other architectures
fall into that same camp) and the ARM specific CONFIG_ARM_HAS_SG_CHAIN
can be eliminated in favour of the now generic cross-arch config symbol.

We have plenty of other Kconfig symbols which control similar features
throughout the kernel source, there is no reason that this one should
not be the same.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
