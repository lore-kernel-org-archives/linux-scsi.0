From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: pci_set_dma_max_seg_size opened up for late
 model controllers
Date: Wed, 6 Feb 2008 09:00:46 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F439829BBB@ADPE2K703.adaptec.com>
References: <532ABFBDAAC3A34EB12EBA6CEC2838F4397D643D@ADPE2K703.adaptec.com>
	<20080205234912B.tomof@acm.org>
	<532ABFBDAAC3A34EB12EBA6CEC2838F4397D6932@ADPE2K703.adaptec.com>
 <20080206101148L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F439829BBBADPE2K703adapte_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:46051 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYBFRAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Feb 2008 12:00:49 -0500
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "tomof@acm.org" <tomof@acm.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, "James.Bottomley@steeleye.com" <James.Bottomley@steeleye.com>, "jeff@garzik.org" <jeff@garzik.org>, "jens.axboe@oracle.com" <jens.axboe@oracle.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F439829BBBADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This patch depends on 'RE: [patch 048/265] iommu sg merging: aacraid: use p=
ci_set_dma_max_seg_size' and ensures that the modern adapters get a maximum=
 sg segment size on par with the maximum transfer size. Added some localize=
d janitor fixes to the discussion patch I used with Fujita.

FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp] sez:
> I think that setting the proper maximum segment size for the late
> model cards (as you did above) makes sense.

This attached patch is against current linux-2.6. It will not apply to curr=
ent scsi-misc-2.6 without the above mentioned dependency.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments. Please use the attached file to patch

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/linit.c |   28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff -ru a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c      2008-02-06 11:35:55.111631591 -0500
+++ b/drivers/scsi/aacraid/linit.c      2008-02-06 11:52:11.095208736 -0500
@@ -1130,31 +1130,29 @@
        if (error < 0)
                goto out_deinit;

-       if (!(aac->adapter_info.options & AAC_OPT_NEW_COMM)) {
-               error =3D pci_set_dma_max_seg_size(pdev, 65536);
-               if (error)
-                       goto out_deinit;
-       }
-
        /*
         * Lets override negotiations and drop the maximum SG limit to 34
         */
        if ((aac_drivers[index].quirks & AAC_QUIRK_34SG) &&
-                       (aac->scsi_host_ptr->sg_tablesize > 34)) {
-               aac->scsi_host_ptr->sg_tablesize =3D 34;
-               aac->scsi_host_ptr->max_sectors
-                 =3D (aac->scsi_host_ptr->sg_tablesize * 8) + 112;
+                       (shost->sg_tablesize > 34)) {
+               shost->sg_tablesize =3D 34;
+               shost->max_sectors =3D (shost->sg_tablesize * 8) + 112;
        }

        if ((aac_drivers[index].quirks & AAC_QUIRK_17SG) &&
-                       (aac->scsi_host_ptr->sg_tablesize > 17)) {
-               aac->scsi_host_ptr->sg_tablesize =3D 17;
-               aac->scsi_host_ptr->max_sectors
-                 =3D (aac->scsi_host_ptr->sg_tablesize * 8) + 112;
+                       (shost->sg_tablesize > 17)) {
+               shost->sg_tablesize =3D 17;
+               shost->max_sectors =3D (shost->sg_tablesize * 8) + 112;
        }

+       error =3D pci_set_dma_max_seg_size(pdev,
+               (aac->adapter_info.options & AAC_OPT_NEW_COMM) ?
+                       (shost->max_sectors << 9) : 65536);
+       if (error)
+               goto out_deinit;
+
        /*
-        * Firware printf works only with older firmware.
+        * Firmware printf works only with older firmware.
         */
        if (aac_drivers[index].quirks & AAC_QUIRK_34SG)
                aac->printf_enabled =3D 1;



--_002_532ABFBDAAC3A34EB12EBA6CEC2838F439829BBBADPE2K703adapte_
Content-Type: application/octet-stream; name="aacraid_pci_set_dma.patch"
Content-Description: aacraid_pci_set_dma.patch
Content-Disposition: attachment; filename="aacraid_pci_set_dma.patch";
	size=1595; creation-date="Wed, 06 Feb 2008 08:52:44 GMT";
	modification-date="Wed, 06 Feb 2008 08:52:44 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDgtMDIt
