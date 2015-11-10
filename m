From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Tue, 10 Nov 2015 15:58:19 -0500
Message-ID: <56425A6B.2070900@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <4982446.ZlJVrezq1Y@wuerfel> <56422725.7040809@codeaurora.org>
 <3742888.Lmg2Y11mdz@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51256 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbbKJU6W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2015 15:58:22 -0500
In-Reply-To: <3742888.Lmg2Y11mdz@wuerfel>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: Abhijit Mahajan <abhijit.mahajan@avagotech.com>, linux-scsi@vger.kernel.org, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, jcm@redhat.com, timur@codeaurora.org, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Hannes Reinecke <hare@suse.de>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, MPT-FusionLinux.pdl@avagotech.com, agross@codeaurora.org



On 11/10/2015 2:56 PM, Arnd Bergmann wrote:
>> The ACPI IORT table declares whether you enable IOMMU for a particular
>> >device or not. The placement of IOMMU HW is system specific. The IORT
>> >table gives the IOMMU HW topology to the operating system.
> This sounds odd. Clearly you need to specify the IOMMU settings for each
> possible PCI device independent of whether the OS actually uses the IOMMU
> or not.

There are provisions to have DMA mask in the PCIe host bridge not at the 
PCIe device level inside IORT table. This setting is specific for each 
PCIe bus. It is not per PCIe device.

It is assumed that the endpoint device driver knows the hardware for 
PCIe devices. The driver can also query the supported DMA bits by this 
platform via DMA APIs and will request the correct DMA mask from the DMA 
subsystem (surprise!).

>In a lot of cases, we want to turn it off to get better performance
> when the driver has set a DMA mask that covers all of RAM, but you
> also want to enable the IOMMU for debugging purposes or for device
> assignment if you run virtual machines. The bootloader doesn't know how
> the device is going to be used, so it cannot define the policy here.

I think we'll end up adding a virtualization option to the UEFI BIOS 
similar to how Intel platforms work. Based on this switch, we'll end up 
patching the ACPI table.

If I remove the IORT entry, then the device is in coherent mode with 
device accessing the full RAM range.

If I have the IORT table, the device is in IOMMU translation mode.

Details are in the IORT spec.


-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
