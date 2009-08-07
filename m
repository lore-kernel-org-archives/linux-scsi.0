From: "Davidlohr Bueso A." <dave@gnu.org>
Subject: Re: [PATCH] drivers/scsi: Check NULL for kmalloc() return
Date: Fri, 7 Aug 2009 16:42:21 -0400
Message-ID: <20090807204221.GA2380@fencepost.gnu.org>
References: <20090807183953.GA22286@fencepost.gnu.org> <Pine.LNX.4.64.0908072054080.8253@ask.diku.dk> <20090807194429.GA23615@fencepost.gnu.org> <Pine.LNX.4.64.0908072155260.8253@ask.diku.dk> <20090807201700.GB23615@fencepost.gnu.org> <154e089b0908071333l1d19545ay2dfaee89366120a5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:43128 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932143AbZHGUmV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 16:42:21 -0400
Content-Disposition: inline
In-Reply-To: <154e089b0908071333l1d19545ay2dfaee89366120a5@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Eder <hannes@hanneseder.net>
Cc: Julia Lawall <julia@diku.dk>, kraxel@bytesex.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Fri, Aug 07, 2009 at 10:33:36PM +0200, Hannes Eder wrote:
> On Fri, Aug 7, 2009 at 22:17, Davidlohr Bueso A.<dave@gnu.org> wrote:
> > On Fri, Aug 07, 2009 at 09:56:48PM +0200, Julia Lawall wrote:
> >> On Fri, 7 Aug 2009, Davidlohr Bueso A. wrote:
> >>
> >> > On Fri, Aug 07, 2009 at 08:54:44PM +0200, Julia Lawall wrote:
> >> > > On Fri, 7 Aug 2009, Davidlohr Bueso A. wrote:
> >> > >
> >> > > > Verify that ch->dt is not NULL before using it:
> >> > > > ch-dt[elem] =3D value;
> >> > >
> >> > > It looks like buffer should be freed as well?
> >> >
> >> > The way I see it, this is done in ch_remove()
> >>
> >> I don't see that at all. =C2=A0buffer appears to be a variable tha=
t is local to
> >> ch_readconfig and is passed down to other functions, but never sav=
ed
> >> anywhere. =C2=A0Furthermore buffer is freed in the normal exit of =
the function,
> >> so it seems likely that it should be freed on an early exit as wel=
l.
> >
> > Sorry, misread, for some reason I thought you were talking about fr=
eeing ch->dt, correting patch.
> >
> > Thanks,
> > Davidlohr
> >
> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> >
> > ---
> > =C2=A0drivers/scsi/ch.c | =C2=A0 =C2=A06 ++++++
> > =C2=A01 files changed, 6 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
> > index 7b1633a..bb42ceb 100644
> > --- a/drivers/scsi/ch.c
> > +++ b/drivers/scsi/ch.c
> > @@ -353,6 +353,12 @@ ch_readconfig(scsi_changer *ch)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0/* look up the devices of the data trans=
fer elements */
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0ch->dt =3D kmalloc(ch->counts[CHET_DT]*s=
izeof(struct scsi_device),
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 GFP_KERNEL);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 if (!ch->dt) {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 free(buffer);
>=20
> kfree(buffer) ?

Wow, unbelievable, that'll teach me!

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/ch.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7b1633a..fe11c1d 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -353,6 +353,12 @@ ch_readconfig(scsi_changer *ch)
        /* look up the devices of the data transfer elements */
        ch->dt =3D kmalloc(ch->counts[CHET_DT]*sizeof(struct scsi_devic=
e),
                         GFP_KERNEL);
+
+       if (!ch->dt) {
+               kfree(buffer);
+               return -ENOMEM;
+       }
+
        for (elem =3D 0; elem < ch->counts[CHET_DT]; elem++) {
                id  =3D -1;
                lun =3D 0;
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
