From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH V2 1/3] scsi: mptxsas: try 64 bit DMA when 32 bit DMA
 fails
Date: Tue, 10 Nov 2015 15:03:59 -0600
Message-ID: <56425BBF.6000308@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <4982446.ZlJVrezq1Y@wuerfel> <564222CB.3000701@codeaurora.org>
 <6333643.g8NiezT8gD@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <6333643.g8NiezT8gD@wuerfel>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Sinan Kaya <okaya@codeaurora.org>, linux-arm-kernel@lists.infradead.org, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, linux-scsi@vger.kernel.org, jcm@redhat.com, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, cov@codeaurora.org, linux-arm-msm@vger.kernel.org, agross@codeaurora.org, MPT-FusionLinux.pdl@avagotech.com, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 11/10/2015 01:13 PM, Arnd Bergmann wrote:
> If the mask is 64-bit by default on ARM64, that is a bug that we need
> to fix urgently. Can you verify this?

I think the mask is 0 by default, because there's no code in ARM64 that 
actually sets the mask.

Take a look at arch_setup_pdev_archdata() in 
arch/powerpc/kernel/setup-common.c.

void arch_setup_pdev_archdata(struct platform_device *pdev)
{
         pdev->archdata.dma_mask = DMA_BIT_MASK(32);
         pdev->dev.dma_mask = &pdev->archdata.dma_mask;
         set_dma_ops(&pdev->dev, &dma_direct_ops);
}

I don't see anything equivalent in arch/arm64

> A lot of PCI devices can only do 32-bit DMA, and we have plenty
> of drivers that don't bother setting a mask at all because the 32-bit
> mask is the default on all other architectures.

In our drivers for 32-bit devices, we have to explicitly set the DMA 
mask to 32-bits in order to get any DMA working.

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
