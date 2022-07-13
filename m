Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B69C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 02:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231128AbiGMCFM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 22:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiGMCFM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 22:05:12 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F77C166C;
        Tue, 12 Jul 2022 19:05:11 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id i8-20020a17090a4b8800b001ef8a65bfbdso1250053pjh.1;
        Tue, 12 Jul 2022 19:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=zXWTV7ls01ZFKOZC63W7jXuAEiR61fc3WFYoak+FHwU=;
        b=ToDyxDVgIibNrV84k77wPbtRENmgUAxD4Hhd0L949c1RpBIgtduQbkLL/qiEWYYjeb
         rX1jX75ITfh+LoVZINOiCOqvH4fITSUiHL5z6V4ssTZGGKI3FWW1D/f8IYOJfJAgyHbd
         iac+94UUjGgVkN4fVazRIVDlpFzYlxxWPsqKAEdltn0eGu4RP+d2cbzEaaqKfKZb3QqI
         vzySWqQ+9FMX6pWuvsZzn2BFGxYc8Xi1DugXeCWg146MaiL0+D/OEtq4dfNL739sDSOl
         gzhXiHXBv09G22Ckt7JMyvzZIfmJ0zNhd5ztNWbChnggiyfU4iyPQWRhY8A062p4eGc9
         hzyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=zXWTV7ls01ZFKOZC63W7jXuAEiR61fc3WFYoak+FHwU=;
        b=a+psUAtI/O4ucPsVeqEQ+7r7CGubyUsJfgFIpV2j69evwbRNQCJJt7KTN/Ov2DNSIL
         hyE+4nlY+iKpVz/UPoHie7igU2RpnzPtBJ5Vd7Cxv+Nhfv5Fc+uZ7bZhIgQHPoVYJQJt
         SgXzll1S9vudyisQEHc1tLdhuKxbs/wQJpEoUvXrWL0JFPYZGdk1oR0XlRzTZt+7ISnL
         2zX1aiSKytxYZq1BaLdxNL2mwxyohYzgj6mx1KipgXswKsG0O4a54KDdRnHpjJwjUWuS
         04NefLERrRJQqiiFSek0TzO5DrYSSElRKxEOSbg5Ko9QXkMb3It1dqTePl7MviPK6QBy
         dlbQ==
X-Gm-Message-State: AJIora8A7RnOaFVJIR0zKf3LY1fcul5FTmpFUb1+HhGpJR8NLQEnjgfD
        kI0S2wE7+GTXr6p1o9LW+zqt7n+IaFE=
X-Google-Smtp-Source: AGRyM1v442chetQ/U6Sil1Ifi4SEnLlGQLmv9RlFj8JH3h8mMIzdP8mknle6DTt3AAWNJsvOS+38hg==
X-Received: by 2002:a17:90a:f001:b0:1f0:3285:6b5b with SMTP id bt1-20020a17090af00100b001f032856b5bmr1297100pjb.12.1657677910940;
        Tue, 12 Jul 2022 19:05:10 -0700 (PDT)
Received: from ?IPV6:2001:df0:0:200c:c871:5dfe:6dac:981b? ([2001:df0:0:200c:c871:5dfe:6dac:981b])
        by smtp.gmail.com with ESMTPSA id u14-20020a17090341ce00b0016c19417495sm7595066ple.239.2022.07.12.19.05.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 19:05:10 -0700 (PDT)
Message-ID: <0306abfd-565f-2081-21a6-dbaf3c36044e@gmail.com>
Date:   Wed, 13 Jul 2022 14:05:06 +1200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 2/5] m68k - set up platform device for mvme147_scsi
Content-Language: en-US
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20220712075832.23793-1-schmitzmic@gmail.com>
 <20220712075832.23793-3-schmitzmic@gmail.com>
 <CAK8P3a2ptjH3VyCjuwQROw8GuOs8CxuhX8dMBxMa5m-Q93yZ_g@mail.gmail.com>
 <7b652abd-3094-e0c8-d8fb-087c60c51fa2@gmail.com>
 <4faebfc0-4fc4-aff6-a507-293d755893ba@gmail.com>
In-Reply-To: <4faebfc0-4fc4-aff6-a507-293d755893ba@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arnd,

On 12/07/22 21:28, Michael Schmitz wrote:
>
>>> I think you actually have to use platform_device_register_full() to 
>>> pass
>>> a DMA mask here: As I understand it, the dma_set_mask_and_coherent()
>>> call in the driver fails if the device is not already marked as dma
>>> capable by having an initial mask set.
>>
>> I'll take a look at that - if true, this requires the amiga-a3000-scsi
>> platform device set-up be changed in the same way (the gvp11 and a2091
>> drivers inherit the DMA mask from the Zorro bus default, so ought to
>> work OK).
>
> I think we are good with using platform_device_register_simple():
>
> setup_pdev_dma_masks() sets the DMA mask to 32 bit when allocating a 
> new platform device, and platform_device_register_full() only changes 
> that when passed in a non-zero mask in pdevinfo.
>
> platform_device_register_simple() leaves the pdevinfo mask zero, so 
> the 32 bit default set in setup_pdev_dma_masks() survives.

Verified by having pata_falcon print the default DMA mask (0xffffffff), 
then setting a 24 bit DMA mask and reading it back.

That did uncover an error I made in the gvp11 driver - the devices' 
default DMA mask there is given as a 32 bit integer, but the DMA API 
needs 64 bit. Will send a separate fix for that.

Cheers,

     Michael

>
> Cheers,
>
>     Michael
>
>>
>> Cheers,
>>
>>     Michael
>>
>>> The way this normally works is that the device gets created with a mask
>>> that reflects the capabilities of the bus, while the driver sets a mask
>>> based on what it wants to program into the device, and the dma-mapping
>>> interfaces ensure that we only use the intersection of those.
>>>
>>>         Arnd
>>>
