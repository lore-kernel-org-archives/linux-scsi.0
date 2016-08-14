From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Time to make dynamically allocated devt the default for scsi disks?
Date: Sun, 14 Aug 2016 11:08:16 -0700
Message-ID: <CAPcyv4i4vyXc-qigqVo9oBL-7n9g4cbhK9Yt0o2F_bCPqMSF1Q@mail.gmail.com>
References: <CAPcyv4jK8W52ss2FhJDa=95B_1q8Szv4AmH0f7p_jzyfEXv0Ag@mail.gmail.com>
 <1471047451.2407.95.camel@HansenPartnership.com> <CAPcyv4jqEaBY1atyrjG3G4PYOzaoLvAMfHgK1PD0Si=MRRwAuw@mail.gmail.com>
 <CAPcyv4i=85fCAm1A5Zh2+nYSw7vwXOD=i-B0g4m2eJ+XkEW3tw@mail.gmail.com>
 <1471101800.2397.9.camel@HansenPartnership.com> <CAPcyv4gDw49gZBO=Y+K9krgth68OUHcs8urGDNXiZzLNa6kotg@mail.gmail.com>
 <1471110212.2397.39.camel@HansenPartnership.com> <CAPcyv4gHq=RraHgcJGx_txk7YJHC8YQ3gCT4CHL0hvzsGpU1wg@mail.gmail.com>
 <1471195252.2355.18.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:36601 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932697AbcHNSI7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Aug 2016 14:08:59 -0400
Received: by mail-oi0-f54.google.com with SMTP id f189so39033020oig.3
        for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2016 11:08:18 -0700 (PDT)
In-Reply-To: <1471195252.2355.18.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Dave Hansen <dave.hansen@intel.com>

