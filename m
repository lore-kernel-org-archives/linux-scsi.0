From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: Re: Bad module reference counter
Date: Wed, 25 Feb 2009 12:00:42 +0100
Message-ID: <200902251200.42517.stf_xl@wp.pl>
References: <200902111032.59225.stf_xl@wp.pl> <200902201145.02308.stf_xl@wp.pl> <200902232336.35371.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200902232336.35371.bzolnier@gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Monday 23 February 2009 23:36:35 Bartlomiej Zolnierkiewicz napisa=C5=82=
(a):
> > Looks that using ->dev insted of ->kref will do the work. But perha=
ps less
> > intrusive fix, like check kref in ide_disk_put() would be better so=
lution.
> > I tested below patch and everythings is fine.
> >=20
> > diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
> > index 7857b20..598f21b 100644
> > --- a/drivers/ide/ide-gd.c
> > +++ b/drivers/ide/ide-gd.c
> > @@ -48,8 +48,8 @@ static void ide_disk_put(struct ide_disk_obj *idk=
p)
> >  	ide_drive_t *drive =3D idkp->drive;
> > =20
> >  	mutex_lock(&ide_disk_ref_mutex);
> > -	kref_put(&idkp->kref, ide_disk_release);
> > -	ide_device_put(drive);
> > +	if (!kref_put(&idkp->kref, ide_disk_release))
> > +		ide_device_put(drive);
>=20
> I worry that this just masks the problem as according to your previou=
s
> mail drive still can be already gone before ->flush in ide_gd_remove(=
).

I checked my patch against all mentioned problems, but it doesn't matte=
r now.
=20
> >  	mutex_unlock(&ide_disk_ref_mutex);
> >  }
> > =20
> > If this patch is ok and dropping kref to dev is not planed currentl=
y, maybe
> > I'll send "official" patch with ide-gd fix and for other devices ty=
pes.
>=20
> Lets fix it fully.  The below patch together with previous ide_device=
_put()
> fix and drive_release_dev() one (from another mail) should make all p=
roblems
> go away...
>=20
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: fix refcounting in device drivers
>=20
> During host driver module removal del_gendisk() results in a final
> put on drive->gendev and freeing the drive by drive_release_dev().
>=20
> Convert device drivers from using struct kref to use struct device
> so device driver's object holds reference on ->gendev and prevents
> drive from prematurely going away.
>=20
> Also fix ->remove methods to not erroneously drop reference on a
> host driver by using only put_device() instead of ide*_put().
>=20
> Reported-by: Stanislaw Gruszka <stf_xl@wp.pl>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Tested-by: Stanislaw Gruszka <stf_xl@wp.pl>
