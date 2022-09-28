Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A3B5C04A95
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 14:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbiI1OWZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 10:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234348AbiI1OWX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 10:22:23 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E90DA9C0A
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 07:22:22 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id l65so12652557pfl.8
        for <linux-scsi@vger.kernel.org>; Wed, 28 Sep 2022 07:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=IcCOVXLXxHvpPopGpnPv2T7v0pTrQ2ZxamJTkqROX/w=;
        b=OVthF5MHuPVJkukGFSTKTOGeIm/VAPIlqbGb4ZI3VhVbiXd7CCeipL3Z2NIOuzENzf
         3Ef8ix6aDPiparDKFbNeUNTcpieYLTvPQpeE3QH3omb33G4XaYOemLITYqSzwt2FDay1
         VtMQE+nBTFJO39jXgTr9dK4HiuT311Ln+8nPYNGeGv2qGLVokMKtfBThJTAwAdHvGLIp
         XO8ug3d320Dte0I7VJiQiyZLR0OVfS0bA6mfWe6aP7iuPR7U5ZnQITGO6zCkYgah59u4
         GZ2BVY7GZ5v022yqAbE+kvMqUC0THUSWJtRqY0vXjiY+Xjm6gYbxa8NbOt06guIMNVYZ
         Puxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=IcCOVXLXxHvpPopGpnPv2T7v0pTrQ2ZxamJTkqROX/w=;
        b=7n1vuvBuEBHsbRhiKtKlSrOTsi7xp5Tin9MfQAYNGfuKFwyre3lkBArucUODJht151
         4Jzue1Hy5noy8I92mUDgq+XlEwov0Nq+a0hVU5812iLLZPGDAQCvDEw7RiReSuZImQeZ
         CCqmOTzUFDvNBpTomwQx9qmU5xazb37FFjPaZU925IibLlfzzPwD+iz8qjvMoaqyWHuz
         lyraKikZvrhtdnK/tPzEI5qQp1L/+vo3YXHeYOzBkq4TdeV8X2ytnCWmaaajpqPovqIJ
         xwU33TM4CN8GyuQEwjWW6wJg/OKT5R/ayPxX5A+cYLc0aWcYpdMXCNhP+VsuPT5mluFo
         m9BQ==
X-Gm-Message-State: ACrzQf2pfzMTLV9FnDgV+jyxoSyB5i1D19rCNzw4o83aLmjxFxHFH7Zw
        jxnEaB4E6KJRRXapmG+gvoTEElflXcFTqA==
X-Google-Smtp-Source: AMsMyM7WUWGY9QTF0hxnqJ85z036FKxylq0a0QVbQjy5vAHIr/PaRgrZPyG6ppoteztUtzf1jxTEsw==
X-Received: by 2002:a65:42cc:0:b0:431:af8c:77e1 with SMTP id l12-20020a6542cc000000b00431af8c77e1mr29052177pgp.308.1664374941478;
        Wed, 28 Sep 2022 07:22:21 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9-20020a621d09000000b005484d133127sm4028417pfd.129.2022.09.28.07.22.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 07:22:21 -0700 (PDT)
Message-ID: <45fef5c6-8945-a140-a3ce-34bb4b287dc4@kernel.dk>
Date:   Wed, 28 Sep 2022 08:22:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCHSET v2 0/5] Enable alloc caching and batched freeing for
 passthrough
Content-Language: en-US
To:     Anuj gupta <anuj1072538@gmail.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
References: <20220927014420.71141-1-axboe@kernel.dk>
 <CACzX3AumYMDVPwvRYpMi6vvcPTzR0W0bUT1-545HvArpH+7Uwg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACzX3AumYMDVPwvRYpMi6vvcPTzR0W0bUT1-545HvArpH+7Uwg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 7:23 AM, Anuj gupta wrote:
> On Tue, Sep 27, 2022 at 7:14 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Hi,
>>
>> The passthrough IO path currently doesn't do any request allocation
>> batching like we do for normal IO. Wire this up through the usual
>> blk_mq_alloc_request() allocation helper.
>>
>> Similarly, we don't currently supported batched completions for
>> passthrough IO. Allow the request->end_io() handler to return back
>> whether or not it retains ownership of the request. By default all
>> handlers are converted to returning RQ_END_IO_NONE, which retains
>> the existing behavior. But with that in place, we can tweak the
>> nvme uring_cmd end_io handler to pass back ownership, and hence enable
>> completion batching for passthrough requests as well.
>>
>> This is good for a 10% improvement for passthrough performance. For
>> a non-drive limited test case, passthrough IO is now more efficient
>> than the regular bdev O_DIRECT path.
>>
>> Changes since v1:
>> - Remove spurious semicolon
>> - Cleanup struct nvme_uring_cmd_pdu handling
>>
>> --
>> Jens Axboe
>>
>>
> I see an improvement of ~12% (2.34 to 2.63 MIOPS) with polling enabled and
> an improvement of ~4% (1.84 to 1.92 MIOPS) with polling disabled using the
> t/io_uring utility (in fio) in my setup with this patch series!

Thanks for your testing! I'll add your reviewed-by to the series.

-- 
Jens Axboe


