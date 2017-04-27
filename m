From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor Post
 Queue (RDPQ) Array support
Date: Thu, 27 Apr 2017 14:45:31 +0530
Message-ID: <9f90b62b5453ac833df1fdc53fd67157@mail.gmail.com>
References: <20140625103445.GA12943@avagotech.com>        <yq1zjg2m6lu.fsf@sermon.lab.mkp.net>
        <CAK=zhgoQt5J=jh4jShAy5rBXNz34sN-tqf=uZDkY4zQJ9XhM5g@mail.gmail.com>
        <yq18unklvda.fsf@sermon.lab.mkp.net>        <CAK=zhgpDWJLBMBB1mV-7u+o_UC86PiOCAp4vi4-UAn_hXHtF2A@mail.gmail.com>
        <yq1r41bkgdp.fsf@sermon.lab.mkp.net>        <CAK=zhgq=DfOZGjLcid4qJA+L_Vs4UjOHAmJza5Zh-V7u=LxcsQ@mail.gmail.com>
 <yq1mvb2ajsc.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:32878 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754501AbdD0JPf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2017 05:15:35 -0400
Received: by mail-lf0-f45.google.com with SMTP id 88so13963807lfr.0
        for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2017 02:15:34 -0700 (PDT)
In-Reply-To: <yq1mvb2ajsc.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: jejb@kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Martin K. Petersen
> Sent: Thursday, April 27, 2017 3:55 AM
> To: Sreekanth Reddy
> Cc: Martin K. Petersen; jejb@kernel.org; linux-scsi@vger.kernel.org;
linux-
> kernel@vger.kernel.org; Christoph Hellwig
> Subject: Re: [RESEND][PATCH 07/10][SCSI]mpt2sas: Added Reply Descriptor
> Post Queue (RDPQ) Array support
>
>
> Sreekanth,
>
> > We need to satisfy this condition on those system where 32 bit dma
> > consistent mask is not supported and it only supports 64 bit dma
> > consistent mask. So on these system we can't set
> > pci_set_consistent_dma_mask() to DMA_BIT_MASK(32).
>
> Which systems are you talking about?
>
> It seems a bit unrealistic to require all devices to support 64-bit DMA.

Martin - We have found all devices to support 64-bit DMA on certain ARM64
platform. I discussed @linux-arm-kern. Below is a thread.

http://marc.info/?l=linux-arm-kernel&m=148880763816046&w=2

For ARM64, it is not supporting SWIOTLB and that is a reason we need to
make all DMA pool above 4GB.
Ea. If I map crash kernel above 4GB in x86_64 platform, they owner DMA 32
bit mask since arch specific code in x86_64 support SWIOTLB.
Same settings on ARM64 platform fails DAM 32 bit mask.

In one particular setup of ARM64, I also see below 4GB is mapped to SoC
and kernel component mapped above 4GB region.

Can we add in MR/IT driver below logic to meet this requirement ?

- Driver will attempt DMA buffer above 4GB and check the start and end
address of the physical address.
If DMA buffer cross the "Same 4GB region" ( I mean High Address should be
constant for that region.), driver will hold that region and attempt one
more allocation.
If second allocation is also not meeting "Same 4GB region", we will give
up driver load.

Before we attempt above logic, we would like to understand if we have any
other reliable method ways to handle this in Linux.

Most of the time, we are going to get "same 4GB region", so we are OK to
have this corner case to detect and bail out driver load. There is no
report of issue from field, but wanted to protect failure for future.

Thanks, Kashyap

>
> --
> Martin K. Petersen	Oracle Linux Engineering
