From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: RE: [PATCH] drivers/scsi/sg.c: fix problems when sg_remove is called before sg_release
Date: Mon, 11 Jul 2005 09:59:15 -0400
Message-ID: <92952AEF1F064042B6EF2522E0EEF437348368@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C58620.B96431A4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.stratus.com ([134.111.1.16]:24965 "EHLO
	mailhub2.stratus.com") by vger.kernel.org with ESMTP
	id S261697AbVGKN7R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Jul 2005 09:59:17 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01C58620.B96431A4
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Just following up on this patch... I haven't heard anything negative,
but also haven't noticed it in the latest kernel. Attached is a version
of my patch that applies against kernel 2.6.13rc2.

Nate Dailey


> -----Original Message-----
> From: Douglas Gilbert [mailto:dougg@torque.net]=20
> Sent: Tuesday, April 12, 2005 7:04 AM
> To: Dailey, Nate
> Cc: 'linux-scsi@vger.kernel.org'
> Subject: Re: [PATCH] drivers/scsi/sg.c: fix problems when=20
> sg_remove is called before sg_release
>=20
>=20
> Dailey, Nate wrote:
> > This is my first attempt at submitting a patch, so I hope=20
> I'm not making any
> > mistakes...
> >=20
> > This patch fixes two problems I came across in sg, both of=20
> which occur when
> > sg_remove is called on a disk which hasn't yet been sg_release'd:
> >=20
> > 1. I got the following Oops in sg_remove:
> >=20
> > --
> > Unable to handle kernel paging request at virtual address e0a58020
> >  printing eip:
> > e0a7ceba
> > *pde =3D 1c245c8b
> > Oops: 0000 [#1]
> > SMP
> > CPU:    3
> > EIP:    0060:[<e0a7ceba>]    Tainted: G  U
> > EFLAGS: 00210246   (2.6.5-7.139-bigsmp )
> > EIP is at sg_remove+0xba/0x240 [sg]
> > eax: dfee0500   ebx: 00000000   ecx: dfeefa50   edx: dfee05a8
> > esi: 00000000   edi: c7beb000   ebp: e0a58000   esp: daf4bec0
> > ds: 007b   es: 007b   ss: 0068
> > Process bash (pid: 27436, threadinfo=3Ddaf4a000 task=3Ddbcd3350)
> > Stack: c10c1840 000000d0 00000001 01500002 00000000=20
> 00200246 df844000
> > e0a84d08
> >        df844240 e0857ec0 e0857f24 c0263dff e0857f0c=20
> df844240 df9d3028
> > df9d3000
> >        fffffffa c0263e78 df844000 e08449be df9d3000=20
> df844000 00000000
> > fffffffa
> > Call Trace:
> >  [<c0263dff>] class_device_del+0x5f/0xd0
> >  [<c0263e78>] class_device_unregister+0x8/0x10
> >  [<e08449be>] scsi_remove_device+0x3e/0xc0 [scsi_mod]
> >  [<e0845b59>] proc_scsi_write+0x269/0x2a0 [scsi_mod]
> >  [<c0176136>] vfs_write+0xc6/0x160
> >  [<c011057d>] do_mmap2+0xdd/0x170
> >  [<c01763e1>] sys_write+0x91/0xf0
> >  [<c0109199>] sysenter_past_esp+0x52/0x71
> >=20
> > Code: 8b 45 20 e8 ce 2a 70 df c7 45 20 00 00 00 00 8b 45 1c e8 ef
> > --
> >=20
> > It looks like sg_remove needs to hold the sg_dev_arr_lock a=20
> little longer.
> > After sg_remove dropped the lock, sg_release/sg_remove_sfp=20
> came along and
> > freed the sdp... and then sg_remove tried to do=20
> cdev_del(sdp->cdev). I made
> > a change to get what we need from the sdp while holding the=20
> lock, and it
> > fixed the problem for me.
> >=20
> > 2. Scsi_device references are never released: after=20
> sg_remove sets the
> > detached flag, sg_release won't call scsi_device_put. But=20
> someone needs to
> > release the reference obtained in sg_open. A change also=20
> needs to be made in
> > sg_remove_sfp to call scsi_device_put if freeing sdp--since=20
> sg_release
> > wouldn't be able to do it in that case. I verified (by=20
> sticking a printk in
> > scsi_device_dev_release) that the scsi_device wasn't freed=20
> in this case,
> > without my change in place.
> >=20
> >=20
> > To provoke these, I used a few 'dd if=3D/dev/sg2=20
> of=3D/dev/null' commands to
> > hold the device open. I then did 'echo "scsi=20
> remove-single-device 1 0 0 0" >
> > /proc/scsi/scsi' to trigger the sg_remove.
> >=20
> > This patch is against 2.6.12-rc2, though I actually=20
> found/fixed the problems
> > in 2.6.5-7.139 (SLES9 SP1).
> >=20
> > Do these look okay?
>=20
> Nate,
>=20
> Thanks for the analysis and the patch.
>=20
> I'm starting to look at this patch and will do more
> testing shortly. The changes look sound. The patch
> had some line wrap problems so attached is my version
> of it (against lk 2.6.12-rc2). It also applies over
> my patch sent to this list on 28/3/2005 with a little
> harmless "fuzz".
>=20
> Doug Gilbert
>=20

------_=_NextPart_001_01C58620.B96431A4
Content-Type: application/octet-stream;
	name="sg2613rc2nd.diff"
Content-Transfer-Encoding: base64
Content-Description: sg2613rc2nd.diff
Content-Disposition: attachment;
	filename="sg2613rc2nd.diff"

LS0tIHNnLmMub3JpZwkyMDA1LTA3LTA4IDExOjQ5OjU1LjAwMDAwMDAwMCAtMDQwMAorKysgc2cu
YwkyMDA1LTA3LTA4IDE0OjUzOjUwLjAwMDAwMDAwMCAtMDQwMApAQCAtMzE5LDkgKzMxOSw3IEBA
IHNnX3JlbGVhc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGYKIAlTQ1NJX0xPR19USU1F
T1VUKDMsIHByaW50aygic2dfcmVsZWFzZTogJXNcbiIsIHNkcC0+ZGlzay0+ZGlza19uYW1lKSk7
CiAJc2dfZmFzeW5jKC0xLCBmaWxwLCAwKTsJLyogcmVtb3ZlIGZpbHAgZnJvbSBhc3luYyBub3Rp
ZmljYXRpb24gbGlzdCAqLwogCWlmICgwID09IHNnX3JlbW92ZV9zZnAoc2RwLCBzZnApKSB7CS8q
IFJldHVybnMgMSB3aGVuIHNkcCBnb25lICovCi0JCWlmICghc2RwLT5kZXRhY2hlZCkgewotCQkJ
c2NzaV9kZXZpY2VfcHV0KHNkcC0+ZGV2aWNlKTsKLQkJfQorCQlzY3NpX2RldmljZV9wdXQoc2Rw
LT5kZXZpY2UpOwogCQlzZHAtPmV4Y2x1ZGUgPSAwOwogCQl3YWtlX3VwX2ludGVycnVwdGlibGUo
JnNkcC0+b19leGNsX3dhaXQpOwogCX0KQEAgLTE2MzIsMTkgKzE2MzAsMzAgQEAgc2dfcmVtb3Zl
KHN0cnVjdCBjbGFzc19kZXZpY2UgKmNsX2RldikKIAkJc2dfbnJfZGV2LS07CiAJCWJyZWFrOwog
CX0KLQl3cml0ZV91bmxvY2tfaXJxcmVzdG9yZSgmc2dfZGV2X2Fycl9sb2NrLCBpZmxhZ3MpOwog
CiAJaWYgKHNkcCkgewotCQlzeXNmc19yZW1vdmVfbGluaygmc2NzaWRwLT5zZGV2X2dlbmRldi5r
b2JqLCAiZ2VuZXJpYyIpOwotCQljbGFzc19kZXZpY2VfZGVzdHJveShzZ19zeXNmc19jbGFzcywg
TUtERVYoU0NTSV9HRU5FUklDX01BSk9SLCBrKSk7Ci0JCWNkZXZfZGVsKHNkcC0+Y2Rldik7CisJ
CXN0cnVjdCBjZGV2ICp0bXBfY2RldjsKKwkJc3RydWN0IGdlbmRpc2sgKnRtcF9kaXNrOworCQlp
bnQgZnJlZV9zZHAgPSAwOworCisJCXRtcF9jZGV2ID0gc2RwLT5jZGV2OwogCQlzZHAtPmNkZXYg
PSBOVUxMOwotCQlkZXZmc19yZW1vdmUoIiVzL2dlbmVyaWMiLCBzY3NpZHAtPmRldmZzX25hbWUp
OwotCQlwdXRfZGlzayhzZHAtPmRpc2spOworCQl0bXBfZGlzayA9IHNkcC0+ZGlzazsKIAkJc2Rw
LT5kaXNrID0gTlVMTDsKIAkJaWYgKE5VTEwgPT0gc2RwLT5oZWFkZnApCisJCQlmcmVlX3NkcCA9
IDE7CisJCXdyaXRlX3VubG9ja19pcnFyZXN0b3JlKCZzZ19kZXZfYXJyX2xvY2ssIGlmbGFncyk7
CisKKwkJc3lzZnNfcmVtb3ZlX2xpbmsoJnNjc2lkcC0+c2Rldl9nZW5kZXYua29iaiwgImdlbmVy
aWMiKTsKKwkJY2xhc3NfZGV2aWNlX2Rlc3Ryb3koc2dfc3lzZnNfY2xhc3MsCisJCQkJICAgICBN
S0RFVihTQ1NJX0dFTkVSSUNfTUFKT1IsIGspKTsKKwkJY2Rldl9kZWwodG1wX2NkZXYpOworCQlk
ZXZmc19yZW1vdmUoIiVzL2dlbmVyaWMiLCBzY3NpZHAtPmRldmZzX25hbWUpOworCQlwdXRfZGlz
ayh0bXBfZGlzayk7CisJCWlmIChmcmVlX3NkcCkKIAkJCWtmcmVlKChjaGFyICopIHNkcCk7Ci0J
fQorCX0gZWxzZQorCQl3cml0ZV91bmxvY2tfaXJxcmVzdG9yZSgmc2dfZGV2X2Fycl9sb2NrLCBp
ZmxhZ3MpOwogCiAJaWYgKGRlbGF5KQogCQltc2xlZXAoMTApOwkvKiBkaXJ0eSBkZXRhY2ggc28g
ZGVsYXkgZGV2aWNlIGRlc3RydWN0aW9uICovCkBAIC0yNjEwLDYgKzI2MTksNyBAQCBzZ19yZW1v
dmVfc2ZwKFNnX2RldmljZSAqIHNkcCwgU2dfZmQgKiBzCiAJCQl9CiAJCQlpZiAoayA8IG1heGQp
CiAJCQkJc2dfZGV2X2FycltrXSA9IE5VTEw7CisJCQlzY3NpX2RldmljZV9wdXQoc2RwLT5kZXZp
Y2UpOwogCQkJa2ZyZWUoKGNoYXIgKikgc2RwKTsKIAkJCXJlcyA9IDE7CiAJCX0K

------_=_NextPart_001_01C58620.B96431A4--
