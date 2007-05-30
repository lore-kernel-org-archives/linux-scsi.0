From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: kexec and aacraid broken
Date: Wed, 30 May 2007 07:44:02 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01A54FB1@otce2k301.adaptec.com>
References: <20070529191347.9b1edd8b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7A2AF.D6DDC3FE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:50497 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbXE3LoQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 07:44:16 -0400
Content-class: urn:content-classes:message
In-reply-to: <20070529191347.9b1edd8b.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7A2AF.D6DDC3FE
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

I believe this issue is a result of the aacraid_commit_reset patch (as
posted for scsi-misc-2.6, enclosed to permit testing) not yet propagated
to the 2.6.22-rc3 tree.

This is the adapter taking longer than 3 minutes to start after a reset.
I seriously doubt either of these patches suggested below will have an
affect. And if they do, they are not root cause, one reduces the chances
that the card will be reset during initialization (thus applied would
likely mitigate this problem), the other prevents a panic when the
Adapter is reset (removed, would result in dogs and cats sleeping with
each other).

Please use kernel parameter aacraid.startup_timeout=3D540 (merely larger
than the default 180 seconds) when spawning the kexec or see if the
aacraid_commit_reset.patch resolves the issue to confirm my hunch.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]=20
> Sent: Tuesday, May 29, 2007 10:14 PM
> To: Yinghai Lu
> Cc: Vivek Goyal; Eric W. Biederman; AACRAID; Linux Kernel=20
> Mailing List; linux-scsi@vger.kernel.org; Michal Piotrowski
> Subject: Re: kexec and aacraid broken
>=20
>=20
> On Tue, 29 May 2007 18:59:32 -0700 "Yinghai Lu"=20
> <yhlu.kernel@gmail.com> wrote:
>=20
> > latest tree, can not use kexec to load 2.6.22-rc3 at least.
> >=20
> > got:
> >=20
> > AAC0: adapter kernel panic'd fffffffd
> > AAC0: adapter kernel failed to start, init status=3D0
>=20
> One of the two diffs below, I guess.  Please do a `patch -R=20
> -p1' of this
> email and retest?
>=20
> >=20
> > but can load 2.6.21.3
> >=20
>=20
> Michal, can you please add this to the regression list?
>=20
>=20
>=20
>=20
> commit 9e4d4a5d71d673901d9c1df5146ce545c2cc0cc0
> Author: Salyzyn, Mark <mark_salyzyn@adaptec.com>
> Date:   Tue May 1 11:43:06 2007 -0400
>=20
>     [SCSI] aacraid: superfluous adapter reset for IBM 8=20
> series ServeRAID controllers
>    =20
>     The kexec patch introduced a superfluous (and otherwise=20
> inert) reset of
>     some adapters. The register can have a hardware default=20
> value that has
>     zeros for the undefined interrupts. This patch refines=20
> the test of the
>     interrupt enable register to focus on only the interrupts=20
> that affect
>     the driver in order to detect if an incomplete shutdown=20
> of the Adapter
>     had occurred (kdump).
>    =20
>     Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>     Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
>=20
> diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
> index b6ee3c0..291cd14 100644
> --- a/drivers/scsi/aacraid/rx.c
> +++ b/drivers/scsi/aacraid/rx.c
> @@ -542,7 +542,7 @@ int _aac_rx_init(struct aac_dev *dev)
>  	dev->a_ops.adapter_sync_cmd =3D rx_sync_cmd;
>  	dev->a_ops.adapter_enable_int =3D aac_rx_disable_interrupt;
>  	dev->OIMR =3D status =3D rx_readb (dev, MUnit.OIMR);
> -	if ((((status & 0xff) !=3D 0xff) || reset_devices) &&
> +	if ((((status & 0x0c) !=3D 0x0c) || reset_devices) &&
>  	  !aac_rx_restart_adapter(dev, 0))
>  		++restart;
>  	/*
> commit a5694ec545a880f9d23463fddc894f5096cc68fa
> Author: Salyzyn, Mark <mark_salyzyn@adaptec.com>
> Date:   Mon Apr 30 13:22:24 2007 -0400
>=20
>     [SCSI] aacraid: kexec fix (reset interrupt handler)
>    =20
>     Another layer on this onion also discovered by Duane, the
>     interrupt enable handler also needed to be set ... The=20
> interrupt enable
>     was called from within the synchronous command handler.
>    =20
>     Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>     Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
>=20
> diff --git a/drivers/scsi/aacraid/rx.c b/drivers/scsi/aacraid/rx.c
> index 0c71315..b6ee3c0 100644
> --- a/drivers/scsi/aacraid/rx.c
> +++ b/drivers/scsi/aacraid/rx.c
> @@ -539,6 +539,8 @@ int _aac_rx_init(struct aac_dev *dev)
>  	}
> =20
>  	/* Failure to reset here is an option ... */
> +	dev->a_ops.adapter_sync_cmd =3D rx_sync_cmd;
> +	dev->a_ops.adapter_enable_int =3D aac_rx_disable_interrupt;
>  	dev->OIMR =3D status =3D rx_readb (dev, MUnit.OIMR);
>  	if ((((status & 0xff) !=3D 0xff) || reset_devices) &&
>  	  !aac_rx_restart_adapter(dev, 0))
>=20
>=20

------_=_NextPart_001_01C7A2AF.D6DDC3FE
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

------_=_NextPart_001_01C7A2AF.D6DDC3FE--
