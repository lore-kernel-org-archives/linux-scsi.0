Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3792C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Nov 2021 11:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238421AbhK2LE5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Nov 2021 06:04:57 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:59798 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239066AbhK2LCy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Nov 2021 06:02:54 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 37A091FD38;
        Mon, 29 Nov 2021 10:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1638183576; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MX/Kqsi5x7Ma/NUP4aQgxNmnm/oCpsmitV0Y+oe9LIA=;
        b=PwPZTjdBby54aZDwCTPbJPlm3EF4XvcZxGhw11Zz1+GdkWZr8v+Prn7VqL5wh23xa/rAPO
        JAS2FktHOPuKnf6mFlTm8P8tytoyeY5NJAbjiz2a2iesAHnUcx+JX5AuJmK30mWHZeMRbe
        KBL0krZvszuJwu8Bxcy0xpUV4bjbMpo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1638183576;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MX/Kqsi5x7Ma/NUP4aQgxNmnm/oCpsmitV0Y+oe9LIA=;
        b=IcXYD26SGssHXg6JnssKzdgotfuNXoawOOcbE/Boe0PU8fAV1mYWAoKszHp2ydCQcuvw19
        i74hzGjZ66txV/AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1C01713B4B;
        Mon, 29 Nov 2021 10:59:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DkryBZiypGF6AwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 29 Nov 2021 10:59:36 +0000
Subject: Re: [PATCH 01/15] scsi: allocate host device
From:   Hannes Reinecke <hare@suse.de>
To:     "chenxiang (M)" <chenxiang66@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>
References: <20211125151048.103910-1-hare@suse.de>
 <20211125151048.103910-2-hare@suse.de>
 <3e3eb96b-ad89-41a3-f915-4855695f1b77@hisilicon.com>
 <a0c57328-c429-04b3-b908-0617fe5c6bde@suse.de>
