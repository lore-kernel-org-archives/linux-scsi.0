From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: improve queue balancing
Date: Tue, 8 Jan 2008 14:07:57 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F40DC6C9@ADPE2K703.adaptec.com>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au><20071101173221.2e1fea42.sfr@canb.auug.org.au>
 <jefxzqqeha.fsf@sykes.suse.de>
 <AE4F746F2AECFC4DA4AADD66A1DFEF01F95EF7@otce2k301.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE734@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE735@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE736@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE738@ADPE2K703.adaptec.com>
 <532ABFBDAAC3A34EB12EBA6CEC2838F40FE739@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC6C9ADPE2K703adaptecc_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:48134 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbYAHWIB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jan 2008 17:08:01 -0500
Received: from ADPE2K701.adaptec.com (adpe2k701.adaptec.com [10.25.8.25])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id BDF702215EC
	for <linux-scsi@vger.kernel.org>; Tue,  8 Jan 2008 14:08:00 -0800 (PST)
In-Reply-To: <532ABFBDAAC3A34EB12EBA6CEC2838F40FE739@ADPE2K703.adaptec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC6C9ADPE2K703adaptecc_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

The adapter queue is divided up equally to all the arrays to prevent comman=
d starvation to any individual array. On the other hand, physical targets a=
re only granted a queue depth of one each. The code prior to this patch use=
d to deal with the incremental discovery of targets, but the driver knows h=
ow many arrays are present prior to the scan so this knowledge is used to g=
enerate a better estimate for the queue depth.

Remove the capability of 'physical=3D0' from preventing access to the class=
 of adapters that have the RAID/SCSI mode of operation since none of the ph=
ysicals on the SCSI channel are candidates ever for an array.

