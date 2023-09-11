Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB69FEE801F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 06:44:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbjIKGoW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 02:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232031AbjIKGoV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 02:44:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9722F120;
        Sun, 10 Sep 2023 23:44:17 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1724FC433CA;
        Mon, 11 Sep 2023 06:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694414657;
        bh=BDtbK6skN/ze3p/6RlCNM57CdgzOGLa77e0zwF/NxHo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Tf8hBGkH4iSJC8ZGDF/62JApX9eZmV4gab645I5Oi8HIIcxKxrdsdYAK1SreH9VPd
         qrd+C89V2p2KgMflIUnc4aGz4o+YsEPExVl4x3drrEMFMwF43OATwGFTIA32mTzWx8
         ESwSdrPgptWSvM+0q8GsSQMWBTNNYA84Xr086TmLAPCDiwXG3TK+RY0VNZVpteF5ay
         LBRekNDBt/Tt2yVozf/zsbuSkXG66OySDlDyqHeTFkpPFhrDUzDUElmVW5ajTUYci4
         B4EfvMIPVT1gE4Pmrrg7oT4q5RPUfuRJuorfgKb6b0S/a2194doCOtEaZnjqtLqbuu
         hb9iDb3dZlTKg==
Message-ID: <db4e461c-d797-fb76-7d97-e38d3640de89@kernel.org>
Date:   Mon, 11 Sep 2023 15:44:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 02/19] ata: libata-core: Fix port and device removal
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-3-dlemoal@kernel.org>
 <add77796-ff0f-4311-8c4d-6597695e89ed@suse.de>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <add77796-ff0f-4311-8c4d-6597695e89ed@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 15:37, Hannes Reinecke wrote:
> On 9/11/23 06:02, Damien Le Moal wrote:
>> Whenever an ATA adapter driver is removed (e.g. rmmod),
>> ata_port_detach() is called repeatedly for all the adapter ports to
>> remove (unload) the devices attached to the port and delete the port
>> device itself. Removing of devices is done using libata EH with the
>> ATA_PFLAG_UNLOADING port flag set. This causes libata EH to execute
>> ata_eh_unload() which disables all devices attached to the port.
>>
>> ata_port_detach() finishes by calling scsi_remove_host() to remove the
>> scsi host associated with the port. This function will trigger the
>> removal of all scsi devices attached to the host and in the case of
>> disks, calls to sd_shutdown() which will flush the device write cache
>> and stop the device. However, given that the devices were already
>> disabled by ata_eh_unload(), the synchronize write cache command and
>> start stop unit commands fail. E.g. running "rmmod ahci" with first
>> removing sd_mod results in error messages like:
>>
>> ata13.00: disable device
>> sd 0:0:0:0: [sda] Synchronizing SCSI cache
>> sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result:
>> hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>> sd 0:0:0:0: [sda] Stopping disk
>> sd 0:0:0:0: [sda] Start/Stop Unit failed: Result: hostbyte=DID_BAD_TARGET
>> driverbyte=DRIVER_OK
>>
>> Fix this by removing all scsi devices of the ata devices connected to
>> the port before scheduling libata EH to disable the ATA devices.
>>
>> Fixes: 720ba12620ee ("[PATCH] libata-hp: update unload-unplug")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>   drivers/ata/libata-core.c | 21 ++++++++++++++++++++-
>>   1 file changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index c4898483d716..693cb3cd70cd 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -5952,11 +5952,30 @@ static void ata_port_detach(struct ata_port *ap)
>>       struct ata_link *link;
>>       struct ata_device *dev;
>>   -    /* tell EH we're leaving & flush EH */
>> +    /* Wait for any ongoing EH */
>> +    ata_port_wait_eh(ap);
>> +
>> +    mutex_lock(&ap->scsi_scan_mutex);
>>       spin_lock_irqsave(ap->lock, flags);
>> +
>> +    /* Remove scsi devices */
>> +    ata_for_each_link(link, ap, HOST_FIRST) {
>> +        ata_for_each_dev(dev, link, ALL) {
>> +            if (dev->sdev) {
>> +                spin_unlock_irqrestore(ap->lock, flags);
>> +                scsi_remove_device(dev->sdev);
>> +                spin_lock_irqsave(ap->lock, flags);
>> +                dev->sdev = NULL;
>> +            }
>> +        }
>> +    }
>> +
>> +    /* Tell EH to disable all devices */
>>       ap->pflags |= ATA_PFLAG_UNLOADING;
>>       ata_port_schedule_eh(ap);
>> +
>>       spin_unlock_irqrestore(ap->lock, flags);
>> +    mutex_unlock(&ap->scsi_scan_mutex);
>>   
> Are you sure about releasing scan_mutex after ata_port_schedule_eh()?
> Technically ata_port_schedule_eh() will be calling into SCSI rescan, which
> would take scan_mutex ...
> Not that it matter much, seeing that we've disconnected all devices, but still ...

UNLOADING is set and in that case, EH does nothing else than removing the
devices. So I think this is OK.

> 
> Cheers,
> 
> Hannes

-- 
Damien Le Moal
Western Digital Research

