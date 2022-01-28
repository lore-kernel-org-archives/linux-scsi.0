Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1204C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 05:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243094AbiA1FbP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 00:31:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237630AbiA1FbO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jan 2022 00:31:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643347873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OD6WAteNVjoEL5BdQQseFUQxBcO/VHXKit43SSCC07c=;
        b=UvUAdSj08xuzeOBLLazUkp/fTI6Ude/M4yTPFV7RT/rCiaOcIDzMCXOY4egUjgxV/tXeG7
        OwWXaAFr9NZ0Htx+D7RBWiHjgI/5LFDC+Abg4q9Rav/8kQcfqlx1V4RmhHCp6OnTlxJGlP
        XcoI0KmpbHN13jgUziSYefEMlmT4PQM=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-JsM-ACgsOc6THUKrtYkSaw-1; Fri, 28 Jan 2022 00:31:12 -0500
X-MC-Unique: JsM-ACgsOc6THUKrtYkSaw-1
Received: by mail-oi1-f198.google.com with SMTP id bq20-20020a05680823d400b002cac339e9b0so2690208oib.4
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 21:31:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=OD6WAteNVjoEL5BdQQseFUQxBcO/VHXKit43SSCC07c=;
        b=H8bhtyS5V27GEA83NbXRLpVfKP+FeHv4b+zsZMWK4mcIKvxCH/QzpyT4+FVqzY9DHm
         7nIvWfW1wGx/Fxw70sARInZiNzxS7JyfoHZ63I6+CV75AcyHcXdzXtef2pOexhNgN4NH
         NZEHPXLEbosd8PRbv10kHA3gkgo4I3/6arTWklU/LYWkvhxlOCab7+vK9OWsNU65DOKV
         ATKeBsAd80WjFO4v08HHoGWsILvMc2WI50f1/1m4CNZt9X+kN43mhDh9jyWQJfcEtffi
         IqDoQs+2i7pu7v/EivKruQDI6fsHVFIwrEA8q9UCKnT1ZZzHWHBF+Lb4NoK36VEWxl6+
         xyWQ==
X-Gm-Message-State: AOAM532B7km8Lx1OvrMXcJ/FNOlmcSTLizR0N0HKZzrHzKawnYMmfCEp
        xh5gNUAn6GCIVkd0jM2DY3WMWavXllwKqldtAGiVSJ0ZD71IvpY9xanP7YomW5BcebCHnchi4YO
        nWOHfUXDnkKyNKiZ9n2Y4gw==
X-Received: by 2002:aca:45c4:: with SMTP id s187mr8701054oia.306.1643347871372;
        Thu, 27 Jan 2022 21:31:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyuhkflKEAecETUqZfO5ziqGnq0F7Y7PbpsqMcaOvz3syLgEDVc9dZjOB54pRce/FUMMXYg5g==
X-Received: by 2002:aca:45c4:: with SMTP id s187mr8701050oia.306.1643347871213;
        Thu, 27 Jan 2022 21:31:11 -0800 (PST)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id m7sm2628382ots.32.2022.01.27.21.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 21:31:10 -0800 (PST)
Subject: Re: [PATCH] scsi: megaraid: cleanup formatting of megaraid
To:     Joe Perches <joe@perches.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Finn Thain <fthain@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, nathan@kernel.org,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20220127151945.1244439-1-trix@redhat.com>
 <953eb015-4b78-f7b-5dc1-6491c6bf27e@linux-m68k.org>
 <CAKwvOdnWHVV+3s8SO=Q8FfZ7hVekRVDL5q+7CwAk_z44xaex8w@mail.gmail.com>
 <fb308f51-f16b-3d9b-80c2-180940236b00@redhat.com>
 <5554a75f65fddab4de60d61fd503fe73773dafbb.camel@perches.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <c801989d-5f3e-84d2-24a0-7022be70da98@redhat.com>
Date:   Thu, 27 Jan 2022 21:31:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5554a75f65fddab4de60d61fd503fe73773dafbb.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 1/27/22 6:43 PM, Joe Perches wrote:
> On Thu, 2022-01-27 at 16:32 -0800, Tom Rix wrote:
>> On 1/27/22 2:47 PM, Nick Desaulniers wrote:
>>> + Miguel (the clang-format maintainer), Joe (checkpatch maintainer)
>>> These criticisms are worth reviewing.
>>>
>>> On Thu, Jan 27, 2022 at 2:38 PM Finn Thain <fthain@linux-m68k.org> wrote:
>>>> On Thu, 27 Jan 2022, trix@redhat.com wrote:
>>>>
>>>>> From: Tom Rix <trix@redhat.com>
>>>>>
>>>>> checkpatch reports several hundred formatting errors. Run these files
>>>>> through clang-format and knock off some of them.
>>>>>
>>>> That method seems like a good recipe for endless churn unless checkpatch
>>>> and clang-format really agree about these style rules.
>>>>
>>>> Why use checkpatch to assess code style, if we could simply diff the
>>>> existing source with the output from clang-format... but it seems that
>>>> clang-format harms readability, makes indentation errors and uses
>>>> inconsistent style rules. Some examples:
>> Problems with clang-format should be fixed, I'll take a look.
>>
>> I was reviewing this file for another issue and could not get past how
>> horredously bad it was and really did not want to manually fix the 400+
>> formatting errors.  I will drop this patch and use the use these files
>> to verify the .clang-format .
> I think this is more an issue with clang-format than with checkpatch.
>
> If you have specific issues with what checkpatch reports for this
> file (or any other file), let me know.

Yes, I agree. Its a clang-format problem.

I will be looking to minimize the .clang-format settings to only those 
that agree with checkpatch.

Then add settings back in later if their problems can be worked out.

Tom

