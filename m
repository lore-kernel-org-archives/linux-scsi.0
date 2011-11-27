From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI/sd: Fix NULL dereference in sd_revalidate_disk
Date: Sat, 26 Nov 2011 20:38:26 -0600
Message-ID: <1322361506.5069.20.camel@dabdike.int.hansenpartnership.com>
References: <CA+v9cxbk0p_FTDq7TMEc5draOMz4n46H4t=iLe2brkosM=LHVw@mail.gmail.com>
	 <20111126105146.756a122a@stein>
	 <1322316009.5069.4.camel@dabdike.int.hansenpartnership.com>
	 <CA+v9cxa+VbY6Oh800rHKjNQQL-zzk4jE8EUfKeamDgfuc800iw@mail.gmail.com>
	 <CA+v9cxZCaz6JguvsqRsxVpx+Jqfg4QBBd1mqqTP0vRjo8na0og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43987 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821Ab1K0Cia (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Nov 2011 21:38:30 -0500
In-Reply-To: <CA+v9cxZCaz6JguvsqRsxVpx+Jqfg4QBBd1mqqTP0vRjo8na0og@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Sun, 2011-11-27 at 10:20 +0800, Huajun Li wrote:
> =E5=9C=A8 2011=E5=B9=B411=E6=9C=8827=E6=97=A5 =E4=B8=8A=E5=8D=889:28=EF=
=BC=8CHuajun Li <huajun.li.lee@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> > =E5=9C=A8 2011=E5=B9=B411=E6=9C=8826=E6=97=A5 =E4=B8=8B=E5=8D=8810:=
00=EF=BC=8CJames Bottomley <jbottomley@parallels.com> =E5=86=99=E9=81=93=
=EF=BC=9A
> >> On Sat, 2011-11-26 at 10:51 +0100, Stefan Richter wrote:
> >>> On Nov 24 Huajun Li wrote:
> >>> >   While unplugging usb disk, scsi_disk(disk)->device  may be re=
leased
> >>> > before sd_revalidate_disk() is called, then there will occur Oo=
ps as
> >>> > shown below:
> >>> [...]
> >>> > --- a/drivers/scsi/sd.c
> >>> > +++ b/drivers/scsi/sd.c
> >>> > @@ -2354,10 +2354,15 @@ static int sd_try_extended_inquiry(stru=
ct
> >>> > scsi_device *sdp)
> >>> >  static int sd_revalidate_disk(struct gendisk *disk)
> >>> >  {
> >>> >     struct scsi_disk *sdkp =3D scsi_disk(disk);
> >>> > -   struct scsi_device *sdp =3D sdkp->device;
> >>> > +   struct scsi_device *sdp;
> >>> >     unsigned char *buffer;
> >>> >     unsigned flush =3D 0;
> >>> >
> >>> > +   if (sdkp)
> >>> > +           sdp =3D sdkp->device;
> >>> > +   else
> >>> > +           goto out;
> >>> > +
> >>> >     SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp,
> >>> >                                   "sd_revalidate_disk\n"));
> >>> >
> >>>
> >>> Shouldn't rather the [block -- command-set-driver -- scsi-core --=
 lld]
> >>> stack be structured along the lines that lower-level device insta=
nces live
> >>> as long as higher levels rely on them?
> >>
> >> Not really, no.  The problem is the lifetime rules are complex.  T=
he
> >> lowest level objects actually live the longest because they're fir=
st to
> >> be discovered before we know what higher level functions to attach=
=2E
> >>
> >> That's why you see complex paired gets in things like scsi_disk_ge=
t
> >> because we try to get references both to the sdkp and the underlyi=
ng
> >> sdp ... so the sdkp can be torn down by last reference release fro=
m
> >> either above or below (this is the menace of hot unplug).
> >>
> >>> For about a year now or so, I am seeing patches floating by that =
add NULL
> >>> pointer checks here and there (or patches that clear pointers), a=
nd every
> >>> time I wonder
> >>>   - where else such NULL pointer checks might be needed,
> >>>   - in what way (if at all) it is ensured that a function which i=
s made to
> >>>     check for a valid pointer at the top does not race with point=
er
> >>>     invalidation further down the road.
> >>
> >> I agree.  The patch is clearly wrong because sdkp is a refcounted =
object
> >> that never actually sets sdkp->device to NULL.  If we find a NULL =
in
> >> there it must be because the sdkp object is wrong.  The implicatio=
n from
> >> the trace seems to be that something allowed blkid to open a non
> >> existent device.
> >>
> >> James
> >>
> >>
> >
> > Thanks for your response.
> >
> > Yes, in this case, actually sdkp is NULL rather than sdkp->device, =
and
> > the patch indicates this.
> > However, there is typo in my comments, maybe it misleads you, sorry=
!
> > In fact, the comment should be:

No, it's not that ... it's how did the open get far enough to do the
revalidation?

> > " While unplugging usb disk, scsi_disk(disk)  may be released
> >  before sd_revalidate_disk() is called, then there will occur Oops.=
"
> >
>=20
> BTW, after applied the patch and repeatedly plug/unplug the USB stick=
,
> I did not see this crash.
>=20
> However, the other concern is, need we validate scsi_disk(disk) in
> some other functions specified in sd_fops ?  since they may be also
> called from other layer after  scsi_disk(disk) is released.

No, it's nothing to do with that.  To call any of the block operations,
you need to call ->open successfully first.  since ->open either gets a
ref to the sdkp or returns an error, how did we happen to be in
sd_revalidate with a NULL sdkp?

The call trace says we came through rescan_partitions() which only
happens if ->open returns zero (or -ERESTARTSYS).

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
