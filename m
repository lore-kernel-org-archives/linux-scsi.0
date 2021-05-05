Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4F6C433ED
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 05:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67EDC610EA
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 05:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhEEF5r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 May 2021 01:57:47 -0400
Received: from mx2.suse.de ([195.135.220.15]:52276 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhEEF5q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 May 2021 01:57:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F25CBADEF;
        Wed,  5 May 2021 05:56:49 +0000 (UTC)
Subject: Re: [PATCH 10/18] scsi: implement reserved command handling
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-11-hare@suse.de>
 <583ea6ee-f8ce-7063-ca2a-409fee83a2b6@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <1baf8877-efe6-a901-e939-7d949f961fc6@suse.de>
Date:   Wed, 5 May 2021 07:56:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <583ea6ee-f8ce-7063-ca2a-409fee83a2b6@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/5/21 2:45 AM, Bart Van Assche wrote:
> On 5/3/21 8:03 AM, Hannes Reinecke wrote:
>>  struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>>  	unsigned int op, blk_mq_req_flags_t flags)
>> @@ -2005,6 +2009,10 @@ struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>>  
>>  	WARN_ON_ONCE(((op & REQ_OP_MASK) != REQ_OP_SCSI_IN) &&
>>  		     ((op & REQ_OP_MASK) != REQ_OP_SCSI_OUT));
>> +
>> +	if (sdev->host->nr_reserved_cmds)
>> +		flags |= BLK_MQ_REQ_RESERVED;
>> +
>>  	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
>>  	if (IS_ERR(rq))
>>  		return NULL;
> 
> Can the if-statement be removed such that scsi_get_internal_cmd() fails
> if sdev->host->nr_reserved_cmds == 0? I'm concerned that otherwise it
> will be very hard to determine which requests are internal and which
> ones not from inside a blk_mq_tagset_busy_iter() callback.
> 
Original idea was that one could use scsi_get_internal_cmd() even with
nr_reserved_cmds == 0, but you are right that this will probably just
lead to confusion.

Will be modifying it for the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
