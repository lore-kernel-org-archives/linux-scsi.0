Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26DA1C77B73
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 09:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjFEJh4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 05:37:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjFEJhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 05:37:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC40AB7;
        Mon,  5 Jun 2023 02:37:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7741060FF4;
        Mon,  5 Jun 2023 09:37:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A78AC433EF;
        Mon,  5 Jun 2023 09:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685957873;
        bh=gelQAYnpc30RXgHxxUKxWEgdFxKlZywiauPpxxil+zA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qrV8EJ8VLC3pub5dPqf7EfkfxwqOc8oELUZacpJcCjiO14W1M4AjYIgpfuwKBmIgK
         3veBnoVh/BaLSB7OmJXk8/VVHQv+GUmidBFIeUcGvCv5tiorSpvucS0PiFDqc0uTlM
         oyjcNx4a2aFy4KU2kfNkZmDBn9y29S3mx7YCMuudsnw8XwXUHADU3H6H7OJu83uFF4
         mLiK1BeJVZSuAmoJd7NymQ9vtL88hxylt2MH/x9i0d5RQOoO8UE+R42r+AS1Qy5Wl0
         /vb3DCB3RqaWwVTCSHrFhZ/CHottFv2wCvSSEBnf5vyCSzftC6vxqXIcx6uEr11WCX
         dEpvg180SSGYA==
Message-ID: <ebbf146b-d9b7-c870-9894-bfdf8268d768@kernel.org>
Date:   Mon, 5 Jun 2023 18:37:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 3/3] ata: libata-scsi: Use ata_ncq_supported in
 ata_scsi_dev_config()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20230605013212.573489-1-dlemoal@kernel.org>
 <20230605013212.573489-4-dlemoal@kernel.org>
 <801bad24-7423-225a-52ec-177df0da0006@suse.de>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <801bad24-7423-225a-52ec-177df0da0006@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/23 17:04, Hannes Reinecke wrote:
> On 6/5/23 03:32, Damien Le Moal wrote:
>> In ata_scsi_dev_config(), instead of hardconing the test to check if
>> an ATA device supports NCQ by looking at the ATA_DFLAG_NCQ flag, use
>> ata_ncq_supported().
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>   drivers/ata/libata-scsi.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 8ce90284eb34..22e2e9ab6b60 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -1122,7 +1122,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>>   	if (dev->flags & ATA_DFLAG_AN)
>>   		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
>>   
>> -	if (dev->flags & ATA_DFLAG_NCQ)
>> +	if (ata_ncq_supported(dev))
>>   		depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
>>   	depth = min(ATA_MAX_QUEUE, depth);
>>   	scsi_change_queue_depth(sdev, depth);
> 
> Argh. ATA NCQ flags. We have ATA_DFLAG_NCQ, ATA_DFLAG_PIO, 
> ATA_DFLAG_NCQ_OFF (and maybe even more which I forgot about).
> Can we please move them into some more descriptive, ie which flags
> are for the drive capabilities (ie _can_ the drive do NCQ) and
> the current current drive status (ie _does_ the drive do NCQ)?
> As it stands it's quite confusing.

In include/linux/libata.h, we have:

ATA_DFLAG_NCQ		= (1 << 3), /* device supports NCQ */
ATA_DFLAG_PIO		= (1 << 13), /* device limited to PIO mode */
ATA_DFLAG_NCQ_OFF	= (1 << 14), /* device limited to non-NCQ mode */

So there are some description. Not enough ?

> 
> But probably not a problem with this patch, so:
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> 
> Cheers,
> 
> Hannes

-- 
Damien Le Moal
Western Digital Research

