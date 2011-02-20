From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/15] megaraid_sas: Add missing check_and_restore_queue_depth call
Date: Sat, 19 Feb 2011 18:22:20 -0800
Message-ID: <AANLkTikbDyMV3k9Uy_DOg4yRC78uCWvjKTZgnaWUHd5e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c1e24b5f722049cad6a98
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65295 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab1BTCZZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2011 21:25:25 -0500
Received: by wwa36 with SMTP id 36so5038199wwa.1
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2011 18:25:24 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c1e24b5f722049cad6a98
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

This patch adds a missing check_and_restore_queue_depth call to megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_fusion.c
linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- linux-2.6.38-rc5/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-19
13:48:26.553365431 -0800
+++ linux-2.6.38-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-19
13:47:00.216364552 -0800
@@ -82,6 +82,10 @@
 struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map);

 u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
+
+void
+megasas_check_and_restore_queue_depth(struct megasas_instance *instance);
+
 u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
 		      struct LD_LOAD_BALANCE_INFO *lbInfo);
 u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
@@ -1746,7 +1750,7 @@
 	wmb();
 	writel(fusion->last_reply_idx,
 	       &instance->reg_set->reply_post_host_index);
-
+	megasas_check_and_restore_queue_depth(instance);
 	return IRQ_HANDLED;
 }

--0016e64c1e24b5f722049cad6a98
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkdaqq010

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzgtcmM1L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfZnVzaW9uLmMgbGludXgtMi42LjM4LXJjNS5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlk
L21lZ2FyYWlkX3Nhc19mdXNpb24uYwotLS0gbGludXgtMi42LjM4LXJjNS9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMDItMTkgMTM6NDg6MjYuNTUzMzY1
NDMxIC0wODAwCisrKyBsaW51eC0yLjYuMzgtcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMDItMTkgMTM6NDc6MDAuMjE2MzY0NTUyIC0wODAw
CkBAIC04Miw2ICs4MiwxMCBAQAogc3RydWN0IE1SX0xEX1JBSUQgKk1SX0xkUmFpZEdldCh1MzIg
bGQsIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCk7CiAKIHUxNiBNUl9HZXRMRFRndElk
KHUzMiBsZCwgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwKTsKKwordm9pZAorbWVnYXNh
c19jaGVja19hbmRfcmVzdG9yZV9xdWV1ZV9kZXB0aChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAq
aW5zdGFuY2UpOworCiB1OCBNUl9WYWxpZGF0ZU1hcEluZm8oc3RydWN0IE1SX0ZXX1JBSURfTUFQ
X0FMTCAqbWFwLAogCQkgICAgICBzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxiSW5mbyk7
CiB1MTYgZ2V0X3VwZGF0ZWRfZGV2X2hhbmRsZShzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8g
KmxiSW5mbywKQEAgLTE3NDYsNyArMTc1MCw3IEBACiAJd21iKCk7CiAJd3JpdGVsKGZ1c2lvbi0+
bGFzdF9yZXBseV9pZHgsCiAJICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+cmVwbHlfcG9zdF9o
b3N0X2luZGV4KTsKLQorCW1lZ2FzYXNfY2hlY2tfYW5kX3Jlc3RvcmVfcXVldWVfZGVwdGgoaW5z
dGFuY2UpOwogCXJldHVybiBJUlFfSEFORExFRDsKIH0KIAo=
--0016e64c1e24b5f722049cad6a98--
