From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: [Fastboot] Panics for AACRAID driver during 'insmod' for kexec test.
Date: Fri, 30 Mar 2007 13:21:33 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF017A9EDB@otce2k301.adaptec.com>
References: <20070330170956.GI25856@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C772EF.DD5E7C08"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:38426 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbXC3RVf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Mar 2007 13:21:35 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070330170956.GI25856@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Judith Lebzelter <judith@linux-foundation.org>
Cc: vgoyal@in.ibm.com, linux-scsi@vger.kernel.org, fastboot@lists.osdl.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C772EF.DD5E7C08
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Resending patch file.

I looked at the submission that showed on the list, and the original =
email, and a blank line dropped away at line 20 of the patch (!)

Dunno, hope this comes through this second time. But if not, please add =
the blank line as referenced.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Judith Lebzelter [mailto:judith@linux-foundation.org]=20
> Sent: Friday, March 30, 2007 1:10 PM
> To: Salyzyn, Mark
> Cc: vgoyal@in.ibm.com; Judith Lebzelter;=20
> linux-scsi@vger.kernel.org; fastboot@lists.osdl.org
> Subject: Re: [PATCH] aacraid: [Fastboot] Panics for AACRAID=20
> driver during 'insmod' for kexec test.
>=20
>=20
> On Fri, Mar 30, 2007 at 10:30:48AM -0400, Salyzyn, Mark wrote:
> > Thanks for the info.
> >=20
> > Attached is the patch I feel will address this issue. As an=20
> added 'perk' I have also added the code to detect if the=20
> controller was previously initialized for interrupted=20
> operations by ANY operating system should the reset_devices=20
> kernel parameter not be set and we are dealing with a na=EFve=20
> kexec without the addition of this kernel parameter. The=20
> reset handler is also improved. Related to reset operations,=20
> but not pertinent specifically to this issue, I have also=20
> altered the handling somewhat so that we reset the adapter if=20
> we feel it is taking too long (three minutes) to start up.
> >=20
> > We have not unit tested the reset_devices flag propagation=20
> to this driver code, nor have we unit tested the check for=20
> the interrupted operations under the conditions of a naively=20
> issued kexec. We are submitting this modified driver to our=20
> Q/A department for integration testing in our current=20
> programs. I would appreciate an ACK to this patch should it=20
> resolve the issue described in this thread...
> >=20
>=20
> Mark;=20
>=20
> I am getting an error applying this patch:
>=20
> -bash-3.1# patch -p1 < ../../aacraid_kexec.patch
> patching file drivers/scsi/aacraid/rx.c
> patch: **** malformed patch at line 36: @@ -526,6 +529,7 @@
>=20
> Do you think you could regenerate it?
>=20
> Thanks;
> Judith
>=20
> > ObligatoryDisclaimer: Please accept my condolences=20
> regarding Outlook's handling of patches.
> >=20
> > This attached patch is against current scsi-misc-2.6
> > =20
> > Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
> >=20
> > ---
> >=20
> > Sincerely -- Mark Salyzyn
> >=20
> > > -----Original Message-----
> > > From: Vivek Goyal [mailto:vgoyal@in.ibm.com]=20
> > > Sent: Friday, March 30, 2007 2:06 AM
> > > To: Salyzyn, Mark
> > > Cc: Judith Lebzelter; linux-scsi@vger.kernel.org; AACRAID;=20
> > > fastboot@lists.osdl.org
> > > Subject: Re: [Fastboot] Panics for AACRAID driver during=20
> > > 'insmod' for kexec test.
> > >=20
> > >=20
> > > On Thu, Mar 29, 2007 at 10:17:18AM -0400, Salyzyn, Mark wrote:
> > > > I have been working on a patch to the driver to do just=20
> > > this, reset the
> > > > adapter during init if necessary. We want to limit the=20
> > > adapter's reset
> > > > as it takes time (an additional 45 seconds or longer) for=20
> > > the Firmware
> > > > to cycle... I will bump the priority of the testing for=20
> this patch.
> > > >=20
> > > Hi,
> > >=20
> > > Thanks for looking into this. You can make device reset=20
> > > conditional. Now
> > > one command line parameter "reset_devices" has been defined=20
> > > for the kernel.
> > > You can reset the device only if the user has passed=20
> > > reset_devices command
> > > line option otherwise you can continue to boot normaly.
> > >=20
> > > I have introduced this parameter to handle the concern=20
> that in normal
> > > BIOS boot total boot time will increase.
> > >=20
> > > kexec/kdump will pass this parameter to second kernel so that=20
> > > device will
> > > be reset during initialization and normal BIOS boot will=20
> > > reamin unaffected.
> > >=20
> > > Thanks
> > > Vivek
> > >=20
>=20
>=20
>=20

