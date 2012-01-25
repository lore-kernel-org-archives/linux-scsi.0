From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: READ CAPACITY(16) failed, failure in mpt2sas_transport_port_add
Date: Wed, 25 Jan 2012 10:52:34 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6048BC1A2FE@inbmail02.lsi.com>
References: <20120125015725.GA2938@tuon>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_A6888A6805518E4EA4AF7072A28264A6048BC1A2FEinbmail02lsic_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:49551 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812Ab2AYFWn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2012 00:22:43 -0500
In-Reply-To: <20120125015725.GA2938@tuon>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kevin Shanahan <kmshanah@disenchant.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--_002_A6888A6805518E4EA4AF7072A28264A6048BC1A2FEinbmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Kevin,
Request to apply the attached patch and test.=20

Regards,
Nagalakshmi


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Kevin Shanahan
Sent: Wednesday, January 25, 2012 7:27 AM
To: linux-scsi@vger.kernel.org
Subject: READ CAPACITY(16) failed, failure in mpt2sas_transport_port_add

Hi,

I wonder if someone can tell me what's going on with this new SAS controlle=
r. I swapped out my old Marvell based controller for a new Intel RS25GB008 =
and it seems that it never detects all the disks correctly (there are 4 att=
ached to this controller).

Trying to pull out the relevant bits of dmesg (full version attached):

[    4.197386] mpt2sas version 10.100.00.00 loaded
[    4.197501] scsi2 : Fusion MPT SAS Host
[    4.197825] mpt2sas 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IR=
Q 16
[    4.197835] mpt2sas 0000:01:00.0: setting latency timer to 64
[    4.197840] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem=
 (8146696 kB)
