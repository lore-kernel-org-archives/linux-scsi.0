Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AFE2C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 19:37:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344143AbiA1ThW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 14:37:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43956 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233070AbiA1ThV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jan 2022 14:37:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643398641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sJ78PqpfaYdoTQU7JcioKlmBoZlxq+jRcIlavIlWaQw=;
        b=Z8q5S7QA0uW+cvVGnuqhqNblWPHsSacXxEdsTpnI56NNhQtyEYMM4K/yAS6tSxh64NgSGv
        W/m8+j/1tl2bjTVrAs4PgsJjze87PnISILX9FnjE7fmCUHW2PTOvU2X843COLC2qAEDJec
        cnujYtuZeMNFw3JnqQjNLmsyNB3bwOc=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-314-J_J8fP8APt20f17DlTzKdA-1; Fri, 28 Jan 2022 14:37:20 -0500
X-MC-Unique: J_J8fP8APt20f17DlTzKdA-1
Received: by mail-ot1-f70.google.com with SMTP id w18-20020a9d5a92000000b005a2408be392so3703624oth.18
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2022 11:37:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=sJ78PqpfaYdoTQU7JcioKlmBoZlxq+jRcIlavIlWaQw=;
        b=wgmHYvl/8mLN+4qjlQMWGhJO6uLqoWv75pTNt9nEWZsBqbneqZgDrKvjvE0ykjF2M/
         dJU51ZvbyPr1HNAy4B6KO91FegBG6wuJ7lc5csVSRdMtuZuVWE3omMQ4tG7S3tgvxVuz
         7fT9e1+ieCzI4Ey4fzaf7HRrYRMGuX5FSzM/NwgsTwiedye1KmVvuZdUpEpEA/yI6yMG
         TOqEEkILsRLIXD0OPul0Hvrobbot3edXqGQVtPOyV3npfsBkOwa0/oK/2E5i3AFtRCC7
         D+pm+gNfhrR1AS50xYFZIct1p8H4HlRLnUKzd5YXWehsIwWosx6qYK8I7n/5JrUdWn75
         cOdg==
X-Gm-Message-State: AOAM532FFeNnfNpupwtU/1NUkq1cj5spsJFqXvsX2s8BIjw12i2w7ZPM
        +HxTigcNPo9FfxomZnX3IRwHtF/ss3Zn/FPpYMGumd8f9tyYg2A+MWyolXlYvMFgp5EjngWo04X
        tzJLHD5u1Ck9XRmNZqCMuqQ==
X-Received: by 2002:a05:6808:302a:: with SMTP id ay42mr10605355oib.9.1643398639363;
        Fri, 28 Jan 2022 11:37:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwJH5+YbwP3uDIx0eIMGxxU4M5Gxe9auKJAqcbbxh30RRitEA2FqyPq4CXplO1Q4MwMWUJJZQ==
X-Received: by 2002:a05:6808:302a:: with SMTP id ay42mr10605345oib.9.1643398639151;
        Fri, 28 Jan 2022 11:37:19 -0800 (PST)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id g20sm12023713oiy.34.2022.01.28.11.37.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jan 2022 11:37:18 -0800 (PST)
Subject: Re: [PATCH] scsi: megaraid: cleanup formatting of megaraid
To:     Joe Perches <joe@perches.com>,
        Bart Van Assche <bvanassche@acm.org>,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, nathan@kernel.org,
        ndesaulniers@google.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20220127151945.1244439-1-trix@redhat.com>
 <d26d4bd8-b5e1-f4d5-b563-9bc4dd384ff8@acm.org>
 <0adde369-3fd7-3608-594c-d199cce3c936@redhat.com>
 <e3ae392a16491b9ddeb1f0b2b74fdf05628b1996.camel@perches.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <46441b86-1d19-5eb4-0013-db1c63a9b0a5@redhat.com>
Date:   Fri, 28 Jan 2022 11:37:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <e3ae392a16491b9ddeb1f0b2b74fdf05628b1996.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 1/28/22 11:11 AM, Joe Perches wrote:
> On Fri, 2022-01-28 at 09:59 -0800, Tom Rix wrote:
>> On 1/28/22 9:42 AM, Bart Van Assche wrote:
>>> On 1/27/22 07:19, trix@redhat.com wrote:
>>>> From: Tom Rix <trix@redhat.com>
>>>>
>>>> checkpatch reports several hundred formatting errors.
>>>> Run these files through clang-format and knock off
>>>> some of them.
>>> Isn't this the kind of patches that carries more risk than value?
> Risk for whitespace style reformatting patches is quite low.
>
> Nominally, clang-format changes should not produce a different
> compiled object file unless __LINE__/__DATE__/__TIME__ style
> changes occur.
>
> If it does, the clang-format tool is broken.
>
>>> Additionally, this patch conflicts with a patch series that I plan to
>>> post soon.
> []
>> Long term, it would be good have a reliable way to automatically fix
>> either new files or really broken old files.
> That's really a maintainer preference no?
>
> Especially so for any automation.

In practice everything is up to the maintainer.

If some maintainer wants fix their formatting then clang-format should 
just work

It isn't likely they will have time to hand fix every file.

Tom

>
>

