Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D9BC433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 18:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbiA1SAB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 13:00:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24914 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235745AbiA1SAA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jan 2022 13:00:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643392799;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u+Hmwc9+6O6R90bO9i51djyWsBTgueZPwQigGIkzQcY=;
        b=F4skjyGf/l4LzaJQ7R4iBqESqcW6YAq/mnf16jij3kkXz29kpeXVAw3bC0/WnRHZKk4eqp
        ghqL78vwjb/RCDfDxPwwghAVtheIeixhqxpQ5K94LWKOwXux/aM9QzYIVp8wFfQHaP1NI1
        KUwaZdhk3il+5LY7o+7QVZsIj7XSJXc=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-284-PHbUtWsZM4a8KfXDlzTg4g-1; Fri, 28 Jan 2022 12:59:58 -0500
X-MC-Unique: PHbUtWsZM4a8KfXDlzTg4g-1
Received: by mail-oo1-f72.google.com with SMTP id n30-20020a4a611e000000b002e519f04f8cso3537510ooc.7
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 09:59:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=u+Hmwc9+6O6R90bO9i51djyWsBTgueZPwQigGIkzQcY=;
        b=Ig0wKaQ2l+W3AUyB5FKrFGc2C3FbSDa1AAMWnDISFPef3dIOForZOhCeA+WpssVo4V
         Xcf9K4GlgkbryL1uUDViqk38r7PzecK4hHSz2XXIZbYdjXPRcaJXWlugymwehQuPUWWR
         E4BNh4/AyIVVb3XrU2/97+dDkACC2226IybJb+23aURDe5zG2V4d/msVdyG7JqbYzUHT
         IzvFsRRM6EojVrJDBXCr1Ojnqamjq58T3kZ9TB5gj1a5tq4keZS21mKk8dIlJBdtp8iU
         Y/xGsKWIgJ2yNuvs/HTRHM83gEy7oszSu9EDQRj0lnq9jEi1a/3bbEYHBQ5x17WHgQKJ
         W14g==
X-Gm-Message-State: AOAM530L1Qjy7XDeyvF8l9yQn5kxfsruCWcSL1k/hAZ6pEEUfm0F3ASQ
        WIAclWj5de4154EkgYbq9Y7f7hsrtzsA/Bto8UzKjnsMIxKTcFIBH/u+L8oEbns+IKXoVSqfPrS
        vVbY2caDbxT0mMGPrV6L0Zw==
X-Received: by 2002:a05:6830:1091:: with SMTP id y17mr5517930oto.251.1643392798033;
        Fri, 28 Jan 2022 09:59:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx7tzvwbAnDL33am0wCZlnAvRFJbSDVAbo5b1w5J/mtfZ8VVd+wV4q4yxN0XRiY8J66auWK3w==
X-Received: by 2002:a05:6830:1091:: with SMTP id y17mr5517919oto.251.1643392797859;
        Fri, 28 Jan 2022 09:59:57 -0800 (PST)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id l19sm4578463ooa.7.2022.01.28.09.59.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 09:59:57 -0800 (PST)
Subject: Re: [PATCH] scsi: megaraid: cleanup formatting of megaraid
To:     Bart Van Assche <bvanassche@acm.org>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20220127151945.1244439-1-trix@redhat.com>
 <d26d4bd8-b5e1-f4d5-b563-9bc4dd384ff8@acm.org>
From:   Tom Rix <trix@redhat.com>
Message-ID: <0adde369-3fd7-3608-594c-d199cce3c936@redhat.com>
Date:   Fri, 28 Jan 2022 09:59:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d26d4bd8-b5e1-f4d5-b563-9bc4dd384ff8@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 1/28/22 9:42 AM, Bart Van Assche wrote:
> On 1/27/22 07:19, trix@redhat.com wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> checkpatch reports several hundred formatting errors.
>> Run these files through clang-format and knock off
>> some of them.
>
> Isn't this the kind of patches that carries more risk than value? 
> Additionally, this patch conflicts with a patch series that I plan to 
> post soon.
>
> Thanks,

I have dropped this patch.

Long term, it would be good have a reliable way to automatically fix 
either new files or really broken old files.

So you could do two patches, first would be fixing formatting problems 
and second would new stuff.

As it is your new patch will have to both for now.

Tom

>
>
> Bart.
>

