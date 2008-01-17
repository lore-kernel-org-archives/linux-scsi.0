From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/2] aacraid: driver features flags
Date: Thu, 17 Jan 2008 09:24:56 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F43911ED66@ADPE2K703.adaptec.com>
References: <457feffcfc40101ad9884914d8f223cd425ee5b6.tomof@acm.org>
 <a789287f8ac2eef0d95c6cbb08f68c122b5f7ec4.tomof@acm.org>
 <532ABFBDAAC3A34EB12EBA6CEC2838F438AEA880@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F438E4653A@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F439065895@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F43911ED66ADPE2K703adapte_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:36962 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbYAQR1J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jan 2008 12:27:09 -0500
Received: from ADPE2K702.adaptec.com (adpe2k702.adaptec.com [10.25.8.26])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id ECEDF24C051
	for <linux-scsi@vger.kernel.org>; Thu, 17 Jan 2008 09:24:58 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F439065895@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F43911ED66ADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Feature enhancement, adding a 'flags' entry that will reside in the host co=
ntroller's tree, with a newline separated list of arbitrary ascii named fea=
tures that indicate whether the combination of driver and controller has su=
pport for said feature. Breaking from the one-line output typical of sysfs =
entries, newline was added to tailor for grep, or simple gets line by line =
string match within an application. I added one for a compiler time check f=
or existence of debug print output, one for an optional manifest defined en=
hanced status reporting in the logs, and one for runtime reporting whether =
the controller and driver supports arrays larger than 2TB. Adaptec's storag=
e management software uses the last flag to determine whether to make avail=
able the creation of arrays larger than 2TB, otherwise a warning is posted.

We report that this is the first patch in a set of two, but this one can st=
and alone without depending on the other. The second patch is the addition =
of a new adapter type that depend on this patch.

This following patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments, so one can NOT use the following in-line to patc=
h, please use the attached file.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/linit.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff -ru a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c      2008-01-17 11:45:34.283650215 -0500
+++ b/drivers/scsi/aacraid/linit.c      2008-01-17 11:56:14.302728941 -0500
@@ -790,6 +790,23 @@
        return len;
 }

+static ssize_t aac_show_flags(struct class_device *class_dev, char *buf)
+{
+       int len =3D 0;
+       struct aac_dev *dev =3D (struct aac_dev*)class_to_shost(class_dev)-=
>hostda
ta;
+
+       if (nblank(dprintk(x)))
+               len =3D snprintf(buf, PAGE_SIZE, "dprintk\n");
+#ifdef AAC_DETAILED_STATUS_INFO
+       len +=3D snprintf(buf + len, PAGE_SIZE - len,
+                       "AAC_DETAILED_STATUS_INFO\n");
+#endif
+       if (dev->raw_io_interface && dev->raw_io_64)
+               len +=3D snprintf(buf + len, PAGE_SIZE - len,
+                               "SAI_READ_CAPACITY_16\n");
+       return len;
+}
+
 static ssize_t aac_show_kernel_version(struct class_device *class_dev,
                char *buf)
 {
@@ -899,6 +916,13 @@
        },
        .show =3D aac_show_vendor,
 };
