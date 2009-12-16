From: Clemens Fruhwirth <clemens@endorphin.org>
Subject: Re: [PATCH] Forcing SCSI capacity for broken SD Card readers
Date: Wed, 16 Dec 2009 17:51:34 +0100
Message-ID: <2f83750a0912160851u4279d39v6165a82f78d17b5c@mail.gmail.com>
References: <2f83750a0910141408m44082639m13cb0bfdb5cbd5cb@mail.gmail.com>
	 <2f83750a0910141413s58df3658k5ed170541e637f1e@mail.gmail.com>
	 <da824cf30910141629m1c30521ftd6ee2ed9970a0edb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001485f7d6e8bcc235047adb51fa
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:41661 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZLPQvh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2009 11:51:37 -0500
Received: by fxm21 with SMTP id 21so1086729fxm.21
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2009 08:51:35 -0800 (PST)
In-Reply-To: <da824cf30910141629m1c30521ftd6ee2ed9970a0edb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: linux-scsi@vger.kernel.org

--001485f7d6e8bcc235047adb51fa
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2009 at 1:29 AM, Grant Grundler <grundler@google.com> wrote=
:
> On Wed, Oct 14, 2009 at 2:13 PM, Clemens Fruhwirth
> <clemens@endorphin.org> wrote:
>> Short: Attached is an incomplete patch that allows user space to force
>> the capacity of an scsi device to a specific value. Any not over
>> my-dead-body objections with that?
>
> No major objection - just the usual nits:
> Why not make /sys/block/sdX/size writeable?
> =C2=A0 =C2=A0(instead of adding an ioctl())

Oh, I like that. Sorry it took me so long to reply. It turned out that
this is a much better idea. The value that is printed when reading the
size attribute is to the value that I set in my patch indirectly
through set_capacity. So, making size writable replaces that totally.

Patch attached.

> After reading the wiki page[1], my impression is that the block size
> gets reported wrong and thus the total capacity is miscalculated for
> 1GB-4GB SD cards with 1024 or 2048 byte blocks. Two questions around this=
:
> a) Does the host need to know the correct block size for correct operatio=
n?

>From experiments it does not look like that's the case. This is
surprising though, as one would suspect the card not to  function
properly otherwise. Frankly speaking, I have not looked down the
calling chain, especially how usb-storage treats these blocks, but I'd
say not at all. Seems like the USB reader, I have, just doesn't get
the capacity right, by not considering BLOCK_LEN > 512.

> b) Do the devices report which SD Card Association spec they are complian=
t
> =C2=A0 with in the USB headers?
>
> I'm asking (b) to start the conversation about if it's feasible to
> auto-detect this in the kernel and spare all the distro's from having
> to frob the device size.
>
> If we can autodetect this case, *and* the device has a valid FAT
> partition, it should be trivial
> to use the FAT partition info instead of what the USB card reader is
> reporting. Partitioning
> a new card will probably still need "size" to be writable.

I'm sorry, I can't really answer (b).

Autofixing this doesn't seem possible to me (except for the partition
trick) as the capacity =3D BLOCK_LEN * BLOCKS. If BLOCK_LEN isn't
detected correctly, we can't distinguish a 1GB from 2GB card.

Best Regards,
--=20
Fruhwirth Clemens http://clemens.endorphin.org

--001485f7d6e8bcc235047adb51fa
Content-Type: application/octet-stream; name="size-setter.patch"
Content-Disposition: attachment; filename="size-setter.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3acaakl0

