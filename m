From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 2/3] - mpt fusion - bug fix for duplicate targets
Date: Thu, 13 Apr 2006 16:11:54 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70080B57@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C65F47.56AB07A6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:61653 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932472AbWDMWL7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 18:11:59 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.

------_=_NextPart_001_01C65F47.56AB07A6
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Bug fix - Due to a recent change in scsi_transport_sas,
in the function sas_rphy_add(), its possible to have the
same target mapped to two different device nodes,=20
meaning /dev/sda at id=3D0 and /dev/sdb at id=3D1, are remapped
in mptsas to the same device at id=3Dfoo.

I'll explain the problem.
The sas drivers have a rphy to rphy relationship.  An rphy
created on a hba phy points to the expander phy.  Then the expander
phy creates a rphy pointing back to the same hba rphy. The expander
phy which contains the rphy pointing back to the hba phy, contains
the attributes device_type =3D SAS_END_DEVICE, and target_port_protocals =
=3D
0.
Hence the recent change in sas_rphy_add() make it drop down to
scsi_scan_target, whereas before there was sepecial handling to=20
prevent this case from happening.  With this change, the mptsas slave
entry=20
points are called to enumerate the rphy that points back to the hba phy.
The target id in our data structures is the same as a real target device
on another phy.  Thus we end up mapping the same target to two different
rphys.
To fix this, I added a check in mptsas_slave_alloc to make sure the
requested rphy is mapped to a true end device.

JEJB: Pls apply to scsi-rc-fixes tree.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C65F47.56AB07A6
Content-Type: application/octet-stream;
	name="duplicate_targets.patch"
Content-Transfer-Encoding: base64
Content-Description: duplicate_targets.patch
Content-Disposition: attachment;
	filename="duplicate_targets.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2FzLmMgYS9kcml2ZXJzL21l
