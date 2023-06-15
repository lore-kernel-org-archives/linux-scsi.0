Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38347EB64DB
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 08:47:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245350AbjFOIrC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jun 2023 04:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244914AbjFOIqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jun 2023 04:46:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C30730D3;
        Thu, 15 Jun 2023 01:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE14760BFC;
        Thu, 15 Jun 2023 08:45:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33D00C433C0;
        Thu, 15 Jun 2023 08:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686818748;
        bh=/F9q5DrVHRMEiUfVNoxSnR46gbvfDyAHt842jojQhhg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=PkvmMXaYTP/wVAs+igfNq5m/NXpYPbmNjwnRNk8eMUT9nb72md8WSUCRj18ywcj1n
         /RmkeGfc69IsEAS9Z3gDZAByF8Gaz/tqkhxQXPXKFqDHowAzav2Rd+tGXTK/1f7BED
         8bW/w6esLrhVmmlcwMzATgbUp50sa/EHcFDL/xYSnUNoFq+K53YmACDWazlPis5e7W
         v4ODpQ29GflVq0cPF5WEqVQ4Xq1KuGQuBB/MEWIwyjGxqLEJFZ4zfQXHL+a+/15uI/
         kx4akD7uDGkZ/vkUbYTYUyp4n0Q2iv7tYZR/BaJPAFbaWT65wjk/F8sdqpL+T97lrF
         xCvAskW5Zlc8A==
Message-ID: <5dc3bd2f-6b0d-f2ee-7f29-9e6b40df2671@kernel.org>
Date:   Thu, 15 Jun 2023 17:45:46 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] ata: libata-scsi: Avoid deadlock on rescan after device
 resume
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J . Wysocki" <rafael@kernel.org>
References: <20230615083326.161875-1-dlemoal@kernel.org>
 <cd56bd55-e0e5-d8f0-bdac-2e0513ed7106@suse.de>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <cd56bd55-e0e5-d8f0-bdac-2e0513ed7106@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/15/23 17:41, Hannes Reinecke wrote:
