From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Bad module reference counter
Date: Mon, 23 Feb 2009 23:36:35 +0100
Message-ID: <200902232336.35371.bzolnier@gmail.com>
References: <200902111032.59225.stf_xl@wp.pl> <200902191749.52740.bzolnier@gmail.com> <200902201145.02308.stf_xl@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200902201145.02308.stf_xl@wp.pl>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Friday 20 February 2009, Stanislaw Gruszka wrote:
> Thursday 19 February 2009 17:49:52 Bartlomiej Zolnierkiewicz napisa=C5=
=82(a):
> > > > Seems like ide_device_put() needs the same module_refcount() ch=
eck that
> > > > is present in scsi_device_put() so removal of device driver won=
't trigger
> > > > a spurious module_put() on a host driver?
> > >=20
> > > I little surprise about scsi code (linux-scsi ML CC). Is comment =
inside
> > > scsi_device_put() function correct? Why scsi_device_get() not che=
ck
> > > try_module_get() return value? And most importand: there is refer=
ence
> > > counter check before put, so it can be 0, but data does it protec=
t is in
> > > use ?
>=20
> Any comments?
>=20
> > Uh... we will need some more intrusive changes to the reference cou=
nting
> > to fix it -- like to replace idkp->kref by idkp->dev and make drive=
->gendev
> > a parent of it (so only after the final put on ->dev ->gendev can g=
o away).
> >=20
> > [ IOW we need to have some changes similar to those done in sd.c by=
:
> > 	commit 6bdaa1f17dd32ec62345c7b57842f53e6278a2fa
> >   and later by:
> > 	commit ee959b00c335d7780136c5abda37809191fe52c3 ]
> >=20
> > > There is no oops with my workaround, when I just remove ide_disk_=
put() from
> >
> > I suppose that after ide_disk_put() removal ide_disk_release() is s=
imply
> > never called... ;)
> >=20
> > > ide_gd_remove(). It's strange why there is lack of symmetrical _p=
ut/_get calls,
> > > ide_gd_probe() has no call to ide_disk_get().=20
> >=20
> > We have kref_init() in ide_disk_probe(), so there is no need for it
> > and we also don't want to hold an extra reference on host driver...
>=20
> Looks that using ->dev insted of ->kref will do the work. But perhaps=
 less
> intrusive fix, like check kref in ide_disk_put() would be better solu=
tion.
> I tested below patch and everythings is fine.
>=20
> diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
> index 7857b20..598f21b 100644
> --- a/drivers/ide/ide-gd.c
> +++ b/drivers/ide/ide-gd.c
> @@ -48,8 +48,8 @@ static void ide_disk_put(struct ide_disk_obj *idkp)
>  	ide_drive_t *drive =3D idkp->drive;
> =20
>  	mutex_lock(&ide_disk_ref_mutex);
> -	kref_put(&idkp->kref, ide_disk_release);
> -	ide_device_put(drive);
> +	if (!kref_put(&idkp->kref, ide_disk_release))
> +		ide_device_put(drive);

I worry that this just masks the problem as according to your previous
mail drive still can be already gone before ->flush in ide_gd_remove().

>  	mutex_unlock(&ide_disk_ref_mutex);
>  }
> =20
> If this patch is ok and dropping kref to dev is not planed currently,=
 maybe
> I'll send "official" patch with ide-gd fix and for other devices type=
s.

Lets fix it fully.  The below patch together with previous ide_device_p=
ut()
fix and drive_release_dev() one (from another mail) should make all pro=
blems
go away...

=46rom: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix refcounting in device drivers

During host driver module removal del_gendisk() results in a final
put on drive->gendev and freeing the drive by drive_release_dev().

Convert device drivers from using struct kref to use struct device
so device driver's object holds reference on ->gendev and prevents
drive from prematurely going away.

Also fix ->remove methods to not erroneously drop reference on a
host driver by using only put_device() instead of ide*_put().

Reported-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-cd.c   |   27 ++++++++++++++++++---------
 drivers/ide/ide-cd.h   |    2 +-
 drivers/ide/ide-gd.c   |   26 +++++++++++++++++---------
 drivers/ide/ide-gd.h   |    2 +-
 drivers/ide/ide-tape.c |   29 +++++++++++++++++++----------
 include/linux/ide.h    |    2 +-
 6 files changed, 57 insertions(+), 31 deletions(-)

Index: b/drivers/ide/ide-cd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -55,7 +55,7 @@
=20
 static DEFINE_MUTEX(idecd_ref_mutex);
