From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: incorrect dma mapping mask during blinkled recover or user initiated reset
Date: Tue, 17 Jul 2007 11:15:08 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5D41@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5D2E@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7C885.43509012"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:51456 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762530AbXGQPPN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 11:15:13 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id DBD8E1922F9
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2007 08:15:11 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01BF5D2E@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7C885.43509012
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Incorrect dma mask was used for blinkled (firmware assert) recovery or
user initiated reset during initialization portion. Ensure that all
callers of aac_fib_map_free null out the fib allocation references to
prevent multiple free. Although serious sounding, no reports of these
problems have surfaced...

This attached patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/commsup.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)
=20
Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C7C885.43509012
Content-Type: application/octet-stream;
	name="aacraid_mapping_failure.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_mapping_failure.patch
Content-Disposition: attachment;
	filename="aacraid_mapping_failure.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9jb21tc3VwLmMgYi9kcml2ZXJzL3Njc2kv
YWFjcmFpZC9jb21tc3VwLmMKLS0tIGEvZHJpdmVycy9zY3NpL2FhY3JhaWQvY29tbXN1cC5jCTIw
MDctMDctMTcgMTA6NTI6NTAuNDA3MjI5NDI0IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNy
YWlkL2NvbW1zdXAuYwkyMDA3LTA3LTE3IDExOjA0OjAwLjAzMzc3NjUxNCAtMDQwMApAQCAtODAs
NyArODAsMTEgQEAKIAogdm9pZCBhYWNfZmliX21hcF9mcmVlKHN0cnVjdCBhYWNfZGV2ICpkZXYp
CiB7Ci0JcGNpX2ZyZWVfY29uc2lzdGVudChkZXYtPnBkZXYsIGRldi0+bWF4X2ZpYl9zaXplICog
KGRldi0+c2NzaV9ob3N0X3B0ci0+Y2FuX3F1ZXVlICsgQUFDX05VTV9NR1RfRklCKSwgZGV2LT5o
d19maWJfdmEsIGRldi0+aHdfZmliX3BhKTsKKwlwY2lfZnJlZV9jb25zaXN0ZW50KGRldi0+cGRl
diwKKwkgIGRldi0+bWF4X2ZpYl9zaXplICogKGRldi0+c2NzaV9ob3N0X3B0ci0+Y2FuX3F1ZXVl
ICsgQUFDX05VTV9NR1RfRklCKSwKKwkgIGRldi0+aHdfZmliX3ZhLCBkZXYtPmh3X2ZpYl9wYSk7
CisJZGV2LT5od19maWJfdmEgPSBOVUxMOworCWRldi0+aHdfZmliX3BhID0gMDsKIH0KIAogLyoq
CkBAIC0xMDg3LDggKzEwOTEsNiBAQAogCSAqIGNhc2UuCiAJICovCiAJYWFjX2ZpYl9tYXBfZnJl
ZShhYWMpOwotCWFhYy0+aHdfZmliX3ZhID0gTlVMTDsKLQlhYWMtPmh3X2ZpYl9wYSA9IDA7CiAJ
cGNpX2ZyZWVfY29uc2lzdGVudChhYWMtPnBkZXYsIGFhYy0+Y29tbV9zaXplLCBhYWMtPmNvbW1f
YWRkciwgYWFjLT5jb21tX3BoeXMpOwogCWFhYy0+Y29tbV9hZGRyID0gTlVMTDsKIAlhYWMtPmNv
bW1fcGh5cyA9IDA7CkBAIC0xMDk4LDEyICsxMTAwLDEyIEBACiAJa2ZyZWUoYWFjLT5mc2FfZGV2
KTsKIAlhYWMtPmZzYV9kZXYgPSBOVUxMOwogCWlmIChhYWNfZ2V0X2RyaXZlcl9pZGVudChpbmRl
eCktPnF1aXJrcyAmIEFBQ19RVUlSS18zMUJJVCkgewotCQlpZiAoKChyZXR2YWwgPSBwY2lfc2V0
X2RtYV9tYXNrKGFhYy0+cGRldiwgRE1BXzMyQklUX01BU0spKSkgfHwKLQkJICAoKHJldHZhbCA9
IHBjaV9zZXRfY29uc2lzdGVudF9kbWFfbWFzayhhYWMtPnBkZXYsIERNQV8zMkJJVF9NQVNLKSkp
KQorCQlpZiAoKChyZXR2YWwgPSBwY2lfc2V0X2RtYV9tYXNrKGFhYy0+cGRldiwgRE1BXzMxQklU
X01BU0spKSkgfHwKKwkJICAoKHJldHZhbCA9IHBjaV9zZXRfY29uc2lzdGVudF9kbWFfbWFzayhh
YWMtPnBkZXYsIERNQV8zMUJJVF9NQVNLKSkpKQogCQkJZ290byBvdXQ7CiAJfSBlbHNlIHsKLQkJ
aWYgKCgocmV0dmFsID0gcGNpX3NldF9kbWFfbWFzayhhYWMtPnBkZXYsIDB4N0ZGRkZGRkZVTEwp
KSkgfHwKLQkJICAoKHJldHZhbCA9IHBjaV9zZXRfY29uc2lzdGVudF9kbWFfbWFzayhhYWMtPnBk
ZXYsIDB4N0ZGRkZGRkZVTEwpKSkpCisJCWlmICgoKHJldHZhbCA9IHBjaV9zZXRfZG1hX21hc2so
YWFjLT5wZGV2LCBETUFfMzJCSVRfTUFTSykpKSB8fAorCQkgICgocmV0dmFsID0gcGNpX3NldF9j
b25zaXN0ZW50X2RtYV9tYXNrKGFhYy0+cGRldiwgRE1BXzMyQklUX01BU0spKSkpCiAJCQlnb3Rv
IG91dDsKIAl9CiAJaWYgKChyZXR2YWwgPSAoKihhYWNfZ2V0X2RyaXZlcl9pZGVudChpbmRleCkt
PmluaXQpKShhYWMpKSkK

------_=_NextPart_001_01C7C885.43509012--
