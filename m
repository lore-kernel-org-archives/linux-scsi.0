From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Bad module reference counter
Date: Thu, 19 Feb 2009 17:49:52 +0100
Message-ID: <200902191749.52740.bzolnier@gmail.com>
References: <200902111032.59225.stf_xl@wp.pl> <200902182225.19784.bzolnier@gmail.com> <200902191348.44508.stf_xl@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f161.google.com ([209.85.218.161]:63197 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593AbZBSRVO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Feb 2009 12:21:14 -0500
In-Reply-To: <200902191348.44508.stf_xl@wp.pl>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thursday 19 February 2009, Stanislaw Gruszka wrote:
> Wednesday 18 February 2009 22:25:19 Bartlomiej Zolnierkiewicz napisa=C5=
=82(a):
> > > I entered a problem with double decreasing module reference count=
er
> > > where it become "negative", here is the usage scenario:
> > >=20
> > > # modprobe at91_ide
> > > # modprobe ide_gd_mod
> > > # lsmod
> > > Module                  Size  Used by    Not tainted
> > > ide_gd_mod             22948  0
> > > at91_ide                4672  0
> > > ide_core               77020  2 ide_gd_mod,at91_ide
> > > # rmmod ide_gd_mod
> > > # lsmod
> > > Module                  Size  Used by    Not tainted
> > > at91_ide                4672 4294967295
> > > ide_core               77020  1 at91_ide
> > >=20
> > > Note when I first remove at91_ide module and then ide_gd_mod
> > > everyting is ok.
> > >=20
> > > I tired to debug issue and I did not found any suspicious in at91=
_ide.
> > > I think probable reason is double free in ide-gd.c . Here is patc=
h with
> > > workaround (or maybe it is a real fix, but I'm not sure):
> > >=20
> > > diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
> > > index 7857b20..31ae04e 100644
> > > --- a/drivers/ide/ide-gd.c
> > > +++ b/drivers/ide/ide-gd.c
> > > @@ -70,8 +70,6 @@ static void ide_gd_remove(ide_drive_t *drive)
> > >  	del_gendisk(g);
> > > =20
> > >  	drive->disk_ops->flush(drive);
> > > -
> > > -	ide_disk_put(idkp);
> > >  }
> > > =20
> > >  static void ide_disk_release(struct kref *kref)
> > >=20
> > > If this patch is ok, maybe similar things need to be done also in=
 ide-cd and
> > > perhaps other device type modules.
> >=20
> > Seems like ide_device_put() needs the same module_refcount() check =
that
> > is present in scsi_device_put() so removal of device driver won't t=
rigger
> > a spurious module_put() on a host driver?
>=20
> I little surprise about scsi code (linux-scsi ML CC). Is comment insi=
de
> scsi_device_put() function correct? Why scsi_device_get() not check
> try_module_get() return value? And most importand: there is reference
> counter check before put, so it can be 0, but data does it protect is=
 in
> use ?
>=20
> Adding module_refcount() !=3D 0 to ide_device_put()  helps only parti=
ally, below
> commands sequence give oops [1].
>=20
> # modprobe at91_ide
> # modprobe ide_gd_mod
> # rmmod ide_gd_mod
> # modprobe ide_gd_mod
> # rmmod at91_ide
>=20
> Oops happens because previous "rmmod ide_gd_mod"  decrease some refer=
ence
> counter in ide_device_put() and in "rmmod at91_ide" function del_gend=
isk()
> cause call to drive_release_dev(), which free drive->id before ide_di=
sk_flush() .
> This function oops with NULL driver->id.

Uh... we will need some more intrusive changes to the reference countin=
g
to fix it -- like to replace idkp->kref by idkp->dev and make drive->ge=
ndev
a parent of it (so only after the final put on ->dev ->gendev can go aw=
ay).

[ IOW we need to have some changes similar to those done in sd.c by:
	commit 6bdaa1f17dd32ec62345c7b57842f53e6278a2fa
  and later by:
	commit ee959b00c335d7780136c5abda37809191fe52c3 ]

> There is no oops with my workaround, when I just remove ide_disk_put(=
) from

I suppose that after ide_disk_put() removal ide_disk_release() is simpl=
y
never called... ;)

> ide_gd_remove(). It's strange why there is lack of symmetrical _put/_=
get calls,
> ide_gd_probe() has no call to ide_disk_get().=20

We have kref_init() in ide_disk_probe(), so there is no need for it
and we also don't want to hold an extra reference on host driver...

Thanks,
Bart
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