=20
-static void ide_cd_release(struct kref *);
+static void ide_cd_release(struct device *);
=20
 static struct cdrom_info *ide_cd_get(struct gendisk *disk)
 {
@@ -67,7 +67,7 @@ static struct cdrom_info *ide_cd_get(str
 		if (ide_device_get(cd->drive))
 			cd =3D NULL;
 		else
-			kref_get(&cd->kref);
+			get_device(&cd->dev);
=20
 	}
 	mutex_unlock(&idecd_ref_mutex);
@@ -79,7 +79,7 @@ static void ide_cd_put(struct cdrom_info
 	ide_drive_t *drive =3D cd->drive;
=20
 	mutex_lock(&idecd_ref_mutex);
-	kref_put(&cd->kref, ide_cd_release);
+	put_device(&cd->dev);
 	ide_device_put(drive);
 	mutex_unlock(&idecd_ref_mutex);
 }
@@ -1790,15 +1790,17 @@ static void ide_cd_remove(ide_drive_t *d
 	ide_debug_log(IDE_DBG_FUNC, "Call %s\n", __func__);
=20
 	ide_proc_unregister_driver(drive, info->driver);
-
+	device_del(&info->dev);
 	del_gendisk(info->disk);
=20
-	ide_cd_put(info);
+	mutex_lock(&idecd_ref_mutex);
+	put_device(&info->dev);
+	mutex_unlock(&idecd_ref_mutex);
 }
=20
-static void ide_cd_release(struct kref *kref)
+static void ide_cd_release(struct device *dev)
 {
-	struct cdrom_info *info =3D to_ide_drv(kref, cdrom_info);
+	struct cdrom_info *info =3D to_ide_drv(dev, cdrom_info);
 	struct cdrom_device_info *devinfo =3D &info->devinfo;
 	ide_drive_t *drive =3D info->drive;
 	struct gendisk *g =3D info->disk;
@@ -1997,7 +1999,12 @@ static int ide_cd_probe(ide_drive_t *dri
=20
 	ide_init_disk(g, drive);
=20
-	kref_init(&info->kref);
+	info->dev.parent =3D &drive->gendev;
+	info->dev.release =3D ide_cd_release;
+	dev_set_name(&info->dev, dev_name(&drive->gendev));
+
+	if (device_register(&info->dev))
+		goto out_free_disk;
=20
 	info->drive =3D drive;
 	info->driver =3D &ide_cdrom_driver;
@@ -2011,7 +2018,7 @@ static int ide_cd_probe(ide_drive_t *dri
 	g->driverfs_dev =3D &drive->gendev;
 	g->flags =3D GENHD_FL_CD | GENHD_FL_REMOVABLE;
 	if (ide_cdrom_setup(drive)) {
-		ide_cd_release(&info->kref);
+		put_device(&info->dev);
 		goto failed;
 	}
=20
@@ -2021,6 +2028,8 @@ static int ide_cd_probe(ide_drive_t *dri
 	add_disk(g);
 	return 0;
=20
+out_free_disk:
+	put_disk(g);
 out_free_cd:
 	kfree(info);
 failed:
Index: b/drivers/ide/ide-cd.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -80,7 +80,7 @@ struct cdrom_info {
 	ide_drive_t		*drive;
 	struct ide_driver	*driver;
 	struct gendisk		*disk;
-	struct kref		kref;
+	struct device		dev;
=20
 	/* Buffer for table of contents.  NULL if we haven't allocated
 	   a TOC buffer for this device yet. */
Index: b/drivers/ide/ide-gd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -25,7 +25,7 @@ module_param(debug_mask, ulong, 0644);
=20
 static DEFINE_MUTEX(ide_disk_ref_mutex);
=20
-static void ide_disk_release(struct kref *);
+static void ide_disk_release(struct device *);
=20
 static struct ide_disk_obj *ide_disk_get(struct gendisk *disk)
 {
@@ -37,7 +37,7 @@ static struct ide_disk_obj *ide_disk_get
 		if (ide_device_get(idkp->drive))
 			idkp =3D NULL;
 		else
-			kref_get(&idkp->kref);
+			get_device(&idkp->dev);
 	}
 	mutex_unlock(&ide_disk_ref_mutex);
 	return idkp;
@@ -48,7 +48,7 @@ static void ide_disk_put(struct ide_disk
 	ide_drive_t *drive =3D idkp->drive;
=20
 	mutex_lock(&ide_disk_ref_mutex);
-	kref_put(&idkp->kref, ide_disk_release);
+	put_device(&idkp->dev);
 	ide_device_put(drive);
 	mutex_unlock(&ide_disk_ref_mutex);
 }
@@ -66,17 +66,18 @@ static void ide_gd_remove(ide_drive_t *d
 	struct gendisk *g =3D idkp->disk;
=20
 	ide_proc_unregister_driver(drive, idkp->driver);
-
+	device_del(&idkp->dev);
 	del_gendisk(g);
-
 	drive->disk_ops->flush(drive);
=20
-	ide_disk_put(idkp);
+	mutex_lock(&ide_disk_ref_mutex);
+	put_device(&idkp->dev);
+	mutex_unlock(&ide_disk_ref_mutex);
 }
=20
-static void ide_disk_release(struct kref *kref)
+static void ide_disk_release(struct device *dev)
 {
-	struct ide_disk_obj *idkp =3D to_ide_drv(kref, ide_disk_obj);
+	struct ide_disk_obj *idkp =3D to_ide_drv(dev, ide_disk_obj);
 	ide_drive_t *drive =3D idkp->drive;
 	struct gendisk *g =3D idkp->disk;
=20
@@ -348,7 +349,12 @@ static int ide_gd_probe(ide_drive_t *dri
=20
 	ide_init_disk(g, drive);
=20
-	kref_init(&idkp->kref);
+	idkp->dev.parent =3D &drive->gendev;
+	idkp->dev.release =3D ide_disk_release;
+	dev_set_name(&idkp->dev, dev_name(&drive->gendev));
+
+	if (device_register(&idkp->dev))
+		goto out_free_disk;
=20
 	idkp->drive =3D drive;
 	idkp->driver =3D &ide_gd_driver;
@@ -373,6 +379,8 @@ static int ide_gd_probe(ide_drive_t *dri
 	add_disk(g);
 	return 0;
=20
+out_free_disk:
+	put_disk(g);
 out_free_idkp:
 	kfree(idkp);
 failed:
Index: b/drivers/ide/ide-gd.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/drivers/ide/ide-gd.h
+++ b/drivers/ide/ide-gd.h
@@ -17,7 +17,7 @@ struct ide_disk_obj {
 	ide_drive_t		*drive;
 	struct ide_driver	*driver;
 	struct gendisk		*disk;
-	struct kref		kref;
+	struct device		dev;
 	unsigned int		openers;	/* protected by BKL for now */
=20
 	/* Last failed packet command */
Index: b/drivers/ide/ide-tape.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -169,7 +169,7 @@ typedef struct ide_tape_obj {
 	ide_drive_t		*drive;
 	struct ide_driver	*driver;
 	struct gendisk		*disk;
-	struct kref		kref;
+	struct device		dev;
=20
 	/*
 	 *	failed_pc points to the last failed packet command, or contains
@@ -267,7 +267,7 @@ static DEFINE_MUTEX(idetape_ref_mutex);
=20
 static struct class *idetape_sysfs_class;
=20
-static void ide_tape_release(struct kref *);
+static void ide_tape_release(struct device *);
=20
 static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
 {
@@ -279,7 +279,7 @@ static struct ide_tape_obj *ide_tape_get
 		if (ide_device_get(tape->drive))
 			tape =3D NULL;
 		else
-			kref_get(&tape->kref);
+			get_device(&tape->dev);
 	}
 	mutex_unlock(&idetape_ref_mutex);
 	return tape;
@@ -290,7 +290,7 @@ static void ide_tape_put(struct ide_tape
 	ide_drive_t *drive =3D tape->drive;
=20
 	mutex_lock(&idetape_ref_mutex);
-	kref_put(&tape->kref, ide_tape_release);
+	put_device(&tape->dev);
 	ide_device_put(drive);
 	mutex_unlock(&idetape_ref_mutex);
 }
@@ -308,7 +308,7 @@ static struct ide_tape_obj *ide_tape_chr
 	mutex_lock(&idetape_ref_mutex);
 	tape =3D idetape_devs[i];
 	if (tape)
-		kref_get(&tape->kref);
+		get_device(&tape->dev);
 	mutex_unlock(&idetape_ref_mutex);
 	return tape;
 }
@@ -2256,15 +2256,17 @@ static void ide_tape_remove(ide_drive_t=20
 	idetape_tape_t *tape =3D drive->driver_data;
=20
 	ide_proc_unregister_driver(drive, tape->driver);
-
+	device_del(&tape->dev);
 	ide_unregister_region(tape->disk);
=20
-	ide_tape_put(tape);
+	mutex_lock(&idetape_ref_mutex);
+	put_device(&tape->dev);
+	mutex_unlock(&idetape_ref_mutex);
 }
=20
-static void ide_tape_release(struct kref *kref)
+static void ide_tape_release(struct device *dev)
 {
-	struct ide_tape_obj *tape =3D to_ide_drv(kref, ide_tape_obj);
+	struct ide_tape_obj *tape =3D to_ide_drv(dev, ide_tape_obj);
 	ide_drive_t *drive =3D tape->drive;
 	struct gendisk *g =3D tape->disk;
=20
@@ -2407,7 +2409,12 @@ static int ide_tape_probe(ide_drive_t *d
=20
 	ide_init_disk(g, drive);
=20
-	kref_init(&tape->kref);
+	tape->dev.parent =3D &drive->gendev;
+	tape->dev.release =3D ide_tape_release;
+	dev_set_name(&tape->dev, dev_name(&drive->gendev));
+
+	if (device_register(&tape->dev))
+		goto out_free_disk;
=20
 	tape->drive =3D drive;
 	tape->driver =3D &idetape_driver;
@@ -2436,6 +2443,8 @@ static int ide_tape_probe(ide_drive_t *d
=20
 	return 0;
=20
+out_free_disk:
+	put_disk(g);
 out_free_tape:
 	kfree(tape);
 failed:
Index: b/include/linux/ide.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -663,7 +663,7 @@ typedef struct ide_drive_s ide_drive_t;
 #define to_ide_device(dev)		container_of(dev, ide_drive_t, gendev)
=20
 #define to_ide_drv(obj, cont_type)	\
-	container_of(obj, struct cont_type, kref)
+	container_of(obj, struct cont_type, dev)
=20
 #define ide_drv_g(disk, cont_type)	\
 	container_of((disk)->private_data, struct cont_type, driver)
