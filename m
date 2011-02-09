From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 31/31] target: Fix generated *_drop_nodeacl() handler in tcm_mod_builder.py
Date: Wed,  9 Feb 2011 15:36:45 -0800
Message-ID: <1297294605-23662-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:44077 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750738Ab1BIXgl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Feb 2011 18:36:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Fubo Chen <fubo.chen@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Fubo Chen <fubo.chen@gmail.com>

This patch adds the missing core_tpg_del_initiator_node_acl() call required
by fabric modules for struct se_node_acl->acl_group context shutdown via

	target_core_fabric_configfs.c:target_fabric_nacl_base_release() ->

		struct target_core_fabric_ops->fabric_drop_nodeacl()

for tcm_mod_builder.py generated $FABRIC_MOD_configfs.c skeleton code.

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 Documentation/target/tcm_mod_builder.py |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
index 89af6c7..7ef9b84 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -289,6 +289,7 @@ def tcm_mod_build_configfs(proto_ident, fabric_mod_dir_var, fabric_mod_name):
 	buf += "{\n"
 	buf += "	struct " + fabric_mod_name + "_nacl *nacl = container_of(se_acl,\n"
 	buf += "				struct " + fabric_mod_name + "_nacl, se_node_acl);\n"
+	buf += "	core_tpg_del_initiator_node_acl(se_acl->se_tpg, se_acl, 1);\n"
 	buf += "	kfree(nacl);\n"
 	buf += "}\n\n"
 
-- 
1.7.4

