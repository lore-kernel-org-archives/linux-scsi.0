From: <Stuart_Hayes@Dell.com>
Subject: [PATCH 2.6.11] ide-scsi: map sg buffers in idescsi_input/output_buffers() to kernel virtual address
Date: Wed, 9 Mar 2005 14:26:03 -0600
Message-ID: <7A8F92187EF7A249BF847F1BF4903C04010EE9A6@ausx2kmpc103.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C524E6.36E7BE64"
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:41761 "EHLO
	ausc60pc101.us.dell.com") by vger.kernel.org with ESMTP
	id S262376AbVCIU0L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Mar 2005 15:26:11 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org, Joshua_Giles@Dell.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01C524E6.36E7BE64
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


This patch will map the sg buffers to kernel virtual memory space in the
functions idescsi_input_buffers() and idescsi_output_buffers().  Without
this patch, idescsi passes a null pointer to atapi_input_bytes() and
atapi_output_bytes() when sg pages are in high memory (i686
architecture).

I'm attaching as a file, too, as the text will certainly be wrapped.

(Sorry for the subject rename--I'm trying to use the correct format for
patch emails.)

Thanks
Stuart


Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>


--- linux-2.6.11.orig/drivers/scsi/ide-scsi.c	2005-03-09
14:13:48.000000000 -0500
+++ linux-2.6.11.new/drivers/scsi/ide-scsi.c	2005-03-09
13:56:38.000000000 -0500
@@ -143,6 +143,7 @@ static void idescsi_input_buffers (ide_d
 {
 	int count;
 	char *buf;
+	unsigned long flags;
=20
 	while (bcount) {
 		if (pc->sg - (struct scatterlist *)
pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
@@ -151,8 +152,11 @@ static void idescsi_input_buffers (ide_d
 			return;
 		}
 		count =3D min(pc->sg->length - pc->b_count, bcount);
-		buf =3D page_address(pc->sg->page) + pc->sg->offset;
+		local_irq_save(flags);
+		buf =3D kmap_atomic(pc->sg->page, KM_USER0) +
pc->sg->offset;
 		drive->hwif->atapi_input_bytes(drive, buf + pc->b_count,
count);
+		kunmap_atomic(buf - pc->sg->offset, KM_USER0);
+		local_irq_restore(flags);
 		bcount -=3D count; pc->b_count +=3D count;
 		if (pc->b_count =3D=3D pc->sg->length) {
 			pc->sg++;
@@ -165,6 +169,7 @@ static void idescsi_output_buffers (ide_
 {
 	int count;
 	char *buf;
+	unsigned long flags;
=20
 	while (bcount) {
 		if (pc->sg - (struct scatterlist *)
pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
@@ -173,8 +178,11 @@ static void idescsi_output_buffers (ide_
 			return;
 		}
 		count =3D min(pc->sg->length - pc->b_count, bcount);
-		buf =3D page_address(pc->sg->page) + pc->sg->offset;
+		local_irq_save(flags);
+		buf =3D kmap_atomic(pc->sg->page, KM_USER0) +
pc->sg->offset;
 		drive->hwif->atapi_output_bytes(drive, buf +
pc->b_count, count);
+		kunmap_atomic(buf - pc->sg->offset, KM_USER0);
+		local_irq_restore(flags);
 		bcount -=3D count; pc->b_count +=3D count;
 		if (pc->b_count =3D=3D pc->sg->length) {
 			pc->sg++;

------_=_NextPart_001_01C524E6.36E7BE64
Content-Type: application/octet-stream;
	name="ide-scsi.2.6.11.try3.patch"
Content-Transfer-Encoding: base64
Content-Description: ide-scsi.2.6.11.try3.patch
Content-Disposition: attachment;
	filename="ide-scsi.2.6.11.try3.patch"

LS0tIGxpbnV4LTIuNi4xMS5vcmlnL2RyaXZlcnMvc2NzaS9pZGUtc2NzaS5jCTIwMDUtMDMtMDkg
MTQ6MTM6NDguMDAwMDAwMDAwIC0wNTAwCisrKyBsaW51eC0yLjYuMTEubmV3L2RyaXZlcnMvc2Nz
aS9pZGUtc2NzaS5jCTIwMDUtMDMtMDkgMTM6NTY6MzguMDAwMDAwMDAwIC0wNTAwCkBAIC0xNDMs
NiArMTQzLDcgQEAgc3RhdGljIHZvaWQgaWRlc2NzaV9pbnB1dF9idWZmZXJzIChpZGVfZAogewog
CWludCBjb3VudDsKIAljaGFyICpidWY7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKIAogCXdoaWxl
IChiY291bnQpIHsKIAkJaWYgKHBjLT5zZyAtIChzdHJ1Y3Qgc2NhdHRlcmxpc3QgKikgcGMtPnNj
c2lfY21kLT5yZXF1ZXN0X2J1ZmZlciA+IHBjLT5zY3NpX2NtZC0+dXNlX3NnKSB7CkBAIC0xNTEs
OCArMTUyLDExIEBAIHN0YXRpYyB2b2lkIGlkZXNjc2lfaW5wdXRfYnVmZmVycyAoaWRlX2QKIAkJ
CXJldHVybjsKIAkJfQogCQljb3VudCA9IG1pbihwYy0+c2ctPmxlbmd0aCAtIHBjLT5iX2NvdW50
LCBiY291bnQpOwotCQlidWYgPSBwYWdlX2FkZHJlc3MocGMtPnNnLT5wYWdlKSArIHBjLT5zZy0+
b2Zmc2V0OworCQlsb2NhbF9pcnFfc2F2ZShmbGFncyk7CisJCWJ1ZiA9IGttYXBfYXRvbWljKHBj
LT5zZy0+cGFnZSwgS01fVVNFUjApICsgcGMtPnNnLT5vZmZzZXQ7CiAJCWRyaXZlLT5od2lmLT5h
dGFwaV9pbnB1dF9ieXRlcyhkcml2ZSwgYnVmICsgcGMtPmJfY291bnQsIGNvdW50KTsKKwkJa3Vu
bWFwX2F0b21pYyhidWYgLSBwYy0+c2ctPm9mZnNldCwgS01fVVNFUjApOworCQlsb2NhbF9pcnFf
cmVzdG9yZShmbGFncyk7CiAJCWJjb3VudCAtPSBjb3VudDsgcGMtPmJfY291bnQgKz0gY291bnQ7
CiAJCWlmIChwYy0+Yl9jb3VudCA9PSBwYy0+c2ctPmxlbmd0aCkgewogCQkJcGMtPnNnKys7CkBA
IC0xNjUsNiArMTY5LDcgQEAgc3RhdGljIHZvaWQgaWRlc2NzaV9vdXRwdXRfYnVmZmVycyAoaWRl
XwogewogCWludCBjb3VudDsKIAljaGFyICpidWY7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKIAog
CXdoaWxlIChiY291bnQpIHsKIAkJaWYgKHBjLT5zZyAtIChzdHJ1Y3Qgc2NhdHRlcmxpc3QgKikg
cGMtPnNjc2lfY21kLT5yZXF1ZXN0X2J1ZmZlciA+IHBjLT5zY3NpX2NtZC0+dXNlX3NnKSB7CkBA
IC0xNzMsOCArMTc4LDExIEBAIHN0YXRpYyB2b2lkIGlkZXNjc2lfb3V0cHV0X2J1ZmZlcnMgKGlk
ZV8KIAkJCXJldHVybjsKIAkJfQogCQljb3VudCA9IG1pbihwYy0+c2ctPmxlbmd0aCAtIHBjLT5i
X2NvdW50LCBiY291bnQpOwotCQlidWYgPSBwYWdlX2FkZHJlc3MocGMtPnNnLT5wYWdlKSArIHBj
LT5zZy0+b2Zmc2V0OworCQlsb2NhbF9pcnFfc2F2ZShmbGFncyk7CisJCWJ1ZiA9IGttYXBfYXRv
bWljKHBjLT5zZy0+cGFnZSwgS01fVVNFUjApICsgcGMtPnNnLT5vZmZzZXQ7CiAJCWRyaXZlLT5o
d2lmLT5hdGFwaV9vdXRwdXRfYnl0ZXMoZHJpdmUsIGJ1ZiArIHBjLT5iX2NvdW50LCBjb3VudCk7
CisJCWt1bm1hcF9hdG9taWMoYnVmIC0gcGMtPnNnLT5vZmZzZXQsIEtNX1VTRVIwKTsKKwkJbG9j
YWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOwogCQliY291bnQgLT0gY291bnQ7IHBjLT5iX2NvdW50ICs9
IGNvdW50OwogCQlpZiAocGMtPmJfY291bnQgPT0gcGMtPnNnLT5sZW5ndGgpIHsKIAkJCXBjLT5z
ZysrOwo=

------_=_NextPart_001_01C524E6.36E7BE64--
