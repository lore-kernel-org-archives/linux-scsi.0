From: Ben Hutchings <ben@decadent.org.uk>
Subject: Bug#741686: linux-image-3.13-1-amd64: systemd-udevd kills long
 running mptsas module initailization, resulting in kernel oops
Date: Sat, 15 Mar 2014 17:29:59 +0000
Message-ID: <1394904599.15764.40.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-QEZQsM7UwKWA9u49nwW/"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43425 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756219AbaCORaD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Mar 2014 13:30:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: DL-MPTFusionLinux@lsi.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Tomas Cernaj <tcernaj@gmx.de>, 741686@bugs.debian.org


--=-QEZQsM7UwKWA9u49nwW/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tomas reports that mptsas can crash if probe is interrupted by a signal:

Tomas Cernaj <tcernaj@gmx.de> wrote:
> Dear Maintainer,
>=20
> after upgrading from linux-image-3.12 to 3.13, systemd-udevd kills the mp=
tsas
> module initialization during boot after 30 seconds while probing the SAS
> hardware. As a consequence the system can't be booted. Kernel output is
> attached as precision-boot.log.
>=20
> I increased systemd's timeout to 45 seconds by adding "udevadm control
> --timeout=3D45" directly after the daemon start in /usr/share/initramfs-
> tools/scripts/init-top/udev and regenerating the initrd. This resulted in=
 the
> kernel failing to load the mptsas module completely, but it could be load=
ed
> manually from the initramfs shell. The kernel output is attached in
> dmesg_manual-load-mptsas-with-udev-timeout-45s.log.
>=20
> I have a LSI SAS1068E controller with two SAS disks as RAID-0. The mptsas
> driver normally takes about 30 seconds to initialize.
>=20
> Kernel output follows. (Note: in this instance I manually added mptsas to=
 /etc
> /initramfs-tools/modules, but the behavior was the same without this entr=
y.
> Also different from the normal boot is netconsole to capture the kernel
> output.)

