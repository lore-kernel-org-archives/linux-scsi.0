Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72622C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 01:32:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56C1B60FDA
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 01:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhIMBdK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 21:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236696AbhIMBdJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Sep 2021 21:33:09 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FED7C06175F
        for <linux-scsi@vger.kernel.org>; Sun, 12 Sep 2021 18:31:55 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id m11so10017003ioo.6
        for <linux-scsi@vger.kernel.org>; Sun, 12 Sep 2021 18:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+kyp/8+7o4cYohhCh7JybYvQipvAXNJ+txtYiR7pHBo=;
        b=sCG70fbmksVvNRK7g/FauezlzXfFxzghiGUp33z8JtPX4kKEAEh0fgRjFKToM80pRP
         Bfy3JupfiT+nWntm0dvoQ7BPrNmIFZiIewFQOIL/XBRTldv1SjGygAjKwKhWQEbaTpmw
         kHG0Z+vqSWndhfBRZOnSj1rtfd74Kif8jRCUwI7Pk3fC28wqEXm29J1TH+heEGHunQJG
         CAtkyr3jVNgxMCYrMKRyk5SOhvazUpKxJkhzNN/XgoXnDc+7AksPFoqlmGg6BHtgphNX
         w4tewQ80faljVmkxFjlqx2Bzq74sDw38I12H2KmMxRXguWmhgmElt83/g//DwHJwlk0f
         kmvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+kyp/8+7o4cYohhCh7JybYvQipvAXNJ+txtYiR7pHBo=;
        b=wnKMsuDPYXROVWjAVpmdYGB72UZh6rHR3RgKaxQMRiGy46jR/g88e554XkK2cQvFLk
         sXkdxQ1RtbumXj9x2WQtHoQolQ0qzTQLwHNieYzOBVyTWlcjeyJrV+j6onbEFhJWcGG+
         oRxG9JQjkdCFJ83U2dv5yyDaVYfAMwLZrzAMetABF8qiuqS0JoAeVHR7nDAIH8qVZrZM
         v0Sx9Uk6nMkgtifAsBOqNtwcXYNTt53GxoA+A8RALtUklTgSFu58VwPEoRpMgZeL+quM
         vVhkJV2e1eqOvUR04evhjc4P7LKFLC0zWWPIUr+6emXqUjCpnwwEQkIpBLyY7ea3G7Ec
         UqDA==
X-Gm-Message-State: AOAM531mGXPgVXRPgINARchOQZFcFBpQNCB6q56ZGoLTog6+mqZlkQGz
        d73Phhw4u0SKW0NM0eIXmQTIhA==
X-Google-Smtp-Source: ABdhPJxDePcclxUCP9q85rRO9Sr/7jL4B6ykhXiVvjNRch9X9FGhgaPz27H5hxnRzgksTMhlZl7N2w==
X-Received: by 2002:a05:6638:4195:: with SMTP id az21mr7516413jab.40.1631496714435;
        Sun, 12 Sep 2021 18:31:54 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id x16sm1393590ile.63.2021.09.12.18.31.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 18:31:54 -0700 (PDT)
Subject: Re: [PATCH] blk-mq: avoid to iterate over stale request
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        luojiaxing <luojiaxing@huawei.com>
References: <20210906065003.439019-1-ming.lei@redhat.com>
 <YT6o3Lt8II2ZIOlf@T590>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <63550f2f-a6d2-f74f-d637-9b4d1d8a0fc8@kernel.dk>
Date:   Sun, 12 Sep 2021 19:31:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YT6o3Lt8II2ZIOlf@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/21 7:26 PM, Ming Lei wrote:
> On Mon, Sep 06, 2021 at 02:50:03PM +0800, Ming Lei wrote:
>> blk-mq can't run allocating driver tag and updating ->rqs[tag]
>> atomically, meantime blk-mq doesn't clear ->rqs[tag] after the driver
>> tag is released.
>>
>> So there is chance to iterating over one stale request just after the
>> tag is allocated and before updating ->rqs[tag].
>>
>> scsi_host_busy_iter() calls scsi_host_check_in_flight() to count scsi
>> in-flight requests after scsi host is blocked, so no new scsi command can
>> be marked as SCMD_STATE_INFLIGHT. However, driver tag allocation still can
>> be run by blk-mq core. One request is marked as SCMD_STATE_INFLIGHT,
>> but this request may have been kept in another slot of ->rqs[], meantime
>> the slot can be allocated out but ->rqs[] isn't updated yet. Then this
>> in-flight request is counted twice as SCMD_STATE_INFLIGHT. This way causes
>> trouble in handling scsi error.
>>
>> Fixes the issue by not iterating over stale request.
>>
>> Cc: linux-scsi@vger.kernel.org
>> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
>> Reported-by: luojiaxing <luojiaxing@huawei.com>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> Hello Jens,
> 
> luojiaxiang has verified that this patch fixes his issue, any chance to
> merge it?

I'll queue it up for 5.15-rc2, thanks.

-- 
Jens Axboe

