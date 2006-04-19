From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH] - mpt fusion - mptspi - host reset, kick off domain validation again.
Date: Wed, 19 Apr 2006 13:20:12 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70081384@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C663E6.48785729"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:52705 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751043AbWDSTUW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 15:20:22 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01C663E6.48785729
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

After host reset, the firmware is putting devices at default
negotiation, which will be asyn narrow, the slowest speed.
This patch kicks off domain validation for every device=20
known prior to the host reset.

Prior to the mptspi driver being ported to spi transport layer,
the driver was resending that last saved negotiation parameters
to each device, not actually starting dv again.  This is better
method than before, as something could of changed, and restarting
dv will handle those cases.  Neverless, I still consider this a bug fix.

James, if possible, please apply to current release candidate tree.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C663E6.48785729
Content-Type: application/octet-stream;
	name="spi_dv_fix.patch"
Content-Transfer-Encoding: base64
Content-Description: spi_dv_fix.patch
Content-Disposition: attachment;
	filename="spi_dv_fix.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c3BpLmMgYS9kcml2ZXJzL21l
c3NhZ2UvZnVzaW9uL21wdHNwaS5jCi0tLSBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c3Bp
LmMJMjAwNi0wNC0xNyAxMDozMzo1MC4wMDAwMDAwMDAgLTA2MDAKKysrIGEvZHJpdmVycy9tZXNz
YWdlL2Z1c2lvbi9tcHRzcGkuYwkyMDA2LTA0LTE5IDEzOjAxOjAyLjAwMDAwMDAwMCAtMDYwMApA
QCAtNzgzLDYgKzc4Myw1NSBAQAogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUocGNpLCBtcHRzcGlf
cGNpX3RhYmxlKTsKIAorLyoKKyAqIHJlbmVnb3RpYXRlIGZvciBhIGdpdmVuIHRhcmdldAorICov
CitzdGF0aWMgdm9pZAorbXB0c3BpX3JlbmVnb3RpYXRlKHN0cnVjdCBzY3NpX2RldmljZSAqc2Rl
dikKK3sKKwlzdHJ1Y3QgX01QVF9TQ1NJX0hPU1QgKmhkID0gKHN0cnVjdCBfTVBUX1NDU0lfSE9T
VCAqKXNkZXYtPmhvc3QtPmhvc3RkYXRhOworCisJaWYgKHNkZXYtPmNoYW5uZWwgPT0gMSB8fAor
CSAgICAgIShoZC0+aW9jLT5yYWlkX2RhdGEuaXNSYWlkICYgKDEgPDwgc2Rldi0+aWQpKSkKKwkJ
bXB0c3BpX2R2X2RldmljZShoZCwgc2Rldik7Cit9CisKKy8qCisgKiBzcGkgbW9kdWxlIHJlc2V0
IGhhbmRsZXIKKyAqLworc3RhdGljIGludAorbXB0c3BpX2lvY19yZXNldChNUFRfQURBUFRFUiAq
aW9jLCBpbnQgcmVzZXRfcGhhc2UpCit7CisgICAgICAgIHN0cnVjdCBzY3NpX2RldmljZSAqc2Rl
djsKKwlpbnQgcmM7CisKKwlyYyA9IG1wdHNjc2loX2lvY19yZXNldChpb2MsIHJlc2V0X3BoYXNl
KTsKKworCWlmIChyZXNldF9waGFzZSA9PSBNUFRfSU9DX1BPU1RfUkVTRVQpCisJCXNob3N0X2Zv
cl9lYWNoX2RldmljZShzZGV2LCBpb2MtPnNoKQorCQkJbXB0c3BpX3JlbmVnb3RpYXRlKHNkZXYp
OworCisJcmV0dXJuIHJjOworfQorCisvKgorICogc3BpIG1vZHVsZSByZXN1bWUgaGFuZGxlcgor
ICovCitzdGF0aWMgaW50CittcHRzcGlfcmVzdW1lKHN0cnVjdCBwY2lfZGV2ICpwZGV2KQorewor
CU1QVF9BREFQVEVSIAkqaW9jID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOworICAgICAgICBzdHJ1
Y3Qgc2NzaV9kZXZpY2UgKnNkZXY7CisJaW50IHJjOworCisJcmMgPSBtcHRzY3NpaF9yZXN1bWUo
cGRldik7CisKKwlzaG9zdF9mb3JfZWFjaF9kZXZpY2Uoc2RldiwgaW9jLT5zaCkKKwkJbXB0c3Bp
X3JlbmVnb3RpYXRlKHNkZXYpOworCisJcmV0dXJuIHJjOworfQorCiAvKj0tPS09LT0tPS09LT0t
PS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09
LT0tPSovCiAvKj0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09
LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPSovCiAvKgpAQCAtMTAzMiw3ICsxMDgxLDcgQEAK
IAkuc2h1dGRvd24JPSBtcHRzY3NpaF9zaHV0ZG93biwKICNpZmRlZiBDT05GSUdfUE0KIAkuc3Vz
cGVuZAk9IG1wdHNjc2loX3N1c3BlbmQsCi0JLnJlc3VtZQkJPSBtcHRzY3NpaF9yZXN1bWUsCisJ
LnJlc3VtZQkJPSBtcHRzcGlfcmVzdW1lLAogI2VuZGlmCiB9OwogCkBAIC0xMDYxLDcgKzExMTAs
NyBAQAogCQkgICI6IFJlZ2lzdGVyZWQgZm9yIElPQyBldmVudCBub3RpZmljYXRpb25zXG4iKSk7
CiAJfQogCi0JaWYgKG1wdF9yZXNldF9yZWdpc3RlcihtcHRzcGlEb25lQ3R4LCBtcHRzY3NpaF9p
b2NfcmVzZXQpID09IDApIHsKKwlpZiAobXB0X3Jlc2V0X3JlZ2lzdGVyKG1wdHNwaURvbmVDdHgs
IG1wdHNwaV9pb2NfcmVzZXQpID09IDApIHsKIAkJZHByaW50aygoS0VSTl9JTkZPIE1ZTkFNCiAJ
CSAgIjogUmVnaXN0ZXJlZCBmb3IgSU9DIHJlc2V0IG5vdGlmaWNhdGlvbnNcbiIpKTsKIAl9Cg==

------_=_NextPart_001_01C663E6.48785729--
