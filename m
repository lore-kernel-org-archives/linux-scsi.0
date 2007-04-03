From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: [Fastboot] Panics for AACRAIDdriverduring'insmod' for kexec test [take 5]
Date: Tue, 3 Apr 2007 12:14:09 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF017AA276@otce2k301.adaptec.com>
References: <1175616594.3645.26.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7760B.1CD40CA0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:56206 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbXDCQOM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Apr 2007 12:14:12 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1175616594.3645.26.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Judith Lebzelter <judith@linux-foundation.org>, vgoyal@in.ibm.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7760B.1CD40CA0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Dropped the portion of the diff with references to sa.c.

Attached is the patch I feel will address this interrupt issue. As an =
added 'perk' I have also added the code to detect if the controller was =
previously initialized for interrupted operations by ANY operating =
system should the reset_devices kernel parameter not be set and we are =
dealing with a na=EFve kexec without the addition of this kernel =
parameter. The reset handler is also improved. Related to reset =
operations, but not pertinent specifically to this issue, I have also =
altered the handling somewhat so that we reset the adapter if we feel it =
is taking too long (three minutes) to start up.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's =
handling of patches.

This attached patch is against current scsi-misc-2.6 MINUS the initial =
version of this patch and the first patch that sets the missing platform =
function related to this discussion.
=20
Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

---

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]=20
> Sent: Tuesday, April 03, 2007 12:10 PM
> To: Salyzyn, Mark
> Cc: Judith Lebzelter; vgoyal@in.ibm.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] aacraid: [Fastboot] Panics for=20
> AACRAIDdriverduring'insmod' for kexec test [take 4]
>=20
>=20
> On Tue, 2007-04-03 at 11:58 -0400, Salyzyn, Mark wrote:
> > I will do you one better, James, I will slip in a little cleanup in
> > sa.c (support file for the old PPC based ARC cards) where I=20
> discovered
> > the restart platform function was ALSO left unset which could result
> > in similar pain of null pointer discovery.
>=20
> Actually, for 2.6.21-rc5 could I just have the two strict bug=20
> fixes for
> the potential oops you spotted ...  I should really be adding feature
> changes or cleanups at this stage of the kernel release.
>=20
> I can put all the rest into scsi-misc for post 2.6.21
>=20
> Thanks,
>=20
> James
>=20
>=20
>=20

------_=_NextPart_001_01C7760B.1CD40CA0
Content-Type: application/octet-stream;
	name="aacraid_kexec_5.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_kexec_5.patch
Content-Disposition: attachment;
	filename="aacraid_kexec_5.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jIGIvZHJpdmVycy9zY3NpL2FhY3Jh
aWQvcnguYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jCTIwMDctMDQtMDMgMTE6MzE6
NDAuMjg4MTE0MzY1IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMJMjAwNy0w
NC0wMyAxMTozNDoxMi41NjA4NzM1MzAgLTA0MDAKQEAgLTQ2NywxNiArNDY3LDE5IEBACiAJaWYg
KGJsZWQpCiAJCXByaW50ayhLRVJOX0VSUiAiJXMlZDogYWRhcHRlciBrZXJuZWwgcGFuaWMnZCAl
eC5cbiIsCiAJCQlkZXYtPm5hbWUsIGRldi0+aWQsIGJsZWQpOwotCWVsc2UKKwllbHNlIHsKIAkJ
YmxlZCA9IGFhY19hZGFwdGVyX3N5bmNfY21kKGRldiwgSU9QX1JFU0VUX0FMV0FZUywKIAkJICAw
LCAwLCAwLCAwLCAwLCAwLCAmdmFyLCBOVUxMLCBOVUxMLCBOVUxMLCBOVUxMKTsKLQlpZiAoYmxl
ZCkKKwkJaWYgKCFibGVkICYmICh2YXIgIT0gMHgwMDAwMDAwMSkpCisJCQlibGVkID0gLUVJTlZB
TDsKKwl9CisJaWYgKGJsZWQgJiYgKGJsZWQgIT0gLUVUSU1FRE9VVCkpCiAJCWJsZWQgPSBhYWNf
YWRhcHRlcl9zeW5jX2NtZChkZXYsIElPUF9SRVNFVCwKIAkJICAwLCAwLCAwLCAwLCAwLCAwLCAm
dmFyLCBOVUxMLCBOVUxMLCBOVUxMLCBOVUxMKTsKIAotCWlmIChibGVkKQorCWlmIChibGVkICYm
IChibGVkICE9IC1FVElNRURPVVQpKQogCQlyZXR1cm4gLUVJTlZBTDsKLQlpZiAodmFyID09IDB4
MzgwMzAwMEYpIHsgLyogVVNFX09USEVSX01FVEhPRCAqLworCWlmIChibGVkIHx8ICh2YXIgPT0g
MHgzODAzMDAwRikpIHsgLyogVVNFX09USEVSX01FVEhPRCAqLwogCQlyeF93cml0ZWwoZGV2LCBN
VW5pdC5yZXNlcnZlZDIsIDMpOwogCQltc2xlZXAoNTAwMCk7IC8qIERlbGF5IDUgc2Vjb25kcyAq
LwogCQl2YXIgPSAweDAwMDAwMDAxOwpAQCAtNTI2LDYgKzUyOSw3IEBACiB7CiAJdW5zaWduZWQg
bG9uZyBzdGFydDsKIAl1bnNpZ25lZCBsb25nIHN0YXR1czsKKwlpbnQgcmVzdGFydCA9IDA7CiAJ
aW50IGluc3RhbmNlID0gZGV2LT5pZDsKIAljb25zdCBjaGFyICogbmFtZSA9IGRldi0+bmFtZTsK
IApAQCAtNTM0LDE1ICs1MzgsMjEgQEAKIAkJZ290byBlcnJvcl9pb3VubWFwOwogCX0KIAorCS8q
IEZhaWx1cmUgdG8gcmVzZXQgaGVyZSBpcyBhbiBvcHRpb24gLi4uICovCisJZGV2LT5hX29wcy5h
ZGFwdGVyX3N5bmNfY21kID0gcnhfc3luY19jbWQ7CisJZGV2LT5hX29wcy5hZGFwdGVyX2VuYWJs
ZV9pbnQgPSBhYWNfcnhfZGlzYWJsZV9pbnRlcnJ1cHQ7CisJZGV2LT5PSU1SID0gc3RhdHVzID0g
cnhfcmVhZGIgKGRldiwgTVVuaXQuT0lNUik7CisJaWYgKCgoKHN0YXR1cyAmIDB4ZmYpICE9IDB4
ZmYpIHx8IHJlc2V0X2RldmljZXMpICYmCisJICAhYWFjX3J4X3Jlc3RhcnRfYWRhcHRlcihkZXYs
IDApKQorCQkrK3Jlc3RhcnQ7CiAJLyoKIAkgKglDaGVjayB0byBzZWUgaWYgdGhlIGJvYXJkIHBh
bmljJ2Qgd2hpbGUgYm9vdGluZy4KIAkgKi8KIAlzdGF0dXMgPSByeF9yZWFkbChkZXYsIE1Vbml0
Lk9NUnhbMF0pOwogCWlmIChzdGF0dXMgJiBLRVJORUxfUEFOSUMpIHsKLQkJaWYgKChzdGF0dXMg
PSBhYWNfcnhfY2hlY2tfaGVhbHRoKGRldikpIDw9IDApCi0JCQlnb3RvIGVycm9yX2lvdW5tYXA7
Ci0JCWlmIChhYWNfcnhfcmVzdGFydF9hZGFwdGVyKGRldiwgc3RhdHVzKSkKKwkJaWYgKGFhY19y
eF9yZXN0YXJ0X2FkYXB0ZXIoZGV2LCBhYWNfcnhfY2hlY2tfaGVhbHRoKGRldikpKQogCQkJZ290
byBlcnJvcl9pb3VubWFwOworCQkrK3Jlc3RhcnQ7CiAJfQogCS8qCiAJICoJQ2hlY2sgdG8gc2Vl
IGlmIHRoZSBib2FyZCBmYWlsZWQgYW55IHNlbGYgdGVzdHMuCkBAIC01NjUsMTEgKzU3NSwyMyBA
QAogCSAqLwogCXdoaWxlICghKChzdGF0dXMgPSByeF9yZWFkbChkZXYsIE1Vbml0Lk9NUnhbMF0p
KSAmIEtFUk5FTF9VUF9BTkRfUlVOTklORykpCiAJewotCQlpZih0aW1lX2FmdGVyKGppZmZpZXMs
IHN0YXJ0K3N0YXJ0dXBfdGltZW91dCpIWikpIHsKKwkJaWYgKChyZXN0YXJ0ICYmCisJCSAgKHN0
YXR1cyAmIChLRVJORUxfUEFOSUN8U0VMRl9URVNUX0ZBSUxFRHxNT05JVE9SX1BBTklDKSkpIHx8
CisJCSAgdGltZV9hZnRlcihqaWZmaWVzLCBzdGFydCtIWipzdGFydHVwX3RpbWVvdXQpKSB7CiAJ
CQlwcmludGsoS0VSTl9FUlIgIiVzJWQ6IGFkYXB0ZXIga2VybmVsIGZhaWxlZCB0byBzdGFydCwg
aW5pdCBzdGF0dXMgPSAlbHguXG4iLCAKIAkJCQkJZGV2LT5uYW1lLCBpbnN0YW5jZSwgc3RhdHVz
KTsKIAkJCWdvdG8gZXJyb3JfaW91bm1hcDsKIAkJfQorCQlpZiAoIXJlc3RhcnQgJiYKKwkJICAo
KHN0YXR1cyAmIChLRVJORUxfUEFOSUN8U0VMRl9URVNUX0ZBSUxFRHxNT05JVE9SX1BBTklDKSkg
fHwKKwkJICB0aW1lX2FmdGVyKGppZmZpZXMsIHN0YXJ0ICsgSFogKgorCQkgICgoc3RhcnR1cF90
aW1lb3V0ID4gNjApCisJCSAgICA/IChzdGFydHVwX3RpbWVvdXQgLSA2MCkKKwkJICAgIDogKHN0
YXJ0dXBfdGltZW91dCAvIDIpKSkpKSB7CisJCQlpZiAobGlrZWx5KCFhYWNfcnhfcmVzdGFydF9h
ZGFwdGVyKGRldiwgYWFjX3J4X2NoZWNrX2hlYWx0aChkZXYpKSkpCisJCQkJc3RhcnQgPSBqaWZm
aWVzOworCQkJKytyZXN0YXJ0OworCQl9CiAJCW1zbGVlcCgxKTsKIAl9CiAJLyoK

------_=_NextPart_001_01C7760B.1CD40CA0--
