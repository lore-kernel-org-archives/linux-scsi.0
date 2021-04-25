Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB7C9C433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 20:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A84261209
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 20:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhDYUyB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 16:54:01 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:46858 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbhDYUx6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 16:53:58 -0400
Received: by mail-pj1-f49.google.com with SMTP id u14-20020a17090a1f0eb029014e38011b09so4065617pja.5;
        Sun, 25 Apr 2021 13:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+fAv3IcCB/xNBG+VkrylC1h4GKQjcXLE+QYZ+nh7+VY=;
        b=NpJaxOaEfrGLd0YUt8ULv6P3foXF/9H36mCgs/MCFhVZ2sc1f15/rzbprdhb6xLXW+
         mB80Jka+W1hX3wEMklxgmLU21xXHuHFkqAstmptCeMLEzB0nvJqrfrE2hmrI9to9GcTI
         c0XAo6oZYaVrvQnXfvB/12TCnacZb/wpLg/6Nl4nlsSIgS5FE31jq47hSEj83OgxOw8q
         7hwuje00DcwRPJgEELQTUcBtCPaNGDtfWQgiPuuPTy3UYPqYQvTnkQTOY/JoXFOzEqrH
         49rvYJzHlaudUoU5WABze+J11XtxNn0B6lU7gCEkgQXAmTE74eOieHyvzD1SFLYQpCKc
         PBaw==
X-Gm-Message-State: AOAM5327uS/uF9RKFL6GOXjwjeFC6z7BM2xdIrHCNj7JbRsGs+DILHT9
        wznYnYV07HqKKUOBy4FgH6A=
X-Google-Smtp-Source: ABdhPJxg5YL5TENzJDyoYWHMvcZsQ2EnGLCYQTDLcAfYC8v65xlvKk/3SpSr4i60vTuZCMKuh3CP6A==
X-Received: by 2002:a17:90a:b112:: with SMTP id z18mr17565855pjq.18.1619383998074;
        Sun, 25 Apr 2021 13:53:18 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i9sm14400312pjh.9.2021.04.25.13.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 13:53:17 -0700 (PDT)
Subject: Re: [PATCH 0/8] blk-mq: fix request UAF related with iterating over
 tagset requests
To:     Ming Lei <ming.lei@redhat.com>, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <YIU2BhuYZAAgonN0@T590>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5c1ef3ec-dd6a-4992-586b-6e67bcd1a678@acm.org>
Date:   Sun, 25 Apr 2021 13:53:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YIU2BhuYZAAgonN0@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/25/21 2:27 AM, Ming Lei wrote:
> On Sun, Apr 25, 2021 at 04:57:45PM +0800, Ming Lei wrote:
>> Revert 4 patches from Bart which try to fix request UAF issue related
>> with iterating over tagset wide requests, because:

Where were you during the four weeks that my patch series was out for
review? I haven't seen any feedback from you on my patch series.

>> 1) request UAF caused by normal completion vs. async completion during
>> iterating can't be covered[1]

I do not agree with the above. Patches 5/8 and 6/8 from this series can
be applied without reverting any of my patches.

> 4) synchronize_rcu() is added before shutting down one request queue,
> which may slow down reboot/poweroff very much on big systems with lots of
> HBAs in which lots of LUNs are attached.

The synchronize_rcu() can be removed by using a semaphore
(<linux/semaphore.h>) instead of an RCU reader lock inside bt_tags_iter().

> 5) freeing request pool in updating nr_requests isn't covered.

This can be addressed easily on top of my patch series.

Bart.
