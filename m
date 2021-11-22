Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9729DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 17:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240149AbhKVRtN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 12:49:13 -0500
Received: from mail-pj1-f49.google.com ([209.85.216.49]:45641 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbhKVRtM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 12:49:12 -0500
Received: by mail-pj1-f49.google.com with SMTP id gb13-20020a17090b060d00b001a674e2c4a8so524366pjb.4
        for <linux-scsi@vger.kernel.org>; Mon, 22 Nov 2021 09:46:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iVn661gPZZIo5ITHX3Aa4z1htHjjzCbNZxVQPLGe/h4=;
        b=D8/jWRw1CniD83NFO+9eohLY5J+U8JeyJgr/YvJJhXVNu2bCikE5j4HjJzIk6qTccg
         UJOcjzwdls/iedGd2tSaVu7FoES36E74ZsjrztJsNFivNn2sg0COaE5IR8PL1TJkQwMA
         9rF0/37xWaOxviSiW6UGJiwkqhzM0Pv2Ogg14OZIYtRVCqAX5rIU5rnH3qY/NcnkYWQ6
         emz1FPTf8kxcRDecANLj4TkXITyL5eaftZra++fh4Q0aNpYHYnVxkToMVk1E4bXj+97R
         7Na98UtEVyN4ds1qSGwb9EPv7fclsyXpc7mZt5A8ZysSiNN0iwubcG3NEfFatK/uF7J0
         LukA==
X-Gm-Message-State: AOAM531PzBWuQfUYpUv0NcbNIgZmhrN+uGMJNUPoQCRLvPgDxwrT9qQS
        kNOwdv8MAQbe9IsALcpdluc=
X-Google-Smtp-Source: ABdhPJxpC0L2AGD/UCv5TATkoBSbb7xLciox6+hiVY2kNzoBlZ5X5kafj5bB3QlCK6n5xZdlHPYHTw==
X-Received: by 2002:a17:903:1c5:b0:141:fbe2:56c1 with SMTP id e5-20020a17090301c500b00141fbe256c1mr108469189plh.52.1637603165046;
        Mon, 22 Nov 2021 09:46:05 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3432:c377:2744:1125])
        by smtp.gmail.com with ESMTPSA id j7sm9187095pfu.164.2021.11.22.09.46.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Nov 2021 09:46:04 -0800 (PST)
Subject: Re: [PATCH v2 05/20] scsi: core: Add support for internal commands
To:     John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-6-bvanassche@acm.org>
 <d396a5ed-763e-de79-1714-b4e58e812c7f@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <24ce9815-c01d-9ad4-2221-5a5b041ee231@acm.org>
Date:   Mon, 22 Nov 2021 09:46:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <d396a5ed-763e-de79-1714-b4e58e812c7f@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/21 12:58 AM, John Garry wrote:
> On 19/11/2021 19:57, Bart Van Assche wrote:
>> +/**
>> + * scsi_get_internal_cmd - Allocate an internal SCSI command
>> + * @q: request queue from which to allocate the command. This request 
>> queue may
>> + *    but does not have to be associated with a SCSI device. This 
>> request
>> + *    queue must be associated with a SCSI tag set. See also
>> + *    scsi_mq_setup_tags().
>> + * @data_direction: Data direction for the allocated command.
>> + * @flags: Zero or more BLK_MQ_REQ_* flags.
>> + *
>> + * Allocates a request for driver-internal use. The tag of the 
>> returned SCSI
>> + * command is guaranteed to be unique.
>> + */
>> +struct scsi_cmnd *scsi_get_internal_cmd(struct request_queue *q,
>> +                    enum dma_data_direction data_direction,
>> +                    blk_mq_req_flags_t flags)
> 
> I'd pass the Scsi_Host or scsi_device rather than a request q, so maybe:
> 
> struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev, ..)
> struct scsi_cmnd *scsi_host_get_internal_cmd(struct Scsi_Host *shost, ..)

Passing a request queue pointer as first argument instead of a struct 
scsi_device is a deliberate choice. In the UFS driver (and probably also 
in other SCSI LLDs) we want to allocate internal requests without these 
requests being visible in any existing SCSI device statistics. Creating 
a new SCSI device for the allocation of internal requests is not a good 
choice because that new SCSI device would have to be assigned a LUN 
number and would be visible in sysfs. Hence the choice to allocate 
internal requests from a request queue that is not associated with any 
SCSI device.

>> +{
>> +    unsigned int opf = REQ_INTERNAL;
>> +    struct request *rq;
>> +
>> +    opf |= data_direction == DMA_TO_DEVICE ? REQ_OP_DRV_OUT : 
>> REQ_OP_DRV_IN;
>> +    rq = blk_mq_alloc_request(q, opf, flags);
>> +    if (IS_ERR(rq))
>> +        return ERR_CAST(rq);
> 
> I think that Christoph suggested elsewhere that we should poison all the 
> scsi_cmnd

I had overlooked that comment. I will look into this.

Thanks,

Bart.
