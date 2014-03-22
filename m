From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND][PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an
 actual Kconfig
Date: Sat, 22 Mar 2014 15:59:11 -0700
Message-ID: <1395529151.2143.64.camel@dabdike.int.hansenpartnership.com>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org>
	 <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
	 <1395523881.2143.58.camel@dabdike.int.hansenpartnership.com>
	 <20140322222306.GM7528@n2100.arm.linux.org.uk>
	 <1395527860.2143.61.camel@dabdike.int.hansenpartnership.com>
	 <20140322225201.GN7528@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <20140322225201.GN7528@n2100.arm.linux.org.uk>
Sender: linux-ia64-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Laura Abbott <lauraa@codeaurora.org>, Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, x86@kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux390@de.ibm.com, sparclinux@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2014-03-22 at 22:52 +0000, Russell King - ARM Linux wrote:
> On Sat, Mar 22, 2014 at 03:37:40PM -0700, James Bottomley wrote:
> > On Sat, 2014-03-22 at 22:23 +0000, Russell King - ARM Linux wrote:
> > > On Sat, Mar 22, 2014 at 02:31:21PM -0700, James Bottomley wrote:
> > > > Perhaps now might be the time to ask which are the remaining
> > > > architectures that cannot do SG chaining and then we can fix them and
> > > > pull the whole thing out.
> > > 
> > > Not quite.  You're making the assumption that we can be sure that all
> > > the scatterlist users on an architecture have been converted - that's
> > > simply not true on ARM.
> > 
> > No I'm not, I said "now might be the time to ask which are the remaining
> > architectures that cannot do SG chaining"
> 
> And I'm disagreeing with that statement which implies that it's something
> that is an architecture wide property for any particular architecture.
> 
> Right now in mainline, if ARM has IOMMU support enabled, then SG_CHAIN
> support will also be enabled.  I've a patch out of tree which I've been
> using for years which enables SG_CHAIN for a particular SoC (Dove).
> Otherwise, it doesn't have support for SG_CHAIN.
> 
> PARISC on the other hand (as you list) has no support to enable SG_CHAIN
> under any circumstances.
> 
> Where we're disagreeing is whether this is something that is always-on or
> always-off for any particular architecture.

Actually, I don't disagree with that.  PA used to share sb_iommu with
ia64 (it's the same chipset for the HP versions), but we can't now
because ia64 is chained and we're not and there's no way to say chained
for this platform but not for these other more legacy ones.  If you have
a proposal for this, I'd be interested, so I don't have to do an all or
nothing conversion, but the config option isn't it because our platform
configuration is runtime determined (we usually select every driver and
let the actual one be chosen at runtime from the config table).

James


