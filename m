Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F1D9C7EE23
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 00:52:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjCBAwA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 19:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCBAv7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 19:51:59 -0500
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6FE5653F;
        Wed,  1 Mar 2023 16:51:58 -0800 (PST)
Received: by mail-pj1-f50.google.com with SMTP id kb15so15231270pjb.1;
        Wed, 01 Mar 2023 16:51:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y+yLQf2HtdYkOd2g1kdvKMafe5s+xMLejYeBI5YFR7Q=;
        b=m94i8vMtDE+gIKx6k2bnecM3ITyX5iAT9fmglPe/H8ffP+v2qqagdD9z3jTMxAKn77
         v3Ajx1j1K5MsHqLXQ4nsBJFcxpUjZwencUqXo+YuH9SEqBb2jpQYAahWMYmNYX2weMIT
         dCWoC62v1zEWpuB81hC53aotTCJWVaPgoxOtqSlDMWY2cHzXhW4U6G3iFnCnwn5EPGte
         +oEFaebh5/zRAU6nC0l+OvvBhxIJoicWDRXMB3pLjKkD+lRJPTkfee6xsTPerKtHvWcu
         PTvBWLeSfe6ZBG8lQv46hQ+OV593vQ87RBVcDs6LOzgTWcXvS6wj0HNYi6Yt/R6h8NZq
         c7Cw==
X-Gm-Message-State: AO0yUKVLVcKUF7RAiH5ZCTkwTucPZF1xrRTzBCbjlS0k21x6cq8Ip1SR
        A1mhrhGm7Mv0FZ8A9yz+Zg/XeG5Z2Bw=
X-Google-Smtp-Source: AK7set+H6K9vJywU4qfeJq7kp1LfRcE9Leuk9g/3JeI149BkHyhcjqaRDArzPjaUfTPo+Wb5iK+pGQ==
X-Received: by 2002:a17:903:2292:b0:19a:5f59:f100 with SMTP id b18-20020a170903229200b0019a5f59f100mr431890plh.9.1677718317299;
        Wed, 01 Mar 2023 16:51:57 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id x65-20020a17090a6c4700b0022bf4d0f912sm353737pjj.22.2023.03.01.16.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 16:51:56 -0800 (PST)
Message-ID: <569dc9d2-3e6c-0efc-560c-bfcacfbfbda7@acm.org>
Date:   Wed, 1 Mar 2023 16:51:54 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [LSF/MM/BPF TOPIC] Hybrid SMR HDDs / Zone Domains & Realms
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Khazhy Kumykov <khazhy@chromium.org>,
        lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <CACGdZYKXqNe08VqcUrrAU8pJ=f88W08V==K6uZxRgynxi0Hyhg@mail.gmail.com>
 <ad8b054a-26a5-ea60-9c66-4a6b63ca27ef@acm.org>
 <54fb85ac-7c45-f77f-11d7-9cb072f702fb@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <54fb85ac-7c45-f77f-11d7-9cb072f702fb@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/23 16:06, Damien Le Moal wrote:
> On 3/2/23 08:50, Bart Van Assche wrote:
>> On 3/1/23 15:34, Khazhy Kumykov wrote:
>>>    - There’s already support in the kernel for marking zones
>>> online/offline and cmr/smr, but this is fixed, not dynamic. Would
>>> there be hiccups with allowing zones to come online/offline while
>>> running?
>>
>> It may be easier to convince HDD vendors to modify their firmware such
>> that the conventional and SMR zones are reported to the Linux kernel as
>> different logical units rather than adding domains & realms support in
>> the Linux kernel. If anyone else has another opinion, feel free to share
>> that opinion.
> 
> That would not resolve the fact that each unit would still potentially have a
> mix of active and inactive areas. Total nightmare to deal with unless a zone API
> is also exposed for any user to figure out which zone is active.
> That means that we would need to always expose these drives as zoned, using a
> very weird zone model as zone domains/zone realms do not fit at all with the
> current host-managed model. Lots of places need changes to handle these drives.
> This will make things very messy all over.

Do users need all the features that are supported by the domains & 
realms model? If not: what I had in mind is to let the HDD expose two 
logical units to the operating system that each have a contiguous range 
of active zones and hence not to support inactive zones.

Thanks,

Bart.

