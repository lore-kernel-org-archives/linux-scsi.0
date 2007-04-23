From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: fails to initialize after a  kexec operation
Date: Mon, 23 Apr 2007 09:38:43 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0188ADCE@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF0188ADBF@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C785AC.B5F17AE5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:39581 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXDWNip (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2007 09:38:45 -0400
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF0188ADBF@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kexec Mailing List <kexec@lists.infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, vgoyal@in.ibm.com, Judith Lebzelter <judith@linux-foundation.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C785AC.B5F17AE5
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Missing portion of the kexec changes to the aacraid driver. The platform
functions were not initialized when the restart function is activated
resulting in a panic when these platform functions are called. Please
note that it is NOT a mistake that the disable interrupt handler is used
as the initial value of the enable interrupt platform function, it will
be set up correctly once the adapter is discovered and initialized.

Please note that aacraid_kexec_5.patch contains this fix, since an
earlier aacraid_kexec patch was applied to the tree and appears to have
propagated, this is meant to supersede the earlier patch and bring it up
to date with aacraid_kexec_5.patch, but expected to break when the
aacraid_kexec_5.patch propagates... James, can you sort out this mess
(either by stopping aacraid_kexec_5.patch, or by letting this enclosed
patch move with some level of priority)?

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patches.

This attached patch is against current scsi-misc-2.6. Also expect this
patch can be applied to 2.6.21-rc6-mm1

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

---

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
> Sent: Monday, April 23, 2007 9:01 AM
> To: vgoyal@in.ibm.com; linux-scsi@vger.kernel.org
> Cc: Kexec Mailing List
> Subject: RE: AACRAID fails to initialize after an kexec operation
>=20
>=20
> 2.6.21-rc6-mm1 contains an earlier kexec patch, that one needs to be
> removed and this one put in it's place.
>=20
> Basically the following fragment represents the update in the later
> patch that deals with this specific issue.
>=20
> diff -ru a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
> @@ -535,6 +539,8 @@
>         }
>=20
>         /* Failure to reset here is an option ... */
> +       dev->a_ops.adapter_sync_cmd =3D rx_sync_cmd;
> +       dev->a_ops.adapter_enable_int =3D aac_rx_disable_interrupt;
>         dev->OIMR =3D status =3D rx_readb (dev, MUnit.OIMR);
>         if ((((status & 0xff) !=3D 0xff) || reset_devices) &&
>           !aac_rx_restart_adapter(dev, 0))
>=20
> Sincerely -- Mark Salyzyn
>=20
> > -----Original Message-----
> > From: Vivek Goyal [mailto:vgoyal@in.ibm.com]=20
> > Sent: Monday, April 23, 2007 3:49 AM
> > To: linux-scsi@vger.kernel.org; AACRAID
> > Cc: Kexec Mailing List; Salyzyn, Mark
> > Subject: AACRAID fails to initialize after an kexec operation
> >=20
> >=20
> > Hi,
> >=20
> > I am trying to kexec into 2.6.21-rc6-mm1 kernel on an x86_64=20
> > machine and
> > aacraid panics in the second kernel. Following is the panic message.
> >=20
> > Any idea what's going on? Please let me know if more details=20
> > are required.
> >=20
> > Adaptec aacraid driver (1.1-5[2437]-mh4)
> > ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 25 (level, low) -> IRQ 25
> > Unable to handle kernel NULL pointer dereference at=20
> > 0000000000000000 RIP:
> >  [<0000000000000000>]
> > PGD 0
> > Oops: 0000 [1] SMP
> > last sysfs file:
> > CPU 4
> > Modules linked in:
> > Pid: 1, comm: swapper Not tainted 2.6.21-rc6-mm1 #2
> > RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
> > RSP: 0018:ffff810100c9fc78  EFLAGS: 00010246
> > RAX: ffff810100c9fcc4 RBX: 0000000000000000 RCX: 0000000000000000
> > RDX: 0000000000000000 RSI: 0000000000001001 RDI: ffff810100e02d30
> > RBP: ffff810100e02d30 R08: 0000000000000000 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000002 R12: ffff810100e02800
> > R13: 0000000000000000 R14: ffffffff80690ee1 R15: 000000000000002d
> > FS:  0000000000000000(0000) GS:ffff810100cf6440(0000)=20
> > knlGS:0000000000000000
> > CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> > Process swapper (pid: 1, threadinfo ffff810100c9e000, task=20
> > ffff810100c9d450)
> > Stack:  ffffffff8045952f 0000000000000000 ffffffff00000000=20
> > ffff810100c9fcc4
> >  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> >  ffffffff80690ee1 000000000000002d ffff810100e02d30 0000000000000001
> > Call Trace:
> > Inexact backtrace:
> >  [<ffffffff8045952f>] aac_rx_restart_adapter+0x7e/0x169
> >  [<ffffffff80459a0a>] _aac_rx_init+0x70/0x2f6
> >  [<ffffffff80280ee4>] cache_alloc_refill+0xdb/0x1db
> >  [<ffffffff8045317f>] aac_probe_one+0x1a9/0x462
> >  [<ffffffff8035f3a0>] pci_device_probe+0xd1/0x138
> >  [<ffffffff803b3251>] driver_probe_device+0xf7/0x174
> >  [<ffffffff803b33e4>] __driver_attach+0x6f/0xae
> >  [<ffffffff803b3375>] __driver_attach+0x0/0xae
> >  [<ffffffff803b3375>] __driver_attach+0x0/0xae
> >  [<ffffffff803b261e>] bus_for_each_dev+0x43/0x6e
> >  [<ffffffff803b2993>] bus_add_driver+0x78/0x19a
> >  [<ffffffff8035f578>] __pci_register_driver+0x58/0x8d
> >  [<ffffffff8084a909>] aac_init+0x35/0x70
> >  [<ffffffff8082d8ad>] kernel_init+0x167/0x2d1
> >  [<ffffffff8020a998>] child_rip+0xa/0x12
> >  [<ffffffff8036bd60>] acpi_ds_init_one_object+0x0/0x7c
> >  [<ffffffff8082d746>] kernel_init+0x0/0x2d1
> >  [<ffffffff8020a98e>] child_rip+0x0/0x12
> >=20
> >=20
> > Code:  Bad RIP value.
> > RIP  [<0000000000000000>]
> >  RSP <ffff810100c9fc78>
> > CR2: 0000000000000000
> > Kernel panic - not syncing: Attempted to kill init!
> >=20
> > Thanks
> > Vivek
> >=20
>=20

