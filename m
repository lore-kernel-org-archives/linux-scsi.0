Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214EEC433B4
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 18:55:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E13F060FE6
	for <linux-scsi@archiver.kernel.org>; Sun, 25 Apr 2021 18:55:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhDYS4F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 14:56:05 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:35366 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbhDYS4F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 14:56:05 -0400
Received: by mail-pj1-f41.google.com with SMTP id h14-20020a17090aea8eb02901553e1cc649so1769290pjz.0;
        Sun, 25 Apr 2021 11:55:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PrEQc4IIoTHTsXOxriMgvj46cgYHAhsoAI5ytNJc5R4=;
        b=QueV+gjWsFrpYi0crg0+sx/tOBgZRKkHuMcS4TW40d9MHSIW2hOl4KmI4dbbaMxcje
         DWIJGmr0w60Yfk3EXZkf6ycNPxJkGuhaYQTJv/sdCHWVEr7puu7tfXjtHF00ssTGT/UN
         KGoMpYnktSaBgo0noKWPp7rAKbDLcowC0QJXjTsghFTeiBKQKjsiTdxD+q4vTW5xcIuQ
         F1t8ubN3KmZ+0ExT4RjVoJmdptFIjCiA80FRc5VL5LykLPP6/PO2Y25zxJ5Z1C9076Jg
         wsPF0qe6ts8LqokvfGTU1q3OFYgi3F3RAOEuOkrKKPpigVisaw5q3hrXrnuxN6EEt3aU
         khcg==
X-Gm-Message-State: AOAM530vjiJQ5aptjNCm+XOpdSm4p9m80Vlgg/Pnm39OCLG9k+32a74D
        q3TtOFISlDRkrXBADrzKBTU=
X-Google-Smtp-Source: ABdhPJx8/WSToc67TMnXO8iikYMeuXON9nfP7Eb1TbQajzj1IzVb8lj6kC2XcAWVjo+i6QdE2bsuCA==
X-Received: by 2002:a17:90a:77c8:: with SMTP id e8mr18468910pjs.69.1619376924853;
        Sun, 25 Apr 2021 11:55:24 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id c26sm9272436pfo.67.2021.04.25.11.55.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 11:55:24 -0700 (PDT)
Subject: Re: [PATCH 7/8] blk-mq: grab rq->refcount before calling ->fn in
 blk_mq_tagset_busy_iter
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
 <20210425085753.2617424-8-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6c0b0af9-ca71-d143-b1cc-384adfca5438@acm.org>
Date:   Sun, 25 Apr 2021 11:55:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210425085753.2617424-8-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/25/21 1:57 AM, Ming Lei wrote:
> However, still one request UAF not covered: refcount_inc_not_zero() may
> read one freed request, and it will be handled in next patch.

This means that patch "blk-mq: clear stale request in tags->rq[] before
freeing one request pool" should come before this patch.

> @@ -276,12 +277,15 @@ static bool bt_tags_iter(struct sbitmap *bitmap, unsigned int bitnr, void *data)
>  		rq = tags->static_rqs[bitnr];
>  	else
>  		rq = tags->rqs[bitnr];
> -	if (!rq)
> +	if (!rq || !refcount_inc_not_zero(&rq->ref))
>  		return true;
>  	if ((iter_data->flags & BT_TAG_ITER_STARTED) &&
>  	    !blk_mq_request_started(rq))
> -		return true;
> -	return iter_data->fn(rq, iter_data->data, reserved);
> +		ret = true;
> +	else
> +		ret = iter_data->fn(rq, iter_data->data, reserved);
> +	blk_mq_put_rq_ref(rq);
> +	return ret;
>  }

Even if patches 7/8 and 8/8 would be reordered, the above code
introduces a new use-after-free, a use-after-free that is much worse
than the UAF in kernel v5.11. The following sequence can be triggered by
the above code:
* bt_tags_iter() reads tags->rqs[bitnr] and stores the request pointer
in the 'rq' variable.
* Request 'rq' completes, tags->rqs[bitnr] is cleared and the memory
that backs that request is freed.
* The memory that backs 'rq' is used for another purpose and the request
reference count becomes nonzero.
* bt_tags_iter() increments the request reference count and thereby
corrupts memory.

Bart.
