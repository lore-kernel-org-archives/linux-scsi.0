From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] scsi: advansys needs ISA dma api for ISA support
Date: Fri, 16 Oct 2015 14:04:31 +0200
Message-ID: <40283310.IhmmM0l1HG@wuerfel>
References: <5081546.QjQ32dGX2L@wuerfel> <8749889.aUxSEGWaCq@wuerfel> <5620E432.1000709@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:61082 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbbJPMEh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Oct 2015 08:04:37 -0400
In-Reply-To: <5620E432.1000709@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org, JBottomley@odin.com, linux-kernel@vger.kernel.org

On Friday 16 October 2015 13:49:06 Hannes Reinecke wrote:
> On 10/15/2015 05:04 PM, Arnd Bergmann wrote:
> > On Thursday 15 October 2015 14:09:31 Hannes Reinecke wrote:
> >> On 10/15/2015 02:06 PM, Hannes Reinecke wrote:
> >>> On 10/12/2015 05:10 PM, Arnd Bergmann wrote:
> >>>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> >>>> index d2f480b04a52..d4aa6a1a806c 100644
> >>>> --- a/drivers/scsi/Kconfig
> >>>> +++ b/drivers/scsi/Kconfig
> >>>> @@ -499,6 +499,7 @@ config SCSI_ADVANSYS
> >>>>      tristate "AdvanSys SCSI support"
> >>>>      depends on SCSI
> >>>>      depends on ISA || EISA || PCI
> >>>> +    depends on ISA_DMA_API || !ISA
> >>>>      help
> >>>>        This is a driver for all SCSI host adapters manufactured by
> >>>>        AdvanSys. It is documented in the kernel source in
> >>>>
> >>> Sorry to chime in again, but wouldn't this allow to build on platforms
> >>> which have neither ISA_DMA_API nor ISA, like oldish sparc systems with
> >>> proprietary S-BUS?
> > 
> > No, the first dependency is still in place. It could also be written as
> > 
> > depends on (ISA && ISA_DMA_API) || EISA || PCI
> > 
> > which might be easier to understand. Do you want me to resubmit it like that?
> > 
> Yes, please do so.
> 

I now realized that they are not the same: the new version allows building
on systems with PCI and ISA but no ISA_DMA_API, which the driver should be
able to handle but doesn't (unless my second patch is applied).

However, I don't think that this combination exists, so we should still
be good, and it does express what the hardware can do. I'll send it after
my build regression tests are complete.

	Arnd
