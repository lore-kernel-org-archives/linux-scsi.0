From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] - mpt fusion - mptspi - host reset, kick offdomainvalidation again.
Date: Wed, 19 Apr 2006 18:28:24 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70081480@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C66411.573FBD85"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:36483 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751340AbWDTA2c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 20:28:32 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C66411.573FBD85
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Wednesday, April 19, 2006 4:45 PM, James Bottomley wrote:=20
>=20
> I haven't followed all the paths, but I'm fairly certain
> mptspi_ioc_reset can be invoked from interrupt context, can't it?  In
> which case it has to use spi_schedule_dv() to get the necessary user
> context to perform the DV.
>=20

Yes, it appears that all calling functions of MptResetHandlers[], pass
the sleepFlag.  Therefore its a possibility that at some time it could
be=20
called at interrupt time, but mostly like not.   Thanks for pointing out
that.

We need to quiese io before and after calling spi_schedule_dv(),
therefore
I prefer if we spawn a work thread from mptspi, then call
mptspi_dv_device.

Attached updated patch.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>






------_=_NextPart_001_01C66411.573FBD85
Content-Type: application/octet-stream;
	name="spi_dv_fix.patch"
Content-Transfer-Encoding: base64
Content-Description: spi_dv_fix.patch
Content-Disposition: attachment;
	filename="spi_dv_fix.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c3BpLmMgYS9kcml2ZXJzL21l
