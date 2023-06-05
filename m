Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5009BC7EE2D
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Jun 2023 01:25:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjFEBZH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Jun 2023 21:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjFEBZG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jun 2023 21:25:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F075BC;
        Sun,  4 Jun 2023 18:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD2D561A2F;
        Mon,  5 Jun 2023 01:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BFF2C433EF;
        Mon,  5 Jun 2023 01:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685928304;
        bh=teqiMI7UUCVjK/7yI2f15PMQvhq/+yLenzwuvONpNwo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=h8PntbVBbNmfwqtBq+nUGUbecQvWZEv8Ce1b4iMeqFic2HcYumg5IY/uXreJH7aR8
         4A/cJ75kWI/4DelScV7z6WfvS0RKWAo8x4bri38hhSR4GlCQP+QBC7Xe3VU/61/MRT
         ealdsNfdD6x0E+muxYr/OcKg65AwW+cQD3A/mnhczp784RfPH/96G0j9AKQBOH0oPo
         UNINdRF/gONZopxzoL13m/tKwTPF8+V+oKZvsVSQMDevVxF3LSok+49TJpmQ6gml3U
         vwO7AxPCYfER8MDcMYW9J2p6eBoYiXh2Ub20WZsUQefqYBhLZusVRuAKW6d2qi0dav
         jLBucWZBcOKeQ==
Message-ID: <c7507777-a4ac-55f5-698c-bff33ab7038a@kernel.org>
Date:   Mon, 5 Jun 2023 10:25:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ata: libata-sata: Simplify ata_change_queue_depth()
To:     John Garry <john.g.garry@oracle.com>, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jason Yan <yanaijie@huawei.com>
References: <20230601222607.263024-1-dlemoal@kernel.org>
 <cdc68c52-4320-1820-028d-c0af9dfe38c1@oracle.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <cdc68c52-4320-1820-028d-c0af9dfe38c1@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/2/23 17:02, John Garry wrote:
> On 01/06/2023 23:26, Damien Le Moal wrote:
>> Commit 141f3d6256e5 ("ata: libata-sata: Fix device queue depth control")
>> added a struct ata_device argument to ata_change_queue_depth() to
>> address problems with changing the queue depth of ATA devices managed
>> through libsas. This was due to problems with ata_scsi_find_dev() which
>> are now fixed with commit 7f875850f20a ("ata: libata-scsi: Use correct
>> device no in ata_find_dev()").
>>
>> Undo some of the changes of commit 141f3d6256e5: remove the added struct
>> ata_device aregument and use again ata_scsi_find_dev() to find the
>> target ATA device structure. While doing this, also make sure that
>> ata_scsi_find_dev() is called with ap->lock held, as it should.
>>
>> libsas and libata call sites of ata_change_queue_depth() are updated to
>> match the modified function arguments.
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> 
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> 
> Thanks!
> 
> Just a reminder to all - I'm not asking anyone to fix it - we still have 
> that funky libsas behaviour for attempting to set queue depth at 33:
> 
> https://lore.kernel.org/linux-scsi/db84e61a-1069-982a-5659-297fcffc14f4@huawei.com/

I checked that again. For a libsas device, with this patch applied, we have:

# echo 1 > /sys/block/sdg/device/queue_depth
# cat /sys/block/sdg/device/queue_depth
1
# echo 33 > /sys/block/sdg/device/queue_depth; echo $?
0		<-- success !
# cat /sys/block/sdg/device/queue_depth
32		<-- qd was capped
# echo 33 > /sys/block/sdg/device/queue_depth; echo $?
1		<-- error !
# cat /sys/block/sdg/device/queue_depth
32		<-- no change

For a libata device, we have:

# echo 1 > /sys/block/sdc/device/queue_depth
# cat /sys/block/sdc/device/queue_depth
1
# echo 33 > /sys/block/sdc/device/queue_depth
# echo $?
1		<-- error !
# cat /sys/block/sdc/device/queue_depth
1		<-- no change

This is not consistent. The attempt to change from 1 to 33 with libsas should
error and not change anything.

That is because sdev->host->can_queue is larger than 32 for libsas devices as it
indicates the number of commands that the HBA can queue rather than the device
max queue depth.


>>   	/* NCQ enabled? */
>> -	spin_lock_irqsave(ap->lock, flags);
>>   	dev->flags &= ~ATA_DFLAG_NCQ_OFF;
>>   	if (queue_depth == 1 || !ata_ncq_enabled(dev)) {
> 
> Apart from this change, should we call ata_ncq_supported() here (instead 
> of ata_ncq_enabled())? ata_ncq_enabled() checks if ATA_DFLAG_NCQ_OFF is 
> not set, which we have already ensured.

Good catch. ata_ncq_enabled() calls ata_ncq_supported(), so this is not really a
bug, but it would be indeed cleaner (and less confusing) to call
ata_ncq_supported().

I am sending a patch to clean this up.

-- 
Damien Le Moal
Western Digital Research

