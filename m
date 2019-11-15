Return-Path: <SRS0=2nLx=ZH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F57DC432C3
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 17:58:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4011120674
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Nov 2019 17:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfKOR56 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Nov 2019 12:57:58 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:36652 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbfKOR56 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Nov 2019 12:57:58 -0500
Received: by mail-pf1-f193.google.com with SMTP id b19so7055395pfd.3;
        Fri, 15 Nov 2019 09:57:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B6Y8nCk4GqPfyHCxLLDXlASZUcgn3emZcmfGWLSrGmM=;
        b=lCWP02IMv7HOTaZ25mLJ6UKuo0kFN3s/iRz3x9LEUcHcUbRuLHfLCJjtuhxws3lYba
         IUU/SlZ4eS6d/zaTwcrFJB30snDwJ/MwJgRoQ/rQHlwuat7phe1yGqive2NXlKIf0G/0
         h7pBkeVy+IN9y72l86oer4IOpl1YNQVCaA7miKlReThDCo6GRbSSCR1llKW6qsbPuwlr
         lfJGmnSNIIOrVzu3O2AmATcX3LW5+DNGAl9Yfyj/hMbE2EXvkhCpgUJ7qHkE5t8lZagf
         WYsFOhOv+gA7rWJjZx5po4UAieIV5Ir/d9x24n2VQUkzBxkBtOzt7ualZ5djr/hS/FkJ
         6j/w==
X-Gm-Message-State: APjAAAWhln/8yi64l2LyLZthRCwjeGqdeTFxIzdYjjFD3yDZ5jx5zO0e
        w8sdgE8Zkyu2FAkkEsr9SmMU8ZnC
X-Google-Smtp-Source: APXvYqytNmXO//DAI9VlyznRtxH/qpKCqnI+WYF+1HAsgH/w1iuw6khbMWSOv2pmzaNj2CFS719FeQ==
X-Received: by 2002:aa7:9d09:: with SMTP id k9mr18692804pfp.154.1573840677719;
        Fri, 15 Nov 2019 09:57:57 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id b9sm12051008pfp.77.2019.11.15.09.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 09:57:56 -0800 (PST)
Subject: Re: [PATCH RFC 3/5] blk-mq: Facilitate a shared tags per tagset
To:     John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "hare@suse.com" <hare@suse.com>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
 <1573652209-163505-4-git-send-email-john.garry@huawei.com>
 <32880159-86e8-5c48-1532-181fdea0df96@suse.de>
 <2cbf591c-8284-8499-7804-e7078cf274d2@huawei.com>
 <02056612-a958-7b05-3c54-bb2fa69bc493@suse.de>
 <ace95bc5-7b89-9ed3-be89-8139f977984b@huawei.com>
 <42b0bcd9-f147-76eb-dfce-270f77bca818@suse.de>
 <89cd1985-39c7-2965-d25b-2ee2c183d057@huawei.com>
 <c34c0ce2-40a8-e4fc-3366-1f7b906da5a3@acm.org>
 <8e7bd2cb-1035-13ba-05db-d8e12c61df1f@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6b85f172-695c-4757-3794-455b8d55e015@acm.org>
Date:   Fri, 15 Nov 2019 09:57:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <8e7bd2cb-1035-13ba-05db-d8e12c61df1f@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/19 2:24 AM, John Garry wrote:
> Bart Van Assche wrote:
> > How about sharing tag sets across hardware
> > queues, e.g. like in the (totally untested) patch below?
> 
> So this is similar in principle what Ming Lei came up with here:
> https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@redhat.com/ 
> 
> However your implementation looks neater, which is good.
> 
> My concern with this approach is that we can't differentiate which tags 
> are allocated for which hctx, and sometimes we need to know that.
> 
> An example here was blk_mq_queue_tag_busy_iter(), which iterates the 
> bits for each hctx. This would just be broken by that change, unless we 
> record which bits are associated with each hctx.

I disagree. In bt_iter() I added " && rq->mq_hctx == hctx" such that 
blk_mq_queue_tag_busy_iter() only calls the callback function for 
matching (hctx, rq) pairs.

> Another example was __blk_mq_tag_idle(), which looks problematic.

Please elaborate.

> For debugfs, when we examine 
> /sys/kernel/debug/block/.../hctxX/tags_bitmap, wouldn't that be the tags 
> for all hctx (hctx0)?
> 
> For debugging reasons, I would say we want to know which tags are 
> allocated for a specific hctx, as this is tightly related to the 
> requests for that hctx.

That is an open issue in the patch I posted and something that needs to 
be addressed. One way to address this is to change the 
sbitmap_bitmap_show() calls into calls to a function that only shows 
those bits for which rq->mq_hctx == hctx.

>> @@ -341,8 +341,11 @@ void blk_mq_tagset_busy_iter(struct 
>> blk_mq_tag_set *tagset,
>>       int i;
>>
>>       for (i = 0; i < tagset->nr_hw_queues; i++) {
>> -        if (tagset->tags && tagset->tags[i])
>> +        if (tagset->tags && tagset->tags[i]) {
>>               blk_mq_all_tag_busy_iter(tagset->tags[i], fn, priv);
> 
> As I mentioned earlier, wouldn't this iterate over all tags for all 
> hctx's, when we just want the tags for hctx[i]?
> 
> Thanks,
> John
> 
> [Not trimming reply for future reference]
> 
>> +            if (tagset->share_tags)
>> +                break;
>> +        }
>>       }
>>   }
>>   EXPORT_SYMBOL(blk_mq_tagset_busy_iter);

Since blk_mq_tagset_busy_iter() loops over all hardware queues all what 
is changed is the order in which requests are examined. I am not aware 
of any block driver that calls blk_mq_tagset_busy_iter() and that 
depends on the order of the requests passed to the callback function.

Thanks,

Bart.
