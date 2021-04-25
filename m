Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 565A7C433ED
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 21:01:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24A4361260
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 21:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhDYVBy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 17:01:54 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:41545 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhDYVBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 17:01:53 -0400
Received: by mail-pf1-f175.google.com with SMTP id w6so23082952pfc.8;
        Sun, 25 Apr 2021 14:01:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YIVdBwNyYUYTkQn4HptAspu70HypxovaJAxGVFKezc4=;
        b=dTxMI6CwYKChg4kEc09oIpXKLeDACxvS7mNofbYPeHbp79DUFwqM//q3Z9tLDYFYal
         nO63oXAnSW9o3YoPtykLHr82AXaUsTeYwjnaCjGbGNy4IfNsQxwNOtvmK8uJoDGFjjFa
         JPwjFR+ectc1V0cv0jMSUokzwCIBM1NJCxgFmBOJWelHMJea0P0/rQFaM/fH62ozxJEF
         9uhHbMLYrLTdPJSDfOEHEvMiZBRq3b2hpwphJROlqcxYNlOPHfqISY5xl62VNtbC2O4f
         EAZA7/7PC7wfIwsIitWomtNOtv883VCXIsksETvKa6la64LY/bsjbR2hQv+H0uJsspDo
         ByFw==
X-Gm-Message-State: AOAM532MM4CWlbcZzRxiYzHWHHhw2S3Ntcyrv8ih+nAy0Tnxk2CT43SS
        h1qILcw4m7V8wXbBdB6lnLFx8skGMU0WWQ==
X-Google-Smtp-Source: ABdhPJzO8vln7atkRbLhYuBEfJJsgskE9Agpu3kRhygK9gDEVjvtkpH/0pBjjdM5TSXKgFbmQcNfUw==
X-Received: by 2002:a62:6101:0:b029:215:3a48:4e6e with SMTP id v1-20020a6261010000b02902153a484e6emr14617947pfb.2.1619384473131;
        Sun, 25 Apr 2021 14:01:13 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id s18sm8780933pgv.44.2021.04.25.14.01.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 14:01:12 -0700 (PDT)
Subject: Re: [PATCH v7 3/5] blk-mq: Fix races between iterating over requests
 and freeing requests
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <dwagner@suse.de>,
        Khazhismel Kumykov <khazhy@google.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210421000235.2028-1-bvanassche@acm.org>
 <20210421000235.2028-4-bvanassche@acm.org> <YIDqa6YkNoD5OiKN@T590>
 <b717ffc0-a434-738f-9c63-32901bd164b2@acm.org> <YIEiElb9wxReV/oL@T590>
 <32a121b7-2444-ac19-420d-4961f2a18129@acm.org> <YIJEg9DLWoOJ06Kc@T590>
 <28607d75-042f-7a6a-f5d0-2ee03754917e@acm.org> <YISzLal7Ur7jyuiy@T590>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <037f5a58-545c-5265-c2a2-d2e8b92168c6@acm.org>
Date:   Sun, 25 Apr 2021 14:01:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <YISzLal7Ur7jyuiy@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 5:09 PM, Ming Lei wrote:
> However, blk_mq_wait_for_tag_iter() still may return before
> blk_mq_wait_for_tag_iter() is done because blk_mq_wait_for_tag_iter()
> supposes all request reference is just done inside bt_tags_iter(),
> especially .iter_rwsem and read rcu lock is added in bt_tags_iter().

The comment above blk_mq_wait_for_tag_iter() needs to be updated but I
believe that the code is fine. Waiting for bt_tags_iter() to finish
should be sufficient to fix the UAF. What matters is that the pointer
read by rcu_dereference(tags->rqs[bitnr]) remains valid until the
callback function has finished. I think that is guaranteed by the
current implementation.

Bart.
