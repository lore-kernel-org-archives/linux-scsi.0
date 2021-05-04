Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3811C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 06:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 795BA60FEB
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 06:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhEDGNV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 02:13:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:41184 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhEDGNV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 02:13:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 40C6CB2BB;
        Tue,  4 May 2021 06:12:26 +0000 (UTC)
Subject: Re: [PATCH 03/18] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-4-hare@suse.de>
 <d9c7f79f-f0ec-a420-517c-d6ca83d99ef9@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <e2b24fd6-fe1b-ac5e-e370-93900d98ac90@suse.de>
Date:   Tue, 4 May 2021 08:12:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <d9c7f79f-f0ec-a420-517c-d6ca83d99ef9@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 4:21 AM, Bart Van Assche wrote:
> On 5/3/21 8:03 AM, Hannes Reinecke wrote:
>> +/**
>> + * scsi_get_internal_cmd - allocate an internal SCSI command
>> + * @sdev: SCSI device from which to allocate the command
>> + * @op: operation (REQ_OP_SCSI_IN or REQ_OP_SCSI_OUT)
>> + * @flags: BLK_MQ_REQ_* flags, e.g. BLK_MQ_REQ_NOWAIT.
>> + *
>> + * Allocates a SCSI command for internal LLDD use.
>> + */
>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>> +	unsigned int op, blk_mq_req_flags_t flags)
>> +{
>> +	struct request *rq;
>> +	struct scsi_cmnd *scmd;
>> +
>> +	WARN_ON_ONCE(((op & REQ_OP_MASK) != REQ_OP_SCSI_IN) &&
>> +		     ((op & REQ_OP_MASK) != REQ_OP_SCSI_OUT));
>> +	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
>> +	if (IS_ERR(rq))
>> +		return NULL;
>> +	scmd = blk_mq_rq_to_pdu(rq);
>> +	scmd->request = rq;
>> +	scmd->device = sdev;
>> +	return scmd;
>> +}
>> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);
> 
> Multiple fields that are initialized by the regular command submission
> path are not initialized by the above function, e.g. scmd->tag. Has it
> been considered to call scsi_init_command() instead of adding yet
> another code path that initializes scmd->request?
> 
Hmm. No, I don't think it's a good idea.
Basic idea is that the SCSI request serves as a container for (non-SCSI) 
management commands, _and_ that they are submitted directly from within 
the driver, ie never ever enter ->queue_rq().
As such we don't need an initialisation vie scsi_init_request(), and it 
would actually be counter-productive as we would be setting up fields 
which we'll never need anyway, and might need to tear down afterwards.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
