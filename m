From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 102/103] target: fix typo Assoication -> Association
Date: Thu, 21 Jul 2011 07:05:34 +0000
Message-ID: <1311231935-24635-103-git-send-email-nab@linux-iscsi.org>
References: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51710 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab1GUH3r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2011 03:29:47 -0400
In-Reply-To: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, James Bottomley <jbottomley@parallels.com>

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Additionally this patch brings proper apply of the designator type.
However, the original code luckily has no bug, because the association
equals to 0.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: James Bottomley <jbottomley@parallels.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_cdb.c      |   10 +++++-----
 drivers/target/target_core_configfs.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 145739b..27e6a2e 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -188,11 +188,11 @@ target_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	/* CODE SET == Binary */
 	buf[off++] = 0x1;
 
-	/* Set ASSOICATION == addressed logical unit: 0)b */
+	/* Set ASSOCIATION == addressed logical unit: 0)b */
 	buf[off] = 0x00;
 
 	/* Identifier/Designator type == NAA identifier */
-	buf[off++] = 0x3;
+	buf[off++] |= 0x3;
 	off++;
 
 	/* Identifier/Designator length */
@@ -293,7 +293,7 @@ check_port:
 			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
 		buf[off++] |= 0x1; /* CODE SET == Binary */
 		buf[off] = 0x80; /* Set PIV=1 */
-		/* Set ASSOICATION == target port: 01b */
+		/* Set ASSOCIATION == target port: 01b */
 		buf[off] |= 0x10;
 		/* DESIGNATOR TYPE == Relative target port identifer */
 		buf[off++] |= 0x4;
@@ -338,7 +338,7 @@ check_tpgi:
 			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
 		buf[off++] |= 0x1; /* CODE SET == Binary */
 		buf[off] = 0x80; /* Set PIV=1 */
-		/* Set ASSOICATION == target port: 01b */
+		/* Set ASSOCIATION == target port: 01b */
 		buf[off] |= 0x10;
 		/* DESIGNATOR TYPE == Target port group identifier */
 		buf[off++] |= 0x5;
@@ -405,7 +405,7 @@ check_scsi_name:
 			(tpg->se_tpg_tfo->get_fabric_proto_ident(tpg) << 4);
 		buf[off++] |= 0x3; /* CODE SET == UTF-8 */
 		buf[off] = 0x80; /* Set PIV=1 */
-		/* Set ASSOICATION == target port: 01b */
+		/* Set ASSOCIATION == target port: 01b */
 		buf[off] |= 0x10;
 		/* DESIGNATOR TYPE == SCSI name string */
 		buf[off++] |= 0x8;
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index a92176d..b2575d8 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -975,7 +975,7 @@ static ssize_t target_core_dev_wwn_show_attr_##_name(			\
 }
 
 /*
- * VPD page 0x83 Assoication: Logical Unit
+ * VPD page 0x83 Association: Logical Unit
  */
 DEF_DEV_WWN_ASSOC_SHOW(vpd_assoc_logical_unit, 0x00);
 
-- 
1.7.6

