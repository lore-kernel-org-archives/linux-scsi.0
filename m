From: Krzysztof =?utf-8?q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Subject: aic94xx or libsas crash on X7DB3 supermicro with enclosure and sata drives
Date: Fri, 30 Nov 2007 10:22:07 +0100
Message-ID: <200711301022.08001.kb@sysmikro.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from v007470.home.net.pl ([212.85.125.104]:58618 "HELO
	v007470.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751071AbXK3J2y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Nov 2007 04:28:54 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vladislav Bolkhovitin <vlad@vlnb.net>

Hello all,

I noticed this according to syslog. furthermore if aic94xx is connected=
 to=20
single sata drive only then there is no crash but device is not recogni=
zed=20
too. (mysterious: "ERROR: Unidentified device type 5").

A crash recorded in syslog:

aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 16 (level, low) -> IRQ 16
aic94xx: found Adaptec AIC-9410W SAS/SATA Host Adapter, device 0000:04:=
02.0
scsi6 : aic94xx
PM: Adding info for No Bus:host6
PM: Adding info for No Bus:0000:04:02.0
PM: Removing info for No Bus:0000:04:02.0
aic94xx: Found sequencer Firmware version 1.1 (V30)
aic94xx: device 0000:04:02.0: SAS addr 500304800004ce20, PCBA SN ORG, 8=
 phys,=20
8 enabled phys, flash present, BIOS build 1822
PM: Adding info for No Bus:phy-6:0

<snip>

BUG: unable to handle kernel NULL pointer dereference at virtual addres=
s=20
00000074
=A0printing eip:
f8e2daf9
*pde =3D 00000000
Oops: 0000 [#1]
SMP=20
Modules linked in: aic94xx firmware_class libsas scsi_transport_sas nfs=
d=20
exportfs nvram speedstep_lib freq_table thermal processor fan button ba=
ttery=20
edd ac ipv6 evdev joydev sr_mod ide_cd cdrom e1000 ehci_hcd i2c_i801 uh=
ci_hcd=20
rng_core dm_mod usbcore
CPU: =A0 =A00
EIP: =A0 =A00060:[<f8e2daf9>] =A0 =A0Not tainted VLI
EFLAGS: 00010286 =A0 (2.6.22.8 #6)
EIP is at sas_rphy_add+0x9/0x100 [scsi_transport_sas]
eax: 00000000 =A0 ebx: 00000000 =A0 ecx: 00000004 =A0 edx: 00000282
esi: f2d8c080 =A0 edi: 00000000 =A0 ebp: f2d8c080 =A0 esp: f33bbe84
ds: 007b =A0 es: 007b =A0 fs: 00d8 =A0gs: 0000 =A0ss: 0068
Process scsi_wq_6 (pid: 8265, ti=3Df33ba000 task=3Df5712a90 task.ti=3Df=
33ba000)
Stack: f2d8c080 00000000 00000000 f2d8c080 f2d8c0d7 f2d8c080 f8e8bdc2 f=
46b49e0=20
=A0 =A0 =A0 =A0f2d8c114 f8e8d040 f7c4446c f704e724 f704e6c0 00000000 00=
000001 00000000=20
=A0 =A0 =A0 =A0f46b49fc f8e8d741 f7c44438 00000000 f33bbedc 402e9267 f7=
c44380 ffffffed=20
Call Trace:
=A0[<f8e8bdc2>] sas_discover_sata+0x42/0x80 [libsas]
=A0[<f8e8d040>] sas_ex_discover_end_dev+0x120/0x2d0 [libsas]
=A0[<f8e8d741>] sas_ex_discover_dev+0x2d1/0x470 [libsas]
=A0[<402e9267>] attribute_container_device_trigger+0xa7/0xb0
=A0[<f8e8daa3>] sas_ex_discover_devices+0x83/0xb0 [libsas]
=A0[<f8e8e6d3>] sas_ex_level_discovery+0x43/0x70 [libsas]
=A0[<f8e8e71b>] sas_ex_bfs_disc+0x1b/0x30 [libsas]
=A0[<f8e8e76e>] sas_discover_root_expander+0x3e/0x80 [libsas]
=A0[<f8e8bf40>] sas_discover_domain+0x0/0xc0 [libsas]
=A0[<f8e8bfea>] sas_discover_domain+0xaa/0xc0 [libsas]
=A0[<40131541>] run_workqueue+0x71/0x100
=A0[<4013167c>] worker_thread+0xac/0x110
=A0[<401352a0>] autoremove_wake_function+0x0/0x50
=A0[<401352a0>] autoremove_wake_function+0x0/0x50
=A0[<401315d0>] worker_thread+0x0/0x110
=A0[<40134d24>] kthread+0x64/0xa0
=A0[<40134cc0>] kthread+0x0/0xa0
=A0[<401048b7>] kernel_thread_helper+0x7/0x10
=A0=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: f0 83 c4 1c 5b 5e 5f 5d c3 0f 0b 8d b4 26 00 00 00 00 eb fe 8d b4=
 26 00=20
00 00 00 8d bc 27 00 00 00 00 55 57 89 c7 56 53 83 ec 08 <8b> 70 74 8b =
5e 74=20
eb 0b 8b 43 74 31 d2 85 c0 74 13 89 c3 89 d8=20
EIP: [<f8e2daf9>] sas_rphy_add+0x9/0x100 [scsi_transport_sas] SS:ESP=20
0068:f33bbe84


let me know if you need any more information. i used latest firmware av=
ailable=20
from Adaptec's site.

Best regards,
Krzysztof Blaszkowski

Systemy mikroprocesorowe
Storrady 1
PL71602 Szczecin, Poland
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
