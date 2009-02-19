From: Stanislaw Gruszka <stf_xl@wp.pl>
Subject: Re: Bad module reference counter
Date: Thu, 19 Feb 2009 13:48:44 +0100
Message-ID: <200902191348.44508.stf_xl@wp.pl>
References: <200902111032.59225.stf_xl@wp.pl> <200902182225.19784.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <200902182225.19784.bzolnier@gmail.com>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Wednesday 18 February 2009 22:25:19 Bartlomiej Zolnierkiewicz napisa=C5=
=82(a):
> > I entered a problem with double decreasing module reference counter
> > where it become "negative", here is the usage scenario:
> >=20
> > # modprobe at91_ide
> > # modprobe ide_gd_mod
> > # lsmod
> > Module                  Size  Used by    Not tainted
> > ide_gd_mod             22948  0
> > at91_ide                4672  0
> > ide_core               77020  2 ide_gd_mod,at91_ide
> > # rmmod ide_gd_mod
> > # lsmod
> > Module                  Size  Used by    Not tainted
> > at91_ide                4672 4294967295
> > ide_core               77020  1 at91_ide
> >=20
> > Note when I first remove at91_ide module and then ide_gd_mod
> > everyting is ok.
> >=20
> > I tired to debug issue and I did not found any suspicious in at91_i=
de.
> > I think probable reason is double free in ide-gd.c . Here is patch =
with
> > workaround (or maybe it is a real fix, but I'm not sure):
> >=20
> > diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
> > index 7857b20..31ae04e 100644
> > --- a/drivers/ide/ide-gd.c
> > +++ b/drivers/ide/ide-gd.c
> > @@ -70,8 +70,6 @@ static void ide_gd_remove(ide_drive_t *drive)
> >  	del_gendisk(g);
> > =20
> >  	drive->disk_ops->flush(drive);
> > -
> > -	ide_disk_put(idkp);
> >  }
> > =20
> >  static void ide_disk_release(struct kref *kref)
> >=20
> > If this patch is ok, maybe similar things need to be done also in i=
de-cd and
> > perhaps other device type modules.
>=20
> Seems like ide_device_put() needs the same module_refcount() check th=
at
> is present in scsi_device_put() so removal of device driver won't tri=
gger
> a spurious module_put() on a host driver?

I little surprise about scsi code (linux-scsi ML CC). Is comment inside
scsi_device_put() function correct? Why scsi_device_get() not check
try_module_get() return value? And most importand: there is reference
counter check before put, so it can be 0, but data does it protect is i=
n
use ?

Adding module_refcount() !=3D 0 to ide_device_put()  helps only partial=
ly, below
commands sequence give oops [1].

# modprobe at91_ide
# modprobe ide_gd_mod
# rmmod ide_gd_mod
# modprobe ide_gd_mod
# rmmod at91_ide

Oops happens because previous "rmmod ide_gd_mod"  decrease some referen=
ce
counter in ide_device_put() and in "rmmod at91_ide" function del_gendis=
k()
cause call to drive_release_dev(), which free drive->id before ide_disk=
_flush() .
This function oops with NULL driver->id.

There is no oops with my workaround, when I just remove ide_disk_put() =
from
ide_gd_remove(). It's strange why there is lack of symmetrical _put/_ge=
t calls,
ide_gd_probe() has no call to ide_disk_get().=20
 =20
Cheers
Stanislaw Gruszka

[1]:

