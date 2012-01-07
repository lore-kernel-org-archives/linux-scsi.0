From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/4] megaraid_sas: mask off flags in ioctl path
Date: Fri, 6 Jan 2012 17:02:34 -0800
Message-ID: <CAHtARFHi=+MxNbmdw_=zhTgxpCstS8Mr_E=Jf5OUs98WBqtB5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6d7ea9081332304b5e5b844
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:43473 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2AGBCf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2012 20:02:35 -0500
Received: by werm1 with SMTP id m1so1502478wer.19
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2012 17:02:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6d7ea9081332304b5e5b844
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas masks off flags in the ioctl path
to prevent memory scribble with older MegaCLI versions.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2012-02-06
12:50:20.000000000 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-01-06
15:02:36.182434657 -0800
@@ -4773,6 +4773,8 @@
 	memcpy(cmd->frame, ioc->frame.raw, 2 * MEGAMFI_FRAME_SIZE);
 	cmd->frame->hdr.context = cmd->index;
 	cmd->frame->hdr.pad_0 = 0;
+	cmd->frame->hdr.flags &= ~(MFI_FRAME_IEEE | MFI_FRAME_SGL64 |
+				   MFI_FRAME_SENSE64);

 	/*
 	 * The management interface between applications and the fw uses

--0016e6d7ea9081332304b5e5b844
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx3xaexm0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTItMDItMDYgMTI6NTA6MjAuMDAwMDAwMDAwIC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDEyLTAxLTA2IDE1OjAyOjM2LjE4MjQzNDY1NyAtMDgwMApAQCAtNDc3Myw2ICs0NzczLDgg
QEAKIAltZW1jcHkoY21kLT5mcmFtZSwgaW9jLT5mcmFtZS5yYXcsIDIgKiBNRUdBTUZJX0ZSQU1F
X1NJWkUpOwogCWNtZC0+ZnJhbWUtPmhkci5jb250ZXh0ID0gY21kLT5pbmRleDsKIAljbWQtPmZy
YW1lLT5oZHIucGFkXzAgPSAwOworCWNtZC0+ZnJhbWUtPmhkci5mbGFncyAmPSB+KE1GSV9GUkFN
RV9JRUVFIHwgTUZJX0ZSQU1FX1NHTDY0IHwKKwkJCQkgICBNRklfRlJBTUVfU0VOU0U2NCk7CiAK
IAkvKgogCSAqIFRoZSBtYW5hZ2VtZW50IGludGVyZmFjZSBiZXR3ZWVuIGFwcGxpY2F0aW9ucyBh
bmQgdGhlIGZ3IHVzZXMK
--0016e6d7ea9081332304b5e5b844--
