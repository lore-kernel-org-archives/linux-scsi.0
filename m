Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3A3C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 07:53:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbhKVH5C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 02:57:02 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:36642 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbhKVH5C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 02:57:02 -0500
Received: by mail-wr1-f53.google.com with SMTP id s13so31010183wrb.3;
        Sun, 21 Nov 2021 23:53:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q0B83Z/pMJS/3Kw2AnU6hlZi7ua50hKFS6zMaB5ImF8=;
        b=Hnf9SkuiybIcdBNGMDMRqseFyeqE30+NzLFbGOyOYBShXqN8jXd4S4ak7ZuFyvjUU3
         OYK4Ltyb9jL7lX9izECYPt64A+FJZlbDjejCS7evYkV1IkjhXXTefB8pDL6btUM4fpEL
         3Z2rhHtyCUoA9wvN69yHz36HHgW0FcWFgL6qoMAHYQmJEM405rr7NrLDGCJ6CJsdwA9S
         oT3sED7BtVVneTYG6ZBt5FIis+dMZJFvul/e0jWG6XwYcke42KtJJEtsvQpGRXvzKVTm
         t9+3+O1LJRlairu5s5d5oeP8EUVkA8g/yrfsdZYxKo/QCUkh8F4cuYeyS9tIsXlGkz9w
         qL3A==
X-Gm-Message-State: AOAM533q+KNmOe4IEzOTn7waAa179/CoSr2Dvk2W0D4/p8LKXwYaDJGz
        UIYHZEVSjyvetaG+iwHktGE=
X-Google-Smtp-Source: ABdhPJyfYMEviMX1WCFI8FxFujbqZf1VpqWmBEpT7IINxm5fp+vIrw3VQnXe1IteGJjr8dDNyHfOow==
X-Received: by 2002:a5d:58fb:: with SMTP id f27mr36635909wrd.10.1637567635391;
        Sun, 21 Nov 2021 23:53:55 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id p13sm20816547wmi.0.2021.11.21.23.53.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Nov 2021 23:53:55 -0800 (PST)
Subject: Re: [PATCH 2/5] blk-mq: rename hctx_lock & hctx_unlock
To:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-3-ming.lei@redhat.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <ed13ee7f-a017-874a-cd28-e40b3aa6b4a7@grimberg.me>
Date:   Mon, 22 Nov 2021 09:53:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211119021849.2259254-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> -static inline void hctx_unlock(struct blk_mq_hw_ctx *hctx, int srcu_idx)
> -	__releases(hctx->srcu)
> +static inline void queue_unlock(struct request_queue *q, bool blocking,
> +		int srcu_idx)
> +	__releases(q->srcu)
>   {
> -	if (!(hctx->flags & BLK_MQ_F_BLOCKING))
> +	if (!blocking)
>   		rcu_read_unlock();
>   	else
> -		srcu_read_unlock(hctx->queue->srcu, srcu_idx);
> +		srcu_read_unlock(q->srcu, srcu_idx);

Maybe instead of passing blocking bool just look at srcu_idx?

	if (srcu_idx < 0)
		rcu_read_unlock();
	else
		srcu_read_unlock(q->srcu, srcu_idx);

Or look if the queue has srcu allocated?

	if (!q->srcu)
		rcu_read_unlock();
	else
		srcu_read_unlock(q->srcu, srcu_idx);

>   }
>   
> -static inline void hctx_lock(struct blk_mq_hw_ctx *hctx, int *srcu_idx)
> +static inline void queue_lock(struct request_queue *q, bool blocking,
> +		int *srcu_idx)
>   	__acquires(hctx->srcu)
>   {
> -	if (!(hctx->flags & BLK_MQ_F_BLOCKING)) {
> +	if (!blocking) {
>   		/* shut up gcc false positive */
>   		*srcu_idx = 0;
>   		rcu_read_lock();
>   	} else
> -		*srcu_idx = srcu_read_lock(hctx->queue->srcu);
> +		*srcu_idx = srcu_read_lock(q->srcu);

Same here:
	
	if (!q->srcu)
		rcu_read_lock();
	else
		srcu_idx = srcu_read_lock(q->srcu);
