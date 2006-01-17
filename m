From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 3/8] fusion - setting timeouts in eh threads appropiatley for fc/sas/spi
Date: Mon, 16 Jan 2006 18:53:13 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC7F@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C61B08.C75CC7EB"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7899 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751328AbWAQBxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 20:53:15 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k0H1m4NI021594
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:48:04 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k0H1rELF007116
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:53:14 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C61B08.C75CC7EB
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

The task managment request timeout in the eh threads was set=20
for U320 timing, which is between 2-5 seconds.=20
This is too small for FC and SAS.
According to the firmware engineers, Fibre needs to be 40 seconds
and SAS needs to be 10 seconds.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C61B08.C75CC7EB
Content-Type: application/octet-stream;
	name="fusion-3-eh-threads.patch"
Content-Transfer-Encoding: base64
Content-Description: fusion-3-eh-threads.patch
Content-Disposition: attachment;
	filename="fusion-3-eh-threads.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2NzaWguYyBhL2RyaXZlcnMv
bWVzc2FnZS9mdXNpb24vbXB0c2NzaWguYwotLS0gYi9kcml2ZXJzL21lc3NhZ2UvZnVzaW9uL21w
dHNjc2loLmMJMjAwNi0wMS0xNiAxODoxMjo1Ny4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVy
cy9tZXNzYWdlL2Z1c2lvbi9tcHRzY3NpaC5jCTIwMDYtMDEtMTYgMTg6MDU6MzcuMDAwMDAwMDAw
IC0wNzAwCkBAIC0xNzQxLDYgKzE3NDEsNyBAQAogCWludAkJIHNjcG50X2lkeDsKIAlpbnQJCSBy
ZXR2YWw7CiAJVmlydERldmljZQkgKnZkZXY7CisJaW50CQkgdG1fdGltZW91dDsKIAogCS8qIElm
IHdlIGNhbid0IGxvY2F0ZSBvdXIgaG9zdCBhZGFwdGVyIHN0cnVjdHVyZSwgcmV0dXJuIEZBSUxF
RCBzdGF0dXMuCiAJICovCkBAIC0xNzkxLDkgKzE3OTIsMjIgQEAKIAloZC0+YWJvcnRTQ3BudCA9
IFNDcG50OwogCiAJdmRldiA9IFNDcG50LT5kZXZpY2UtPmhvc3RkYXRhOworCS8qIHNldCB0aW1l
b3V0IGluIHNlY29uZHMgKi8KKwlzd2l0Y2ggKGhkLT5pb2MtPmJ1c190eXBlKSB7CisJY2FzZSBG
QzoKKwkJdG1fdGltZW91dD00MDsKKwkJYnJlYWs7CisJY2FzZSBTQVM6CisJCXRtX3RpbWVvdXQ9
MTA7CisJCWJyZWFrOworCWNhc2UgU1BJOgorCWRlZmF1bHQ6CisJCXRtX3RpbWVvdXQ9MjsKKwkJ
YnJlYWs7CisJfQogCXJldHZhbCA9IG1wdHNjc2loX1RNSGFuZGxlcihoZCwgTVBJX1NDU0lUQVNL
TUdNVF9UQVNLVFlQRV9BQk9SVF9UQVNLLAogCQl2ZGV2LT5idXNfaWQsIHZkZXYtPnRhcmdldF9p
ZCwgdmRldi0+bHVuLAotCQljdHgyYWJvcnQsIDIgLyogMiBzZWNvbmQgdGltZW91dCAqLyk7CisJ
CWN0eDJhYm9ydCwgdG1fdGltZW91dCk7CiAKIAlwcmludGsgKEtFUk5fV0FSTklORyBNWU5BTSAi
OiAlczogdGFzayBhYm9ydDogJXMgKHNjPSVwKVxuIiwKIAkJaGQtPmlvYy0+bmFtZSwKQEAgLTE4
MjQsNiArMTgzOCw3IEBACiAJTVBUX1NDU0lfSE9TVAkqaGQ7CiAJaW50CQkgcmV0dmFsOwogCVZp
cnREZXZpY2UJICp2ZGV2OworCWludAkJIHRtX3RpbWVvdXQ7CiAKIAkvKiBJZiB3ZSBjYW4ndCBs
b2NhdGUgb3VyIGhvc3QgYWRhcHRlciBzdHJ1Y3R1cmUsIHJldHVybiBGQUlMRUQgc3RhdHVzLgog
CSAqLwpAQCAtMTg0Miw5ICsxODU3LDIxIEBACiAJc2NzaV9wcmludF9jb21tYW5kKFNDcG50KTsK
IAogCXZkZXYgPSBTQ3BudC0+ZGV2aWNlLT5ob3N0ZGF0YTsKKwlzd2l0Y2ggKGhkLT5pb2MtPmJ1
c190eXBlKSB7CisJY2FzZSBGQzoKKwkJdG1fdGltZW91dD00MDsKKwkJYnJlYWs7CisJY2FzZSBT
QVM6CisJCXRtX3RpbWVvdXQ9MTA7CisJCWJyZWFrOworCWNhc2UgU1BJOgorCWRlZmF1bHQ6CisJ
CXRtX3RpbWVvdXQ9NTsKKwkJYnJlYWs7CisJfQogCXJldHZhbCA9IG1wdHNjc2loX1RNSGFuZGxl
cihoZCwgTVBJX1NDU0lUQVNLTUdNVF9UQVNLVFlQRV9UQVJHRVRfUkVTRVQsCiAJCXZkZXYtPmJ1
c19pZCwgdmRldi0+dGFyZ2V0X2lkLAotCQkwLCAwLCA1IC8qIDUgc2Vjb25kIHRpbWVvdXQgKi8p
OworCQkwLCAwLCB0bV90aW1lb3V0KTsKIAogCXByaW50ayAoS0VSTl9XQVJOSU5HIE1ZTkFNICI6
ICVzOiB0YXJnZXQgcmVzZXQ6ICVzIChzYz0lcClcbiIsCiAJCWhkLT5pb2MtPm5hbWUsCkBAIC0x
ODc1LDYgKzE5MDIsNyBAQAogCU1QVF9TQ1NJX0hPU1QJKmhkOwogCWludAkJIHJldHZhbDsKIAlW
aXJ0RGV2aWNlCSAqdmRldjsKKwlpbnQJCSB0bV90aW1lb3V0OwogCiAJLyogSWYgd2UgY2FuJ3Qg
bG9jYXRlIG91ciBob3N0IGFkYXB0ZXIgc3RydWN0dXJlLCByZXR1cm4gRkFJTEVEIHN0YXR1cy4K
IAkgKi8KQEAgLTE4OTMsOCArMTkyMSwyMCBAQAogCQloZC0+dGltZW91dHMrKzsKIAogCXZkZXYg
PSBTQ3BudC0+ZGV2aWNlLT5ob3N0ZGF0YTsKKwlzd2l0Y2ggKGhkLT5pb2MtPmJ1c190eXBlKSB7
CisJY2FzZSBGQzoKKwkJdG1fdGltZW91dD00MDsKKwkJYnJlYWs7CisJY2FzZSBTQVM6CisJCXRt
X3RpbWVvdXQ9MTA7CisJCWJyZWFrOworCWNhc2UgU1BJOgorCWRlZmF1bHQ6CisJCXRtX3RpbWVv
dXQ9NTsKKwkJYnJlYWs7CisJfQogCXJldHZhbCA9IG1wdHNjc2loX1RNSGFuZGxlcihoZCwgTVBJ
X1NDU0lUQVNLTUdNVF9UQVNLVFlQRV9SRVNFVF9CVVMsCi0JCXZkZXYtPmJ1c19pZCwgMCwgMCwg
MCwgNSAvKiA1IHNlY29uZCB0aW1lb3V0ICovKTsKKwkJdmRldi0+YnVzX2lkLCAwLCAwLCAwLCB0
bV90aW1lb3V0KTsKIAogCXByaW50ayAoS0VSTl9XQVJOSU5HIE1ZTkFNICI6ICVzOiBidXMgcmVz
ZXQ6ICVzIChzYz0lcClcbiIsCiAJCWhkLT5pb2MtPm5hbWUsCg==

------_=_NextPart_001_01C61B08.C75CC7EB--
