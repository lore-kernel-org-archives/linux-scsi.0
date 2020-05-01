Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38EBC47257
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 15:42:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE27D24956
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 15:42:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729860AbgEAPm7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 11:42:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:52300 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728812AbgEAPm6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 11:42:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1B799AC69;
        Fri,  1 May 2020 15:42:57 +0000 (UTC)
Subject: Re: [PATCH RFC v3 02/41] scsi: add scsi_{get,put}_reserved_cmd()
To:     dgilbert@interlog.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-3-hare@suse.de>
 <4cd3cb8a-b61a-54c8-bc0a-da8a1bdc3b70@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <97accaa0-5209-4700-5090-62cb704d3755@suse.de>
Date:   Fri, 1 May 2020 17:42:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <4cd3cb8a-b61a-54c8-bc0a-da8a1bdc3b70@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/30/20 7:11 PM, Douglas Gilbert wrote:
> On 2020-04-30 9:18 a.m., Hannes Reinecke wrote:
>> Add helper functions to retrieve SCSI commands from the reserved
>> tag pool.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>   drivers/scsi/scsi_lib.c    | 35 +++++++++++++++++++++++++++++++++++
>>   include/scsi/scsi_device.h |  3 +++
>>   2 files changed, 38 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 5358f553f526..d0972744ea7f 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -1901,6 +1901,41 @@ void scsi_mq_destroy_tags(struct Scsi_Host *shost)
>>       blk_mq_free_tag_set(&shost->tag_set);
>>   }
>> +/**
>> + * scsi_get_reserved_cmd - allocate a SCSI command from reserved tags
>> + * @sdev: SCSI device from which to allocate the command
>> + * @data_direction: Data direction for the allocated command
>> + */
>> +struct scsi_cmnd *scsi_get_reserved_cmd(struct scsi_device *sdev,
>> +                    int data_direction)
>> +{
>> +    struct request *rq;
>> +    struct scsi_cmnd *scmd;
>> +
>> +    rq = blk_mq_alloc_request(sdev->request_queue,
>> +                  data_direction == DMA_TO_DEVICE ?
>> +                  REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN | REQ_NOWAIT,
> 
> after consulting: 
> https://en.cppreference.com/w/c/language/operator_precedence
> I think that the above expression can be written as:
> 
> (data_direction == DMA_TO_DEVICE) ? REQ_OP_SCSI_OUT : (REQ_OP_SCSI_IN | 
> REQ_NOWAIT),
> 
> So is REQ_NOWAIT not needed with REQ_OP_SCSI_OUT ?
> 
Nope, that's an error on my side.
REQ_NOWAIT should be set for both directions.

I'll fix it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
