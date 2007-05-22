From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: apply commit config for reset_devices flag
Date: Tue, 22 May 2007 09:32:29 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF019E18B5@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C79C75.A581E26C"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:43660 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779AbXEVNcc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 May 2007 09:32:32 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 38ABF1A9DB6
	for <linux-scsi@vger.kernel.org>; Tue, 22 May 2007 06:32:31 -0700 (PDT)
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C79C75.A581E26C
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Under some conditions associated with the unclean transition to kdump,
the aacraid adapters will view the array as foreign and not export it to
prevent access and data manipulation. The solution is to submit a commit
configuration to export the devices since this is a expected behavior
when transitioning to a kdump kernel.

This patch adds the aacraid.reset_devices flag and when either this or
the global reset_devices flag is set, ensures that a commit config is
issued and extends the startup_timeout if it is set less than 5 minutes.

This attached patch is against current scsi-misc-2.6 and was unit tested
on RHEL5 and 2.6.22. This is a bugfix, so this patch needs to propagate
quickly.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Salyzyn, Mark=20
Sent: Wednesday, May 16, 2007 10:41 AM
To: 'vgoyal@in.ibm.com'
Subject: RE: System does not boot if booted with "reset_devices"

Vivek, could you please try the enclosed patch.

This patch adds the aacraid.reset_devices flag and when either this or
the global reset_devices flag is set, ensures that a commit config is
issued and extends the startup_timeout if it is set less than 5 minutes.
IF you are satisfied with this, I will submit it to the scsi list.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Vivek Goyal [mailto:vgoyal@in.ibm.com]=20
> Sent: Wednesday, May 16, 2007 1:31 AM
> To: Salyzyn, Mark
> Subject: Re: System does not boot if booted with "reset_devices"
>=20
>=20
> On Tue, May 15, 2007 at 12:51:06PM -0400, Salyzyn, Mark wrote:
> > Been tossing it around here, and it appears I am the only=20
> person that
> > considers this a risk to do a forced commit config in this=20
> scenario. I
> > will send you a patch later that does this (basically=20
> export commit from
> > aachba.c, and set it to a value of one if we had to reset=20
> the adapter
> > during the initialization, but I will have to make sure I=20
> resolve all
> > symbol name overlaps etc, so not a simple task; and few=20
> minutes left in
> > my day to work on this).
> >=20
>=20
> Thanks Mark. I am waiting for your patch. :-)
>=20
> Thanks
> Vivek
>=20

------_=_NextPart_001_01C79C75.A581E26C
Content-Type: application/octet-stream;
	name="aacraid_commit_reset.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_commit_reset.patch
Content-Disposition: attachment;
	filename="aacraid_commit_reset.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9hYWNoYmEuYyBiL2RyaXZlcnMvc2NzaS9h