+static struct class_device_attribute aac_flags =3D {
+       .attr =3D {
+               .name =3D "flags",
+               .mode =3D S_IRUGO,
+       },
+       .show =3D aac_show_flags,
+};
 static struct class_device_attribute aac_kernel_version =3D {
        .attr =3D {
                .name =3D "hba_kernel_version",
@@ -953,6 +977,7 @@
 static struct class_device_attribute *aac_attrs[] =3D {
        &aac_model,
        &aac_vendor,
+       &aac_flags,
        &aac_kernel_version,
        &aac_monitor_version,
        &aac_bios_version,

Sincerely -- Mark Salyzyn

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F43911ED66ADPE2K703adapte_
Content-Type: application/octet-stream; name="aacraid_sysfs_flags.patch"
Content-Description: aacraid_sysfs_flags.patch
Content-Disposition: attachment; filename="aacraid_sysfs_flags.patch";
	size=1343; creation-date="Thu, 17 Jan 2008 08:57:31 GMT";
	modification-date="Thu, 17 Jan 2008 08:57:31 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDgtMDEt
MTcgMTE6NDU6MzQuMjgzNjUwMjE1IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwOC0wMS0xNyAxMTo1NjoxNC4zMDI3Mjg5NDEgLTA1MDAKQEAgLTc5MCw2ICs3OTAs
MjMgQEAKIAlyZXR1cm4gbGVuOwogfQogCitzdGF0aWMgc3NpemVfdCBhYWNfc2hvd19mbGFncyhz
dHJ1Y3QgY2xhc3NfZGV2aWNlICpjbGFzc19kZXYsIGNoYXIgKmJ1ZikKK3sKKwlpbnQgbGVuID0g
MDsKKwlzdHJ1Y3QgYWFjX2RldiAqZGV2ID0gKHN0cnVjdCBhYWNfZGV2KiljbGFzc190b19zaG9z
dChjbGFzc19kZXYpLT5ob3N0ZGF0YTsKKworCWlmIChuYmxhbmsoZHByaW50ayh4KSkpCisJCWxl
biA9IHNucHJpbnRmKGJ1ZiwgUEFHRV9TSVpFLCAiZHByaW50a1xuIik7CisjaWZkZWYgQUFDX0RF
VEFJTEVEX1NUQVRVU19JTkZPCisJbGVuICs9IHNucHJpbnRmKGJ1ZiArIGxlbiwgUEFHRV9TSVpF
IC0gbGVuLAorCQkJIkFBQ19ERVRBSUxFRF9TVEFUVVNfSU5GT1xuIik7CisjZW5kaWYKKwlpZiAo
ZGV2LT5yYXdfaW9faW50ZXJmYWNlICYmIGRldi0+cmF3X2lvXzY0KQorCQlsZW4gKz0gc25wcmlu
dGYoYnVmICsgbGVuLCBQQUdFX1NJWkUgLSBsZW4sCisJCQkJIlNBSV9SRUFEX0NBUEFDSVRZXzE2
XG4iKTsKKwlyZXR1cm4gbGVuOworfQorCiBzdGF0aWMgc3NpemVfdCBhYWNfc2hvd19rZXJuZWxf
dmVyc2lvbihzdHJ1Y3QgY2xhc3NfZGV2aWNlICpjbGFzc19kZXYsCiAJCWNoYXIgKmJ1ZikKIHsK
QEAgLTg5OSw2ICs5MTYsMTMgQEAKIAl9LAogCS5zaG93ID0gYWFjX3Nob3dfdmVuZG9yLAogfTsK
K3N0YXRpYyBzdHJ1Y3QgY2xhc3NfZGV2aWNlX2F0dHJpYnV0ZSBhYWNfZmxhZ3MgPSB7CisJLmF0
dHIgPSB7CisJCS5uYW1lID0gImZsYWdzIiwKKwkJLm1vZGUgPSBTX0lSVUdPLAorCX0sCisJLnNo
b3cgPSBhYWNfc2hvd19mbGFncywKK307CiBzdGF0aWMgc3RydWN0IGNsYXNzX2RldmljZV9hdHRy
aWJ1dGUgYWFjX2tlcm5lbF92ZXJzaW9uID0gewogCS5hdHRyID0gewogCQkubmFtZSA9ICJoYmFf
a2VybmVsX3ZlcnNpb24iLApAQCAtOTUzLDYgKzk3Nyw3IEBACiBzdGF0aWMgc3RydWN0IGNsYXNz
X2RldmljZV9hdHRyaWJ1dGUgKmFhY19hdHRyc1tdID0gewogCSZhYWNfbW9kZWwsCiAJJmFhY192
ZW5kb3IsCisJJmFhY19mbGFncywKIAkmYWFjX2tlcm5lbF92ZXJzaW9uLAogCSZhYWNfbW9uaXRv
cl92ZXJzaW9uLAogCSZhYWNfYmlvc192ZXJzaW9uLAo=

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F43911ED66ADPE2K703adapte_--
