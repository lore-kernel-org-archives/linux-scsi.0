Return-Path: <SRS0=8UCH=7J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE7AC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 15:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FAE920899
	for <linux-scsi@archiver.kernel.org>; Wed, 27 May 2020 15:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389642AbgE0PG0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 May 2020 11:06:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:58010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389316AbgE0PG0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 May 2020 11:06:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 94EA8B16F;
        Wed, 27 May 2020 15:06:27 +0000 (UTC)
Subject: Re: [PATCH 1/4] scsi: convert target lookup to xarray
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Doug Gilbert <dgilbert@interlog.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20200527141400.58087-1-hare@suse.de>
 <20200527141400.58087-2-hare@suse.de>
 <SN4PR0401MB3598F8FE6B4221DE4881B7FA9BB10@SN4PR0401MB3598.namprd04.prod.outlook.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <67b9aa56-88d0-9f0d-9f32-d6752316e9ec@suse.de>
Date:   Wed, 27 May 2020 17:06:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <SN4PR0401MB3598F8FE6B4221DE4881B7FA9BB10@SN4PR0401MB3598.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/27/20 4:57 PM, Johannes Thumshirn wrote:
> On 27/05/2020 16:14, Hannes Reinecke wrote:
> [...]
>> @@ -670,8 +683,8 @@ EXPORT_SYMBOL(__scsi_device_lookup_by_target);
>>   struct scsi_device *scsi_device_lookup_by_target(struct scsi_target *starget,
>>   						 u64 lun)
>>   {
>> -	struct scsi_device *sdev;
>>   	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
>> +	struct scsi_device *sdev;
>>   	unsigned long flags;
> 
> This looks unrelated.
> 
>>   
>>   	spin_lock_irqsave(shost->host_lock, flags);
>> @@ -701,19 +714,19 @@ EXPORT_SYMBOL(scsi_device_lookup_by_target);
>>    * really want to use scsi_device_lookup instead.
>>    **/
>>   struct scsi_device *__scsi_device_lookup(struct Scsi_Host *shost,
>> -		uint channel, uint id, u64 lun)
>> +		u16 channel, u16 id, u64 lun)
>>   {
>> +	struct scsi_target *starget;
>>   	struct scsi_device *sdev;
>>   
>> -	list_for_each_entry(sdev, &shost->__devices, siblings) {
>> -		if (sdev->sdev_state == SDEV_DEL)
>> -			continue;
>> -		if (sdev->channel == channel && sdev->id == id &&
>> -				sdev->lun ==lun)
>> -			return sdev;
>> -	}
>> +	starget = __scsi_target_lookup(shost, channel, id);
>> +	if (!starget)
>> +		return NULL;
>> +	sdev = __scsi_device_lookup_by_target(starget, lun);
>> +	if (sdev && sdev->sdev_state == SDEV_DEL)
>> +		sdev = NULL;
>>   
> 
> I think the above if is unneeded as __scsi_device_lookup_by_target() does:
> 	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
> 		if (sdev->sdev_state == SDEV_DEL)
> 			continue;
> 
> So 'sdev != NULL && sdev->sdev_state == SDEV_DEL' would never evaluate to true,
> wouldn't it?
> 
Oh. indeed. So that can be simplified.
Will do for the next version.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
