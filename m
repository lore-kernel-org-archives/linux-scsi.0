Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 516F6C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 12:55:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1ECD7613BA
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 12:55:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhEDMzz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 08:55:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:38322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhEDMzy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 08:55:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 45E63AE00;
        Tue,  4 May 2021 12:54:59 +0000 (UTC)
Subject: Re: [PATCH 03/18] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-4-hare@suse.de> <20210504095346.GC25986@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <5ef846cb-2861-3c23-ed8c-54f54131ad1a@suse.de>
Date:   Tue, 4 May 2021 14:54:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210504095346.GC25986@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 11:53 AM, Christoph Hellwig wrote:
> On Mon, May 03, 2021 at 05:03:18PM +0200, Hannes Reinecke wrote:
>> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
>> +	unsigned int op, blk_mq_req_flags_t flags)
> 
> Weird indentation - prototype continuations either use two tabs or
> are aligned after the opening brace (I generally prefer the former).
> 
Yeah, I'm never sure how one should be indenting the second line for a 
function declaration. But I'll fix it.

>> +{
>> +	struct request *rq;
>> +	struct scsi_cmnd *scmd;
>> +
>> +	WARN_ON_ONCE(((op & REQ_OP_MASK) != REQ_OP_SCSI_IN) &&
>> +		     ((op & REQ_OP_MASK) != REQ_OP_SCSI_OUT));
> 
> Woudn't a simple bool write command make more sense than passing the
> actual op here?
> 
Yep, can do.

>> +	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
>> +	if (IS_ERR(rq))
>> +		return NULL;
>> +	scmd = blk_mq_rq_to_pdu(rq);
>> +	scmd->request = rq;
>> +	scmd->device = sdev;
> 
> Maybe a comment that explains what part of the scmd are initialized
> and which not would be useful.
> 
Okay.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
