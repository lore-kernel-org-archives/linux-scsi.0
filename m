Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF7BC43460
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 16:29:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B1DA611CE
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 16:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbhDZQak (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 12:30:40 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:41978 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234333AbhDZQaj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Apr 2021 12:30:39 -0400
Received: by mail-pg1-f179.google.com with SMTP id f29so3278409pgm.8;
        Mon, 26 Apr 2021 09:29:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FRpv1P7l6v7ose3AJjfVKi2W+FlDkpRj5ZEW8pezQfY=;
        b=QW6l8QPc/aTRRJkMflqb7pNerHG64JWhRMqyVqYvcJrUVZgoiAnPwE6t7HWWSEIHos
         eUnQxjAnnrvuczuuhvE+Smqe5W1DofsONt/AHiziEQ7hYwIaEk4xLpmEX7bls65s6rCp
         ae3n8tGHLRTVIQuHAALzPkVqLJ1Vberj/qCq0xJIBxtr3uCmmBcX5iOHAhxpIb9oteR8
         w9mC0F4H9cCZCLRHWV3MRNNTrin8P8FPcu22bhFeauSRgiXcWtrQ0DGv5/sVjUYGQQkH
         5PxOAkraaB/Ce1wZ1/DHk0PCKhxwCgSdeCmz9gtgYQ+MZdo+Wpe5/txAO50vIbKeVlnB
         qLBQ==
X-Gm-Message-State: AOAM532N0BCPY9ij8svTBpwej6+xffVkyfukkHYCzocRSZbjwhesTrVe
        3UTCWxxNvzj3KI5t4Dg0aoAk0BaXDk6YLg==
X-Google-Smtp-Source: ABdhPJyev+n50Sl7ge7QGwoi0EZWXv7dGiSbPpSdLW+WKUXjUfXO1ivrv0MYfqlz35LzmmJ7OALDoQ==
X-Received: by 2002:a62:2cce:0:b029:21d:97da:833e with SMTP id s197-20020a622cce0000b029021d97da833emr18170081pfs.40.1619454597208;
        Mon, 26 Apr 2021 09:29:57 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id f10sm15871804pju.27.2021.04.26.09.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 09:29:56 -0700 (PDT)
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
Message-ID: <d1d3c068-4446-145b-34c6-12fa1f30d4da@acm.org>
Date:   Mon, 26 Apr 2021 09:29:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YISzLal7Ur7jyuiy@T590>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 5:09 PM, Ming Lei wrote:
> Terminating all pending commands can't avoid the issue wrt. request UAF,
> so far blk_mq_tagset_wait_completed_request() is used for making sure
> that all pending requests are really aborted.
> 
> However, blk_mq_wait_for_tag_iter() still may return before
> blk_mq_wait_for_tag_iter() is done because blk_mq_wait_for_tag_iter()
> supposes all request reference is just done inside bt_tags_iter(),
> especially .iter_rwsem and read rcu lock is added in bt_tags_iter().

Hi Ming,

I think that we agree that completing a request from inside a tag
iteration callback function may cause the request completion to happen
after tag iteration has finished. This can happen because
blk_mq_complete_request() may redirect completion processing to another
CPU via an IPI.

But can this mechanism trigger a use-after-free by itself? If request
completion is redirected to another CPU, the request is still considered
pending and request queue freezing won't complete. Request queue
freezing will only succeed after __blk_mq_free_request() has been called
because it is __blk_mq_free_request() that calls blk_queue_exit().

In other words, do we really need the new
blk_mq_complete_request_locally() function?

Did I perhaps miss something?

Thanks,

Bart.
