From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] microtek.c - use data accessors and !use_sg cleanup
Date: Thu, 12 Jul 2007 16:58:00 +0300
Message-ID: <46963368.9080308@panasas.com>
References: <468BE4CE.80402@panasas.com> <4696287C.8060501@panasas.com> <200707121529.35512.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:7284 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932632AbXGLN6X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jul 2007 09:58:23 -0400
In-Reply-To: <200707121529.35512.oliver@neukum.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

Oliver Neukum wrote:
> Am Donnerstag, 12. Juli 2007 schrieb Boaz Harrosh:
>>   - use scsi_cmnd data accessors
>>   - Clean the !use_sg code paths
>=20
> This doesn't compile, at least on x86_64, so NAK.
>=20
> 	Regards
> 		Oliver
>=20
>   CC [M]  drivers/usb/image/microtek.o
> drivers/usb/image/microtek.c: In function =E2=80=98mts_data_done=E2=80=
=99:
> drivers/usb/image/microtek.c:450: warning: implicit declaration of fu=
nction =E2=80=98scsi_set_resid=E2=80=99
> drivers/usb/image/microtek.c: In function =E2=80=98mts_command_done=E2=
=80=99:
> drivers/usb/image/microtek.c:494: warning: implicit declaration of fu=
nction =E2=80=98scsi_sg_count=E2=80=99
> drivers/usb/image/microtek.c: In function =E2=80=98mts_do_sg=E2=80=99=
:
> drivers/usb/image/microtek.c:517: warning: implicit declaration of fu=
nction =E2=80=98scsi_sglist=E2=80=99
> drivers/usb/image/microtek.c:517: warning: assignment makes pointer f=
rom integer without a cast
> drivers/usb/image/microtek.c: In function =E2=80=98mts_build_transfer=
_context=E2=80=99:
> drivers/usb/image/microtek.c:553: warning: implicit declaration of fu=
nction =E2=80=98scsi_bufflen=E2=80=99
> drivers/usb/image/microtek.c:558: warning: assignment makes pointer f=
rom integer without a cast
>   MODPOST vmlinux
> Kernel: arch/x86_64/boot/bzImage is ready  (#4)
>   Building modules, stage 2.
>   MODPOST 1705 modules
> ERROR: "scsi_set_resid" [drivers/usb/image/microtek.ko] undefined!
> ERROR: "scsi_sg_count" [drivers/usb/image/microtek.ko] undefined!
> ERROR: "scsi_sglist" [drivers/usb/image/microtek.ko] undefined!
> ERROR: "scsi_bufflen" [drivers/usb/image/microtek.ko] undefined!
> make[1]: *** [__modpost] Fehler 1
> make: *** [modules] Fehler 2

This is over current scsi-2.6-misc git tree, and the infrastructure=20
needed for this is going into the linux 2.6.23 merging window.
The proposed changes above are for probably 2.6.24 merge window.

It is all a part of a clean sweep of every scsi driver in the=20
tree. Most drivers have already been converted and accepted into
current scsi-2.6-misc and are do into the current merge window.

The microtek.c driver is sitting in USB land but it is a scsi
driver and should be maintained through the scsi-2.6-misc tree?
No?

Boaz
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
