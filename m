From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: [Fastboot] Panics for AACRAID driverduring'insmod' for kexec test [take 4]
Date: Tue, 3 Apr 2007 11:58:17 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF017AA267@otce2k301.adaptec.com>
References: <1175611901.3645.3.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C77608.E6891A90"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:55195 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbXDCP6W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Apr 2007 11:58:22 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1175611901.3645.3.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Judith Lebzelter <judith@linux-foundation.org>, vgoyal@in.ibm.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C77608.E6891A90
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

I will do you one better, James, I will slip in a little cleanup in sa.c =
(support file for the old PPC based ARC cards) where I discovered the =
restart platform function was ALSO left unset which could result in =
similar pain of null pointer discovery.

Please note: The issue Judith ran into, where the card took longer than =
3 minutes to initialize because of a problem drive may require the =
extension of the timeout to address (insmod parameter =
aacraid.startup_timeout=3D540 may do the trick). Extending the timeout =
may have been a fact of life given that the restart of the adapter =
normally occurs on BIOS load long before the driver instantiates =
settling the problem drives; if this is the case a small and lower =
priority follow-up hardening patch can help the users that find adding =
the insmod parameter repugnant in order to support kexec and kdump in =
the face of problem drives. Problem drives may have lead to the need to =
get a kernel dump ...

You will find enclosed the pristine patch based on the initial patch, =
dropping the static function, and adding the three missing platform =
function initializations.

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
> Sent: Tuesday, April 03, 2007 10:52 AM
> To: Salyzyn, Mark
> Cc: Judith Lebzelter; vgoyal@in.ibm.com
> Subject: RE: [PATCH] aacraid: [Fastboot] Panics for AACRAID=20
> driverduring'insmod' for kexec test.
>=20
>=20
> On Tue, 2007-04-03 at 09:30 -0400, Salyzyn, Mark wrote:
> > 0x48 status code means the Firmware is trying to boot the=20
> Kernel. This
> > phase is most likely blocked because of the hard drive=20
> failure as you
> > suspected; the kernel is not declared up and running until after the
> > drives have spun up, and a problem drive could be tricking=20
> the Firmware
> > into a recovery loop holding things back ...
>=20
> I'm constructing what I hope will be the last pre 2.6.21=20
> merge tree ...
> do you have a clean patch with the two necessary fixes for=20
> the panic you
> can send to the list?
>=20
> James

------_=_NextPart_001_01C77608.E6891A90
Content-Type: application/octet-stream;
	name="aacraid_kexec_4.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_kexec_4.patch
Content-Disposition: attachment;
	filename="aacraid_kexec_4.patch"

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
aWVzOworCQkJKytyZXN0YXJ0OworCQl9CiAJCW1zbGVlcCgxKTsKIAl9CiAJLyoKZGlmZiAtcnUg
YS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9zYS5jIGIvZHJpdmVycy9zY3NpL2FhY3JhaWQvc2EuYwot
LS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9zYS5jCTIwMDctMDQtMDMgMTE6MTc6MzIuNzcwMTE3
MjQ5IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3NhLmMJMjAwNy0wNC0wMyAxMToz
NTozOS40Mjc4OTgzODEgLTA0MDAKQEAgLTUsNyArNSw3IEBACiAgKiBiYXNlZCBvbiB0aGUgb2xk
IGFhY3JhaWQgZHJpdmVyIHRoYXQgaXMuLgogICogQWRhcHRlYyBhYWNyYWlkIGRldmljZSBkcml2
ZXIgZm9yIExpbnV4LgogICoKLSAqIENvcHlyaWdodCAoYykgMjAwMCBBZGFwdGVjLCBJbmMuIChh
YWNyYWlkQGFkYXB0ZWMuY29tKQorICogQ29weXJpZ2h0IChjKSAyMDAwLTIwMDcgQWRhcHRlYywg
SW5jLiAoYWFjcmFpZEBhZGFwdGVjLmNvbSkKICAqCiAgKiBUaGlzIHByb2dyYW0gaXMgZnJlZSBz
b2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yIG1vZGlmeQogICogaXQgdW5k
ZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBhcyBwdWJsaXNo
ZWQgYnkKQEAgLTI1OCw2ICsyNTgsMTEgQEAKIAkJCU5VTEwsIE5VTEwsIE5VTEwsIE5VTEwsIE5V
TEwpOwogfQogCitzdGF0aWMgaW50IGFhY19zYV9yZXN0YXJ0X2FkYXB0ZXIoc3RydWN0IGFhY19k
ZXYgKmRldiwgaW50IGJsZWQpCit7CisJcmV0dXJuIC1FSU5WQUw7Cit9CisKIC8qKgogICoJYWFj
X3NhX2NoZWNrX2hlYWx0aAogICoJQGRldjogZGV2aWNlIHRvIGNoZWNrIGlmIGhlYWx0aHkKQEAg
LTM2Nyw2ICszNzIsNyBAQAogCWRldi0+YV9vcHMuYWRhcHRlcl9ub3RpZnkgPSBhYWNfc2Ffbm90
aWZ5X2FkYXB0ZXI7CiAJZGV2LT5hX29wcy5hZGFwdGVyX3N5bmNfY21kID0gc2Ffc3luY19jbWQ7
CiAJZGV2LT5hX29wcy5hZGFwdGVyX2NoZWNrX2hlYWx0aCA9IGFhY19zYV9jaGVja19oZWFsdGg7
CisJZGV2LT5hX29wcy5hZGFwdGVyX3Jlc3RhcnQgPSBhYWNfc2FfcmVzdGFydF9hZGFwdGVyOwog
CWRldi0+YV9vcHMuYWRhcHRlcl9pbnRyID0gYWFjX3NhX2ludHI7CiAJZGV2LT5hX29wcy5hZGFw
dGVyX2lvcmVtYXAgPSBhYWNfc2FfaW9yZW1hcDsKIAo=

------_=_NextPart_001_01C77608.E6891A90--
