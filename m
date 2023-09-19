Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07440CE79A9
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Sep 2023 16:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231903AbjISQbT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Sep 2023 12:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbjISQbS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2023 12:31:18 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00019BA;
        Tue, 19 Sep 2023 09:31:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8FCC4339A;
        Tue, 19 Sep 2023 16:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695141066;
        bh=6YJginIl4d1otkR4Lb85rezGiPQkb1c3KK5wqQgF/gw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=kiTB3o2TPE2Vh6lsGZmS5XlqcJHmJrnI4C5MOhJcS0Osfs7rHc79mHae9cEYMyCDb
         lQrfTIefMSnZgNlCxSZ3x/Ey9fRuXU7kg8k7RILNTQzf4TXCl5McisdABcJcbG/td8
         H1E4ZRPDHRepipxKU2QRdgAhl5+ZDeLC5FtDu5DpgPkgxzOJR/N7d2LgC4cdUvcgUd
         u0jXB7WanqS5uJJh4OUMrmTTNCZTGxgtfGzvau8FE4IG7hVFEaDQCcVT7kBGilKw3n
         O5sUcAfKg5brk0akMYDQTmpLuTMlkJG4OM/zakWJTVWglHMT9AYehIFTIkcvuTBq4e
         yVxvSDPT+J/jA==
Message-ID: <0c2c5b5b-85b5-89c6-5d62-c4d3a029fb2b@kernel.org>
Date:   Tue, 19 Sep 2023 09:31:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v3 01/23] ata: libata-core: Fix ata_port_request_pm()
 locking
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
 <20230915081507.761711-2-dlemoal@kernel.org> <ZQmgNUCLV8rDXg5I@x1-carbon>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZQmgNUCLV8rDXg5I@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/19 6:21, Niklas Cassel wrote:
> On Fri, Sep 15, 2023 at 05:14:45PM +0900, Damien Le Moal wrote:
>> The function ata_port_request_pm() checks the port flag
>> ATA_PFLAG_PM_PENDING and calls ata_port_wait_eh() if this flag is set to
>> ensure that power management operations for a port are not secheduled
> 
> s/secheduled/scheduled/
> 
>> simultaneously. However, this flag check is done without holding the
>> port lock.
>>
>> Fix this by taking the port lock on entry to the function and checking
>> the flag under this lock. The lock is released and re-taken if
>> ata_port_wait_eh() needs to be called.
>>
>> Fixes: 5ef41082912b ("ata: add ata port system PM callbacks")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>> Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
>> ---
>>  drivers/ata/libata-core.c | 17 +++++++++--------
>>  1 file changed, 9 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 74314311295f..c4898483d716 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -5040,17 +5040,20 @@ static void ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
>>  	struct ata_link *link;
>>  	unsigned long flags;
>>  
>> -	/* Previous resume operation might still be in
>> -	 * progress.  Wait for PM_PENDING to clear.
>> +	spin_lock_irqsave(ap->lock, flags);
>> +
>> +	/*
>> +	 * A previous PM operation might still be in progress. Wait for
>> +	 * ATA_PFLAG_PM_PENDING to clear.
>>  	 */
>>  	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
>> +		spin_unlock_irqrestore(ap->lock, flags);
>>  		ata_port_wait_eh(ap);
>> +		spin_lock_irqsave(ap->lock, flags);
>>  		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
>>  	}
>>  
>> -	/* request PM ops to EH */
>> -	spin_lock_irqsave(ap->lock, flags);
>> -
>> +	/* Request PM operation to EH */
>>  	ap->pm_mesg = mesg;
>>  	ap->pflags |= ATA_PFLAG_PM_PENDING;
>>  	ata_for_each_link(link, ap, HOST_FIRST) {
>> @@ -5062,10 +5065,8 @@ static void ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
>>  
>>  	spin_unlock_irqrestore(ap->lock, flags);
>>  
>> -	if (!async) {
>> +	if (!async)
>>  		ata_port_wait_eh(ap);
>> -		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
> 
> Perhaps you should mention why this WARN_ON() is removed in the commit
> message.
> 
> I don't understand why you keep the WARN_ON() higher up in this function,
> but remove this WARN_ON(). They seem to have equal worth to me.
> Perhaps just take and release the lock around the WARN_ON() here as well?

Yes, they have the same worth == not super useful... I kept the one higher up as
it is OK because we hold the lock, but removed the second one as checking pflags
without the lock is just plain wrong. Thinking of it, the first WRN_ON() is also
wrong I think because EH could be rescheduled right after wait_eh and before we
take the lock. In that case, the warn on would be a flase positive. I will
remove it as well.

-- 
Damien Le Moal
Western Digital Research

