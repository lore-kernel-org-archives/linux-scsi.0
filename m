From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [PATCH 4/5] scsi: megaraid_sas - preallocate memory for ioctlprocessing
Date: Wed, 7 Feb 2007 19:54:38 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E82298ED5D6@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36341 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933350AbXBHCyw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Feb 2007 21:54:52 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Kolli, Neela" <Neela.Kolli@lsi.com>, "Yang, Bo" <Bo.Yang@lsi.com>

Thanks.
I will resubmit the patch.

Regards,
Sumant 

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Wednesday, February 07, 2007 2:02 PM
To: Andrew Morton
Cc: Patro, Sumant; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org; Kolli, Neela; Yang, Bo; Patro, Sumant
Subject: Re: [PATCH 4/5] scsi: megaraid_sas - preallocate memory for
ioctlprocessing

On Wed, 2007-02-07 at 13:30 -0800, Andrew Morton wrote:
> I suspect all this horror is due to stupidity in the DMA API.
> 
> pci_alloc_consistent() just goes and assumes GFP_ATOMIC, whereas the 
> caller (megasas_mgmt_fw_ioctl) would have been perfectly happy to use 
> GFP_KERNEL.
> 
> I bet this fixes it

It does, but the DMA API was expanded to cope with this exact case, so
use dma_alloc_coherent() directly in the megaraid code instead.  The dev
is just &pci_dev->dev.

James


