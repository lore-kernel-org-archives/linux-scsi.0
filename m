Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF948C7EE23
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 10:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjFEKlD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 06:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjFEKlC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 06:41:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DCBA6;
        Mon,  5 Jun 2023 03:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49CDE61DCF;
        Mon,  5 Jun 2023 10:41:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B5BDC433D2;
        Mon,  5 Jun 2023 10:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685961660;
        bh=rZ7C9whXt2XlheKQaFftWtVJILVgQ+PfynL3tO3Mdtc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=rojEmKojzTHqxT2o/r5mhJ+Vz3lK2iESY+HUAm0d8iU0mdNB9LLZ09ZG8+6WbZk6a
         YNBpPlnpfTbcrQTYpEJ/Z/QRdPkSchHYXmZMFRLVmpBihc9NPvBAutsaAQ+Xm3c+0m
         kDKrepD3gxRsMK/1EEC+BJkRUV/EMZcRjtsWsvuemD2f9xGEIrJfeDUZlv6ECqcogl
         lNQ4AtGiPkjzYplWAC9AQpBUNKiIlMOZqYzeHAi8k8dujh5J+K66nDS/zHs0KlAlz+
         E/3cULc38ajL3i1xVGUVHIBOCtY1pwUmapcEcnj8X9qDDaOi0uFdq8cmc+aHqGEom6
         8zvwiZ2P/a94w==
Message-ID: <edd27331-dabb-47e5-0043-a8219833df9e@kernel.org>
Date:   Mon, 5 Jun 2023 19:40:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 1/3] ata: libata-sata: Improve ata_change_queue_depth()
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jason Yan <yanaijie@huawei.com>
References: <20230605013212.573489-1-dlemoal@kernel.org>
 <20230605013212.573489-2-dlemoal@kernel.org>
 <0b1a036c-d71b-3c6c-56b0-67a7ced0834e@oracle.com>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <0b1a036c-d71b-3c6c-56b0-67a7ced0834e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/23 18:58, John Garry wrote:
> On 05/06/2023 02:32, Damien Le Moal wrote:
>> ata_change_queue_depth() implements different behaviors for ATA devices
>> managed by libsas than for those managed by libata directly.
>> Specifically, if a user attempts to set a device queue depth to a value
>> larger than 32 (ATA_MAX_QUEUE), the queue depth is capped to the maximum
>> and set to 32 for libsas managed devices whereas for libata managed
>> devices, the queue depth is unchanged and an error returned to the user.
>> This is due to the fact that for libsas devices, sdev->host->can_queue
>> may indicate the host (HBA) maximum number of commands that can be
>> queued rather than the device maximum queue depth.
>>
>> Change ata_change_queue_depth() to provide a consistent behavior for all
>> devices by changing the queue depth capping code to a check that the
>> user provided value does not exceed the device maximum queue depth.
>> This check is moved before the code clearing or setting the
>> ATA_DFLAG_NCQ_OFF flag to ensure that this flag is not modified when an
>> invlaid queue depth is provided.
>>
>> While at it, two other small improvements are added:
>> 1) Use ata_ncq_supported() instead of ata_ncq_enabled() and clear the
>>     ATA_DFLAG_NCQ_OFF flag only and only if needed.
>> 2) If the user provided queue depth is equal to the current queue depth,
>>     do not return an error as that is useless.
>>
>> Overall, the behavior of ata_change_queue_depth() for libata managed
>> devices is unchanged. The behavior with libsas managed devices becomes
>> consistent with libata managed devices.
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> 
> I have some nitpicks below. Regardless of those:
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
> Thanks!!
> 
>> ---
>>   drivers/ata/libata-sata.c | 25 +++++++++++++++----------
>>   1 file changed, 15 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
>> index e3c9cb617048..56a1cd57a107 100644
>> --- a/drivers/ata/libata-sata.c
>> +++ b/drivers/ata/libata-sata.c
>> @@ -1035,6 +1035,7 @@ int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
>>   {
>>   	struct ata_device *dev;
>>   	unsigned long flags;
>> +	int max_queue_depth;
>>   
>>   	spin_lock_irqsave(ap->lock, flags);
>>   
>> @@ -1044,22 +1045,26 @@ int ata_change_queue_depth(struct ata_port *ap, struct scsi_device *sdev,
>>   		return sdev->queue_depth;
>>   	}
>>   
>> -	/* NCQ enabled? */
>> -	dev->flags &= ~ATA_DFLAG_NCQ_OFF;
>> -	if (queue_depth == 1 || !ata_ncq_enabled(dev)) {
>> +	/* limit queue depth */
>> +	max_queue_depth = min(ATA_MAX_QUEUE, sdev->host->can_queue);
>> +	max_queue_depth = min(max_queue_depth, ata_id_queue_depth(dev->id));
>> +	if (queue_depth > max_queue_depth) {
>> +		spin_unlock_irqrestore(ap->lock, flags);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* NCQ supported ? */
> 
> nit: I find this comment so vague that it is ambiguous. The previous 
> code had it. What exactly are we trying to say?

I will detail this.

> 
>> +	if (queue_depth == 1 || !ata_ncq_supported(dev)) {
>>   		dev->flags |= ATA_DFLAG_NCQ_OFF;
> 
> super nit: I don't like checking a value and then setting it to the same 
> pass if the check passes, so ...
> 
>>   		queue_depth = 1;
>> +	} else {
>> +		dev->flags &= ~ATA_DFLAG_NCQ_OFF;
>>   	}
>>   
> 
> .. we could have instead:
> 
> if (queue_depth == 1)
> 	dev->flags |= ATA_DFLAG_NCQ_OFF;
> else if (!ata_ncq_supported(dev)) {
> 	dev->flags |= ATA_DFLAG_NCQ_OFF;
> 	queue_depth = 1;
> } else
> 	dev->flags &= ~ATA_DFLAG_NCQ_OFF;
> 	
> Maybe too long-winded.

Yes, that makes the code self-explanatory but is indeed a bit verbose. I will
improve the comment instead.

-- 
Damien Le Moal
Western Digital Research

