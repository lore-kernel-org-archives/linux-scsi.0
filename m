Return-Path: <SRS0=b1yV=7H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 855D0C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 16:47:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69EEA2070A
	for <linux-scsi@archiver.kernel.org>; Mon, 25 May 2020 16:47:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391233AbgEYQrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 May 2020 12:47:52 -0400
Received: from smtp.infotech.no ([82.134.31.41]:47420 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387766AbgEYQrw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 May 2020 12:47:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 027DB204238;
        Mon, 25 May 2020 18:47:50 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MCUPr7P08WfG; Mon, 25 May 2020 18:47:43 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 31A3A204165;
        Mon, 25 May 2020 18:47:41 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [RFC v2 3/6] scsi: xarray mark sdev_del state
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20200524155814.5895-1-dgilbert@interlog.com>
 <20200524155814.5895-4-dgilbert@interlog.com>
 <3e2b3737-879c-0d65-030b-a48556268cba@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <725901b9-6a52-a5db-5eb8-f58a00f3a4ab@interlog.com>
Date:   Mon, 25 May 2020 12:47:40 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <3e2b3737-879c-0d65-030b-a48556268cba@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-25 3:00 a.m., Hannes Reinecke wrote:
> On 5/24/20 5:58 PM, Douglas Gilbert wrote:
>> One of the features of an xarray is the ability to mark the pointers
>> that it holds. Sadly there are only two marks available per xarray so
>> it is not possible to map marks to the sdev_state enumeration which
>> holds 9 states. Since several loops skip sdev_s in SDEV_DEL state
>> then its negation was chosen as one mark: SCSI_XA_NON_SDEV_DEL.
>>
>> To support this mark a new iterator macro:
>>    shost_for_each_non_del_device(sdev, shost)
>> has been introduced plus a helper function:
>>     __scsi_iterate_non_del_devices(shost, sdev).
>> The new iterator macro is used once (in scsi_scan.c) and the new
>> mark is used directly in three other loops. The machinery to support
>> the mark is placed in a helper (scsi_adjust_non_sdev_del_mark())
>> called mainly by scsi_device_set_state(). Other locations that set
>> sdev_state were checked and some additional calls to that helper
>> were added.
>>
>> Following a complaint from 'make W=1' the formal name of a parameter
>> to both starget_for_each_device() and __starget_for_each_device()
>> was changed from starg to starget.
>>
>> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
>> ---
>>   drivers/scsi/scsi.c        | 49 +++++++++++++++++++++++++++++++++-----
>>   drivers/scsi/scsi_lib.c    | 34 ++++++++++++++++++++++++--
>>   drivers/scsi/scsi_scan.c   | 14 +++++------
>>   drivers/scsi/scsi_sysfs.c  | 19 +++++++++------
>>   include/scsi/scsi_device.h | 19 +++++++++++++++
>>   include/scsi/scsi_host.h   |  2 ++
>>   6 files changed, 114 insertions(+), 23 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
>> index aa3240f7aed9..0fb650aebcfb 100644
>> --- a/drivers/scsi/scsi.c
>> +++ b/drivers/scsi/scsi.c
>> @@ -588,6 +588,45 @@ struct scsi_device *__scsi_iterate_devices(struct 
>> Scsi_Host *shost,
>>   }
>>   EXPORT_SYMBOL(__scsi_iterate_devices);
>> +/* helper for shost_for_each_non_del_device, see that for documentation */
>> +struct scsi_device *__scsi_iterate_non_del_devices(struct Scsi_Host *shost,
>> +                           struct scsi_device *prev)
>> +{
>> +    struct scsi_device *next = prev;
>> +    unsigned long flags, l_idx;
>> +
>> +    spin_lock_irqsave(shost->host_lock, flags);
>> +    if (xa_empty(&shost->__devices)) {
>> +        next = NULL;
>> +        goto unlock;
>> +    }
>> +    do {
>> +        if (!next) {    /* get first element iff first iteration */
>> +            l_idx = 0;
>> +            next = xa_find(&shost->__devices, &l_idx,
>> +                       scsi_xa_limit_16b.max,
>> +                       SCSI_XA_NON_SDEV_DEL);
>> +        } else {
>> +            l_idx = next->sh_idx,
>> +            next = xa_find_after(&shost->__devices, &l_idx,
>> +                         scsi_xa_limit_16b.max,
>> +                         SCSI_XA_NON_SDEV_DEL);
>> +        }
>> +        if (next) {
>> +            /* skip devices that we can't get a reference to */
>> +            if (!scsi_device_get(next))
>> +                break;
>> +        }
>> +    } while (next);
>> +unlock:
>> +    spin_unlock_irqrestore(shost->host_lock, flags);
>> +
>> +    if (prev)
>> +        scsi_device_put(prev);
>> +    return next;
>> +}
>> +EXPORT_SYMBOL(__scsi_iterate_non_del_devices);
>> +
>>   /* helper for starg_for_each_device, see that for documentation */
>>   struct scsi_device *__scsi_target_iterate_devices(struct scsi_target *starg,
>>                             struct scsi_device *prev)
>> @@ -695,9 +734,8 @@ struct scsi_device *__scsi_device_lookup_by_target(struct 
>> scsi_target *starget,
>>       unsigned long l_idx;
>>       struct scsi_device *sdev;
>> -    xa_for_each(&starget->devices, l_idx, sdev) {
>> -        if (sdev->sdev_state == SDEV_DEL)
>> -            continue;
>> +    xa_for_each_marked(&starget->devices, l_idx, sdev,
>> +               SCSI_XA_NON_SDEV_DEL) {
>>           if (sdev->lun ==lun)
>>               return sdev;
>>       }
>> @@ -754,9 +792,8 @@ struct scsi_device *__scsi_device_lookup(struct Scsi_Host 
>> *shost,
>>       unsigned long l_idx;
>>       struct scsi_device *sdev;
>> -    xa_for_each(&shost->__devices, l_idx, sdev) {
>> -        if (sdev->sdev_state == SDEV_DEL)
>> -            continue;
>> +    xa_for_each_marked(&shost->__devices, l_idx, sdev,
>> +               SCSI_XA_NON_SDEV_DEL) {
>>           if (sdev->channel == channel && sdev->id == id &&
>>                   sdev->lun ==lun)
>>               return sdev;
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 68df68f54fc8..f484bf2b5d7d 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -2217,6 +2217,27 @@ scsi_test_unit_ready(struct scsi_device *sdev, int 
>> timeout, int retries,
>>   }
>>   EXPORT_SYMBOL(scsi_test_unit_ready);
>> +/* Assume host_lock taken and that xahp->xa_lock is the same lock. */
>> +static inline void
>> +scsi_adjust_non_sdev_del_mark(struct scsi_device *sdev,
>> +                  enum scsi_device_state old_state,
>> +                  enum scsi_device_state new_state)
>> +{
>> +    struct xarray *xatp =
>> +            &to_scsi_target(sdev->sdev_gendev.parent)->devices;
>> +    struct xarray *xahp = &sdev->host->__devices;
>> +
>> +    if (old_state == new_state)
>> +        return;
>> +    if (old_state == SDEV_DEL) {
>> +        xa_set_mark(xatp, sdev->starg_idx, SCSI_XA_NON_SDEV_DEL);
>> +        xa_set_mark(xahp, sdev->sh_idx, SCSI_XA_NON_SDEV_DEL);
>> +    } else if (new_state == SDEV_DEL) {
>> +        xa_clear_mark(xatp, sdev->starg_idx, SCSI_XA_NON_SDEV_DEL);
>> +        xa_clear_mark(xahp, sdev->sh_idx, SCSI_XA_NON_SDEV_DEL);
>> +    }
>> +}
>> +
>>   /**
>>    *    scsi_device_set_state - Take the given device through the device state 
>> model.
>>    *    @sdev:    scsi device to change the state of.
>> @@ -2330,6 +2351,8 @@ scsi_device_set_state(struct scsi_device *sdev, enum 
>> scsi_device_state state)
>>       }
>>       sdev->offline_already = false;
>> +    if (unlikely(oldstate == SDEV_DEL || state == SDEV_DEL))
>> +        scsi_adjust_non_sdev_del_mark(sdev, oldstate, state);
>>       sdev->sdev_state = state;
>>       return 0;
>> @@ -2731,14 +2754,21 @@ int scsi_internal_device_unblock_nowait(struct 
>> scsi_device *sdev,
>>       switch (sdev->sdev_state) {
>>       case SDEV_BLOCK:
>>       case SDEV_TRANSPORT_OFFLINE:
>> +        if (unlikely(new_state == SDEV_DEL))
>> +            scsi_adjust_non_sdev_del_mark(sdev, sdev->sdev_state,
>> +                              SDEV_DEL);
>>           sdev->sdev_state = new_state;
>>           break;
>>       case SDEV_CREATED_BLOCK:
>>           if (new_state == SDEV_TRANSPORT_OFFLINE ||
>> -            new_state == SDEV_OFFLINE)
>> +            new_state == SDEV_OFFLINE) {
>>               sdev->sdev_state = new_state;
>> -        else
>> +        } else {
>> +            if (unlikely(new_state == SDEV_DEL))
>> +                scsi_adjust_non_sdev_del_mark
>> +                    (sdev, sdev->sdev_state, SDEV_DEL);
>>               sdev->sdev_state = SDEV_CREATED;
>> +        }
>>           break;
>>       case SDEV_CANCEL:
>>       case SDEV_OFFLINE:
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index 72a0064a879a..f5a5e48ca5ae 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -280,7 +280,7 @@ static struct scsi_device *scsi_alloc_sdev(struct 
>> scsi_target *starget,
>>       scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun ?
>>                       sdev->host->cmd_per_lun : 1);
>> -    scsi_sysfs_device_initialize(sdev);
>> +    scsi_sysfs_device_initialize(sdev);    /* marked as non_sdev_del */
>>       if (shost->hostt->slave_alloc) {
>>           ret = shost->hostt->slave_alloc(sdev);
>> @@ -1708,10 +1708,9 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, 
>> unsigned int channel,
>>   static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
>>   {
>>       struct scsi_device *sdev;
>> -    shost_for_each_device(sdev, shost) {
>> -        /* target removed before the device could be added */
>> -        if (sdev->sdev_state == SDEV_DEL)
>> -            continue;
>> +
>> +    /* target may be removed before devices could be added */
>> +    shost_for_each_non_del_device(sdev, shost) {
>>           /* If device is already visible, skip adding it to sysfs */
>>           if (sdev->is_visible)
>>               continue;
>> @@ -1883,9 +1882,8 @@ void scsi_forget_host(struct Scsi_Host *shost)
>>    restart:
>>       spin_lock_irqsave(shost->host_lock, flags);
>> -    xa_for_each(&shost->__devices, l_idx, sdev) {
>> -        if (sdev->sdev_state == SDEV_DEL)
>> -            continue;
>> +    xa_for_each_marked(&shost->__devices, l_idx, sdev,
>> +               SCSI_XA_NON_SDEV_DEL) {
>>           spin_unlock_irqrestore(shost->host_lock, flags);
>>           __scsi_remove_device(sdev);
>>           goto restart;
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 4bfcf33139a2..6fdd4648f374 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1481,15 +1481,15 @@ static void __scsi_remove_target(struct scsi_target 
>> *starget)
>>       spin_lock_irqsave(shost->host_lock, flags);
>>    restart:
>> -    xa_for_each(&starget->devices, l_idx, sdev) {
>> +    xa_for_each_marked(&starget->devices, l_idx, sdev,
>> +               SCSI_XA_NON_SDEV_DEL) {
>>           /*
>>            * We cannot call scsi_device_get() here, as
>>            * we might've been called from rmmod() causing
>>            * scsi_device_get() to fail the module_is_live()
>>            * check.
>>            */
>> -        if (sdev->sdev_state == SDEV_DEL ||
>> -            sdev->sdev_state == SDEV_CANCEL ||
>> +        if (sdev->sdev_state == SDEV_CANCEL ||
>>               !get_device(&sdev->sdev_gendev))
>>               continue;
>>           spin_unlock_irqrestore(shost->host_lock, flags);
>> @@ -1621,16 +1621,21 @@ void scsi_sysfs_device_initialize(struct scsi_device 
>> *sdev)
>>       /* XARRAY: might add in hole */
>>       res = xa_alloc(&starget->devices, &u_idx, sdev, scsi_xa_limit_16b,
>>                  GFP_ATOMIC);
>> -    if (res < 0)
>> +    if (res < 0) {
>>           pr_err("%s: xa_alloc 1 failure errno=%d\n", __func__, -res);
>> -    else
>> +    } else {
>>           sdev->starg_idx = u_idx;
>> +        xa_set_mark(&starget->devices, u_idx, SCSI_XA_NON_SDEV_DEL);
>> +    }
>>       res = xa_alloc(&shost->__devices, &u_idx, sdev, scsi_xa_limit_16b,
>>                  GFP_ATOMIC);
>> -    if (res < 0)
>> +    if (res < 0) {
>>           pr_err("%s: xa_alloc 2 failure errno=%d\n", __func__, -res);
>> -    else
>> +    } else {
>>           sdev->sh_idx = u_idx;
>> +        /* already have host_lock which is shost->__devices.xa_lock */
>> +        xa_set_mark(&shost->__devices, u_idx, SCSI_XA_NON_SDEV_DEL);
>> +    }
>>       spin_unlock_irqrestore(shost->host_lock, flags);
>>       /*
>>        * device can now only be removed via __scsi_remove_device() so hold
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index 4219b8d1b94c..23bf686cbabc 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -372,6 +372,9 @@ extern void __starget_for_each_device(struct scsi_target 
>> *, void *,
>>   /* only exposed to implement shost_for_each_device */
>>   extern struct scsi_device *__scsi_iterate_devices(struct Scsi_Host *,
>>                             struct scsi_device *);
>> +/* only exposed to implement shost_for_each_non_del_device */
>> +extern struct scsi_device *__scsi_iterate_non_del_devices
>> +            (struct Scsi_Host *shost, struct scsi_device *sdev);
>>   /* only exposed to implement starg_for_each_device */
>>   extern struct scsi_device *__scsi_target_iterate_devices
>>                       (struct scsi_target *starg,
>> @@ -391,6 +394,22 @@ extern struct scsi_device *__scsi_target_iterate_devices
>>            (sdev); \
>>            (sdev) = __scsi_iterate_devices((shost), (sdev)))
>> +/**
>> + * shost_for_each_non_del_device - iterate over those scsi_devices that do not
>> + *                   have the SDEV_DEL state and are associated
>> + *                   with given host
>> + * @sdev: the &struct scsi_device to use as a cursor
>> + * @shost: the &struct Scsi_Host to iterate over
>> + *
>> + * Iterator that returns each device attached to @shost.  This loop
>> + * takes a reference on each device and releases it at the end.  If
>> + * you break out of the loop, you must call scsi_device_put(sdev).
>> + */
>> +#define shost_for_each_non_del_device(sdev, shost) \
>> +    for ((sdev) = __scsi_iterate_non_del_devices((shost), NULL); \
>> +         (sdev); \
>> +         (sdev) = __scsi_iterate_non_del_devices((shost), (sdev)))
>> +
>>   /* helper for __shost_for_each_device */
>>   static inline struct scsi_device *__scsi_h2d_1st_it(struct Scsi_Host *shost)
>>   {
>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>> index e6386f3d6de1..0e94b1feb8e9 100644
>> --- a/include/scsi/scsi_host.h
>> +++ b/include/scsi/scsi_host.h
>> @@ -33,6 +33,8 @@ struct scsi_transport_template;
>>   /* XARRAY: this limits number of devices (LUs) in host to 64K */
>>   #define scsi_xa_limit_16b    XA_LIMIT(0, USHRT_MAX)
>> +#define SCSI_XA_NON_SDEV_DEL XA_MARK_1
>> +
>>   struct scsi_host_template {
>>       struct module *module;
>>       const char *name;
>>
> Hmm.
> Nice idea, yet I'm not sure if it's worth the hassle.
> We still have to check additional conditions during the iterators;
> saving just one condition is probably not worth it.

Again, this was proof-of-concept. I believe it is useful. In this
case, the mark allows the code to know that a sdev is in SDEV_DELETE
state _without_ derefencing sdev. And that makes it inherently safer.

Also showing LLD coders how to use marks on xarrays and leaving at least
one unused might give them ideas for improving their code. For example
a mark for every sdev that is "in-flight" might make for a very
useful sub-list.


And if I understand xarrays correctly, the concept of:
     pointer_s[index]
can be replaced by:
     <32 or 64 set of bit_flags>_s[index]

with the restriction that <32 or 64 set of bit_flags> can't be 0. Also
I think some of those 32 or 64 bit positions are used, so deduct a few.
That way the collector (shost or starget) could hold the target or
LU states (e.g. replacing the need for an 'enum scsi_device_state'
member in sdev objects).

Doug Gilbert
