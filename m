From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: SMC vendor identification
Date: Fri, 11 Jan 2008 13:46:24 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F437E44532@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au><20071101173221.2e1fea42.sfr@canb.auug.org.au>
 <jefxzqqeha.fsf@sykes.suse.de>
 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE738@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE739@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE73E@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F437E96989@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F437E443DE@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F437E44532ADPE2K703adapte_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:52260 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761119AbYAKVq2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Jan 2008 16:46:28 -0500
Received: from ADPE2K702.adaptec.com (adpe2k702.adaptec.com [10.25.8.26])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id D9178225106
	for <linux-scsi@vger.kernel.org>; Fri, 11 Jan 2008 13:46:27 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F437E443DE@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F437E44532ADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Due to an internal limit associated with the AdapterTypeText field, SMC req=
uired a product ID that overloaded the combined vendor and product ID. A de=
cision was made to ship the SMC products without a vendor string dropping t=
he defacto space that used to delineate vendor and product to boot. To corr=
ect this, we needed to adjust the code in the driver to parse out the vendo=
r and product strings for the adapter. We match of 'AOC' in the AdapterType=
Text, if so we set the vendor to SMC and place the entire AdapterTypeText i=
nto the product field.

This only affects the cosmetic presentation of the Adapter vendor and produ=
ct in the logs and in sysfs.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments, use the attachment, not the inline patch.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/aachba.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff -ru a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
--- a/drivers/scsi/aacraid/aachba.c     2008-01-11 16:28:15.129189613 -0500
+++ b/drivers/scsi/aacraid/aachba.c     2008-01-11 16:31:22.032344801 -0500
@@ -716,16 +716,21 @@

        if (dev->supplement_adapter_info.AdapterTypeText[0]) {
                char * cp =3D dev->supplement_adapter_info.AdapterTypeText;
-               int c =3D sizeof(str->vid);
-               while (*cp && *cp !=3D ' ' && --c)
-                       ++cp;
-               c =3D *cp;
-               *cp =3D '\0';
-               inqstrcpy (dev->supplement_adapter_info.AdapterTypeText,
-                 str->vid);
-               *cp =3D c;
-               while (*cp && *cp !=3D ' ')
-                       ++cp;
+               int c;
+               if ((cp[0] =3D=3D 'A') && (cp[1] =3D=3D 'O') && (cp[2] =3D=
=3D 'C'))
+                       inqstrcpy("SMC", str->vid);
+               else {
+                       c =3D sizeof(str->vid);
+                       while (*cp && *cp !=3D ' ' && --c)
+                               ++cp;
+                       c =3D *cp;
+                       *cp =3D '\0';
+                       inqstrcpy (dev->supplement_adapter_info.AdapterType=
Text,
+                         str->vid);
+                       *cp =3D c;
+                       while (*cp && *cp !=3D ' ')
+                               ++cp;
+               }
                while (*cp =3D=3D ' ')
                        ++cp;
                /* last six chars reserved for vol type */

Sincerely -- Mark Salyzyn

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F437E44532ADPE2K703adapte_
Content-Type: application/octet-stream; name="aacraid_SMC_vid.patch"
Content-Description: aacraid_SMC_vid.patch
Content-Disposition: attachment; filename="aacraid_SMC_vid.patch"; size=1019;
	creation-date="Fri, 11 Jan 2008 13:32:19 GMT";
	modification-date="Fri, 11 Jan 2008 13:32:19 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDgt
MDEtMTEgMTY6Mjg6MTUuMTI5MTg5NjEzIC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDgtMDEtMTEgMTY6MzE6MjIuMDMyMzQ0ODAxIC0wNTAwCkBAIC03MTYsMTYg
KzcxNiwyMSBAQAogCiAJaWYgKGRldi0+c3VwcGxlbWVudF9hZGFwdGVyX2luZm8uQWRhcHRlclR5
cGVUZXh0WzBdKSB7CiAJCWNoYXIgKiBjcCA9IGRldi0+c3VwcGxlbWVudF9hZGFwdGVyX2luZm8u
QWRhcHRlclR5cGVUZXh0OwotCQlpbnQgYyA9IHNpemVvZihzdHItPnZpZCk7Ci0JCXdoaWxlICgq
Y3AgJiYgKmNwICE9ICcgJyAmJiAtLWMpCi0JCQkrK2NwOwotCQljID0gKmNwOwotCQkqY3AgPSAn
XDAnOwotCQlpbnFzdHJjcHkgKGRldi0+c3VwcGxlbWVudF9hZGFwdGVyX2luZm8uQWRhcHRlclR5
cGVUZXh0LAotCQkgIHN0ci0+dmlkKTsgCi0JCSpjcCA9IGM7Ci0JCXdoaWxlICgqY3AgJiYgKmNw
ICE9ICcgJykKLQkJCSsrY3A7CisJCWludCBjOworCQlpZiAoKGNwWzBdID09ICdBJykgJiYgKGNw
WzFdID09ICdPJykgJiYgKGNwWzJdID09ICdDJykpCisJCQlpbnFzdHJjcHkoIlNNQyIsIHN0ci0+
dmlkKTsKKwkJZWxzZSB7CisJCQljID0gc2l6ZW9mKHN0ci0+dmlkKTsKKwkJCXdoaWxlICgqY3Ag
JiYgKmNwICE9ICcgJyAmJiAtLWMpCisJCQkJKytjcDsKKwkJCWMgPSAqY3A7CisJCQkqY3AgPSAn
XDAnOworCQkJaW5xc3RyY3B5IChkZXYtPnN1cHBsZW1lbnRfYWRhcHRlcl9pbmZvLkFkYXB0ZXJU
eXBlVGV4dCwKKwkJCSAgc3RyLT52aWQpOyAKKwkJCSpjcCA9IGM7CisJCQl3aGlsZSAoKmNwICYm
ICpjcCAhPSAnICcpCisJCQkJKytjcDsKKwkJfQogCQl3aGlsZSAoKmNwID09ICcgJykKIAkJCSsr
Y3A7CiAJCS8qIGxhc3Qgc2l4IGNoYXJzIHJlc2VydmVkIGZvciB2b2wgdHlwZSAqLwo=

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F437E44532ADPE2K703adapte_--