> On 6/15/23 10:33, Damien Le Moal wrote:
>> When an ATA port is resumed from sleep, the port is reset and a power
>> management request issued to libata EH to reset the port and rescanning
>> the device(s) attached to the port. Device rescanning is done by
>> scheduling an ata_scsi_dev_rescan() work, which will execute
>> scsi_rescan_device().
>>
>> However, scsi_rescan_device() takes the generic device lock, which is
>> also taken by dpm_resume() when the SCSI device is resumed as well. If
>> a device rescan execution starts before the completion of the SCSI
>> device resume, the rcu locking used to refresh the cached VPD pages of
>> the device, combined with the generic device locking from
>> scsi_rescan_device() and from dpm_resume() can cause a deadlock.
>>
>> Avoid this situation by changing struct ata_port scsi_rescan_task to be
>> a delayed work instead of a simple work_struct. ata_scsi_dev_rescan() is
>> modified to check if the SCSI device associated with the ATA device that
>> must be rescanned is not suspended. If the SCSI device is still
>> suspended, ata_scsi_dev_rescan() returns early and reschedule itself for
>> execution after an arbitrary delay of 5ms.
>>
>> Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>> Reported-by: Joe Breuer <linux-kernel@jmbreuer.net>
>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217530
>> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>   drivers/ata/libata-core.c |  3 ++-
>>   drivers/ata/libata-eh.c   |  2 +-
>>   drivers/ata/libata-scsi.c | 22 +++++++++++++++++++++-
>>   include/linux/libata.h    |  2 +-
>>   4 files changed, 25 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 8bf612bdd61a..b4f246f0cac7 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -5348,7 +5348,7 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
>>   
>>   	mutex_init(&ap->scsi_scan_mutex);
>>   	INIT_DELAYED_WORK(&ap->hotplug_task, ata_scsi_hotplug);
>> -	INIT_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
>> +	INIT_DELAYED_WORK(&ap->scsi_rescan_task, ata_scsi_dev_rescan);
>>   	INIT_LIST_HEAD(&ap->eh_done_q);
>>   	init_waitqueue_head(&ap->eh_wait_q);
>>   	init_completion(&ap->park_req_pending);
>> @@ -5954,6 +5954,7 @@ static void ata_port_detach(struct ata_port *ap)
>>   	WARN_ON(!(ap->pflags & ATA_PFLAG_UNLOADED));
>>   
>>   	cancel_delayed_work_sync(&ap->hotplug_task);
>> +	cancel_delayed_work_sync(&ap->scsi_rescan_task);
>>   
>>    skip_eh:
>>   	/* clean up zpodd on port removal */
>> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
>> index a6c901811802..6f8d14191593 100644
>> --- a/drivers/ata/libata-eh.c
>> +++ b/drivers/ata/libata-eh.c
>> @@ -2984,7 +2984,7 @@ static int ata_eh_revalidate_and_attach(struct ata_link *link,
>>   			ehc->i.flags |= ATA_EHI_SETMODE;
>>   
>>   			/* schedule the scsi_rescan_device() here */
>> -			schedule_work(&(ap->scsi_rescan_task));
>> +			schedule_delayed_work(&ap->scsi_rescan_task, 0);
>>   		} else if (dev->class == ATA_DEV_UNKNOWN &&
>>   			   ehc->tries[dev->devno] &&
>>   			   ata_class_enabled(ehc->classes[dev->devno])) {
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 8ce90284eb34..551077cea4e4 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -4597,10 +4597,11 @@ int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
>>   void ata_scsi_dev_rescan(struct work_struct *work)
>>   {
>>   	struct ata_port *ap =
>> -		container_of(work, struct ata_port, scsi_rescan_task);
>> +		container_of(work, struct ata_port, scsi_rescan_task.work);
>>   	struct ata_link *link;
>>   	struct ata_device *dev;
>>   	unsigned long flags;
>> +	bool delay_rescan = false;
>>   
>>   	mutex_lock(&ap->scsi_scan_mutex);
>>   	spin_lock_irqsave(ap->lock, flags);
>> @@ -4614,6 +4615,21 @@ void ata_scsi_dev_rescan(struct work_struct *work)
>>   			if (scsi_device_get(sdev))
>>   				continue;
>>   
>> +			/*
>> +			 * If the rescan work was scheduled because of a resume
>> +			 * event, the port is already fully resumed, but the
>> +			 * SCSI device may not yet be fully resumed. In such
>> +			 * case, executing scsi_rescan_device() may cause a
>> +			 * deadlock with the PM code on device_lock(). Prevent
>> +			 * this by giving up and retrying rescan after a short
>> +			 * delay.
>> +			 */
>> +			delay_rescan = sdev->sdev_gendev.power.is_suspended;
>> +			if (delay_rescan) {
>> +				scsi_device_put(sdev);
>> +				break;
>> +			}
>> +
>>   			spin_unlock_irqrestore(ap->lock, flags);
>>   			scsi_rescan_device(&(sdev->sdev_gendev));
>>   			scsi_device_put(sdev);
>> @@ -4623,4 +4639,8 @@ void ata_scsi_dev_rescan(struct work_struct *work)
>>   
>>   	spin_unlock_irqrestore(ap->lock, flags);
>>   	mutex_unlock(&ap->scsi_scan_mutex);
>> +
>> +	if (delay_rescan)
>> +		schedule_delayed_work(&ap->scsi_rescan_task,
>> +				      msecs_to_jiffies(5));
>>   }
>> diff --git a/include/linux/libata.h b/include/linux/libata.h
>> index 311cd93377c7..dd5797fb6305 100644
>> --- a/include/linux/libata.h
>> +++ b/include/linux/libata.h
>> @@ -836,7 +836,7 @@ struct ata_port {
>>   
>>   	struct mutex		scsi_scan_mutex;
>>   	struct delayed_work	hotplug_task;
>> -	struct work_struct	scsi_rescan_task;
>> +	struct delayed_work	scsi_rescan_task;
>>   
>>   	unsigned int		hsm_task_state;
>>   
> 
> Hehe. That is exactly what I had in mind.

The direct test of "is_suspended" is not exactly pretty. But there are a few
drivers doing it... So, it will have to do for now.

> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> 
> Cheers,
> 
> Hannes
> 

-- 
Damien Le Moal
Western Digital Research