YWNyYWlkL2FhY2hiYS5jCi0tLSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY2hiYS5jCTIwMDct
MDUtMTYgMTA6Mjk6MjUuNjk3NzM1MzY3IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlk
L2FhY2hiYS5jCTIwMDctMDUtMTYgMTA6Mzc6MzMuNTM3MTI4NDg1IC0wNDAwCkBAIC0xNDYsNyAr
MTQ2LDcgQEAKIHN0YXRpYyBpbnQgbm9uZGFzZCA9IC0xOwogc3RhdGljIGludCBkYWNtb2RlID0g
LTE7CiAKLXN0YXRpYyBpbnQgY29tbWl0ID0gLTE7CitpbnQgYWFjX2NvbW1pdCA9IC0xOwogaW50
IHN0YXJ0dXBfdGltZW91dCA9IDE4MDsKIGludCBhaWZfdGltZW91dCA9IDEyMDsKIApAQCAtMTU0
LDcgKzE1NCw3IEBACiBNT0RVTEVfUEFSTV9ERVNDKG5vbmRhc2QsICJDb250cm9sIHNjYW5uaW5n
IG9mIGhiYSBmb3Igbm9uZGFzZCBkZXZpY2VzLiAwPW9mZiwgMT1vbiIpOwogbW9kdWxlX3BhcmFt
KGRhY21vZGUsIGludCwgU19JUlVHT3xTX0lXVVNSKTsKIE1PRFVMRV9QQVJNX0RFU0MoZGFjbW9k
ZSwgIkNvbnRyb2wgd2hldGhlciBkbWEgYWRkcmVzc2luZyBpcyB1c2luZyA2NCBiaXQgREFDLiAw
PW9mZiwgMT1vbiIpOwotbW9kdWxlX3BhcmFtKGNvbW1pdCwgaW50LCBTX0lSVUdPfFNfSVdVU1Ip
OworbW9kdWxlX3BhcmFtX25hbWVkKGNvbW1pdCwgYWFjX2NvbW1pdCwgaW50LCBTX0lSVUdPfFNf
SVdVU1IpOwogTU9EVUxFX1BBUk1fREVTQyhjb21taXQsICJDb250cm9sIHdoZXRoZXIgYSBDT01N
SVRfQ09ORklHIGlzIGlzc3VlZCB0byB0aGUgYWRhcHRlciBmb3IgZm9yZWlnbiBhcnJheXMuXG5U
aGlzIGlzIHR5cGljYWxseSBuZWVkZWQgaW4gc3lzdGVtcyB0aGF0IGRvIG5vdCBoYXZlIGEgQklP
Uy4gMD1vZmYsIDE9b24iKTsKIG1vZHVsZV9wYXJhbShzdGFydHVwX3RpbWVvdXQsIGludCwgU19J
UlVHT3xTX0lXVVNSKTsKIE1PRFVMRV9QQVJNX0RFU0Moc3RhcnR1cF90aW1lb3V0LCAiVGhlIGR1
cmF0aW9uIG9mIHRpbWUgaW4gc2Vjb25kcyB0byB3YWl0IGZvciBhZGFwdGVyIHRvIGhhdmUgaXQn
cyBrZXJuZWwgdXAgYW5kXG5ydW5uaW5nLiBUaGlzIGlzIHR5cGljYWxseSBhZGp1c3RlZCBmb3Ig
bGFyZ2Ugc3lzdGVtcyB0aGF0IGRvIG5vdCBoYXZlIGEgQklPUy4iKTsKQEAgLTE3Myw2ICsxNzMs
OSBAQAogbW9kdWxlX3BhcmFtKGV4cG9zZV9waHlzaWNhbHMsIGludCwgU19JUlVHT3xTX0lXVVNS
KTsKIE1PRFVMRV9QQVJNX0RFU0MoZXhwb3NlX3BoeXNpY2FscywgIkV4cG9zZSBwaHlzaWNhbCBj
b21wb25lbnRzIG9mIHRoZSBhcnJheXMuIC0xPXByb3RlY3QgMD1vZmYsIDE9b24iKTsKIAoraW50
IGFhY19yZXNldF9kZXZpY2VzID0gMDsKK21vZHVsZV9wYXJhbV9uYW1lZChyZXNldF9kZXZpY2Vz
LCBhYWNfcmVzZXRfZGV2aWNlcywgaW50LCBTX0lSVUdPfFNfSVdVU1IpOworTU9EVUxFX1BBUk1f
REVTQyhyZXNldF9kZXZpY2VzLCAiRm9yY2UgYW4gYWRhcHRlciByZXNldCBhdCBpbml0aWFsaXph
dGlvbi4iKTsKIAogc3RhdGljIGlubGluZSBpbnQgYWFjX3ZhbGlkX2NvbnRleHQoc3RydWN0IHNj
c2lfY21uZCAqc2NzaWNtZCwKIAkJc3RydWN0IGZpYiAqZmlicHRyKSB7CkBAIC0yNDYsNyArMjQ5
LDcgQEAKIAlhYWNfZmliX2NvbXBsZXRlKGZpYnB0cik7CiAJLyogU2VuZCBhIENUX0NPTU1JVF9D
T05GSUcgdG8gZW5hYmxlIGRpc2NvdmVyeSBvZiBkZXZpY2VzICovCiAJaWYgKHN0YXR1cyA+PSAw
KSB7Ci0JCWlmICgoY29tbWl0ID09IDEpIHx8IGNvbW1pdF9mbGFnKSB7CisJCWlmICgoYWFjX2Nv
bW1pdCA9PSAxKSB8fCBjb21taXRfZmxhZykgewogCQkJc3RydWN0IGFhY19jb21taXRfY29uZmln
ICogZGluZm87CiAJCQlhYWNfZmliX2luaXQoZmlicHRyKTsKIAkJCWRpbmZvID0gKHN0cnVjdCBh
YWNfY29tbWl0X2NvbmZpZyAqKSBmaWJfZGF0YShmaWJwdHIpOwpAQCAtMjYxLDcgKzI2NCw3IEBA
CiAJCQkJICAgIDEsIDEsCiAJCQkJICAgIE5VTEwsIE5VTEwpOwogCQkJYWFjX2ZpYl9jb21wbGV0
ZShmaWJwdHIpOwotCQl9IGVsc2UgaWYgKGNvbW1pdCA9PSAwKSB7CisJCX0gZWxzZSBpZiAoYWFj
X2NvbW1pdCA9PSAwKSB7CiAJCQlwcmludGsoS0VSTl9XQVJOSU5HCiAJCQkgICJhYWNfZ2V0X2Nv
bmZpZ19zdGF0dXM6IEZvcmVpZ24gZGV2aWNlIGNvbmZpZ3VyYXRpb25zIGFyZSBiZWluZyBpZ25v
cmVkXG4iKTsKIAkJfQpkaWZmIC1ydSBhL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY3JhaWQuaCBi
L2RyaXZlcnMvc2NzaS9hYWNyYWlkL2FhY3JhaWQuaAotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFp
ZC9hYWNyYWlkLmgJMjAwNy0wNS0xNiAxMDoyOToyNS42OTc3MzUzNjcgLTA0MDAKKysrIGIvZHJp
dmVycy9zY3NpL2FhY3JhaWQvYWFjcmFpZC5oCTIwMDctMDUtMTYgMTA6Mzc6MzMuNTM4MTI4MzU0
IC0wNDAwCkBAIC0xODI5LDMgKzE4MjksNSBAQAogZXh0ZXJuIGludCBzdGFydHVwX3RpbWVvdXQ7
CiBleHRlcm4gaW50IGFpZl90aW1lb3V0OwogZXh0ZXJuIGludCBleHBvc2VfcGh5c2ljYWxzOwor
ZXh0ZXJuIGludCBhYWNfcmVzZXRfZGV2aWNlczsKK2V4dGVybiBpbnQgYWFjX2NvbW1pdDsKZGlm
ZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQv
cnguYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jCTIwMDctMDUtMTYgMTA6Mjk6MjUu
Njk5NzM1MTEzIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMJMjAwNy0wNS0x
NiAxMDozNzozMy41MzkxMjgyMjMgLTA0MDAKQEAgLTQ4OCw2ICs0ODgsOCBAQAogCQlyZXR1cm4g
LUVJTlZBTDsKIAlpZiAocnhfcmVhZGwoZGV2LCBNVW5pdC5PTVJ4WzBdKSAmIEtFUk5FTF9QQU5J
QykKIAkJcmV0dXJuIC1FTk9ERVY7CisJaWYgKHN0YXJ0dXBfdGltZW91dCA8IDMwMCkKKwkJc3Rh
cnR1cF90aW1lb3V0ID0gMzAwOwogCXJldHVybiAwOwogfQogCkBAIC01NDIsNyArNTQ0LDcgQEAK
IAlkZXYtPmFfb3BzLmFkYXB0ZXJfc3luY19jbWQgPSByeF9zeW5jX2NtZDsKIAlkZXYtPmFfb3Bz
LmFkYXB0ZXJfZW5hYmxlX2ludCA9IGFhY19yeF9kaXNhYmxlX2ludGVycnVwdDsKIAlkZXYtPk9J
TVIgPSBzdGF0dXMgPSByeF9yZWFkYiAoZGV2LCBNVW5pdC5PSU1SKTsKLQlpZiAoKCgoc3RhdHVz
ICYgMHgwYykgIT0gMHgwYykgfHwgcmVzZXRfZGV2aWNlcykgJiYKKwlpZiAoKCgoc3RhdHVzICYg
MHgwYykgIT0gMHgwYykgfHwgYWFjX3Jlc2V0X2RldmljZXMgfHwgcmVzZXRfZGV2aWNlcykgJiYK
IAkgICFhYWNfcnhfcmVzdGFydF9hZGFwdGVyKGRldiwgMCkpCiAJCSsrcmVzdGFydDsKIAkvKgpA
QCAtNTk0LDYgKzU5Niw4IEBACiAJCX0KIAkJbXNsZWVwKDEpOwogCX0KKwlpZiAocmVzdGFydCkK
KwkJYWFjX2NvbW1pdCA9IDE7CiAJLyoKIAkgKglGaWxsIGluIHRoZSBjb21tb24gZnVuY3Rpb24g
ZGlzcGF0Y2ggdGFibGUuCiAJICovCg==

------_=_NextPart_001_01C79C75.A581E26C--
