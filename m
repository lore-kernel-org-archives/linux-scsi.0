From: adam radford <aradford@gmail.com>
Subject: [PATCH 6/14] megaraid_sas: Fix megasas_get_cmd printk
Date: Thu, 24 Feb 2011 20:56:36 -0800
Message-ID: <AANLkTimMuwYPbmear_zD49_=h7HhSy4NHg9hYh8esLSN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00163683340a9c3d3f049d142703
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49097 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1BYE4h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:56:37 -0500
Received: by wwb39 with SMTP id 39so1696373wwb.1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:56:36 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--00163683340a9c3d3f049d142703
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes a megasas_get_cmd printk.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:49:07.531369391 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-24
18:49:45.987337951 -0800
@@ -186,7 +186,8 @@
 				 struct megasas_cmd, list);
 		list_del_init(&cmd->list);
 	} else {
-		printk(KERN_ERR "megasas: Command pool empty!\n");
+		if (megasas_dbg_lvl)
+			printk(KERN_ERR "megasas: Command pool empty!\n");
 	}

 	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);

--00163683340a9c3d3f049d142703
Content-Type: application/octet-stream; name="megaraid_sas.patch6"
Content-Disposition: attachment; filename="megaraid_sas.patch6"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkmigwh0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMjQgMTg6NDk6MDcuNTMxMzY5MzkxIC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTAyLTI0IDE4OjQ5OjQ1Ljk4NzMzNzk1MSAtMDgwMApAQCAtMTg2LDcgKzE4Niw4IEBA
CiAJCQkJIHN0cnVjdCBtZWdhc2FzX2NtZCwgbGlzdCk7CiAJCWxpc3RfZGVsX2luaXQoJmNtZC0+
bGlzdCk7CiAJfSBlbHNlIHsKLQkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBDb21tYW5kIHBv
b2wgZW1wdHkhXG4iKTsKKwkJaWYgKG1lZ2FzYXNfZGJnX2x2bCkKKwkJCXByaW50ayhLRVJOX0VS
UiAibWVnYXNhczogQ29tbWFuZCBwb29sIGVtcHR5IVxuIik7CiAJfQogCiAJc3Bpbl91bmxvY2tf
aXJxcmVzdG9yZSgmaW5zdGFuY2UtPmNtZF9wb29sX2xvY2ssIGZsYWdzKTsK
--00163683340a9c3d3f049d142703--
