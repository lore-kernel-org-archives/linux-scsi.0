From: "Dailey, Nate" <Nate.Dailey@stratus.com>
Subject: [PATCH] drivers/scsi/sg.c: fix problems when sg_remove is called  before sg_release
Date: Fri, 23 Sep 2005 14:03:03 -0400
Message-ID: <92952AEF1F064042B6EF2522E0EEF437024334A5@EXNA.corp.stratus.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C5C069.0AB25FD5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.17]:41651 "EHLO
	mailhub4.stratus.com") by vger.kernel.org with ESMTP
	id S1750936AbVIWSDO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Sep 2005 14:03:14 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C5C069.0AB25FD5
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

This is a re-submission of a patch I sent to the linux-scsi mailing list
several months back
(http://marc.theaimsgroup.com/?l=3Dlinux-scsi&m=3D111290555013699&w=3D2).=



In summary, the patch fixes:

1. an oops in sg_remove, if it's called when the device has been opened,
which occurs because the sg_dev_arr_lock is dropped too soon and
sg_remove_sfp frees the sdp before sg_remove is done with it.

2. a case in sg_remove_sfp where a reference isn't dropped, but should
be.


I found a problem with my original patch... I was calling
scsi_device_put (which may eventually sleep, at least in the 2.6.9
kernel I'm using) from sg_remove_sfp while holding a spinlock. Hence the
revised patch.

The attached patch is against kernel 2.6.14rc2. I retested in a recent
kernel to verify that these problems still exist and are fixed by the
patch.


Nate Dailey
Stratus Technologies


Signed-off-by: Nate Dailey <nate.dailey@stratus.com>

------_=_NextPart_001_01C5C069.0AB25FD5
Content-Type: application/octet-stream;
	name="sg.c.patch2614rc2nd"
Content-Transfer-Encoding: base64
Content-Description: sg.c.patch2614rc2nd
Content-Disposition: attachment;
	filename="sg.c.patch2614rc2nd"

LS0tIHNnLmMub3JpZwkyMDA1LTA5LTIyIDEwOjMxOjUxLjAwMDAwMDAwMCAtMDQwMAorKysgc2cu
YwkyMDA1LTA5LTIyIDEwOjQxOjI4LjAwMDAwMDAwMCAtMDQwMApAQCAtMzE5LDkgKzMxOSw3IEBA
IHNnX3JlbGVhc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGYKIAlTQ1NJX0xPR19USU1F
T1VUKDMsIHByaW50aygic2dfcmVsZWFzZTogJXNcbiIsIHNkcC0+ZGlzay0+ZGlza19uYW1lKSk7
CiAJc2dfZmFzeW5jKC0xLCBmaWxwLCAwKTsJLyogcmVtb3ZlIGZpbHAgZnJvbSBhc3luYyBub3Rp
ZmljYXRpb24gbGlzdCAqLwogCWlmICgwID09IHNnX3JlbW92ZV9zZnAoc2RwLCBzZnApKSB7CS8q
IFJldHVybnMgMSB3aGVuIHNkcCBnb25lICovCi0JCWlmICghc2RwLT5kZXRhY2hlZCkgewotCQkJ
c2NzaV9kZXZpY2VfcHV0KHNkcC0+ZGV2aWNlKTsKLQkJfQorCQlzY3NpX2RldmljZV9wdXQoc2Rw
LT5kZXZpY2UpOwogCQlzZHAtPmV4Y2x1ZGUgPSAwOwogCQl3YWtlX3VwX2ludGVycnVwdGlibGUo
JnNkcC0+b19leGNsX3dhaXQpOwogCX0KQEAgLTE2MzEsMTkgKzE2MjksMjkgQEAgc2dfcmVtb3Zl
KHN0cnVjdCBjbGFzc19kZXZpY2UgKmNsX2RldikKIAkJc2dfbnJfZGV2LS07CiAJCWJyZWFrOwog
CX0KLQl3cml0ZV91bmxvY2tfaXJxcmVzdG9yZSgmc2dfZGV2X2Fycl9sb2NrLCBpZmxhZ3MpOwog
CiAJaWYgKHNkcCkgewotCQlzeXNmc19yZW1vdmVfbGluaygmc2NzaWRwLT5zZGV2X2dlbmRldi5r
b2JqLCAiZ2VuZXJpYyIpOwotCQljbGFzc19kZXZpY2VfZGVzdHJveShzZ19zeXNmc19jbGFzcywg
TUtERVYoU0NTSV9HRU5FUklDX01BSk9SLCBrKSk7Ci0JCWNkZXZfZGVsKHNkcC0+Y2Rldik7CisJ
CXN0cnVjdCBjZGV2ICp0bXBfY2RldjsKKwkJc3RydWN0IGdlbmRpc2sgKnRtcF9kaXNrOworCQlp
bnQgZnJlZV9zZHAgPSAwOworCisJCXRtcF9jZGV2ID0gc2RwLT5jZGV2OwogCQlzZHAtPmNkZXYg
PSBOVUxMOwotCQlkZXZmc19yZW1vdmUoIiVzL2dlbmVyaWMiLCBzY3NpZHAtPmRldmZzX25hbWUp
OwotCQlwdXRfZGlzayhzZHAtPmRpc2spOworCQl0bXBfZGlzayA9IHNkcC0+ZGlzazsKIAkJc2Rw
LT5kaXNrID0gTlVMTDsKIAkJaWYgKE5VTEwgPT0gc2RwLT5oZWFkZnApCisJCQlmcmVlX3NkcCA9
IDE7CisJCXdyaXRlX3VubG9ja19pcnFyZXN0b3JlKCZzZ19kZXZfYXJyX2xvY2ssIGlmbGFncyk7
CisKKwkJc3lzZnNfcmVtb3ZlX2xpbmsoJnNjc2lkcC0+c2Rldl9nZW5kZXYua29iaiwgImdlbmVy
aWMiKTsKKwkJY2xhc3NfZGV2aWNlX2Rlc3Ryb3koc2dfc3lzZnNfY2xhc3MsIE1LREVWKFNDU0lf
R0VORVJJQ19NQUpPUiwgaykpOworCQljZGV2X2RlbCh0bXBfY2Rldik7CisJCWRldmZzX3JlbW92
ZSgiJXMvZ2VuZXJpYyIsIHNjc2lkcC0+ZGV2ZnNfbmFtZSk7CisJCXB1dF9kaXNrKHRtcF9kaXNr
KTsKKwkJaWYgKGZyZWVfc2RwKQogCQkJa2ZyZWUoKGNoYXIgKikgc2RwKTsKLQl9CisJfSBlbHNl
CisJCXdyaXRlX3VubG9ja19pcnFyZXN0b3JlKCZzZ19kZXZfYXJyX2xvY2ssIGlmbGFncyk7CiAK
IAlpZiAoZGVsYXkpCiAJCW1zbGVlcCgxMCk7CS8qIGRpcnR5IGRldGFjaCBzbyBkZWxheSBkZXZp
Y2UgZGVzdHJ1Y3Rpb24gKi8KQEAgLTI2MDksMTAgKzI2MTcsMTIgQEAgc2dfcmVtb3ZlX3NmcChT
Z19kZXZpY2UgKiBzZHAsIFNnX2ZkICogcwogCQkJfQogCQkJaWYgKGsgPCBtYXhkKQogCQkJCXNn
X2Rldl9hcnJba10gPSBOVUxMOworCQkJd3JpdGVfdW5sb2NrX2lycXJlc3RvcmUoJnNnX2Rldl9h
cnJfbG9jaywgaWZsYWdzKTsKKwkJCXNjc2lfZGV2aWNlX3B1dChzZHAtPmRldmljZSk7CiAJCQlr
ZnJlZSgoY2hhciAqKSBzZHApOwogCQkJcmVzID0gMTsKLQkJfQotCQl3cml0ZV91bmxvY2tfaXJx
cmVzdG9yZSgmc2dfZGV2X2Fycl9sb2NrLCBpZmxhZ3MpOworCQl9IGVsc2UKKwkJCXdyaXRlX3Vu
bG9ja19pcnFyZXN0b3JlKCZzZ19kZXZfYXJyX2xvY2ssIGlmbGFncyk7CiAJfSBlbHNlIHsKIAkJ
LyogTU9EX0lOQydzIHRvIGluaGliaXQgdW5sb2FkaW5nIHNnIGFuZCBhc3NvY2lhdGVkIGFkYXB0
ZXIgZHJpdmVyICovCiAJCS8qIG9ubHkgYnVtcCB0aGUgYWNjZXNzX2NvdW50IGlmIHdlIGFjdHVh
bGx5IHN1Y2NlZWRlZCBpbgo=

------_=_NextPart_001_01C5C069.0AB25FD5--
