From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Time to make dynamically allocated devt the default for scsi disks?
Date: Sat, 13 Aug 2016 11:27:22 -0700
Message-ID: <CAPcyv4gHq=RraHgcJGx_txk7YJHC8YQ3gCT4CHL0hvzsGpU1wg@mail.gmail.com>
References: <CAPcyv4jK8W52ss2FhJDa=95B_1q8Szv4AmH0f7p_jzyfEXv0Ag@mail.gmail.com>
 <1471047451.2407.95.camel@HansenPartnership.com> <CAPcyv4jqEaBY1atyrjG3G4PYOzaoLvAMfHgK1PD0Si=MRRwAuw@mail.gmail.com>
 <CAPcyv4i=85fCAm1A5Zh2+nYSw7vwXOD=i-B0g4m2eJ+XkEW3tw@mail.gmail.com>
 <1471101800.2397.9.camel@HansenPartnership.com> <CAPcyv4gDw49gZBO=Y+K9krgth68OUHcs8urGDNXiZzLNa6kotg@mail.gmail.com>
 <1471110212.2397.39.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33930 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbcHNJ4R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Aug 2016 05:56:17 -0400
Received: by mail-oi0-f42.google.com with SMTP id l203so31861264oib.1
        for <linux-scsi@vger.kernel.org>; Sun, 14 Aug 2016 02:56:16 -0700 (PDT)
In-Reply-To: <1471110212.2397.39.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Dave Hansen <dave.hansen@intel.com>

On Sat, Aug 13, 2016 at 10:43 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Sat, 2016-08-13 at 09:29 -0700, Dan Williams wrote:
>> On Sat, Aug 13, 2016 at 8:23 AM, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>> > It does?  The race is the fact that the parent can be removed
>> > before the child meaning if the parent name is re-registered before
>> > the child dies we get a duplicate name in bdi space.
>>
>> No, the race is that the *name* of the parent isn't released until
>> the child is both unregistered and put.  The device core is already
>> ensuring that the parent is not released until all descendants have
>> been removed.
>
> We're both saying the same thing: the problem is that, with
> df08c32ce3be the bdi name lifetime is tied to the lifetime of the
> gendisk.  However, the parent of the gendisk currently is only tied to
> the visibility lifetime of the gendisk, not the final put lifetime, so
> it doesn't see this.
>
>> >
>> > > So I tried the attached and it makes the libnvdimm unit tests
>> > > start crashing.
>> >
>> > Well, the attached is clearly buggy, isn't it?  You're trying to do
>> > a get on the parent before the parent is actually set.
>>
>> Ah, yes, thank you.  Fixed up v2 attached that passes my tests.
>>
>> > Why don't you just try the incremental patch I sent instead of
>> > trying to rework it?
>>
>> I reworked it because it is the bdi that holds this extra dependency
>> on the disk's parent, not the disk itself.
>
> Philosophically I don't like this approach.  The dependency goes
>
> bdi->gendisk->parent

I'm arguing that there is no bdi->gendisk dependency.

The dependency is:

bdi->devt

It just so happens that block-dynamic devt is released in disk_release().

> Making the bdi manage the parent lifetime is an unusual pattern.
>  Making the parent stay around until the last reference to gendisk is
> put is the usual one.

What's unusual is the bdi's dependency on the allocated name, not the
gendisk itself.

>> > >   A couple crash logs attached.  Not yet sure what assumption
>> > > is getting violated, but how about that conversion of scsi to use
>> > > dynamic devt? ;-)
>> >
>> > It's completely orthogonal.  The problem is in hierarchy lifetimes:
>> > switching from static to dynamic allocation won't change that at
>> > all.  You don't see this problem in nvme because the parent control
>> > device's lifetime belongs to the controller not the disk.  In SCSI
>> > the parent is our representation of the SCSI device whose lifetime
>> > is governed at the SCSI level and effectively represents the disk.
>> >
>>
>> No, it's only the name.  We could achieve the same by teaching the
>> block core to manage the "sd_index_ida" instead of the sd driver
>> itself, but the v2-patch attached works and does not introduce that
>> layering violation.
>
> Um, so this patch doesn't fix the problem. It merely makes the lifetime
> rules correct so the problem can then be fixed at the scsi level.

You're right that this patch does not fix the problem, I missed that
the scsi_disk is not the parent of the gendisk, so this patch does
nothing to delay scsi_disk_release.  What I think is the real fix is
to make the devt properly reference counted and prevent
ida_remove(&sd_index_ida, sdkp->index); from being called until all
objects derived from that allocation are done with it.