Message-ID: <8efc0e24-3000-39d9-7676-e0896145f247@suse.de>
Date:   Mon, 29 Nov 2021 11:59:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <a0c57328-c429-04b3-b908-0617fe5c6bde@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/27/21 5:52 PM, Hannes Reinecke wrote:
> On 11/26/21 3:47 AM, chenxiang (M) wrote:
>> Hi Hannes,
>>
>>
>> 在 2021/11/25 23:10, Hannes Reinecke 写道:
>>> Add a flag 'alloc_host_dev' to the SCSI host template and allocate
>>> a virtual scsi device if the flag is set.
>>> This device has the SCSI id <max_id + 1>:0, so won't clash with any
>>> devices the HBA might allocate. It's also excluded from scanning and
>>> will not show up in sysfs.
>>> Intention is to use this device to send internal commands to the HBA.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>   drivers/scsi/hosts.c       |  8 +++++
>>>   drivers/scsi/scsi_scan.c   | 67 +++++++++++++++++++++++++++++++++++++-
>>>   drivers/scsi/scsi_sysfs.c  |  3 +-
>>>   include/scsi/scsi_device.h |  2 +-
>>>   include/scsi/scsi_host.h   | 21 ++++++++++++
>>>   5 files changed, 98 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>>> index f69b77cbf538..a539fa2fb221 100644
>>> --- a/drivers/scsi/hosts.c
>>> +++ b/drivers/scsi/hosts.c
>>> @@ -290,6 +290,14 @@ int scsi_add_host_with_dma(struct Scsi_Host 
>>> *shost, struct device *dev,
>>>       if (error)
>>>           goto out_del_dev;
>>> +    if (sht->alloc_host_sdev) {
>>> +        shost->shost_sdev = scsi_get_host_dev(shost);
>>> +        if (!shost->shost_sdev) {
>>> +            error = -ENOMEM;
>>> +            goto out_del_dev;
>>> +        }
>>> +    }
>>> +
>>>       scsi_proc_host_add(shost);
>>>       scsi_autopm_put_host(shost);
>>>       return error;
>>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>>> index 328c0e79dfe7..e2910aa02a65 100644
>>> --- a/drivers/scsi/scsi_scan.c
>>> +++ b/drivers/scsi/scsi_scan.c
>>> @@ -1139,6 +1139,12 @@ static int scsi_probe_and_add_lun(struct 
>>> scsi_target *starget,
>>>       if (!sdev)
>>>           goto out;
>>> +    if (scsi_device_is_host_dev(sdev)) {
>>> +        if (bflagsp)
>>> +            *bflagsp = BLIST_NOLUN;
>>> +        return SCSI_SCAN_LUN_PRESENT;
>>> +    }
>>> +
>>>       result = kmalloc(result_len, GFP_KERNEL);
>>>       if (!result)
>>>           goto out_free_sdev;
>>> @@ -1755,6 +1761,9 @@ static void scsi_sysfs_add_devices(struct 
>>> Scsi_Host *shost)
>>>           /* If device is already visible, skip adding it to sysfs */
>>>           if (sdev->is_visible)
>>>               continue;
>>> +        /* Host devices should never be visible in sysfs */
>>> +        if (scsi_device_is_host_dev(sdev))
>>> +            continue;
>>>           if (!scsi_host_scan_allowed(shost) ||
>>>               scsi_sysfs_add_sdev(sdev) != 0)
>>>               __scsi_remove_device(sdev);
>>> @@ -1919,12 +1928,16 @@ EXPORT_SYMBOL(scsi_scan_host);
>>>   void scsi_forget_host(struct Scsi_Host *shost)
>>>   {
>>> -    struct scsi_device *sdev;
>>> +    struct scsi_device *sdev, *host_sdev = NULL;
>>>       unsigned long flags;
>>>    restart:
>>>       spin_lock_irqsave(shost->host_lock, flags);
>>>       list_for_each_entry(sdev, &shost->__devices, siblings) {
>>> +        if (scsi_device_is_host_dev(sdev)) {
>>> +            host_sdev = sdev;
>>> +            continue;
>>> +        }
>>>           if (sdev->sdev_state == SDEV_DEL)
>>>               continue;
>>>           spin_unlock_irqrestore(shost->host_lock, flags);
>>> @@ -1932,5 +1945,57 @@ void scsi_forget_host(struct Scsi_Host *shost)
>>>           goto restart;
>>>       }
>>>       spin_unlock_irqrestore(shost->host_lock, flags);
>>> +    /* Remove host device last, might be needed to send commands */
>>> +    if (host_sdev)
>>> +        __scsi_remove_device(host_sdev);
>>>   }
>>> +/**
>>> + * scsi_get_host_dev - Create a virtual scsi_device to the host adapter
>>> + * @shost: Host that needs a scsi_device
>>> + *
>>> + * Lock status: None assumed.
>>> + *
>>> + * Returns:     The scsi_device or NULL
>>> + *
>>> + * Notes:
>>> + *    Attach a single scsi_device to the Scsi_Host. The primary aim
>>> + *    for this device is to serve as a container from which valid
>>> + *    scsi commands can be allocated from. Each scsi command will carry
>>> + *    an unused/free command tag, which then can be used by the LLDD to
>>> + *    send internal or passthrough commands without having to find a
>>> + *    valid command tag internally.
>>> + */
>>> +struct scsi_device *scsi_get_host_dev(struct Scsi_Host *shost)
>>> +{
>>> +    struct scsi_device *sdev = NULL;
>>> +    struct scsi_target *starget;
>>> +
>>> +    mutex_lock(&shost->scan_mutex);
>>> +    if (!scsi_host_scan_allowed(shost))
>>> +        goto out;
>>> +    starget = scsi_alloc_target(&shost->shost_gendev, 0,
>>> +                    shost->max_id);
>>> +    if (!starget)
>>> +        goto out;
>>> +
>>> +    sdev = scsi_alloc_sdev(starget, 0, NULL);
>>> +    if (sdev)
>>> +        sdev->borken = 0;
>>> +    else
>>> +        scsi_target_reap(starget);
>>
>> Currently many scsi drivers fill some interfaces such as 
>> target_alloc()/slave_alloc() for real disks.
>> When allocating scsi target and scsi device for host dev, it will also 
>> call those interfaces, and not sure whether it breaks those drivers.
>>  From function sas_target_alloc() (common interface in libsas layer), 
>> it seems break it as there is no sas_rphy for host dev.
>>
> Ah. Didn't consider that.
> Will be having a look and fixup the patch.
> 
After giving it some more consideration, I don't think that this is the 
best way to go.

An update to make sas_target_alloc() work correctly would mean a change 
in the SAS topology, as we'd need to create an rphy for the host port, 
and have the host device using that as a parent.
But then this rphy doesn't really exist (as it's the SAS host itself), 
so we would either need to modify libsas to convert the SAS host into 
being able to serve as a port/phy, or add a 'fake' rphy for the SAS 
host. And in either case it would be a bigger surgery.

I'd rather prefer to add checks to libsas to figure out if a given SCSI 
device is a SAS device or a the SCSI host device; John Garry did some 
patches here to libsas.

But anyway, I would first want to concentrate on the API _how_ reserved 
tags should be allocated, and once we have that we can work on porting 
it to more complex things like libsas.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
