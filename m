From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
Subject: [PATCH 1/1] aacraid: informational sysfs value corrections
Date: Fri, 8 Feb 2008 09:01:34 -0800
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F4398D83F6@ADPE2K703.adaptec.com>
References: <532ABFBDAAC3A34EB12EBA6CEC2838F4397D643D@ADPE2K703.adaptec.com>
	 <20080205234912B.tomof@acm.org>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F4397D6932@ADPE2K703.adaptec.com>
	 <20080206101148L.fujita.tomonori@lab.ntt.co.jp>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F439829BBB@ADPE2K703.adaptec.com>
	 <1202320497.3112.92.camel@localhost.localdomain>
	 <532ABFBDAAC3A34EB12EBA6CEC2838F43982A010@ADPE2K703.adaptec.com>
 <1202430634.3171.41.camel@localhost.localdomain>
 <532ABFBDAAC3A34EB12EBA6CEC2838F4398716E3@ADPE2K703.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_532ABFBDAAC3A34EB12EBA6CEC2838F4398D83F6ADPE2K703adapte_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:41114 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763012AbYBHRBg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 12:01:36 -0500
Received: from ADPE2K701.adaptec.com (adaptecpop.adaptec.com [10.25.8.25])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 19595250095
	for <linux-scsi@vger.kernel.org>; Fri,  8 Feb 2008 09:01:36 -0800 (PST)
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F4398D83F6ADPE2K703adapte_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Some sysfs problems reported. The serial number on late model controllers w=
as truncated. Non-DASD devices (tapes and CDROMs) were showing up as JBOD i=
n the level report on the physical channel.

This attached patch is against current scsi-misc-2.6.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's hand=
ling of patch attachments (inline gets damaged, please use attachment).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/linit.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff -ru a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
--- a/drivers/scsi/aacraid/linit.c      2008-02-08 11:22:43.497295473 -0500
+++ b/drivers/scsi/aacraid/linit.c      2008-02-08 11:51:52.376880890 -0500
@@ -494,13 +494,14 @@

 static ssize_t aac_show_raid_level(struct device *dev, struct device_attri=
bute
*attr, char *buf)
 {
-       struct scsi_device * sdev =3D to_scsi_device(dev);
+       struct scsi_device *sdev =3D to_scsi_device(dev);
+       struct aac_dev *aac =3D (struct aac_dev *)(sdev->host->hostdata);
        if (sdev_channel(sdev) !=3D CONTAINER_CHANNEL)
                return snprintf(buf, PAGE_SIZE, sdev->no_uld_attach
-                 ? "Hidden\n" : "JBOD");
+                 ? "Hidden\n" :
+                 ((aac->jbod && (sdev->type =3D=3D TYPE_DISK)) ? "JBOD\n" =
: ""));
        return snprintf(buf, PAGE_SIZE, "%s\n",
-         get_container_type(((struct aac_dev *)(sdev->host->hostdata))
-           ->fsa_dev[sdev_id(sdev)].type));
+         get_container_type(aac->fsa_dev[sdev_id(sdev)].type));
 }

 static struct device_attribute aac_raid_level_attr =3D {
@@ -860,8 +861,8 @@
                  le32_to_cpu(dev->adapter_info.serial[0]));
        if (len &&
          !memcmp(&dev->supplement_adapter_info.MfgPcbaSerialNo[
-           sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo)+2-len],
-         buf, len))
+           sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo)-len],
+         buf, len-1))
                len =3D snprintf(buf, PAGE_SIZE, "%.*s\n",
                  (int)sizeof(dev->supplement_adapter_info.MfgPcbaSerialNo)=
,
                  dev->supplement_adapter_info.MfgPcbaSerialNo);

Sincerely - Mark Salyzyn

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F4398D83F6ADPE2K703adapte_
Content-Type: application/octet-stream;
	name="aacraid_serial_level_sysfs.patch"
Content-Description: aacraid_serial_level_sysfs.patch
Content-Disposition: attachment;
	filename="aacraid_serial_level_sysfs.patch"; size=1453;
	creation-date="Fri, 08 Feb 2008 08:52:44 GMT";
	modification-date="Fri, 08 Feb 2008 08:52:44 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDgtMDIt
