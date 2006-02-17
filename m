From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Problems with MSI-X on ia64
Date: Fri, 17 Feb 2006 07:11:00 -0700
Message-ID: <20060217141100.GR12822@parisc-linux.org>
References: <D4CFB69C345C394284E4B78B876C1CF10B848090@cceexc23.americas.cpqcorp.net> <20060217075829.GB22451@esmail.cup.hp.com> <20060217084605.GG4523@taniwha.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ia64-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060217084605.GG4523@taniwha.stupidest.org>
Sender: linux-ia64-owner@vger.kernel.org
To: Chris Wedgwood <cw@f00f.org>
Cc: Grant Grundler <iod00d@hp.com>, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ia64@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 17, 2006 at 12:46:05AM -0800, Chris Wedgwood wrote:
> On Thu, Feb 16, 2006 at 11:58:29PM -0800, Grant Grundler wrote:
> 
> > The root cause is the use of u32 to describe a PCI resource "start".
> > phys_addr needs to be "unsigned long". More details in Log entry
> > below.
> 
> That won't always suffice.
> 
> I have machines at work that will place some PCI resources above the
> 4GB boundary even when booting in '32-bit OS' mode (there is a BIOS
> option for this but no matter the setting some resources always end up
> above 4GB).  I've heard from others they've also been hit by this
> (with 64-bit kernels it's fine).  I guess it could be argued that it's
> a BIOS bug, I'm not entirely sure what to thing,  Windows seems to
> deal with it.

So we need to use dma_addr_t here, I guess.
