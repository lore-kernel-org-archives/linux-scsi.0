Received: from nick.sneptech.io (nick.sneptech.io [178.62.38.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B981898FB;
	Wed, 10 Jun 2026 23:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.62.38.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781133302; cv=none; b=f01jZ3g08FEbGxq+PyOnFwkQLESgSJF3yAI+3zAZbkNp/ow7DtMdBU0JYPiK1yQ5ZhNmORLPk4DB8dSSAsOGow9zsMYmMlCLii9fu7/KjedprwabyDSptUOYpcporNjlpCx/T21n5NXs6LlDAktJzi5/pBzQ825+8AeSUgwfPBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781133302; c=relaxed/simple;
	bh=xNqp3F06cc7JZH9jxh1e9z2CzOS8Du+Ssxjazr0E+B0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kwpdunVg0IIsfnO1I/WY1p9whOIl7q7DO5VbnYQ7BTn12+7kwYKGxspd0Ybe5eIJSiS8oHgB3/8lqhZu7xnUMZEnWn8VNbIvTnB4WSLe1D+06Dx7iuClJCrgMe6IDdHgSp595bVf1P2V7EccIwGiKxYzohOYmXV+jq4DhLmC/zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk; spf=pass smtp.mailfrom=philpem.me.uk; dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b=TQrw9S6k; arc=none smtp.client-ip=178.62.38.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=philpem.me.uk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=philpem.me.uk header.i=@philpem.me.uk header.b="TQrw9S6k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=philpem.me.uk;
	s=mail; t=1781133292;
	bh=xNqp3F06cc7JZH9jxh1e9z2CzOS8Du+Ssxjazr0E+B0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TQrw9S6k5LXNFKAI03li+GvBR+ZDTS0iSSU385Dn93Zow1T74/VQmo3/oY8hIOFHj
	 KH/mR+zGMNLVOYraNLq14wJYgCTyI4pgKERD8xuQyckNrGjC0KJd4nNPZLA1BBdbMS
	 r6pLgzmipu2QoSjBUfqFKZKjWfPi0j/lu/yBdLM0=
Received: from wolf.philpem.me.uk (81-187-163-148.ip4.reverse-dns.uk [81.187.163.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	(Authenticated sender: mailrelay_wolf@philpem.me.uk)
	by nick.sneptech.io (Postfix) with ESMTPSA id 83669BD70C;
	Wed, 10 Jun 2026 23:14:52 +0000 (UTC)
Received: from [10.0.0.32] (cheetah.homenet.philpem.me.uk [10.0.0.32])
	by wolf.philpem.me.uk (Postfix) with ESMTPSA id 41E3A5FC0E;
	Thu, 11 Jun 2026 00:14:52 +0100 (BST)
Message-ID: <224f25e2-fd31-4c78-8cf4-0e1b016fad61@philpem.me.uk>
Date: Thu, 11 Jun 2026 00:14:52 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/6] ata: libata-scsi: convert dev->sdev to per-LUN
 array
To: Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260608213443.2296614-1-philpem@philpem.me.uk>
 <20260608213443.2296614-3-philpem@philpem.me.uk>
 <fb133176-358a-4908-85b0-a75edad582af@suse.de>
Content-Language: en-GB
From: Phil Pemberton <philpem@philpem.me.uk>
In-Reply-To: <fb133176-358a-4908-85b0-a75edad582af@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 09/06/2026 08:22, Hannes Reinecke wrote:
>> +            for (lun = dev->nr_luns - 1; lun >= 0; lun--) {
>> +                if (!dev->sdev[lun])
>> +                    continue;
>>                   spin_unlock_irqrestore(ap->lock, flags);
>> -                scsi_remove_device(dev->sdev);
>> +                scsi_remove_device(dev->sdev[lun]);
>>                   spin_lock_irqsave(ap->lock, flags);
>> -                dev->sdev = NULL;
>> +                dev->sdev[lun] = NULL;
> 
> As pointed out by sashiko, this is racy.
> Please move 'dev->sdev[lun] = NULL' before unlock, and hold
> 'sdev' in a temporary variable.
> 
> Maybe even make this a separate patch, then this patch can be kept
> as just the interface change.

The race was introduced by the patch itself and only exists because v6 
got the NULL placement wrong. I think splitting it out would leave patch 
2 transiently broken, which would make bisecting harder not easier.

IMHO a series where every commit is correct is more useful than one with 
a known unfixed bug. The fix is only 3 lines and I've kept it in patch 2 
where the cause and correction sit near each other and are easy to review.

I'm happy to split it if you feel strongly about it - or was this 
thinking out loud?

>> -        scsi_remove_device(sdev);
>> -        scsi_device_put(sdev);
>> +                 dev_name(&sdevs[lun]->sdev_gendev));
>> +        scsi_remove_device(sdevs[lun]);
>> +        scsi_device_put(sdevs[lun]);
>  >       }>   }
> Wouldn't it be simpler to have another mutex under 'dev' to protect
> 'dev->sdev[]' ?
> That would get us out of this mess, and we could do away with the
> temporary adev array.

I looked at that, but dev->sdev[] is also accessed from IRQ context: 
ata_scsi_media_change_notify runs under ap->lock with IRQs disabled, and 
so does ata_scsi_offline_dev. A mutex would only protect sleepable 
paths, leaving the IRQ paths unprotected. That feels worse to me than 
the current consistent use of ap->lock for all accesses.

The snapshot approach in ata_scsi_remove_dev is boilerplate but it is 
correct.

If you think a mutex-based redesign is the way to go, I'm happy to look 
at it as a follow-up.


>> @@ -4872,9 +4872,12 @@ static void ata_scsi_handle_link_detach(struct 
>> ata_link *link)
>>    */
>>   void ata_scsi_media_change_notify(struct ata_device *dev)
>>   {
>> -    if (dev->sdev)
>> -        sdev_evt_send_simple(dev->sdev, SDEV_EVT_MEDIA_CHANGE,
>> -                     GFP_ATOMIC);
>> +    int lun;
>> +
>> +    for (lun = 0; lun < dev->nr_luns; lun++)
>> +        if (dev->sdev[lun])
>> +            sdev_evt_send_simple(dev->sdev[lun],
>> +                         SDEV_EVT_MEDIA_CHANGE, GFP_ATOMIC);
>>   }
> 
> I guess the iteration need to be protected somehow, either by
> taking 'ap->lock' or with the dedicated mutex from the above
> comments.

Both call sites are inside sata_async_notification(). That's documented 
as "LOCKING: spin_lock_irqsave(host lock)", so ap->lock is already held 
and the iteration is protected - QED.


>> diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
>> index 414e7c63bd85..dca774d8ec05 100644
>> --- a/drivers/ata/libata-zpodd.c
>> +++ b/drivers/ata/libata-zpodd.c
>> @@ -185,7 +185,7 @@ void zpodd_enable_run_wake(struct ata_device *dev)
>>   {
>>       struct zpodd *zpodd = dev->zpodd;
>> -    sdev_disable_disk_events(dev->sdev);
>> +    sdev_disable_disk_events(ata_dev_scsi_device(dev, 0));
> 
> I _think_  we should call this for every LUN.

Done in v7, all three ZPODD functions (enable_run_wake, post_poweron, 
wake_dev) iterate over all LUN slots.


Thanks,
-- 
Phil.
philpem@philpem.me.uk
https://www.philpem.me.uk/
