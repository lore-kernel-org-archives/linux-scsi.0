Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125FAC7EE23
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 09:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbjFEJqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 05:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjFEJqs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 05:46:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0261DBD;
        Mon,  5 Jun 2023 02:46:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id ADD981F8B6;
        Mon,  5 Jun 2023 09:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1685958405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ubKOukbr9YW/atZbTLt0IyYcQSecDrJZJbRBvrQsVFY=;
        b=iwNM3b9SELFTt3Pxqp0kaFuOXab6jTeRjdqz7TxwPCc/2oLE5Lz5ise2BjBRCCdXUU06Gx
        M9+xu6Ye8Kr1wIxUNXigsEM8mzDV38jUucCm3kdpniE0G4F+rEcwXksrQmMvNmkWrbSQN3
        uELruG/SNcaYX1VWOe+5ED4Ft3ae+RY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1685958405;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ubKOukbr9YW/atZbTLt0IyYcQSecDrJZJbRBvrQsVFY=;
        b=08i6Da/iPgkIYX1JpuNA3qmJ7CYCtgzcKUsJzkReLg2NlVA3bCCUzUat+JbZaDXj0uwMom
        kkzYi+Vl37zzpcCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9216C139C7;
        Mon,  5 Jun 2023 09:46:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 1x5bIwWvfWTJMgAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 05 Jun 2023 09:46:45 +0000
Message-ID: <4cd15610-1381-3fc6-2475-0831a50bf72d@suse.de>
Date:   Mon, 5 Jun 2023 11:46:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 3/3] ata: libata-scsi: Use ata_ncq_supported in
 ata_scsi_dev_config()
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     John Garry <john.g.garry@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20230605013212.573489-1-dlemoal@kernel.org>
 <20230605013212.573489-4-dlemoal@kernel.org>
 <801bad24-7423-225a-52ec-177df0da0006@suse.de>
 <ebbf146b-d9b7-c870-9894-bfdf8268d768@kernel.org>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <ebbf146b-d9b7-c870-9894-bfdf8268d768@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/23 11:37, Damien Le Moal wrote:
> On 6/5/23 17:04, Hannes Reinecke wrote:
>> On 6/5/23 03:32, Damien Le Moal wrote:
>>> In ata_scsi_dev_config(), instead of hardconing the test to check if
>>> an ATA device supports NCQ by looking at the ATA_DFLAG_NCQ flag, use
>>> ata_ncq_supported().
>>>
>>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>>> ---
>>>    drivers/ata/libata-scsi.c | 2 +-
>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>>> index 8ce90284eb34..22e2e9ab6b60 100644
>>> --- a/drivers/ata/libata-scsi.c
>>> +++ b/drivers/ata/libata-scsi.c
>>> @@ -1122,7 +1122,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>>>    	if (dev->flags & ATA_DFLAG_AN)
>>>    		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
>>>    
>>> -	if (dev->flags & ATA_DFLAG_NCQ)
>>> +	if (ata_ncq_supported(dev))
>>>    		depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
>>>    	depth = min(ATA_MAX_QUEUE, depth);
>>>    	scsi_change_queue_depth(sdev, depth);
>>
>> Argh. ATA NCQ flags. We have ATA_DFLAG_NCQ, ATA_DFLAG_PIO,
>> ATA_DFLAG_NCQ_OFF (and maybe even more which I forgot about).
>> Can we please move them into some more descriptive, ie which flags
>> are for the drive capabilities (ie _can_ the drive do NCQ) and
>> the current current drive status (ie _does_ the drive do NCQ)?
>> As it stands it's quite confusing.
> 
> In include/linux/libata.h, we have:
> 
> ATA_DFLAG_NCQ		= (1 << 3), /* device supports NCQ */
> ATA_DFLAG_PIO		= (1 << 13), /* device limited to PIO mode */
> ATA_DFLAG_NCQ_OFF	= (1 << 14), /* device limited to non-NCQ mode */
> 
> So there are some description. Not enough ?
> 
Well. Guess my point is that ATA_DFLAG_PIO is a device status (which 
might change during runtime), whereas ATA_DFLAG_NCQ is a device setting
(either it does or does not support NCQ).
And ATA_DFLAG_NCQ_OFF is again a device status (device supports NCQ, but
it's disabled for whatever reason).
I'd rather have a more descriptive naming like
ATA_DFLAG_NCQ_SUPPORTED
to clearly indicate that this flag is not about what the driver 
_currently_ is using (as opposed to ATA_DFLAG_PIO), but rather a static
device configuration which won't change whatever I do.

Cheers,

Hannes

