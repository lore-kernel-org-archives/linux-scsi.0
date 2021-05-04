Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33816C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 06:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F366D613AA
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 06:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbhEDGRb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 02:17:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:43110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229770AbhEDGRb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 02:17:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 728D4ACF6;
        Tue,  4 May 2021 06:16:36 +0000 (UTC)
Subject: Re: [PATCH 08/18] snic: use reserved commands
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-9-hare@suse.de>
 <c99e0b3c-ba06-db4b-1405-2b8ecbba9eab@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <511e9750-3f07-b3ac-ccbd-56049e48026c@suse.de>
Date:   Tue, 4 May 2021 08:16:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <c99e0b3c-ba06-db4b-1405-2b8ecbba9eab@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/4/21 5:12 AM, Bart Van Assche wrote:
> On 5/3/21 8:03 AM, Hannes Reinecke wrote:
>> @@ -2170,42 +2144,42 @@ snic_device_reset(struct scsi_cmnd *sc)
>>   		goto dev_rst_end;
>>   	}
>>   
>> -	/* There is no tag when lun reset is issue through ioctl. */
>> -	if (unlikely(tag <= SNIC_NO_TAG)) {
>> -		SNIC_HOST_INFO(snic->shost,
>> -			       "Devrst: LUN Reset Recvd thru IOCTL.\n");
>> +	reset_sc = scsi_get_internal_cmd(sc->device, REQ_OP_SCSI_IN,
>> +					 BLK_MQ_REQ_NOWAIT);
>> +	if (!reset_sc)
>> +		goto dev_rst_end;
> 
> The SCSI error handler may call .eh_device_reset_handler and other error
> handling callbacks if no tags are available. If no tags are available,
> scsi_get_internal_cmd() will fail. If scsi_get_internal_cmd() fails,
> snic_device_reset() will fail. Does that count as a regression?
> 
The snic driver _requires_ a free tag to send a reset.
If no free tags are available the driver cannot send a reset, even in 
the old code.
So no, this is not a regression.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
