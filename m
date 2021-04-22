Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21307C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 08:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 025376144E
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Apr 2021 08:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbhDVIj4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Apr 2021 04:39:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:35254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235249AbhDVIjx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Apr 2021 04:39:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 15DAFAC7D;
        Thu, 22 Apr 2021 08:39:18 +0000 (UTC)
Subject: Re: [PATCH 05/42] scsi: stop using DRIVER_ERROR
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-6-hare@suse.de>
 <139685e9-6f8b-ab5b-59b2-6a4b06fc5f39@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ddef4880-bdf5-1d6b-1a36-756ac0091b18@suse.de>
Date:   Thu, 22 Apr 2021 10:39:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <139685e9-6f8b-ab5b-59b2-6a4b06fc5f39@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 11:30 PM, Bart Van Assche wrote:
> On 4/21/21 10:47 AM, Hannes Reinecke wrote:
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index c532f9390ae3..2d9b533ef1ec 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -245,20 +245,23 @@ int __scsi_execute(struct scsi_device *sdev, 
>> const unsigned char *cmd,
>>   {
>>       struct request *req;
>>       struct scsi_request *rq;
>> -    int ret = DRIVER_ERROR << 24;
>> +    int ret;
>>       req = blk_get_request(sdev->request_queue,
>>               data_direction == DMA_TO_DEVICE ?
>>               REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN,
>>               rq_flags & RQF_PM ? BLK_MQ_REQ_PM : 0);
>>       if (IS_ERR(req))
>> -        return ret;
>> -    rq = scsi_req(req);
>> +        return PTR_ERR(req);
>> -    if (bufflen &&    blk_rq_map_kern(sdev->request_queue, req,
>> -                    buffer, bufflen, GFP_NOIO))
>> -        goto out;
>> +    rq = scsi_req(req);
>> +    if (bufflen) {
>> +        ret = blk_rq_map_kern(sdev->request_queue, req,
>> +                      buffer, bufflen, GFP_NOIO);
>> +        if (ret)
>> +            goto out;
>> +    }
>>       rq->cmd_len = COMMAND_SIZE(cmd[0]);
>>       memcpy(rq->cmd, cmd, rq->cmd_len);
>>       rq->retries = retries;
> 
> Please mention in the patch description that this change involves a user 
> space ABI change. My understanding is that the current behavior of the 
> IOC_PR_* ioctls is as follows:
> * A value <= 0 is returned for NVMe where 0 represents success and a 
> negative value represents failure.
> * A value >= 0 is returned for SCSI where 0 represents success and a 
> positive value is a four-byte SCSI status code.
> 
> This patch changes the behavior for SCSI from returning a value >= 0 
> into returning a value that can be negative, zero or positive where only 
> the return value 0 represents success.
> 
> See also sd_pr_command() in drivers/scsi/sd.c.
> 

As indicated: the description for __scsi_execute() explicitly states 
that a negative return value is allowed here.
And all functions calling sd_pr_command() might even now return a 
negative error value, so userspace _must_ be prepared to handle it.

So while we're changing the error we return, the actual impact to 
userspace should be pretty neglible as either error value indicates
a non-retryable failure.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
