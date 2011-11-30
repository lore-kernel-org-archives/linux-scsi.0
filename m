From: Huajun Li <huajun.li.lee@gmail.com>
Subject: Re: [PATCH] SCSI/sd: Fix NULL dereference in sd_revalidate_disk
Date: Wed, 30 Nov 2011 22:43:18 +0800
Message-ID: <CA+v9cxYVJm1OwbBcctaeBE2Grfouh5tfYU6VD+Qhr2THkBG8Xg@mail.gmail.com>
References: <CA+v9cxbk0p_FTDq7TMEc5draOMz4n46H4t=iLe2brkosM=LHVw@mail.gmail.com>
	<20111126105146.756a122a@stein>
	<1322316009.5069.4.camel@dabdike.int.hansenpartnership.com>
	<CA+v9cxa+VbY6Oh800rHKjNQQL-zzk4jE8EUfKeamDgfuc800iw@mail.gmail.com>
	<CA+v9cxZCaz6JguvsqRsxVpx+Jqfg4QBBd1mqqTP0vRjo8na0og@mail.gmail.com>
	<1322361506.5069.20.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60358 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab1K3OnU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2011 09:43:20 -0500
Received: by ggnr5 with SMTP id r5so670297ggn.19
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2011 06:43:19 -0800 (PST)
In-Reply-To: <1322361506.5069.20.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Huajun Li <huajun.li.lee@gmail.com>

=D4=DA 2011=C4=EA11=D4=C227=C8=D5 =C9=CF=CE=E710:38=A3=ACJames Bottomle=
y
<James.Bottomley@hansenpartnership.com> =D0=B4=B5=C0=A3=BA
> On Sun, 2011-11-27 at 10:20 +0800, Huajun Li wrote:
>> =D4=DA 2011=C4=EA11=D4=C227=C8=D5 =C9=CF=CE=E79:28=A3=ACHuajun Li <h=
uajun.li.lee@gmail.com> =D0=B4=B5=C0=A3=BA
>> > =D4=DA 2011=C4=EA11=D4=C226=C8=D5 =CF=C2=CE=E710:00=A3=ACJames Bot=
tomley <jbottomley@parallels.com> =D0=B4=B5=C0=A3=BA
>> >> On Sat, 2011-11-26 at 10:51 +0100, Stefan Richter wrote:
>> >>> On Nov 24 Huajun Li wrote:
>> >>> >   While unplugging usb disk, scsi_disk(disk)->device  may be r=
eleased
>> >>> > before sd_revalidate_disk() is called, then there will occur O=
ops as
>> >>> > shown below:
>> >>> [...]
>> >>> > --- a/drivers/scsi/sd.c
>> >>> > +++ b/drivers/scsi/sd.c
>> >>> > @@ -2354,10 +2354,15 @@ static int sd_try_extended_inquiry(str=
uct
>> >>> > scsi_device *sdp)
>> >>> >  static int sd_revalidate_disk(struct gendisk *disk)
>> >>> >  {
>> >>> >     struct scsi_disk *sdkp =3D scsi_disk(disk);
>> >>> > -   struct scsi_device *sdp =3D sdkp->device;
>> >>> > +   struct scsi_device *sdp;
>> >>> >     unsigned char *buffer;
>> >>> >     unsigned flush =3D 0;
>> >>> >
>> >>> > +   if (sdkp)
>> >>> > +           sdp =3D sdkp->device;
>> >>> > +   else
>> >>> > +           goto out;
>> >>> > +
>> >>> >     SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
>> >>> >                                   "sd_revalidate_disk\n"));
>> >>> >
>> >>>
>> >>> Shouldn't rather the [block -- command-set-driver -- scsi-core -=
- lld]
>> >>> stack be structured along the lines that lower-level device inst=
ances live
>> >>> as long as higher levels rely on them?
>> >>
>> >> Not really, no.  The problem is the lifetime rules are complex.  =
The
>> >> lowest level objects actually live the longest because they're fi=
rst to
>> >> be discovered before we know what higher level functions to attac=
h.
>> >>
>> >> That's why you see complex paired gets in things like scsi_disk_g=
et
>> >> because we try to get references both to the sdkp and the underly=
ing
>> >> sdp ... so the sdkp can be torn down by last reference release fr=
om
>> >> either above or below (this is the menace of hot unplug).
>> >>
>> >>> For about a year now or so, I am seeing patches floating by that=
 add NULL
>> >>> pointer checks here and there (or patches that clear pointers), =
and every
>> >>> time I wonder
>> >>>   - where else such NULL pointer checks might be needed,
>> >>>   - in what way (if at all) it is ensured that a function which =
is made to
>> >>>     check for a valid pointer at the top does not race with poin=
ter
>> >>>     invalidation further down the road.
>> >>
>> >> I agree.  The patch is clearly wrong because sdkp is a refcounted=
 object
>> >> that never actually sets sdkp->device to NULL.  If we find a NULL=
 in
>> >> there it must be because the sdkp object is wrong.  The implicati=
on from
>> >> the trace seems to be that something allowed blkid to open a non
>> >> existent device.
>> >>
>> >> James
>> >>
>> >>
>> >
>> > Thanks for your response.
>> >
>> > Yes, in this case, actually sdkp is NULL rather than sdkp->device,=
 and
>> > the patch indicates this.
>> > However, there is typo in my comments, maybe it misleads you, sorr=
y!
>> > In fact, the comment should be:
>
> No, it's not that ... it's how did the open get far enough to do the
> revalidation?
>
>> > " While unplugging usb disk, scsi_disk(disk)  may be released
>> >  before sd_revalidate_disk() is called, then there will occur Oops=
=2E"
>> >
>>
>> BTW, after applied the patch and repeatedly plug/unplug the USB stic=
k,
>> I did not see this crash.
>>
>> However, the other concern is, need we validate scsi_disk(disk) in
>> some other functions specified in sd_fops ?  since they may be also
>> called from other layer after  scsi_disk(disk) is released.
>
> No, it's nothing to do with that.  To call any of the block operation=
s,
> you need to call ->open successfully first.  since ->open either gets=
 a
> ref to the sdkp or returns an error, how did we happen to be in
> sd_revalidate with a NULL sdkp?
>

Hi James,
Thanks for your hints.

Here is a case may cause sd_revalidate_disk() triggered with a NULL sdk=
p:
In sd_open(), if the removable medium does not present, it will call
scsi_disk_put(sdkp) and return -ENOMEDIUM,  then scsi_disk_put() may
cause scsi_disk_release() called and sdkp get freed.

In consequence, while __blkdev_get()  calling disk->fops->open(), it
will trigger rescan_partitions() if  ->open returns -ENOMEDIUM,
finally sd_revalidate_disk() will be called with a NULL sdkp.

BTW, I tried above path, it really could happen on my host. :)

> The call trace says we came through rescan_partitions() which only
> happens if ->open returns zero (or -ERESTARTSYS).
>

Not exactly. It happens if  ->open returns zero or -ENOMEDIUM, please
see this commit:
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcomm=
itdiff;h=3D1196f8b814f32cd04df334abf47648c2a9fd8324


Thanks,
--Huajun
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
