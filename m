Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F12BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 04:06:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbiBWEHC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Feb 2022 23:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237252AbiBWEHB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2022 23:07:01 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC6C5FC3;
        Tue, 22 Feb 2022 20:06:33 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id cp23-20020a17090afb9700b001bbfe0fbe94so1557494pjb.3;
        Tue, 22 Feb 2022 20:06:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H4afSgsATLCukURmuVFydXNZD6XruxTDrJfp/9i5FJg=;
        b=PYZOQV3qk67++l/Y4JC8W/fDBWSbKIsl9/SqMe/MzjD0i3wc/i25KVH8qYwaz4OSqs
         vAXmsYM+xn8xvC2Ig2HwoM/u09L8vidEE5lPF2aRxcMTOLLyVEegu+DjhrJS0wjHbXXr
         BAUqy8ygBKFrfwkTjraEz27zjEh00DZr17z0/Xpe1EzN3CwZjbBArpIumIbeAgzMiwT+
         FcWSiQGob66MwexO1faO8ljDBNmhzxt6k8Olpqh06BDWdSd3NcvqYR5z/yB7EFH2tzx/
         KmNJVY9rnCkc3a7RBgUXQXI3+v81fhZR8NcBE7UNysDHzMW5Mh611mo/LPS5Wm/0J9kE
         kk+Q==
X-Gm-Message-State: AOAM533/zIYoOPEN4nKMqm6WnDR5jCCPt3hfSuh3Jshl0/fban6FcoGF
        tr2E80ASS9c1RxLr7RCeoao=
X-Google-Smtp-Source: ABdhPJyAgeC9Uot/dIHMgi42sP9IUt3I6HBgkRF6vRXisSvZX1LQXrCI/qrGc+u2fRyal5filRedhw==
X-Received: by 2002:a17:902:da88:b0:14b:550b:4caa with SMTP id j8-20020a170902da8800b0014b550b4caamr25367662plx.111.1645589193035;
        Tue, 22 Feb 2022 20:06:33 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id z7sm1120324pjr.3.2022.02.22.20.06.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 20:06:32 -0800 (PST)
Message-ID: <6105afff-b4e1-1a38-2112-b21396829dd0@acm.org>
Date:   Tue, 22 Feb 2022 20:06:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 08/12] block: don't remove hctx debugfs dir from
 blk_mq_exit_queue
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <20220222141450.591193-1-hch@lst.de>
 <20220222141450.591193-9-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220222141450.591193-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 06:14, Christoph Hellwig wrote:
> From: Ming Lei <ming.lei@redhat.com>
> 
> The queue's top debugfs dir is removed from blk_release_queue(), so all
> hctx's debugfs dirs are removed from there. Given blk_mq_exit_queue()
> is only called from blk_cleanup_queue(), it isn't necessary to remove
> hctx debugfs from blk_mq_exit_queue().
> 
> So remove it from blk_mq_exit_queue().
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   block/blk-mq.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 63e2d3fd60946..540c8da30da72 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3425,7 +3425,6 @@ static void blk_mq_exit_hw_queues(struct request_queue *q,
>   	queue_for_each_hw_ctx(q, hctx, i) {
>   		if (i == nr_queue)
>   			break;
> -		blk_mq_debugfs_unregister_hctx(hctx);
>   		blk_mq_exit_hctx(q, set, hctx, i);
>   	}
>   }

What will happen if a new queue with the same name as a removed queue is 
created before blk_release_queue() for the removed queue has finished? 
Will that cause registration of debugfs attributes for the newly created 
queue to fail?

Thanks,

Bart.
