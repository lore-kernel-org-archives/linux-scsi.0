Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A311DC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 07:15:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 738C961076
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 07:15:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbhD0HQR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 03:16:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:60782 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231327AbhD0HQQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 03:16:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8E017B0BD;
        Tue, 27 Apr 2021 07:15:32 +0000 (UTC)
Subject: Re: [PATCH 08/39] scsi: Kill DRIVER_SENSE
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-9-hare@suse.de> <20210426152016.GA25615@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <97812358-b222-4205-cb1f-b0486d7472da@suse.de>
Date:   Tue, 27 Apr 2021 09:15:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210426152016.GA25615@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/21 5:20 PM, Christoph Hellwig wrote:
> On Fri, Apr 23, 2021 at 01:39:13PM +0200, Hannes Reinecke wrote:
>> Introduce scsi_status_is_check_condition() and
> 
> That was added in the last patch, wasn't it?
> 
Yeah, already fixed up.

>> +++ b/block/bsg.c
>> @@ -97,6 +97,8 @@ static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
>>   	hdr->device_status = sreq->result & 0xff;
>>   	hdr->transport_status = host_byte(sreq->result);
>>   	hdr->driver_status = driver_byte(sreq->result);
>> +	if (scsi_status_is_check_condition(sreq->result))
>> +		hdr->driver_status |= DRIVER_SENSE;
> 
> I think hdr->driver_status also needs to be cleared to 0 first.  A little
> comment on the history would be nice as well.
> 
That will happen one of the later patches when we drop the 
'driver_byte()' macro completely.

And I've added to explanation to the sg header file.

>> @@ -257,6 +257,8 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
>>   	hdr->msg_status = msg_byte(req->result);
>>   	hdr->host_status = host_byte(req->result);
>>   	hdr->driver_status = driver_byte(req->result);
>> +	if (hdr->status == SAM_STAT_CHECK_CONDITION)
>> +		hdr->driver_status |= DRIVER_SENSE;
> 
> Same here.  Also why the open coded check in one please and the
> SAM_STAT_CHECK_CONDITION comparism in another?
> 
> Maybe we need a little helper instead of duplicating the logic?
> 
Check condition is cleaned up, and the clearing of the driver_byte value 
will happen one of the later patches.

>> +			} else
>> +				hp->driver_status |= DRIVER_SENSE;
> 
> Shouldn't this be where the previous driver_byte call was?  And
> maybe also use a proper helper?
> 
I'm not sure if we need a helper here; all other call sites dealing with 
the SG header do it directly, and the driver_status setting will be 
changed later on again.

>> @@ -131,6 +131,8 @@ struct compat_sg_io_hdr {
>>   #define SG_INFO_DIRECT_IO 0x2   /* direct IO requested and performed */
>>   #define SG_INFO_MIXED_IO 0x4    /* part direct, part indirect IO */
>>   
>> +/* Obsolete DRIVER_SENSE setting */
>> +#define DRIVER_SENSE 0x08
> 
> I think this needs a better documentation on what it means and why it
> is obsolete.
> 
Yes, will be doing so.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
