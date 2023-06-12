Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13FB6C88CB6
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 15:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbjFLPkw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 11:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239951AbjFLPkQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 11:40:16 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3E210CB;
        Mon, 12 Jun 2023 08:40:10 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-650c89c7e4fso4794698b3a.0;
        Mon, 12 Jun 2023 08:40:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686584410; x=1689176410;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VsnGA8Sn5qSVmWHY2CC/rIiXe0BUsfmX764WRUzBsNo=;
        b=c2AaPKfwTtpi3YFcvPTLAgi/s3fSOAPT6ob35bNNlL1HzSw91ihcCG27ePy9hF6eEX
         SP345/SY+emuFJh+ZgjcLBlzM8F/+rKBd6SPngvzyUrV66WgcPS7oYK4YEPtE2jp8RAz
         Mv28/yyN/5N+8SVvlQj5ysftORdI9mtYxopsW06D2ehkDzaumSOD0U/HhiV3CACFg3ND
         kg56JiQPhE2fJZ9jk6bLJlIpWapesCigsYI8R4nnwDu+sp5bDYlM4r55eX0KRT8kkYV8
         2jPVh163cKmncGKDm+0DN5ZHiJMKLdTjcgPhMn9xp8YujUoGTQeKJ3IA0sspKyxfH6aO
         UGXw==
X-Gm-Message-State: AC+VfDyRbwpZU9yJn5eIq4vXNh5u7r0Z/DaOE5FAIQGX3koI9wuWDeza
        Aq2RQ83p1N1LX/MQffNHm7c=
X-Google-Smtp-Source: ACHHUZ5zsHEAFuXGkIlKJvJe8Gp7QUKU9gLcR3mJyE5csKXgpdUhNcpBU9GhMcDLPHMBnQ4IqM59Lw==
X-Received: by 2002:a05:6a20:1606:b0:10f:708b:bb28 with SMTP id l6-20020a056a20160600b0010f708bbb28mr11768044pzj.7.1686584409955;
        Mon, 12 Jun 2023 08:40:09 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id g3-20020a17090a3c8300b0024e33c69ee5sm7547334pjc.5.2023.06.12.08.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 08:40:09 -0700 (PDT)
Message-ID: <c0908f1d-58e9-6ecb-7f4c-c0bf4659a17f@acm.org>
Date:   Mon, 12 Jun 2023 08:40:07 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v4 4/6] scsi: don't wait for quiesce in scsi_stop_queue()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230612150309.18103-1-mwilck@suse.com>
 <20230612150309.18103-5-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230612150309.18103-5-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 08:03, mwilck@suse.com wrote:
> -	 * However, we still need to wait until quiesce is done
> -	 * in case that queue has been stopped.
> +	 * After return, we still need to wait until quiesce is done.

The above comment would be more clear if "After return, we still need" 
would be changed into "The caller needs".

> @@ -2800,9 +2792,17 @@ static void scsi_device_block(struct scsi_device *sdev, void *data)
>   
>   	mutex_lock(&sdev->state_mutex);
>   	err = __scsi_internal_device_block_nowait(sdev);
> -	if (err == 0)
> -		scsi_stop_queue(sdev, false);
> -	mutex_unlock(&sdev->state_mutex);
> +	if (err == 0) {
> +		/*
> +		 * scsi_stop_queue() must be called with the state_mutex
> +		 * held. Otherwise a simultaneous scsi_start_queue() call
> +		 * might unquiesce the queue before we quiesce it.
> +		 */
> +		scsi_stop_queue(sdev);
> +		mutex_unlock(&sdev->state_mutex);
> +		blk_mq_wait_quiesce_done(sdev->request_queue->tag_set);
> +	} else
> +		mutex_unlock(&sdev->state_mutex);

Has it been considered to modify the above code such that there is a 
single mutex_unlock() call instead of two? I wouldn't mind if 
blk_mq_wait_quiesce_done() would be called if err != 0 since performance 
is not that important if this function fails.

Thanks,

Bart.