Quoting part of that log (full logs are at
<https://bugs.debian.org/741686>):

> [   32.392600] systemd-udevd[95]: timeout: killing '/sbin/modprobe -b pci=
:v00001000d00000058sv00001028sd00001F0Ebc01sc00i00' [204]
> [   33.419390] systemd-udevd[95]: timeout: killing '/sbin/modprobe -b pci=
:v00001000d00000058sv00001028sd00001F0Ebc01sc00i00' [204]
> [   33.422860] systemd-udevd[92]: worker [95] /devices/pci0000:20/0000:20=
:09.0/0000:23:00.0 timeout; kill it
> [   33.422867] systemd-udevd[92]: seq 688 '/devices/pci0000:20/0000:20:09=
.0/0000:23:00.0' killed
> [   33.473577] systemd-udevd[92]: worker [95] terminated by signal 9 (Kil=
led)
> [   33.488028] netpoll: netconsole: local port 6665
> [   33.501909] netpoll: netconsole: local IPv4 address 192.168.1.20
> [   33.516006] netpoll: netconsole: interface 'eth0'
> [   33.530072] netpoll: netconsole: remote port 6666
> [   33.544275] netpoll: netconsole: remote IPv4 address 192.168.1.128
> [   33.558569] netpoll: netconsole: remote ethernet address ff:ff:ff:ff:f=
f:ff
> [   33.572813] netpoll: netconsole: device eth0 not up yet, forcing it
> [   33.586981] tg3 0000:06:00.0: irq 91 for MSI/MSI-X
> [   33.683276] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
> [   34.091924] scsi6: error handler thread failed to spawn, error =3D -12
> [   34.105904] mptsas: ioc0: WARNING - Unable to register controller with=
 SCSI subsystem
> [   34.120160] BUG: unable to handle kernel NULL pointer dereference at 0=
000000000000060
> [   34.134430] IP: [<ffffffff814a5099>] mutex_lock+0x9/0x25
> [   34.148658] PGD 0=20
> [   34.162680] Oops: 0002 [#1] SMP=20
> [   34.176706] Modules linked in: netconsole(+) configfs sg sr_mod cdrom =
hid_generic usbhid hid mptsas(+) tg3 ahci scsi_transport_sas ptp mptscsih l=
ibahci uhci_hcd ehci_pci libata mptbase ehci_hcd pps_core libphy scsi_mod u=
sbcore usb_common
> [   34.207141] CPU: 0 PID: 204 Comm: modprobe Tainted: G          I  3.13=
-1-amd64 #1 Debian 3.13.5-1
> [   34.222620] Hardware name: Dell Inc. Precision WorkStation T5500  /0D8=
83F, BIOS A05 04/12/2010
> [   34.238232] task: ffff880312060010 ti: ffff880312126000 task.ti: ffff8=
80312126000
> [   34.253972] RIP: 0010:[<ffffffff814a5099>]  [<ffffffff814a5099>] mutex=
_lock+0x9/0x25
> [   34.270077] RSP: 0018:ffff880312127ba8  EFLAGS: 00010246
> [   34.286124] RAX: 0000000000000000 RBX: 0000000000000060 RCX: 000000000=
0001464
> [   34.302018] RDX: 0000000000001464 RSI: 0000000000000046 RDI: 000000000=
0000060
> [   34.317456] RBP: 0000000000000060 R08: 0000000000000000 R09: 000000000=
0000312
> [   34.332672] R10: 000000000000000f R11: 0000000007070707 R12: ffff88031=
6372000
> [   34.347735] R13: ffff880316372098 R14: ffffffffa014a3f0 R15: 000000000=
0000001
> [   34.362525] FS:  00007fed06cf3700(0000) GS:ffff880323200000(0000) knlG=
S:0000000000000000
> [   34.377141] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [   34.391580] CR2: 0000000000000060 CR3: 000000031202a000 CR4: 000000000=
00007f0
> [   34.406043] Stack:
> [   34.420328]  0000000000000000 ffffffffa019f4f3 0000000000000000 ffff88=
0316051000
> [   34.435163]  ffff880316372000 ffffffffa009c215 ffff880316051000 000000=
00ffffffff
> [   34.449977]  ffff880316372000 ffffffffa0146fa8 ffff880316372000 000000=
0000000000
> [   34.464604] Call Trace:
> [   34.479035]  [<ffffffffa019f4f3>] ? scsi_remove_host+0x13/0x100 [scsi_=
mod]
> [   34.493578]  [<ffffffffa009c215>] ? mptscsih_remove+0x25/0x80 [mptscsi=
h]
> [   34.507795]  [<ffffffffa0146fa8>] ? mptsas_probe+0x398/0x4a0 [mptsas]
> [   34.521684]  [<ffffffff812a0e8a>] ? local_pci_probe+0x3a/0xa0
> [   34.535584]  [<ffffffff812a219a>] ? pci_device_probe+0xca/0x120
> [   34.549436]  [<ffffffff81354c78>] ? driver_probe_device+0x68/0x220
> [   34.562960]  [<ffffffff81354eeb>] ? __driver_attach+0x7b/0x80
> [   34.576082]  [<ffffffff81354e70>] ? __device_attach+0x40/0x40
> [   34.588726]  [<ffffffff81353033>] ? bus_for_each_dev+0x53/0x90
> [   34.600982]  [<ffffffff81354430>] ? bus_add_driver+0x170/0x220
> [   34.612910]  [<ffffffffa014d000>] ? 0xffffffffa014cfff
> [   34.624691]  [<ffffffff81355486>] ? driver_register+0x56/0xd0
> [   34.636367]  [<ffffffffa014d000>] ? 0xffffffffa014cfff
> [   34.647907]  [<ffffffffa014d11a>] ? mptsas_init+0x11a/0x1000 [mptsas]
> [   34.659558]  [<ffffffff81002162>] ? do_one_initcall+0x112/0x170
> [   34.671205]  [<ffffffff810c6937>] ? load_module+0x1b07/0x23f0
> [   34.682908]  [<ffffffff810c3530>] ? m_show+0x1c0/0x1c0
> [   34.694597]  [<ffffffff810c734d>] ? SyS_finit_module+0x6d/0x70
> [   34.706285]  [<ffffffff814adb39>] ? system_call_fastpath+0x16/0x1b
> [   34.718018] Code: 00 00 48 89 e6 4c 89 f7 e8 35 56 bf ff e9 40 ff ff f=
f b8 01 00 00 00 e9 87 fe ff ff 66 0f 1f 44 00 00 53 48 89 fb e8 57 e4 ff f=
f <f0> ff 0b 79 08 48 89 df e8 3a fe ff ff 65 48 8b 04 25 40 c8 00=20
> [   34.742873] RIP  [<ffffffff814a5099>] mutex_lock+0x9/0x25
> [   34.754928]  RSP <ffff880312127ba8>
> [   34.766735] CR2: 0000000000000060
> [   34.778493] ---[ end trace 7cf83da47bb3f354 ]---

--=20
Ben Hutchings
When you say `I wrote a program that crashed Windows', people just stare ..=
.
and say `Hey, I got those with the system, *for free*'. - Linus Torvalds

--=-QEZQsM7UwKWA9u49nwW/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIUAwUAUySOF+e/yOyVhhEJAQo0Lg/46T42DwKskJUrouDK1roSRwG4pVwIyBF/
ujgbLKb1+CR5Kmzi8x5QCw7ovq4sWNigBNX5O81mr2xN0ZIC+zJIs7yEvpryc/av
IyFtAULzfMQ+plaTe5HELusbhpE04XQvKz/F28IN0qJZwF/QXCbHnqvazjCVtdzx
+kFfPvmr6+MJhLLls3eg/PkG6WIuKeARsoiv6RcCDUWlH3/Ysyz/1cV9vQpIgAFN
NLlJITCpzEldOeQrnzysI7DigqWeNqk2TXVipnq39DvG1opUIsSA6ws/4zTjD7ub
cUwJJ1ZprKu2TSmrFXivi0hnbU6AtqTphrgE1KA6yRVvapgjK38XWjeFf11XLyva
xJXNfGMICLRrB3I7FCCpmVtWLXHz3NO7TkCOcNbAFNtAx+M4deRbJ6vbHiaOC+j6
BFPg1FahRiXoVbDbHr3LR0IaGPuVf5xCN9se4EyoiO6tsvXl7IH3UjQND7QRACTx
8X8ZPoaeeRSmAuErlw1NMkkakMVcpZBtk49FZezhl3MEUmw8op7ZY7sJDhhSSEzb
XVUbIliWbilD49AiN2H2secRwHLX7taBbFbN4PxT8Sd1ylgwLVOMCANu0iRlwYMb
hJSlsDGCgYrQwvhxfH1MJsPgdlu9AQqkXHI9RmSQSC6mow6/GjggzDZ1kvD4F3b+
fgPweA7hlw==
=4e+I
-----END PGP SIGNATURE-----

--=-QEZQsM7UwKWA9u49nwW/--