c3NhZ2UvZnVzaW9uL21wdHNwaS5jCi0tLSBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c3Bp
LmMJMjAwNi0wNC0xNyAxMDozMzo1MC4wMDAwMDAwMDAgLTA2MDAKKysrIGEvZHJpdmVycy9tZXNz
YWdlL2Z1c2lvbi9tcHRzcGkuYwkyMDA2LTA0LTE5IDE4OjE2OjExLjAwMDAwMDAwMCAtMDYwMApA
QCAtNzgzLDYgKzc4Myw3MCBAQAogfTsKIE1PRFVMRV9ERVZJQ0VfVEFCTEUocGNpLCBtcHRzcGlf
cGNpX3RhYmxlKTsKIAorCisvKgorICogcmVuZWdvdGlhdGUgZm9yIGEgZ2l2ZW4gdGFyZ2V0Cisg
Ki8KK3N0YXRpYyB2b2lkCittcHRzcGlfZHZfcmVuZWdvdGlhdGVfd29yayh2b2lkICpkYXRhKQor
eworCXN0cnVjdCB3b3JrX3F1ZXVlX3dyYXBwZXIgKndxdyA9IChzdHJ1Y3Qgd29ya19xdWV1ZV93
cmFwcGVyICopZGF0YTsKKwlzdHJ1Y3QgX01QVF9TQ1NJX0hPU1QgKmhkID0gd3F3LT5oZDsKKwlz
dHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXY7CisKKwlrZnJlZSh3cXcpOworCisJc2hvc3RfZm9yX2Vh
Y2hfZGV2aWNlKHNkZXYsIGhkLT5pb2MtPnNoKQorCQltcHRzcGlfZHZfZGV2aWNlKGhkLCBzZGV2
KTsKK30KKworc3RhdGljIHZvaWQKK21wdHNwaV9kdl9yZW5lZ290aWF0ZShzdHJ1Y3QgX01QVF9T
Q1NJX0hPU1QgKmhkKQoreworCXN0cnVjdCB3b3JrX3F1ZXVlX3dyYXBwZXIgKndxdyA9IGttYWxs
b2Moc2l6ZW9mKCp3cXcpLCBHRlBfQVRPTUlDKTsKKworCWlmICghd3F3KQorCQlyZXR1cm47CisK
KwlJTklUX1dPUksoJndxdy0+d29yaywgbXB0c3BpX2R2X3JlbmVnb3RpYXRlX3dvcmssIHdxdyk7
CisJd3F3LT5oZCA9IGhkOworCisJc2NoZWR1bGVfd29yaygmd3F3LT53b3JrKTsKK30KKworLyoK
KyAqIHNwaSBtb2R1bGUgcmVzZXQgaGFuZGxlcgorICovCitzdGF0aWMgaW50CittcHRzcGlfaW9j
X3Jlc2V0KE1QVF9BREFQVEVSICppb2MsIGludCByZXNldF9waGFzZSkKK3sKKwlzdHJ1Y3QgX01Q
VF9TQ1NJX0hPU1QgKmhkID0gKHN0cnVjdCBfTVBUX1NDU0lfSE9TVCAqKWlvYy0+c2gtPmhvc3Rk
YXRhOworCWludCByYzsKKworCXJjID0gbXB0c2NzaWhfaW9jX3Jlc2V0KGlvYywgcmVzZXRfcGhh
c2UpOworCisJaWYgKHJlc2V0X3BoYXNlID09IE1QVF9JT0NfUE9TVF9SRVNFVCkKKwkJbXB0c3Bp
X2R2X3JlbmVnb3RpYXRlKGhkKTsKKworCXJldHVybiByYzsKK30KKworLyoKKyAqIHNwaSBtb2R1
bGUgcmVzdW1lIGhhbmRsZXIKKyAqLworc3RhdGljIGludAorbXB0c3BpX3Jlc3VtZShzdHJ1Y3Qg
cGNpX2RldiAqcGRldikKK3sKKwlNUFRfQURBUFRFUiAJKmlvYyA9IHBjaV9nZXRfZHJ2ZGF0YShw
ZGV2KTsKKwlzdHJ1Y3QgX01QVF9TQ1NJX0hPU1QgKmhkID0gKHN0cnVjdCBfTVBUX1NDU0lfSE9T
VCAqKWlvYy0+c2gtPmhvc3RkYXRhOworCWludCByYzsKKworCXJjID0gbXB0c2NzaWhfcmVzdW1l
KHBkZXYpOworCW1wdHNwaV9kdl9yZW5lZ290aWF0ZShoZCk7CisKKwlyZXR1cm4gcmM7Cit9CisK
IC8qPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0t
PS09LT0tPS09LT0tPS09LT0tPS09Ki8KIC8qPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0t
PS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09Ki8KIC8qCkBAIC0x
MDMyLDcgKzEwOTYsNyBAQAogCS5zaHV0ZG93bgk9IG1wdHNjc2loX3NodXRkb3duLAogI2lmZGVm
IENPTkZJR19QTQogCS5zdXNwZW5kCT0gbXB0c2NzaWhfc3VzcGVuZCwKLQkucmVzdW1lCQk9IG1w
dHNjc2loX3Jlc3VtZSwKKwkucmVzdW1lCQk9IG1wdHNwaV9yZXN1bWUsCiAjZW5kaWYKIH07CiAK
QEAgLTEwNjEsNyArMTEyNSw3IEBACiAJCSAgIjogUmVnaXN0ZXJlZCBmb3IgSU9DIGV2ZW50IG5v
dGlmaWNhdGlvbnNcbiIpKTsKIAl9CiAKLQlpZiAobXB0X3Jlc2V0X3JlZ2lzdGVyKG1wdHNwaURv
bmVDdHgsIG1wdHNjc2loX2lvY19yZXNldCkgPT0gMCkgeworCWlmIChtcHRfcmVzZXRfcmVnaXN0
ZXIobXB0c3BpRG9uZUN0eCwgbXB0c3BpX2lvY19yZXNldCkgPT0gMCkgewogCQlkcHJpbnRrKChL
RVJOX0lORk8gTVlOQU0KIAkJICAiOiBSZWdpc3RlcmVkIGZvciBJT0MgcmVzZXQgbm90aWZpY2F0
aW9uc1xuIikpOwogCX0K

------_=_NextPart_001_01C66411.573FBD85--