MDYgMTE6MzU6NTUuMTExNjMxNTkxIC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwOC0wMi0wNiAxMTo1MjoxMS4wOTUyMDg3MzYgLTA1MDAKQEAgLTExMzAsMzEgKzEx
MzAsMjkgQEAKIAlpZiAoZXJyb3IgPCAwKQogCQlnb3RvIG91dF9kZWluaXQ7CiAKLQlpZiAoIShh
YWMtPmFkYXB0ZXJfaW5mby5vcHRpb25zICYgQUFDX09QVF9ORVdfQ09NTSkpIHsKLQkJZXJyb3Ig
PSBwY2lfc2V0X2RtYV9tYXhfc2VnX3NpemUocGRldiwgNjU1MzYpOwotCQlpZiAoZXJyb3IpCi0J
CQlnb3RvIG91dF9kZWluaXQ7Ci0JfQotCiAJLyoKICAJICogTGV0cyBvdmVycmlkZSBuZWdvdGlh
dGlvbnMgYW5kIGRyb3AgdGhlIG1heGltdW0gU0cgbGltaXQgdG8gMzQKICAJICovCiAJaWYgKChh
YWNfZHJpdmVyc1tpbmRleF0ucXVpcmtzICYgQUFDX1FVSVJLXzM0U0cpICYmCi0JCQkoYWFjLT5z
Y3NpX2hvc3RfcHRyLT5zZ190YWJsZXNpemUgPiAzNCkpIHsKLSAJCWFhYy0+c2NzaV9ob3N0X3B0
ci0+c2dfdGFibGVzaXplID0gMzQ7Ci0gCQlhYWMtPnNjc2lfaG9zdF9wdHItPm1heF9zZWN0b3Jz
Ci0gCQkgID0gKGFhYy0+c2NzaV9ob3N0X3B0ci0+c2dfdGFibGVzaXplICogOCkgKyAxMTI7CisJ
CQkoc2hvc3QtPnNnX3RhYmxlc2l6ZSA+IDM0KSkgeworIAkJc2hvc3QtPnNnX3RhYmxlc2l6ZSA9
IDM0OworIAkJc2hvc3QtPm1heF9zZWN0b3JzID0gKHNob3N0LT5zZ190YWJsZXNpemUgKiA4KSAr
IDExMjsKICAJfQogCiAgCWlmICgoYWFjX2RyaXZlcnNbaW5kZXhdLnF1aXJrcyAmIEFBQ19RVUlS
S18xN1NHKSAmJgotCQkJKGFhYy0+c2NzaV9ob3N0X3B0ci0+c2dfdGFibGVzaXplID4gMTcpKSB7
Ci0gCQlhYWMtPnNjc2lfaG9zdF9wdHItPnNnX3RhYmxlc2l6ZSA9IDE3OwotIAkJYWFjLT5zY3Np
X2hvc3RfcHRyLT5tYXhfc2VjdG9ycwotIAkJICA9IChhYWMtPnNjc2lfaG9zdF9wdHItPnNnX3Rh
Ymxlc2l6ZSAqIDgpICsgMTEyOworCQkJKHNob3N0LT5zZ190YWJsZXNpemUgPiAxNykpIHsKKyAJ
CXNob3N0LT5zZ190YWJsZXNpemUgPSAxNzsKKyAJCXNob3N0LT5tYXhfc2VjdG9ycyA9IChzaG9z
dC0+c2dfdGFibGVzaXplICogOCkgKyAxMTI7CiAgCX0KIAorCWVycm9yID0gcGNpX3NldF9kbWFf
bWF4X3NlZ19zaXplKHBkZXYsCisJCShhYWMtPmFkYXB0ZXJfaW5mby5vcHRpb25zICYgQUFDX09Q
VF9ORVdfQ09NTSkgPworIAkJCShzaG9zdC0+bWF4X3NlY3RvcnMgPDwgOSkgOiA2NTUzNik7CisJ
aWYgKGVycm9yKQorCQlnb3RvIG91dF9kZWluaXQ7CisKIAkvKgotCSAqIEZpcndhcmUgcHJpbnRm
IHdvcmtzIG9ubHkgd2l0aCBvbGRlciBmaXJtd2FyZS4KKwkgKiBGaXJtd2FyZSBwcmludGYgd29y
a3Mgb25seSB3aXRoIG9sZGVyIGZpcm13YXJlLgogCSAqLwogCWlmIChhYWNfZHJpdmVyc1tpbmRl
eF0ucXVpcmtzICYgQUFDX1FVSVJLXzM0U0cpCiAJCWFhYy0+cHJpbnRmX2VuYWJsZWQgPSAxOwo=

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F439829BBBADPE2K703adapte_--
