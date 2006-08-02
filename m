From: Robert Annessi <robert@annessi.at>
Subject: Re: dc395x: Report
Date: Wed, 02 Aug 2006 11:35:36 +0200
Message-ID: <44D071E8.8090001@annessi.at>
References: <44CF40F2.3080401@annessi.at> <Pine.LNX.4.60.0608020046510.8659@poirot.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig64902E8B982F01F6DB929129"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx-01.sil.at ([86.59.12.198]:50109 "EHLO mx-01.sil.at")
	by vger.kernel.org with ESMTP id S1751167AbWHBJfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 05:35:53 -0400
In-Reply-To: <Pine.LNX.4.60.0608020046510.8659@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig64902E8B982F01F6DB929129
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/02/06 01:24, Guennadi Liakhovetski wrote:
> On Tue, 1 Aug 2006, Robert Annessi wrote:
>>
>> The default settings of the module were not applicable for me.
>> When loading the module (or the driver builtin within the kernel) with=
out any
>> additional arguments I got a bunch of these error messages:
>> "dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds"
>> (about 10 per second) and I was not able to access the disk.
>=20
> Ok, I think:
>=20
> 1) your _device_ is buggy. If you look in drivers/scsi/scsi_devinfo.c i=
n=20
> scsi_static_device_list[] blask list, you'll find 2 more SEAGATE drives=
=20
> with problems with tagged commands. Try adding your drive to the list a=
lso=20
> with BLIST_NOTQ like


It's a decent drive I used with other controllers before - and it worked
out of the box. But maybe it's really a buggy drive..


> {"SEAGATE", "ST3146807LC", "0007", BLIST_NOTQ}
>=20
> or you can build dc395x as a module and before loading it add your devi=
ce=20
> to /proc/scsi/device_info. Actually, you can even try it with your 2.6.=
16=20
> kernel, ...
>=20
> !!! Oh, no... dc395x doesn't use the generic blacklist table... Anyone =
to=20
> fix it? Until it is fixed you should forget the above and could try=20
> disabling it in the driver by either
>=20
> a) uncommenting the line
>=20
> #define DC395x_NO_TAGQ
>=20
> b) removing " | NTC_DO_TAG_QUEUEING" from dev mode from cfg_data
>=20
> c) some other dirty trick...
>=20
> 2) dc395x was not patched for 2.6.17, only for 2.6.18-rc*, so, would be=
=20
> quite interesting if you could test with that. We haven't had any repor=
ts=20
> with wide devices with this "help improve support" problem yet.
>=20
> 3) if you do get round to testing your system under 2.6.18-rcX, please =

> first test with vanilla kernel without parameters, then with safe=3D1, =
then=20
> with your disk added to the blacklist (hacked dc395x.c) without and (if=
=20
> still needed) with safe=3D1. Please, send all (distinct) negotiation=20
> protocols from these tests.


Short answer: it works (more or less).

Long answer:
I tested it with a vanilla 2.6.18-rc3 and workaround a) "uncommenting
#define DC395x_NO_TAGQ in dc395x.c".

Notes:
"unknown partition table" is fine. The disk does not have a valid
partition table (dm-crypted the whole disk).
I wonder why the dc395x driver version is still the same as in 2.6.16..?

Anyway, the results are below.

Regards,
Robert



Vanilla module with no additional arguments:
<snip>
dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

PCI: Enabling device 0000:00:02.0 (0100 -> 0103)
PCI: Found IRQ 11 for device 0000:00:02.0
dc395x: Used settings: AdapterID=3D07, Speed=3D0(20.0MHz), dev_mode=3D0x3=
7
dc395x:                AdaptMode=3D0x4e, Tags=3D0(01), DelayReset=3D1s
dc395x: (Wide) Connectors: int68  Termination: Auto Low High
dc395x: Performing initial SCSI bus reset
scsi1 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

dc395x: Target 00: Wide16 Sync: 48ns Offset 15 (41.7 MB/s)
  Vendor: SEAGATE   Model: ST3146807LC       Rev: 0007
  Type:   Direct-Access                      ANSI SCSI revision: 03
sda : READ CAPACITY failed.
sda : status=3D12, message=3D00, host=3D7, driver=3D00
sda : sense not available.
sda: test WP failed, assume Write Enabled
sda: asking for cache data failed
sda: assuming drive cache: write through
sda : READ CAPACITY failed.
sda : status=3D12, message=3D00, host=3D7, driver=3D00
sda : sense not available.
sda: test WP failed, assume Write Enabled
sda: asking for cache data failed
sda: assuming drive cache: write through
 sda:<6>dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
<snap>


Vanilla module and safe=3D1:
<snip>
dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

PCI: setting IRQ 11 as level-triggered
PCI: Found IRQ 11 for device 0000:00:02.0
dc395x: Using safe settings.
dc395x: Used settings: AdapterID=3D07, Speed=3D4(06.7MHz), dev_mode=3D0x0=
9
dc395x:                AdaptMode=3D0x0f, Tags=3D2(04), DelayReset=3D3s
dc395x: (Wide) Connectors: int68  Termination: Auto Low High
dc395x: Performing initial SCSI bus reset
scsi0 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

  Vendor: SEAGATE   Model: ST3146807LC       Rev: 0007
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
sda: Write Protect is off
sda: Mode Sense: ab 00 10 08
SCSI device sda: drive cache: write back w/ FUA
SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
sda: Write Protect is off
sda: Mode Sense: ab 00 10 08
SCSI device sda: drive cache: write back w/ FUA
 sda: unknown partition table
sd 0:0:0:0: Attached scsi disk sda
<snap>


Module with NO_TAGQ workaround and no additional arguments:
<snip>
dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

