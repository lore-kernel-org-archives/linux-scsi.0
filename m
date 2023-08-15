Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59261C04A6A
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Aug 2023 17:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238720AbjHOR3p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Aug 2023 13:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238850AbjHOR3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Aug 2023 13:29:17 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376641BD8;
        Tue, 15 Aug 2023 10:29:16 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-55b0e7efb1cso3246935a12.1;
        Tue, 15 Aug 2023 10:29:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120555; x=1692725355;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zNwqp9voclo+2OrmEl7irib0fmM01jgzFFd6N4aipkU=;
        b=Y9gbNzRn9BrSzyxEcnvfd1sziEAmksQj2AKTJ2671L+gdUcrMbQrj4sk+r987p/mH/
         YlgfwCyBOiDUVjeZVd0kxBj4Si2aoo9ZCjL5VEEN7QYf/7FlFm9v6ps0sT/y4vnBRfyg
         JpG04fb7fAWeDnhbg5Axv+J0AbIabHt4lG3rwQI28yebh92m2IVFWTvoUpuaDG/LtCai
         eTQw5ZIsWbj8C25CEs+jkkmjjIZjRZW5f8lw0n0CqNhNe6DNmuefS5iwF5auf7efHP5J
         4k/5rwd9mbkAKU+WSpGCeozkcht7MaLP/cdlVt+IPBWpcKfCqh7+be7kV0O8fn5c8aSH
         BtnQ==
X-Gm-Message-State: AOJu0Yx0tmBuLgEQlUXa3Oazn7CPYX8BXdNJ2ST9rCZOs0t1MgVkDAEw
        G8C0Q4OOka+Frk801ZFDZ2hebWmZ0bc=
X-Google-Smtp-Source: AGHT+IFPrvD8w3zR7VM7jALX0ugy7C4j8913EAX3lwW4uAnHyoDPk163z+N+iLw1avQKxWbwuDZMLA==
X-Received: by 2002:a17:90b:e8b:b0:263:e133:b9c9 with SMTP id fv11-20020a17090b0e8b00b00263e133b9c9mr9918840pjb.34.1692120555560;
        Tue, 15 Aug 2023 10:29:15 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:a40d:28ad:b5b9:2ae2? ([2620:15c:211:201:a40d:28ad:b5b9:2ae2])
        by smtp.gmail.com with ESMTPSA id ij13-20020a170902ab4d00b001b02bd00c61sm11478165plb.237.2023.08.15.10.29.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Aug 2023 10:29:15 -0700 (PDT)
Message-ID: <3161926c-b1cb-9617-bf71-73b8711e86de@acm.org>
Date:   Tue, 15 Aug 2023 10:29:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v8 5/9] scsi: core: Retry unaligned zoned writes
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230811213604.548235-1-bvanassche@acm.org>
 <20230811213604.548235-6-bvanassche@acm.org>
 <7dd67537-1ad8-79ca-281c-540bade2cb83@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <7dd67537-1ad8-79ca-281c-540bade2cb83@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/14/23 05:36, Damien Le Moal wrote:
> On 8/12/23 06:35, Bart Van Assche wrote:
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -1238,6 +1238,8 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
>>   	cmd->transfersize = sdp->sector_size;
>>   	cmd->underflow = nr_blocks << 9;
>>   	cmd->allowed = sdkp->max_retries;
>> +	if (!rq->q->limits.use_zone_write_lock && blk_rq_is_seq_zoned_write(rq))
> 
> This condition could be written as a little inline helper
> blk_req_need_zone_write_lock(), which could be used in mq-dealine patch 2.

The above test differs from the tests in the mq-deadline I/O scheduler.
The mq-deadline I/O scheduler uses write locking if
rq->q->limits.use_zone_write_lock && q->disk->seq_zones_wlock &&
blk_rq_is_seq_zoned_write(rq). The above test is different and occurs
two times in scsi_error.c and one time in sd.c. Do you still want me to
introduce a helper function for that expression?

Thanks,

Bart.
