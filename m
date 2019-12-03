Return-Path: <SRS0=KpyL=ZZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5749C432C0
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 16:38:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0A3F205ED
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Dec 2019 16:38:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfLCQi3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Dec 2019 11:38:29 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35168 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfLCQi3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Dec 2019 11:38:29 -0500
Received: by mail-pl1-f193.google.com with SMTP id s10so1911381plp.2;
        Tue, 03 Dec 2019 08:38:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dfUDHMi/qzcRJxN2pVGjTr0VCbodDkUsVuFikJ7JL5g=;
        b=KW/Y+Q5XZ2cCFEz6HW7PaLAf9PInUU5t5zlC5Jv3t11wiuV7obg9G3lcg3yjmC3rmJ
         WXSmkPwTbLg8E6lIj6nI4ixwusdygoGj6RDd8IfSQYMxocCq187wCl0n/duttVVxIcDo
         ZIMzrP2QXQbRqFnGFj9IwhnCcws6mCP0sGzeFHUUOcE9vAJkfHFrF0ZaGiRSexdNpWT9
         wtRUUir4/eNEL/0Sj7klFeOSZBajD+02VO3JViaC/iVhgao6pc+d/iQ3CI1uQb8E/Shh
         zYJhD/zb9Itm1EO03g2ETuGcMyGSVDyqsDMfIJ2a541G7Wy1HXXjE70rxz5SY72qBYLU
         tBLA==
X-Gm-Message-State: APjAAAVl1IsEGwVN82s3eKp2UNkJ4llpUhEDi068W1MokXVL8mmEK3nA
        UrgEW9VCWkAEJJAZsZ3/NXEISgxAcio=
X-Google-Smtp-Source: APXvYqwJz7YcrlRQfxzYMGcu8vLaD+YDSy0kZQpKSNYwEw2l1ZvaRRR728EGYd/Sg7Hd6kqvVq4fPw==
X-Received: by 2002:a17:90a:650:: with SMTP id q16mr6527915pje.53.1575391107618;
        Tue, 03 Dec 2019 08:38:27 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id d6sm4054505pfn.32.2019.12.03.08.38.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2019 08:38:26 -0800 (PST)
Subject: Re: [PATCH 04/11] blk-mq: Facilitate a shared sbitmap per tagset
To:     John Garry <john.garry@huawei.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20191202153914.84722-1-hare@suse.de>
 <20191202153914.84722-5-hare@suse.de>
 <ab7555b2-2e95-6fb1-2e44-fe3a323a24e4@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <764e2882-b348-aacf-c630-64ffd59f185a@acm.org>
Date:   Tue, 3 Dec 2019 08:38:24 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <ab7555b2-2e95-6fb1-2e44-fe3a323a24e4@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/3/19 6:54 AM, John Garry wrote:
>> @@ -483,8 +483,8 @@ static int hctx_tags_bitmap_show(void *data, 
>> struct seq_file *m)
>>       res = mutex_lock_interruptible(&q->sysfs_lock);
>>       if (res)
>>           goto out;
>> -    if (hctx->tags)
>> -        sbitmap_bitmap_show(&hctx->tags->bitmap_tags.sb, m);
>> +    if (hctx->tags) /* We should just iterate the relevant bits for 
>> this hctx FIXME */
> 
> Bart's solution to this problem seemed ok, if he doesn't mind us 
> borrowing his idea:
> 
> https://lore.kernel.org/linux-block/5183ab13-0c81-95f0-95ba-40318569c6c6@huawei.com/T/#m24394fe70b1ea79a154dfd9620f5e553c3e7e7da 
>  
> See hctx_tags_bitmap_show().

Hi John,

Sure, borrowing that code is fine with me.

Bart.
