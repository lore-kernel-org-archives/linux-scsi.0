From: adam radford <aradford@gmail.com>
Subject: [PATCH 6/15] megaraid_sas: Fix megasas_get_cmd printk
Date: Sat, 19 Feb 2011 18:22:42 -0800
Message-ID: <AANLkTinUKA3+3dwCmvrWNpq3x3VDmsK23iTaMZPjrrBi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c3e6606a160049cad6c2a
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52251 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BTCWn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:22:43 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so5037267wwa.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:22:42 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c3e6606a160049cad6c2a
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

The following patch for megaraid_sas fixes a megasas_get_cmd() printk.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:04:58.918332644 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-02-19
14:05:47.832331304 -0800
@@ -186,7 +186,8 @@
 				 struct megasas_cmd, list);
 		list_del_init(&cmd->list);
 	} else {
-		printk(KERN_ERR "megasas: Command pool empty!\n");
+		if (megasas_dbg_lvl)
+			printk(KERN_ERR "megasas: Command pool empty!\n");
 	}

 	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);

--0016e64c3e6606a160049cad6c2a
Content-Type: application/octet-stream; name="megaraid_sas.patch6"
Content-Disposition: attachment; filename="megaraid_sas.patch6"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdazo4o0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zOC1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDItMTkgMTQ6MDQ6NTguOTE4MzMyNjQ0IC0w
ODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYwkyMDExLTAyLTE5IDE0OjA1OjQ3LjgzMjMzMTMwNCAtMDgwMApAQCAtMTg2
LDcgKzE4Niw4IEBACiAJCQkJIHN0cnVjdCBtZWdhc2FzX2NtZCwgbGlzdCk7CiAJCWxpc3RfZGVs
X2luaXQoJmNtZC0+bGlzdCk7CiAJfSBlbHNlIHsKLQkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2Fz
OiBDb21tYW5kIHBvb2wgZW1wdHkhXG4iKTsKKwkJaWYgKG1lZ2FzYXNfZGJnX2x2bCkKKwkJCXBy
aW50ayhLRVJOX0VSUiAibWVnYXNhczogQ29tbWFuZCBwb29sIGVtcHR5IVxuIik7CiAJfQogCiAJ
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2UtPmNtZF9wb29sX2xvY2ssIGZsYWdzKTsK
--0016e64c3e6606a160049cad6c2a--
