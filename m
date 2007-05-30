From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: fix shutdown handler to also disable interrupts.
Date: Wed, 30 May 2007 11:59:13 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55087@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55010@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7A2D3.785E8848"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:55759 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbXE3P7T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 11:59:19 -0400
Content-class: urn:content-classes:message
In-reply-to: <AE4F746F2AECFC4DA4AADD66A1DFEF01A55010@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: vgoyal@in.ibm.com, Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yhlu.kernel@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7A2D3.785E8848
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Moves quiesce, thread and interrupt shutdown into aacraid drivers'
.shutdown handler. This fix to the aac_shutdown handler will remove the
superfluous reset of the adapter during a (clean) kexec.

This fix may mitigate the active investigation 'kexec and aacraid
broken' but it is unlikely to affect the root cause (issue likely
present in both kexec and kdump). This patch reduces the chance the
problem will occur with a kexec. The fix for root cause is currently
expected to be the minimum value check to the aacraid.startup_timeout
driver variable after an adapter reset within aacraid_commit_reset.patch
submitted on 05/22/2007 and awaiting testing by Yinghai to confirm.

This attached patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
> Sent: Wednesday, May 30, 2007 10:31 AM
> To: vgoyal@in.ibm.com
> Cc: Andrew Morton; Yinghai Lu; Eric W. Biederman; Linux=20
> Kernel Mailing List; linux-scsi@vger.kernel.org; Michal Piotrowski
> Subject: RE: kexec and aacraid broken
>=20
> Vivek Goyal [mailto:vgoyal@in.ibm.com] writes:
> > So most likely if we start disabling the interrupts
> > in .shutdown routine we might skip resetting adapter
> > on every kexec without any side affects?
>=20
> Not that simple. The .shutdown would need to perform more resource
> cleanups of the .remove call to prevent side effects. I need to move
> some of the .remove activity into the .shutdown handler to=20
> make sure the
> adapter is quiesced.
>=20
> I will hold off on submitting any of these changes until they are
> evaluated and tested; I am waiting for feedback from Yinghai on the
> other mitigations that I feel are closer to the root cause.
>=20
> Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C7A2D3.785E8848
Content-Type: application/octet-stream;
	name="aacraid_shutdown.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_shutdown.patch
Content-Disposition: attachment;
	filename="aacraid_shutdown.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDctMDUt
MzAgMTE6MDA6MzYuNjE5ODMxNTIxIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwNy0wNS0zMCAxMTowNDozNS4zMjU4NjcyMTIgLTA0MDAKQEAgLTg1OSw2ICs4NTks
MTQgQEAKIAkuZW11bGF0ZWQgICAgICAgICAgICAgICAgICAgICAgID0gMSwKIH07CiAKK3N0YXRp
YyB2b2lkIF9fYWFjX3NodXRkb3duKHN0cnVjdCBhYWNfZGV2ICogYWFjKQoreworCWt0aHJlYWRf
c3RvcChhYWMtPnRocmVhZCk7CisJYWFjX3NlbmRfc2h1dGRvd24oYWFjKTsKKwlhYWNfYWRhcHRl
cl9kaXNhYmxlX2ludChhYWMpOworCWZyZWVfaXJxKGFhYy0+cGRldi0+aXJxLCBhYWMpOworfQor
CiBzdGF0aWMgaW50IF9fZGV2aW5pdCBhYWNfcHJvYmVfb25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2
LAogCQljb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQpCiB7CkBAIC0xMDExLDEwICsxMDE5
LDcgQEAKIAlyZXR1cm4gMDsKIAogIG91dF9kZWluaXQ6Ci0Ja3RocmVhZF9zdG9wKGFhYy0+dGhy
ZWFkKTsKLQlhYWNfc2VuZF9zaHV0ZG93bihhYWMpOwotCWFhY19hZGFwdGVyX2Rpc2FibGVfaW50
KGFhYyk7Ci0JZnJlZV9pcnEocGRldi0+aXJxLCBhYWMpOworCV9fYWFjX3NodXRkb3duKGFhYyk7
CiAgb3V0X3VubWFwOgogCWFhY19maWJfbWFwX2ZyZWUoYWFjKTsKIAlwY2lfZnJlZV9jb25zaXN0
ZW50KGFhYy0+cGRldiwgYWFjLT5jb21tX3NpemUsIGFhYy0+Y29tbV9hZGRyLCBhYWMtPmNvbW1f
cGh5cyk7CkBAIC0xMDM0LDcgKzEwMzksOCBAQAogewogCXN0cnVjdCBTY3NpX0hvc3QgKnNob3N0
ID0gcGNpX2dldF9kcnZkYXRhKGRldik7CiAJc3RydWN0IGFhY19kZXYgKmFhYyA9IChzdHJ1Y3Qg
YWFjX2RldiAqKXNob3N0LT5ob3N0ZGF0YTsKLQlhYWNfc2VuZF9zaHV0ZG93bihhYWMpOworCXNj
c2lfYmxvY2tfcmVxdWVzdHMoc2hvc3QpOworCV9fYWFjX3NodXRkb3duKGFhYyk7CiB9CiAKIHN0
YXRpYyB2b2lkIF9fZGV2ZXhpdCBhYWNfcmVtb3ZlX29uZShzdHJ1Y3QgcGNpX2RldiAqcGRldikK
QEAgLTEwNDQsMTYgKzEwNTAsMTIgQEAKIAogCXNjc2lfcmVtb3ZlX2hvc3Qoc2hvc3QpOwogCi0J
a3RocmVhZF9zdG9wKGFhYy0+dGhyZWFkKTsKLQotCWFhY19zZW5kX3NodXRkb3duKGFhYyk7Ci0J
YWFjX2FkYXB0ZXJfZGlzYWJsZV9pbnQoYWFjKTsKKwlfX2FhY19zaHV0ZG93bihhYWMpOwogCWFh
Y19maWJfbWFwX2ZyZWUoYWFjKTsKIAlwY2lfZnJlZV9jb25zaXN0ZW50KGFhYy0+cGRldiwgYWFj
LT5jb21tX3NpemUsIGFhYy0+Y29tbV9hZGRyLAogCQkJYWFjLT5jb21tX3BoeXMpOwogCWtmcmVl
KGFhYy0+cXVldWVzKTsKIAotCWZyZWVfaXJxKHBkZXYtPmlycSwgYWFjKTsKIAlhYWNfYWRhcHRl
cl9pb3JlbWFwKGFhYywgMCk7CiAJCiAJa2ZyZWUoYWFjLT5maWJzKTsK

------_=_NextPart_001_01C7A2D3.785E8848--
