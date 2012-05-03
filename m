From: "Mahesh Rajashekhara" <Mahesh_Rajashekhara@pmc-sierra.com>
Subject: FW: [PATCH 1/1] aacraid: Fixes kernel oops in "aac_eh_abort"
Date: Wed, 2 May 2012 19:10:45 -0700
Message-ID: <340C71CD25A7EB49BFA81AE8C8392667189985FE@BBY1EXM10.pmc_nt.nt.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01CD28D1.F4A5B9F2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:37427 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753204Ab2ECC33 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2012 22:29:29 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Achim Leubner <Achim_Leubner@pmc-sierra.com>, Tony Ruiz <Tony_Ruiz@pmc-sierra.com>, Rich Bono <Rich_Bono@pmc-sierra.com>, aacraid@pmc-sierra.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01CD28D1.F4A5B9F2
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

It looks like the patch has not been included in the upstream kernel.
Please let us know your review comments.

Thanks,
Mahesh

-----Original Message-----
From: Mahesh Bagepalli Rajashekhara - ERS, HCL Tech
[mailto:maheshbr@hcl.com]=20
Sent: Thursday, March 08, 2012 5:13 PM
To: James.Bottomley@HansenPartnership.com
Cc: Achim Leubner; linux-scsi@vger.kernel.org; aacraid@pmc-sierra.com;
Tony Ruiz
Subject: [PATCH 1/1] aacraid: Fixes kernel oops in "aac_eh_abort"

Hi James,

This patch fixes the kernel oops in the error handler "aac_eh_abort"
function.

This attached patch is against current upstream kernel

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments (inline gets damaged, please use
attachment).

Signed-off-by: Mahesh Rajashekhara <aacraid@pmc-sierra.com>

---

drivers/scsi/aacraid/commsup.c |    1 +
drivers/scsi/aacraid/linit.c   |    2 +-
2 files changed, 2 insertions(+), 1 deletion(-)

