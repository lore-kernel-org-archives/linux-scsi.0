Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CC2C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 19:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C6860F45
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Nov 2021 19:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhKBTp5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Nov 2021 15:45:57 -0400
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:63556 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhKBTpy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Nov 2021 15:45:54 -0400
Received: from [192.168.1.18] ([86.243.171.122])
        by smtp.orange.fr with ESMTPA
        id hzgjmnFJ83ptZhzgjmuj88; Tue, 02 Nov 2021 20:43:18 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Tue, 02 Nov 2021 20:43:18 +0100
X-ME-IP: 86.243.171.122
Subject: Re: [PATCH V2] message: fusion: switch from 'pci_' to 'dma_' API
To:     Qing Wang <wangqing@vivo.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kernel Janitors <kernel-janitors@vger.kernel.org>
References: <1632800532-108476-1-git-send-email-wangqing@vivo.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <ccc494e7-1d8b-36b9-c12b-1f418f525aa0@wanadoo.fr>
Date:   Tue, 2 Nov 2021 20:43:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <1632800532-108476-1-git-send-email-wangqing@vivo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Le 28/09/2021 à 05:42, Qing Wang a écrit :
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below.
> expression e1, e2;
> @@
> -    pci_set_dma_mask(e1, e2)
> +    dma_set_mask(&e1->dev, e2)
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_consistent_dma_mask(e1, e2)
> +    dma_set_coherent_mask(&e1->dev, e2)
> 
> While at it, some 'dma_set_mask()/dma_set_coherent_mask()' have been
> updated to a much less verbose 'dma_set_mask_and_coherent()'.
> 
> Signed-off-by: Qing Wang <wangqing@vivo.com>
> ---
>   drivers/message/fusion/mptbase.c | 31 +++++++++----------------------
>   1 file changed, 9 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> index 7f7abc9..c255d8a
> --- a/drivers/message/fusion/mptbase.c
> +++ b/drivers/message/fusion/mptbase.c
> @@ -1666,16 +1666,12 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>   		const uint64_t required_mask = dma_get_required_mask
>   		    (&pdev->dev);
>   		if (required_mask > DMA_BIT_MASK(32)
> -			&& !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))
> -			&& !pci_set_consistent_dma_mask(pdev,
> -						 DMA_BIT_MASK(64))) {
> +			&& dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64))) {

The logic is reversed here. We used to have a !, but it is now missing.

CJ

>   			ioc->dma_mask = DMA_BIT_MASK(64);
>   			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
>   				": 64 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
>   				ioc->name));
> -		} else if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
> -			&& !pci_set_consistent_dma_mask(pdev,
> -						DMA_BIT_MASK(32))) {
> +		} else if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
>   			ioc->dma_mask = DMA_BIT_MASK(32);
>   			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
>   				": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
> @@ -1686,9 +1682,7 @@ mpt_mapresources(MPT_ADAPTER *ioc)
>   			goto out_pci_release_region;
>   		}
>   	} else {
> -		if (!pci_set_dma_mask(pdev, DMA_BIT_MASK(32))
> -			&& !pci_set_consistent_dma_mask(pdev,
> -						DMA_BIT_MASK(32))) {
> +		if (!dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32))) {
>   			ioc->dma_mask = DMA_BIT_MASK(32);
>   			dinitprintk(ioc, printk(MYIOC_s_INFO_FMT
>   				": 32 BIT PCI BUS DMA ADDRESSING SUPPORTED\n",
> @@ -4452,9 +4446,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
>   		 */
>   		if (ioc->pcidev->device == MPI_MANUFACTPAGE_DEVID_SAS1078 &&
>   		    ioc->dma_mask > DMA_BIT_MASK(35)) {
> -			if (!pci_set_dma_mask(ioc->pcidev, DMA_BIT_MASK(32))
> -			    && !pci_set_consistent_dma_mask(ioc->pcidev,
> -			    DMA_BIT_MASK(32))) {
> +			if (!dma_set_mask_and_coherent(&ioc->pcidev, DMA_BIT_MASK(32))) {
>   				dma_mask = DMA_BIT_MASK(35);
>   				d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>   				    "setting 35 bit addressing for "
> @@ -4462,10 +4454,7 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
>   				    ioc->name));
>   			} else {
>   				/*Reseting DMA mask to 64 bit*/
> -				pci_set_dma_mask(ioc->pcidev,
> -					DMA_BIT_MASK(64));
> -				pci_set_consistent_dma_mask(ioc->pcidev,
> -					DMA_BIT_MASK(64));
> +				dma_set_mask_and_coherent(&ioc->pcidev, DMA_BIT_MASK(64));
>   
>   				printk(MYIOC_s_ERR_FMT
>   				    "failed setting 35 bit addressing for "
> @@ -4600,9 +4589,8 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
>   		alloc_dma += ioc->reply_sz;
>   	}
>   
> -	if (dma_mask == DMA_BIT_MASK(35) && !pci_set_dma_mask(ioc->pcidev,
> -	    ioc->dma_mask) && !pci_set_consistent_dma_mask(ioc->pcidev,
> -	    ioc->dma_mask))
> +	if (dma_mask == DMA_BIT_MASK(35) &&
> +	    !dma_set_mask_and_coherent(&ioc->pcidev, ioc->dma_mask))
>   		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>   		    "restoring 64 bit addressing\n", ioc->name));
>   
> @@ -4625,9 +4613,8 @@ PrimeIocFifos(MPT_ADAPTER *ioc)
>   		ioc->sense_buf_pool = NULL;
>   	}
>   
> -	if (dma_mask == DMA_BIT_MASK(35) && !pci_set_dma_mask(ioc->pcidev,
> -	    DMA_BIT_MASK(64)) && !pci_set_consistent_dma_mask(ioc->pcidev,
> -	    DMA_BIT_MASK(64)))
> +	if (dma_mask == DMA_BIT_MASK(35) &&
> +	    !dma_set_mask_and_coherent(&ioc->pcidev, DMA_BIT_MASK(64)))
>   		d36memprintk(ioc, printk(MYIOC_s_DEBUG_FMT
>   		    "restoring 64 bit addressing\n", ioc->name));
>   
> 

