Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34639CE79A8
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 17:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbjISRnz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 13:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232564AbjISRni (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 13:43:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D0530D3;
        Tue, 19 Sep 2023 10:42:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360F3C433CB;
        Tue, 19 Sep 2023 17:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695145358;
        bh=Em2WVg3mf7U6V+e5WYCg2jM8nchb1BTEyR0212Lh/t8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=PEq9Z++T37PkQaQaSUsxinra+YL2SIvpBYWTnRKJ5H5bZB+OKUIQN2WpElZm5+wFn
         Y0XTZHqIjCNlOVZgYnSnNRNT0w7PVW6w7X4bSdrkNoXBLCeQXCsuA9J3hiTfTZZbR4
         7PD20RA8xIhMvxD2LEymiZcHvxizDAm+KQ+BRqoyEeYmnrEDCOfJ/YdW37MAjKplLj
         Uo8PRVpzj4CNjJ5tTNBPryWaVy/EFHm/ynkUA9HS+BRaQEi1ZQ4jwGE141QhLB7PYJ
         hkxLMZof0NHJiMeGFy2Gc3UCptPl35Zq5pLFBhe8MqZkXndiBuARXjxxOwkDk6LsXV
         j3f7PHvQISVfw==
Message-ID: <21a91219-82d1-dcbf-e20b-49ed2ddfd1f0@kernel.org>
Date:   Tue, 19 Sep 2023 10:42:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 02/23] ata: libata-core: Fix port and device removal
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230915081507.761711-1-dlemoal@kernel.org>
 <20230915081507.761711-3-dlemoal@kernel.org> <ZQmgSgm+Kovh+27q@x1-carbon>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZQmgSgm+Kovh+27q@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/19 6:21, Niklas Cassel wrote:
> On Fri, Sep 15, 2023 at 05:14:46PM +0900, Damien Le Moal wrote:
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
>> sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>> sd 0:0:0:0: [sda] Stopping disk
>> sd 0:0:0:0: [sda] Start/Stop Unit failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>>
>> Fix this by removing all scsi devices of the ata devices connected to
>> the port before scheduling libata EH to disable the ATA devices.
>>
>> Fixes: 720ba12620ee ("[PATCH] libata-hp: update unload-unplug")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
>> ---
>>  drivers/ata/libata-core.c | 21 ++++++++++++++++++++-
>>  1 file changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index c4898483d716..693cb3cd70cd 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -5952,11 +5952,30 @@ static void ata_port_detach(struct ata_port *ap)
>>  	struct ata_link *link;
>>  	struct ata_device *dev;
>>  
>> -	/* tell EH we're leaving & flush EH */
>> +	/* Wait for any ongoing EH */
>> +	ata_port_wait_eh(ap);
>> +
>> +	mutex_lock(&ap->scsi_scan_mutex);
>>  	spin_lock_irqsave(ap->lock, flags);
>> +
>> +	/* Remove scsi devices */
>> +	ata_for_each_link(link, ap, HOST_FIRST) {
>> +		ata_for_each_dev(dev, link, ALL) {
>> +			if (dev->sdev) {
>> +				spin_unlock_irqrestore(ap->lock, flags);
>> +				scsi_remove_device(dev->sdev);
>> +				spin_lock_irqsave(ap->lock, flags);
>> +				dev->sdev = NULL;
>> +			}
>> +		}
>> +	}
>> +
>> +	/* Tell EH to disable all devices */
>>  	ap->pflags |= ATA_PFLAG_UNLOADING;
>>  	ata_port_schedule_eh(ap);
>> +
>>  	spin_unlock_irqrestore(ap->lock, flags);
>> +	mutex_unlock(&ap->scsi_scan_mutex);
>>  
>>  	/* wait till EH commits suicide */
>>  	ata_port_wait_eh(ap);
>> -- 
>> 2.41.0
>>
> 
> Looks good:
> Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Could you perhaps also fix the WARN_ON(!(ap->pflags & ATA_PFLAG_UNLOADED));
> in this very same function.
> 
> The pflag is checked without holding the lock.

It does not matter much at that point since EH is dead, or supposed to be, which
is what the WARN_ON() checks.

> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

