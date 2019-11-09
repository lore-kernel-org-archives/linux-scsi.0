Return-Path: <SRS0=dDgG=ZB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F455C17443
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 22:53:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 219CB20842
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Nov 2019 22:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfKIWxg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Nov 2019 17:53:36 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:37406 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfKIWxg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2019 17:53:36 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id EC6942A4DD;
        Sat,  9 Nov 2019 17:53:31 -0500 (EST)
Date:   Sun, 10 Nov 2019 09:53:33 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Kars de Jong <jongk@linux-m68k.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: [PATCH] zorro_esp: increase maximum dma length to 65536 bytes
In-Reply-To: <20191109191400.8999-1-jongk@linux-m68k.org>
Message-ID: <alpine.LNX.2.21.1.1911100936080.8@nippy.intranet>
References: <CACz-3rh9ZCyU1825yU8xxty5BGrwFhpbjKNoWnn0mGiv_h2Kag@mail.gmail.com> <20191109191400.8999-1-jongk@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 9 Nov 2019, Kars de Jong wrote:

> When using this driver on a Blizzard 1260, there were failures whenever
> DMA transfers from the SCSI bus to memory of 65535 bytes were followed by a
> DMA transfer of 1 byte. This caused the byte at offset 65535 to be
> overwritten with 0xff. The Blizzard hardware can't handle single byte DMA
> transfers.
> 
> Besides this issue, limiting the DMA length to something that is not a
> multiple of the page size is very inefficient on most file systems.
> 

Makes sense. You may want to add,
Fixes: b7ded0e8b0d1 ("scsi: zorro_esp: Limit DMA transfers to 65535 bytes")

> It seems this limit was chosen because the DMA transfer counter of the ESP
> by default is 16 bits wide, thus limiting the length to 65535 bytes.
> However, the value 0 means 65536 bytes, which is handled by the ESP and the
> Blizzard just fine. It is also the default maximum used by esp_scsi when
> drivers don't provide their own dma_length_limit() function.
> 
> Signed-off-by: Kars de Jong <jongk@linux-m68k.org>
> ---
>  drivers/scsi/zorro_esp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
> index ca8e3abeb2c7..4448567c495d 100644
> --- a/drivers/scsi/zorro_esp.c
> +++ b/drivers/scsi/zorro_esp.c
> @@ -218,7 +218,7 @@ static int fastlane_esp_irq_pending(struct esp *esp)
>  static u32 zorro_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
>  					u32 dma_len)
>  {
> -	return dma_len > 0xFFFF ? 0xFFFF : dma_len;
> +	return dma_len > (1U << 16) ? (1U << 16) : dma_len;
>  }
>  

Would it be safer to simply remove this code and leave 
esp_driver_ops.dma_length_limit == NULL for all board types?

-- 

>  static void zorro_esp_reset_dma(struct esp *esp)
> 
