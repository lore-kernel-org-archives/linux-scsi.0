Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50BCDC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 10:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DF5820708
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 10:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgF1KNi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 06:13:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:51162 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbgF1KNi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 28 Jun 2020 06:13:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 40634ACCC;
        Sun, 28 Jun 2020 10:13:37 +0000 (UTC)
Subject: Re: [PATCH 02/22] block: add flag for internal commands
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microchip.de>, linux-scsi@vger.kernel.org
References: <20200625140124.17201-1-hare@suse.de>
 <20200625140124.17201-3-hare@suse.de>
 <3576e7ea-02d3-fc48-a66b-4dcc1bf6a8c2@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f63e5192-aa06-a69a-fabd-083a876a2a51@suse.de>
Date:   Sun, 28 Jun 2020 12:13:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <3576e7ea-02d3-fc48-a66b-4dcc1bf6a8c2@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/28/20 5:43 AM, Bart Van Assche wrote:
> On 2020-06-25 07:01, Hannes Reinecke wrote:
>> diff --git a/block/blk-exec.c b/block/blk-exec.c
>> index 85324d53d072..86e8968cfa90 100644
>> --- a/block/blk-exec.c
>> +++ b/block/blk-exec.c
>> @@ -55,6 +55,11 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
>>   	rq->rq_disk = bd_disk;
>>   	rq->end_io = done;
>>   
>> +	if (WARN_ON(blk_rq_is_internal(rq))) {
>> +		blk_mq_end_request(rq, BLK_STS_NOTSUPP);
>> +		return;
>> +	}
>> +
>>   	blk_account_io_start(rq);
> 
> Isn't it recommended to use WARN_ON_ONCE() instead of WARN_ON()?
> 
Depends on the frequency, but yeah, we could.

>>   #define REQ_DRV			(1ULL << __REQ_DRV)
>>   #define REQ_SWAP		(1ULL << __REQ_SWAP)
>> +#define REQ_INTERNAL		(1ULL << __REQ_INTERNAL)
> 
> How about introducing a __bitwise type for the REQ_ flags such that
> sparse can check whether the proper type of flags has been passed to a
> function?
> 
Possibly, but that would be a different patchset.
I'd rather not introduce it here as it would convolute this patchset 
even more.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