On Sun, Aug 14, 2016 at 10:20 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sat, 2016-08-13 at 11:27 -0700, Dan Williams wrote:
>> On Sat, Aug 13, 2016 at 10:43 AM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > On Sat, 2016-08-13 at 09:29 -0700, Dan Williams wrote:
>> > > On Sat, Aug 13, 2016 at 8:23 AM, James Bottomley
>> > > <James.Bottomley@hansenpartnership.com> wrote:
>> > > > It does?  The race is the fact that the parent can be removed
>> > > > before the child meaning if the parent name is re-registered
>> > > > before the child dies we get a duplicate name in bdi space.
>> > >
>> > > No, the race is that the *name* of the parent isn't released
>> > > until the child is both unregistered and put.  The device core is
>> > > already ensuring that the parent is not released until all
>> > > descendants have been removed.
>> >
>> > We're both saying the same thing: the problem is that, with
>> > df08c32ce3be the bdi name lifetime is tied to the lifetime of the
>> > gendisk.  However, the parent of the gendisk currently is only tied
>> > to the visibility lifetime of the gendisk, not the final put
>> > lifetime, so it doesn't see this.
>> >
>> > > >
>> > > > > So I tried the attached and it makes the libnvdimm unit tests
>> > > > > start crashing.
>> > > >
>> > > > Well, the attached is clearly buggy, isn't it?  You're trying
>> > > > to do a get on the parent before the parent is actually set.
>> > >
>> > > Ah, yes, thank you.  Fixed up v2 attached that passes my tests.
>> > >
>> > > > Why don't you just try the incremental patch I sent instead of
>> > > > trying to rework it?
>> > >
>> > > I reworked it because it is the bdi that holds this extra
>> > > dependency on the disk's parent, not the disk itself.
>> >
>> > Philosophically I don't like this approach.  The dependency goes
>> >
>> > bdi->gendisk->parent
>>
>> I'm arguing that there is no bdi->gendisk dependency.
>
> You created one with your bdi->owner field.  Just because you didn't
> call it a parent doesn't mean it wasn't one.  Arguably the whole bdi
> thing is strangely done because gendisk treats it like a class and
> that's how it behaves, it just doesn't have a proper class structure
> (which is why gendisk creates the link that would be done by the class
> infrastructure)
>
>> The dependency is:
>>
>> bdi->devt
>
> devt isn't a device (in the struct device sense).  It exists as
> effectively an embedded component of the bdi.  As far as I can tell
> there's no reason for it to be separately allocated, it could be
> properly embedded as is the normal pattern.
>
>> It just so happens that block-dynamic devt is released in
>> disk_release().
>>
>> > Making the bdi manage the parent lifetime is an unusual pattern.
>> >  Making the parent stay around until the last reference to gendisk
>> > is put is the usual one.
>>
>> What's unusual is the bdi's dependency on the allocated name, not the
>> gendisk itself.
>
> A name is just a resource belonging to an object.  The object it
> belongs to is the bdi and the bdi is parented by the owner field (and a
> hokey link) to the gendisk.
>
>> > > > >   A couple crash logs attached.  Not yet sure what assumption
>> > > > > is getting violated, but how about that conversion of scsi to
>> > > > > use dynamic devt? ;-)
>> > > >
>> > > > It's completely orthogonal.  The problem is in hierarchy
>> > > > lifetimes: switching from static to dynamic allocation won't
>> > > > change that at all.  You don't see this problem in nvme because
>> > > > the parent control device's lifetime belongs to the controller
>> > > > not the disk.  In SCSI the parent is our representation of the
>> > > > SCSI device whose lifetime is governed at the SCSI level and
>> > > > effectively represents the disk.
>> > > >
>> > >
>> > > No, it's only the name.  We could achieve the same by teaching
>> > > the block core to manage the "sd_index_ida" instead of the sd
>> > > driver itself, but the v2-patch attached works and does not
>> > > introduce that layering violation.
>> >
>> > Um, so this patch doesn't fix the problem. It merely makes the
>> > lifetime rules correct so the problem can then be fixed at the scsi
>> > level.
>>
>> You're right that this patch does not fix the problem, I missed that
>> the scsi_disk is not the parent of the gendisk, so this patch does
>> nothing to delay scsi_disk_release.  What I think is the real fix is
>> to make the devt properly reference counted and prevent
>> ida_remove(&sd_index_ida, sdkp->index); from being called until all
>> objects derived from that allocation are done with it.
>
> OK, this is another philosophical difference, I suppose: since bdi is
> already so complex and non-standard, I really don't think adding more
> non standard stuff is a good idea.  The simplest way to fix it is
>
>    1. The two line patch I already sent to make the bdi hold the owner
>       ->parent until release
>    2. Parent the gendisk to scsi_disk->dev.  The name release is already
>       in the correct place, so this is a 3 line patch.
>
> These are established patterns, so they're both understandable to
> anyone who reads the code.  The answer to any other BDI lifetime
> problem is to free the name in the parent release.
>
> James
>
> ---
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index d3e852a..222771d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3000,7 +3000,13 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
>         }
>
>         blk_pm_runtime_init(sdp->request_queue, dev);
> -       device_add_disk(dev, gd);
> +       /*
> +        * previously the parent of the gendisk was the scsi device.  It
> +        * was moved to fix lifetime rules, so now we install a symlink
> +        * to the new location of the block class directory
> +        */
> +       device_add_disk(&sdkp->dev, gd);
> +       WARN_ON(sysfs_add_link_to_group(&dev->kobj, "block", &sdkp->dev.kobj, "block"));
>         if (sdkp->capacity)
>                 sd_dif_config_host(sdkp);
>
> @@ -3142,6 +3148,7 @@ static int sd_remove(struct device *dev)
>
>         async_synchronize_full_domain(&scsi_sd_pm_domain);
>         async_synchronize_full_domain(&scsi_sd_probe_domain);
> +       sysfs_remove_link(&dev->kobj, "block");
>         device_del(&sdkp->dev);
>         del_gendisk(sdkp->disk);
>         sd_shutdown(dev);

I like it.  I still think the bdi registration code should be in
charge of taking the extra reference on the disk device's parent to
isolate / make clear why the extra reference is being acquired, but I
won't lose sleep if Jens takes your smaller change.

Thanks James!
