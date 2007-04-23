From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: AACRAID fails to initialize after an kexec operation
Date: Mon, 23 Apr 2007 09:01:25 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0188ADBF@otce2k301.adaptec.com>
References: <20070423074913.GC14664@in.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C785A7.823BC347"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:38873 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161537AbXDWNBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Apr 2007 09:01:31 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070423074913.GC14664@in.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vgoyal@in.ibm.com, linux-scsi@vger.kernel.org
Cc: Kexec Mailing List <kexec@lists.infradead.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C785A7.823BC347
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

2.6.21-rc6-mm1 contains an earlier kexec patch, that one needs to be
removed and this one put in it's place.

Basically the following fragment represents the update in the later
patch that deals with this specific issue.

diff -ru a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
@@ -535,6 +539,8 @@
        }

        /* Failure to reset here is an option ... */
+       dev->a_ops.adapter_sync_cmd =3D rx_sync_cmd;
+       dev->a_ops.adapter_enable_int =3D aac_rx_disable_interrupt;
        dev->OIMR =3D status =3D rx_readb (dev, MUnit.OIMR);
        if ((((status & 0xff) !=3D 0xff) || reset_devices) &&
          !aac_rx_restart_adapter(dev, 0))

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@in.ibm.com]=20
> Sent: Monday, April 23, 2007 3:49 AM
> To: linux-scsi@vger.kernel.org; AACRAID
> Cc: Kexec Mailing List; Salyzyn, Mark
> Subject: AACRAID fails to initialize after an kexec operation
>=20
>=20
> Hi,
>=20
> I am trying to kexec into 2.6.21-rc6-mm1 kernel on an x86_64=20
> machine and
> aacraid panics in the second kernel. Following is the panic message.
>=20
> Any idea what's going on? Please let me know if more details=20
> are required.
>=20
> Adaptec aacraid driver (1.1-5[2437]-mh4)
> ACPI: PCI Interrupt 0000:01:02.0[A] -> GSI 25 (level, low) -> IRQ 25
> Unable to handle kernel NULL pointer dereference at=20
> 0000000000000000 RIP:
>  [<0000000000000000>]
> PGD 0
> Oops: 0000 [1] SMP
> last sysfs file:
> CPU 4
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.21-rc6-mm1 #2
> RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
> RSP: 0018:ffff810100c9fc78  EFLAGS: 00010246
> RAX: ffff810100c9fcc4 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000001001 RDI: ffff810100e02d30
> RBP: ffff810100e02d30 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000002 R12: ffff810100e02800
> R13: 0000000000000000 R14: ffffffff80690ee1 R15: 000000000000002d
> FS:  0000000000000000(0000) GS:ffff810100cf6440(0000)=20
> knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006e0
> Process swapper (pid: 1, threadinfo ffff810100c9e000, task=20
> ffff810100c9d450)
> Stack:  ffffffff8045952f 0000000000000000 ffffffff00000000=20
> ffff810100c9fcc4
>  0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  ffffffff80690ee1 000000000000002d ffff810100e02d30 0000000000000001
> Call Trace:
> Inexact backtrace:
>  [<ffffffff8045952f>] aac_rx_restart_adapter+0x7e/0x169
>  [<ffffffff80459a0a>] _aac_rx_init+0x70/0x2f6
>  [<ffffffff80280ee4>] cache_alloc_refill+0xdb/0x1db
>  [<ffffffff8045317f>] aac_probe_one+0x1a9/0x462
>  [<ffffffff8035f3a0>] pci_device_probe+0xd1/0x138
>  [<ffffffff803b3251>] driver_probe_device+0xf7/0x174
>  [<ffffffff803b33e4>] __driver_attach+0x6f/0xae
>  [<ffffffff803b3375>] __driver_attach+0x0/0xae
>  [<ffffffff803b3375>] __driver_attach+0x0/0xae
>  [<ffffffff803b261e>] bus_for_each_dev+0x43/0x6e
>  [<ffffffff803b2993>] bus_add_driver+0x78/0x19a
>  [<ffffffff8035f578>] __pci_register_driver+0x58/0x8d
>  [<ffffffff8084a909>] aac_init+0x35/0x70
>  [<ffffffff8082d8ad>] kernel_init+0x167/0x2d1
>  [<ffffffff8020a998>] child_rip+0xa/0x12
>  [<ffffffff8036bd60>] acpi_ds_init_one_object+0x0/0x7c
>  [<ffffffff8082d746>] kernel_init+0x0/0x2d1
>  [<ffffffff8020a98e>] child_rip+0x0/0x12
>=20
>=20
> Code:  Bad RIP value.
> RIP  [<0000000000000000>]
>  RSP <ffff810100c9fc78>
> CR2: 0000000000000000
> Kernel panic - not syncing: Attempted to kill init!
>=20
> Thanks
> Vivek
>=20

