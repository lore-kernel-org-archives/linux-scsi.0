From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: Re: Bad module reference counter
Date: Fri, 20 Feb 2009 11:45:02 +0100
Message-ID: <200902201145.02308.stf_xl@wp.pl>
References: <200902111032.59225.stf_xl@wp.pl> <200902191348.44508.stf_xl@wp.pl> <200902191749.52740.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.wp.pl ([212.77.101.5]:38948 "EHLO mx1.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbZBTKpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Feb 2009 05:45:21 -0500
In-Reply-To: <200902191749.52740.bzolnier@gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Thursday 19 February 2009 17:49:52 Bartlomiej Zolnierkiewicz napisa=C5=82=
(a):
> > > Seems like ide_device_put() needs the same module_refcount() chec=
k that
> > > is present in scsi_device_put() so removal of device driver won't=
 trigger
> > > a spurious module_put() on a host driver?
> >=20
> > I little surprise about scsi code (linux-scsi ML CC). Is comment in=
side
> > scsi_device_put() function correct? Why scsi_device_get() not check
> > try_module_get() return value? And most importand: there is referen=
ce
> > counter check before put, so it can be 0, but data does it protect =
is in
> > use ?

Any comments?

> Uh... we will need some more intrusive changes to the reference count=
ing
> to fix it -- like to replace idkp->kref by idkp->dev and make drive->=
gendev
> a parent of it (so only after the final put on ->dev ->gendev can go =
away).
>=20
> [ IOW we need to have some changes similar to those done in sd.c by:
> 	commit 6bdaa1f17dd32ec62345c7b57842f53e6278a2fa
>   and later by:
> 	commit ee959b00c335d7780136c5abda37809191fe52c3 ]
>=20
> > There is no oops with my workaround, when I just remove ide_disk_pu=
t() from
>
> I suppose that after ide_disk_put() removal ide_disk_release() is sim=
ply
> never called... ;)
>=20
> > ide_gd_remove(). It's strange why there is lack of symmetrical _put=
/_get calls,
> > ide_gd_probe() has no call to ide_disk_get().=20
>=20
> We have kref_init() in ide_disk_probe(), so there is no need for it
> and we also don't want to hold an extra reference on host driver...

Looks that using ->dev insted of ->kref will do the work. But perhaps l=
ess
intrusive fix, like check kref in ide_disk_put() would be better soluti=
on.
I tested below patch and everythings is fine.

diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 7857b20..598f21b 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -48,8 +48,8 @@ static void ide_disk_put(struct ide_disk_obj *idkp)
 	ide_drive_t *drive =3D idkp->drive;
=20
 	mutex_lock(&ide_disk_ref_mutex);
-	kref_put(&idkp->kref, ide_disk_release);
-	ide_device_put(drive);
+	if (!kref_put(&idkp->kref, ide_disk_release))
+		ide_device_put(drive);
 	mutex_unlock(&ide_disk_ref_mutex);
 }
=20
If this patch is ok and dropping kref to dev is not planed currently, m=
aybe
I'll send "official" patch with ide-gd fix and for other devices types.

Regards
Stanislaw Gruszka
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
