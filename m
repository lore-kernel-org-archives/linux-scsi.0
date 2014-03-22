From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RESEND][PATCH 1/2] lib/scatterlist: Make ARCH_HAS_SG_CHAIN an
 actual Kconfig
Date: Sat, 22 Mar 2014 15:37:40 -0700
Message-ID: <1395527860.2143.61.camel@dabdike.int.hansenpartnership.com>
References: <1395512032-20575-1-git-send-email-lauraa@codeaurora.org>
	 <1395512032-20575-2-git-send-email-lauraa@codeaurora.org>
	 <1395523881.2143.58.camel@dabdike.int.hansenpartnership.com>
	 <20140322222306.GM7528@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <20140322222306.GM7528@n2100.arm.linux.org.uk>
Sender: linux-ia64-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Laura Abbott <lauraa@codeaurora.org>, Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, x86@kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org, linux390@de.ibm.com, sparclinux@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-ia64@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 2014-03-22 at 22:23 +0000, Russell King - ARM Linux wrote:
> On Sat, Mar 22, 2014 at 02:31:21PM -0700, James Bottomley wrote:
> > Perhaps now might be the time to ask which are the remaining
> > architectures that cannot do SG chaining and then we can fix them and
> > pull the whole thing out.
> 
> Not quite.  You're making the assumption that we can be sure that all
> the scatterlist users on an architecture have been converted - that's
> simply not true on ARM.

No I'm not, I said "now might be the time to ask which are the remaining
architectures that cannot do SG chaining" I think it's time to list them
so we know what work remains.  I know we've got a bunch in parisc (all
of our iommu code in driver/parisc - about 5 different ones - are
unconverted).  However, the conversion is pretty simple; it's mostly
replacing sglist++ with sglist=sg_next(sglist)

>   We have some which have, and some which still
> have not been audited.
> 
> The cases that get us here would be old platform DMA code which walks
> scatterlists handed to it from drivers - stuff like
> arch/arm/mach-rpc/dma.c (which probably can cope), and drivers/scsi/arm/*
> (which definitely can't because of their SCSI pointers save/restore
> handling message.)  I know that's one case where SG_CHAIN definitely
> isn't supported on ARM.
> 
> So, we had decided not to enable it, but this means that new stuff
> isn't benefitting from this.  I've recently asked arm-soc to enable
> it for the modern multi-platform builds, because modern stuff really
> be written with correct SG chaining in mind.

OK, so lets see what the actual effort is.

James