LS0tIGxpbnV4LTIuNi4zMi9ibG9jay9nZW5oZC5jCTIwMDktMTItMDMgMDQ6NTE6MjEuMDAwMDAw
MDAwICswMTAwCisrKyBsaW51eC0yLjYuMzItcGF0Y2hlZC9ibG9jay9nZW5oZC5jCTIwMDktMTIt
MTUgMDg6NDk6MzEuNjA4OTU5MDM4ICswMTAwCkBAIC04NjUsNyArODY1LDcgQEAKIHN0YXRpYyBE
RVZJQ0VfQVRUUihleHRfcmFuZ2UsIFNfSVJVR08sIGRpc2tfZXh0X3JhbmdlX3Nob3csIE5VTEwp
Owogc3RhdGljIERFVklDRV9BVFRSKHJlbW92YWJsZSwgU19JUlVHTywgZGlza19yZW1vdmFibGVf
c2hvdywgTlVMTCk7CiBzdGF0aWMgREVWSUNFX0FUVFIocm8sIFNfSVJVR08sIGRpc2tfcm9fc2hv
dywgTlVMTCk7Ci1zdGF0aWMgREVWSUNFX0FUVFIoc2l6ZSwgU19JUlVHTywgcGFydF9zaXplX3No
b3csIE5VTEwpOworc3RhdGljIERFVklDRV9BVFRSKHNpemUsIFNfSVJVR08gfCBTX0lXVVNSLCBw
YXJ0X3NpemVfc2hvdywgcGFydF9zaXplX3NldCk7CiBzdGF0aWMgREVWSUNFX0FUVFIoYWxpZ25t
ZW50X29mZnNldCwgU19JUlVHTywgZGlza19hbGlnbm1lbnRfb2Zmc2V0X3Nob3csIE5VTEwpOwog
c3RhdGljIERFVklDRV9BVFRSKGNhcGFiaWxpdHksIFNfSVJVR08sIGRpc2tfY2FwYWJpbGl0eV9z
aG93LCBOVUxMKTsKIHN0YXRpYyBERVZJQ0VfQVRUUihzdGF0LCBTX0lSVUdPLCBwYXJ0X3N0YXRf
c2hvdywgTlVMTCk7Ci0tLSBsaW51eC0yLjYuMzIvZnMvcGFydGl0aW9ucy9jaGVjay5jCTIwMDkt
MTItMDMgMDQ6NTE6MjEuMDAwMDAwMDAwICswMTAwCisrKyBsaW51eC0yLjYuMzItcGF0Y2hlZC9m
cy9wYXJ0aXRpb25zL2NoZWNrLmMJMjAwOS0xMi0xNSAwODo0OTowMS4wNjM0NjU4MTkgKzAxMDAK
QEAgLTIxOSw2ICsyMTksMTkgQEAKIAlyZXR1cm4gc3ByaW50ZihidWYsICIlbGx1XG4iLCh1bnNp
Z25lZCBsb25nIGxvbmcpcC0+bnJfc2VjdHMpOwogfQogCitzc2l6ZV90IHBhcnRfc2l6ZV9zZXQo
c3RydWN0IGRldmljZSAqZGV2LAorCQkgICAgICBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0
ciwgY2hhciAqYnVmLCBzaXplX3QgbGVuKQoreworCXN0cnVjdCBoZF9zdHJ1Y3QgKnAgPSBkZXZf
dG9fcGFydChkZXYpOworCWNoYXIgKmVuZHA7CisJdW5zaWduZWQgbG9uZyBsb25nIHZhbCA9IHNp
bXBsZV9zdHJ0b3VsbChidWYsICZlbmRwLCAxMCk7CisJaWYgKGVuZHAgPT0gYnVmKQorCQlyZXR1
cm4gLUVJTlZBTDsKKwkKKwlwLT5ucl9zZWN0cyA9IHZhbDsKKwlyZXR1cm4gbGVuOworfQorCiBz
c2l6ZV90IHBhcnRfYWxpZ25tZW50X29mZnNldF9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwKIAkJ
CQkgICBzdHJ1Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKQogewotLS0gbGlu
dXgtMi42LjMyL2luY2x1ZGUvbGludXgvZ2VuaGQuaAkyMDA5LTEyLTAzIDA0OjUxOjIxLjAwMDAw
MDAwMCArMDEwMAorKysgbGludXgtMi42LjMyLXBhdGNoZWQvaW5jbHVkZS9saW51eC9nZW5oZC5o
CTIwMDktMTItMTUgMDk6MTg6NDQuNzkzMDg4Nzc4ICswMTAwCkBAIC01NDksNiArNTQ5LDggQEAK
IAogZXh0ZXJuIHNzaXplX3QgcGFydF9zaXplX3Nob3coc3RydWN0IGRldmljZSAqZGV2LAogCQkJ
ICAgICAgc3RydWN0IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsIGNoYXIgKmJ1Zik7CitleHRlcm4g
c3NpemVfdCBwYXJ0X3NpemVfc2V0KHN0cnVjdCBkZXZpY2UgKmRldiwKKwkJCSAgICAgc3RydWN0
IGRldmljZV9hdHRyaWJ1dGUgKmF0dHIsIGNoYXIgKmJ1Ziwgc2l6ZV90IGxlbik7CiBleHRlcm4g
c3NpemVfdCBwYXJ0X3N0YXRfc2hvdyhzdHJ1Y3QgZGV2aWNlICpkZXYsCiAJCQkgICAgICBzdHJ1
Y3QgZGV2aWNlX2F0dHJpYnV0ZSAqYXR0ciwgY2hhciAqYnVmKTsKIGV4dGVybiBzc2l6ZV90IHBh
cnRfaW5mbGlnaHRfc2hvdyhzdHJ1Y3QgZGV2aWNlICpkZXYsCg==
--001485f7d6e8bcc235047adb51fa--
