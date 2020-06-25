Return-Path: <SRS0=uw5d=AG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B76ECC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 15:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BA3C208C9
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Jun 2020 15:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390150AbgFYP7G (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Jun 2020 11:59:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:38954 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389860AbgFYP7G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Jun 2020 11:59:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 096A9AC12;
        Thu, 25 Jun 2020 15:59:04 +0000 (UTC)
Subject: Re: [PATCH 08/22] scsi: implement reserved command handling
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Don Brace <don.brace@microchip.de>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
References: <20200625140124.17201-1-hare@suse.de>
 <20200625140124.17201-9-hare@suse.de>
 <8074064c-a2ea-2084-cd1a-60bf51af6844@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8872a235-76cc-0c80-3f6d-7f001ddf2578@suse.de>
Date:   Thu, 25 Jun 2020 17:59:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8074064c-a2ea-2084-cd1a-60bf51af6844@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/25/20 5:30 PM, John Garry wrote:
> On 25/06/2020 15:01, Hannes Reinecke wrote:
>> Quite some drivers are using management commands internally, which
>> typically use the same hardware tag pool (ie they are being allocated
>> from the same hardware resources) as the 'normal' I/O commands.
>> These commands are set aside before allocating the block-mq tag bitmap,
>> so they'll never show up as busy in the tag map.
>> The block-layer, OTOH, already has 'reserved_tags' to handle precisely
>> this situation.
>> So this patch adds a new field 'nr_reserved_cmds' to the SCSI host
>> template to instruct the block layer to set aside a tag space for these
>> management commands by using reserved tags.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/scsi_lib.c  | 10 +++++++++-
>>   include/scsi/scsi_host.h | 11 +++++++++++
>>   2 files changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index bd378e1bd3fc..a752806af70b 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1887,7 +1887,9 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>>       else
>>           tag_set->ops = &scsi_mq_ops_no_commit;
>>       tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
>> -    tag_set->queue_depth = shost->can_queue;
>> +    tag_set->queue_depth =
>> +        shost->can_queue + shost->nr_reserved_cmds;
>> +    tag_set->reserved_tags = shost->nr_reserved_cmds;
>>       tag_set->cmd_size = cmd_size;
>>       tag_set->numa_node = NUMA_NO_NODE;
>>       tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
>> @@ -1910,6 +1912,9 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>>    * @op_flags: request allocation flags
>>    *
>>    * Allocates a SCSI command for internal LLDD use.
>> + * If 'nr_reserved_commands' is spectified by the host the
> 
> /s/spectified/specified/
> 
> I suppose making this usable by drivers which don't set 
> nr_reserved_commands is helpful (if not slightly strange). In that we 
> can move drivers which don't use rq->tag currently - like pm8001 - to 
> use it, and not have to worry about guessing some nr_reserved_commands 
> to specify.
> 
That's what I plan to do, and in fact have patches queued for that.
I've just posted the initial patchset here to agree on the interface
and provide drivers which benefit from it with very little churn.

In a later patchset I'll be converting other drivers and subsystems like
megaraid_sas and libsas etc; those I had in the v3 version but that was
deemed to complex for the initial submission.
Hence I've left them out in this round.

>> + * command will be allocated from the reserved tag pool;
>> + * otherwise the normal tag pool will be used.
>>    */
>>   struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>>                       int data_direction, int op_flags)
>> @@ -1919,6 +1924,9 @@ struct scsi_cmnd *scsi_get_internal_cmd(struct 
>> scsi_device *sdev,
>>       blk_mq_req_flags_t flags = 0;
>>       unsigned int op = REQ_INTERNAL | op_flags;
>> +    if (sdev->host->nr_reserved_cmds)
>> +        flags = BLK_MQ_REQ_RESERVED; > +
>>       op |= (data_direction == DMA_TO_DEVICE) ?
>>           REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN;
>>       rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index 46ef8cccc982..b94938e87e3a 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -590,6 +590,11 @@ struct Scsi_Host {
>>       unsigned short max_cmd_len;
>>       int this_id;
>> +
>> +    /*
>> +     * Number of commands this host can handle at the same time.
>> +     * This excludes reserved commands as specified by nr_reserved_cmds.
>> +     */
>>       int can_queue;
>>       short cmd_per_lun;
>>       short unsigned int sg_tablesize;
>> @@ -606,6 +611,12 @@ struct Scsi_Host {
>>        * is nr_hw_queues * can_queue.
> 
> If we are going to go this way, then could you update the comment on 
> Scsi_Host.nr_hw_queues here? Currently we have "it is assumed that each 
> hardware queue has a depth of can_queue..."
> 
Ah. Right. Yes, will do.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
