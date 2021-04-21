Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C2FC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:01:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B74F86144E
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240376AbhDUVBk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 17:01:40 -0400
Received: from mail-pf1-f174.google.com ([209.85.210.174]:41613 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236602AbhDUVBh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 17:01:37 -0400
Received: by mail-pf1-f174.google.com with SMTP id w6so15512300pfc.8
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 14:01:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vP40ubjZYDy1wdoDxIU0WAuR1P47574UJzHo3i3XSTM=;
        b=tI5Dm2LN+tHkJuEHYsd4V2AEeCA847y5rlmZuh3aNMb1CEA8K8kn6VvQcaXvn4jxIj
         lQE9yBXw4oEQhIOms9KsvrE+owRN2HVBd4N8aoe3j5Db2AAnKV3CoC07BfNhPN9Sh1yh
         kQus9G96AJOnnkIDI1DHoQcqmkAWh3WHoikU13Y4hStRZ3pHRoJd0VGVSIbqVo+1TSUJ
         9b/aGpfFxPamxVO2wLG0k5IqfIt+vnfuYWB9XtGSWGRiW+KEnNoshUOI1tU5FRxWl5uv
         sGe5tqbKSDrU3zdfVWxU+ewaoLY6P6iWJ7YiFw+7q1eJSC4AeU4G8dLQGJGxYMw0koOW
         mtcA==
X-Gm-Message-State: AOAM5305npSJAVVWBOAiLUzLv08aNwCEH2E88iu1hDQWcQN9QwSVBnrG
        93m0+RTHctANEMfX/noPM7Mz96fE8YmxFg==
X-Google-Smtp-Source: ABdhPJxEWppYquEDxBP/8rSDxuhO1fVLghybjZmdI66i8dJLqsw0mvVWyFUAYPJ+3IldELP1cfA/tg==
X-Received: by 2002:a05:6a00:1aca:b029:25a:b810:94c7 with SMTP id f10-20020a056a001acab029025ab81094c7mr71427pfv.15.1619038863371;
        Wed, 21 Apr 2021 14:01:03 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id r18sm2871106pjo.30.2021.04.21.14.01.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 14:01:02 -0700 (PDT)
Subject: Re: [PATCH 02/42] scsi_ioctl: return error code when
 blk_rq_map_kern() fails
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-3-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cf3e301e-e4f7-9def-e66b-c0a3eaa838a2@acm.org>
Date:   Wed, 21 Apr 2021 14:01:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-3-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 10:47 AM, Hannes Reinecke wrote:
> The callers of sg_scsi_ioctl() already check for negative
> return values, so we can drop the usage of DRIVER_ERROR
> and return the error from blk_rq_map_kern() instead.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   block/scsi_ioctl.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 6599bac0a78c..99d58786e0d5 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -488,9 +488,10 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
>   		break;
>   	}
>   
> -	if (bytes && blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO)) {
> -		err = DRIVER_ERROR << 24;
> -		goto error;
> +	if (bytes) {
> +		err = blk_rq_map_kern(q, rq, buffer, bytes, GFP_NOIO);
> +		if (err)
> +			goto error;
>   	}
>   
>   	blk_execute_rq(disk, rq, 0);

Is this perhaps a backwards-incompatible user space ABI change since the 
sg_scsi_ioctl() return value is reported to user space?

Thanks,

Bart.


