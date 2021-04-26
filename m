Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C390DC433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 07:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 952FF60E0C
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 07:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbhDZHDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Apr 2021 03:03:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:36458 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231816AbhDZHDM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Apr 2021 03:03:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5E086B00D;
        Mon, 26 Apr 2021 07:02:30 +0000 (UTC)
Subject: Re: [PATCH 08/39] scsi: Kill DRIVER_SENSE
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-9-hare@suse.de>
 <f7c35ab2-bfca-99e1-54d3-d869957f134d@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <69d50158-1fb9-654f-bf47-6ac5049ff6d6@suse.de>
Date:   Mon, 26 Apr 2021 09:02:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <f7c35ab2-bfca-99e1-54d3-d869957f134d@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/26/21 5:41 AM, Bart Van Assche wrote:
> On 4/23/21 4:39 AM, Hannes Reinecke wrote:
>> Introduce scsi_status_is_check_condition()
> 
> Wasn't that macro introduced by patch 07/39?
> 
Sheesh.
Left-over from patch separation.
Will be fixing it up.

>> For backwards compability move the DRIVER_SENSE definition
>                 ^^^^^^^^^^^
>                   typo?
> 
Yep.

>> diff --git a/block/bsg.c b/block/bsg.c
>> index bd10922d5cbb..a70bb25ab906 100644
>> --- a/block/bsg.c
>> +++ b/block/bsg.c
>> @@ -97,6 +97,8 @@ static int bsg_scsi_complete_rq(struct request *rq, struct sg_io_v4 *hdr)
>>  	hdr->device_status = sreq->result & 0xff;
>>  	hdr->transport_status = host_byte(sreq->result);
>>  	hdr->driver_status = driver_byte(sreq->result);
>> +	if (scsi_status_is_check_condition(sreq->result))
>> +		hdr->driver_status |= DRIVER_SENSE;
> 
> If another value is already present in the driver_byte(), will |=
> DRIVER_SENSE corrupt that value?
> 
Yes, and no.
It would corrupt it if there _were_ another value.
But the whole point of this patchset is that there _is_ no value in the
driver_byte field.
And we're just fudging in that one parameter (DRIVER_SENSE) which
actually has a meaning and (occasionally) is evaluated in user-space.

>> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
>> index 99d58786e0d5..e59e1f70f3a5 100644
>> --- a/block/scsi_ioctl.c
>> +++ b/block/scsi_ioctl.c
>> @@ -257,6 +257,8 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
>>  	hdr->msg_status = msg_byte(req->result);
>>  	hdr->host_status = host_byte(req->result);
>>  	hdr->driver_status = driver_byte(req->result);
>> +	if (hdr->status == SAM_STAT_CHECK_CONDITION)
>> +		hdr->driver_status |= DRIVER_SENSE;
> 
> Same here: since "driver_status" is not a bitfield, "|=" seems
> conceptually wrong to me.
> 
That, on the other hand, is correct.
Will be fixing it up.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
