Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 378BCC433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 09:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CED820772
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 09:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726130AbgF1JCG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 05:02:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:38158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbgF1JCG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Jun 2020 05:02:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B86F3AC40;
        Sun, 28 Jun 2020 09:02:04 +0000 (UTC)
Subject: Re: [PATCH 03/22] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microchip.de>, linux-scsi@vger.kernel.org
References: <20200625140124.17201-1-hare@suse.de>
 <20200625140124.17201-4-hare@suse.de>
 <863b7da2-bbfc-a32f-87ab-648f8561314c@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <7a52763c-eb51-7c63-8d06-b0cc2eab6630@suse.de>
Date:   Sun, 28 Jun 2020 11:02:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <863b7da2-bbfc-a32f-87ab-648f8561314c@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/20 5:48 AM, Bart Van Assche wrote:
> On 2020-06-25 07:01, Hannes Reinecke wrote:
>> +/**
>> + * scsi_get_internal_cmd - allocate an intenral SCSI command
>                                            ^^^^^^^^
>                                            internal?
>> + * @sdev: SCSI device from which to allocate the command
>> + * @data_direction: Data direction for the allocated command
>> + * @op_flags: request allocation flags
>> + *
>> + * Allocates a SCSI command for internal LLDD use.
>> + */
>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>> +					int data_direction, int op_flags)
> 
> How about using enum dma_data_direction for data_direction and unsigned
> int, or even better, a new __bitwise type for op_flags?
> 
Okay for data direction, but converting op_flags into __bitwise (or even 
a new type) should be relegated to a different patchset.

>> +{
>> +	struct request *rq;
>> +	struct scsi_cmnd *scmd;
>> +	blk_mq_req_flags_t flags = 0;
>> +	unsigned int op = REQ_INTERNAL | op_flags;
>> +
>> +	op |= (data_direction == DMA_TO_DEVICE) ?
>> +		REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN;
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
> Since the 'flags' variable always has the value 0, can it be left out?
> 
Yep, true.

>> +/**
>> + * scsi_put_internal_cmd - free an internal SCSI command
>> + * @scmd: SCSI command to be freed
>> + */
>> +void scsi_put_internal_cmd(struct scsi_cmnd *scmd)
>> +{
>> +	struct request *rq = blk_mq_rq_from_pdu(scmd);
>> +
>> +	if (blk_rq_is_internal(rq))
>> +		blk_mq_free_request(rq);
>> +}
>> +EXPORT_SYMBOL_GPL(scsi_put_internal_cmd);
> 
> How about triggering a warning for the !blk_rq_is_internal(rq) case
> instead of silently ignoring regular SCSI commands?
> 
That's by design.
Some drivers have a common routine for freeing up commands, so it'd be 
quite tricky to separate these two cases out at the driver level.
So it's far easier to call the common routine for all commands, and
let this function do the right thing for all commands.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
