Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C487EE801F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 06:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbjIKG7Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 02:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234531AbjIKG7Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 02:59:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A8012D;
        Sun, 10 Sep 2023 23:59:20 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17D7C433C7;
        Mon, 11 Sep 2023 06:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694415560;
        bh=sF8Mqt4Uq0ewUynE1/pJEApM8zTMfvU3gzFDG+jqzqQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=M/Wnzwj/9Qtvtc95latBFpFv0BXffMYvOSxrSPFqcrApboN/8zyJeyGibXGAZUnLI
         Rw21G3Vjs/TGo1HzsxEVOHdMTgwNOSl3euNRLEryykQNjC45Ywg1GbQ6kRdsqxHwZU
         0WsR/KgDACC3f6FLcqPC1Fofng2DYg2Ap0zf6hdT3twaiehYlp90Sh19Cst3A8qoDj
         qEblU+rmLBIm11YMycJ9lXrBpgL63HYVbFQEy1N7aOINsaQKcyXFZBB3XBPZhyAIS7
         WeJb7r6/s/eQ8ybU+dJRU18pSVojE19B2+F9k/iFwaMN2yvvompFmy/h/VE09uiOim
         QKVjNQjGl5yFA==
Message-ID: <8ca4afdb-bf15-c964-c225-b5f6d7b4d670@kernel.org>
Date:   Mon, 11 Sep 2023 15:59:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 04/19] ata: libata-scsi: Disable scsi device
 manage_start_stop
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
 <20230911040217.253905-5-dlemoal@kernel.org>
 <0d7e1e2d-06a8-4992-be0b-7a97646c170d@suse.de>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <0d7e1e2d-06a8-4992-be0b-7a97646c170d@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 15:46, Hannes Reinecke wrote:
> On 9/11/23 06:02, Damien Le Moal wrote:
>> The introduction of a device link to create a consumer/supplier
>> relationship between the scsi device of an ATA device and the ATA port
>> of the ATA device fixed the ordering of the suspend and resume
>> operations. For suspend, the scsi device is suspended first and the ata
>> port after it. This is fine as this allows the synchronize cache and
>> START STOP UNIT commands issued by the scsi disk driver to be executed
>> before the ata port is disabled.
>>
>> For resume operations, the ata port is resumed first, followed
>> by the scsi device. This allows having the request queue of the scsi
>> device to be unfrozen after the ata port restart is scheduled in EH,
>> thus avoiding to see new requests issued to the ATA device prematurely.
>> However, since libata sets manage_start_stop to 1, the scsi disk resume
>> operation also results in issuing a START STOP UNIT command to wakeup
>> the device. This is too late and that must be done before libata EH
>> resume handling starts revalidating the drive with IDENTIFY etc
>> commands. Commit 0a8589055936 ("ata,scsi: do not issue START STOP UNIT
>> on resume") disabled issuing the START STOP UNIT command to avoid
>> issues with it. However, this is incorrect as transitioning a device to
>> the active power mode from the standby power mode set on suspend
>> requires a media access command. The device link reset and subsequent
>> SET FEATURES, IDENTIFY and READ LOG commands executed in libata EH
>> context triggered by the ata port resume operation may thus fail.
>>
>> Fix this by handling a device power mode transitions for suspend and
>> resume in libata EH context without relying on the scsi disk management
>> triggered with the manage_start_stop flag.
>>
>> To do this, the following libata helper functions are introduced:
>>
>> 1) ata_dev_power_set_standby():
>>
>> This function issues a STANDBY IMMEDIATE command to transitiom a device
>> to the standby power mode. For HDDs, this spins down the disks. This
>> function applies only to ATA and ZAC devices and does nothing otherwise.
>> This function also does nothing for devices that have the
>> ATA_FLAG_NO_POWEROFF_SPINDOWN or ATA_FLAG_NO_HIBERNATE_SPINDOWN flag
>> set.
>>
>> For suspend, call ata_dev_power_set_standby() in
>> ata_eh_handle_port_suspend() before the port is disabled and frozen.
>> ata_eh_unload() is also modified to transition all enabled devices to
>> the standby power mode when the system is shutdown or devices removed.
>>
>> 2) ata_dev_power_set_active() and
>>
>> This function applies to ATA or ZAC devices and issues a VERIFY command
>> for 1 sector at LBA 0 to transition the device to the active power mode.
>> For HDDs, since this function will complete only once the disk spin up.
>> Its execution uses the same timeouts as for reset, to give the drive
>> enough time to complete spinup without triggering a command timeout.
>>
> Neat. But why VERIFY?

Ask that to T13 :) Need a media access command to get out of sleep state...
Could use a read, but then need a buffer, which is silly for just waking up a
drive. VERIFY is a mandatory command.

> Isn't there a dedicated command (ie the opposite of STANDBY IMMEDIATE)?
> And can we be sure that VERIFY is implemented everywhere?
> It's not that this command had been in active use until now ...

START STOP UNIT with start == 1 has been translated to a VERIFY command since
forever. This is according to SAT specs. There is no command to explicitly get
out of standby-mode. Even a reset should not change the drive power state
(though I do see a lot of drive waking up on COMRESET). A media access command
does that. See ACS specs "Power Management states and transitions". The only
exception is that you can use SET FEATURE command to wake up a drive, but only
from PUIS state (Power-Up in Standby), which is a different feature that is not
necessarilly supported by a device.

> 
> Cheers,
> 
> Hannes

-- 
Damien Le Moal
Western Digital Research

