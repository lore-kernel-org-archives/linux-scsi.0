From: Huajun Li <huajun.li.lee@gmail.com>
Subject: Re: [PATCH] SCSI/sd: Fix NULL dereference in sd_revalidate_disk
Date: Sun, 27 Nov 2011 09:28:05 +0800
Message-ID: <CA+v9cxa+VbY6Oh800rHKjNQQL-zzk4jE8EUfKeamDgfuc800iw@mail.gmail.com>
References: <CA+v9cxbk0p_FTDq7TMEc5draOMz4n46H4t=iLe2brkosM=LHVw@mail.gmail.com>
	<20111126105146.756a122a@stein>
	<1322316009.5069.4.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46424 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab1K0B2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Nov 2011 20:28:07 -0500
Received: by bke11 with SMTP id 11so6343645bke.19
        for <linux-scsi@vger.kernel.org>; Sat, 26 Nov 2011 17:28:05 -0800 (PST)
In-Reply-To: <1322316009.5069.4.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Huajun Li <huajun.li.lee@gmail.com>

=D4=DA 2011=C4=EA11=D4=C226=C8=D5 =CF=C2=CE=E710:00=A3=ACJames Bottomle=
y <jbottomley@parallels.com> =D0=B4=B5=C0=A3=BA
> On Sat, 2011-11-26 at 10:51 +0100, Stefan Richter wrote:
>> On Nov 24 Huajun Li wrote:
>> >   While unplugging usb disk, scsi_disk(disk)->device  may be relea=
sed
>> > before sd_revalidate_disk() is called, then there will occur Oops =
as
>> > shown below:
>> [...]
>> > --- a/drivers/scsi/sd.c
>> > +++ b/drivers/scsi/sd.c
>> > @@ -2354,10 +2354,15 @@ static int sd_try_extended_inquiry(struct
>> > scsi_device *sdp)
>> >  static int sd_revalidate_disk(struct gendisk *disk)
>> >  {
>> >     struct scsi_disk *sdkp =3D scsi_disk(disk);
>> > -   struct scsi_device *sdp =3D sdkp->device;
>> > +   struct scsi_device *sdp;
>> >     unsigned char *buffer;
>> >     unsigned flush =3D 0;
>> >
>> > +   if (sdkp)
>> > +           sdp =3D sdkp->device;
>> > +   else
>> > +           goto out;
>> > +
>> >     SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
>> >                                   "sd_revalidate_disk\n"));
>> >
>>
>> Shouldn't rather the [block -- command-set-driver -- scsi-core -- ll=
d]
>> stack be structured along the lines that lower-level device instance=
s live
>> as long as higher levels rely on them?
>
> Not really, no.  The problem is the lifetime rules are complex.  The
> lowest level objects actually live the longest because they're first =
to
> be discovered before we know what higher level functions to attach.
>
> That's why you see complex paired gets in things like scsi_disk_get
> because we try to get references both to the sdkp and the underlying
> sdp ... so the sdkp can be torn down by last reference release from
> either above or below (this is the menace of hot unplug).
>
>> For about a year now or so, I am seeing patches floating by that add=
 NULL
>> pointer checks here and there (or patches that clear pointers), and =
every
>> time I wonder
>>   - where else such NULL pointer checks might be needed,
>>   - in what way (if at all) it is ensured that a function which is m=
ade to
>>     check for a valid pointer at the top does not race with pointer
>>     invalidation further down the road.
>
> I agree.  The patch is clearly wrong because sdkp is a refcounted obj=
ect
> that never actually sets sdkp->device to NULL.  If we find a NULL in
> there it must be because the sdkp object is wrong.  The implication f=
rom
> the trace seems to be that something allowed blkid to open a non
> existent device.
>
> James
>
>

Thanks for your response.

Yes, in this case, actually sdkp is NULL rather than sdkp->device, and
the patch indicates this.
However, there is typo in my comments, maybe it misleads you, sorry!
In fact, the comment should be:

" While unplugging usb disk, scsi_disk(disk)  may be released
 before sd_revalidate_disk() is called, then there will occur Oops."
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
