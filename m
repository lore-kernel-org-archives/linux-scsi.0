From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/4] megaraid_sas: Fix reglockFlags for degraded raid5/6
Date: Fri, 6 Jan 2012 17:02:26 -0800
Message-ID: <CAHtARFEm1guBwovMvjyeDCuK7j=pNmdWKmp5EDdS9UbPrAnQNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=e89a8f23443b0c856504b5e5b88b
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50517 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2AGBC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2012 20:02:28 -0500
Received: by wibhm6 with SMTP id hm6so1444579wib.19
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2012 17:02:26 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--e89a8f23443b0c856504b5e5b88b
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas fixes the reglockFlags field for
degraded raid5/6 for MR9360/9380, which will result in a performance
improvement.

Signed-off-by:  Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fp.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fp.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fp.c	2012-02-06
12:50:20.000000000 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fp.c	2012-01-06
14:58:15.364307850 -0800
@@ -282,7 +282,9 @@
 	else {
 		*pDevHandle = MR_PD_INVALID; /* set dev handle as invalid. */
 		if ((raid->level >= 5) &&
-		    (instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER))
+		    ((instance->pdev->device != PCI_DEVICE_ID_LSI_INVADER) ||
+		     (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER &&
+		      raid->regTypeReqOnRead != REGION_TYPE_UNUSED)))
 			pRAID_Context->regLockFlags = REGION_TYPE_EXCLUSIVE;
 		else if (raid->level == 1) {
 			/* Get alternate Pd. */

--e89a8f23443b0c856504b5e5b88b
Content-Type: application/octet-stream; name="megaraid_sas.patch1"
Content-Disposition: attachment; filename="megaraid_sas.patch1"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx3x748f0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnAuYyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzX2ZwLmMKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlk
X3Nhc19mcC5jCTIwMTItMDItMDYgMTI6NTA6MjAuMDAwMDAwMDAwIC0wODAwCisrKyBzY3NpLW1p
c2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2ZwLmMJMjAxMi0w
MS0wNiAxNDo1ODoxNS4zNjQzMDc4NTAgLTA4MDAKQEAgLTI4Miw3ICsyODIsOSBAQAogCWVsc2Ug
ewogCQkqcERldkhhbmRsZSA9IE1SX1BEX0lOVkFMSUQ7IC8qIHNldCBkZXYgaGFuZGxlIGFzIGlu
dmFsaWQuICovCiAJCWlmICgocmFpZC0+bGV2ZWwgPj0gNSkgJiYKLQkJICAgIChpbnN0YW5jZS0+
cGRldi0+ZGV2aWNlICE9IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIpKQorCQkgICAgKChpbnN0
YW5jZS0+cGRldi0+ZGV2aWNlICE9IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIpIHx8CisJCSAg
ICAgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfSU5WQURFUiAm
JgorCQkgICAgICByYWlkLT5yZWdUeXBlUmVxT25SZWFkICE9IFJFR0lPTl9UWVBFX1VOVVNFRCkp
KQogCQkJcFJBSURfQ29udGV4dC0+cmVnTG9ja0ZsYWdzID0gUkVHSU9OX1RZUEVfRVhDTFVTSVZF
OwogCQllbHNlIGlmIChyYWlkLT5sZXZlbCA9PSAxKSB7CiAJCQkvKiBHZXQgYWx0ZXJuYXRlIFBk
LiAqLwo=
--e89a8f23443b0c856504b5e5b88b--
