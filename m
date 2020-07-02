Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779B8C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 07:59:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DAEF20B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 07:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgGBH7k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 03:59:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:57914 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgGBH7j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Jul 2020 03:59:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F1DA8AE48;
        Thu,  2 Jul 2020 07:59:37 +0000 (UTC)
Subject: Re: [PATCH 03/22] scsi: add scsi_{get,put}_internal_cmd() helper
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>, linux-scsi@vger.kernel.org
References: <20200629072021.9864-1-hare@suse.de>
 <20200629072021.9864-4-hare@suse.de>
 <e211779a-d95c-de3a-5beb-6bf0311733fe@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <a0ae1522-856d-f47a-c8c1-f67e38ad4f3c@suse.de>
Date:   Thu, 2 Jul 2020 09:59:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e211779a-d95c-de3a-5beb-6bf0311733fe@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/20 2:48 PM, John Garry wrote:
> On 29/06/2020 08:20, Hannes Reinecke wrote:
>> Add helper functions to allow LLDDs to allocate and free
>> internal commands.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_lib.c    | 44 
>> ++++++++++++++++++++++++++++++++++++++++++++
>>   include/scsi/scsi_device.h |  4 ++++
>>   2 files changed, 48 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 0ba7a65e7c8d..c2277eff4e06 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1903,6 +1903,50 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>>       blk_mq_free_tag_set(&shost->tag_set);
>>   }
>> +/**
>> + * scsi_get_internal_cmd - allocate an internal SCSI command
>> + * @sdev: SCSI device from which to allocate the command
>> + * @data_direction: Data direction for the allocated command
>> + * @op_flags: request allocation flags
>> + *
>> + * Allocates a SCSI command for internal LLDD use.
>> + */
>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>> +    enum dma_data_direction data_direction, int op_flags)
>> +{
>> +    struct request *rq;
>> +    struct scsi_cmnd *scmd;
>> +    blk_mq_req_flags_t flags = 0;
>> +    unsigned int op = REQ_INTERNAL | op_flags;
>> +
>> +    op |= (data_direction == DMA_TO_DEVICE) ?
>> +        REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN;
> 
> As an aside, REQ_OP_SCSI_OUT seems to have same effect as 
> REQ_OP_SCSI_IN, as we only ever check if either is set, here:
> 
> bool blk_op_is_scsi(unsigned int op)
> {
>      return op == REQ_OP_SCSI_OUT || op == REQ_OP_SCSI_IN;
> }
> 
> but maybe I missed something.
> 
Indeed you do :-)

That's one of the best-kept secrets in the block layer:

op_is_write()

The assumption is that every request with a REQ_OP which has the lowest 
bit set is a write.
And quite a lot of accounting the the block layer revolves around that.
So we'll need to keep it.

... and we probably should document it somewhere.

>> +    rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
>> +    if (IS_ERR(rq))
>> +        return NULL;
>> +    scmd = blk_mq_rq_to_pdu(rq);
>> +    scmd->request = rq;
>> +    scmd->device = sdev;
>> +    return scmd;
>> +}
>> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
>> +
>> +/**
>> + * scsi_put_internal_cmd - free an internal SCSI command
>> + * @scmd: SCSI command to be freed
>> + *
>> + * Check if @scmd is an internal command, and call
>> + * blk_mq_free_request() if true.
>> + */
>> +void scsi_put_internal_cmd(struct scsi_cmnd *scmd)
>> +{
>> +    struct request *rq = blk_mq_rq_from_pdu(scmd);
>> +
>> +    if (blk_rq_is_internal(rq))
>> +        blk_mq_free_request(rq);
> 
> I haven't gone through all users in the series, but is it worth warning 
> when we're passed a scmd which isn't an internal command? Doing so seems 
> a programming error which we should yell about.
> 
Will be part of the next round; others have complained, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
