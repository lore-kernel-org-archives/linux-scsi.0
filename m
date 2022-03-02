Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA8AC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 19:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244953AbiCBTPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 14:15:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbiCBTP3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 14:15:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 495DC51306
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 11:14:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646248484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YiPVDUBebs7EB1B9i8U5kkuWPnwl3uCi7XbX0p51YuI=;
        b=PmoXzez90gjGqH5AFCOBzc0ZDO2A6nNhOybBKB1QFXTfvTYy60gx8ZEe8sPGk+FPpCm79O
        xc1Jl4CD+CoqjrV/rMZwX/vs11yo2/UXGXX7RS0iF29g4Yu+aLvw8TzE79YY2VnBLhLkhG
        SwsNw7fksGoQe0FJ9Rbit70bsz8P+rM=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-198-80OBA4csNWS6mOjdLwl7-g-1; Wed, 02 Mar 2022 14:14:43 -0500
X-MC-Unique: 80OBA4csNWS6mOjdLwl7-g-1
Received: by mail-oo1-f69.google.com with SMTP id j3-20020a4a92c3000000b00319481d8795so1865043ooh.9
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 11:14:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=YiPVDUBebs7EB1B9i8U5kkuWPnwl3uCi7XbX0p51YuI=;
        b=434Yy/RYOjO6pH3wq810yp+cRpjFp3NTQCckKRiVrWYdJo3nRJeXYTjZfA+zEj0r3M
         2vFzIejcjNsMBzPzHJZIvrgN51sh5Pyv/ugy0KDoAJZrw2mY7wBLUeQskWOnn9JET6OQ
         uJdIgUfpsUI+xFiSC6KZ+L39EgrHgBq5ZWDr0KCc/UiuMcFz0IHtC+VzfdiWp5AHSzg6
         I7HTEoK7EG98Pxw8gIk3w0ikDmNgqZYRo72qXJzsBlTMzwIrzTUCzniXTOeRrX3KPR+a
         MR7/2MeLYmAZLUdXf2dAUcRVkBq1eGtcj0ubR1q6rIH0h48dXNLWMi3BDdbLM6k1vkf1
         2rRg==
X-Gm-Message-State: AOAM5330pzigQemphEfa/Mj65rOV8unDeLCoOsGgnsEEdrkzy+Ch4l3N
        Dj67RnAVZeorFyUPgOsRXw1k64iRMFmd8WVn218D90Bajt/aGxBTDodgAJwsOf3owz+5j5PLdU+
        eD0gLcSOXFnpyoqbBtYn87Q==
X-Received: by 2002:a9d:6f82:0:b0:5af:1555:5a9b with SMTP id h2-20020a9d6f82000000b005af15555a9bmr17592469otq.289.1646248482660;
        Wed, 02 Mar 2022 11:14:42 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxB4KkiaJYio4742IBRrbpirlsfY7jDTJSDYE0Y2LApyDfwNM6nimi0+dhckWOYXqK7oHp9AA==
X-Received: by 2002:a9d:6f82:0:b0:5af:1555:5a9b with SMTP id h2-20020a9d6f82000000b005af15555a9bmr17592453otq.289.1646248482460;
        Wed, 02 Mar 2022 11:14:42 -0800 (PST)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id q13-20020a0568080ecd00b002d44f01f1d7sm10093409oiv.40.2022.03.02.11.14.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 11:14:42 -0800 (PST)
Subject: Re: [PATCH] scsi: megaraid: cleanup formatting of megaraid
From:   Tom Rix <trix@redhat.com>
To:     Joe Perches <joe@perches.com>,
        Bart Van Assche <bvanassche@acm.org>,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, nathan@kernel.org,
        ndesaulniers@google.com, Konrad Kleine <kkleine@redhat.com>
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20220127151945.1244439-1-trix@redhat.com>
 <d26d4bd8-b5e1-f4d5-b563-9bc4dd384ff8@acm.org>
 <0adde369-3fd7-3608-594c-d199cce3c936@redhat.com>
 <e3ae392a16491b9ddeb1f0b2b74fdf05628b1996.camel@perches.com>
 <46441b86-1d19-5eb4-0013-db1c63a9b0a5@redhat.com>
Message-ID: <8dd05afd-0bb9-c91b-6393-aff69f1363e1@redhat.com>
Date:   Wed, 2 Mar 2022 11:14:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <46441b86-1d19-5eb4-0013-db1c63a9b0a5@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 1/28/22 11:37 AM, Tom Rix wrote:
>
> On 1/28/22 11:11 AM, Joe Perches wrote:
>> On Fri, 2022-01-28 at 09:59 -0800, Tom Rix wrote:
>>> On 1/28/22 9:42 AM, Bart Van Assche wrote:
>>>> On 1/27/22 07:19, trix@redhat.com wrote:
>>>>> From: Tom Rix <trix@redhat.com>
>>>>>
>>>>> checkpatch reports several hundred formatting errors.
>>>>> Run these files through clang-format and knock off
>>>>> some of them.
>>>> Isn't this the kind of patches that carries more risk than value?
>> Risk for whitespace style reformatting patches is quite low.
>>
>> Nominally, clang-format changes should not produce a different
>> compiled object file unless __LINE__/__DATE__/__TIME__ style
>> changes occur.
>>
>> If it does, the clang-format tool is broken.
>>
>>>> Additionally, this patch conflicts with a patch series that I plan to
>>>> post soon.
>> []
>>> Long term, it would be good have a reliable way to automatically fix
>>> either new files or really broken old files.
>> That's really a maintainer preference no?
>>
>> Especially so for any automation.
>
> In practice everything is up to the maintainer.
>
> If some maintainer wants fix their formatting then clang-format should 
> just work
>
> It isn't likely they will have time to hand fix every file.

A follow up issue in the clang project has been raised by Konrad, here

https://github.com/llvm/llvm-project/issues/54137

Tom


>
> Tom
>
>>
>>