As always, the user can override this default queue depth policy by making =
the appropriate adjustments utilizing sysfs.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments (inline gets damaged, use attachment).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/linit.c |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/drivers/scsi/aacraid/linit.c      2008-01-08 16:38:32.783320829 -0500
+++ b/drivers/scsi/aacraid/linit.c      2008-01-08 16:55:07.805050564 -0500
@@ -401,16 +401,14 @@

 static int aac_slave_configure(struct scsi_device *sdev)
 {
+       struct aac_dev *aac =3D (struct aac_dev *)sdev->host->hostdata;
        if ((sdev->type =3D=3D TYPE_DISK) &&
-                       (sdev_channel(sdev) !=3D CONTAINER_CHANNEL)) {
+                       (sdev_channel(sdev) !=3D CONTAINER_CHANNEL) &&
+                       (!aac->raid_scsi_mode || (sdev_channel(sdev) !=3D 2=
))) {
                if (expose_physicals =3D=3D 0)
                        return -ENXIO;
-               if (expose_physicals < 0) {
-                       struct aac_dev *aac =3D
-                               (struct aac_dev *)sdev->host->hostdata;
-                       if (!aac->raid_scsi_mode || (sdev_channel(sdev) !=
=3D 2))
-                               sdev->no_uld_attach =3D 1;
-               }
+               if (expose_physicals < 0)
+                       sdev->no_uld_attach =3D 1;
        }
        if (sdev->tagged_supported && (sdev->type =3D=3D TYPE_DISK) &&
                        (sdev_channel(sdev) =3D=3D CONTAINER_CHANNEL)) {
@@ -419,6 +417,7 @@
                unsigned num_lsu =3D 0;
                unsigned num_one =3D 0;
                unsigned depth;
+               unsigned cid;

                /*
                 * Firmware has an individual device recovery time typicall=
y
@@ -426,11 +425,15 @@
                 */
                if (sdev->timeout < (45 * HZ))
                        sdev->timeout =3D 45 * HZ;
+               for (cid =3D 0; cid < aac->maximum_num_containers; ++cid)
+                       if (aac->fsa_dev[cid].valid)
+                               ++num_lsu;
                __shost_for_each_device(dev, host) {
                        if (dev->tagged_supported && (dev->type =3D=3D TYPE=
_DISK) &&

-                               (sdev_channel(dev) =3D=3D CONTAINER_CHANNEL=
))
-                               ++num_lsu;
-                       else
+                               (sdev_channel(dev) =3D=3D CONTAINER_CHANNEL=
)) {
+                               if (!aac->fsa_dev[sdev_id(dev)].valid)
+                                       ++num_lsu;
+                       } else
                                ++num_one;
                }
                if (num_lsu =3D=3D 0)

Sincerely -- Mark Salyzyn

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC6C9ADPE2K703adaptecc_
Content-Type: application/octet-stream; name="aacraid_queue_depth.patch"
Content-Description: aacraid_queue_depth.patch
Content-Disposition: attachment; filename="aacraid_queue_depth.patch";
	size=1685; creation-date="Tue, 08 Jan 2008 13:55:42 GMT";
	modification-date="Tue, 08 Jan 2008 13:55:42 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDgtMDEt
MDggMTY6Mzg6MzIuNzgzMzIwODI5IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwOC0wMS0wOCAxNjo1NTowNy44MDUwNTA1NjQgLTA1MDAKQEAgLTQwMSwxNiArNDAx
LDE0IEBACiAKIHN0YXRpYyBpbnQgYWFjX3NsYXZlX2NvbmZpZ3VyZShzdHJ1Y3Qgc2NzaV9kZXZp
Y2UgKnNkZXYpCiB7CisJc3RydWN0IGFhY19kZXYgKmFhYyA9IChzdHJ1Y3QgYWFjX2RldiAqKXNk
ZXYtPmhvc3QtPmhvc3RkYXRhOwogCWlmICgoc2Rldi0+dHlwZSA9PSBUWVBFX0RJU0spICYmCi0J
CQkoc2Rldl9jaGFubmVsKHNkZXYpICE9IENPTlRBSU5FUl9DSEFOTkVMKSkgeworCQkJKHNkZXZf
Y2hhbm5lbChzZGV2KSAhPSBDT05UQUlORVJfQ0hBTk5FTCkgJiYKKwkJCSghYWFjLT5yYWlkX3Nj
c2lfbW9kZSB8fCAoc2Rldl9jaGFubmVsKHNkZXYpICE9IDIpKSkgewogCQlpZiAoZXhwb3NlX3Bo
eXNpY2FscyA9PSAwKQogCQkJcmV0dXJuIC1FTlhJTzsKLQkJaWYgKGV4cG9zZV9waHlzaWNhbHMg
PCAwKSB7Ci0JCQlzdHJ1Y3QgYWFjX2RldiAqYWFjID0KLQkJCQkoc3RydWN0IGFhY19kZXYgKilz
ZGV2LT5ob3N0LT5ob3N0ZGF0YTsKLQkJCWlmICghYWFjLT5yYWlkX3Njc2lfbW9kZSB8fCAoc2Rl
dl9jaGFubmVsKHNkZXYpICE9IDIpKQotCQkJCXNkZXYtPm5vX3VsZF9hdHRhY2ggPSAxOwotCQl9
CisJCWlmIChleHBvc2VfcGh5c2ljYWxzIDwgMCkKKwkJCXNkZXYtPm5vX3VsZF9hdHRhY2ggPSAx
OwogCX0KIAlpZiAoc2Rldi0+dGFnZ2VkX3N1cHBvcnRlZCAmJiAoc2Rldi0+dHlwZSA9PSBUWVBF
X0RJU0spICYmCiAJCQkoc2Rldl9jaGFubmVsKHNkZXYpID09IENPTlRBSU5FUl9DSEFOTkVMKSkg
ewpAQCAtNDE5LDYgKzQxNyw3IEBACiAJCXVuc2lnbmVkIG51bV9sc3UgPSAwOwogCQl1bnNpZ25l
ZCBudW1fb25lID0gMDsKIAkJdW5zaWduZWQgZGVwdGg7CisJCXVuc2lnbmVkIGNpZDsKIAogCQkv
KgogCQkgKiBGaXJtd2FyZSBoYXMgYW4gaW5kaXZpZHVhbCBkZXZpY2UgcmVjb3ZlcnkgdGltZSB0
eXBpY2FsbHkKQEAgLTQyNiwxMSArNDI1LDE1IEBACiAJCSAqLwogCQlpZiAoc2Rldi0+dGltZW91
dCA8ICg0NSAqIEhaKSkKIAkJCXNkZXYtPnRpbWVvdXQgPSA0NSAqIEhaOworCQlmb3IgKGNpZCA9
IDA7IGNpZCA8IGFhYy0+bWF4aW11bV9udW1fY29udGFpbmVyczsgKytjaWQpCisJCQlpZiAoYWFj
LT5mc2FfZGV2W2NpZF0udmFsaWQpCisJCQkJKytudW1fbHN1OwogCQlfX3Nob3N0X2Zvcl9lYWNo
X2RldmljZShkZXYsIGhvc3QpIHsKIAkJCWlmIChkZXYtPnRhZ2dlZF9zdXBwb3J0ZWQgJiYgKGRl
di0+dHlwZSA9PSBUWVBFX0RJU0spICYmCi0JCQkJKHNkZXZfY2hhbm5lbChkZXYpID09IENPTlRB
SU5FUl9DSEFOTkVMKSkKLQkJCQkrK251bV9sc3U7Ci0JCQllbHNlCisJCQkJKHNkZXZfY2hhbm5l
bChkZXYpID09IENPTlRBSU5FUl9DSEFOTkVMKSkgeworCQkJCWlmICghYWFjLT5mc2FfZGV2W3Nk
ZXZfaWQoZGV2KV0udmFsaWQpCisJCQkJCSsrbnVtX2xzdTsKKwkJCX0gZWxzZQogCQkJCSsrbnVt
X29uZTsKIAkJfQogCQlpZiAobnVtX2xzdSA9PSAwKQo=

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F40DC6C9ADPE2K703adaptecc_--
