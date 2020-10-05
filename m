Return-Path: <SRS0=3mnS=DM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95905C4363A
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 16:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 653C2206DD
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Oct 2020 16:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgJEQL6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Oct 2020 12:11:58 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41783 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbgJEQL6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Oct 2020 12:11:58 -0400
Received: by mail-pf1-f196.google.com with SMTP id g10so3987257pfc.8
        for <linux-scsi@vger.kernel.org>; Mon, 05 Oct 2020 09:11:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RJ9WkD4gmXcph2EpcYyERdqsNqFWYrdlq7h3L/p7PFM=;
        b=RQ3hGXz8dCzQktfhSrvE0/Y0aMO61TPwYystzOUXc7X/QMPVfp3yusvggLCpfa03J1
         HPkJ99uwdWdb+h/BLhZWYFAIEHYUFjpnQQKMQ6CLSdvQBQ2EReC0bo1PEJzHvDq2LTE4
         nIGQXYvpNnIO6yLhkWY+qpU9yMncq8LNlKL+0gQYLJL9AY/agMm+GsGs3cneqlEaZQI5
         YOOWU2c0RCSbYaeCsURIs0Izx+QNuIFHBoEuEeLEF2SoZgq0c8e4xSUkmZ40MX8ga2fE
         O08RFM3JzFf1dk74sEtIuvoUbow6jZJGGmfrsfcrGVnw0kTWRPHvmfzkOJRfbBVQ/chM
         Vp5w==
X-Gm-Message-State: AOAM53236wLo7FwzvJo+pBHoYVb9z1WGmM8URDjIexnaofjtpZZUY3O4
        +iZcSp++Al3WZyGxMkC/CDNrjyjbEh0=
X-Google-Smtp-Source: ABdhPJz/RLNbq/HyRCy5TaiWNfuxYXyYVHDSyg+cR3mc1x/QduzpB1ZYTYlbT6ZaWwVJJPYAvoE1pw==
X-Received: by 2002:aa7:8b03:0:b029:152:a364:5084 with SMTP id f3-20020aa78b030000b0290152a3645084mr416573pfd.29.1601914316419;
        Mon, 05 Oct 2020 09:11:56 -0700 (PDT)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id p9sm356682pff.167.2020.10.05.09.11.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 09:11:55 -0700 (PDT)
Subject: Re: [PATCH 10/10] scsi: only start the request just before
 dispatching
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20201005084130.143273-1-hch@lst.de>
 <20201005084130.143273-11-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <889875a1-0210-4e72-b6b5-3dfe92d2e5bf@acm.org>
Date:   Mon, 5 Oct 2020 09:11:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005084130.143273-11-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/20 1:41 AM, Christoph Hellwig wrote:
> This has no change in behavior, but improves the accounting a bit.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/scsi/scsi_lib.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f7b88d8cf975d5..f0254f913b3e3f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1548,8 +1548,6 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>   			(struct scatterlist *)(cmd->prot_sdb + 1);
>   	}
>   
> -	blk_mq_start_request(req);
> -
>   	/*
>   	 * Special handling for passthrough commands, which don't go to the ULP
>   	 * at all:
> @@ -1649,7 +1647,6 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   		req->rq_flags |= RQF_DONTPREP;
>   	} else {
>   		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
> -		blk_mq_start_request(req);
>   	}
>   
>   	cmd->flags &= SCMD_PRESERVED_FLAGS;
> @@ -1662,6 +1659,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
>   	cmd->scsi_done = scsi_mq_done;
>   
> +	blk_mq_start_request(req);
>   	reason = scsi_dispatch_cmd(cmd);
>   	if (reason) {
>   		scsi_set_blocked(cmd, reason);

That's a nice cleanup!

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
