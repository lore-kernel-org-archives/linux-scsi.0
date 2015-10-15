From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: advansys needs ISA dma api for ISA support
Date: Thu, 15 Oct 2015 17:04:50 +0200
Message-ID: <8749889.aUxSEGWaCq@wuerfel>
References: <5081546.QjQ32dGX2L@wuerfel> <561F96B7.4050300@suse.de> <561F977B.1030009@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:49769 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbbJOPFC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 11:05:02 -0400
In-Reply-To: <561F977B.1030009@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, JBottomley@odin.com, linux-kernel@vger.kernel.org

On Thursday 15 October 2015 14:09:31 Hannes Reinecke wrote:
> On 10/15/2015 02:06 PM, Hannes Reinecke wrote:
> > On 10/12/2015 05:10 PM, Arnd Bergmann wrote:
> >> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> >> index d2f480b04a52..d4aa6a1a806c 100644
> >> --- a/drivers/scsi/Kconfig
> >> +++ b/drivers/scsi/Kconfig
> >> @@ -499,6 +499,7 @@ config SCSI_ADVANSYS
> >>      tristate "AdvanSys SCSI support"
> >>      depends on SCSI
> >>      depends on ISA || EISA || PCI
> >> +    depends on ISA_DMA_API || !ISA
> >>      help
> >>        This is a driver for all SCSI host adapters manufactured by
> >>        AdvanSys. It is documented in the kernel source in
> >>
> > Sorry to chime in again, but wouldn't this allow to build on platforms
> > which have neither ISA_DMA_API nor ISA, like oldish sparc systems with
> > proprietary S-BUS?

No, the first dependency is still in place. It could also be written as

depends on (ISA && ISA_DMA_API) || EISA || PCI

which might be easier to understand. Do you want me to resubmit it like that?

> > Why not ISA_DMA_API || EISA || PCI ?

That would indeed make it possible to enable it on ancient systems that
have none of ISA, EISA or PCI but still support ISA_DMA_API, e.g. for
a floppy controller.

A theoretical downside is that a system with a PCI advansys adapter
and ISA slots but no ISA_DMA_API would not be able to build this.
As far as I know, such a system does not exist.

> Gnaa. Ignore this.
> 
> Mailer got confused about which mails are more recent than others 

Just to make sure we are on the same page: James thought my second patch
was making things too ugly and wanted to get back to this one.

	Arnd
