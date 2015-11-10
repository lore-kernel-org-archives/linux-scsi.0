From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA fails
Date: Tue, 10 Nov 2015 09:38:32 +0100
Message-ID: <5349261.sTnZTFhKWB@wuerfel>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org> <6940177.lD0iNnWRJy@wuerfel> <56412AAE.80004@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:56107 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbbKJIj5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2015 03:39:57 -0500
In-Reply-To: <56412AAE.80004@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Sinan Kaya <okaya@codeaurora.org>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, timur@codeaurora.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, Hannes Reinecke <hare@suse.de>

On Monday 09 November 2015 18:22:22 Sinan Kaya wrote:
> On 11/9/2015 9:33 AM, Arnd Bergmann wrote:
> > On Monday 09 November 2015 09:07:36 Sinan Kaya wrote:
> >> On 11/9/2015 3:59 AM, Arnd Bergmann wrote:
> 
> ioc->dma_mask is 0 and the driver is trying to use 32 bit even though 64 
> bit supported by the platform.

Ok, makes sense.

> I think the proper fix is to pass the required_mask back to 
> consistent_dma_mask rather than using ioc->dma_mask and guessing.
> 
> pci_set_consistent_dma_mask(pdev, required_mask)
> 
> My code was just a band aid for broken code.
> 

No, as Timur found, the driver is correct and it intentionally
sets the 32-bit mask, and that is guaranteed to work on all sane
hardware. Don't change the driver but find a better platform for
your workload, or talk to the people that are responsible for
the platform and get them to fix it.

If the platform also doesn't have an IOMMU, you can probably work
around it by setting up the dma-ranges property of the PCI host
to map the low PCI addresses to the start of RAM. This will also
require changes in the bootloader to set up the PCI outbound translation,
and it will require implementing the DMA offset on ARM64, which I was
hoping to avoid.

	Arnd