diff -purN a/drivers/scsi/aacraid/commsup.c
b/drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c    2012-03-08 14:28:50.000000000
+0530
+++ b/drivers/scsi/aacraid/commsup.c    2012-03-08 14:31:51.000000000
+0530
@@ -136,6 +136,7 @@ int aac_fib_setup(struct aac_dev * dev)
                i < (dev->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB);
                i++, fibptr++)
        {
+               fibptr->flags =3D 0;
                fibptr->dev =3D dev;
                fibptr->hw_fib_va =3D hw_fib;
                fibptr->data =3D (void *) fibptr->hw_fib_va->data;
diff -purN a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c      2012-03-08 14:28:34.000000000
+0530
+++ b/drivers/scsi/aacraid/linit.c      2012-03-08 14:30:55.000000000
+0530
@@ -1157,7 +1157,7 @@ static int __devinit aac_probe_one(struc
        aac->cardtype =3D index;
        INIT_LIST_HEAD(&aac->entry);

-       aac->fibs =3D kmalloc(sizeof(struct fib) * (shost->can_queue +
AAC_NUM_MGT_FIB), GFP_KERNEL);
+       aac->fibs =3D kzalloc(sizeof(struct fib) * (shost->can_queue +
AAC_NUM_MGT_FIB), GFP_KERNEL);
        if (!aac->fibs)
                goto out_free_host;
        spin_lock_init(&aac->fib_lock);

::DISCLAIMER::
------------------------------------------------------------------------
-----------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and
intended for the named recipient(s) only.
It shall not attach any liability on the originator or HCL or its
affiliates. Any views or opinions presented in
this email are solely those of the author and may not necessarily
reflect the opinions of HCL or its affiliates.
Any form of reproduction, dissemination, copying, disclosure,
modification, distribution and / or publication of
this message without the prior written consent of the author of this
e-mail is strictly prohibited. If you have
received this email in error please delete it and notify the sender
immediately. Before opening any mail and
attachments please check them for viruses and defect.

------------------------------------------------------------------------
-----------------------------------------------

------_=_NextPart_001_01CD28D1.F4A5B9F2
Content-Type: application/octet-stream;
	name="aac-kernel-oops-fix.patch"
Content-Transfer-Encoding: base64
Content-Description: aac-kernel-oops-fix.patch
Content-Disposition: attachment;
	filename="aac-kernel-oops-fix.patch"

ZHJpdmVycy9zY3NpL2FhY3JhaWQvY29tbXN1cC5jIHwgICAgMSArCmRyaXZlcnMvc2NzaS9hYWNy
YWlkL2xpbml0LmMgICB8ICAgIDIgKy0KMiBmaWxlcyBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyks
IDEgZGVsZXRpb24oLSkKCmRpZmYgLXB1ck4gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tc3Vw
LmMgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tc3VwLmMKLS0tIGEvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvY29tbXN1cC5jCTIwMTItMDMtMDggMTQ6Mjg6NTAuMDAwMDAwMDAwICswNTMwCisrKyBi
L2RyaXZlcnMvc2NzaS9hYWNyYWlkL2NvbW1zdXAuYwkyMDEyLTAzLTA4IDE0OjMxOjUxLjAwMDAw
MDAwMCArMDUzMApAQCAtMTM2LDYgKzEzNiw3IEBAIGludCBhYWNfZmliX3NldHVwKHN0cnVjdCBh
YWNfZGV2ICogZGV2KQogCQlpIDwgKGRldi0+c2NzaV9ob3N0X3B0ci0+Y2FuX3F1ZXVlICsgQUFD
X05VTV9NR1RfRklCKTsKIAkJaSsrLCBmaWJwdHIrKykKIAl7CisJCWZpYnB0ci0+ZmxhZ3MgPSAw
OwogCQlmaWJwdHItPmRldiA9IGRldjsKIAkJZmlicHRyLT5od19maWJfdmEgPSBod19maWI7CiAJ
CWZpYnB0ci0+ZGF0YSA9ICh2b2lkICopIGZpYnB0ci0+aHdfZmliX3ZhLT5kYXRhOwpkaWZmIC1w
dXJOIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvbGluaXQuYyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2xpbml0LmMKLS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvbGluaXQuYwkyMDEyLTAzLTA4IDE0
OjI4OjM0LjAwMDAwMDAwMCArMDUzMAorKysgYi9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5j
CTIwMTItMDMtMDggMTQ6MzA6NTUuMDAwMDAwMDAwICswNTMwCkBAIC0xMTU3LDcgKzExNTcsNyBA
QCBzdGF0aWMgaW50IF9fZGV2aW5pdCBhYWNfcHJvYmVfb25lKHN0cnVjCiAJYWFjLT5jYXJkdHlw
ZSA9IGluZGV4OwogCUlOSVRfTElTVF9IRUFEKCZhYWMtPmVudHJ5KTsKIAotCWFhYy0+ZmlicyA9
IGttYWxsb2Moc2l6ZW9mKHN0cnVjdCBmaWIpICogKHNob3N0LT5jYW5fcXVldWUgKyBBQUNfTlVN
X01HVF9GSUIpLCBHRlBfS0VSTkVMKTsKKwlhYWMtPmZpYnMgPSBremFsbG9jKHNpemVvZihzdHJ1
Y3QgZmliKSAqIChzaG9zdC0+Y2FuX3F1ZXVlICsgQUFDX05VTV9NR1RfRklCKSwgR0ZQX0tFUk5F
TCk7CiAJaWYgKCFhYWMtPmZpYnMpCiAJCWdvdG8gb3V0X2ZyZWVfaG9zdDsKIAlzcGluX2xvY2tf
aW5pdCgmYWFjLT5maWJfbG9jayk7Cg==

------_=_NextPart_001_01CD28D1.F4A5B9F2--
