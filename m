From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] target-core: don't use "const char*" for a buffer that is written to
Date: Tue, 21 Nov 2017 01:12:43 +0100
Message-ID: <20171121001244.8026-1-linux@rasmusvillemoes.dk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:37055 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751198AbdKUANQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 19:13:16 -0500
Received: by mail-wr0-f196.google.com with SMTP id k61so9695870wrc.4
        for <linux-scsi@vger.kernel.org>; Mon, 20 Nov 2017 16:13:16 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Rasmus Villemoes <rasmus.villemoes@prevas.dk>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

iscsi_parse_pr_out_transport_id launders the const away via a call to
strstr(), and then modifies the buffer (writing a nul byte) through
the return value. It's cleaner to be honest and simply declare the
parameter as "char*", fixing up the call chain, and allowing us to
drop the cast in the return statement.

Amusingly, the two current callers found it necessary to cast a
non-const pointer to a const.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/target/target_core_fabric_lib.c | 6 +++---
 drivers/target/target_core_internal.h   | 2 +-
 drivers/target/target_core_pr.c         | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 508da345b73f..71a80257a052 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -273,7 +273,7 @@ static int iscsi_get_pr_transport_id_len(
 
 static char *iscsi_parse_pr_out_transport_id(
 	struct se_portal_group *se_tpg,
-	const char *buf,
+	char *buf,
 	u32 *out_tid_len,
 	char **port_nexus_ptr)
 {
@@ -356,7 +356,7 @@ static char *iscsi_parse_pr_out_transport_id(
 		}
 	}
 
-	return (char *)&buf[4];
+	return &buf[4];
 }
 
 int target_get_pr_transport_id_len(struct se_node_acl *nacl,
@@ -405,7 +405,7 @@ int target_get_pr_transport_id(struct se_node_acl *nacl,
 }
 
 const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
-		const char *buf, u32 *out_tid_len, char **port_nexus_ptr)
+		char *buf, u32 *out_tid_len, char **port_nexus_ptr)
 {
 	u32 offset;
 
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 18e3eb16e756..cada158cf1c2 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -101,7 +101,7 @@ int	target_get_pr_transport_id(struct se_node_acl *nacl,
 		struct t10_pr_registration *pr_reg, int *format_code,
 		unsigned char *buf);
 const char *target_parse_pr_out_transport_id(struct se_portal_group *tpg,
-		const char *buf, u32 *out_tid_len, char **port_nexus_ptr);
+		char *buf, u32 *out_tid_len, char **port_nexus_ptr);
 
 /* target_core_hba.c */
 struct se_hba *core_alloc_hba(const char *, u32, u32);
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index dd2cd8048582..09941d1ae6c1 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1597,7 +1597,7 @@ core_scsi3_decode_spec_i_port(
 			dest_rtpi = tmp_lun->lun_rtpi;
 
 			i_str = target_parse_pr_out_transport_id(tmp_tpg,
-					(const char *)ptr, &tid_len, &iport_ptr);
+					ptr, &tid_len, &iport_ptr);
 			if (!i_str)
 				continue;
 
@@ -3285,7 +3285,7 @@ core_scsi3_emulate_pro_register_and_move(struct se_cmd *cmd, u64 res_key,
 		goto out;
 	}
 	initiator_str = target_parse_pr_out_transport_id(dest_se_tpg,
-			(const char *)&buf[24], &tmp_tid_len, &iport_ptr);
+			&buf[24], &tmp_tid_len, &iport_ptr);
 	if (!initiator_str) {
 		pr_err("SPC-3 PR REGISTER_AND_MOVE: Unable to locate"
 			" initiator_str from Transport ID\n");
-- 
2.11.0