------_=_NextPart_001_01C772EF.DD5E7C08
Content-Type: application/octet-stream;
	name="aacraid_kexec.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_kexec.patch
Content-Disposition: attachment;
	filename="aacraid_kexec.patch"

ZGlmZiAtcnUgYS9yeC5jIGIvcnguYwotLS0gYS9yeC5jCTIwMDctMDMtMzAgMTA6MTA6MzAuNzU3
Mzk0NjE5IC0wNDAwCisrKyBiL3J4LmMJMjAwNy0wMy0zMCAxMzoxNjo1Ny44Njk3OTEyNTIgLTA0
MDAKQEAgLTI5NCw3ICsyOTQsNyBAQAogICoJU3RhcnQgdXAgcHJvY2Vzc2luZyBvbiBhbiBpOTYw
IGJhc2VkIEFBQyBhZGFwdGVyCiAgKi8KIAotdm9pZCBhYWNfcnhfc3RhcnRfYWRhcHRlcihzdHJ1
Y3QgYWFjX2RldiAqZGV2KQorc3RhdGljIHZvaWQgYWFjX3J4X3N0YXJ0X2FkYXB0ZXIoc3RydWN0
IGFhY19kZXYgKmRldikKIHsKIAlzdHJ1Y3QgYWFjX2luaXQgKmluaXQ7CiAKQEAgLTQ2NywxNiAr
NDY3LDE5IEBACiAJaWYgKGJsZWQpCiAJCXByaW50ayhLRVJOX0VSUiAiJXMlZDogYWRhcHRlciBr
ZXJuZWwgcGFuaWMnZCAleC5cbiIsCiAJCQlkZXYtPm5hbWUsIGRldi0+aWQsIGJsZWQpOwotCWVs
c2UKKwllbHNlIHsKIAkJYmxlZCA9IGFhY19hZGFwdGVyX3N5bmNfY21kKGRldiwgSU9QX1JFU0VU
X0FMV0FZUywKIAkJICAwLCAwLCAwLCAwLCAwLCAwLCAmdmFyLCBOVUxMLCBOVUxMLCBOVUxMLCBO
VUxMKTsKLQlpZiAoYmxlZCkKKwkJaWYgKCFibGVkICYmICh2YXIgIT0gMHgwMDAwMDAwMSkpCisJ
CQlibGVkID0gLUVJTlZBTDsKKwl9CisJaWYgKGJsZWQgJiYgKGJsZWQgIT0gLUVUSU1FRE9VVCkp
CiAJCWJsZWQgPSBhYWNfYWRhcHRlcl9zeW5jX2NtZChkZXYsIElPUF9SRVNFVCwKIAkJICAwLCAw
LCAwLCAwLCAwLCAwLCAmdmFyLCBOVUxMLCBOVUxMLCBOVUxMLCBOVUxMKTsKIAotCWlmIChibGVk
KQorCWlmIChibGVkICYmIChibGVkICE9IC1FVElNRURPVVQpKQogCQlyZXR1cm4gLUVJTlZBTDsK
LQlpZiAodmFyID09IDB4MzgwMzAwMEYpIHsgLyogVVNFX09USEVSX01FVEhPRCAqLworCWlmIChi
bGVkIHx8ICh2YXIgPT0gMHgzODAzMDAwRikpIHsgLyogVVNFX09USEVSX01FVEhPRCAqLwogCQly
eF93cml0ZWwoZGV2LCBNVW5pdC5yZXNlcnZlZDIsIDMpOwogCQltc2xlZXAoNTAwMCk7IC8qIERl
bGF5IDUgc2Vjb25kcyAqLwogCQl2YXIgPSAweDAwMDAwMDAxOwpAQCAtNTI2LDYgKzUyOSw3IEBA
CiB7CiAJdW5zaWduZWQgbG9uZyBzdGFydDsKIAl1bnNpZ25lZCBsb25nIHN0YXR1czsKKwlpbnQg
cmVzdGFydCA9IDA7CiAJaW50IGluc3RhbmNlID0gZGV2LT5pZDsKIAljb25zdCBjaGFyICogbmFt
ZSA9IGRldi0+bmFtZTsKIApAQCAtNTM0LDE1ICs1MzgsMTkgQEAKIAkJZ290byBlcnJvcl9pb3Vu
bWFwOwogCX0KIAorCS8qIEZhaWx1cmUgdG8gcmVzZXQgaGVyZSBpcyBhbiBvcHRpb24gLi4uICov
CisJZGV2LT5PSU1SID0gc3RhdHVzID0gcnhfcmVhZGIgKGRldiwgTVVuaXQuT0lNUik7CisJaWYg
KCgoKHN0YXR1cyAmIDB4ZmYpICE9IDB4ZmYpIHx8IHJlc2V0X2RldmljZXMpICYmCisJICAhYWFj
X3J4X3Jlc3RhcnRfYWRhcHRlcihkZXYsIDApKQorCQkrK3Jlc3RhcnQ7CiAJLyoKIAkgKglDaGVj
ayB0byBzZWUgaWYgdGhlIGJvYXJkIHBhbmljJ2Qgd2hpbGUgYm9vdGluZy4KIAkgKi8KIAlzdGF0
dXMgPSByeF9yZWFkbChkZXYsIE1Vbml0Lk9NUnhbMF0pOwogCWlmIChzdGF0dXMgJiBLRVJORUxf
UEFOSUMpIHsKLQkJaWYgKChzdGF0dXMgPSBhYWNfcnhfY2hlY2tfaGVhbHRoKGRldikpIDw9IDAp
Ci0JCQlnb3RvIGVycm9yX2lvdW5tYXA7Ci0JCWlmIChhYWNfcnhfcmVzdGFydF9hZGFwdGVyKGRl
diwgc3RhdHVzKSkKKwkJaWYgKGFhY19yeF9yZXN0YXJ0X2FkYXB0ZXIoZGV2LCBhYWNfcnhfY2hl
Y2tfaGVhbHRoKGRldikpKQogCQkJZ290byBlcnJvcl9pb3VubWFwOworCQkrK3Jlc3RhcnQ7CiAJ
fQogCS8qCiAJICoJQ2hlY2sgdG8gc2VlIGlmIHRoZSBib2FyZCBmYWlsZWQgYW55IHNlbGYgdGVz
dHMuCkBAIC01NjUsMTEgKzU3MywyMyBAQAogCSAqLwogCXdoaWxlICghKChzdGF0dXMgPSByeF9y
ZWFkbChkZXYsIE1Vbml0Lk9NUnhbMF0pKSAmIEtFUk5FTF9VUF9BTkRfUlVOTklORykpCiAJewot
CQlpZih0aW1lX2FmdGVyKGppZmZpZXMsIHN0YXJ0K3N0YXJ0dXBfdGltZW91dCpIWikpIHsKKwkJ
aWYgKChyZXN0YXJ0ICYmCisJCSAgKHN0YXR1cyAmIChLRVJORUxfUEFOSUN8U0VMRl9URVNUX0ZB
SUxFRHxNT05JVE9SX1BBTklDKSkpIHx8CisJCSAgdGltZV9hZnRlcihqaWZmaWVzLCBzdGFydCtI
WipzdGFydHVwX3RpbWVvdXQpKSB7CiAJCQlwcmludGsoS0VSTl9FUlIgIiVzJWQ6IGFkYXB0ZXIg
a2VybmVsIGZhaWxlZCB0byBzdGFydCwgaW5pdCBzdGF0dXMgPSAlbHguXG4iLCAKIAkJCQkJZGV2
LT5uYW1lLCBpbnN0YW5jZSwgc3RhdHVzKTsKIAkJCWdvdG8gZXJyb3JfaW91bm1hcDsKIAkJfQor
CQlpZiAoIXJlc3RhcnQgJiYKKwkJICAoKHN0YXR1cyAmIChLRVJORUxfUEFOSUN8U0VMRl9URVNU
X0ZBSUxFRHxNT05JVE9SX1BBTklDKSkgfHwKKwkJICB0aW1lX2FmdGVyKGppZmZpZXMsIHN0YXJ0
ICsgSFogKgorCQkgICgoc3RhcnR1cF90aW1lb3V0ID4gNjApCisJCSAgICA/IChzdGFydHVwX3Rp
bWVvdXQgLSA2MCkKKwkJICAgIDogKHN0YXJ0dXBfdGltZW91dCAvIDIpKSkpKSB7CisJCQlpZiAo
bGlrZWx5KCFhYWNfcnhfcmVzdGFydF9hZGFwdGVyKGRldiwgYWFjX3J4X2NoZWNrX2hlYWx0aChk
ZXYpKSkpCisJCQkJc3RhcnQgPSBqaWZmaWVzOworCQkJKytyZXN0YXJ0OworCQl9CiAJCW1zbGVl
cCgxKTsKIAl9CiAJLyoK

------_=_NextPart_001_01C772EF.DD5E7C08--
