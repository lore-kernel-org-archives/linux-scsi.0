From: adam radford <aradford@gmail.com>
Subject: Re: [patch 2/6] drivers/scsi/megaraid.c: fix sparse warnings
Date: Tue, 10 Jan 2012 18:07:56 -0800
Message-ID: <CAHtARFFf3dHMVuC5OvOUUrWfLuv4ExsjMGqq7oawq9c_eMijnA@mail.gmail.com>
References: <20120110234230.58C9F20012E@hpza10.eem.corp.google.com>
	<CAHtARFFWhGpFDZ51JsSHQsXs02i4Pu4x4YUfM37JxvYLucH5Dg@mail.gmail.com>
	<1326245138.3264.121.camel@dabdike.int.hansenpartnership.com>
	<20120110174814.351384c1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6d7ea90a41d0204b637198d
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36074 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757035Ab2AKCH6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 21:07:58 -0500
Received: by werm1 with SMTP id m1so178920wer.19
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2012 18:07:56 -0800 (PST)
In-Reply-To: <20120110174814.351384c1.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, rdunlap@xenotime.net, megaraidlinux@lsi.com, viro@zeniv.linux.org.uk

--0016e6d7ea90a41d0204b637198d
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 10, 2012 at 5:48 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> Yes, it sounds like this is a day-one bug which we can't really fix
> now, with an acceptable level of effort or risk. =A0I agree that replacin=
g
> it with literal zero and a decent code comment is appropriate.
>

James/Andrew/linux-scsi,

The following patch for the older megaraid driver fixes some sparse warning=
s.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid.c
scsi-misc-2.6.new/drivers/scsi/megaraid.c
--- scsi-misc-2.6/drivers/scsi/megaraid.c	2012-02-06 12:50:20.000000000 -08=
00
+++ scsi-misc-2.6.new/drivers/scsi/megaraid.c	2012-01-10
18:00:23.570267019 -0800
@@ -306,19 +306,22 @@
 	adapter->host->sg_tablesize =3D adapter->sglen;


-	/* use HP firmware and bios version encoding */
+	/* use HP firmware and bios version encoding
+	   Note: fw_version[0|1] and bios_version[0|1] were originally shifted
+	   right 8 bits making them zero. This 0 value was hardcoded to fix
+	   sparse warnings. */
 	if (adapter->product_info.subsysvid =3D=3D HP_SUBSYS_VID) {
 		sprintf (adapter->fw_version, "%c%d%d.%d%d",
 			 adapter->product_info.fw_version[2],
-			 adapter->product_info.fw_version[1] >> 8,
+			 0,
 			 adapter->product_info.fw_version[1] & 0x0f,
-			 adapter->product_info.fw_version[0] >> 8,
+			 0,
 			 adapter->product_info.fw_version[0] & 0x0f);
 		sprintf (adapter->bios_version, "%c%d%d.%d%d",
 			 adapter->product_info.bios_version[2],
-			 adapter->product_info.bios_version[1] >> 8,
+			 0,
 			 adapter->product_info.bios_version[1] & 0x0f,
-			 adapter->product_info.bios_version[0] >> 8,
+			 0,
 			 adapter->product_info.bios_version[0] & 0x0f);
 	} else {
 		memcpy(adapter->fw_version,

--0016e6d7ea90a41d0204b637198d
Content-Type: text/x-patch; charset=US-ASCII; name="megaraid.patch"
Content-Disposition: attachment; filename="megaraid.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx9pjcyt0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC5jIHNjc2ktbWlz
Yy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC5jCTIwMTItMDItMDYgMTI6NTA6MjAuMDAwMDAwMDAwIC0wODAwCisr
KyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQuYwkyMDEyLTAxLTEwIDE4
OjAwOjIzLjU3MDI2NzAxOSAtMDgwMApAQCAtMzA2LDE5ICszMDYsMjIgQEAKIAlhZGFwdGVyLT5o
b3N0LT5zZ190YWJsZXNpemUgPSBhZGFwdGVyLT5zZ2xlbjsKIAogCi0JLyogdXNlIEhQIGZpcm13
YXJlIGFuZCBiaW9zIHZlcnNpb24gZW5jb2RpbmcgKi8KKwkvKiB1c2UgSFAgZmlybXdhcmUgYW5k
IGJpb3MgdmVyc2lvbiBlbmNvZGluZworCSAgIE5vdGU6IGZ3X3ZlcnNpb25bMHwxXSBhbmQgYmlv
c192ZXJzaW9uWzB8MV0gd2VyZSBvcmlnaW5hbGx5IHNoaWZ0ZWQKKwkgICByaWdodCA4IGJpdHMg
bWFraW5nIHRoZW0gemVyby4gVGhpcyAwIHZhbHVlIHdhcyBoYXJkY29kZWQgdG8gZml4IAorCSAg
IHNwYXJzZSB3YXJuaW5ncy4gKi8KIAlpZiAoYWRhcHRlci0+cHJvZHVjdF9pbmZvLnN1YnN5c3Zp
ZCA9PSBIUF9TVUJTWVNfVklEKSB7CiAJCXNwcmludGYgKGFkYXB0ZXItPmZ3X3ZlcnNpb24sICIl
YyVkJWQuJWQlZCIsCiAJCQkgYWRhcHRlci0+cHJvZHVjdF9pbmZvLmZ3X3ZlcnNpb25bMl0sCi0J
CQkgYWRhcHRlci0+cHJvZHVjdF9pbmZvLmZ3X3ZlcnNpb25bMV0gPj4gOCwKKwkJCSAwLAogCQkJ
IGFkYXB0ZXItPnByb2R1Y3RfaW5mby5md192ZXJzaW9uWzFdICYgMHgwZiwKLQkJCSBhZGFwdGVy
LT5wcm9kdWN0X2luZm8uZndfdmVyc2lvblswXSA+PiA4LAorCQkJIDAsCiAJCQkgYWRhcHRlci0+
cHJvZHVjdF9pbmZvLmZ3X3ZlcnNpb25bMF0gJiAweDBmKTsKIAkJc3ByaW50ZiAoYWRhcHRlci0+
Ymlvc192ZXJzaW9uLCAiJWMlZCVkLiVkJWQiLAogCQkJIGFkYXB0ZXItPnByb2R1Y3RfaW5mby5i
aW9zX3ZlcnNpb25bMl0sCi0JCQkgYWRhcHRlci0+cHJvZHVjdF9pbmZvLmJpb3NfdmVyc2lvblsx
XSA+PiA4LAorCQkJIDAsCiAJCQkgYWRhcHRlci0+cHJvZHVjdF9pbmZvLmJpb3NfdmVyc2lvblsx
XSAmIDB4MGYsCi0JCQkgYWRhcHRlci0+cHJvZHVjdF9pbmZvLmJpb3NfdmVyc2lvblswXSA+PiA4
LAorCQkJIDAsCiAJCQkgYWRhcHRlci0+cHJvZHVjdF9pbmZvLmJpb3NfdmVyc2lvblswXSAmIDB4
MGYpOwogCX0gZWxzZSB7CiAJCW1lbWNweShhZGFwdGVyLT5md192ZXJzaW9uLAo=
--0016e6d7ea90a41d0204b637198d--
