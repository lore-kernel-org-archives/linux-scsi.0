Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4E3C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:30:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48220613C7
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343503AbhDUVbG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 17:31:06 -0400
Received: from mail-pg1-f178.google.com ([209.85.215.178]:44596 "EHLO
        mail-pg1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238736AbhDUVbF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 17:31:05 -0400
Received: by mail-pg1-f178.google.com with SMTP id y32so31185045pga.11
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 14:30:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CM7pHJCQ9en5fVeKf9UGFRIbwE9I50YVXmWPFJOjAys=;
        b=GpB2pLukdfyZ2cKPkuRG6vZ/57ecDVPlUmRvSZv/QUmmEZ43IntXvrVfGapZXkGIzS
         lmcEAo1boICj//Jrd66/pCmvwIqbqquavkNf3gNoe2T5/1bFjQlNRqiPO3naopP+MlJX
         X6Qc64Y/pXnqKVA3tr0PFQfKnk8MCwpMM2C2uBWn3HbgXn3U5XlKSEquoOH5pxX9dQYk
         KDt9XB1qRDFsbHfUjOya+0mRpOj8D2WiO8qFm0K/6wX/5xsLP///SCod7vK1vkQDmkGA
         zkseyLGHShMBW6SNI0PZbjNF5CguHUND2J4XDZxboCH5yL7i2n/j95Mix1nRcy1bfYsx
         caQA==
X-Gm-Message-State: AOAM5317Cz6KFH9YlnZakBHe0ZG5WEsv+xLpTCDCxwvVXOPmpHdNRSFF
        kGeUjuKRJg0deZNkqxM/WoLFL06Gw8BYzA==
X-Google-Smtp-Source: ABdhPJyDrnbmjDS4ob/qpUlSkBtzxq0ge/mgLBv04tII+iml8nLvrALE+TGhfNOrBwUYnQsOvkTuSw==
X-Received: by 2002:a17:90b:147:: with SMTP id em7mr149712pjb.138.1619040631566;
        Wed, 21 Apr 2021 14:30:31 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id oa9sm246484pjb.44.2021.04.21.14.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 14:30:30 -0700 (PDT)
Subject: Re: [PATCH 05/42] scsi: stop using DRIVER_ERROR
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-6-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <139685e9-6f8b-ab5b-59b2-6a4b06fc5f39@acm.org>
Date:   Wed, 21 Apr 2021 14:30:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-6-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 10:47 AM, Hannes Reinecke wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index c532f9390ae3..2d9b533ef1ec 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -245,20 +245,23 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>   {
>   	struct request *req;
>   	struct scsi_request *rq;
> -	int ret = DRIVER_ERROR << 24;
> +	int ret;
>   
>   	req = blk_get_request(sdev->request_queue,
>   			data_direction == DMA_TO_DEVICE ?
>   			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
>   			rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
>   	if (IS_ERR(req))
> -		return ret;
> -	rq = scsi_req(req);
> +		return PTR_ERR(req);
>   
> -	if (bufflen &&	blk_rq_map_kern(sdev->request_queue, req,
> -					buffer, bufflen, GFP_NOIO))
> -		goto out;
> +	rq = scsi_req(req);
>   
> +	if (bufflen) {
> +		ret = blk_rq_map_kern(sdev->request_queue, req,
> +				      buffer, bufflen, GFP_NOIO);
> +		if (ret)
> +			goto out;
> +	}
>   	rq->cmd_len = COMMAND_SIZE(cmd[0]);
>   	memcpy(rq->cmd, cmd, rq->cmd_len);
>   	rq->retries = retries;

Please mention in the patch description that this change involves a user 
space ABI change. My understanding is that the current behavior of the 
IOC_PR_* ioctls is as follows:
* A value <= 0 is returned for NVMe where 0 represents success and a 
negative value represents failure.
* A value >= 0 is returned for SCSI where 0 represents success and a 
positive value is a four-byte SCSI status code.

This patch changes the behavior for SCSI from returning a value >= 0 
into returning a value that can be negative, zero or positive where only 
the return value 0 represents success.

See also sd_pr_command() in drivers/scsi/sd.c.

Thanks,

Bart.