[    4.197933] mpt2sas 0000:01:00.0: irq 47 for MSI/MSI-X
[    4.197938] mpt2sas 0000:01:00.0: irq 48 for MSI/MSI-X
[    4.197943] mpt2sas 0000:01:00.0: irq 49 for MSI/MSI-X
[    4.197948] mpt2sas 0000:01:00.0: irq 50 for MSI/MSI-X
[    4.197981] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 47
[    4.197983] mpt2sas0-msix1: PCI-MSI-X enabled: IRQ 48
[    4.197984] mpt2sas0-msix2: PCI-MSI-X enabled: IRQ 49
[    4.197986] mpt2sas0-msix3: PCI-MSI-X enabled: IRQ 50
[    4.197987] mpt2sas0: iomem(0x00000000dfef0000), mapped(0xffffc900122e00=
00), size(65536)
[    4.197989] mpt2sas0: ioport(0x000000000000de00), size(256)
[    4.440008] mpt2sas0: sending message unit reset !!
[    4.446683] mpt2sas0: message unit reset: SUCCESS
[    4.590327] mpt2sas0: Allocated physical memory: size(11195 kB)
[    4.590330] mpt2sas0: Current Controller Queue Depth(4859), Max Controll=
er Queue Depth(5120)
[    4.590332] mpt2sas0: Scatter Gather Elements per IO(128)
[    4.790353] mpt2sas0: LSISAS2308: FWVersion(09.00.00.00), ChipRevision(0=
x01), BiosVersion(07.17.03.00)
[    4.790356] mpt2sas0: Intel(R) RAID Controller RS25GB008
[    4.790358] mpt2sas0: Protocol=3D(Initiator,Target), Capabilities=3D(TLR=
,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[    4.790423] mpt2sas0: sending port enable !!
[    4.792873] mpt2sas0: host_add: handle(0x0001), sas_addr(0x500605b003f34=
c80), phys(8)
[    4.803344] mpt2sas0: port enable: SUCCESS
[    4.814391] scsi 2:0:0:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A=
80 PQ: 0 ANSI: 5
[    4.814397] scsi 2:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221100000=
000), phy(0), device_name(0x4ee250019f620672)
[    4.814400] scsi 2:0:0:0: SATA: enclosure_logical_id(0x500605b003f34c80)=
, slot(0)
[    4.814489] scsi 2:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fu=
a(y), sw_preserve(y)
[    4.814498] scsi 2:0:0:0: qdepth(32), tagged(1), simple(0), ordered(0), =
scsi_level(6), cmd_que(1)
[    4.820459] sd 2:0:0:0: [sdc] physical block alignment offset: 4096
[    4.820465] sd 2:0:0:0: [sdc] 5860533168 512-byte logical blocks: (3.00 =
TB/2.72 TiB)
[    4.820468] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    4.829459] scsi 2:0:1:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A=
80 PQ: 0 ANSI: 5
[    4.829465] scsi 2:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221101000=
000), phy(1), device_name(0x4ee250010e9c0673)
[    4.829468] scsi 2:0:1:0: SATA: enclosure_logical_id(0x500605b003f34c80)=
, slot(1)
[    4.829546] scsi 2:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fu=
a(y), sw_preserve(y)
[    4.829551] scsi 2:0:1:0: qdepth(32), tagged(1), simple(0), ordered(0), =
scsi_level(6), cmd_que(1)
[    4.837538] sd 2:0:1:0: [sdd] physical block alignment offset: 4096
[    4.837543] sd 2:0:1:0: [sdd] 5860533168 512-byte logical blocks: (3.00 =
TB/2.72 TiB)
[    4.837545] sd 2:0:1:0: [sdd] 4096-byte physical blocks
[    4.844069] scsi 2:0:2:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A=
80 PQ: 0 ANSI: 5
[    4.844075] scsi 2:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221102000=
000), phy(2), device_name(0x4ee25001c81a5bc7)
[    4.844078] scsi 2:0:2:0: SATA: enclosure_logical_id(0x500605b003f34c80)=
, slot(2)
[    4.844153] scsi 2:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fu=
a(y), sw_preserve(y)
[    4.844158] scsi 2:0:2:0: qdepth(32), tagged(1), simple(0), ordered(0), =
scsi_level(6), cmd_que(1)
[    4.851179] sd 2:0:2:0: [sde] physical block alignment offset: 4096
[    4.851184] sd 2:0:2:0: [sde] 5860533168 512-byte logical blocks: (3.00 =
TB/2.72 TiB)
[    4.851186] sd 2:0:2:0: [sde] 4096-byte physical blocks
[    4.851459] sd 2:0:0:0: [sdc] Write Protect is off
[    4.851463] sd 2:0:0:0: [sdc] Mode Sense: 7f 00 00 08
[    4.857728] scsi 2:0:3:0: Direct-Access     ATA      WDC WD30EZRX-00A 0A=
80 PQ: 0 ANSI: 5
[    4.857734] scsi 2:0:3:0: SATA: handle(0x000c), sas_addr(0x4433221103000=
000), phy(3), device_name(0x4ee250010d1e0673)
[    4.857737] scsi 2:0:3:0: SATA: enclosure_logical_id(0x500605b003f34c80)=
, slot(3)
[    4.857809] scsi 2:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fu=
a(y), sw_preserve(y)
[    4.857814] scsi 2:0:3:0: qdepth(32), tagged(1), simple(0), ordered(0), =
scsi_level(6), cmd_que(1)
[    4.858145]  port-2:0: remove: sas_addr(0x4433221100000000)
[    4.858154]  port-2:0: remove: sas_addr(0x4433221100000000), phy(0)
[    4.862435] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.862589] sd 2:0:0:0: [sdc] READ CAPACITY(16) failed
[    4.862592] sd 2:0:0:0: [sdc]  Result: hostbyte=3D0x01 driverbyte=3D0x00
[    4.862594] sd 2:0:0:0: [sdc] Sense not available.
[    4.862623] sd 2:0:0:0: [sdc] READ CAPACITY failed
[    4.862626] sd 2:0:0:0: [sdc]  Result: hostbyte=3D0x01 driverbyte=3D0x00
[    4.862628] sd 2:0:0:0: [sdc] Sense not available.
[    4.862655] sd 2:0:0:0: [sdc] Asking for cache data failed
[    4.862902] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    4.863127] sdc: detected capacity change from 3000592982016 to 0
[    4.863199] sd 2:0:0:0: [sdc] READ CAPACITY(16) failed
[    4.863201] sd 2:0:0:0: [sdc]  Result: hostbyte=3D0x01 driverbyte=3D0x00
[    4.863203] sd 2:0:0:0: [sdc] Sense not available.
[    4.863222] sd 2:0:0:0: [sdc] READ CAPACITY failed
[    4.863223] sd 2:0:0:0: [sdc]  Result: hostbyte=3D0x01 driverbyte=3D0x00
[    4.863226] sd 2:0:0:0: [sdc] Sense not available.
[    4.863251] sd 2:0:0:0: [sdc] Asking for cache data failed
[    4.863477] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    4.863702] sd 2:0:0:0: [sdc] Attached SCSI disk
[    4.864690] sd 2:0:3:0: [sdf] physical block alignment offset: 4096
[    4.864695] sd 2:0:3:0: [sdf] 5860533168 512-byte logical blocks: (3.00 =
TB/2.72 TiB)
[    4.864698] sd 2:0:3:0: [sdf] 4096-byte physical blocks
[    4.876736] sd 2:0:1:0: [sdd] Write Protect is off
[    4.876740] sd 2:0:1:0: [sdd] Mode Sense: 7f 00 00 08
[    4.885584] sd 2:0:2:0: [sde] Write Protect is off
[    4.885588] sd 2:0:2:0: [sde] Mode Sense: 7f 00 00 08
[    4.891538] sd 2:0:1:0: [sdd] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.897125] sd 2:0:3:0: [sdf] Write Protect is off
[    4.897129] sd 2:0:3:0: [sdf] Mode Sense: 7f 00 00 08
[    4.900113] sd 2:0:2:0: [sde] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.910240] sd 2:0:3:0: [sdf] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[    4.974155]  sdf: sdf1
[    4.975438]  sdd: sdd1
[    4.983617]  sde: sde1
[    5.026685] sd 2:0:3:0: [sdf] Attached SCSI disk
[    5.032538] sd 2:0:1:0: [sdd] Attached SCSI disk
[    5.039178] sd 2:0:2:0: [sde] Attached SCSI disk
[    5.039528] mpt2sas0: removing handle(0x0009), sas_addr(0x44332211000000=
00)
[    5.039532] mpt2sas0: failure at drivers/scsi/mpt2sas/mpt2sas_transport.=
c:705/mpt2sas_transport_port_add()!

