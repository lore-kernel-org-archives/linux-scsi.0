From: <Stuart_Hayes@Dell.com>
Subject: ide-scsi oops with ide tape drive
Date: Tue, 8 Mar 2005 14:52:25 -0600
Message-ID: <7A8F92187EF7A249BF847F1BF4903C04010EE993@ausx2kmpc103.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C52420.BBA5377C"
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:26276 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S262276AbVCHUw2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Mar 2005 15:52:28 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joshua_Giles@Dell.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01C52420.BBA5377C
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hello!

We're seeing a null pointer dereference with certain IDE tape drives on
2.6.11 when we use it with ide-scsi (i686 architecture).  The problem is
that the scatter-gather pages aren't mapped to kernel virtual address
space in idescsi_output_buffers()/idescsi_input_buffers(), so, if these
pages are in high memory, page_address() returns a null pointer.

This patch fixes the problem.  I'll attach it as a file, too, just in
case it gets mangled.  Please let me know if there are any problems with
or questions regarding this patch.

Again, this patch is against 2.6.11.

Thanks!
Stuart Hayes
stuart_hayes@dell.com



--- ide-scsi.c.orig	2005-03-08 13:44:38.000000000 -0500
+++ ide-scsi.c	2005-03-08 14:02:43.000000000 -0500
@@ -151,8 +151,9 @@ static void idescsi_input_buffers (ide_d
 			return;
 		}
 		count =3D min(pc->sg->length - pc->b_count, bcount);
-		buf =3D page_address(pc->sg->page) + pc->sg->offset;
+		buf =3D kmap_atomic(pc->sg->page, KM_USER0) +
pc->sg->offset;
 		drive->hwif->atapi_input_bytes(drive, buf + pc->b_count,
count);
+		kunmap_atomic(buf - pc->sg->offset, KM_USER0);
 		bcount -=3D count; pc->b_count +=3D count;
 		if (pc->b_count =3D=3D pc->sg->length) {
 			pc->sg++;
@@ -173,8 +174,9 @@ static void idescsi_output_buffers (ide_
 			return;
 		}
 		count =3D min(pc->sg->length - pc->b_count, bcount);
-		buf =3D page_address(pc->sg->page) + pc->sg->offset;
+		buf =3D kmap_atomic(pc->sg->page, KM_USER0) +
pc->sg->offset;
 		drive->hwif->atapi_output_bytes(drive, buf +
pc->b_count, count);
+		kunmap_atomic(buf - pc->sg->offset, KM_USER0);
 		bcount -=3D count; pc->b_count +=3D count;
 		if (pc->b_count =3D=3D pc->sg->length) {
 			pc->sg++;

------_=_NextPart_001_01C52420.BBA5377C
Content-Type: application/octet-stream;
	name="ide-scsi.2.6.11.patch"
Content-Transfer-Encoding: base64
Content-Description: ide-scsi.2.6.11.patch
Content-Disposition: attachment;
	filename="ide-scsi.2.6.11.patch"

LS0tIGlkZS1zY3NpLmMub3JpZwkyMDA1LTAzLTA4IDEzOjQ0OjM4LjAwMDAwMDAwMCAtMDUwMAor
KysgaWRlLXNjc2kuYwkyMDA1LTAzLTA4IDE0OjAyOjQzLjAwMDAwMDAwMCAtMDUwMApAQCAtMTUx
LDggKzE1MSw5IEBAIHN0YXRpYyB2b2lkIGlkZXNjc2lfaW5wdXRfYnVmZmVycyAoaWRlX2QKIAkJ
CXJldHVybjsKIAkJfQogCQljb3VudCA9IG1pbihwYy0+c2ctPmxlbmd0aCAtIHBjLT5iX2NvdW50
LCBiY291bnQpOwotCQlidWYgPSBwYWdlX2FkZHJlc3MocGMtPnNnLT5wYWdlKSArIHBjLT5zZy0+
b2Zmc2V0OworCQlidWYgPSBrbWFwX2F0b21pYyhwYy0+c2ctPnBhZ2UsIEtNX1VTRVIwKSArIHBj
LT5zZy0+b2Zmc2V0OwogCQlkcml2ZS0+aHdpZi0+YXRhcGlfaW5wdXRfYnl0ZXMoZHJpdmUsIGJ1
ZiArIHBjLT5iX2NvdW50LCBjb3VudCk7CisJCWt1bm1hcF9hdG9taWMoYnVmIC0gcGMtPnNnLT5v
ZmZzZXQsIEtNX1VTRVIwKTsKIAkJYmNvdW50IC09IGNvdW50OyBwYy0+Yl9jb3VudCArPSBjb3Vu
dDsKIAkJaWYgKHBjLT5iX2NvdW50ID09IHBjLT5zZy0+bGVuZ3RoKSB7CiAJCQlwYy0+c2crKzsK
QEAgLTE3Myw4ICsxNzQsOSBAQCBzdGF0aWMgdm9pZCBpZGVzY3NpX291dHB1dF9idWZmZXJzIChp
ZGVfCiAJCQlyZXR1cm47CiAJCX0KIAkJY291bnQgPSBtaW4ocGMtPnNnLT5sZW5ndGggLSBwYy0+
Yl9jb3VudCwgYmNvdW50KTsKLQkJYnVmID0gcGFnZV9hZGRyZXNzKHBjLT5zZy0+cGFnZSkgKyBw
Yy0+c2ctPm9mZnNldDsKKwkJYnVmID0ga21hcF9hdG9taWMocGMtPnNnLT5wYWdlLCBLTV9VU0VS
MCkgKyBwYy0+c2ctPm9mZnNldDsKIAkJZHJpdmUtPmh3aWYtPmF0YXBpX291dHB1dF9ieXRlcyhk
cml2ZSwgYnVmICsgcGMtPmJfY291bnQsIGNvdW50KTsKKwkJa3VubWFwX2F0b21pYyhidWYgLSBw
Yy0+c2ctPm9mZnNldCwgS01fVVNFUjApOwogCQliY291bnQgLT0gY291bnQ7IHBjLT5iX2NvdW50
ICs9IGNvdW50OwogCQlpZiAocGMtPmJfY291bnQgPT0gcGMtPnNnLT5sZW5ndGgpIHsKIAkJCXBj
LT5zZysrOwo=

------_=_NextPart_001_01C52420.BBA5377C--
