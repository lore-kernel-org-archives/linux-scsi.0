From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] scsi: advansys needs ISA dma api for ISA support
Date: Fri, 16 Oct 2015 16:19:18 +0200
Message-ID: <5461074.f3cLgYkzKJ@wuerfel>
References: <4351271.eUtUWpTn54@wuerfel> <1445003624.2191.2.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:57575 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235AbbJPOTt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2015 10:19:49 -0400
In-Reply-To: <1445003624.2191.2.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org

On Friday 16 October 2015 06:53:44 James Bottomley wrote:
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > index d2f480b04a52..1d8b8257773d 100644
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -498,7 +498,7 @@ config SCSI_DPT_I2O
> >  config SCSI_ADVANSYS
> >       tristate "AdvanSys SCSI support"
> >       depends on SCSI
> > -     depends on ISA || EISA || PCI
> > +     depends on (ISA && ISA_DMA_API) || EISA || PCI
> 
> I thought the desire was to avoid a compile failure when ISA && !
> ISA_DMA_API?  Won't this one fail if ISA is defined with either EISA or
> PCI and !ISA_DMA_API?

I thought I had it ruled out, but now I've actually found a combination:
we can build an ARM kernel that supports two ancient machines, and one
of them supports ISA (but not ISA_DMA_API), while the other one supports
PCI. I had looked through several thousand randconfig builds and not
found this combination together with advansys, but I guess that is
because those were mostly old builds from the times when there was
a dependency on VIRT_TO_BUS that this platform doesn't have.

So screw this one and go back to the original patch.

	Arnd
