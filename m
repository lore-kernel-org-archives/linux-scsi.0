From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: RE: requesting advice: oops when doing sg_dd IO and device is removed
Date: Thu, 20 Oct 2005 12:48:21 -0400
Message-ID: <92952AEF1F064042B6EF2522E0EEF43702433512@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C5D596.1454D8C9"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub5.stratus.com ([134.111.1.18]:49567 "EHLO
	mailhub5.stratus.com") by vger.kernel.org with ESMTP
	id S932478AbVJTQsY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 12:48:24 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5D596.1454D8C9
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Doug, I'm attaching a new patch (again, against 2.6.9)... the primary
difference from my previous patch is that this one now schedules a work
item from sg_cmd_done. This work item drops the reference on the device,
so this gets rid of the problems of calling scsi_device_put from
sg_cmd_done or of sleeping in sg_release. Does this look okay?

Nate



> -----Original Message-----
> From: Douglas Gilbert [mailto:dougg@torque.net]=20
> Sent: Tuesday, October 18, 2005 12:55 AM
> To: Dailey, Nate
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: requesting advice: oops when doing sg_dd IO and=20
> device is removed
>=20
>=20
> Nate,
> I always suspected that if one really tried hard enough
> then unexpectedly closing a file descriptor (e.g. via
> control-C on an app) at the same time as there are
> outstanding commands could cause problems. Obviously
> you have succeeded demonstrating that with your experiment.
>=20
> When I fought with this problem in the lk 2.4 series,
> someone skilled at finding flaws in locking logic
> suggested there was no solution (at least the way
> I was doing it) ...
>=20
> Waiting a close() call (i.e. sg_release() ), potentially
> indefinitely, was very unpopular with application clients.
> The sg driver did that in the old days, and I was abused
> from several quarters (one name springs to mind). So I
> tried to design sg_release() so it wouldn't ever hang
> the application client.
>=20
> On reflection, I think to allow sg_release() to go
> through quickly, another kernel thread is needed that
> is passed ownership of unfinished commands. What do
> you think?
>=20
>=20
> Doug Gilbert
>=20
>=20
> Dailey, Nate wrote:
> > Doug (and anyone else who might be interested), I'm looking for some
> > advice as to how best to fix a problem I hit in sg.
> >=20
> > I was doing the following:
> >=20
> > - start up several processes reading from an sg device with sg_dd
> > - every other iteration, kill the processes
> > - remove the device (echo 1 > /sys/bus/scsi/devices/1:0:1:0/delete)
> > - add the device (echo "0 1 0" > /sys/class/scsi_host/host1/scan)
> >=20
> > This was on a 2.6.9 kernel, with a patch:
> >=20
> > =
http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D112749860222533&w=3D2
> >=20
> > That I've submitted to the LSML... patch was intended to=20
> fix a different
> > oops when doing the above test.
> >=20
> > Here's what I saw, after the device was removed:
> >=20
> > Debug: sleeping function called from invalid context at
> > include/linux/rwsem.h:6in_atomic():1[expected: 0], irqs_disabled():0
> >  [<c011fcd1>] __might_sleep+0x7d/0x88
> >  [<c021cb5e>] device_del+0x1e/0x90
> >  [<f8840ccc>] scsi_device_dev_release+0xdf/0x13a [scsi_mod]
> >  [<c021c8e9>] device_release+0x11/0x40
> >  [<c01bf03f>] kobject_cleanup+0x40/0x60
> >  [<c01bf05f>] kobject_release+0x0/0x8
> >  [<c01bf305>] kref_put+0x42/0x45
> >  [<f883e61b>] scsi_next_command+0xc/0x14 [scsi_mod]
> >  [<f883a0a8>] scsi_release_request+0x8/0x10 [scsi_mod]
> >  [<f883ab15>] scsi_finish_command+0xad/0xb1 [scsi_mod]
> >  [<f883aa3a>] scsi_softirq+0xb6/0xbe [scsi_mod]
> >  [<c0126424>] __do_softirq+0x4c/0xb1
> >  [<c010812f>] do_softirq+0x4f/0x56
> >  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >  [<c0107a44>] do_IRQ+0x1a2/0x1ae
> >  [<c02d1a8c>] common_interrupt+0x18/0x20
> >  [<c0104018>] default_idle+0x0/0x2c
> >  [<c0104041>] default_idle+0x29/0x2c
> >  [<c010409d>] cpu_idle+0x26/0x3b
> >  [<c0390786>] start_kernel+0x199/0x19d
> >=20
> > (It looks like a command comes back, we drop the last=20
> reference on the
> > device, the device is freed... because we're in softirq,=20
> and device_del
> > may eventually sleep (in this kernel version, anyway), we=20
> get this debug
> > message. I don't think this should normally happen when a=20
> command comes
> > back, for reasons I'll discuss below)
> >=20
> > Continuing on...
> >=20
> > Badness in kref_get at lib/kref.c:32
> >  [<c01bf2bb>] kref_get+0x24/0x2c
> >  [<c01beffb>] kobject_get+0xf/0x13
> >  [<c021cb32>] get_device+0xe/0x14
> >  [<f883ef34>] scsi_request_fn+0x19/0x319 [scsi_mod]
> >  [<c022213e>] blk_run_queue+0x20/0x2f
> >  [<f883a0a8>] scsi_release_request+0x8/0x10 [scsi_mod]
> >  [<f883ab15>] scsi_finish_command+0xad/0xb1 [scsi_mod]
> >  [<f883aa3a>] scsi_softirq+0xb6/0xbe [scsi_mod]
> >  [<c0126424>] __do_softirq+0x4c/0xb1
> >  [<c010812f>] do_softirq+0x4f/0x56
> >  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >  [<c0107a44>] do_IRQ+0x1a2/0x1ae
> >  [<c02d1a8c>] common_interrupt+0x18/0x20
> >  [<c0104018>] default_idle+0x0/0x2c
> >  [<c0104041>] default_idle+0x29/0x2c
> >  [<c010409d>] cpu_idle+0x26/0x3b
> >  [<c0390786>] start_kernel+0x199/0x19d
> >=20
> > (So, there were more commands on the device's queue...=20
> presumably for
> > sg, since I wasn't doing any other IO to this disk. We're=20
> trying to get
> > a reference on the device, but the ref count has already=20
> gone to 0 so
> > this "Badness" message results.)
> >=20
> > Continuing on...
> >=20
> > Unable to handle kernel NULL pointer dereference at virtual address
> > 00000008
> >  printing eip:
> > c0229678
> > *pde =3D 00004001
> > Oops: 0000 [#1]
> > SMP
> > Modules linked in: sg(U) parport_pc lp parport autofs4 nfs=20
> lockd sunrpc
> > md5
> >  ip)
> > CPU:  0
> > EIP:    0060:[<c0229678>]    Tainted: PF     VLI
> > EFLAGS: 00010046   (2.6.9-20.ELsmp)
> > EIP is at cfq_next_request+0x7/0x35
> > eax: f7b6f5e0   ebx: 00000000   ecx: c03249bc   edx: f243a594
> > esi: f7b6f5e0   edi: f7f5b000   ebp: f7b6f5e0   esp: c03c7f80
> > ds: 007b   es: 007b   ss: 0068
> > Process swapper (pid: 0, threadinfo=3Dc03c7000 task=3Dc031ea80)
> > Stack: f7b6f5e0 f7b6f5e0 c02209dc f7b6f5e0 f243a400=20
> f7f5b000 f883ef51
> > f7b6f5e0
> >        00000246 f243a400 00000000 c022213e f7d62800=20
> f3872800 f883a0a8
> > f7f5b000
> >        f883ab15 00002002 f3872800 c03c7fd4 f883aa3a=20
> c03c7fd4 c03c7fd4
> > 00000003
> > Call Trace:
> >  [<c02209dc>] elv_next_request+0xbe/0xce
> >  [<f883ef51>] scsi_request_fn+0x36/0x319 [scsi_mod]
> >  [<c022213e>] blk_run_queue+0x20/0x2f
> >  [<f883a0a8>] scsi_release_request+0x8/0x10 [scsi_mod]
> >  [<f883ab15>] scsi_finish_command+0xad/0xb1 [scsi_mod]
> >  [<f883aa3a>] scsi_softirq+0xb6/0xbe [scsi_mod]
> >  [<c0126424>] __do_softirq+0x4c/0xb1
> >  [<c010812f>] do_softirq+0x4f/0x56
> >  =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >  [<c0107a44>] do_IRQ+0x1a2/0x1ae
> >  [<c02d1a8c>] common_interrupt+0x18/0x20
> >  [<c0104018>] default_idle+0x0/0x2c
> >  [<c0104041>] default_idle+0x29/0x2c
> >  [<c010409d>] cpu_idle+0x26/0x3b
> >  [<c0390786>] start_kernel+0x199/0x19d
> > Code: 01 00 00 00 89 e8 eb b6 8b 04 24 3b 43 24 0f 92 c0 31=20
> d2 85 ff 0f
> > 95 c2
> >=20
> > (It was inevitable that something bad would happen when=20
> trying to run
> > the queue on a device which had been freed)
> >=20
> >=20
> > My theory here is that sg should be holding a reference on the SCSI
> > device until all IO comes back. With or without the patch I=20
> mentioned
> > above, this is not the case. Although sg_release does take=20
> out an extra
> > reference if there's any IO still outstanding, if sg_remove=20
> is called,
> > this reference is dropped. So after sg_remove, there could=20
> still be IO
> > to the device outstanding, but no reference on the device (from sg).
> > This means the device could get freed even though there's=20
> still some sg
> > IO on the queue.
> >=20
> > Does this analysis sound reasonable? I'm a bit puzzled by=20
> the fact that
> > sd (for example) doesn't appear to have this problem (maybe=20
> sd_release
> > just never gets called until all IO comes back?).
> >=20
> >=20
> > So, how to fix this?
> >=20
> > The first thing I tried was adding a kref to the Sg_device struct,
> > patterned after the reference counting in sd, sr, st. In=20
> sg_release, I
> > would drop a reference only if there was no IO outstanding. If there
> > _was_ IO outstanding, I would drop the reference in=20
> sg_cmd_done when the
> > last IO came back. In theory, this would ensure that sg=20
> kept a reference
> > on the device until all IO came back.
> >=20
> > First problem: I was protecting the kref with a mutex, as=20
> sd, sr, etc.
> > do. Trying to down the mutex from sg_cmd_done didn't work=20
> (as this is
> > done from softirq). Okay, so I took out the mutex, just to see how
> > things would work. Still there was a problem... doing the final
> > scsi_device_put in sg_cmd_done won't work, because
> > scsi_device_dev_release calls device_del, which may sleep (in this
> > kernel version, anyway... I think this has changed in later=20
> kernels). So
> > it seems trying to drop a reference when the last command=20
> comes back is
> > out of the question.
> >=20
> > The next thing I tried was simply sleeping in sg_release until all
> > outstanding IO comes back (changing sg_remove_sfp to return=20
> a count of
> > outstanding IOs), and only then dropping the device reference (patch
> > below). This seems to be working fine. But I'm wondering if this is
> > really a good solution? I'm not sure I can think of=20
> anything else... any
> > ideas?
> >=20
> > Thanks!
> >=20
> > Nate Dailey
> > Stratus Technologies

