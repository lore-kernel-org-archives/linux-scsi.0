From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: fix panic on short Inquiry
Date: Wed, 16 May 2007 10:06:39 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF0197D9C4@otce2k301.adaptec.com>
References: <1179321266.3787.14.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C797C3.6E788CFC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:51490 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756153AbXEPOGq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2007 10:06:46 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1179321266.3787.14.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C797C3.6E788CFC
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Reject, transfer_len is an unsigned ... modified patch enclosed.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]=20
> Sent: Wednesday, May 16, 2007 9:14 AM
> To: Salyzyn, Mark
> Cc: linux-scsi
> Subject: [PATCH] aacraid: fix panic on short Inquiry
>=20
>=20
> This was actually seen at a customer site running RHEL5:
>=20
> Unable to handle kernel paging request at ffff8101c0000000 RIP:=20
>  [<ffffffff880b22a1>] :aacraid:aac_internal_transfer+0xd6/0xe3
> PGD 8063 PUD 0=20
> Oops: 0000 [1] SMP=20
> last sysfs file: /block/sdb/removable
> CPU 2=20
> Modules linked in: autofs4(U) hidp(U) nfs(U) lockd(U)=20
> fscache(U) nfs_acl(U) rfcomm(U) l2cap(U) bluetooth(U)=20
> sunrpc(U) ipv6(U) cpufreq_ondemand(U) dm_mirror(U) dm_mod(U)=20
> video(U) sbs(U) i2c_ec(U) button(U) battery(U) asus_acpi(U)=20
> acpi_memhotplug(U) ac(U) parport_pc(U) lp(U) parport(U)=20
> joydev(U) ide_cd(U) i2c_i801(U) i2c_core(U) shpchp(U)=20
> cdrom(U) bnx2(U) sg(U) pcspkr(U) ata_piix(U) libata(U)=20
> aacraid(U) sd_mod(U) scsi_mod(U) ext3(U) jbd(U) ehci_hcd(U)=20
> ohci_hcd(U) uhci_hcd(U)
> Pid: 2352, comm: syslogd Not tainted 2.6.18-prep #1
> RIP: 0010:[<ffffffff880b22a1>]  [<ffffffff880b22a1>]=20
> :aacraid:aac_internal_transfer+0xd6/0xe3
> RSP: 0000:ffff8101bfd1fe68  EFLAGS: 00010083
> RAX: 0000000000000063 RBX: 0000000000000008 RCX: 00000000ffd1fea0
> RDX: ffffffff802da628 RSI: ffff8101c0000000 RDI: ffff8101b2a08168
> RBP: ffff8101b2728010 R08: ffffffff802da628 R09: 0000000000000046
> R10: 0000000000000000 R11: 0000000000000080 R12: 0000000000000010
> R13: ffff8101bfd1fea8 R14: ffff8101bc74df58 R15: ffff8101bc74df58
> FS:  00002aaaab0146f0(0000) GS:ffff8101bfcd2e40(0000)=20
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: ffff8101c0000000 CR3: 00000001bdecd000 CR4: 00000000000006e0
> Process syslogd (pid: 2352, threadinfo ffff8101bc74c000, task=20
> ffff8101bd979040)
> Stack:  0000000000000012 0000000000000036 0000000000000000=20
> ffff8101bee9a800
>  ffff8101be9d3a00 ffff8101be9d3a00 ffff8101be8014f8 ffffffff880b26cc
>  40212227607e3141 2029282a26252423 0000000000000003 ffff810037e3a000
> Call Trace:
>  <IRQ>  [<ffffffff880b26cc>]=20
> :aacraid:get_container_name_callback+0x8b/0xb5
>  [<ffffffff880b6f67>] :aacraid:aac_intr_normal+0x1b3/0x1f9
>  [<ffffffff880b8007>] :aacraid:aac_rkt_intr+0x37/0x115
>  [<ffffffff80099749>] __rcu_process_callbacks+0xf8/0x1a8
>  [<ffffffff80010705>] handle_IRQ_event+0x29/0x58
>  [<ffffffff800b2fe0>] __do_IRQ+0xa4/0x105
>  [<ffffffff80011c19>] __do_softirq+0x5e/0xd5
>  [<ffffffff8006a193>] do_IRQ+0xe7/0xf5
>  [<ffffffff8005b649>] ret_from_intr+0x0/0xa
>=20
> On digging into it, it turned out that the customer was probing an
> aacraid device with an INQUIRY of 8 bytes.  The way aacraid works, it
> was blindly trying to use aac_internal_transfer to copy the container
> name to byte 16 of the inquiry data, resulting in a negative transfer
> length.  It then copies over the whole of kernel memory=20
> before dropping
> off the end.
>=20
> The fix is simple.  However, I'm beginning to think that each of these
> separate copy into scatterlist routines we have sprayed throughout the
> drivers are asking for bugs like this.  I can apply the=20
> simple fix now,
> but long term I think we want a library routine to do this=20
> correctly for
> everyone.
>=20
> James
>=20
> diff --git a/drivers/scsi/aacraid/aachba.c=20
> b/drivers/scsi/aacraid/aachba.c
> index 1e82c69..089f5b9 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -351,7 +351,7 @@ static void aac_internal_transfer(struct=20
> scsi_cmnd *scsicmd, void *data, unsigne
>  		transfer_len =3D min(scsicmd->request_bufflen,=20
> len + offset);
>  	}
>  	transfer_len -=3D offset;
> -	if (buf && transfer_len)
> +	if (buf && transfer_len > 0)
>  		memcpy(buf + offset, data, transfer_len);
> =20
>  	if (scsicmd->use_sg)=20
>=20
>=20
>=20

