From: adam radford <aradford@gmail.com>
Subject: [PATCH 6/10] megaraid_sas: Clear FUSION_IN_RESET before enabling interrupts
Date: Sat, 8 Oct 2011 18:14:59 -0700
Message-ID: <CAHtARFHKEcYHmWqyMDkNpx1qT84j7iXb5hcQAO=sWT62L=ZkaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001485f8606e37c9c704aed36747
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63151 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1JIBPA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:15:00 -0400
Received: by mail-ww0-f44.google.com with SMTP id 22so7565389wwf.1
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2011 18:14:59 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--001485f8606e37c9c704aed36747
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas will clear FUSION_IN_RESET bit
before enabling interrupts.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-07
19:15:27.804236999 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-07
19:16:53.458268171 -0700
@@ -2179,6 +2179,8 @@
 				continue;
 			}

+			clear_bit(MEGASAS_FUSION_IN_RESET,
+				  &instance->reset_flags);
 			instance->instancet->enable_intr(instance->reg_set);
 			instance->adprecovery = MEGASAS_HBA_OPERATIONAL;

@@ -2240,6 +2242,7 @@
 		megaraid_sas_kill_hba(instance);
 		retval = FAILED;
 	} else {
+		clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
 		instance->instancet->enable_intr(instance->reg_set);
 		instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
 	}

--001485f8606e37c9c704aed36747
Content-Type: application/octet-stream; name="megaraid_sas.patch6"
Content-Disposition: attachment; filename="megaraid_sas.patch6"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjbxtyz0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhc19mdXNpb24uYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMTAtMDcgMTk6MTU6MjcuODA0MjM2OTk5IC0wNzAw
CisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTEtMTAtMDcgMTk6MTY6NTMuNDU4MjY4MTcxIC0wNzAwCkBAIC0yMTc5LDYg
KzIxNzksOCBAQAogCQkJCWNvbnRpbnVlOwogCQkJfQogCisJCQljbGVhcl9iaXQoTUVHQVNBU19G
VVNJT05fSU5fUkVTRVQsCisJCQkJICAmaW5zdGFuY2UtPnJlc2V0X2ZsYWdzKTsKIAkJCWluc3Rh
bmNlLT5pbnN0YW5jZXQtPmVuYWJsZV9pbnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKIAkJCWluc3Rh
bmNlLT5hZHByZWNvdmVyeSA9IE1FR0FTQVNfSEJBX09QRVJBVElPTkFMOwogCkBAIC0yMjQwLDYg
KzIyNDIsNyBAQAogCQltZWdhcmFpZF9zYXNfa2lsbF9oYmEoaW5zdGFuY2UpOwogCQlyZXR2YWwg
PSBGQUlMRUQ7CiAJfSBlbHNlIHsKKwkJY2xlYXJfYml0KE1FR0FTQVNfRlVTSU9OX0lOX1JFU0VU
LCAmaW5zdGFuY2UtPnJlc2V0X2ZsYWdzKTsKIAkJaW5zdGFuY2UtPmluc3RhbmNldC0+ZW5hYmxl
X2ludHIoaW5zdGFuY2UtPnJlZ19zZXQpOwogCQlpbnN0YW5jZS0+YWRwcmVjb3ZlcnkgPSBNRUdB
U0FTX0hCQV9PUEVSQVRJT05BTDsKIAl9Cg==
--001485f8606e37c9c704aed36747--
