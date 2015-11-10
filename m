From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Tue, 10 Nov 2015 11:06:40 -0500
Message-ID: <56421610.50005@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <6940177.lD0iNnWRJy@wuerfel> <56412AAE.80004@codeaurora.org>
 <5349261.sTnZTFhKWB@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33255 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbbKJQGo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2015 11:06:44 -0500
In-Reply-To: <5349261.sTnZTFhKWB@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, timur@codeaurora.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, Hannes Reinecke <hare@suse.de>



On 11/10/2015 3:38 AM, Arnd Bergmann wrote:
 > No, as Timur found, the driver is correct and it intentionally
> sets the 32-bit mask, and that is guaranteed to work on all sane
> hardware. Don't change the driver but find a better platform for
> your workload, or talk to the people that are responsible for
> the platform and get them to fix it.

Platform does have an IOMMU. No issues there. I am trying to clean out 
the patch pipe I have in order to get this card working with and without 
IOMMU.

>
> If the platform also doesn't have an IOMMU, you can probably work
> around it by setting up the dma-ranges property of the PCI host
> to map the low PCI addresses to the start of RAM. This will also
> require changes in the bootloader to set up the PCI outbound translation,
> and it will require implementing the DMA offset on ARM64, which I was
> hoping to avoid.

 From the email thread, it looks like this was introduced to support 
some legacy card that has 64 bit addressing limitations and is being 
carried around ("rotted") since then.

I'm the second guy after the powerpc architecture complaining about the 
very same issue. Any red flags?

I can't change the address map for PCIe. SBSA requires all inbound PCIe 
addresses to be non-translated.

I'll just have to stick with IOMMU for this card.

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
