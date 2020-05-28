Return-Path: <SRS0=GT1C=7K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D95C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 19:44:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2971A2078C
	for <linux-scsi@archiver.kernel.org>; Thu, 28 May 2020 19:44:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgE1Tov (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 May 2020 15:44:51 -0400
Received: from smtp.infotech.no ([82.134.31.41]:57973 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbgE1Tor (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 May 2020 15:44:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0393920418D;
        Thu, 28 May 2020 21:44:46 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id myeCyBJwOOuj; Thu, 28 May 2020 21:44:39 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 7E015204179;
        Thu, 28 May 2020 21:44:38 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 3/4] scsi: move target device list to xarray
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20200528163625.110184-1-hare@suse.de>
 <20200528163625.110184-4-hare@suse.de>
 <a6b85428-f32c-e57b-fa3e-e376400819ac@interlog.com>
 <20200528185402.GP17206@bombadil.infradead.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <40da0c89-054c-b02d-ce44-d4964cb9a228@interlog.com>
Date:   Thu, 28 May 2020 15:44:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200528185402.GP17206@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-28 2:54 p.m., Matthew Wilcox wrote:
> On Thu, May 28, 2020 at 01:50:02PM -0400, Douglas Gilbert wrote:
>> On 2020-05-28 12:36 p.m., Hannes Reinecke wrote:
>>> Use xarray for device lookup by target. LUNs below 256 are linear,
>>> and can be used directly as the index into the xarray.
>>> LUNs above 256 have a distinct LUN format, and are not necessarily
>>> linear. They'll be stored in indices above 256 in the xarray, with
>>> the next free index in the xarray.
> 
> I don't understand why you think this is an improvement over just
> using an allocating XArray for all LUNs.  It seems like more code,
> and doesn't actually save you any storage space ... ?
> 
>>> +++ b/drivers/scsi/scsi.c
>>> @@ -601,13 +601,14 @@ static struct scsi_target *__scsi_target_lookup(struct Scsi_Host *shost,
>>>    void starget_for_each_device(struct scsi_target *starget, void *data,
>>>    		     void (*fn)(struct scsi_device *, void *))
>>>    {
>>> -	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
>>>    	struct scsi_device *sdev;
>>> +	unsigned long lun_id = 0;
>>> -	shost_for_each_device(sdev, shost) {
>>> -		if ((sdev->channel == starget->channel) &&
>>> -		    (sdev->id == starget->id))
>>> -			fn(sdev, data);
>>> +	xa_for_each(&starget->devices, lun_id, sdev) {
>>> +		if (scsi_device_get(sdev))
>>> +			continue;
>>> +		fn(sdev, data);
>>> +		scsi_device_put(sdev);
>>>    	}
>>>    }
> 
> I appreciate you're implementing the API that's currently in use, but I would recommend open-coding this.  Looking at the functions called, lots of them
> are two-three liners, eg:
> 
> static void __scsi_report_device_reset(struct scsi_device *sdev, void *data)
> {
>          sdev->was_reset = 1;
>          sdev->expecting_cc_ua = 1;
> }
> 
> which would just be more readable:
> 
>          if (rtn == SUCCESS) {
> 		struct scsi_target *starget = scsi_target(scmd->device);
> 		struct scsi_device *sdev;
> 		unsigned long index;
> 
>                  spin_lock_irqsave(host->host_lock, flags);
> 		xa_for_each(&starget->devices, index, sdev) {
> 			sdev->was_reset = 1;
> 			sdev->expecting_cc_ua = 1;
> 		}
>                  spin_unlock_irqrestore(host->host_lock, flags);
>          }
> 
> And then maybe you could make a convincing argument that the spin_lock
> there could be turned into an xa_lock since that will prevent sdevs from
> coming & going during the iteration of the device list.

I tried that but ran into problems. The xarray model is clear enough,
but there is a (non-atomic) enumerated state in each sdev (struct
scsi_device object (pointer)) that is protected by a mutex.
I was unable to escape those pesky (but very useful) warnings out of
the depths of xarray that the locking was awry. When I've burrowed
into xarray.c I have usually found that it was correct. So now I regard
it as a pesky feature :-)

That said, in my work on the sg driver rewrite, I got rid of all
the explicit spinlocks in favour of xa_locks and that works fine, IMO.
The locking in the SCSI ML is a more complex beast. Maybe it doesn't
need to be ...


Hannes, why not make sdev_state an atomic and get rid of that mutex?

Virtually none of this code is on the command fastpath, but Ming Lei
found that trimming down the size and position of members in sdev
could lead to performance improvements.

These changes may improve the time taken to stabilize a system with large
disk arrays attached at startup, shutdown and when there are disruptions
or errors.

>>> @@ -1621,7 +1623,18 @@ void scsi_sysfs_device_initialize(struct scsi_device *sdev)
>>>    	transport_setup_device(&sdev->sdev_gendev);
>>>    	spin_lock_irqsave(shost->host_lock, flags);
>>> -	list_add_tail(&sdev->same_target_siblings, &starget->devices);
>>> +	if (sdev->lun < 256) {
>>> +		sdev->lun_idx = sdev->lun;
>>> +		WARN_ON(xa_insert(&starget->devices, sdev->lun_idx,
>>> +				   sdev, GFP_KERNEL) < 0);
>>
>> You have interrupts masked again, so GFP_KERNEL is a non-no.
> 
> Actually, I would say this is a great place to not use the host_lock.
> 
> +	int err;
> ...
> +	if (sdev->lun < 256) {
> +		sdev->lun_idx = sdev->lun;
> +		err = xa_insert_irq(&starget->devices, sdev->lun_idx, sdev,
> +				GFP_KERNEL);
> +	} else {
> +		err = xa_alloc_irq(&starget->devices, &sdev->lun_idx, sdev,
> +				scsi_lun_limit, GFP_KERNEL);
> +	}
> +	... maybe you want to convert scsi_sysfs_device_initialize()
> +	to return an errno, although honestly this should never fail ...
>          spin_lock_irqsave(shost->host_lock, flags);
> -       list_add_tail(&sdev->same_target_siblings, &starget->devices);
>          list_add_tail(&sdev->siblings, &shost->__devices);
>          spin_unlock_irqrestore(shost->host_lock, flags);
> 
> 
>>> +	unsigned int lun_idx;		/* Index into target device xarray */
>>
>> Xarray gives you _two_ choices for the type of an index :-)
>> It is either u32 (as used in xa_alloc() and its variants) _or_
>> unsigned long (as used everywhere else in xarray where an index
>> is needed). So it's definitely 32 bits for xa_alloc() and either
>> 32 or 64 bits for the rest of xarray depending on the machine
>> architecture.
>> Matthew Wilcox may care to explain why this is ...
> 
> Saving space in data structures, mostly.  It's not really useful to
> have 4 billion things in an allocating XArray.  Indeed, it's not really
> useful to have 4 billion of almost anything.  So we have XArrays which
> are indexed by something sensible like page index in file, and they're
> nice and well-behaved (most people don't create files in excess of 16TB,
> and those who do don't expect amazing performance when seeking around
> in them at random because they've lost all caching effects).  And then
> you have people who probably want one scsi device.  Maybe a dozen.
> Possibly a thousand.  Definitely not a million.  If you get 4 billion scsi
> devices, something's gone very wrong.  You've run out of drive letters,
> for a start (/dev/sdmzabcd anybody?)

    no_uld=1     # RAID cards might do this on its physicals so smartmontools
                 # can check them

Then you only have to worry about /dev/sg<n> and /dev/bsg/<hctl) numbers
or tuples going through the roof :-)

> It doesn't cost us anything to just use unsigned long as the index of an
> XArray, due to how it's constructed.  Except in this one place where we
> need to point to somewhere to store the index so that we can update the
> index within an sdev before anybody iterating the data structure under
> RCU can find the uninitialised index.
> 
> This patch seems decent enough ... I just think the decision to optimise
> the layout for LUNs < 256 is a bit odd.  But hey, your subsystem,
> not mine.

Hannes has the most experience in that area. He has only been using xarray
for a week or so (I think). There is something important missing from his
patchset: any xa_destroy() calls :-)

Doug Gilbert


