From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 1/3] fusion - unloading the driver results in panic - fix
Date: Tue, 17 Jan 2006 17:06:23 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AB0AD@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C61BC3.045C429B"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:20970 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932547AbWARAGY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 19:06:24 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k0I01DNI011579
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 16:01:13 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k0I06NpW016141
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 16:06:23 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C61BC3.045C429B
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

The ioc->alt_ioc->alt_ioc pointer is not getting cleared
during driver unload time.   This dangling pointer
can result in panic in certain circumstances, such=20
as error recovery, or firmware download in flashless
environments. This only impacts dual functions controllers,=20
such as 1030. Please apply.

This patch also includes a small cosmetic name change=20
for mpt_spi_log_info.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_001_01C61BC3.045C429B
Content-Type: application/octet-stream;
	name="fusion-1-panic.patch"
Content-Transfer-Encoding: base64
Content-Description: fusion-1-panic.patch
Content-Disposition: attachment;
	filename="fusion-1-panic.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0YmFzZS5jIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRiYXNlLmMKLS0tIGIvZHJpdmVycy9tZXNzYWdlL2Z1c2lvbi9tcHRi
YXNlLmMJMjAwNi0wMS0xNyAxMToxODo0MS4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRiYXNlLmMJMjAwNi0wMS0xNyAxNjowNDo1OS4wMDAwMDAwMDAgLTA3
MDAKQEAgLTE3OCw3ICsxNzgsNyBAQAogc3RhdGljIGludAlQcm9jZXNzRXZlbnROb3RpZmljYXRp
b24oTVBUX0FEQVBURVIgKmlvYywgRXZlbnROb3RpZmljYXRpb25SZXBseV90ICpldlJlcGx5LCBp
bnQgKmV2SGFuZGxlcnMpOwogc3RhdGljIHZvaWQJbXB0X3NwX2lvY19pbmZvKE1QVF9BREFQVEVS
ICppb2MsIHUzMiBpb2Nfc3RhdHVzLCBNUFRfRlJBTUVfSERSICptZik7CiBzdGF0aWMgdm9pZAlt
cHRfZmNfbG9nX2luZm8oTVBUX0FEQVBURVIgKmlvYywgdTMyIGxvZ19pbmZvKTsKLXN0YXRpYyB2
b2lkCW1wdF9zcF9sb2dfaW5mbyhNUFRfQURBUFRFUiAqaW9jLCB1MzIgbG9nX2luZm8pOworc3Rh
dGljIHZvaWQJbXB0X3NwaV9sb2dfaW5mbyhNUFRfQURBUFRFUiAqaW9jLCB1MzIgbG9nX2luZm8p
Owogc3RhdGljIHZvaWQJbXB0X3Nhc19sb2dfaW5mbyhNUFRfQURBUFRFUiAqaW9jLCB1MzIgbG9n
X2luZm8pOwogCiAvKiBtb2R1bGUgZW50cnkgcG9pbnQgKi8KQEAgLTMxNyw3ICszMTcsNyBAQAog
CQlpZiAoaW9jLT5idXNfdHlwZSA9PSBGQykKIAkJCW1wdF9mY19sb2dfaW5mbyhpb2MsIGxvZ19p
bmZvKTsKIAkJZWxzZSBpZiAoaW9jLT5idXNfdHlwZSA9PSBTUEkpCi0JCQltcHRfc3BfbG9nX2lu
Zm8oaW9jLCBsb2dfaW5mbyk7CisJCQltcHRfc3BpX2xvZ19pbmZvKGlvYywgbG9nX2luZm8pOwog
CQllbHNlIGlmIChpb2MtPmJ1c190eXBlID09IFNBUykKIAkJCW1wdF9zYXNfbG9nX2luZm8oaW9j
LCBsb2dfaW5mbyk7CiAJfQpAQCAtMTQ5NSw2ICsxNDk1LDggQEAKIAkJZnJlZV9pcnEoaW9jLT5w
Y2lfaXJxLCBpb2MpOwogCQlpZiAobXB0X21zaV9lbmFibGUgPT0gMSkKIAkJCXBjaV9kaXNhYmxl
X21zaShwZGV2KTsKKwkJaWYgKGlvYy0+YWx0X2lvYykKKwkJCWlvYy0+YWx0X2lvYy0+YWx0X2lv
YyA9IE5VTEw7CiAJCWlvdW5tYXAobWVtKTsKIAkJa2ZyZWUoaW9jKTsKIAkJcGNpX3NldF9kcnZk
YXRhKHBkZXYsIE5VTEwpOwpAQCAtMjE3MSw2ICsyMTczLDEwIEBACiAJc3pfbGFzdCA9IGlvYy0+
YWxsb2NfdG90YWw7CiAJZHByaW50aygoS0VSTl9JTkZPIE1ZTkFNICI6ICVzOiBmcmVlJ2QgJWQg
b2YgJWQgYnl0ZXNcbiIsCiAJCQlpb2MtPm5hbWUsIHN6X2ZpcnN0LXN6X2xhc3QrKGludClzaXpl
b2YoKmlvYyksIHN6X2ZpcnN0KSk7CisKKwlpZiAoaW9jLT5hbHRfaW9jKQorCQlpb2MtPmFsdF9p
b2MtPmFsdF9pb2MgPSBOVUxMOworCiAJa2ZyZWUoaW9jKTsKIH0KIApAQCAtNjIwNyw3ICs2MjEz
LDcgQEAKIAogLyo9LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0t
PS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0qLwogLyoKLSAqCW1wdF9zcF9sb2dfaW5mbyAt
IExvZyBpbmZvcm1hdGlvbiByZXR1cm5lZCBmcm9tIFNDU0kgUGFyYWxsZWwgSU9DLgorICoJbXB0
X3NwaV9sb2dfaW5mbyAtIExvZyBpbmZvcm1hdGlvbiByZXR1cm5lZCBmcm9tIFNDU0kgUGFyYWxs
ZWwgSU9DLgogICoJQGlvYzogUG9pbnRlciB0byBNUFRfQURBUFRFUiBzdHJ1Y3R1cmUKICAqCUBt
cjogUG9pbnRlciB0byBNUFQgcmVwbHkgZnJhbWUKICAqCUBsb2dfaW5mbzogVTMyIExvZ0luZm8g
d29yZCBmcm9tIHRoZSBJT0MKQEAgLTYyMTUsNyArNjIyMSw3IEBACiAgKglSZWZlciB0byBsc2kv
c3BfbG9nLmguCiAgKi8KIHN0YXRpYyB2b2lkCi1tcHRfc3BfbG9nX2luZm8oTVBUX0FEQVBURVIg
KmlvYywgdTMyIGxvZ19pbmZvKQorbXB0X3NwaV9sb2dfaW5mbyhNUFRfQURBUFRFUiAqaW9jLCB1
MzIgbG9nX2luZm8pCiB7CiAJdTMyIGluZm8gPSBsb2dfaW5mbyAmIDB4MDBGRjAwMDA7CiAJY2hh
ciAqZGVzYyA9ICJ1bmtub3duIjsK

------_=_NextPart_001_01C61BC3.045C429B--