PCI: Enabling device 0000:00:02.0 (0100 -> 0103)
PCI: Found IRQ 11 for device 0000:00:02.0
dc395x: Used settings: AdapterID=3D07, Speed=3D0(20.0MHz), dev_mode=3D0x3=
7
dc395x:                AdaptMode=3D0x4e, Tags=3D0(01), DelayReset=3D1s
dc395x: (Wide) Connectors: int68  Termination: Auto Low High
dc395x: Performing initial SCSI bus reset
scsi1 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

dc395x: Target 00: Wide16 Sync: 48ns Offset 15 (41.7 MB/s)
  Vendor: SEAGATE   Model: ST3146807LC       Rev: 0007
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
BUG: warning at drivers/scsi/dc395x.c:2329/data_in_phase0()
 [<f884c768>] data_in_phase0+0x190/0x244 [dc395x]
 [<f884c15e>] dc395x_handle_interrupt+0xf7/0x128 [dc395x]
 [<f884c1c0>] dc395x_interrupt+0x31/0x5f [dc395x]
 [<c0137975>] handle_IRQ_event+0x21/0x49
 [<c0137a2e>] __do_IRQ+0x91/0xef
 [<c0104a2f>] do_IRQ+0x43/0x50
 [<c01032aa>] common_interrupt+0x1a/0x20
sda: Write Protect is off
sda: Mode Sense: ab 00 10 08
BUG: warning at drivers/scsi/dc395x.c:2329/data_in_phase0()
 [<f884c768>] data_in_phase0+0x190/0x244 [dc395x]
 [<f884c15e>] dc395x_handle_interrupt+0xf7/0x128 [dc395x]
 [<f884c1c0>] dc395x_interrupt+0x31/0x5f [dc395x]
 [<c0137975>] handle_IRQ_event+0x21/0x49
 [<c0137a2e>] __do_IRQ+0x91/0xef
 [<c0104a2f>] do_IRQ+0x43/0x50
 [<c01032aa>] common_interrupt+0x1a/0x20
SCSI device sda: drive cache: write back w/ FUA
SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
BUG: warning at drivers/scsi/dc395x.c:2329/data_in_phase0()
 [<f884c768>] data_in_phase0+0x190/0x244 [dc395x]
 [<f884c15e>] dc395x_handle_interrupt+0xf7/0x128 [dc395x]
 [<f884c1c0>] dc395x_interrupt+0x31/0x5f [dc395x]
 [<c0137975>] handle_IRQ_event+0x21/0x49
 [<c0137a2e>] __do_IRQ+0x91/0xef
 [<c0104a2f>] do_IRQ+0x43/0x50
 [<c01032aa>] common_interrupt+0x1a/0x20
 [<c0100b10>] default_idle+0x0/0x59
 [<c0100b41>] default_idle+0x31/0x59
 [<c0100c25>] cpu_idle+0xa8/0xcf
 [<c03c07b7>] start_kernel+0x1b6/0x1b8
sda: Write Protect is off
sda: Mode Sense: ab 00 10 08
BUG: warning at drivers/scsi/dc395x.c:2329/data_in_phase0()
 [<f884c768>] data_in_phase0+0x190/0x244 [dc395x]
 [<f884c15e>] dc395x_handle_interrupt+0xf7/0x128 [dc395x]
 [<f884c1c0>] dc395x_interrupt+0x31/0x5f [dc395x]
 [<c0137975>] handle_IRQ_event+0x21/0x49
 [<c0137a2e>] __do_IRQ+0x91/0xef
 [<c0104a2f>] do_IRQ+0x43/0x50
 [<c01032aa>] common_interrupt+0x1a/0x20
 [<c0100b10>] default_idle+0x0/0x59
 [<c0100b41>] default_idle+0x31/0x59
 [<c0100c25>] cpu_idle+0xa8/0xcf
 [<c03c07b7>] start_kernel+0x1b6/0x1b8
SCSI device sda: drive cache: write back w/ FUA
 sda: unknown partition table
sd 1:0:0:0: Attached scsi disk sda
<snap>


Module with NO_TAGQ workaround and safe=3D1:
<snip>
dc395x: Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

PCI: Enabling device 0000:00:02.0 (0100 -> 0103)
PCI: Found IRQ 11 for device 0000:00:02.0
dc395x: Using safe settings.
dc395x: Used settings: AdapterID=3D07, Speed=3D4(06.7MHz), dev_mode=3D0x0=
9
dc395x:                AdaptMode=3D0x0f, Tags=3D2(04), DelayReset=3D3s
dc395x: (Wide) Connectors: int68  Termination: Auto Low High
dc395x: Performing initial SCSI bus reset
scsi2 : Tekram DC395(U/UW/F), DC315(U) - ASIC TRM-S1040 v2.05, 2004/03/08=

  Vendor: SEAGATE   Model: ST3146807LC       Rev: 0007
  Type:   Direct-Access                      ANSI SCSI revision: 03
SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
sda: Write Protect is off
sda: Mode Sense: ab 00 10 08
SCSI device sda: drive cache: write back w/ FUA
SCSI device sda: 286749488 512-byte hdwr sectors (146816 MB)
sda: Write Protect is off
sda: Mode Sense: ab 00 10 08
SCSI device sda: drive cache: write back w/ FUA
 sda: unknown partition table
sd 2:0:0:0: Attached scsi disk sda
<snap>


--------------enig64902E8B982F01F6DB929129
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iEYEARECAAYFAkTQcewACgkQVoNfMxmfyFPlPgCdFPGSyIDwS682Qb5v5tPDE7Eo
bjwAn2AEvsYmPo+hK5YIXkZz95GJmrB7
=9a0R
-----END PGP SIGNATURE-----

--------------enig64902E8B982F01F6DB929129--
