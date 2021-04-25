Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B1DC433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 18:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B838611ED
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 18:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbhDYSk0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 14:40:26 -0400
Received: from mail-pl1-f178.google.com ([209.85.214.178]:44914 "EHLO
        mail-pl1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhDYSk0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 14:40:26 -0400
Received: by mail-pl1-f178.google.com with SMTP id y1so12092864plg.11;
        Sun, 25 Apr 2021 11:39:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5YG2hPeM/Yx8k+iQC4Kx30pgH4bvBziMfztPYklA/YY=;
        b=ZOZFUFriKZjG747j4ic4SdQCXqpKBWqmrfC9qS1ZPNv3NdQWsAP8tyxWDy8wWScupl
         137Rk2ld2Y9JAyBgFgJhQ6C8SOeWjtX8vFKJH9pnP+y1u73zXKZAKzMBNMogfcZ3pds3
         vf5ZracAvuEfXNKP+eCjK7liLVsqP0a4ku6q+NRf9sUEyPl/CIBVGJG+Jy5FLXI9FYTc
         OMTnIwRAoOanvbBii44BEpAT+AQgoZRIiJTM/6ZRoHK9ShxAAhBIOwbRG73CBDwLFRh4
         OgiWEP3cs2VmZtQxGMQBPo4WDq15MJ+gZkHESeTWaFq5MMjLlKdtyYzSRtVVz7HnbVn+
         w4qQ==
X-Gm-Message-State: AOAM532KPzoDsTCPPUMdpTZzK1xHvlwAUqRpYszLBTBZNY0836tRj9HQ
        z2qyI/7wsMxnA93iRWMDfyU=
X-Google-Smtp-Source: ABdhPJwN+teehJ1j2dpG2nmGQYgx83VbGPsxMT79+JYLw9zHjL66D4/ElzwmhTMnburTc0ZLaX5d8Q==
X-Received: by 2002:a17:902:ea05:b029:ed:3116:d65f with SMTP id s5-20020a170902ea05b02900ed3116d65fmr1002683plg.73.1619375985787;
        Sun, 25 Apr 2021 11:39:45 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g34sm9485942pgg.59.2021.04.25.11.39.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 11:39:45 -0700 (PDT)
Subject: Re: [PATCH 0/8] blk-mq: fix request UAF related with iterating over
 tagset requests
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Khazhy Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        David Jeffery <djeffery@redhat.com>
References: <20210425085753.2617424-1-ming.lei@redhat.com>
 <77cbc472-279e-5c9a-3428-b1a485b3f1b7@kernel.dk>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f4d43e0d-cdd7-4a8c-9852-bbc99053fd81@acm.org>
Date:   Sun, 25 Apr 2021 11:39:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <77cbc472-279e-5c9a-3428-b1a485b3f1b7@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/25/21 9:17 AM, Jens Axboe wrote:
> I'm going to pull the UAF series for now so we don't need to do a series
> of reverts if we deem this a better approach. I'll take a further look
> at it tomorrow.

Please give me the time to post review comments. My opinion about this
series is that (a) the analysis on which some patches are based is wrong
and also (b) that some patches introduce new bugs that are worse than
the current state of the for-next branch and also make it worse than the
v5.11 kernel.

Bart.


