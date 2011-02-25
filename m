From: adam radford <aradford@gmail.com>
Subject: [PATCH 12/14] megaraid_sas: Fix max_sectors for IEEE SGL
Date: Thu, 24 Feb 2011 20:57:09 -0800
Message-ID: <AANLkTim=+jWXiTnt_zNbziKVcLAOBswsxXh_XD6ums0q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00163683340a9261b9049d142963
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43537 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab1BYE5J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:57:09 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1266614wyg.19
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:57:09 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--00163683340a9261b9049d142963
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes the max_sectors setting for
IEEE SGL's.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:59:19.098275734 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
19:00:18.258276274 -0800
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
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2011-02-24
18:49:07.532369325 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2011-02-24
19:00:51.227276173 -0800
@@ -723,6 +723,7 @@
 						MEGASAS_MAX_DEV_PER_CHANNEL)

 #define MEGASAS_MAX_SECTORS                    (2*1024)
+#define MEGASAS_MAX_SECTORS_IEEE		(2*128)
 #define MEGASAS_DBG_LVL				1

 #define MEGASAS_FW_BUSY				1

--00163683340a9261b9049d142963
Content-Type: application/octet-stream; name="megaraid_sas.patch12"
Content-Disposition: attachment; filename="megaraid_sas.patch12"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkmm4l00

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMjQgMTg6NTk6MTkuMDk4Mjc1NzM0IC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTAyLTI0IDE5OjAwOjE4LjI1ODI3NjI3NCAtMDgwMApAQCAtMzgyNSw2ICszODI1LDEw
IEBACiAJCQlpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgLSBNRUdBU0FTX0lOVF9DTURTOwogCWhvc3Qt
PnRoaXNfaWQgPSBpbnN0YW5jZS0+aW5pdF9pZDsKIAlob3N0LT5zZ190YWJsZXNpemUgPSBpbnN0
YW5jZS0+bWF4X251bV9zZ2U7CisKKwlpZiAoaW5zdGFuY2UtPmZ3X3N1cHBvcnRfaWVlZSkKKwkJ
aW5zdGFuY2UtPm1heF9zZWN0b3JzX3Blcl9yZXEgPSBNRUdBU0FTX01BWF9TRUNUT1JTX0lFRUU7
CisKIAkvKgogCSAqIENoZWNrIGlmIHRoZSBtb2R1bGUgcGFyYW1ldGVyIHZhbHVlIGZvciBtYXhf
c2VjdG9ycyBjYW4gYmUgdXNlZAogCSAqLwpkaWZmIC1OYXVyIHNjc2ktbWlzYy0yLjYvZHJpdmVy
cy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMv
c2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Nj
c2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMS0wMi0yNCAxODo0OTowNy41MzIzNjkzMjUg
LTA4MDAKKysrIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXMuaAkyMDExLTAyLTI0IDE5OjAwOjUxLjIyNzI3NjE3MyAtMDgwMApAQCAtNzIzLDYgKzcy
Myw3IEBACiAJCQkJCQlNRUdBU0FTX01BWF9ERVZfUEVSX0NIQU5ORUwpCiAKICNkZWZpbmUgTUVH
QVNBU19NQVhfU0VDVE9SUyAgICAgICAgICAgICAgICAgICAgKDIqMTAyNCkKKyNkZWZpbmUgTUVH
QVNBU19NQVhfU0VDVE9SU19JRUVFCQkoMioxMjgpCiAjZGVmaW5lIE1FR0FTQVNfREJHX0xWTAkJ
CQkxCiAKICNkZWZpbmUgTUVHQVNBU19GV19CVVNZCQkJCTEK
--00163683340a9261b9049d142963--