------_=_NextPart_001_01C785A7.823BC347
Content-Type: application/octet-stream;
	name="aacraid_kexec_5.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_kexec_5.patch
Content-Disposition: attachment;
	filename="aacraid_kexec_5.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jIGIvZHJpdmVycy9zY3NpL2FhY3Jh
aWQvcnguYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jCTIwMDctMDQtMDMgMTE6MzE6
NDAuMjg4MTE0MzY1IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMJMjAwNy0w
NC0wMyAxMTozNDoxMi41NjA4NzM1MzAgLTA0MDAKQEAgLTQ2NywxNiArNDY3LDE5IEBACiAJaWYg
KGJsZWQpCiAJCXByaW50ayhLRVJOX0VSUiAiJXMlZDogYWRhcHRlciBrZXJuZWwgcGFuaWMnZCAl
eC5cbiIsCiAJCQlkZXYtPm5hbWUsIGRldi0+aWQsIGJsZWQpOwotCWVsc2UKKwllbHNlIHsKIAkJ
YmxlZCA9IGFhY19hZGFwdGVyX3N5bmNfY21kKGRldiwgSU9QX1JFU0VUX0FMV0FZUywKIAkJICAw
LCAwLCAwLCAwLCAwLCAwLCAmdmFyLCBOVUxMLCBOVUxMLCBOVUxMLCBOVUxMKTsKLQlpZiAoYmxl
ZCkKKwkJaWYgKCFibGVkICYmICh2YXIgIT0gMHgwMDAwMDAwMSkpCisJCQlibGVkID0gLUVJTlZB
TDsKKwl9CisJaWYgKGJsZWQgJiYgKGJsZWQgIT0gLUVUSU1FRE9VVCkpCiAJCWJsZWQgPSBhYWNf
YWRhcHRlcl9zeW5jX2NtZChkZXYsIElPUF9SRVNFVCwKIAkJICAwLCAwLCAwLCAwLCAwLCAwLCAm
dmFyLCBOVUxMLCBOVUxMLCBOVUxMLCBOVUxMKTsKIAotCWlmIChibGVkKQorCWlmIChibGVkICYm
IChibGVkICE9IC1FVElNRURPVVQpKQogCQlyZXR1cm4gLUVJTlZBTDsKLQlpZiAodmFyID09IDB4
MzgwMzAwMEYpIHsgLyogVVNFX09USEVSX01FVEhPRCAqLworCWlmIChibGVkIHx8ICh2YXIgPT0g
MHgzODAzMDAwRikpIHsgLyogVVNFX09USEVSX01FVEhPRCAqLwogCQlyeF93cml0ZWwoZGV2LCBN
VW5pdC5yZXNlcnZlZDIsIDMpOwogCQltc2xlZXAoNTAwMCk7IC8qIERlbGF5IDUgc2Vjb25kcyAq
LwogCQl2YXIgPSAweDAwMDAwMDAxOwpAQCAtNTI2LDYgKzUyOSw3IEBACiB7CiAJdW5zaWduZWQg
bG9uZyBzdGFydDsKIAl1bnNpZ25lZCBsb25nIHN0YXR1czsKKwlpbnQgcmVzdGFydCA9IDA7CiAJ
aW50IGluc3RhbmNlID0gZGV2LT5pZDsKIAljb25zdCBjaGFyICogbmFtZSA9IGRldi0+bmFtZTsK
IApAQCAtNTM0LDE1ICs1MzgsMjEgQEAKIAkJZ290byBlcnJvcl9pb3VubWFwOwogCX0KIAorCS8q
IEZhaWx1cmUgdG8gcmVzZXQgaGVyZSBpcyBhbiBvcHRpb24gLi4uICovCisJZGV2LT5hX29wcy5h
ZGFwdGVyX3N5bmNfY21kID0gcnhfc3luY19jbWQ7CisJZGV2LT5hX29wcy5hZGFwdGVyX2VuYWJs
ZV9pbnQgPSBhYWNfcnhfZGlzYWJsZV9pbnRlcnJ1cHQ7CisJZGV2LT5PSU1SID0gc3RhdHVzID0g
cnhfcmVhZGIgKGRldiwgTVVuaXQuT0lNUik7CisJaWYgKCgoKHN0YXR1cyAmIDB4ZmYpICE9IDB4
ZmYpIHx8IHJlc2V0X2RldmljZXMpICYmCisJICAhYWFjX3J4X3Jlc3RhcnRfYWRhcHRlcihkZXYs
IDApKQorCQkrK3Jlc3RhcnQ7CiAJLyoKIAkgKglDaGVjayB0byBzZWUgaWYgdGhlIGJvYXJkIHBh
bmljJ2Qgd2hpbGUgYm9vdGluZy4KIAkgKi8KIAlzdGF0dXMgPSByeF9yZWFkbChkZXYsIE1Vbml0
Lk9NUnhbMF0pOwogCWlmIChzdGF0dXMgJiBLRVJORUxfUEFOSUMpIHsKLQkJaWYgKChzdGF0dXMg
PSBhYWNfcnhfY2hlY2tfaGVhbHRoKGRldikpIDw9IDApCi0JCQlnb3RvIGVycm9yX2lvdW5tYXA7
Ci0JCWlmIChhYWNfcnhfcmVzdGFydF9hZGFwdGVyKGRldiwgc3RhdHVzKSkKKwkJaWYgKGFhY19y
eF9yZXN0YXJ0X2FkYXB0ZXIoZGV2LCBhYWNfcnhfY2hlY2tfaGVhbHRoKGRldikpKQogCQkJZ290
byBlcnJvcl9pb3VubWFwOworCQkrK3Jlc3RhcnQ7CiAJfQogCS8qCiAJICoJQ2hlY2sgdG8gc2Vl
IGlmIHRoZSBib2FyZCBmYWlsZWQgYW55IHNlbGYgdGVzdHMuCkBAIC01NjUsMTEgKzU3NSwyMyBA
QAogCSAqLwogCXdoaWxlICghKChzdGF0dXMgPSByeF9yZWFkbChkZXYsIE1Vbml0Lk9NUnhbMF0p
KSAmIEtFUk5FTF9VUF9BTkRfUlVOTklORykpCiAJewotCQlpZih0aW1lX2FmdGVyKGppZmZpZXMs
IHN0YXJ0K3N0YXJ0dXBfdGltZW91dCpIWikpIHsKKwkJaWYgKChyZXN0YXJ0ICYmCisJCSAgKHN0
YXR1cyAmIChLRVJORUxfUEFOSUN8U0VMRl9URVNUX0ZBSUxFRHxNT05JVE9SX1BBTklDKSkpIHx8
CisJCSAgdGltZV9hZnRlcihqaWZmaWVzLCBzdGFydCtIWipzdGFydHVwX3RpbWVvdXQpKSB7CiAJ
CQlwcmludGsoS0VSTl9FUlIgIiVzJWQ6IGFkYXB0ZXIga2VybmVsIGZhaWxlZCB0byBzdGFydCwg
aW5pdCBzdGF0dXMgPSAlbHguXG4iLCAKIAkJCQkJZGV2LT5uYW1lLCBpbnN0YW5jZSwgc3RhdHVz
KTsKIAkJCWdvdG8gZXJyb3JfaW91bm1hcDsKIAkJfQorCQlpZiAoIXJlc3RhcnQgJiYKKwkJICAo
KHN0YXR1cyAmIChLRVJORUxfUEFOSUN8U0VMRl9URVNUX0ZBSUxFRHxNT05JVE9SX1BBTklDKSkg
fHwKKwkJICB0aW1lX2FmdGVyKGppZmZpZXMsIHN0YXJ0ICsgSFogKgorCQkgICgoc3RhcnR1cF90
aW1lb3V0ID4gNjApCisJCSAgICA/IChzdGFydHVwX3RpbWVvdXQgLSA2MCkKKwkJICAgIDogKHN0
YXJ0dXBfdGltZW91dCAvIDIpKSkpKSB7CisJCQlpZiAobGlrZWx5KCFhYWNfcnhfcmVzdGFydF9h
ZGFwdGVyKGRldiwgYWFjX3J4X2NoZWNrX2hlYWx0aChkZXYpKSkpCisJCQkJc3RhcnQgPSBqaWZm
aWVzOworCQkJKytyZXN0YXJ0OworCQl9CiAJCW1zbGVlcCgxKTsKIAl9CiAJLyoK

------_=_NextPart_001_01C785A7.823BC347--
