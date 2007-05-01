From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: superfluous adapter reset for IBM 8 series ServeRAID controllers
Date: Tue, 1 May 2007 11:43:06 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF018FDDBD@otce2k301.adaptec.com>
References: <46326FE1.1030605@us.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C78C07.6A0BA310"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:37560 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbXEAPnL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 May 2007 11:43:11 -0400
Content-class: urn:content-classes:message
In-Reply-To: <46326FE1.1030605@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Alexis Bruemmer <ahbruemm@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C78C07.6A0BA310
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The kexec patch introduced a superfluous (and otherwise inert) reset of
some adapters. The register can have a hardware default value that has
zeros for the undefined interrupts. This patch refines the test of the
interrupt enable register to focus on only the interrupts that affect
the driver in order to detect if an incomplete shutdown of the Adapter
had occurred (kdump).

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patches. Dynamic fast paced public patches create confusion.

This attached patch is against current scsi-misc-2.6 *after* either the
aacraid_kexec_5 or the aacraid_kexec_fix patches have propagated. The
reason for supplying this patch in this manner is to recognize the lower
priority of this patch, the dependence and to survive cleanly the
sequencing and the overlap of patch application. James, say the word and
I can provide an aacraid_kexec_6 with this rolled in, but my goal is NOT
to delay aacraid_kexec_5 (or aacraid_kexec_fix as applied to
aacraid_kexec_2 which currently is in scsi-misc-2.6 and 2.6.21-rc6-mm1+)
from propagating otherwise.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

---

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Darrick J. Wong [mailto:djwong@us.ibm.com]=20
> Sent: Friday, April 27, 2007 5:49 PM
> To: Salyzyn, Mark
> Cc: linux-scsi@vger.kernel.org; Alexis Bruemmer; Vivek Goyal;=20
> Judith Lebzelter
> Subject: Re: [PATCH] aacraid: Initialize rx/rkt function pointers
before calling them
>=20
> Salyzyn, Mark wrote:
> > As an option for a patch (later), what was the actual value of the
> > Munit.OIMR register (on the x3550 and the x3650 please,=20
> just in case)?
>=20
> 0xF.
>=20
> --D

------_=_NextPart_001_01C78C07.6A0BA310
Content-Type: application/octet-stream;
	name="aacraid_aurora.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_aurora.patch
Content-Disposition: attachment;
	filename="aacraid_aurora.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jIGIvZHJpdmVycy9zY3NpL2FhY3Jh
aWQvcnguYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jCTIwMDctMDUtMDEgMTE6MTc6
NDYuNjY4MzIxMjYwIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMJMjAwNy0w
NS0wMSAxMToxODoyNC4zODQ3MDczOTQgLTA0MDAKQEAgLTU0Miw3ICs1NDIsNyBAQAogCWRldi0+
YV9vcHMuYWRhcHRlcl9zeW5jX2NtZCA9IHJ4X3N5bmNfY21kOwogCWRldi0+YV9vcHMuYWRhcHRl
cl9lbmFibGVfaW50ID0gYWFjX3J4X2Rpc2FibGVfaW50ZXJydXB0OwogCWRldi0+T0lNUiA9IHN0
YXR1cyA9IHJ4X3JlYWRiIChkZXYsIE1Vbml0Lk9JTVIpOwotCWlmICgoKChzdGF0dXMgJiAweGZm
KSAhPSAweGZmKSB8fCByZXNldF9kZXZpY2VzKSAmJgorCWlmICgoKChzdGF0dXMgJiAweDBjKSAh
PSAweDBjKSB8fCByZXNldF9kZXZpY2VzKSAmJgogCSAgIWFhY19yeF9yZXN0YXJ0X2FkYXB0ZXIo
ZGV2LCAwKSkKIAkJKytyZXN0YXJ0OwogCS8qCg==

------_=_NextPart_001_01C78C07.6A0BA310--