------_=_NextPart_001_01C797C3.6E788CFC
Content-Type: application/octet-stream;
	name="aacraid_transfer_len.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_transfer_len.patch
Content-Disposition: attachment;
	filename="aacraid_transfer_len.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDUtMTYgMTA6MDE6MzkuOTc1NTcyOTQ4IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDUtMTYgMTA6MDU6MzMuMjg0OTAxOTIzIC0wNDAwCkBAIC0zNDAsNyAr
MzQwLDcgQEAKIHN0YXRpYyB2b2lkIGFhY19pbnRlcm5hbF90cmFuc2ZlcihzdHJ1Y3Qgc2NzaV9j
bW5kICpzY3NpY21kLCB2b2lkICpkYXRhLCB1bnNpZ25lZCBpbnQgb2Zmc2V0LCB1bnNpZ25lZCBp
bnQgbGVuKQogewogCXZvaWQgKmJ1ZjsKLQl1bnNpZ25lZCBpbnQgdHJhbnNmZXJfbGVuOworCWlu
dCB0cmFuc2Zlcl9sZW47CiAJc3RydWN0IHNjYXR0ZXJsaXN0ICpzZyA9IHNjc2ljbWQtPnJlcXVl
c3RfYnVmZmVyOwogCiAJaWYgKHNjc2ljbWQtPnVzZV9zZykgewpAQCAtMzUxLDcgKzM1MSw3IEBA
CiAJCXRyYW5zZmVyX2xlbiA9IG1pbihzY3NpY21kLT5yZXF1ZXN0X2J1ZmZsZW4sIGxlbiArIG9m
ZnNldCk7CiAJfQogCXRyYW5zZmVyX2xlbiAtPSBvZmZzZXQ7Ci0JaWYgKGJ1ZiAmJiB0cmFuc2Zl
cl9sZW4pCisJaWYgKGJ1ZiAmJiB0cmFuc2Zlcl9sZW4gPiAwKQogCQltZW1jcHkoYnVmICsgb2Zm
c2V0LCBkYXRhLCB0cmFuc2Zlcl9sZW4pOwogCiAJaWYgKHNjc2ljbWQtPnVzZV9zZykgCg==

------_=_NextPart_001_01C797C3.6E788CFC--
