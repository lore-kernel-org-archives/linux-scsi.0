From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/14] megaraid_sas: Add missing check_and_restore_queue_depth call
Date: Thu, 24 Feb 2011 20:56:05 -0800
Message-ID: <AANLkTi=-G=6S+swXANOAGYyO9oFZXBSbjY4=ja=jEp89@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6d59d66c91e9d049d142581
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44391 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab1BYE4G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2011 23:56:06 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so1266125wyg.19
        for <linux-scsi@vger.kernel.org>; Thu, 24 Feb 2011 20:56:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6d59d66c91e9d049d142581
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

This patch adds a missing check_and_restore_queue_depth call to megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-24
18:27:47.193306786 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-02-24
18:34:25.104215511 -0800
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

--0016e6d59d66c91e9d049d142581
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gkkm2kbe0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfZnVzaW9uLmMgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhc19mdXNpb24uYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMDItMjQgMTg6Mjc6NDcuMTkzMzA2Nzg2IC0wODAw
CisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Z1c2lvbi5jCTIwMTEtMDItMjQgMTg6MzQ6MjUuMTA0MjE1NTExIC0wODAwCkBAIC04Miw2ICs4
MiwxMCBAQAogc3RydWN0IE1SX0xEX1JBSUQgKk1SX0xkUmFpZEdldCh1MzIgbGQsIHN0cnVjdCBN
Ul9GV19SQUlEX01BUF9BTEwgKm1hcCk7CiAKIHUxNiBNUl9HZXRMRFRndElkKHUzMiBsZCwgc3Ry
dWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwKTsKKwordm9pZAorbWVnYXNhc19jaGVja19hbmRf
cmVzdG9yZV9xdWV1ZV9kZXB0aChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOwor
CiB1OCBNUl9WYWxpZGF0ZU1hcEluZm8oc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwLAog
CQkgICAgICBzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxiSW5mbyk7CiB1MTYgZ2V0X3Vw
ZGF0ZWRfZGV2X2hhbmRsZShzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxiSW5mbywKQEAg
LTE3NDYsNyArMTc1MCw3IEBACiAJd21iKCk7CiAJd3JpdGVsKGZ1c2lvbi0+bGFzdF9yZXBseV9p
ZHgsCiAJICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+cmVwbHlfcG9zdF9ob3N0X2luZGV4KTsK
LQorCW1lZ2FzYXNfY2hlY2tfYW5kX3Jlc3RvcmVfcXVldWVfZGVwdGgoaW5zdGFuY2UpOwogCXJl
dHVybiBJUlFfSEFORExFRDsKIH0KIAo=
--0016e6d59d66c91e9d049d142581--
