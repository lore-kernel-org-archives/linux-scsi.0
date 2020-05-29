Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75350C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 06:24:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C271208E4
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 06:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgE2GYR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 02:24:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:41278 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbgE2GYQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 02:24:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id AE4A6ABF4;
        Fri, 29 May 2020 06:24:14 +0000 (UTC)
Subject: Re: [PATCH 1/4] scsi: convert target lookup to xarray
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200528163625.110184-1-hare@suse.de>
 <20200528163625.110184-2-hare@suse.de>
 <8a9b4a1f-9408-0920-75fc-6df146ea95c2@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <c9b19838-b8be-607d-f1ce-2c74f6de6ffa@suse.de>
Date:   Fri, 29 May 2020 08:24:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <8a9b4a1f-9408-0920-75fc-6df146ea95c2@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/28/20 7:48 PM, Bart Van Assche wrote:
> On 2020-05-28 09:36, Hannes Reinecke wrote:
>> +#define scsi_target_index(s) \
>> +	((((unsigned long)(s)->channel) << 16) | (s)->id)
> 
> Please define scsi_target_index() as an inline function instead of a macro.
> 
>> +	if (xa_insert(&shost->__targets, tid, starget, GFP_KERNEL)) {
>> +		dev_printk(KERN_ERR, dev, "target index busy\n");
>> +		kfree(starget);
>> +		return NULL;
>> +	}
> 
> So the above code passes GFP_KERNEL to xa_insert() while holding a
> spinlock? That doesn't seem correct to me. Since xa_insert() provides
> locking itself, can the spin_lock_irqsave(shost->host_lock, flags) /
> spin_unlock_irqrestore(shost->host_lock, flags) pair be removed and can
> the xa_load() and xa_insert() calls be combined into a single
> xa_insert() call? I think xa_insert() returns -EBUSY if an entry already
> exists.
> 
>> -restart:
>>   	spin_lock_irqsave(shost->host_lock, flags);
>> -	list_for_each_entry(starget, &shost->__targets, siblings) {
>> +	starget = xa_find(&shost->__targets, &tid, ULONG_MAX, XA_PRESENT);
>> +	while (starget) {
>>   		if (starget->state == STARGET_DEL ||
>>   		    starget->state == STARGET_REMOVE ||
>> -		    starget->state == STARGET_CREATED_REMOVE)
>> +		    starget->state == STARGET_CREATED_REMOVE) {
>> +			starget = xa_find_after(&shost->__targets, &tid,
>> +						ULONG_MAX, XA_PRESENT);
>>   			continue;
>> +		}
>>   		if (starget->dev.parent == dev || &starget->dev == dev) {
>>   			kref_get(&starget->reap_ref);
>>   			if (starget->state == STARGET_CREATED)
>> @@ -1530,7 +1534,10 @@ void scsi_remove_target(struct device *dev)
>>   			spin_unlock_irqrestore(shost->host_lock, flags);
>>   			__scsi_remove_target(starget);
>>   			scsi_target_reap(starget);
>> -			goto restart;
>> +			spin_lock_irqsave(shost->host_lock, flags);
>> +			starget = xa_find_after(&shost->__targets, &tid,
>> +						ULONG_MAX, XA_PRESENT);
>> +			continue;
>>   		}
>>   	}
> 
> How about using a for loop instead of a while loop such that the
> xa_find_after() statement does not have to be duplicated?
> 
Ok, will do for the next round.

Cheers,

Hannes