[ 5043.790000] Unable to handle kernel NULL pointer dereference at virt=
ual address 000000a6
[ 5043.800000] pgd =3D c3a40000
[ 5043.800000] [000000a6] *pgd=3D23b55031, *pte=3D00000000, *ppte=3D000=
00000
[ 5043.810000] Internal error: Oops: 17 [#1]
[ 5043.810000] Modules linked in: ide_gd_mod at91_ide(-) ide_core [last=
 unloaded: ide_gd_mod]
[ 5043.810000] CPU: 0    Not tainted  (2.6.29-rc3 #34)
[ 5043.810000] PC is at ide_disk_flush+0x18/0xe4 [ide_gd_mod]
[ 5043.810000] LR is at ide_gd_remove+0x34/0x40 [ide_gd_mod]
[ 5043.810000] pc : [<bf035c6c>]    lr : [<bf035320>]    psr: 80000013
[ 5043.810000] sp : c3bb1d74  ip : c3bb1db0  fp : c3bb1dac
[ 5043.810000] r10: 0000b8e8  r9 : c3bb0000  r8 : c0028f24
[ 5043.810000] r7 : c3b9cde0  r6 : c3a8de00  r5 : c3b57a00  r4 : c3b980=
00
[ 5043.810000] r3 : bf037ea0  r2 : 00000000  r1 : 00000051  r0 : c3b980=
00
[ 5043.810000] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Seg=
ment user
[ 5043.810000] Control: 0005317f  Table: 23a40000  DAC: 00000015
[ 5043.810000] Process rmmod (pid: 11458, stack limit =3D 0xc3bb0260)
[ 5043.810000] Stack: (0xc3bb1d74 to 0xc3bb2000)
{snip binary stack}
[ 5043.810000] Backtrace:
[ 5043.810000] [<bf035c54>] (ide_disk_flush+0x0/0xe4 [ide_gd_mod]) from=
 [<bf035320>] (ide_gd_remove+0x34/0x40 [ide_gd_mod])
[ 5043.810000]  r4:c3b98000
[ 5043.810000] [<bf0352ec>] (ide_gd_remove+0x0/0x40 [ide_gd_mod]) from =
[<bf00b198>] (generic_ide_remove+0x24/0x2c [ide_core])
[ 5043.810000]  r6:c3b984f8 r5:bf03a744 r4:c3b98090
[ 5043.810000] [<bf00b174>] (generic_ide_remove+0x0/0x2c [ide_core]) fr=
om [<c0170a38>] (__device_release_driver+0x6c/0x88)
[ 5043.810000] [<c01709cc>] (__device_release_driver+0x0/0x88) from [<c=
0170b08>] (device_release_driver+0x24/0x30)
[ 5043.810000]  r5:c3b98118 r4:c3b98090
[ 5043.810000] [<c0170ae4>] (device_release_driver+0x0/0x30) from [<c01=
6fd68>] (bus_remove_device+0x80/0x94)
[ 5043.810000]  r5:c3b98090 r4:c3b980c0
[ 5043.810000] [<c016fce8>] (bus_remove_device+0x0/0x94) from [<c016e58=
c>] (device_del+0x104/0x154)
[ 5043.810000]  r5:c3b98404 r4:c3b98090
[ 5043.810000] [<c016e488>] (device_del+0x0/0x154) from [<c016e5f0>] (d=
evice_unregister+0x14/0x20)
[ 5043.810000]  r6:00000001 r5:c3b98404 r4:c3b98090
[ 5043.810000] [<c016e5dc>] (device_unregister+0x0/0x20) from [<bf01061=
4>] (__ide_port_unregister_devices+0x30/0x54 [ide_core])
[ 5043.810000]  r4:c3b98000
[ 5043.810000] [<bf0105e4>] (__ide_port_unregister_devices+0x0/0x54 [id=
e_core]) from [<bf0106c8>] (ide_host_remove+0x70/0x108 [ide_core])
[ 5043.810000]  r6:00000000 r5:c3bb0000 r4:c3b98400
[ 5043.810000] [<bf010658>] (ide_host_remove+0x0/0x108 [ide_core]) from=
 [<bf023634>] (at91_ide_remove+0x14/0x1c [at91_ide])
[ 5043.810000]  r7:00000880 r6:bf024054 r5:bf024054 r4:c02f3500
[ 5043.810000] [<bf023620>] (at91_ide_remove+0x0/0x1c [at91_ide]) from =
[<c0171b40>] (platform_drv_remove+0x20/0x24)
[ 5043.810000] [<c0171b20>] (platform_drv_remove+0x0/0x24) from [<c0170=
a38>] (__device_release_driver+0x6c/0x88)
[ 5043.810000] [<c01709cc>] (__device_release_driver+0x0/0x88) from [<c=
0170abc>] (driver_detach+0x68/0x90)
[ 5043.810000]  r5:c02f3588 r4:c02f3500
[ 5043.810000] [<c0170a54>] (driver_detach+0x0/0x90) from [<c016fc40>] =
(bus_remove_driver+0x8c/0xb4)
[ 5043.810000]  r6:c0307320 r5:bf0240a0 r4:bf024054
[ 5043.810000] [<c016fbb4>] (bus_remove_driver+0x0/0xb4) from [<c0170f5=
4>] (driver_unregister+0x44/0x48)
[ 5043.810000]  r6:00000000 r5:bf0240a0 r4:bf024054
[ 5043.810000] [<c0170f10>] (driver_unregister+0x0/0x48) from [<c0171ce=
0>] (platform_driver_unregister+0x14/0x18)
[ 5043.810000]  r6:bf0241c0 r5:bf0240a0 r4:00000000
[ 5043.810000] [<c0171ccc>] (platform_driver_unregister+0x0/0x18) from =
[<bf023618>] (at91_ide_exit+0x14/0x1c [at91_ide])
[ 5043.810000] [<bf023604>] (at91_ide_exit+0x0/0x1c [at91_ide]) from [<=
c005b850>] (sys_delete_module+0x1b8/0x230)
[ 5043.810000] [<c005b698>] (sys_delete_module+0x0/0x230) from [<c0028d=
80>] (ret_fast_syscall+0x0/0x2c)
[ 5043.810000]  r7:00000081 r6:becd1bcc r5:00000880 r4:becd1cd8
[ 5043.810000] Code: e24cb004 e24dd028 e590201c e1a04000 (e1d21ab6)
[ 5044.320000] ---[ end trace 120de1a999313176 ]---
