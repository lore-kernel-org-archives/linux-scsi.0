Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B04F1C05027
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Jan 2023 17:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231640AbjAZRd5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Jan 2023 12:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229813AbjAZRd5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jan 2023 12:33:57 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D483D92A;
        Thu, 26 Jan 2023 09:33:56 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id lp10so2196424pjb.4;
        Thu, 26 Jan 2023 09:33:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZGK06YoP32l1GWMGYQiaA0u5fJCl15ikGlRsUs8jD9M=;
        b=wWgau1OOUTit+DaQBsqmYJd7JAGeqmYpFvLsJFuC5plyr366Gr3Md7VO4syFAldl7I
         G+8D4dlWbngiPtl/BbofIUBjEdyHrlugprleunHggFrN2YPozJNHR1UicR0iFrcLT+dX
         td3s9uIE8ixFplOEDbe5koNyIzNoEc18EqE8Z2uIu5Ef2/rc39EhV/vgXs6ybcUNR/kO
         dnF+orHr5vNhNVwsdEVXEPlhy47tQk6zqTA0Qnnx7fjYW9Ts6Yd3vzOx6X+Kr17r/But
         AyKbyHI3mFCKmOdipsFVwCfK9le8t0RDG2fZSbo+AdRM9dgs9Av76GMImnQLFQDP+Er8
         nRVA==
X-Gm-Message-State: AFqh2kqau8fvR8jiHGkx0Cqgqy+HMWW1eXrlAbNLkXwIucfX5G6KRUef
        Bz00bja45vxZhzH7BOC8Qks=
X-Google-Smtp-Source: AMrXdXtQT2sGh87mpSnW08pQBqrCK0kJ7P9Ha5vpqKB23KYRdBiqIJwSYwBz3mRsW1PGkuKIX5c9Fg==
X-Received: by 2002:a17:902:edc5:b0:189:9e91:762e with SMTP id q5-20020a170902edc500b001899e91762emr36270319plk.57.1674754435319;
        Thu, 26 Jan 2023 09:33:55 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:221c:184f:ef36:dca0? ([2620:15c:211:201:221c:184f:ef36:dca0])
        by smtp.gmail.com with ESMTPSA id iz4-20020a170902ef8400b001964c8164aasm293616plb.129.2023.01.26.09.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 09:33:54 -0800 (PST)
Message-ID: <7f0a2464-673a-f64a-4ebb-e599c3123a24@acm.org>
Date:   Thu, 26 Jan 2023 09:33:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230124190308.127318-2-niklas.cassel@wdc.com>
 <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org>
 <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com>
 <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
 <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com>
 <5066441f-e265-ed64-fa39-f77a931ab998@acm.org>
 <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com>
 <e8324901-7c18-153f-b47f-112a394832bd@acm.org> <Y9Gd0eI1t8V61yzO@x1-carbon>
 <86de1e78-0ff2-be70-f592-673bce76e5ac@opensource.wdc.com>
 <Y9KF5z/v0Qp5E4sI@x1-carbon>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y9KF5z/v0Qp5E4sI@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/26/23 05:53, Niklas Cassel wrote:
> On Thu, Jan 26, 2023 at 09:24:12AM +0900, Damien Le Moal wrote:
>> But again, the difficulty with this overloading is that we *cannot* implement a
>> solid level-based scheduling in IO schedulers because ordering the CDLs in a
>> meaningful way is impossible. So BFQ handling of the RT class would likely not
>> result in the most ideal scheduling (that would depend heavily on how the CDL
>> descriptors are defined on the drive). Hence my reluctance to overload the RT
>> class for CDL.
> 
> Well, if CDL were to reuse IOPRIO_CLASS_RT, then the user would either have to
> disable the IO scheduler, so that lower classdata levels wouldn't be prioritized
> over higher classdata levels, or simply use an IO scheduler that does not care
> about the classdata level, e.g. mq-deadline.

How about making the information about whether or not CDL has been 
enabled available to the scheduler such that the scheduler can include 
that information in its decisions?

> However, for CDL, things are not as simple as setting a single bit in the
> command, because of all the different descriptors, so we must let the classdata
> represent the device side priority level, and not the host side priority level
> (as we cannot have both, and I agree with you, it is very hard define an order
> between the descriptors.. e.g. should a 20 ms policy 0xf descriptor be ranked
> higher or lower than a 20 ms policy 0xd descriptor?).

How about only supporting a subset of the standard such that it becomes 
easy to map CDLs to host side priority levels?

If users really need the ability to use all standardized CDL features 
and if there is no easy way to map CDL levels to an I/O priority, is the 
I/O priority mechanism really the best basis for a user space interface 
for CDLs?

Thanks,

Bart.