Usually if I hot-unplug and re-plug the disk in question it will be detecte=
d properly, but next reboot I have the same problem again.

Does anything there point towards a hardware/software problem? I notice the=
re's a newer RS25GB008 bios available, though I'll need to source a UEFI bo=
ard in order to install it.

Thanks,
Kevin.

--_002_A6888A6805518E4EA4AF7072A28264A6048BC1A2FEinbmail02lsic_
Content-Type: application/octet-stream;
	name="scsi-misc-2[1].6.git-2cb6fc8c014b9b00c4487a79b8f6ed0da4121f45.patch"
Content-Description: scsi-misc-2[1].6.git-2cb6fc8c014b9b00c4487a79b8f6ed0da4121f45.patch
Content-Disposition: attachment; filename=
	"scsi-misc-2[1].6.git-2cb6fc8c014b9b00c4487a79b8f6ed0da4121f45.patch";
	size=3221; creation-date="Tue, 17 Jan 2012 14:31:34 GMT";
	modification-date="Tue, 17 Jan 2012 14:40:49 GMT"
Content-Transfer-Encoding: base64

RnJvbSAyY2I2ZmM4YzAxNGI5YjAwYzQ0ODdhNzliOGY2ZWQwZGE0MTIxZjQ1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiAibmFnYWxha3NobWkubmFuZGlnYW1hQGxzaS5jb20iIDxuYWdh
bGFrc2htaS5uYW5kaWdhbWFAbHNpLmNvbT4KRGF0ZTogVHVlLCAxMyBEZWMgMjAxMSAwOToyOTox
NSArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIFtTQ1NJXSBtcHQyc2FzOiBSZW1vdmVkIHJlZHVuZGFu
dCBjYWxsaW5nIG9mCiBfc2NzaWhfcHJvYmVfZGV2aWNlcygpIGZyb20gX3Njc2loX3Byb2JlCgpS
ZW1vdmVkIHJlZHVuZGFudCBjYWxsaW5nIG9mIF9zY3NpaF9wcm9iZV9kZXZpY2VzKCkgZnJvbSBf
c2NzaWhfcHJvYmUgYXMKaXQgaXMgZ2V0dGluZyBjYWxsZWQgZnJvbSBfc2NzaWhfc2Nhbl9maW5p
c2hlZC4KCkFsc28gbW92ZWQgdGhlIGZ1bmN0aW9uIHNjc2lfc2Nhbl9ob3N0KHNob3N0KSB0byBn
ZXQgY2FsbGVkIGFmdGVyIHRoZQp2b2x1bWVzIG9uIHdhcnAgZHJpdmUgYXJlIHJlcG9ydGVkIHRv
IHRoZSBPUy4gT3RoZXJ3aXNlIGJ5IHRoZSB0aW1lCnRoZSAoaW9jLT5oaWRlX2RyaXZlcykgZmxh
Z3MgaXMgc2V0LCB0aGUgdm9sdW1lcyBvbiB3YXJwIGRyaXZlCmFyZSByZXBvcnRlZCB0byB0aGUg
T1MgYWxyZWFkeS4KCkFsc28gbW9kaWZpZWQgdGhlIGluaXRpYWxpemF0aW9uIG9mIHJlcGx5IHF1
ZXVlcyBvbmx5IGluIGNhc2Ugb2YgZHJpdmVyIGxvYWQKdGltZSBpbiB0aGUgZnVuY3Rpb24gX2Jh
c2VfbWFrZV9pb2Nfb3BlcmF0aW9uYWwoKS4KClNpZ25lZC1vZmYtYnk6IE5hZ2FsYWtzaG1pIE5h
bmRpZ2FtYSA8bmFnYWxha3NobWkubmFuZGlnYW1hQGxzaS5jb20+ClNpZ25lZC1vZmYtYnk6IEph
bWVzIEJvdHRvbWxleSA8SkJvdHRvbWxleUBQYXJhbGxlbHMuY29tPgotLS0KIGRyaXZlcnMvc2Nz
aS9tcHQyc2FzL21wdDJzYXNfYmFzZS5jICB8ICAgMjAgKysrKysrKy0tLS0tLS0tLS0tLS0KIGRy
aXZlcnMvc2NzaS9tcHQyc2FzL21wdDJzYXNfc2NzaWguYyB8ICAgIDMgKy0tCiAyIGZpbGVzIGNo
YW5nZWQsIDggaW5zZXJ0aW9ucygrKSwgMTUgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJp
dmVycy9zY3NpL21wdDJzYXMvbXB0MnNhc19iYXNlLmMgYi9kcml2ZXJzL3Njc2kvbXB0MnNhcy9t
cHQyc2FzX2Jhc2UuYwppbmRleCA0ODE5MTgxLi4wYjJjOTU1IDEwMDY0NAotLS0gYS9kcml2ZXJz
L3Njc2kvbXB0MnNhcy9tcHQyc2FzX2Jhc2UuYworKysgYi9kcml2ZXJzL3Njc2kvbXB0MnNhcy9t
cHQyc2FzX2Jhc2UuYwpAQCAtNDA5OSw3ICs0MDk5LDggQEAgX2Jhc2VfbWFrZV9pb2Nfb3BlcmF0
aW9uYWwoc3RydWN0IE1QVDJTQVNfQURBUFRFUiAqaW9jLCBpbnQgc2xlZXBfZmxhZykKIAkJaW9j
LT5yZXBseV9mcmVlW2ldID0gY3B1X3RvX2xlMzIocmVwbHlfYWRkcmVzcyk7CiAKIAkvKiBpbml0
aWFsaXplIHJlcGx5IHF1ZXVlcyAqLwotCV9iYXNlX2Fzc2lnbl9yZXBseV9xdWV1ZXMoaW9jKTsK
KwlpZiAoaW9jLT5pc19kcml2ZXJfbG9hZGluZykKKwkJX2Jhc2VfYXNzaWduX3JlcGx5X3F1ZXVl
cyhpb2MpOwogCiAJLyogaW5pdGlhbGl6ZSBSZXBseSBQb3N0IEZyZWUgUXVldWUgKi8KIAlyZXBs
eV9wb3N0X2ZyZWUgPSAobG9uZylpb2MtPnJlcGx5X3Bvc3RfZnJlZTsKQEAgLTQxNDcsMjQgKzQx
NDgsMTcgQEAgX2Jhc2VfbWFrZV9pb2Nfb3BlcmF0aW9uYWwoc3RydWN0IE1QVDJTQVNfQURBUFRF
UiAqaW9jLCBpbnQgc2xlZXBfZmxhZykKIAogCiAJaWYgKGlvYy0+aXNfZHJpdmVyX2xvYWRpbmcp
IHsKLQotCi0KLQkJaW9jLT53YWl0X2Zvcl9kaXNjb3ZlcnlfdG9fY29tcGxldGUgPQotCQkgICAg
X2Jhc2VfZGV0ZXJtaW5lX3dhaXRfb25fZGlzY292ZXJ5KGlvYyk7Ci0JCXJldHVybiByOyAvKiBz
Y2FuX3N0YXJ0IGFuZCBzY2FuX2ZpbmlzaGVkIHN1cHBvcnQgKi8KLQl9Ci0KLQotCWlmIChpb2Mt
PndhaXRfZm9yX2Rpc2NvdmVyeV90b19jb21wbGV0ZSAmJiBpb2MtPmlzX3dhcnBkcml2ZSkgewot
CQlpZiAoaW9jLT5tYW51X3BnMTAuT0VNSWRlbnRpZmllciAgPT0gMHg4MCkgeworCQlpZiAoaW9j
LT5pc193YXJwZHJpdmUgJiYgaW9jLT5tYW51X3BnMTAuT0VNSWRlbnRpZmllcgorCQkgICAgPT0g
MHg4MCkgewogCQkJaGlkZV9mbGFnID0gKHU4KSAoaW9jLT5tYW51X3BnMTAuT0VNU3BlY2lmaWNG
bGFnczAgJgogCQkJICAgIE1GR19QQUdFMTBfSElERV9TU0RTX01BU0spOwogCQkJaWYgKGhpZGVf
ZmxhZyAhPSBNRkdfUEFHRTEwX0hJREVfU1NEU19NQVNLKQogCQkJCWlvYy0+bWZnX3BnMTBfaGlk
ZV9mbGFnID0gaGlkZV9mbGFnOwogCQl9CisJCWlvYy0+d2FpdF9mb3JfZGlzY292ZXJ5X3RvX2Nv
bXBsZXRlID0KKwkJICAgIF9iYXNlX2RldGVybWluZV93YWl0X29uX2Rpc2NvdmVyeShpb2MpOwor
CQlyZXR1cm4gcjsgLyogc2Nhbl9zdGFydCBhbmQgc2Nhbl9maW5pc2hlZCBzdXBwb3J0ICovCiAJ
fQotCiAJciA9IF9iYXNlX3NlbmRfcG9ydF9lbmFibGUoaW9jLCBzbGVlcF9mbGFnKTsKIAlpZiAo
cikKIAkJcmV0dXJuIHI7CmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvbXB0MnNhcy9tcHQyc2Fz
X3Njc2loLmMgYi9kcml2ZXJzL3Njc2kvbXB0MnNhcy9tcHQyc2FzX3Njc2loLmMKaW5kZXggOGNk
NGViYi4uMTkzZTMzZSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zY3NpL21wdDJzYXMvbXB0MnNhc19z
Y3NpaC5jCisrKyBiL2RyaXZlcnMvc2NzaS9tcHQyc2FzL21wdDJzYXNfc2NzaWguYwpAQCAtODAz
OSw3ICs4MDM5LDYgQEAgX3Njc2loX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBz
dHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpCiAJCWdvdG8gb3V0X2F0dGFjaF9mYWlsOwogCX0KIAot
CXNjc2lfc2Nhbl9ob3N0KHNob3N0KTsKIAlpZiAoaW9jLT5pc193YXJwZHJpdmUpIHsKIAkJaWYg
KGlvYy0+bWZnX3BnMTBfaGlkZV9mbGFnID09ICBNRkdfUEFHRTEwX0VYUE9TRV9BTExfRElTS1Mp
CiAJCQlpb2MtPmhpZGVfZHJpdmVzID0gMDsKQEAgLTgwNTMsOCArODA1Miw4IEBAIF9zY3NpaF9w
cm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQgKmlk
KQogCQl9CiAJfSBlbHNlCiAJCWlvYy0+aGlkZV9kcml2ZXMgPSAwOworCXNjc2lfc2Nhbl9ob3N0
KHNob3N0KTsKIAotCV9zY3NpaF9wcm9iZV9kZXZpY2VzKGlvYyk7CiAJcmV0dXJuIDA7CiAKICBv
dXRfYXR0YWNoX2ZhaWw6Ci0tIAoxLjcuNi41Cgo=

--_002_A6888A6805518E4EA4AF7072A28264A6048BC1A2FEinbmail02lsic_--
