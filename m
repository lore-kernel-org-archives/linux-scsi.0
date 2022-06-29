Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA9B2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 07:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiF2H1C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 03:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiF2H1B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 03:27:01 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C0C252AB;
        Wed, 29 Jun 2022 00:27:00 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m14-20020a17090a668e00b001ee6ece8368so9186039pjj.3;
        Wed, 29 Jun 2022 00:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=p0NOM3tOvTu9tYu9Jo91fNZhl1btdoLw3G3+FzLKArM=;
        b=n3j8GaQHuO3/QxhfJ8CTdhl1hlcudhq0b3DYg6UiXzzSaeo95kmbbOAgNKGpVh6xqy
         C+xVMyOxJiUJ1ywhyHBR1P6e2BRACnegWrkT2jHwU44FgrnSeddVLTBk8ne2jO2MCyuz
         thu1Rif8QuRvEQ3d5z/UXeh3d3nrgUnLN+ixbahcLuXF3mrvGO0lGDLNHX19mxbkXosq
         qhALpOpHNWdG6IdzSXn91l0Tml3mIYg5QL3t472ECb6hXMGVdv3iWybyRdsc5g97Ne6B
         UmwgG5YMR7UDjLv4sXXH1UZQ0C0a7ZxcJq5dwE2RtmnEavc3y6SNXT3htbQ8adBi2rUJ
         c4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=p0NOM3tOvTu9tYu9Jo91fNZhl1btdoLw3G3+FzLKArM=;
        b=ypryCuYIVSaIf71w+cIP7rsiQHJkfRjtg74rquJDV+Egxk+TzhiC8CMnIRKrfQ8UIr
         z4kdZUPehyGEHLqNvymnRXN1fgj+SgSR8FWvAGNKRa0ij/jitABXRKEE35F+9wP26UMP
         kRNCATJP8vwnnYi1CvirUJZVTyqRBOWINBMCmHPu5wIII8Y9AKa2+xV/MMjfz1XUKNmF
         NgWLP8OcttYd8n0r9UFHUDjkxhXBbkMvaQlPYu+78ScVpXj/fOBSA76qNiCYvA3iEVBF
         O+2ZqbDPNcK429MiDYiJQAOgn9aTJQGTFXyOCCMuqTezBg0g/9qLAghgiZk4t7bf2S0I
         /GJg==
X-Gm-Message-State: AJIora916vQy3nhI3y+dlxy7dOqHP2NxD5vJfpARiPqOfddWi1DGYJ7I
        SuADsHyyehIfqP/WG0z/Frk=
X-Google-Smtp-Source: AGRyM1sSZVLEMQBl3VyNMSf7sn9exiAxLXQ76/IGAArZslL7bpjz6wMRSDDWVgMeipgE9vaiQNy73A==
X-Received: by 2002:a17:90b:3a8f:b0:1ec:93d4:f955 with SMTP id om15-20020a17090b3a8f00b001ec93d4f955mr4230251pjb.23.1656487619990;
        Wed, 29 Jun 2022 00:26:59 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id a4-20020a170902710400b00162037fbb68sm10525024pll.215.2022.06.29.00.26.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jun 2022 00:26:59 -0700 (PDT)
Subject: Re: [PATCH v1 2/3] scsi - a2091.c: convert m68k WD33C93 drivers to
 DMA API
To:     Arnd Bergmann <arnd@kernel.org>
References: <20220629011638.21783-1-schmitzmic@gmail.com>
 <20220629011638.21783-3-schmitzmic@gmail.com>
 <CAK8P3a2yx7dgU8xnhOLsyeD0eq5q+wSOOzJPmNDdG1kWkiG3-g@mail.gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <554d6fa7-01b7-d3c8-a72a-6474e9c5038e@gmail.com>
Date:   Wed, 29 Jun 2022 19:26:53 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <CAK8P3a2yx7dgU8xnhOLsyeD0eq5q+wSOOzJPmNDdG1kWkiG3-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arnd,

thanks for your review!

Am 29.06.2022 um 18:06 schrieb Arnd Bergmann:
> On Wed, Jun 29, 2022 at 3:16 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>>
>> Use dma_map_single() for a2091 driver (leave bounce buffer
>> logic unchanged).
>>
>> Use dma_set_mask_and_coherent() to avoid explicit cache
>> flushes.
>>
>> Compile-tested only.
>>
>> CC: linux-scsi@vger.kernel.org
>> Link: https://lore.kernel.org/r/6d1d88ee-1cf6-c735-1e6d-bafd2096e322@gmail.com
>> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
>
>> +
>> +       addr = dma_map_single(hdata->dev, scsi_pointer->ptr,
>> +                             len, DMA_DIR(dir_in));
>> +       if (dma_mapping_error(hdata->dev, addr)) {
>> +               dev_warn(hdata->dev, "cannot map SCSI data block %p\n",
>> +                        scsi_pointer->ptr);
>> +               return 1;
>> +       }
>> +       scsi_pointer->dma_handle = addr;
>>
>>         /* don't allow DMA if the physical address is bad */
>>         if (addr & A2091_XFER_MASK) {
>> +               /* drop useless mapping */
>> +               dma_unmap_single(hdata->dev, scsi_pointer->dma_handle,
>> +                                scsi_pointer->this_residual,
>> +                                DMA_DIR(dir_in));
>
> I think you could save the extra map/unmap here if you wanted, but that
> would risk introducing bugs since it requires a larger rework.

Not sure how to do that ...

>> +               scsi_pointer->dma_handle = (dma_addr_t) NULL;
>> +
>>                 wh->dma_bounce_len = (scsi_pointer->this_residual + 511) & ~0x1ff;
>>                 wh->dma_bounce_buffer = kmalloc(wh->dma_bounce_len,
>>                                                 GFP_KERNEL);
>
> Not your bug, but if there is memory above the A2091_XFER_MASK limit,
> this would need to use GFP_DMA instead of GFP_KERNEL.

Same argument goes for gvp11 - though last time I checked (and certainly 
at the time these drivers were written), there really was no difference 
between using GFP_DMA and GFP_KERNEL on m68k, hence the need to check 
the allocated buffer is indeed suitable for DMA, and perhaps revert to 
chip RAM (slow, useless for most other purposes but definitely below 16 
MB) if that fails (as the gvp11 driver does).

Most users will opt for loading the kernel to a RAM chunk at a higher 
physical address, making the lower chunk unusable (except as chip RAM), 
meaning allocating a bounce buffer within the first 16 MB will most 
likely fail anyway AIUI (but Geert would know that for sure).

Cheers,

	Michael

>
>          Arnd
>
