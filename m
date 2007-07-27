From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: Re: [PATCH] aacraid: add SCSI SYNCHONIZE_CACHE range checking (take 2)
Date: Fri, 27 Jul 2007 09:48:49 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01C5B414@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7D054.DC80FC53"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:53897 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814AbXG0Nsv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 09:48:51 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 7F66A1A5E58
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jul 2007 06:48:50 -0700 (PDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7D054.DC80FC53
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

It's been a month now, any issues with this patch I am not aware of?

Sincerely -- Mark Salyzyn

From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
Sent: Wednesday, June 20, 2007 11:31 AM
To: linux-scsi@vger.kernel.org
Subject: [PATCH] aacraid: add SCSI SYNCHONIZE_CACHE range checking (take
2)

There was some overlap with another patch (?) this one has not shown in
scsi-pending-2.6. Modernized to apply cleanly and did some extra
cleanup.

This attached patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/aachba.c |   63
++++++++++++++++++++++++++++++++++++------
 1 file changed, 55 insertions(+), 8 deletions(-)

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org=20
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Salyzyn, Mark
> Sent: Thursday, June 07, 2007 1:21 PM
> To: linux-scsi@vger.kernel.org
> Subject: [PATCH] aacraid: add SCSI SYNCHONIZE_CACHE range checking.=20
>=20
>=20
> Customer running an application that issues SYNCHRONIZE_CACHE calls
> directly noticed the broad stroke of the current implementation in the
> aacraid driver resulting in multiple applications feeding I/O to the
> storage causing the issuing application to stall for long periods of
> time. By only waiting for the current WRITE commands, rather than all
> commands, to complete; and those that are in range of the
> SYNCHRONIZE_CACHE call that would associate more tightly with the
> issuing application before telling the Firmware to flush it's dirty
> cache, we managed to reduce the stalling. The Firmware itself still
> flushes all the dirty cache associated with the array ignoring the
> range, it just does so in a more timely manner.
>=20
> This attached patch is against current scsi-misc-2.6
>=20
> ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
> handling of patch attachments.
>=20
> Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>=20
> Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C7D054.DC80FC53
Content-Type: application/octet-stream;
	name="aacraid_synch_range2.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_synch_range2.patch
Content-Disposition: attachment;
	filename="aacraid_synch_range2.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDYtMjAgMTE6MDU6NDcuNjczNjA5MjMzIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDYtMjAgMTE6MjE6MzMuNjU1MDUzMjg1IC0wNDAwCkBAIC0xNTk1LDIz
ICsxNTk1LDIzIEBACiAJaWYgKCFhYWNfdmFsaWRfY29udGV4dChjbWQsIGZpYnB0cikpCiAJCXJl
dHVybjsKIAotCWRwcmludGsoKEtFUk5fREVCVUcgInN5bmNocm9uaXplX2NhbGxiYWNrW2NwdSAl
ZF06IHQgPSAlbGQuXG4iLCAKKwlkcHJpbnRrKChLRVJOX0RFQlVHICJzeW5jaHJvbml6ZV9jYWxs
YmFja1tjcHUgJWRdOiB0ID0gJWxkLlxuIiwKIAkJCQlzbXBfcHJvY2Vzc29yX2lkKCksIGppZmZp
ZXMpKTsKIAlCVUdfT04oZmlicHRyID09IE5VTEwpOwogCiAKIAlzeW5jaHJvbml6ZXJlcGx5ID0g
ZmliX2RhdGEoZmlicHRyKTsKIAlpZiAobGUzMl90b19jcHUoc3luY2hyb25pemVyZXBseS0+c3Rh
dHVzKSA9PSBDVF9PSykKLQkJY21kLT5yZXN1bHQgPSBESURfT0sgPDwgMTYgfCAKKwkJY21kLT5y
ZXN1bHQgPSBESURfT0sgPDwgMTYgfAogCQkJQ09NTUFORF9DT01QTEVURSA8PCA4IHwgU0FNX1NU
QVRfR09PRDsKIAllbHNlIHsKIAkJc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2ID0gY21kLT5kZXZp
Y2U7CiAJCXN0cnVjdCBhYWNfZGV2ICpkZXYgPSBmaWJwdHItPmRldjsKIAkJdTMyIGNpZCA9IHNk
ZXZfaWQoc2Rldik7Ci0JCXByaW50ayhLRVJOX1dBUk5JTkcgCisJCXByaW50ayhLRVJOX1dBUk5J
TkcKIAkJICAgICAic3luY2hyb25pemVfY2FsbGJhY2s6IHN5bmNocm9uaXplIGZhaWxlZCwgc3Rh
dHVzID0gJWRcbiIsCiAJCSAgICAgbGUzMl90b19jcHUoc3luY2hyb25pemVyZXBseS0+c3RhdHVz
KSk7Ci0JCWNtZC0+cmVzdWx0ID0gRElEX09LIDw8IDE2IHwgCisJCWNtZC0+cmVzdWx0ID0gRElE
X09LIDw8IDE2IHwKIAkJCUNPTU1BTkRfQ09NUExFVEUgPDwgOCB8IFNBTV9TVEFUX0NIRUNLX0NP
TkRJVElPTjsKIAkJc2V0X3NlbnNlKCh1OCAqKSZkZXYtPmZzYV9kZXZbY2lkXS5zZW5zZV9kYXRh
LAogCQkJCSAgICBIQVJEV0FSRV9FUlJPUiwKQEAgLTE2MTksNyArMTYxOSw3IEBACiAJCQkJICAg
IEFTRU5DT0RFX0lOVEVSTkFMX1RBUkdFVF9GQUlMVVJFLCAwLCAwLAogCQkJCSAgICAwLCAwKTsK
IAkJbWVtY3B5KGNtZC0+c2Vuc2VfYnVmZmVyLCAmZGV2LT5mc2FfZGV2W2NpZF0uc2Vuc2VfZGF0
YSwKLQkJICBtaW4oc2l6ZW9mKGRldi0+ZnNhX2RldltjaWRdLnNlbnNlX2RhdGEpLCAKKwkJICBt
aW4oc2l6ZW9mKGRldi0+ZnNhX2RldltjaWRdLnNlbnNlX2RhdGEpLAogCQkJICBzaXplb2YoY21k
LT5zZW5zZV9idWZmZXIpKSk7CiAJfQogCkBAIC0xNjM3LDYgKzE2MzcsOSBAQAogCXN0cnVjdCBz
Y3NpX2RldmljZSAqc2RldiA9IHNjc2ljbWQtPmRldmljZTsKIAlpbnQgYWN0aXZlID0gMDsKIAlz
dHJ1Y3QgYWFjX2RldiAqYWFjOworCXU2NCBsYmEgPSAoKHU2NClzY3NpY21kLT5jbW5kWzJdIDw8
IDI0KSB8IChzY3NpY21kLT5jbW5kWzNdIDw8IDE2KSB8CisJCShzY3NpY21kLT5jbW5kWzRdIDw8
IDgpIHwgc2NzaWNtZC0+Y21uZFs1XTsKKwl1MzIgY291bnQgPSAoc2NzaWNtZC0+Y21uZFs3XSA8
PCA4KSB8IHNjc2ljbWQtPmNtbmRbOF07CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKIAogCS8qCkBA
IC0xNjQ1LDcgKzE2NDgsNTEgQEAKIAkgKi8KIAlzcGluX2xvY2tfaXJxc2F2ZSgmc2Rldi0+bGlz
dF9sb2NrLCBmbGFncyk7CiAJbGlzdF9mb3JfZWFjaF9lbnRyeShjbWQsICZzZGV2LT5jbWRfbGlz
dCwgbGlzdCkKLQkJaWYgKGNtZCAhPSBzY3NpY21kICYmIGNtZC0+U0NwLnBoYXNlID09IEFBQ19P
V05FUl9GSVJNV0FSRSkgeworCQlpZiAoY21kLT5TQ3AucGhhc2UgPT0gQUFDX09XTkVSX0ZJUk1X
QVJFKSB7CisJCQl1NjQgY21uZF9sYmE7CisJCQl1MzIgY21uZF9jb3VudDsKKworCQkJaWYgKGNt
ZC0+Y21uZFswXSA9PSBXUklURV82KSB7CisJCQkJY21uZF9sYmEgPSAoKGNtZC0+Y21uZFsxXSAm
IDB4MUYpIDw8IDE2KSB8CisJCQkJCShjbWQtPmNtbmRbMl0gPDwgOCkgfAorCQkJCQljbWQtPmNt
bmRbM107CisJCQkJY21uZF9jb3VudCA9IGNtZC0+Y21uZFs0XTsKKwkJCQlpZiAoY21uZF9jb3Vu
dCA9PSAwKQorCQkJCQljbW5kX2NvdW50ID0gMjU2OworCQkJfSBlbHNlIGlmIChjbWQtPmNtbmRb
MF0gPT0gV1JJVEVfMTYpIHsKKwkJCQljbW5kX2xiYSA9ICgodTY0KWNtZC0+Y21uZFsyXSA8PCA1
NikgfAorCQkJCQkoKHU2NCljbWQtPmNtbmRbM10gPDwgNDgpIHwKKwkJCQkJKCh1NjQpY21kLT5j
bW5kWzRdIDw8IDQwKSB8CisJCQkJCSgodTY0KWNtZC0+Y21uZFs1XSA8PCAzMikgfAorCQkJCQko
KHU2NCljbWQtPmNtbmRbNl0gPDwgMjQpIHwKKwkJCQkJKGNtZC0+Y21uZFs3XSA8PCAxNikgfAor
CQkJCQkoY21kLT5jbW5kWzhdIDw8IDgpIHwKKwkJCQkJY21kLT5jbW5kWzldOworCQkJCWNtbmRf
Y291bnQgPSAoY21kLT5jbW5kWzEwXSA8PCAyNCkgfAorCQkJCQkoY21kLT5jbW5kWzExXSA8PCAx
NikgfAorCQkJCQkoY21kLT5jbW5kWzEyXSA8PCA4KSB8CisJCQkJCWNtZC0+Y21uZFsxM107CisJ
CQl9IGVsc2UgaWYgKGNtZC0+Y21uZFswXSA9PSBXUklURV8xMikgeworCQkJCWNtbmRfbGJhID0g
KCh1NjQpY21kLT5jbW5kWzJdIDw8IDI0KSB8CisJCQkJCShjbWQtPmNtbmRbM10gPDwgMTYpIHwK
KwkJCQkJKGNtZC0+Y21uZFs0XSA8PCA4KSB8CisJCQkJCWNtZC0+Y21uZFs1XTsKKwkJCQljbW5k
X2NvdW50ID0gKGNtZC0+Y21uZFs2XSA8PCAyNCkgfAorCQkJCQkoY21kLT5jbW5kWzddIDw8IDE2
KSB8CisJCQkJCShjbWQtPmNtbmRbOF0gPDwgOCkgfAorCQkJCQljbWQtPmNtbmRbOV07CisJCQl9
IGVsc2UgaWYgKGNtZC0+Y21uZFswXSA9PSBXUklURV8xMCkgeworCQkJCWNtbmRfbGJhID0gKCh1
NjQpY21kLT5jbW5kWzJdIDw8IDI0KSB8CisJCQkJCShjbWQtPmNtbmRbM10gPDwgMTYpIHwKKwkJ
CQkJKGNtZC0+Y21uZFs0XSA8PCA4KSB8CisJCQkJCWNtZC0+Y21uZFs1XTsKKwkJCQljbW5kX2Nv
dW50ID0gKGNtZC0+Y21uZFs3XSA8PCA4KSB8CisJCQkJCWNtZC0+Y21uZFs4XTsKKwkJCX0gZWxz
ZQorCQkJCWNvbnRpbnVlOworCQkJaWYgKCgoY21uZF9sYmEgKyBjbW5kX2NvdW50KSA8IGxiYSkg
fHwKKwkJCSAgKGNvdW50ICYmICgobGJhICsgY291bnQpIDwgY21uZF9sYmEpKSkKKwkJCQljb250
aW51ZTsKIAkJCSsrYWN0aXZlOwogCQkJYnJlYWs7CiAJCX0KQEAgLTE2NzQsNyArMTcyMSw3IEBA
CiAJc3luY2hyb25pemVjbWQtPmNvbW1hbmQgPSBjcHVfdG9fbGUzMihWTV9Db250YWluZXJDb25m
aWcpOwogCXN5bmNocm9uaXplY21kLT50eXBlID0gY3B1X3RvX2xlMzIoQ1RfRkxVU0hfQ0FDSEUp
OwogCXN5bmNocm9uaXplY21kLT5jaWQgPSBjcHVfdG9fbGUzMihzY21kX2lkKHNjc2ljbWQpKTsK
LQlzeW5jaHJvbml6ZWNtZC0+Y291bnQgPSAKKwlzeW5jaHJvbml6ZWNtZC0+Y291bnQgPQogCSAg
ICAgY3B1X3RvX2xlMzIoc2l6ZW9mKCgoc3RydWN0IGFhY19zeW5jaHJvbml6ZV9yZXBseSAqKU5V
TEwpLT5kYXRhKSk7CiAKIAkvKgpAQCAtMTY5Niw3ICsxNzQzLDcgQEAKIAkJcmV0dXJuIDA7CiAJ
fQogCi0JcHJpbnRrKEtFUk5fV0FSTklORyAKKwlwcmludGsoS0VSTl9XQVJOSU5HCiAJCSJhYWNf
c3luY2hyb25pemU6IGFhY19maWJfc2VuZCBmYWlsZWQgd2l0aCBzdGF0dXM6ICVkLlxuIiwgc3Rh
dHVzKTsKIAlhYWNfZmliX2NvbXBsZXRlKGNtZF9maWJjb250ZXh0KTsKIAlhYWNfZmliX2ZyZWUo
Y21kX2ZpYmNvbnRleHQpOwo=

------_=_NextPart_001_01C7D054.DC80FC53--
