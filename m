Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B135C7EE23
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 09:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbjFEJ63 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Jun 2023 05:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231228AbjFEJ61 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2023 05:58:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE81CB0;
        Mon,  5 Jun 2023 02:58:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D2E661369;
        Mon,  5 Jun 2023 09:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094CBC433EF;
        Mon,  5 Jun 2023 09:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685959105;
        bh=vTrw0B44JCtUsZgtO2fYSD2nbbOrPHi6og5detWPDaw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kFpjhJV3W3XiTI1NSbVS2UTejEv/kdJMX7GsXU6/ern+2twejdKK3vxZ+hSORwpAk
         C/+HCisqBdUyI4E4PXbnWnSlozkxnTcDrLyt5WIdar7aCCYpunUVsMEe9X/FJh6Bcr
         WDZ3yPqLf8YZuwXOl00fndaOqvIBvHBdTX319d1NtdSAPKdSBnNZ0nV/6P/174CIQM
         PQoLI/0JjiKCxj6AkgwaBH9O216GSSS1VrS4ho7kbmsjUOwwiiAwuM/ReZ7Yx5ABYy
         plc4Ufjbu20jAzdJ3agWAN7EEqR+CvZw7kO4pIx2NztGmgM1ezgkt5Fhoalth21669
         GTepoGtt37jmg==
Message-ID: <da338f49-d614-f75b-fe84-4f59acface36@kernel.org>
Date:   Mon, 5 Jun 2023 18:58:24 +0900
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
 <ebbf146b-d9b7-c870-9894-bfdf8268d768@kernel.org>
 <4cd15610-1381-3fc6-2475-0831a50bf72d@suse.de>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <4cd15610-1381-3fc6-2475-0831a50bf72d@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/5/23 18:46, Hannes Reinecke wrote:
> On 6/5/23 11:37, Damien Le Moal wrote:
>> On 6/5/23 17:04, Hannes Reinecke wrote:
>>> On 6/5/23 03:32, Damien Le Moal wrote:
>>>> In ata_scsi_dev_config(), instead of hardconing the test to check if
>>>> an ATA device supports NCQ by looking at the ATA_DFLAG_NCQ flag, use
>>>> ata_ncq_supported().
>>>>
>>>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>>>> ---
>>>>    drivers/ata/libata-scsi.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>>>> index 8ce90284eb34..22e2e9ab6b60 100644
>>>> --- a/drivers/ata/libata-scsi.c
>>>> +++ b/drivers/ata/libata-scsi.c
>>>> @@ -1122,7 +1122,7 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
>>>>    	if (dev->flags & ATA_DFLAG_AN)
>>>>    		set_bit(SDEV_EVT_MEDIA_CHANGE, sdev->supported_events);
>>>>    
>>>> -	if (dev->flags & ATA_DFLAG_NCQ)
>>>> +	if (ata_ncq_supported(dev))
>>>>    		depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
>>>>    	depth = min(ATA_MAX_QUEUE, depth);
>>>>    	scsi_change_queue_depth(sdev, depth);
>>>
>>> Argh. ATA NCQ flags. We have ATA_DFLAG_NCQ, ATA_DFLAG_PIO,
>>> ATA_DFLAG_NCQ_OFF (and maybe even more which I forgot about).
>>> Can we please move them into some more descriptive, ie which flags
>>> are for the drive capabilities (ie _can_ the drive do NCQ) and
>>> the current current drive status (ie _does_ the drive do NCQ)?
>>> As it stands it's quite confusing.
>>
>> In include/linux/libata.h, we have:
>>
>> ATA_DFLAG_NCQ		= (1 << 3), /* device supports NCQ */
>> ATA_DFLAG_PIO		= (1 << 13), /* device limited to PIO mode */
>> ATA_DFLAG_NCQ_OFF	= (1 << 14), /* device limited to non-NCQ mode */
>>
>> So there are some description. Not enough ?
>>
> Well. Guess my point is that ATA_DFLAG_PIO is a device status (which 
> might change during runtime), whereas ATA_DFLAG_NCQ is a device setting
> (either it does or does not support NCQ).
> And ATA_DFLAG_NCQ_OFF is again a device status (device supports NCQ, but
> it's disabled for whatever reason).
> I'd rather have a more descriptive naming like
> ATA_DFLAG_NCQ_SUPPORTED
> to clearly indicate that this flag is not about what the driver 
> _currently_ is using (as opposed to ATA_DFLAG_PIO), but rather a static
> device configuration which won't change whatever I do.

Yes, agree.

There is also some funky logic going on with all this:
ATA_DFLAG_PIO meaning "PIO supported" should always be set for NCQ drives,
because NCQ drives necessarily can do DMA and so they can do PIO as well...
So patterns like:

dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ |
		ATA_DFLAG_NCQ_OFF)) == ATA_DFLAG_NCQ

To test if NCQ is supported does not really make any sense... Example:
ata_scsi_security_inout_xlat() has:

bool dma = !(qc->dev->flags & ATA_DFLAG_PIO);

Sure... That works, but that is not technically super correct has a DMA capable
drive can do PIO as well.

I think we are dealing with ata history here as everything was "PIO" at the
beginning of ata times, so that flag did not really needed to exist and was
added later to differentiate with NCQ case.

Splitting the gigantic enum in include/linux/libata.h into manageable pieces
(e.g. "enum ata_device_flags { ... };") with some renaming and better kdocs
would help clarifies things. Will try to work on that.

-- 
Damien Le Moal
Western Digital Research

