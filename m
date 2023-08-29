Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9465C71153
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 22:26:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235941AbjH2W0O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 18:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238435AbjH2W0K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 18:26:10 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604F8C2;
        Tue, 29 Aug 2023 15:26:06 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-68bec3a9bdbso3187319b3a.3;
        Tue, 29 Aug 2023 15:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693347966; x=1693952766; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S3mrDNqKZv7VLwU1y4Q1e3BwMYueO6udpio+hi3sY54=;
        b=QNANQ0rTCVphI0pvZ/gv3w5ZxmiCqJc2pxakAzSXcplWKmX4nBHTVwlQb4CJGuNRdC
         aJoMzcVJNAlz8uLFXXRAtHR4T1kU7DpjqDa4SlRtzA/wE6uDoJgqndYn3rAkUXTYzANh
         U5MzzKv2vqS9NahW+G5P0sb+Ks9Aagdr++GHkQkIpD8soukc0q0PWxffkY1ragrJXX3b
         vBhGArqBPWnDj7v/5piVBbLXfrNA0iaBbhowU03MEYmD4vNuJ2osyxEV9kyn4YJNrmMR
         dmhl8/5e2ZDMvcsEchI17LtA9lWSti/kGJDyi8oFQItnDkDqgBboSF8sxZzdbeVfU+MQ
         +yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693347966; x=1693952766;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S3mrDNqKZv7VLwU1y4Q1e3BwMYueO6udpio+hi3sY54=;
        b=U+9Vh2fe4eugHOhuMPxhNN3SuqGUqdpPLofgI1QCfeZIXmEhEklkONggG5Y/B96HpJ
         ipRPGbzWibIzrjJ4vJDxWWP0g0xXYQCKxCoRKqYeUHSQaPqq6o8PRm78o5Gudn0hMuSE
         fCMiAAyU2ujq30gwOgzkz98GREeOymIOwEgEudvmx3EelDY2dIGDPhaTcL4RVh1pyoS5
         7k+qL7x+f6paM7n5aqHoXKkaCBEutMUsLU21lEaxGK6CKQ4nw+r0gBv/7FbqmSmBpcFj
         fyiCX1ohsGgtXAK1ROI7X+UpE7sU3E3CDlx+nj35q1BhlYFfE0lbUo7Okh+Tv6hZgGFI
         XVZQ==
X-Gm-Message-State: AOJu0YzI1fuSURK6GU57X9bly2ZL3NEA9/n7V+vhQpOKL1gvPM+U4uc0
        ZtvDDrkCUSlNwbMCiE+47wsRh8S/R+Y=
X-Google-Smtp-Source: AGHT+IHhpx+YFoYz3NsBY5l+gY+Zi/8ze8zpcHuVGj8VYvviBqChcSXsE0Jgq8GlzJqHJoCwzEE/Lw==
X-Received: by 2002:a05:6a21:789a:b0:14c:c393:6af with SMTP id bf26-20020a056a21789a00b0014cc39306afmr946615pzc.0.1693347965701;
        Tue, 29 Aug 2023 15:26:05 -0700 (PDT)
Received: from ?IPV6:2001:df0:0:200c:7425:4279:1223:a1? ([2001:df0:0:200c:7425:4279:1223:a1])
        by smtp.gmail.com with ESMTPSA id iy20-20020a170903131400b001b89466a5f4sm9849668plb.105.2023.08.29.15.26.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 15:26:05 -0700 (PDT)
Message-ID: <ab78a254-ee6a-a2f1-c3cd-3b608e0c9e60@gmail.com>
Date:   Wed, 30 Aug 2023 10:25:59 +1200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] scsi: gvp11: add module parameter for DMA transfer bit
 mask
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     linux-m68k@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20230829214517.14448-1-schmitzmic@gmail.com>
 <4a7d0dda-c24f-4875-892f-c8c5ef700882@app.fastmail.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
In-Reply-To: <4a7d0dda-c24f-4875-892f-c8c5ef700882@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arnd,

thanks for your comments!

On 30/08/23 10:05, Arnd Bergmann wrote:
> On Tue, Aug 29, 2023, at 17:45, Michael Schmitz wrote:
>> SCSI boards on Amiga. There now is no way to set a non-default
>> DMA mask on these boards.
> It might help to mention here in which cases the default mask
> is actually wrong.

All I have is:

Probably it's needed on A2000 with an accelerator card and GVP II SCSI,
to prevent DMA to RAM banks that do not support fast DMA cycles.

from Geert's reply. I can add that. It just did sound a shade 
speculative...
>
>> +module_param(gvp11_xfer_mask,  int, 0444);
>> +MODULE_PARM_DESC(gvp11_xfer_mask, "DMA mask (0xff000000 == 24 bit DMA)");
>> +
> I think the comment is the wrong way round, it should be
> 0x00ffffff in this case, which also matches the default
> mask for ZORRO_PROD_GVP_SERIES_II, in the match table:
>
> static struct zorro_device_id gvp11_zorro_tbl[] = {
>          { ZORRO_PROD_GVP_COMBO_030_R3_SCSI,     ~0x00ffffff },
>          { ZORRO_PROD_GVP_SERIES_II,             ~0x00ffffff },
>          { ZORRO_PROD_GVP_GFORCE_030_SCSI,       ~0x01ffffff },
>          { ZORRO_PROD_GVP_A530_SCSI,             ~0x01ffffff },
>          { ZORRO_PROD_GVP_COMBO_030_R4_SCSI,     ~0x01ffffff },
>          { ZORRO_PROD_GVP_A1291,                 ~0x07ffffff },
>          { ZORRO_PROD_GVP_GFORCE_040_SCSI_1,     ~0x07ffffff },
>          { 0 }
> };

gvp11_xfer_mask works inverse to what you'd expect (and inverse to what 
a DMA mask usually is defined as). DMA can _not_ be used if (address & 
gvp11_xfer_mask) isn't zero. See code in dma_setup() for details.

All those definitions have a '~' prefix, for that very reason.

I agree it isn't intuitive, and caused a little head scratching when 
preparing this patch. But I believe it is correct.

Now you could argue to shift the bit mask inversion to gvp11_probe() or 
even dma_setup() instead to rule out such confusion in future, but that 
would be an actual code change and would benefit from testing on at 
least one of these boards IMO. Not sure how easy that will be.

Cheers,

     Michael

>        Arnd
