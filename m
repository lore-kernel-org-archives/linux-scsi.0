From: adam radford <aradford@gmail.com>
Subject: [PATCH 13/15] megaraid_sas: Fix max_sectors for IEEE SGL
Date: Sat, 19 Feb 2011 18:23:21 -0800
Message-ID: <AANLkTi=O0dsS1euoUdgEdDzdmiuneaXoCLmXZuUZCOi+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c1e245fe110049cad6e1d
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65295 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab1BTCZf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:25:35 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so5038199wwa.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:25:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c1e245fe110049cad6e1d
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes the max_sectors setting for
IEEE SGL's.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:25:55.899395046 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:27:36.563207670 -0800
@@ -3825,6 +3825,10 @@
 			instance->max_fw_cmds - MEGASAS_INT_CMDS;
 	host->this_id = instance->init_id;
 	host->sg_tablesize = instance->max_num_sge;
+
+	if (instance->fw_support_ieee)
+		instance->max_sectors_per_req = MEGASAS_MAX_SECTORS_IEEE;
+
 	/*
 	 * Check if the module parameter value for max_sectors can be used
 	 */
diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas.h
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas.h	2011-02-19
14:04:58.919332498 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas.h	2011-02-19
14:28:04.113364498 -0800
@@ -723,6 +723,7 @@
 						MEGASAS_MAX_DEV_PER_CHANNEL)

 #define MEGASAS_MAX_SECTORS                    (2*1024)
+#define MEGASAS_MAX_SECTORS_IEEE		(2*128)
 #define MEGASAS_DBG_LVL				1

 #define MEGASAS_FW_BUSY				1

--0016e64c1e245fe110049cad6e1d
Content-Type: application/octet-stream; name="megaraid_sas.patch13"
Content-Disposition: attachment; filename="megaraid_sas.patch13"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdbh7i50

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMTkgMTQ6MjU6NTUuODk5Mzk1MDQ2IC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYwkyMDExLTAyLTE5IDE0OjI3OjM2LjU2MzIwNzY3MCAtMDgwMApAQCAtMzgy
NSw2ICszODI1LDEwIEBACiAJCQlpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgLSBNRUdBU0FTX0lOVF9D
TURTOwogCWhvc3QtPnRoaXNfaWQgPSBpbnN0YW5jZS0+aW5pdF9pZDsKIAlob3N0LT5zZ190YWJs
ZXNpemUgPSBpbnN0YW5jZS0+bWF4X251bV9zZ2U7CisKKwlpZiAoaW5zdGFuY2UtPmZ3X3N1cHBv
cnRfaWVlZSkKKwkJaW5zdGFuY2UtPm1heF9zZWN0b3JzX3Blcl9yZXEgPSBNRUdBU0FTX01BWF9T
RUNUT1JTX0lFRUU7CisKIAkvKgogCSAqIENoZWNrIGlmIHRoZSBtb2R1bGUgcGFyYW1ldGVyIHZh
bHVlIGZvciBtYXhfc2VjdG9ycyBjYW4gYmUgdXNlZAogCSAqLwpkaWZmIC1OYXVyIGxpbnV4LTIu
Ni4zOC1yYzUvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oIGxpbnV4LTIuNi4z
OC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAotLS0gbGludXgt
Mi42LjM4LXJjNS9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMS0wMi0x
OSAxNDowNDo1OC45MTkzMzI0OTggLTA4MDAKKysrIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDExLTAyLTE5IDE0OjI4OjA0LjExMzM2
NDQ5OCAtMDgwMApAQCAtNzIzLDYgKzcyMyw3IEBACiAJCQkJCQlNRUdBU0FTX01BWF9ERVZfUEVS
X0NIQU5ORUwpCiAKICNkZWZpbmUgTUVHQVNBU19NQVhfU0VDVE9SUyAgICAgICAgICAgICAgICAg
ICAgKDIqMTAyNCkKKyNkZWZpbmUgTUVHQVNBU19NQVhfU0VDVE9SU19JRUVFCQkoMioxMjgpCiAj
ZGVmaW5lIE1FR0FTQVNfREJHX0xWTAkJCQkxCiAKICNkZWZpbmUgTUVHQVNBU19GV19CVVNZCQkJ
CTEK
--0016e64c1e245fe110049cad6e1d--