c3NhZ2UvZnVzaW9uL21wdHNhcy5jCi0tLSBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2Fz
LmMJMjAwNi0wNC0xMyAxNTowODoyNy4wMDAwMDAwMDAgLTA2MDAKKysrIGEvZHJpdmVycy9tZXNz
YWdlL2Z1c2lvbi9tcHRzYXMuYwkyMDA2LTA0LTEzIDE1OjExOjE1LjAwMDAwMDAwMCAtMDYwMApA
QCAtMjk4LDYgKzI5OCwyNiBAQAogCXJldHVybiByYzsKIH0KIAorLyoKKyAqIFJldHVybnMgdHJ1
ZSBpZiB0aGVyZSBpcyBhIHNjc2kgZW5kIGRldmljZQorICovCitzdGF0aWMgaW5saW5lIGludAor
bXB0c2FzX2lzX2VuZF9kZXZpY2Uoc3RydWN0IG1wdHNhc19kZXZpbmZvICogYXR0YWNoZWQpCit7
CisJaWYgKChhdHRhY2hlZC0+aGFuZGxlKSAmJgorCSAgICAoYXR0YWNoZWQtPmRldmljZV9pbmZv
ICYKKwkgICAgTVBJX1NBU19ERVZJQ0VfSU5GT19FTkRfREVWSUNFKSAmJgorCSAgICAoKGF0dGFj
aGVkLT5kZXZpY2VfaW5mbyAmCisJICAgIE1QSV9TQVNfREVWSUNFX0lORk9fU1NQX1RBUkdFVCkg
fAorCSAgICAoYXR0YWNoZWQtPmRldmljZV9pbmZvICYKKwkgICAgTVBJX1NBU19ERVZJQ0VfSU5G
T19TVFBfVEFSR0VUKSB8CisJICAgIChhdHRhY2hlZC0+ZGV2aWNlX2luZm8gJgorCSAgICBNUElf
U0FTX0RFVklDRV9JTkZPX1NBVEFfREVWSUNFKSkpCisJCXJldHVybiAxOworCWVsc2UKKwkJcmV0
dXJuIDA7Cit9CisKIHN0YXRpYyBpbnQKIG1wdHNhc19zYXNfZW5jbG9zdXJlX3BnMChNUFRfQURB
UFRFUiAqaW9jLCBzdHJ1Y3QgbXB0c2FzX2VuY2xvc3VyZSAqZW5jbG9zdXJlLAogCQl1MzIgZm9y
bSwgdTMyIGZvcm1fc3BlY2lmaWMpCkBAIC00MjksNiArNDQ5LDkgQEAKIAkJZm9yIChpID0gMDsg
aSA8IHAtPm51bV9waHlzOyBpKyspIHsKIAkJCWlmIChwLT5waHlfaW5mb1tpXS5hdHRhY2hlZC5z
YXNfYWRkcmVzcyA9PQogCQkJCQlycGh5LT5pZGVudGlmeS5zYXNfYWRkcmVzcykgeworCQkJCWlm
ICghbXB0c2FzX2lzX2VuZF9kZXZpY2UoCisJCQkJCSZwLT5waHlfaW5mb1tpXS5hdHRhY2hlZCkp
CisJCQkJCWdvdG8gb3V0X25vX2RldjsKIAkJCQl0YXJnZXRfaWQgPSBwLT5waHlfaW5mb1tpXS5h
dHRhY2hlZC5pZDsKIAkJCQl2dGFyZ2V0LT5idXNfaWQgPSBwLT5waHlfaW5mb1tpXS5hdHRhY2hl
ZC5jaGFubmVsOwogCQkJCXZkZXYtPmx1biA9IHNkZXYtPmx1bjsKQEAgLTQ0OCw2ICs0NzEsNyBA
QAogCQkJfQogCQl9CiAJfQorIG91dF9ub19kZXY6CiAJbXV0ZXhfdW5sb2NrKCZoZC0+aW9jLT5z
YXNfdG9wb2xvZ3lfbXV0ZXgpOwogCiAJa2ZyZWUodmRldik7CkBAIC0xMDY4LDI2ICsxMDkyLDYg
QEAKIAlyZXR1cm4gZXJyb3I7CiB9CiAKLS8qCi0gKiBSZXR1cm5zIHRydWUgaWYgdGhlcmUgaXMg
YSBzY3NpIGVuZCBkZXZpY2UKLSAqLwotc3RhdGljIGlubGluZSBpbnQKLW1wdHNhc19pc19lbmRf
ZGV2aWNlKHN0cnVjdCBtcHRzYXNfZGV2aW5mbyAqIGF0dGFjaGVkKQotewotCWlmICgoYXR0YWNo
ZWQtPmhhbmRsZSkgJiYKLQkgICAgKGF0dGFjaGVkLT5kZXZpY2VfaW5mbyAmCi0JICAgIE1QSV9T
QVNfREVWSUNFX0lORk9fRU5EX0RFVklDRSkgJiYKLQkgICAgKChhdHRhY2hlZC0+ZGV2aWNlX2lu
Zm8gJgotCSAgICBNUElfU0FTX0RFVklDRV9JTkZPX1NTUF9UQVJHRVQpIHwKLQkgICAgKGF0dGFj
aGVkLT5kZXZpY2VfaW5mbyAmCi0JICAgIE1QSV9TQVNfREVWSUNFX0lORk9fU1RQX1RBUkdFVCkg
fAotCSAgICAoYXR0YWNoZWQtPmRldmljZV9pbmZvICYKLQkgICAgTVBJX1NBU19ERVZJQ0VfSU5G
T19TQVRBX0RFVklDRSkpKQotCQlyZXR1cm4gMTsKLQllbHNlCi0JCXJldHVybiAwOwotfQotCiBz
dGF0aWMgdm9pZAogbXB0c2FzX3BhcnNlX2RldmljZV9pbmZvKHN0cnVjdCBzYXNfaWRlbnRpZnkg
KmlkZW50aWZ5LAogCQlzdHJ1Y3QgbXB0c2FzX2RldmluZm8gKmRldmljZV9pbmZvKQo=

------_=_NextPart_001_01C65F47.56AB07A6--