MDggMTE6MjI6NDMuNDk3Mjk1NDczIC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwOC0wMi0wOCAxMTo1MTo1Mi4zNzY4ODA4OTAgLTA1MDAKQEAgLTQ5NCwxMyArNDk0
LDE0IEBACiAKIHN0YXRpYyBzc2l6ZV90IGFhY19zaG93X3JhaWRfbGV2ZWwoc3RydWN0IGRldmlj
ZSAqZGV2LCBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQogewotCXN0
cnVjdCBzY3NpX2RldmljZSAqIHNkZXYgPSB0b19zY3NpX2RldmljZShkZXYpOworCXN0cnVjdCBz
Y3NpX2RldmljZSAqc2RldiA9IHRvX3Njc2lfZGV2aWNlKGRldik7CisJc3RydWN0IGFhY19kZXYg
KmFhYyA9IChzdHJ1Y3QgYWFjX2RldiAqKShzZGV2LT5ob3N0LT5ob3N0ZGF0YSk7CiAJaWYgKHNk
ZXZfY2hhbm5lbChzZGV2KSAhPSBDT05UQUlORVJfQ0hBTk5FTCkKIAkJcmV0dXJuIHNucHJpbnRm
KGJ1ZiwgUEFHRV9TSVpFLCBzZGV2LT5ub191bGRfYXR0YWNoCi0JCSAgPyAiSGlkZGVuXG4iIDog
IkpCT0QiKTsKKwkJICA/ICJIaWRkZW5cbiIgOgorCQkgICgoYWFjLT5qYm9kICYmIChzZGV2LT50
eXBlID09IFRZUEVfRElTSykpID8gIkpCT0RcbiIgOiAiIikpOwogCXJldHVybiBzbnByaW50Zihi
dWYsIFBBR0VfU0laRSwgIiVzXG4iLAotCSAgZ2V0X2NvbnRhaW5lcl90eXBlKCgoc3RydWN0IGFh
Y19kZXYgKikoc2Rldi0+aG9zdC0+aG9zdGRhdGEpKQotCSAgICAtPmZzYV9kZXZbc2Rldl9pZChz
ZGV2KV0udHlwZSkpOworCSAgZ2V0X2NvbnRhaW5lcl90eXBlKGFhYy0+ZnNhX2RldltzZGV2X2lk
KHNkZXYpXS50eXBlKSk7CiB9CiAKIHN0YXRpYyBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSBhYWNf
cmFpZF9sZXZlbF9hdHRyID0gewpAQCAtODYwLDggKzg2MSw4IEBACiAJCSAgbGUzMl90b19jcHUo
ZGV2LT5hZGFwdGVyX2luZm8uc2VyaWFsWzBdKSk7CiAJaWYgKGxlbiAmJgogCSAgIW1lbWNtcCgm
ZGV2LT5zdXBwbGVtZW50X2FkYXB0ZXJfaW5mby5NZmdQY2JhU2VyaWFsTm9bCi0JICAgIHNpemVv
ZihkZXYtPnN1cHBsZW1lbnRfYWRhcHRlcl9pbmZvLk1mZ1BjYmFTZXJpYWxObykrMi1sZW5dLAot
CSAgYnVmLCBsZW4pKQorCSAgICBzaXplb2YoZGV2LT5zdXBwbGVtZW50X2FkYXB0ZXJfaW5mby5N
ZmdQY2JhU2VyaWFsTm8pLWxlbl0sCisJICBidWYsIGxlbi0xKSkKIAkJbGVuID0gc25wcmludGYo
YnVmLCBQQUdFX1NJWkUsICIlLipzXG4iLAogCQkgIChpbnQpc2l6ZW9mKGRldi0+c3VwcGxlbWVu
dF9hZGFwdGVyX2luZm8uTWZnUGNiYVNlcmlhbE5vKSwKIAkJICBkZXYtPnN1cHBsZW1lbnRfYWRh
cHRlcl9pbmZvLk1mZ1BjYmFTZXJpYWxObyk7Cg==

--_002_532ABFBDAAC3A34EB12EBA6CEC2838F4398D83F6ADPE2K703adapte_--
