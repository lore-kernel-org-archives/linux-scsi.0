Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC3BC17449
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 22:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD8182196E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 22:46:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfKLWqL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 17:46:11 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:59654 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKLWqK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Nov 2019 17:46:10 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 4C4712A6B4;
        Tue, 12 Nov 2019 17:46:07 -0500 (EST)
Date:   Wed, 13 Nov 2019 09:46:10 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Kars de Jong <jongk@linux-m68k.org>
cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        schmitzmic@gmail.com
Subject: Re: [PATCH v2] zorro_esp: Limit DMA transfers to 65536 bytes (except
 on Fastlane)
In-Reply-To: <20191112175523.23145-1-jongk@linux-m68k.org>
Message-ID: <alpine.LNX.2.21.1.1911130945480.13@nippy.intranet>
References: <1573414513.3230.4.camel@linux.ibm.com> <20191112175523.23145-1-jongk@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 12 Nov 2019, Kars de Jong wrote:

> When using this driver on a Blizzard 1260, there were failures whenever
> DMA transfers from the SCSI bus to memory of 65535 bytes were followed by a
> DMA transfer of 1 byte. This caused the byte at offset 65535 to be
> overwritten with 0xff. The Blizzard hardware can't handle single byte DMA
> transfers.
> 
> Besides this issue, limiting the DMA length to something that is not a
> multiple of the page size is very inefficient on most file systems.
> 
> It seems this limit was chosen because the DMA transfer counter of the ESP
> by default is 16 bits wide, thus limiting the length to 65535 bytes.
> However, the value 0 means 65536 bytes, which is handled by the ESP and the
> Blizzard just fine. It is also the default maximum used by esp_scsi when
> drivers don't provide their own dma_length_limit() function.
> 
> The limit of 65536 bytes can be used by all boards except the Fastlane. The
> old driver used a limit of 65532 bytes (0xfffc), which is reintroduced in
> this patch.
> 
> Fixes: b7ded0e8b0d1 ("scsi: zorro_esp: Limit DMA transfers to 65535 bytes")
> Signed-off-by: Kars de Jong <jongk@linux-m68k.org>

Reviewed-by: Finn Thain <fthain@telegraphics.com.au>

> ---
>  drivers/scsi/zorro_esp.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/zorro_esp.c b/drivers/scsi/zorro_esp.c
> index ca8e3abeb2c7..a23a8e5794f5 100644
> --- a/drivers/scsi/zorro_esp.c
> +++ b/drivers/scsi/zorro_esp.c
> @@ -218,7 +218,14 @@ static int fastlane_esp_irq_pending(struct esp *esp)
>  static u32 zorro_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
>  					u32 dma_len)
>  {
> -	return dma_len > 0xFFFF ? 0xFFFF : dma_len;
> +	return dma_len > (1U << 16) ? (1U << 16) : dma_len;
> +}
> +
> +static u32 fastlane_esp_dma_length_limit(struct esp *esp, u32 dma_addr,
> +					u32 dma_len)
> +{
> +	/* The old driver used 0xfffc as limit, so do that here too */
> +	return dma_len > 0xfffc ? 0xfffc : dma_len;
>  }
>  
>  static void zorro_esp_reset_dma(struct esp *esp)
> @@ -604,7 +611,7 @@ static const struct esp_driver_ops fastlane_esp_ops = {
>  	.esp_write8		= zorro_esp_write8,
>  	.esp_read8		= zorro_esp_read8,
>  	.irq_pending		= fastlane_esp_irq_pending,
> -	.dma_length_limit	= zorro_esp_dma_length_limit,
> +	.dma_length_limit	= fastlane_esp_dma_length_limit,
>  	.reset_dma		= zorro_esp_reset_dma,
>  	.dma_drain		= zorro_esp_dma_drain,
>  	.dma_invalidate		= fastlane_esp_dma_invalidate,
> 
