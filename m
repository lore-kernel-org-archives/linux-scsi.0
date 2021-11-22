Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78044C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 07:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238854AbhKVH7T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 02:59:19 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:46706 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbhKVH7T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 02:59:19 -0500
Received: by mail-wr1-f54.google.com with SMTP id u1so30941771wru.13;
        Sun, 21 Nov 2021 23:56:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=78Zaoc+ysQZW0svRK1nsW0QmI3S17DItZByKXc3/tr8=;
        b=sPa7iBfPsmJPBKuwtsPyLBOsBq8tXuCdm0pG6VaXJDDzszDHgVPo5N8z3lJ28yNPnj
         5jTgTU3BTKGrymZ2bYZuk8614k7l8+7Qw3fSaXP94fw4gazyZy7u/Np68piwYc1QonXf
         Am6K6GsG4OS7hVA4RZ59jwLjEws1L5L322cL0NkDPi8rxJ1yT5qGY3VqfKL5AyPR3a1l
         sBUlXGHl2IqfJHPcX5YpUDeJ9g9CMLfdLFXIDx7PCig2CfIUWd+8LQ+ezTmORGt87WES
         lPLDxF9h/n5SHTDhXKqJ3lzAe78zWh9QFSDqg064VdpDTWUTY/jSKoXONyVLGpRXOolm
         r6Uw==
X-Gm-Message-State: AOAM533JhYPy+O9cGXNid3lSlK19ubzOoUj+OFT30HEuzm8qwz29IoV0
        vSDhduWpowtZB1/JMrn53pw=
X-Google-Smtp-Source: ABdhPJy05or7AiPXEADL1NGpquFhxqkO2PYPdr/Gq1eAF15MB4FM5Abvecrg2lRFpC6RvQu5DZGgjA==
X-Received: by 2002:adf:eece:: with SMTP id a14mr36297769wrp.333.1637567772184;
        Sun, 21 Nov 2021 23:56:12 -0800 (PST)
Received: from [192.168.64.123] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id m17sm7931073wrz.22.2021.11.21.23.56.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Nov 2021 23:56:11 -0800 (PST)
Subject: Re: [PATCH 3/5] blk-mq: add helper of blk_mq_global_quiesce_wait()
To:     Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Keith Busch <kbusch@kernel.org>
References: <20211119021849.2259254-1-ming.lei@redhat.com>
 <20211119021849.2259254-4-ming.lei@redhat.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <8f6b6452-9abb-fd89-0262-9fb9d00d42a5@grimberg.me>
Date:   Mon, 22 Nov 2021 09:56:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211119021849.2259254-4-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Add helper of blk_mq_global_quiesce_wait() for supporting to quiesce
> queues in parallel, then we can just wait once if global quiesce wait
> is allowed.

blk_mq_global_quiesce_wait() is a poor name... global is scope-less and
obviously it has a scope.


> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   include/linux/blk-mq.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 5cc7fc1ea863..a9fecda2507e 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -777,6 +777,19 @@ static inline bool blk_mq_add_to_batch(struct request *req,
>   	return true;
>   }
>   
> +/*
> + * If the queue has allocated & used srcu to quiesce queue, quiesce wait is
> + * done via the synchronize_srcu(q->rcu), otherwise it is done via global
> + * synchronize_rcu().
> + *
> + * This helper can help us to support quiescing queue in parallel, so just
> + * one quiesce wait is enough if global quiesce wait is allowed.
> + */
> +static inline bool blk_mq_global_quiesce_wait(struct request_queue *q)
> +{
> +	return !q->alloc_srcu;
> +}
> +
>   void blk_mq_requeue_request(struct request *rq, bool kick_requeue_list);
>   void blk_mq_kick_requeue_list(struct request_queue *q);
>   void blk_mq_delay_kick_requeue_list(struct request_queue *q, unsigned long msecs);
> 
