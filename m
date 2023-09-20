Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5A8CE79B9
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Sep 2023 10:22:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbjITKWg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Sep 2023 06:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbjITKWf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Sep 2023 06:22:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A320A94;
        Wed, 20 Sep 2023 03:22:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE047C433C8;
        Wed, 20 Sep 2023 10:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695205349;
        bh=KyQVvlKYy5PbSPVtEt7iFhUFowTzcx9hMSjyyZO8+5A=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MS3FHYQR7GK2PqMi47QE/BAILuLmno1o7Z6MU8/IH6hVGfnRLN9XANRPxXMJh76HU
         IggNyCT9BZQCsjemDnIBEyYhVn/0//7watbzourgjLPdO49uqFU91QXyGU3AXiP637
         kb6ttTcL4slqPFIyTx0s4f7YGT6jbaw7Dt0ZeysTj02Gf2IJK0SD0M1zWG8Ae++OrY
         xbd7oRdIJ/0fcuAWnUv031YeFgolR5baEhQeJHa+4Kkc1c3K2ETer9m/QKZWtRE/xN
         TRfHjqt6UEbPhhZZVWHPpbDneW19focHryKaDyQH27Jj68X6vnLgZoEEaNdOVLQWO4
         zAA1yq1k/lSVA==
Message-ID: <6bcc7a88-af44-f23e-1f79-ba09df415486@kernel.org>
Date:   Wed, 20 Sep 2023 03:22:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
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
 <0c2c5b5b-85b5-89c6-5d62-c4d3a029fb2b@kernel.org>
 <ZQqdap5Q3ky6lV4p@x1-carbon> <ZQqfkisAiMowBWVD@x1-carbon>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ZQqfkisAiMowBWVD@x1-carbon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/20 0:30, Niklas Cassel wrote:
> On Wed, Sep 20, 2023 at 09:21:14AM +0200, Niklas Cassel wrote:
>> On Tue, Sep 19, 2023 at 09:31:04AM -0700, Damien Le Moal wrote:
>>> On 2023/09/19 6:21, Niklas Cassel wrote:
>>>> On Fri, Sep 15, 2023 at 05:14:45PM +0900, Damien Le Moal wrote:
>>>>> The function ata_port_request_pm() checks the port flag
>>>>> ATA_PFLAG_PM_PENDING and calls ata_port_wait_eh() if this flag is set to
>>>>> ensure that power management operations for a port are not secheduled
>>>>
>>>> s/secheduled/scheduled/
>>>>
>>>>> simultaneously. However, this flag check is done without holding the
>>>>> port lock.
>>>>>
>>>>> Fix this by taking the port lock on entry to the function and checking
>>>>> the flag under this lock. The lock is released and re-taken if
>>>>> ata_port_wait_eh() needs to be called.
>>>>>
>>>>> Fixes: 5ef41082912b ("ata: add ata port system PM callbacks")
>>>>> Cc: stable@vger.kernel.org
>>>>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>>>>> Reviewed-by: Hannes Reinecke <hare@suse.de>
>>>>> Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
>>>>> ---
>>>>>  drivers/ata/libata-core.c | 17 +++++++++--------
>>>>>  1 file changed, 9 insertions(+), 8 deletions(-)
>>>>>
>>>>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>>>>> index 74314311295f..c4898483d716 100644
>>>>> --- a/drivers/ata/libata-core.c
>>>>> +++ b/drivers/ata/libata-core.c
>>>>> @@ -5040,17 +5040,20 @@ static void ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
>>>>>  	struct ata_link *link;
>>>>>  	unsigned long flags;
>>>>>  
>>>>> -	/* Previous resume operation might still be in
>>>>> -	 * progress.  Wait for PM_PENDING to clear.
>>>>> +	spin_lock_irqsave(ap->lock, flags);
>>>>> +
>>>>> +	/*
>>>>> +	 * A previous PM operation might still be in progress. Wait for
>>>>> +	 * ATA_PFLAG_PM_PENDING to clear.
>>>>>  	 */
>>>>>  	if (ap->pflags & ATA_PFLAG_PM_PENDING) {
>>>>> +		spin_unlock_irqrestore(ap->lock, flags);
>>>>>  		ata_port_wait_eh(ap);
>>>>> +		spin_lock_irqsave(ap->lock, flags);
>>>>>  		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
>>>>>  	}
>>>>>  
>>>>> -	/* request PM ops to EH */
>>>>> -	spin_lock_irqsave(ap->lock, flags);
>>>>> -
>>>>> +	/* Request PM operation to EH */
>>>>>  	ap->pm_mesg = mesg;
>>>>>  	ap->pflags |= ATA_PFLAG_PM_PENDING;
>>>>>  	ata_for_each_link(link, ap, HOST_FIRST) {
>>>>> @@ -5062,10 +5065,8 @@ static void ata_port_request_pm(struct ata_port *ap, pm_message_t mesg,
>>>>>  
>>>>>  	spin_unlock_irqrestore(ap->lock, flags);
>>>>>  
>>>>> -	if (!async) {
>>>>> +	if (!async)
>>>>>  		ata_port_wait_eh(ap);
>>>>> -		WARN_ON(ap->pflags & ATA_PFLAG_PM_PENDING);
>>>>
>>>> Perhaps you should mention why this WARN_ON() is removed in the commit
>>>> message.
>>>>
>>>> I don't understand why you keep the WARN_ON() higher up in this function,
>>>> but remove this WARN_ON(). They seem to have equal worth to me.
>>>> Perhaps just take and release the lock around the WARN_ON() here as well?
>>>
>>> Yes, they have the same worth == not super useful... I kept the one higher up as
>>> it is OK because we hold the lock, but removed the second one as checking pflags
>>> without the lock is just plain wrong. Thinking of it, the first WRN_ON() is also
>>> wrong I think because EH could be rescheduled right after wait_eh and before we
>>> take the lock. In that case, the warn on would be a flase positive. I will
>>> remove it as well.
>>
>> We are checking if ATA_PFLAG_PM_PENDING is set, if it is, we do
>> ata_port_wait_eh(), which will wait until both ATA_PFLAG_EH_PENDING and
>> ATA_PFLAG_EH_IN_PROGRESS is cleared.
>>
>> Note that ATA_PFLAG_PM_PENDING and ATA_PFLAG_EH_PENDING have very similar
>> names... I really think we should rename ATA_PFLAG_PM_PENDING to something
>> like ATA_PFLAG_EH_PM_PENDING (the PM is performed by EH), in order to make
>> it harder to mix them up.
> 
> Perhaps ATA_PFLAG_POWER_STATE_PENDING is a better name?

That could be confused with a power state called "pending". Something like
ATA_PFLAG_EH_PM_REQUEST_PENDING would be more descriptive and different enough
from ATA_PFLAG_EH_PENDING.

> 
> That way we make it even harder to mix them up, since my previous
> suggestion ATA_PFLAG_EH_PM_PENDING, people might still miss the _PM_ part
> when reading quickly and could still confuse it with ATA_PFLAG_EH_PENDING.
> 
> 
> Kind regards,
> Niklas

-- 
Damien Le Moal
Western Digital Research

