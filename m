From: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2/2] fusion:  Implement generic interrupt misroute handling
Date: Tue, 5 Aug 2008 10:38:38 -0700
Message-ID: <200808051038.39275.jbarnes@virtuousgeek.org>
References: <1217786709.4179.27.camel@localhost.localdomain> <48970A4D.2090309@csr.com> <1217954187.9923.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-mail-02.bluehost.com ([69.89.21.12]:48923 "HELO
	outbound-mail-02.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1761399AbYHERiw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2008 13:38:52 -0400
In-Reply-To: <1217954187.9923.15.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: David Vrabel <david.vrabel@csr.com>, "Moore, Eric" <Eric.Moore@lsi.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Tuesday, August 05, 2008 9:36 am James Bottomley wrote:
> On Mon, 2008-08-04 at 14:55 +0100, David Vrabel wrote:
> > Moore, Eric wrote:
> > > Thanks, I will try this out.   However I thought I saw lost
> > > interrupts occurring randomly, meaning it was not necessarily the
> > > first config page access.  I'm back in the office on 8/11, I will
> > > test it out then and provide feedback.
> >
> > Is this using MSI on a device without per-vector mask bits?  If so, then
> > this patch may help.
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit
> >;h=ce6fce4295ba727b36fdc73040e444bd1aae64cd
>
> We don't really know what the problem is.  MSI interrupts get lost on
> older motherboards (the ones most likely to contain a 1030).  Why is
> anybody's guess although the clever money is on the motherboard bridge
> having issues.

David just got us to fix an MSI masking bug recently, which could be related.

The issue is that the PCI & interrupt handling code was disabling MSI during 
interrupt handling, which could end up causing missed interrupts.  When MSI 
is disabled, devices can still generate interrupts, but they'll go out the 
interrupt line instead, so unless your IRQ handler is also registered with 
that IRQ number, you'll probably lose them.

As of the last PCI upstream merge, we work around this issue by never masking 
MSI interrupts unless the device supports the MSI mask bit (as opposed to 
just the big hammer enable/disable flag).

Jesse


