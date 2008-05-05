From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: [PATCH] Stop using num_physpages in aacraid
Date: Mon, 5 May 2008 11:11:03 -0400
Message-ID: <371DC18F-1BA5-47DA-A3CC-F868993A935B@adaptec.com>
References: <20080502185227.GN14976@parisc-linux.org> <CA69411A-909E-4161-A4E3-FC86246CDA22@adaptec.com> <20080503105135.GY14976@parisc-linux.org>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:57490 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbYEEPLH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 May 2008 11:11:07 -0400
In-Reply-To: <20080503105135.GY14976@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Perfect! ACK!

Thanks for the suggestion.

Sincerely -- Mark Salyzyn

On May 3, 2008, at 6:51 AM, Matthew Wilcox wrote:

> . . .
> Thanks for the explanation of the quirks and options.  I don't want to
> drop support for any cards, I just want to make aacraid not rely on
> the meaning of num_physpages.
>
> The question aacraid wants to ask is "Does this device have to
> do DAC to access memory?"  The answer can be affected by an IOMMU or
> by memory layout.  It's far from clear what question num_physpages is
> intended to answer; there are different bits of the kernel using it in
> interesting ways.  But we do have a function designed to answer the
> question you want to ask: dma_get_required_mask().  This may be an
> expensive question to ask, so in the below patch I cache the answer in
> the aac_dev.
>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
>
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/ 
> aachba.c
> index 460d402..cd0865d 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -1201,9 +1201,8 @@ static int aac_scsi_32(struct fib * fib,  
> struct scsi_cmnd * cmd)
>
> static int aac_scsi_32_64(struct fib * fib, struct scsi_cmnd * cmd)
> {
> -       if ((sizeof(dma_addr_t) > 4) &&
> -        (num_physpages > (0xFFFFFFFFULL >> PAGE_SHIFT)) &&
> -        (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
> +       if ((sizeof(dma_addr_t) > 4) && fib->dev->needs_dac &&
> +           (fib->dev->adapter_info.options & AAC_OPT_SGMAP_HOST64))
>    return FAILED;
> return aac_scsi_32(fib, cmd);
> }
> @@ -1394,6 +1393,9 @@ int aac_get_adapter_info(struct aac_dev* dev)
>            rcode = -ENOMEM;
>    }
> }
> +       if (dma_get_required_mask(&dev->pdev->dev) > DMA_32BIT_MASK)
> +               dev->needs_dac = 1;
> +
> /*
> * Deal with configuring for the individualized limits of each packet
> * interface.
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/ 
> aacraid.h
> index 113ca9c..a06c817 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1016,6 +1016,7 @@ struct aac_dev
> u8                      jbod;
> u8                      cache_protected;
> u8                      dac_support;
> +       u8                      needs_dac;
> u8                      raid_scsi_mode;
> u8                      comm_interface;
> #      define AAC_COMM_PRODUCER 0