------_=_NextPart_001_01C785AC.B5F17AE5
Content-Type: application/octet-stream;
	name="aacraid_kexec_fix.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_kexec_fix.patch
Content-Disposition: attachment;
	filename="aacraid_kexec_fix.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jIGIvZHJpdmVycy9zY3NpL2FhY3Jh
aWQvcnguYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jCTIwMDctMDQtMjMgMDk6MDg6
MzQuNzUzMDIyNzExIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMJMjAwNy0w
NC0yMyAwOToyNTo1OS41MDYzODE3MTMgLTA0MDAKQEAgLTUzOSw2ICs1MzksOCBAQAogCX0KIAog
CS8qIEZhaWx1cmUgdG8gcmVzZXQgaGVyZSBpcyBhbiBvcHRpb24gLi4uICovCisJZGV2LT5hX29w
cy5hZGFwdGVyX3N5bmNfY21kID0gcnhfc3luY19jbWQ7CisJZGV2LT5hX29wcy5hZGFwdGVyX2Vu
YWJsZV9pbnQgPSBhYWNfcnhfZGlzYWJsZV9pbnRlcnJ1cHQ7CiAJZGV2LT5PSU1SID0gc3RhdHVz
ID0gcnhfcmVhZGIgKGRldiwgTVVuaXQuT0lNUik7CiAJaWYgKCgoKHN0YXR1cyAmIDB4ZmYpICE9
IDB4ZmYpIHx8IHJlc2V0X2RldmljZXMpICYmCiAJICAhYWFjX3J4X3Jlc3RhcnRfYWRhcHRlcihk
ZXYsIDApKQo=

------_=_NextPart_001_01C785AC.B5F17AE5--
