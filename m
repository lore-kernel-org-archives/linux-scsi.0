From: adam radford <aradford@gmail.com>
Subject: [PATCH 1/1] megaraid_sas: Fix instance access in megasas_reset_timer
Date: Thu, 13 Oct 2011 16:01:12 -0700
Message-ID: <CAHtARFFVAUwTw9R=9OFcgu7=L6LgmZBnKViL4xmnPzuPiOhLHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e65c8ddaf27c0304af361da4
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:43173 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1JMXBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2011 19:01:13 -0400
Received: by wwf22 with SMTP id 22so2561373wwf.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2011 16:01:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com
Cc: stable@kernel.org

--0016e65c8ddaf27c0304af361da4
Content-Type: text/plain; charset=ISO-8859-1

CC: stable

James/linux-scsi,

The following patch for scsi-misc-2.6 for megaraid_sas will fix a
potential bad pointer access in megasas_reset_timer(), when a MegaRAID
9265/9285 or 9360/9380 gets a timeout.  megasas_build_io_fusion() sets
SCp.ptr to be a struct megasas_cmd_fusion *, but then
megasas_reset_timer() was casting SCp.ptr to be a struct megasas_cmd
*, then trying to access cmd->instance, which is invalid.

Just loading instance from scmd->device->host->hostdata in
megasas_reset_timer() fixes the issue.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-13
15:35:39.563245479 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-13
15:38:15.711245124 -0700
@@ -1914,7 +1914,6 @@
 static enum
 blk_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
 {
-	struct megasas_cmd *cmd = (struct megasas_cmd *)scmd->SCp.ptr;
 	struct megasas_instance *instance;
 	unsigned long flags;

@@ -1923,7 +1922,7 @@
 		return BLK_EH_NOT_HANDLED;
 	}

-	instance = cmd->instance;
+	instance = (struct megasas_instance *)scmd->device->host->hostdata;
 	if (!(instance->flag & MEGASAS_FW_BUSY)) {
 		/* FW is busy, throttle IO */
 		spin_lock_irqsave(instance->host->host_lock, flags);

--0016e65c8ddaf27c0304af361da4
Content-Type: application/octet-stream; name="megaraid_sas.patch11"
Content-Disposition: attachment; filename="megaraid_sas.patch11"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtqcp46g0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMTAtMTMgMTU6MzU6MzkuNTYzMjQ1NDc5IC0wNzAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTEwLTEzIDE1OjM4OjE1LjcxMTI0NTEyNCAtMDcwMApAQCAtMTkxNCw3ICsxOTE0LDYg
QEAKIHN0YXRpYyBlbnVtCiBibGtfZWhfdGltZXJfcmV0dXJuIG1lZ2FzYXNfcmVzZXRfdGltZXIo
c3RydWN0IHNjc2lfY21uZCAqc2NtZCkKIHsKLQlzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCA9IChz
dHJ1Y3QgbWVnYXNhc19jbWQgKilzY21kLT5TQ3AucHRyOwogCXN0cnVjdCBtZWdhc2FzX2luc3Rh
bmNlICppbnN0YW5jZTsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwogCkBAIC0xOTIzLDcgKzE5MjIs
NyBAQAogCQlyZXR1cm4gQkxLX0VIX05PVF9IQU5ETEVEOwogCX0KIAotCWluc3RhbmNlID0gY21k
LT5pbnN0YW5jZTsKKwlpbnN0YW5jZSA9IChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqKXNjbWQt
PmRldmljZS0+aG9zdC0+aG9zdGRhdGE7CiAJaWYgKCEoaW5zdGFuY2UtPmZsYWcgJiBNRUdBU0FT
X0ZXX0JVU1kpKSB7CiAJCS8qIEZXIGlzIGJ1c3ksIHRocm90dGxlIElPICovCiAJCXNwaW5fbG9j
a19pcnFzYXZlKGluc3RhbmNlLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsK
--0016e65c8ddaf27c0304af361da4--
