Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A91EC3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 08:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 31DFA21582
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 08:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgEBIqe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 04:46:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:56082 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbgEBIqe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 May 2020 04:46:34 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 12157AC51;
        Sat,  2 May 2020 08:46:33 +0000 (UTC)
Subject: Re: [PATCH RFC v3 03/41] scsi: Implement scsi_cmd_is_reserved()
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-4-hare@suse.de> <20200501174345.GB23795@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <3f56e242-7258-2660-f510-16a12518efc1@suse.de>
Date:   Sat, 2 May 2020 10:46:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501174345.GB23795@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 7:43 PM, Christoph Hellwig wrote:
> On Thu, Apr 30, 2020 at 03:18:26PM +0200, Hannes Reinecke wrote:
>> Add function to check if a SCSI command originates from the reserved
>> tag pool and update scsi_put_reserved_cmd() to only free commands if
>> they originate from the reserved tag pool.
> 
> The SCSI bits should go into the previous patch.  The block layer
> bits should be a separate prep patch before that.
> 
Okay.

>> +/**
>> + * blk_mq_rq_is_reserved - Check for reserved request
>> + *
>> + * @rq: Request to check
> 
> No empty line before the parameter description, please.
> 
Okay

>>    */
>>   void scsi_put_reserved_cmd(struct scsi_cmnd *scmd)
>>   {
>> +	struct request *rq;
>>   
>> +	if (scmd && scsi_cmd_is_reserved(scmd)) {
>> +		rq = blk_mq_rq_from_pdu(scmd);
>> +		blk_mq_free_request(rq);
>> +	}
> 
> The check looks weird.  Passing a NULL cmnd here seems like an API
> abuse to start with, and !scsi_cmd_is_reserved should at best be
> a WARN_ON_ONCE.
> 
> So I think this should just be something like:
> 
> void scsi_put_reserved_cmd(struct scsi_cmnd *scmd)
> {
> 	WARN_ON_ONCE(!scsi_cmd_is_reserved(scmd));
> 	blk_mq_free_request(blk_mq_rq_from_pdu(scmd));
> }
> 
Will do.

>> +/**
>> + * scsi_cmd_is_reserved - check for reserved scsi command
>> + * @scmd: command to check
>> + *
>> + * Returns true if @scmd originates from the reserved tag pool.
>> + */
>> +static inline bool scsi_cmd_is_reserved(struct scsi_cmnd *scmd)
>> +{
>> +	struct request *rq = blk_mq_rq_from_pdu(scmd);
>> +
>> +	return blk_mq_rq_is_reserved(rq);
> 
> Can be shortened to:
> 
> 	return blk_mq_rq_is_reserved(blk_mq_rq_from_pdu(scmd));
> 
Same here.

Will be updating the patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
