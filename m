From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 1/3] - mpt fusion - panic in mptsas_slave_configure
Date: Thu, 13 Apr 2006 16:08:17 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70080B50@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C65F46.D5AE0E82"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:32213 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932464AbWDMWIY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 18:08:24 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01C65F46.D5AE0E82
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Driver panic when RAID logical volume was present when driver
loaded, or when a RAID logical volume was created on the fly.

This issue was created in due to recent scsi_transport_sas change,
when sas_read_port_mode_page was added into the mptsas drivers
slave_config entry point.   =20

This new API expects that all sdev's to be assocated to an rphy, however
that is not the case for logical volumes, as they are created using
scsi_add_device, instead of sas_rphy_add().

JEJB: Pls apply to scsi-rc-fixes tree.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C65F46.D5AE0E82
Content-Type: application/octet-stream;
	name="slave_config_panic.patch"
Content-Transfer-Encoding: base64
Content-Description: slave_config_panic.patch
Content-Disposition: attachment;
	filename="slave_config_panic.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2FzLmMgYS9kcml2ZXJzL21l
c3NhZ2UvZnVzaW9uL21wdHNhcy5jCi0tLSBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2Fz
LmMJMjAwNi0wNC0xMSAxNToxOTozNC4wMDAwMDAwMDAgLTA2MDAKKysrIGEvZHJpdmVycy9tZXNz
YWdlL2Z1c2lvbi9tcHRzYXMuYwkyMDA2LTA0LTEzIDE1OjA4OjI3LjAwMDAwMDAwMCAtMDYwMApA
QCAtMzY2LDcgKzM2NiwxNSBAQAogc3RhdGljIGludAogbXB0c2FzX3NsYXZlX2NvbmZpZ3VyZShz
dHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYpCiB7Ci0Jc2FzX3JlYWRfcG9ydF9tb2RlX3BhZ2Uoc2Rl
dik7CisJc3RydWN0IFNjc2lfSG9zdAkqaG9zdCA9IHNkZXYtPmhvc3Q7CisJTVBUX1NDU0lfSE9T
VAkJKmhkID0gKE1QVF9TQ1NJX0hPU1QgKilob3N0LT5ob3N0ZGF0YTsKKworCS8qCisJICogUkFJ
RCB2b2x1bWVzIHBsYWNlZCBiZXlvbmQgdGhlIGxhc3QgZXhwZWN0ZWQgcG9ydC4KKwkgKiBJZ25v
cmUgc2VuZGluZyBzYXMgbW9kZSBwYWdlcyBpbiB0aGF0IGNhc2UuLgorCSAqLworCWlmIChzZGV2
LT5jaGFubmVsIDwgaGQtPmlvYy0+bnVtX3BvcnRzKQorCQlzYXNfcmVhZF9wb3J0X21vZGVfcGFn
ZShzZGV2KTsKIAogCXJldHVybiBtcHRzY3NpaF9zbGF2ZV9jb25maWd1cmUoc2Rldik7CiB9Cg==

------_=_NextPart_001_01C65F46.D5AE0E82--
