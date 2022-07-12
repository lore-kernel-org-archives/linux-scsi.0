Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B48B2C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 09:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbiGLJ2b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 05:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbiGLJ23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 05:28:29 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBA09E443;
        Tue, 12 Jul 2022 02:28:28 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id v7so4941368pfb.0;
        Tue, 12 Jul 2022 02:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=xdlLsXcXr4pB8OtKr+yvxyVmFWoAJCk6OqnB3IKUIm0=;
        b=Jr4eekZpAsbACqB4sswYbvoqxW7qIs7bC8Xvy5fWKWpbZp1KnUPw4dTuWpNQAG9OlC
         BxYnlk/8mnlAhc42zpL0t00244TWdT5pzsYXc6jd6UpM8nsh36DpgBhEFFE4P7r6K/tQ
         VOP7hv1BA9mcXgs4Kv2Okgnnpz/Vb7MOjX8a4BeYBbC230tErX1wucl4LwJmINnExNZH
         ifkEkLTnvIw8tIPQq6Fzx7B39NIRzJ30L4KMj/ICvb0avFy0AJeQNeC3Eq82qyPdzxWS
         nPUTi9MYZ7sW+kBzkwOEPQQW3mlsweAd35QsnIhFndIgFwMoLovJd/8mPYhflx2y5Hmv
         KUHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=xdlLsXcXr4pB8OtKr+yvxyVmFWoAJCk6OqnB3IKUIm0=;
        b=weu2J5NEnzwHHGtyLGalR94qoO+RxmUxGmdl6fvmcwBkEwaavODvbodXrrCijBbSC+
         Bf+pEL3c7ojFyKkB8Oe2OOg4P3PBuEjSgCAZVcbTISWxIeOYghzw15yJWXbayChhtLdO
         nxk/7H9Gmx5Q9CrRMVmcQ7Buznd9L95wBPsNV0c8k5AX3AJdOz5obdMA4vyxsiS3sN6Q
         1kC1g6gc8OiovmNKvxkOX+HUF3TSUlM3e0w+DPf88ckUJeijlqXQhvCm7Ygsf376k6iY
         0/N31GtGLdCgNSV9Ayi72a14zUy8vVmn92DjceKH/vjfqtrWT73nXxDkh/VWZbsf0ltc
         EMRw==
X-Gm-Message-State: AJIora9wCqzlH0Atqg0AxU++92/5nfw2UrJ1gKDqPwVvPDKgPhyPd5Go
        PVWQb/+R0GtN9ONg1h3KVpU=
X-Google-Smtp-Source: AGRyM1v5KtRVt03pirfRDPvDZsebDF9ed56r5b2YIvJIHY3Ug8SQvQDxXcHfaSPBnKaS6Oo83dGH9A==
X-Received: by 2002:a62:a516:0:b0:505:722e:15d5 with SMTP id v22-20020a62a516000000b00505722e15d5mr23151184pfm.52.1657618107861;
        Tue, 12 Jul 2022 02:28:27 -0700 (PDT)
Received: from [10.1.1.24] (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id b8-20020a17090a488800b001f02a72f29csm4608578pjh.8.2022.07.12.02.28.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Jul 2022 02:28:27 -0700 (PDT)
Subject: Re: [PATCH v2 2/5] m68k - set up platform device for mvme147_scsi
To:     Arnd Bergmann <arnd@kernel.org>
References: <20220712075832.23793-1-schmitzmic@gmail.com>
 <20220712075832.23793-3-schmitzmic@gmail.com>
 <CAK8P3a2ptjH3VyCjuwQROw8GuOs8CxuhX8dMBxMa5m-Q93yZ_g@mail.gmail.com>
 <7b652abd-3094-e0c8-d8fb-087c60c51fa2@gmail.com>
Cc:     Linux/m68k <linux-m68k@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <4faebfc0-4fc4-aff6-a507-293d755893ba@gmail.com>
Date:   Tue, 12 Jul 2022 21:28:23 +1200
User-Agent: Mozilla/5.0 (X11; Linux ppc; rv:45.0) Gecko/20100101
 Icedove/45.4.0
MIME-Version: 1.0
In-Reply-To: <7b652abd-3094-e0c8-d8fb-087c60c51fa2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arnd,

Am 12.07.2022 um 21:07 schrieb Michael Schmitz:
> Hi Arnd,
>
> Am 12.07.2022 um 20:12 schrieb Arnd Bergmann:
>> On Tue, Jul 12, 2022 at 9:58 AM Michael Schmitz <schmitzmic@gmail.com>
>> wrote:
>>> +
>>> +static const struct resource mvme147_scsi_rsrc[] __initconst = {
>>> +       DEFINE_RES_MEM(MVME147_SCSI_BASE, 0xff),
>>
>> Still the wrong size?
>
> Too true - forgot to fix that, sorry.
>
>>
>>> +       DEFINE_RES_IRQ(MVME147_IRQ_SCSI_PORT),
>>> +};
>>> +
>>> +int __init mvme147_platform_init(void)
>>> +{
>>> +       struct platform_device *pdev;
>>> +       int rv = 0;
>>> +
>>> +       pdev = platform_device_register_simple("mvme147-scsi", -1,
>>> +               mvme147_scsi_rsrc, ARRAY_SIZE(mvme147_scsi_rsrc));
>>
>> I think you actually have to use platform_device_register_full() to pass
>> a DMA mask here: As I understand it, the dma_set_mask_and_coherent()
>> call in the driver fails if the device is not already marked as dma
>> capable by having an initial mask set.
>
> I'll take a look at that - if true, this requires the amiga-a3000-scsi
> platform device set-up be changed in the same way (the gvp11 and a2091
> drivers inherit the DMA mask from the Zorro bus default, so ought to
> work OK).

I think we are good with using platform_device_register_simple():

setup_pdev_dma_masks() sets the DMA mask to 32 bit when allocating a new 
platform device, and platform_device_register_full() only changes that 
when passed in a non-zero mask in pdevinfo.

platform_device_register_simple() leaves the pdevinfo mask zero, so the 
32 bit default set in setup_pdev_dma_masks() survives.

Cheers,

	Michael

>
> Cheers,
>
>     Michael
>
>> The way this normally works is that the device gets created with a mask
>> that reflects the capabilities of the bus, while the driver sets a mask
>> based on what it wants to program into the device, and the dma-mapping
>> interfaces ensure that we only use the intersection of those.
>>
>>         Arnd
>>
