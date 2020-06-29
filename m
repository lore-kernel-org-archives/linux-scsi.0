Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2A0C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F41A6206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 19:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbgF2TMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:12:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:53588 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731052AbgF2TLY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 29 Jun 2020 15:11:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BC0CFAC91;
        Mon, 29 Jun 2020 14:51:46 +0000 (UTC)
Subject: Re: [PATCH 21/22] aacraid: use scsi_get_internal_cmd()
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200629072021.9864-1-hare@suse.de>
 <20200629072021.9864-22-hare@suse.de>
 <d3ddc77d-11d9-f5ac-784e-af1f75bd5982@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bed45604-adc2-a2bf-8039-c23dddd89fdb@suse.de>
Date:   Mon, 29 Jun 2020 16:51:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <d3ddc77d-11d9-f5ac-784e-af1f75bd5982@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/20 3:08 PM, John Garry wrote:
> 
>>       return fibptr;
>>   }
>> @@ -240,36 +231,28 @@ struct fib *aac_fib_alloc_tag(struct aac_dev 
>> *dev, struct scsi_cmnd *scmd)
>>   /**
>>    *    aac_fib_alloc    -    allocate a fib
>>    *    @dev: Adapter to allocate the fib for
>> + *    @direction: DMA data direction
>>    *
>>    *    Allocate a fib from the adapter fib pool. If the pool is empty we
>>    *    return NULL.
>>    */
>> -struct fib *aac_fib_alloc(struct aac_dev *dev)
>> +struct fib *aac_fib_alloc(struct aac_dev *dev, int direction)
>>   {
>> -    struct fib * fibptr;
>> +    struct scsi_cmnd *scmd;
>> +    struct fib * fibptr = NULL;
>>       unsigned long flags;
>> +
>>       spin_lock_irqsave(&dev->fib_lock, flags);
> 
> Do you still require this spinlock'ing?
> 
No, indeed not. Will be removing them.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
