From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: Fw: using usb storage
Date: Sun, 1 Aug 2004 09:26:32 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040801162632.GA23865@one-eyed-alien.net>
References: <20040731193121.1082160f.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:5583 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265663AbUHAQ0m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Aug 2004 12:26:42 -0400
Content-Disposition: inline
In-Reply-To: <20040731193121.1082160f.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

usb-storage doesn't directly create any slab caches.  Most likely, this
crash is caused as a side-effect of a forced rmmod.

Matt

On Sat, Jul 31, 2004 at 07:31:21PM -0700, Andrew Morton wrote:
>=20
> Is this now fixed?  usb-storage in 2.6.7 is trying to create the
> scsi_cmd_cache slab cache,  but it already exists.
>=20
>=20
> Begin forwarded message:
>=20
> Date: Sat, 31 Jul 2004 22:30:39 +0200
> From: willy discart <willy.discart@skynet.be>
> To: linux-kernel@vger.kernel.org
> Subject: using usb storage
>=20
>=20
>=20
>=20
> Ran into the following problem :
>=20
>=20
> Using rsync to copy files to usb storage:
>=20
> usr/X11R6/
> usr/X11R6/ATI.2.TIMESTAMP
> usr/X11R6/README.ati.2
> usr/X11R6/bin/
> usr/X11R6/bin/X
> usr/X11R6/bin/XFree86
> rsync: writefd_unbuffered failed to write 4 bytes: phase "unknown":=20
> Broken pipe
> rsync error: error in rsync protocol data stream (code 12) at io.c(839)
> rsync: writefd_unbuffered failed to write 69 bytes: phase "unknown":=20
> Broken pipe
> rsync error: error in rsync protocol data stream (code 12) at io.c(839)
>=20
>=20
> umount /disk
> rmmod -v -f usb_storage
> rmmod usb_storage, wait=3Dno force
>=20
> disconnect the usb storage, reconnect again :
>=20
> usb 1-2.1: adding 1-2.1:1.0 (config #1, interface 0)
> usb 1-2.1:1.0: hotplug
> Initializing USB Mass Storage driver...
> usb-storage 1-2.1:1.0: usb_probe_interface
> usb-storage 1-2.1:1.0: usb_probe_interface - got id
> kmem_cache_create: duplicate cache scsi_cmd_cache
> ------------[ cut here ]------------
> kernel BUG at mm/slab.c:1392!
> invalid operand: 0000 [#1]
> PREEMPT
> Modules linked in: usb_storage ds binfmt_misc thermal fan button=20
> processor ac        pro100 usbhid uhci_hcd usbcore yenta_socket=20
> pcmcia_core sd_mod battery snd_int       8x0 snd_ac97_codec snd_pcm_oss=
=20
> snd_mixer_oss snd_pcm snd_timer snd_page_alloc        d_mpu401_uart=20
> snd_rawmidi snd_seq_device snd
> CPU:    0
> EIP:    0060:[<c0135124>]    Not tainted
> EFLAGS: 00010202   (2.6.7)
> EIP is at kmem_cache_create+0x3f4/0x5a0
> eax: 00000032   ebx: c13bea50   ecx: c03c0d8c   edx: c031e838
> esi: c02f5437   edi: c02f5437   ebp: c466de0c   esp: c466ddd8
> ds: 007b   es: 007b   ss: 0068
> Process modprobe (pid: 2423, threadinfo=3Dc466c000 task=3Dc95948d0)
> Stack: c02e7e40 c02f5428 00000020 00002000 c466ddfc c13be99c c0000000=20
> ffffffe0
>        c13be960 000000a0 cfe0e600 c0364440 cfe0e60c c466de38 c024e863=20
> c02f5428
>        00000160 00000020 00002000 00000000 00000000 000001d8 cfe0e600=20
> d08bd820
> Call Trace:
>  [<c01047ef>] show_stack+0x7f/0xa0
>  [<c0104996>] show_registers+0x156/0x1b0
>  [<c0104b39>] die+0x89/0x100
>  [<c0104f25>] do_invalid_op+0xb5/0xc0
>  [<c0104475>] error_code+0x2d/0x38
>  [<c024e863>] scsi_setup_command_freelist+0x83/0x110
>  [<c024f934>] scsi_host_alloc+0x1b4/0x2c0
>  [<d08ba957>] usb_stor_acquire_resources+0xc7/0x130 [usb_storage]
>  [<d08bac71>] storage_probe+0xf1/0x190 [usb_storage]
>  [<d08f20db>] usb_probe_interface+0xbb/0xc0 [usbcore]
>  [<c021e9fd>] bus_match+0x3d/0x70
>  [<c021eb3c>] driver_attach+0x5c/0xa0
>  [<c021ee55>] bus_add_driver+0xa5/0xc0
>  [<c021f301>] driver_register+0x31/0x40
>  [<d08f219f>] usb_register+0x3f/0xa0 [usbcore]
>  [<d0924021>] usb_stor_init+0x21/0x3c [usb_storage]
>  [<c012aa05>] sys_init_module+0x135/0x280
>  [<c01042cb>] syscall_call+0x7/0xb
>=20
> Code: 0f 0b 70 05 8c 76 2e c0 8b 0b e9 56 ff ff ff 8b 47 34 c7 04
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I'm just trying to think of a way to say "up yours" without getting fired.
					-- Stef
User Friendly, 10/8/1998

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBDRm4IjReC7bSPZARAv1AAKCEd7uNOIny5eqw22527gfHF04mDACeJI46
dT1nu3k0YCidZRWTNFD5zDM=
=vmpR
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
