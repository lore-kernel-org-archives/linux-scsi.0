Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871B7C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Mar 2022 13:46:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230415AbiCDNq6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Mar 2022 08:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiCDNq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Mar 2022 08:46:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BE8871B84CC
        for <linux-scsi@vger.kernel.org>; Fri,  4 Mar 2022 05:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646401568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6AS9vldJLrqi2tiwa++Hi55C1gYgBHhwabhvXG7rxQc=;
        b=Mlq7tyfpKDjbYhnt6OTrR91mmJKbpVtfvBpXSCUdoCLmtdEpkCmmPs+BYHTMpsnbTZDqf0
        yAKd+vI4Z2FyJ9nY2tadugBbwwcrpmsGO1ikPEKd1s3OSYAOIpowOkaYxGU1GBpxa9Ze+i
        UJDmZ4H0UOB0rd8mFn3KyeiVybxDo8Y=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-1xLvfPQ7Pm--Bpyxxh62bA-1; Fri, 04 Mar 2022 08:46:07 -0500
X-MC-Unique: 1xLvfPQ7Pm--Bpyxxh62bA-1
Received: by mail-qv1-f69.google.com with SMTP id fv11-20020a056214240b00b0043253a948f0so6821159qvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Mar 2022 05:46:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=6AS9vldJLrqi2tiwa++Hi55C1gYgBHhwabhvXG7rxQc=;
        b=RsV/hn/Hd8hNomAjzBiKqWmkUmUDs05EsSmvqBKRgE9JPgUsTINBM1RaUxRf4fmo6+
         5B6nCATuQvDsPilcuA+ajUA00lViZ5hBuuov6IYZLirpuEUWd1/W8wvjv26ag+tA0MlW
         2jNYd+//kzfsj2SOieUnH67GZnAdgnZGwD2FOCfLG9lKZLFxsAwsIwilx9fV0sUlGT8T
         46Ad0sq78thi5TEN83WwWhZ3g5dUz455Nw4Bcba73FGQZp2PXulr3W/Qgy9HZEYJrWYb
         pP4AuW+IsPlBoP/wPTZXgTj1zbj95THYkE7NE4Wz+bVa75GadhN3gGaUy4adWwtetdWj
         TTRg==
X-Gm-Message-State: AOAM531ADluFtgLIIpQeHk2ZeK/2QuF+2cOK+jOPMqW+u0iwMlrqGNuO
        G6ymxouFVjvVlMSa5JzeKh5QSJiF2AT+2lB/Nd/3qdfX+piWaqjvubV8ooNW0DsBAFVkEaHXDzE
        beg0rEdt7mIQrAX74yZzt/A==
X-Received: by 2002:a05:622a:1392:b0:2de:4e16:d7a9 with SMTP id o18-20020a05622a139200b002de4e16d7a9mr31925006qtk.680.1646401567387;
        Fri, 04 Mar 2022 05:46:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQHhXySv6wvXYlS/EA/l4dJ+N4lPXOuDXMCujrScg7kQKn2HWmh5DC1HAgcq3MPtMYpIqgwA==
X-Received: by 2002:a05:622a:1392:b0:2de:4e16:d7a9 with SMTP id o18-20020a05622a139200b002de4e16d7a9mr31924981qtk.680.1646401567142;
        Fri, 04 Mar 2022 05:46:07 -0800 (PST)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id o4-20020a05620a22c400b006490deb5687sm2375962qki.76.2022.03.04.05.46.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Mar 2022 05:46:06 -0800 (PST)
Subject: Re: [PATCH] scsi: megaraid: cleanup formatting of megaraid
To:     Joe Perches <joe@perches.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Finn Thain <fthain@linux-m68k.org>
Cc:     Konrad Wilhelm Kleine <kkleine@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        megaraidlinux.pdl@broadcom.com, scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, llvm@lists.linux.dev
References: <20220127151945.1244439-1-trix@redhat.com>
 <d26d4bd8-b5e1-f4d5-b563-9bc4dd384ff8@acm.org>
 <0adde369-3fd7-3608-594c-d199cce3c936@redhat.com>
 <e3ae392a16491b9ddeb1f0b2b74fdf05628b1996.camel@perches.com>
 <46441b86-1d19-5eb4-0013-db1c63a9b0a5@redhat.com>
 <8dd05afd-0bb9-c91b-6393-aff69f1363e1@redhat.com>
 <233660d0-1dee-7d80-1581-2e6845bf7689@linux-m68k.org>
 <CABRYuGk+1AGpvfkR7=LTCm+bN4kt55fwQnQXCjidSXWxuMWsiQ@mail.gmail.com>
 <95f5be1d-f5f3-478-5ccb-76556a41de78@linux-m68k.org>
 <CANiq72kOJh_rGg6cT+S833HYqwHnZJzZss8v+kQDcgz_cZUfBQ@mail.gmail.com>
 <7368bc3ea6dece01004c3e0c194abb0d26d4932b.camel@perches.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <9dc86e74-7741-bb8e-bbad-ae96cebaaebc@redhat.com>
Date:   Fri, 4 Mar 2022 05:46:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <7368bc3ea6dece01004c3e0c194abb0d26d4932b.camel@perches.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 3/3/22 3:38 PM, Joe Perches wrote:
> On Fri, 2022-03-04 at 00:17 +0100, Miguel Ojeda wrote:
>> On Thu, Mar 3, 2022 at 11:44 PM Finn Thain <fthain@linux-m68k.org> wrote:
>>> Others might argue that they should always be changed from,
>>>
>>> /*
>>>   * this style
>>>   * of multiline comment
>>>   */
>>>
>>> to
>>>
>>> /* this style
>>>   * of multiline comment
>>>   */
>> In general, for things that the coding style guide talks about, we
>> should follow them, even if some subsystems do not (they can always
>> override in their folder if they really, really want it). So, here for
>> instance, the first one should be used.
> It's up to individual maintainers to each decide on what might be
> considered unnecessary churn for the subsystems they control.

clang-format does not have an opt-in mechanism like indent, it is 
all-or-nothing

What is done is all the settings in .clang-format and the default settings.

The churn level will be very high.

Until clang-format has an opt-in mechanism, I do not think clang-format 
should be used.

.clang-format should be moved to staging/ to reflect its not being ready 
status.

staging/ would be a good long term home. it's content should not need 
backporting and is more likely to have style issues.

Tom

>
> One argument is that churn leads to difficulty in backporting
> fixes to older 'stable' versions.
>
> I think the churn argument is overstated.
>
>

