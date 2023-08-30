Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4832C6FA8F
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Aug 2023 00:48:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbjH3Aru (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 20:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239188AbjH3ArX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 20:47:23 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16FA619A;
        Tue, 29 Aug 2023 17:47:20 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 41be03b00d2f7-565e54cb93aso2098488a12.3;
        Tue, 29 Aug 2023 17:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693356439; x=1693961239; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wAZwmFFo6m9/hKGVeFTEQc2axQuBHBiouzKA18aHFmE=;
        b=mH6zj+F+LA7qTa4QvclbRcWEWEVWHfyGc15yoQD1+puMcWRCIcVBLgfrVHqDHJXGgH
         KmoFyFGmuNk+g6PL6ykCNFhZFkgxEf7W3fgTzM8qwj6yiXLmvEcvhKDZd4J9QniZKHu+
         4g/YKe1lzYVyi+8RfCxZr07wfx7yf/8Ql+id9ui3s+ur8tmynMuHLWHhuoc/KSaRMA/c
         360PWy3f60flk6Nl8sIL0HHKStnK9XhPSLLG9OkEZzaSHuR4+24iDshPOV4tIhIDB/FJ
         1+UrcPYi6CBWe6EYOYMbPiIWxQfsnZ1nh3JNMpoenC/9WxQBx5C2mJMBifhDAYSy1BrJ
         7tVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693356439; x=1693961239;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wAZwmFFo6m9/hKGVeFTEQc2axQuBHBiouzKA18aHFmE=;
        b=JjgK/MzC7DiZUmHdlniWpk3QinP27ezldEz27OI8g4C+lJJd77rVvWfVw0/Td4LdeX
         6EPZZP1dyTkOMUVWo6T4vlV5rO1DbjtXycqosdCwILBDO/RgMdgtohgG8vlSfXDbo1a8
         kVQXK4uiBbUJ0aRuezARujm8G2ls2ZmT1sl2Q5FPXnZpbWF1JgBuPZWbCDRBo/7UyGKp
         wSoQM40oFJgl3qyc7we7BDBeHe8UNtApNEXWoHnvGiDjNiLYjb1PklPoXk8FYrAqQ8oy
         8Iy9MbKrqntq6BHSRUBEBZmEQhy06vgE8J1YRkbYbWdo0H2cdslE2sKRWkHMqT83LNvj
         KbSg==
X-Gm-Message-State: AOJu0Yw2280B661aOOmOzjZx78S92ADhLzIp4IlRNkgaPQV3mkluAIte
        +bRsU8pUO0zZf+op0EGWJ1I=
X-Google-Smtp-Source: AGHT+IFbbi7ptJwkZyVjnGt3P4AbA0WhgTeDBIIMezmjudVD7V972Rqld13UspO6yevB4TPCBjHasg==
X-Received: by 2002:a17:90a:8507:b0:267:717f:2f91 with SMTP id l7-20020a17090a850700b00267717f2f91mr706581pjn.40.1693356439400;
        Tue, 29 Aug 2023 17:47:19 -0700 (PDT)
Received: from ?IPV6:2001:df0:0:200c:7425:4279:1223:a1? ([2001:df0:0:200c:7425:4279:1223:a1])
        by smtp.gmail.com with ESMTPSA id 21-20020a17090a01d500b00265c742a262sm195264pjd.4.2023.08.29.17.47.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Aug 2023 17:47:19 -0700 (PDT)
Message-ID: <bd54d374-a388-258b-19ad-ac3417057a8a@gmail.com>
Date:   Wed, 30 Aug 2023 12:47:13 +1200
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
 <ab78a254-ee6a-a2f1-c3cd-3b608e0c9e60@gmail.com>
 <31a63180-ffdc-4b5c-8bc6-3be4728a8463@app.fastmail.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
In-Reply-To: <31a63180-ffdc-4b5c-8bc6-3be4728a8463@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks Arnd!

Cheers,

     Michael

On 30/08/23 12:14, Arnd Bergmann wrote:
> On Tue, Aug 29, 2023, at 18:25, Michael Schmitz wrote:
>>>> +module_param(gvp11_xfer_mask,  int, 0444);
>>>> +MODULE_PARM_DESC(gvp11_xfer_mask, "DMA mask (0xff000000 == 24 bit DMA)");
>>>> +
>>> I think the comment is the wrong way round, it should be
>>> 0x00ffffff in this case, which also matches the default
>>> mask for ZORRO_PROD_GVP_SERIES_II, in the match table:
>>>
>>> static struct zorro_device_id gvp11_zorro_tbl[] = {
>>>           { ZORRO_PROD_GVP_COMBO_030_R3_SCSI,     ~0x00ffffff },
>>>           { ZORRO_PROD_GVP_SERIES_II,             ~0x00ffffff },
>>>           { ZORRO_PROD_GVP_GFORCE_030_SCSI,       ~0x01ffffff },
>>>           { ZORRO_PROD_GVP_A530_SCSI,             ~0x01ffffff },
>>>           { ZORRO_PROD_GVP_COMBO_030_R4_SCSI,     ~0x01ffffff },
>>>           { ZORRO_PROD_GVP_A1291,                 ~0x07ffffff },
>>>           { ZORRO_PROD_GVP_GFORCE_040_SCSI_1,     ~0x07ffffff },
>>>           { 0 }
>>> };
>> gvp11_xfer_mask works inverse to what you'd expect (and inverse to what
>> a DMA mask usually is defined as). DMA can _not_ be used if (address &
>> gvp11_xfer_mask) isn't zero. See code in dma_setup() for details.
>>
>> All those definitions have a '~' prefix, for that very reason.
>>
>> I agree it isn't intuitive, and caused a little head scratching when
>> preparing this patch. But I believe it is correct.
>>
>> Now you could argue to shift the bit mask inversion to gvp11_probe() or
>> even dma_setup() instead to rule out such confusion in future, but that
>> would be an actual code change and would benefit from testing on at
>> least one of these boards IMO. Not sure how easy that will be.
> Ok, I see now. Let's leave the patch as it is then.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
