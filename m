Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26ABAC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 20:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbiF2Us2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 16:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiF2Us1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 16:48:27 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0EC73FBCC;
        Wed, 29 Jun 2022 13:48:21 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id r1so15172525plo.10;
        Wed, 29 Jun 2022 13:48:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qhsFUjH+wI94oun4uxuL1yuFWLai9/RJksYgc2AjR00=;
        b=bju/ywKNEIT0oyzLLDdIcnsCfM8AryG+PYC0jGE2sDzfsHT2+5BWJHi0iLsisKFqcK
         LERHVeMHOtzvKnTQmjozdmvxpQjPS0+rsTVboV33yfFfMZCg4ptp+8qI5G6ait9mHVJQ
         B02YpSjDbnwBY9+7Os/gAecjvFLDknT2t8KgUAvgXGDxtPF+32wVnsauC4GocS1boiYy
         6lIgTVwaJpiAc+5i5EWyZyVGXw6M6plYkPRKG/jZf4wVdzddyPYFgfklZi7UUgMILA+/
         uqFwvykP3fJ6QFqdW6sRBXvexF8Sifc76CoNTgiMRGAWoKDhS3K66c3rVRH/5bgrQqC8
         ZusQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qhsFUjH+wI94oun4uxuL1yuFWLai9/RJksYgc2AjR00=;
        b=TP7cfDys9+G8aphilZWWUISdkiRIfp1LDwzAFi4IoNk65Jq/4Bt5kK0iO8v4TyeLNU
         DCcCR7iU43iH5g0LTYQnezRIQQBu0mI+cT6NgD0a/hwAYDWjfALy9cqn6TOKAL+7QXbE
         mCB4zq4b15NnvWRo5UxZv+MqiHjRyqxveL00DaeAptrLPEeJqYujn7Wh/y8sXmsbXN2z
         m+huBJ+bi+ujXGEqEPiIU7JioQZdIlClFa1b6MaSZZt4S/SYWKSfgwSattKDh8i7u4Dl
         YixQmHURlw21Qa0k4VCRYkfe454bBj0lP0FBOaEuSy+MfbEbo0nj2L1URoEg/wLNZK6j
         Qpww==
X-Gm-Message-State: AJIora9oZJq9+iv7d4I3nPO2lo5NqKw7bNwH30KG+H+IHNZ8uAPBtD3D
        NVaesgXadAalWttMojS6eFynAHuQ5Tcv5A==
X-Google-Smtp-Source: AGRyM1t76qqv2RVL0T0jTVMhkfsPOaCn3fxyNGUq9Zl1nwTuV15oXJk0dK/UWSbShXfEesWoGQ5uIg==
X-Received: by 2002:a17:903:124f:b0:16b:8167:e34e with SMTP id u15-20020a170903124f00b0016b8167e34emr12016165plh.52.1656535701216;
        Wed, 29 Jun 2022 13:48:21 -0700 (PDT)
Received: from ?IPV6:2001:df0:0:200c:b411:35d2:9458:bbe5? ([2001:df0:0:200c:b411:35d2:9458:bbe5])
        by smtp.gmail.com with ESMTPSA id t4-20020a17090340c400b001616723b8ddsm11756842pld.45.2022.06.29.13.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 13:48:20 -0700 (PDT)
Message-ID: <39114583-9c4a-7b19-54d5-516feb556fac@gmail.com>
Date:   Thu, 30 Jun 2022 08:48:16 +1200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v1 2/3] scsi - a2091.c: convert m68k WD33C93 drivers to
 DMA API
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Arnd Bergmann <arnd@kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
References: <20220629011638.21783-1-schmitzmic@gmail.com>
 <20220629011638.21783-3-schmitzmic@gmail.com>
 <CAK8P3a2yx7dgU8xnhOLsyeD0eq5q+wSOOzJPmNDdG1kWkiG3-g@mail.gmail.com>
 <554d6fa7-01b7-d3c8-a72a-6474e9c5038e@gmail.com>
 <CAMuHMdX0x3nL5fhmv2T01o8=H6Gp1jog_MZt9gjFe2A7YyMAuQ@mail.gmail.com>
From:   Michael Schmitz <schmitzmic@gmail.com>
In-Reply-To: <CAMuHMdX0x3nL5fhmv2T01o8=H6Gp1jog_MZt9gjFe2A7YyMAuQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Geert,

On 30/06/22 03:55, Geert Uytterhoeven wrote:
> Hi Michael,
>
> On Wed, Jun 29, 2022 at 9:27 AM Michael Schmitz <schmitzmic@gmail.com> wrote:
>> Most users will opt for loading the kernel to a RAM chunk at a higher
>> physical address, making the lower chunk unusable (except as chip RAM),
>> meaning allocating a bounce buffer within the first 16 MB will most
>> likely fail anyway AIUI (but Geert would know that for sure).
> Exactly.  On Zorro III-capable machines, Zorro II RAM is not mapped
> for general use, but can be used by the z2ram block device.
Is there any DMA capable memory other than chip and ZorroII RAM on these 
machines?
> Note that you can use it as a bounce buffer, by looking for and marking
> free chunks in the zorro_unused_z2ram bitmap.

That would be similar to what amiga_chip_alloc() does, right? Any 
advantages over using chip RAM (faster, perhaps)?

Cheers,

     Michael

>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
