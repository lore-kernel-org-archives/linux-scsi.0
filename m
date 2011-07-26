From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/3] megaraid_sas: Add .change_queue_depth support
Date: Tue, 26 Jul 2011 15:42:52 -0700
Message-ID: <CAHtARFFAqj+iSKg7pzt4N3vYw_L9CODTfnYdumbUM2-jTQaRgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=90e6ba2121c3eed63b04a900a604
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58513 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1GZWmx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 18:42:53 -0400
Received: by gwaa18 with SMTP id a18so660319gwa.19
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2011 15:42:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--90e6ba2121c3eed63b04a900a604
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adds support for the
.change_queue_depth entrypoint.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c	2011-07-21
19:17:23.000000000 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-07-26
14:20:02.356434707 -0700
@@ -54,6 +54,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_tcq.h>
 #include "megaraid_sas_fusion.h"
 #include "megaraid_sas.h"

@@ -2057,6 +2058,20 @@
 	}
 }

+static int megasas_change_queue_depth(struct scsi_device *sdev,
+				      int queue_depth, int reason)
+{
+	if (reason != SCSI_QDEPTH_DEFAULT)
+		return -EOPNOTSUPP;
+
+	if (queue_depth > sdev->host->can_queue)
+		queue_depth = sdev->host->can_queue;
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
+				queue_depth);
+
+	return queue_depth;
+}
+
 /*
  * Scsi host template for megaraid_sas driver
  */
@@ -2074,6 +2089,7 @@
 	.eh_timed_out = megasas_reset_timer,
 	.bios_param = megasas_bios_param,
 	.use_clustering = ENABLE_CLUSTERING,
+	.change_queue_depth = megasas_change_queue_depth,
 };

 /**

--90e6ba2121c3eed63b04a900a604
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqlejlug0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19i
YXNlLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jh
c2UuYwotLS0gc2NzaS1taXNjL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFz
ZS5jCTIwMTEtMDctMjEgMTk6MTc6MjMuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLW1pc2MubmV3
L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDctMjYgMTQ6
MjA6MDIuMzU2NDM0NzA3IC0wNzAwCkBAIC01NCw2ICs1NCw3IEBACiAjaW5jbHVkZSA8c2NzaS9z
Y3NpX2NtbmQuaD4KICNpbmNsdWRlIDxzY3NpL3Njc2lfZGV2aWNlLmg+CiAjaW5jbHVkZSA8c2Nz
aS9zY3NpX2hvc3QuaD4KKyNpbmNsdWRlIDxzY3NpL3Njc2lfdGNxLmg+CiAjaW5jbHVkZSAibWVn
YXJhaWRfc2FzX2Z1c2lvbi5oIgogI2luY2x1ZGUgIm1lZ2FyYWlkX3Nhcy5oIgogCkBAIC0yMDU3
LDYgKzIwNTgsMjAgQEAKIAl9CiB9CiAKK3N0YXRpYyBpbnQgbWVnYXNhc19jaGFuZ2VfcXVldWVf
ZGVwdGgoc3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LAorCQkJCSAgICAgIGludCBxdWV1ZV9kZXB0
aCwgaW50IHJlYXNvbikKK3sKKwlpZiAocmVhc29uICE9IFNDU0lfUURFUFRIX0RFRkFVTFQpCisJ
CXJldHVybiAtRU9QTk9UU1VQUDsKKworCWlmIChxdWV1ZV9kZXB0aCA+IHNkZXYtPmhvc3QtPmNh
bl9xdWV1ZSkKKwkJcXVldWVfZGVwdGggPSBzZGV2LT5ob3N0LT5jYW5fcXVldWU7CisJc2NzaV9h
ZGp1c3RfcXVldWVfZGVwdGgoc2Rldiwgc2NzaV9nZXRfdGFnX3R5cGUoc2RldiksCisJCQkJcXVl
dWVfZGVwdGgpOworCisJcmV0dXJuIHF1ZXVlX2RlcHRoOworfQorCiAvKgogICogU2NzaSBob3N0
IHRlbXBsYXRlIGZvciBtZWdhcmFpZF9zYXMgZHJpdmVyCiAgKi8KQEAgLTIwNzQsNiArMjA4OSw3
IEBACiAJLmVoX3RpbWVkX291dCA9IG1lZ2FzYXNfcmVzZXRfdGltZXIsCiAJLmJpb3NfcGFyYW0g
PSBtZWdhc2FzX2Jpb3NfcGFyYW0sCiAJLnVzZV9jbHVzdGVyaW5nID0gRU5BQkxFX0NMVVNURVJJ
TkcsCisJLmNoYW5nZV9xdWV1ZV9kZXB0aCA9IG1lZ2FzYXNfY2hhbmdlX3F1ZXVlX2RlcHRoLAog
fTsKIAogLyoqCg==
--90e6ba2121c3eed63b04a900a604--
