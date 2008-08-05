From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] fusion:  Implement generic interrupt misroute
	handling
Date: Tue, 05 Aug 2008 13:45:24 -0700
Message-ID: <1217969124.9923.67.camel@localhost.localdomain>
References: <1217786709.4179.27.camel@localhost.localdomain>
	 <48970A4D.2090309@csr.com> <1217954187.9923.15.camel@localhost.localdomain>
	 <200808051038.39275.jbarnes@virtuousgeek.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-pci-owner@vger.kernel.org>
In-Reply-To: <200808051038.39275.jbarnes@virtuousgeek.org>
Sender: linux-pci-owner@vger.kernel.org
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: David Vrabel <david.vrabel@csr.com>, "Moore, Eric" <Eric.Moore@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-08-05 at 10:38 -0700, Jesse Barnes wrote:
> On Tuesday, August 05, 2008 9:36 am James Bottomley wrote:
> > On Mon, 2008-08-04 at 14:55 +0100, David Vrabel wrote:
> > > Moore, Eric wrote:
> > > > Thanks, I will try this out.   However I thought I saw lost
> > > > interrupts occurring randomly, meaning it was not necessarily the
> > > > first config page access.  I'm back in the office on 8/11, I will
> > > > test it out then and provide feedback.
> > >
> > > Is this using MSI on a device without per-vector mask bits?  If so, then
> > > this patch may help.
> > >
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
> > >;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd
> >
> > We don't really know what the problem is.  MSI interrupts get lost on
> > older motherboards (the ones most likely to contain a 1030).  Why is
> > anybody's guess although the clever money is on the motherboard bridge
> > having issues.
> 
> David just got us to fix an MSI masking bug recently, which could be related.
> 
> The issue is that the PCI & interrupt handling code was disabling MSI during 
> interrupt handling, which could end up causing missed interrupts.  When MSI 
> is disabled, devices can still generate interrupts, but they'll go out the 
> interrupt line instead, so unless your IRQ handler is also registered with 
> that IRQ number, you'll probably lose them.
> 
> As of the last PCI upstream merge, we work around this issue by never masking 
> MSI interrupts unless the device supports the MSI mask bit (as opposed to 
> just the big hammer enable/disable flag).

True, but this is orthogonal.

I'm trying to put together a diagnosing tool.  Once we know there's a
problem and who has it, then we can try seeing if patches like this fix
it.

James