------_=_NextPart_001_01C5D596.1454D8C9
Content-Type: application/octet-stream;
	name="sg.c.ND102005.patch"
Content-Transfer-Encoding: base64
Content-Description: sg.c.ND102005.patch
Content-Disposition: attachment;
	filename="sg.c.ND102005.patch"

LS0tIHNnLmMub3JpZwkyMDA1LTEwLTEzIDE2OjUwOjAwLjAwMDAwMDAwMCAtMDQwMAorKysgc2cu
YwkyMDA1LTEwLTIwIDEyOjA4OjEzLjI4MjY2OTk2NiAtMDQwMApAQCAtNDksNiArNDksNyBAQCBz
dGF0aWMgaW50IHNnX3ZlcnNpb25fbnVtID0gMzA1MzE7CS8qIDIgCiAjaW5jbHVkZSA8bGludXgv
c2VxX2ZpbGUuaD4KICNpbmNsdWRlIDxsaW51eC9ibGtkZXYuaD4KICNpbmNsdWRlIDxsaW51eC9k
ZWxheS5oPgorI2luY2x1ZGUgPGxpbnV4L2tyZWYuaD4KIAogI2luY2x1ZGUgInNjc2kuaCIKICNp
bmNsdWRlIDxzY3NpL3Njc2lfaG9zdC5oPgpAQCAtMTczLDYgKzE3NCw3IEBAIHR5cGVkZWYgc3Ry
dWN0IHNnX2RldmljZSB7IC8qIGhvbGRzIHRoZSAKIAljaGFyIHNnZGVidWc7CQkvKiAwLT5vZmYs
IDEtPnNlbnNlLCA5LT5kdW1wIGRldiwgMTAtPiBhbGwgZGV2cyAqLwogCXN0cnVjdCBnZW5kaXNr
ICpkaXNrOwogCXN0cnVjdCBjZGV2ICogY2RldjsJLyogY2hhcl9kZXYgW3N5c2ZzOiAvc3lzL2Nk
ZXYvbWFqb3Ivc2c8bj5dICovCisJc3RydWN0IGtyZWYga3JlZjsKIH0gU2dfZGV2aWNlOwogCiBz
dGF0aWMgaW50IHNnX2Zhc3luYyhpbnQgZmQsIHN0cnVjdCBmaWxlICpmaWxwLCBpbnQgbW9kZSk7
CkBAIC0yMTgsMTEgKzIyMCw4OSBAQCBzdGF0aWMgU2dfZGV2aWNlICoqc2dfZGV2X2FyciA9IE5V
TEw7CiBzdGF0aWMgaW50IHNnX2Rldl9tYXg7CiBzdGF0aWMgaW50IHNnX25yX2RldjsKIAorLyog
VGhpcyBzZW1hcGhvcmUgaXMgdXNlZCB0byBtZWRpYXRlIHRoZSAwLT4xIHJlZmVyZW5jZSBnZXQg
aW4gdGhlCisgKiBmYWNlIG9mIG9iamVjdCBkZXN0cnVjdGlvbiAoaS5lLiB3ZSBjYW4ndCBhbGxv
dyBhIGdldCBvbiBhbgorICogb2JqZWN0IGFmdGVyIGxhc3QgcHV0KSAqLworc3RhdGljIERFQ0xB
UkVfTVVURVgoc2dfcmVmX3NlbSk7CisKK3N0YXRpYyB2b2lkIHNjc2lfZ2VuZXJpY19yZWxlYXNl
KHN0cnVjdCBrcmVmICprcmVmKTsKKyNkZWZpbmUgdG9fc2NzaV9nZW5lcmljKG9iaikgY29udGFp
bmVyX29mKG9iaixTZ19kZXZpY2Usa3JlZikKKwogI2RlZmluZSBTWl9TR19IRUFERVIgc2l6ZW9m
KHN0cnVjdCBzZ19oZWFkZXIpCiAjZGVmaW5lIFNaX1NHX0lPX0hEUiBzaXplb2Yoc2dfaW9faGRy
X3QpCiAjZGVmaW5lIFNaX1NHX0lPVkVDIHNpemVvZihzZ19pb3ZlY190KQogI2RlZmluZSBTWl9T
R19SRVFfSU5GTyBzaXplb2Yoc2dfcmVxX2luZm9fdCkKIAorc3RhdGljIFNnX2RldmljZSAqc2Nz
aV9nZW5lcmljX2dldChpbnQgZGV2KQoreworCVNnX2RldmljZSAqc2RwID0gTlVMTDsKKworCWRv
d24oJnNnX3JlZl9zZW0pOworCisJc2RwID0gc2dfZ2V0X2RldiAoZGV2KTsKKwlpZiAoIXNkcCkg
Z290byBvdXQ7CisKKwlpZiAoc2RwLT5kZXRhY2hlZCkgeworCQlzZHAgPSBOVUxMOworCQlnb3Rv
IG91dDsKKwl9CisKKwlrcmVmX2dldCgmc2RwLT5rcmVmKTsKKworCWlmICghc2RwLT5kZXZpY2Up
CisJCWdvdG8gb3V0X3B1dDsKKworCWlmIChzY3NpX2RldmljZV9nZXQoc2RwLT5kZXZpY2UpKQor
CQlnb3RvIG91dF9wdXQ7CisKKwlnb3RvIG91dDsKKworb3V0X3B1dDoKKwlrcmVmX3B1dCgmc2Rw
LT5rcmVmLCBzY3NpX2dlbmVyaWNfcmVsZWFzZSk7CisJc2RwID0gTlVMTDsKK291dDoKKwl1cCgm
c2dfcmVmX3NlbSk7CisJcmV0dXJuIHNkcDsKK30KKworc3RhdGljIHZvaWQgc2NzaV9nZW5lcmlj
X3B1dChTZ19kZXZpY2UgKnNkcCkKK3sKKwlzdHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYgPSBzZHAt
PmRldmljZTsKKworCWRvd24oJnNnX3JlZl9zZW0pOworCWtyZWZfcHV0KCZzZHAtPmtyZWYsIHNj
c2lfZ2VuZXJpY19yZWxlYXNlKTsKKwlzY3NpX2RldmljZV9wdXQoc2Rldik7CisJdXAoJnNnX3Jl
Zl9zZW0pOworfQorCitzdHJ1Y3Qgc2NzaV9nZW5lcmljX3B1dF93b3JrX2l0ZW0geworCVNnX2Rl
dmljZSAqc2RwOworICAgICAgICBzdHJ1Y3Qgd29ya19zdHJ1Y3Qgd29yazsKK307CisKK3ZvaWQg
c2NzaV9nZW5lcmljX3B1dF93b3JrX2hhbmRsZXIodm9pZCAqZGF0YSkKK3sKKwlTZ19kZXZpY2Ug
KnNkcCA9ICgoc3RydWN0IHNjc2lfZ2VuZXJpY19wdXRfd29ya19pdGVtKilkYXRhKS0+c2RwOwor
CisgICAgICAgIHNjc2lfZ2VuZXJpY19wdXQoc2RwKTsKKwlrZnJlZShkYXRhKTsKK30KKworc3Rh
dGljIGludCBzY3NpX2dlbmVyaWNfcHV0X3NjaGVkdWxlX3dvcmsoU2dfZGV2aWNlICpzZHApCit7
CisJc3RydWN0IHNjc2lfZ2VuZXJpY19wdXRfd29ya19pdGVtICpkYXRhOworCisJaWYgKChkYXRh
ID0ga21hbGxvYyhzaXplb2YoKmRhdGEpLCBHRlBfQVRPTUlDKSkgPT0gTlVMTCkKKwkJcmV0dXJu
IC1FTk9NRU07CisKKwltZW1zZXQoZGF0YSwgMCwgc2l6ZW9mKCpkYXRhKSk7CisgICAgICAgIElO
SVRfV09SSygmZGF0YS0+d29yaywgc2NzaV9nZW5lcmljX3B1dF93b3JrX2hhbmRsZXIsIGRhdGEp
OworCWRhdGEtPnNkcCA9IHNkcDsKKworICAgICAgICBzY2hlZHVsZV93b3JrKCZkYXRhLT53b3Jr
KTsKKwlyZXR1cm4gMDsKK30KKwogc3RhdGljIGludAogc2dfb3BlbihzdHJ1Y3QgaW5vZGUgKmlu
b2RlLCBzdHJ1Y3QgZmlsZSAqZmlscCkKIHsKQEAgLTIzNSwxNyArMzE1LDggQEAgc2dfb3Blbihz
dHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZQogCiAJbm9uc2Vla2FibGVfb3Blbihpbm9k
ZSwgZmlscCk7CiAJU0NTSV9MT0dfVElNRU9VVCgzLCBwcmludGsoInNnX29wZW46IGRldj0lZCwg
ZmxhZ3M9MHgleFxuIiwgZGV2LCBmbGFncykpOwotCXNkcCA9IHNnX2dldF9kZXYoZGV2KTsKLQlp
ZiAoKCFzZHApIHx8ICghc2RwLT5kZXZpY2UpKQorCWlmICghKHNkcCA9IHNjc2lfZ2VuZXJpY19n
ZXQoZGV2KSkpCiAJCXJldHVybiAtRU5YSU87Ci0JaWYgKHNkcC0+ZGV0YWNoZWQpCi0JCXJldHVy
biAtRU5PREVWOwotCi0JLyogVGhpcyBkcml2ZXIncyBtb2R1bGUgY291bnQgYnVtcGVkIGJ5IGZv
cHNfZ2V0IGluIDxsaW51eC9mcy5oPiAqLwotCS8qIFByZXZlbnQgdGhlIGRldmljZSBkcml2ZXIg
ZnJvbSB2YW5pc2hpbmcgd2hpbGUgd2Ugc2xlZXAgKi8KLQlyZXR2YWwgPSBzY3NpX2RldmljZV9n
ZXQoc2RwLT5kZXZpY2UpOwotCWlmIChyZXR2YWwpCi0JCXJldHVybiByZXR2YWw7CiAKIAlpZiAo
ISgoZmxhZ3MgJiBPX05PTkJMT0NLKSB8fAogCSAgICAgIHNjc2lfYmxvY2tfd2hlbl9wcm9jZXNz
aW5nX2Vycm9ycyhzZHAtPmRldmljZSkpKSB7CkBAIC0zMDIsNyArMzczLDcgQEAgc2dfb3Blbihz
dHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZQogCXJldHVybiAwOwogCiAgICAgICBlcnJv
cl9vdXQ6Ci0Jc2NzaV9kZXZpY2VfcHV0KHNkcC0+ZGV2aWNlKTsKKwlzY3NpX2dlbmVyaWNfcHV0
KHNkcCk7CiAJcmV0dXJuIHJldHZhbDsKIH0KIApAQCAtMzEyLDE4ICszODMsMjEgQEAgc2dfcmVs
ZWFzZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZgogewogCVNnX2RldmljZSAqc2RwOwog
CVNnX2ZkICpzZnA7CisJaW50IGRpcnR5OwogCiAJaWYgKCghKHNmcCA9IChTZ19mZCAqKSBmaWxw
LT5wcml2YXRlX2RhdGEpKSB8fCAoIShzZHAgPSBzZnAtPnBhcmVudGRwKSkpCiAJCXJldHVybiAt
RU5YSU87CiAJU0NTSV9MT0dfVElNRU9VVCgzLCBwcmludGsoInNnX3JlbGVhc2U6ICVzXG4iLCBz
ZHAtPmRpc2stPmRpc2tfbmFtZSkpOwogCXNnX2Zhc3luYygtMSwgZmlscCwgMCk7CS8qIHJlbW92
ZSBmaWxwIGZyb20gYXN5bmMgbm90aWZpY2F0aW9uIGxpc3QgKi8KLQlpZiAoMCA9PSBzZ19yZW1v
dmVfc2ZwKHNkcCwgc2ZwKSkgewkvKiBSZXR1cm5zIDEgd2hlbiBzZHAgZ29uZSAqLwotCQlpZiAo
IXNkcC0+ZGV0YWNoZWQpIHsKLQkJCXNjc2lfZGV2aWNlX3B1dChzZHAtPmRldmljZSk7Ci0JCX0K
LQkJc2RwLT5leGNsdWRlID0gMDsKLQkJd2FrZV91cF9pbnRlcnJ1cHRpYmxlKCZzZHAtPm9fZXhj
bF93YWl0KTsKLQl9CisJZGlydHkgPSBzZ19yZW1vdmVfc2ZwKHNkcCwgc2ZwKTsKKwlzZHAtPmV4
Y2x1ZGUgPSAwOworCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmc2RwLT5vX2V4Y2xfd2FpdCk7CisK
KwkvKiBPbmx5IGRyb3AgdGhlIHJlZmVyZW5jZSBpZiBzZ19yZW1vdmVfc2ZwIHJldHVybmVkIDAK
KwkgICAob3RoZXJ3aXNlLCB0aGVyZSdzIElPIG91dHN0YW5kaW5nICYgd2UgbXVzdCBrZWVwIHRo
ZSByZWZlcmVuY2UpLiAqLworCWlmICghZGlydHkpCisJCXNjc2lfZ2VuZXJpY19wdXQoc2RwKTsK
KwogCXJldHVybiAwOwogfQogCkBAIC0xMTc1LDExICsxMjQ5LDE0IEBAIHN0YXRpYyBpbnQKIHNn
X21tYXAoc3RydWN0IGZpbGUgKmZpbHAsIHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hKQogewog
CVNnX2ZkICpzZnA7Ci0JdW5zaWduZWQgbG9uZyByZXFfc3ogPSB2bWEtPnZtX2VuZCAtIHZtYS0+
dm1fc3RhcnQ7CisJdW5zaWduZWQgbG9uZyByZXFfc3o7CiAJU2dfc2NhdHRlcl9ob2xkICpyc3Zf
c2NocDsKIAogCWlmICgoIWZpbHApIHx8ICghdm1hKSB8fCAoIShzZnAgPSAoU2dfZmQgKikgZmls
cC0+cHJpdmF0ZV9kYXRhKSkpCiAJCXJldHVybiAtRU5YSU87CisKKwlyZXFfc3ogPSB2bWEtPnZt
X2VuZCAtIHZtYS0+dm1fc3RhcnQ7CisKIAlTQ1NJX0xPR19USU1FT1VUKDMsIHByaW50aygic2df
bW1hcCBzdGFydGluZywgdm1fc3RhcnQ9JXAsIGxlbj0lZFxuIiwKIAkJCQkgICAodm9pZCAqKSB2
bWEtPnZtX3N0YXJ0LCAoaW50KSByZXFfc3opKTsKIAlpZiAodm1hLT52bV9wZ29mZikKQEAgLTEy
MzgsNyArMTMxNSw3IEBAIHNnX2NtZF9kb25lKFNjc2lfQ21uZCAqIFNDcG50KQogCXNmcCA9IHNy
cC0+cGFyZW50ZnA7CiAJaWYgKHNmcCkKIAkJc2RwID0gc2ZwLT5wYXJlbnRkcDsKLQlpZiAoKE5V
TEwgPT0gc2RwKSB8fCBzZHAtPmRldGFjaGVkKSB7CisJaWYgKE5VTEwgPT0gc2RwKSB7CiAJCXBy
aW50ayhLRVJOX0lORk8gInNnX2NtZF9kb25lOiBkZXZpY2UgZGV0YWNoZWRcbiIpOwogCQlzY3Np
X3JlbGVhc2VfcmVxdWVzdChTUnBudCk7CiAJCXJldHVybjsKQEAgLTEyOTgsOCArMTM3NSwxNiBA
QCBzZ19jbWRfZG9uZShTY3NpX0NtbmQgKiBTQ3BudCkKIAkJc3JwID0gTlVMTDsKIAkJaWYgKE5V
TEwgPT0gc2ZwLT5oZWFkcnApIHsKIAkJCVNDU0lfTE9HX1RJTUVPVVQoMSwgcHJpbnRrKCJzZy4u
LmJoOiBhbHJlYWR5IGNsb3NlZCwgZmluYWwgY2xlYW51cFxuIikpOwotCQkJaWYgKDAgPT0gc2df
cmVtb3ZlX3NmcChzZHAsIHNmcCkpIHsJLyogZGV2aWNlIHN0aWxsIHByZXNlbnQgKi8KLQkJCQlz
Y3NpX2RldmljZV9wdXQoc2RwLT5kZXZpY2UpOworCisJCQkvKiBEcm9wIGEgcmVmZXJlbmNlIGlm
IHNnX3JlbW92ZV9zZnAgcmV0dXJucyAwCisJCQkgICAobm8gSU8gb3V0c3RhbmRpbmcpLiAqLwor
CQkJaWYgKDAgPT0gc2dfcmVtb3ZlX3NmcChzZHAsIHNmcCkpIHsKKwkJCQlpZiAoc2NzaV9nZW5l
cmljX3B1dF9zY2hlZHVsZV93b3JrKHNkcCkpCisJCQkJeworCQkJCQkvKiBFcnJvciBzY2hlZHVs
aW5nIHRoZSB3b3JrLi4uCisJCQkJCSAgIGp1c3QgZHJvcCB0aGUgcmVmZXJlbmNlLiAqLworCQkJ
CQlzY3NpX2dlbmVyaWNfcHV0KHNkcCk7CisJCQkJfQogCQkJfQogCQkJc2ZwID0gTlVMTDsKIAkJ
fQpAQCAtMTQ0MSw2ICsxNTI2LDcgQEAgc2dfYWRkKHN0cnVjdCBjbGFzc19kZXZpY2UgKmNsX2Rl
dikKIAl9CiAJayA9IGVycm9yOwogCXNkcCA9IHNnX2Rldl9hcnJba107CisJa3JlZl9pbml0KCZz
ZHAtPmtyZWYpOwogCiAJZGV2ZnNfbWtfY2RldihNS0RFVihTQ1NJX0dFTkVSSUNfTUFKT1IsIGsp
LAogCQkJU19JRkNIUiB8IFNfSVJVU1IgfCBTX0lXVVNSIHwgU19JUkdSUCwKQEAgLTE0OTMsNDUg
KzE1NzksMzMgQEAgc2dfcmVtb3ZlKHN0cnVjdCBjbGFzc19kZXZpY2UgKmNsX2RldikKIAl1bnNp
Z25lZCBsb25nIGlmbGFnczsKIAlTZ19mZCAqc2ZwOwogCVNnX2ZkICp0c2ZwOwotCVNnX3JlcXVl
c3QgKnNycDsKLQlTZ19yZXF1ZXN0ICp0c3JwOwotCWludCBrLCBkZWxheTsKKwlpbnQgazsKIAog
CWlmIChOVUxMID09IHNnX2Rldl9hcnIpCiAJCXJldHVybjsKLQlkZWxheSA9IDA7CiAJd3JpdGVf
bG9ja19pcnFzYXZlKCZzZ19kZXZfYXJyX2xvY2ssIGlmbGFncyk7CiAJZm9yIChrID0gMDsgayA8
IHNnX2Rldl9tYXg7IGsrKykgewotCQlzZHAgPSBzZ19kZXZfYXJyW2tdOwotCQlpZiAoKE5VTEwg
PT0gc2RwKSB8fCAoc2RwLT5kZXZpY2UgIT0gc2NzaWRwKSkKKwkJaWYgKChOVUxMID09IHNnX2Rl
dl9hcnJba10pIHx8CisJCSAgICAoc2dfZGV2X2FycltrXS0+ZGV2aWNlICE9IHNjc2lkcCkpCiAJ
CQljb250aW51ZTsJLyogZGlydHkgYnV0IGxvd2VycyBuZXN0aW5nICovCisJCXNkcCA9IHNnX2Rl
dl9hcnJba107CisJCXNkcC0+ZGV0YWNoZWQgPSAxOworCiAJCWlmIChzZHAtPmhlYWRmcCkgewot
CQkJc2RwLT5kZXRhY2hlZCA9IDE7CiAJCQlmb3IgKHNmcCA9IHNkcC0+aGVhZGZwOyBzZnA7IHNm
cCA9IHRzZnApIHsKIAkJCQl0c2ZwID0gc2ZwLT5uZXh0ZnA7Ci0JCQkJZm9yIChzcnAgPSBzZnAt
PmhlYWRycDsgc3JwOyBzcnAgPSB0c3JwKSB7Ci0JCQkJCXRzcnAgPSBzcnAtPm5leHRycDsKLQkJ
CQkJaWYgKHNmcC0+Y2xvc2VkIHx8ICgwID09IHNnX3NycF9kb25lKHNycCwgc2ZwKSkpCi0JCQkJ
CQlzZ19maW5pc2hfcmVtX3JlcShzcnApOwotCQkJCX0KLQkJCQlpZiAoc2ZwLT5jbG9zZWQpIHsK
LQkJCQkJc2NzaV9kZXZpY2VfcHV0KHNkcC0+ZGV2aWNlKTsKLQkJCQkJX19zZ19yZW1vdmVfc2Zw
KHNkcCwgc2ZwKTsKLQkJCQl9IGVsc2UgewotCQkJCQlkZWxheSA9IDE7CisJCQkJaWYgKCEoc2Zw
LT5jbG9zZWQpKSB7CiAJCQkJCXdha2VfdXBfaW50ZXJydXB0aWJsZSgmc2ZwLT5yZWFkX3dhaXQp
OwogCQkJCQlraWxsX2Zhc3luYygmc2ZwLT5hc3luY19xcCwgU0lHUE9MTCwKIAkJCQkJCSAgICBQ
T0xMX0hVUCk7CiAJCQkJfQogCQkJfQogCQkJU0NTSV9MT0dfVElNRU9VVCgzLCBwcmludGsoInNn
X2RldGFjaDogZGV2PSVkLCBkaXJ0eVxuIiwgaykpOwotCQkJaWYgKE5VTEwgPT0gc2RwLT5oZWFk
ZnApIHsKLQkJCQlzZ19kZXZfYXJyW2tdID0gTlVMTDsKLQkJCX0KIAkJfSBlbHNlIHsJLyogbm90
aGluZyBhY3RpdmUsIHNpbXBsZSBjYXNlICovCiAJCQlTQ1NJX0xPR19USU1FT1VUKDMsIHByaW50
aygic2dfZGV0YWNoOiBkZXY9JWRcbiIsIGspKTsKLQkJCXNnX2Rldl9hcnJba10gPSBOVUxMOwog
CQl9CisKKwkJc2dfZGV2X2FycltrXSA9IE5VTEw7CiAJCXNnX25yX2Rldi0tOwogCQlicmVhazsK
IAl9CkBAIC0xNTQzLDE0ICsxNjE3LDMyIEBAIHNnX3JlbW92ZShzdHJ1Y3QgY2xhc3NfZGV2aWNl
ICpjbF9kZXYpCiAJCWNkZXZfZGVsKHNkcC0+Y2Rldik7CiAJCXNkcC0+Y2RldiA9IE5VTEw7CiAJ
CWRldmZzX3JlbW92ZSgiJXMvZ2VuZXJpYyIsIHNjc2lkcC0+ZGV2ZnNfbmFtZSk7Ci0JCXB1dF9k
aXNrKHNkcC0+ZGlzayk7Ci0JCXNkcC0+ZGlzayA9IE5VTEw7Ci0JCWlmIChOVUxMID09IHNkcC0+
aGVhZGZwKQotCQkJa2ZyZWUoKGNoYXIgKikgc2RwKTsKKworCQlkb3duKCZzZ19yZWZfc2VtKTsK
KwkJa3JlZl9wdXQoJnNkcC0+a3JlZiwgc2NzaV9nZW5lcmljX3JlbGVhc2UpOworCQl1cCgmc2df
cmVmX3NlbSk7CiAJfQorfQorCisvKioKKyAqICAgICAgc2NzaV9nZW5lcmljX3JlbGVhc2UgLSBD
YWxsZWQgdG8gZnJlZSB0aGUgU2dfZGV2aWNlIHN0cnVjdHVyZQorICogICAgICBAa3JlZjogcG9p
bnRlciB0byBlbWJlZGRlZCBrcmVmCisgKgorICogICAgICBzZ19yZWZfc2VtIG11c3QgYmUgaGVs
ZCBlbnRlcmluZyB0aGlzIHJvdXRpbmUuICBCZWNhdXNlIGl0IGlzCisgKiAgICAgIGNhbGxlZCBv
biBsYXN0IHB1dCwgeW91IHNob3VsZCBhbHdheXMgdXNlIHRoZSBzY3NpX2dlbmVyaWNfZ2V0KCkK
KyAqICAgICAgYW5kIHNjc2lfZ2VuZXJpY19wdXQoKSBoZWxwZXJzIHdoaWNoIG1hbmlwdWxhdGUg
dGhlIHNlbWFwaG9yZQorICogICAgICBkaXJlY3RseSBhbmQgbmV2ZXIgZG8gYSBkaXJlY3Qga3Jl
Zl9wdXQoKS4KKyAqKi8KK3N0YXRpYyB2b2lkIHNjc2lfZ2VuZXJpY19yZWxlYXNlKHN0cnVjdCBr
cmVmICprcmVmKQoreworCVNnX2RldmljZSAqc2RwID0gdG9fc2NzaV9nZW5lcmljKGtyZWYpOwor
CXN0cnVjdCBnZW5kaXNrICpkaXNrID0gc2RwLT5kaXNrOworCisJZGlzay0+cHJpdmF0ZV9kYXRh
ID0gTlVMTDsKKwlwdXRfZGlzayhkaXNrKTsKIAotCWlmIChkZWxheSkKLQkJbXNsZWVwKDEwKTsJ
LyogZGlydHkgZGV0YWNoIHNvIGRlbGF5IGRldmljZSBkZXN0cnVjdGlvbiAqLworCWtmcmVlKChj
aGFyICopIHNkcCk7CisJcmV0dXJuOwogfQogCiAvKiBTZXQgJ3Blcm0nICg0dGggYXJndW1lbnQp
IHRvIDAgdG8gZGlzYWJsZSBtb2R1bGVfcGFyYW0ncyBkZWZpbml0aW9uCkBAIC0xNjAyLDYgKzE2
OTQsOSBAQCBlcnJfb3V0Ogogc3RhdGljIHZvaWQgX19leGl0CiBleGl0X3NnKHZvaWQpCiB7CisJ
Lyogc2dfY21kX2RvbmUgY2FuIHNjaGVkdWxlIHdvcmsuLi4gd2FpdCBmb3IgaXQgdG8gY29tcGxl
dGUuICovCisJZmx1c2hfc2NoZWR1bGVkX3dvcmsoKTsKKwogI2lmZGVmIENPTkZJR19TQ1NJX1BS
T0NfRlMKIAlzZ19wcm9jX2NsZWFudXAoKTsKICNlbmRpZgkJCQkvKiBDT05GSUdfU0NTSV9QUk9D
X0ZTICovCkBAIC0yNDg0LDE0ICsyNTc5LDEzIEBAIF9fc2dfcmVtb3ZlX3NmcChTZ19kZXZpY2Ug
KiBzZHAsIFNnX2ZkICoKIAlzZ19wYWdlX2ZyZWUoKGNoYXIgKikgc2ZwLCBzaXplb2YgKFNnX2Zk
KSk7CiB9CiAKLS8qIFJldHVybnMgMCBpbiBub3JtYWwgY2FzZSwgMSB3aGVuIGRldGFjaGVkIGFu
ZCBzZHAgb2JqZWN0IHJlbW92ZWQgKi8KKy8qIFJldHVybnMgYSBjb3VudCBvZiBJT3Mgc3RpbGwg
aW4gcHJvZ3Jlc3MuICovCiBzdGF0aWMgaW50CiBzZ19yZW1vdmVfc2ZwKFNnX2RldmljZSAqIHNk
cCwgU2dfZmQgKiBzZnApCiB7CiAJU2dfcmVxdWVzdCAqc3JwOwogCVNnX3JlcXVlc3QgKnRzcnA7
CiAJaW50IGRpcnR5ID0gMDsKLQlpbnQgcmVzID0gMDsKIAogCWZvciAoc3JwID0gc2ZwLT5oZWFk
cnA7IHNycDsgc3JwID0gdHNycCkgewogCQl0c3JwID0gc3JwLT5uZXh0cnA7CkBAIC0yNTA1LDMw
ICsyNTk5LDE2IEBAIHNnX3JlbW92ZV9zZnAoU2dfZGV2aWNlICogc2RwLCBTZ19mZCAqIHMKIAog
CQl3cml0ZV9sb2NrX2lycXNhdmUoJnNnX2Rldl9hcnJfbG9jaywgaWZsYWdzKTsKIAkJX19zZ19y
ZW1vdmVfc2ZwKHNkcCwgc2ZwKTsKLQkJaWYgKHNkcC0+ZGV0YWNoZWQgJiYgKE5VTEwgPT0gc2Rw
LT5oZWFkZnApKSB7Ci0JCQlpbnQgaywgbWF4ZDsKLQotCQkJbWF4ZCA9IHNnX2Rldl9tYXg7Ci0J
CQlmb3IgKGsgPSAwOyBrIDwgbWF4ZDsgKytrKSB7Ci0JCQkJaWYgKHNkcCA9PSBzZ19kZXZfYXJy
W2tdKQotCQkJCQlicmVhazsKLQkJCX0KLQkJCWlmIChrIDwgbWF4ZCkKLQkJCQlzZ19kZXZfYXJy
W2tdID0gTlVMTDsKLQkJCWtmcmVlKChjaGFyICopIHNkcCk7Ci0JCQlyZXMgPSAxOwotCQl9CiAJ
CXdyaXRlX3VubG9ja19pcnFyZXN0b3JlKCZzZ19kZXZfYXJyX2xvY2ssIGlmbGFncyk7CiAJfSBl
bHNlIHsKLQkJLyogTU9EX0lOQydzIHRvIGluaGliaXQgdW5sb2FkaW5nIHNnIGFuZCBhc3NvY2lh
dGVkIGFkYXB0ZXIgZHJpdmVyICovCi0JCS8qIG9ubHkgYnVtcCB0aGUgYWNjZXNzX2NvdW50IGlm
IHdlIGFjdHVhbGx5IHN1Y2NlZWRlZCBpbgotCQkgKiB0aHJvd2luZyBhbm90aGVyIGNvdW50ZXIg
b24gdGhlIGhvc3QgbW9kdWxlICovCi0JCXNjc2lfZGV2aWNlX2dldChzZHAtPmRldmljZSk7CS8q
IFhYWDogcmV0dmFsIGlnbm9yZWQ/ICovCQorCQkvKiBUaGUgbm9uLXplcm8gZGlydHkgY291bnQg
d2lsbCBiZSByZXR1cm5lZC4gVGhpcyB3aWxsIHRlbGwKKwkJICAgdGhlIGNhbGxlciBub3QgdG8g
ZHJvcCB0aGUgcmVmZXJlbmNlIG9uIHRoaXMgZGV2aWNlLiAqLworCiAJCXNmcC0+Y2xvc2VkID0g
MTsJLyogZmxhZyBkaXJ0eSBzdGF0ZSBvbiB0aGlzIGZkICovCiAJCVNDU0lfTE9HX1RJTUVPVVQo
MSwgcHJpbnRrKCJzZ19yZW1vdmVfc2ZwOiB3b3JyaXNvbWUsICVkIHdyaXRlcyBwZW5kaW5nXG4i
LAogCQkJCSAgZGlydHkpKTsKIAl9Ci0JcmV0dXJuIHJlczsKKwlyZXR1cm4gZGlydHk7CiB9CiAK
IHN0YXRpYyBpbnQK

------_=_NextPart_001_01C5D596.1454D8C9--
