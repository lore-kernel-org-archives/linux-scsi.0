Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0317EC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 07:52:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1439208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 07:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgE1Hwm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 03:52:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:46136 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgE1Hwm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 May 2020 03:52:42 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2E63FABE2;
        Thu, 28 May 2020 07:52:43 +0000 (UTC)
Subject: Re: [PATCH 1/4] scsi: convert target lookup to xarray
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200527141400.58087-1-hare@suse.de>
 <20200527141400.58087-2-hare@suse.de>
 <20200528072409.s6jqoaty2zvks7ei@beryllium.lan>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <efd9850d-936a-f7fa-3dbf-cc27a56c8108@suse.de>
Date:   Thu, 28 May 2020 09:52:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528072409.s6jqoaty2zvks7ei@beryllium.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/28/20 9:24 AM, Daniel Wagner wrote:
> On Wed, May 27, 2020 at 04:13:57PM +0200, Hannes Reinecke wrote:
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1512,15 +1512,19 @@ void scsi_remove_target(struct device *dev)
>>   {
>>   	struct Scsi_Host *shost = dev_to_shost(dev->parent);
>>   	struct scsi_target *starget;
>> +	unsigned long tid = 0;
>>   	unsigned long flags;
>>   
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
> 
> Is there a special reason why don't use xa_for_each to iterate through all
> entries?
> 
This entire function is completely daft.
It says 'scsi_remove_target()', but for some weird reason fails to pass 
in the target it want to delete, so it has to go round in circles trying 
to figure out which target to delete.
There probably had been an obscure reason for this, but with the current 
code it's just pointless.
So that's the next thing to fix (after all of this): use a struct 
scsi_target as argument for this function, then this entire loop can go.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
