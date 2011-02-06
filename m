From: Fubo Chen <fubo.chen@gmail.com>
Subject: target: Fix crash triggered by removing node ACL
Date: Sun, 6 Feb 2011 20:52:34 +0100
Message-ID: <AANLkTikJLdR58V-tvCPYYFc4pAxv_mzJ0LFZGMJ=BtKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48298 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab1BFTwf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Feb 2011 14:52:35 -0500
Received: by iwn9 with SMTP id 9so3938005iwn.19
        for <linux-scsi@vger.kernel.org>; Sun, 06 Feb 2011 11:52:34 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

With tcm_mvsas creating tpg, creating acl, removing acl and removing
tpg triggers kernel crash during removing tpg.
With patch below crash disappears. Does patch make sense ?

Signed-off-by: Fubo Chen <fubo.chen@gmail.com>

---
 Documentation/target/tcm_mod_builder.py |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/target/tcm_mod_builder.py
b/Documentation/target/tcm_mod_builder.py
index 89af6c7..3925481 100755
--- a/Documentation/target/tcm_mod_builder.py
+++ b/Documentation/target/tcm_mod_builder.py
@@ -57,6 +57,7 @@ def tcm_mod_build_FC_include(fabric_mod_dir_var,
fabric_mod_name):
 	buf += "	char nport_name[" + fabric_mod_name.upper() + "_NAMELEN];\n"
 	buf += "	/* Returned by " + fabric_mod_name + "_make_nodeacl() */\n"
 	buf += "	struct se_node_acl se_node_acl;\n"
+	buf += "	struct se_portal_group *se_tpg;\n"
 	buf += "};\n"
 	buf += "\n"
 	buf += "struct " + fabric_mod_name + "_tpg {\n"
@@ -112,6 +113,7 @@ def tcm_mod_build_SAS_include(fabric_mod_dir_var,
fabric_mod_name):
 	buf += "	char iport_name[" + fabric_mod_name.upper() + "_NAMELEN];\n"
 	buf += "	/* Returned by " + fabric_mod_name + "_make_nodeacl() */\n"
 	buf += "	struct se_node_acl se_node_acl;\n"
+	buf += "	struct se_portal_group *se_tpg;\n"
 	buf += "};\n\n"
 	buf += "struct " + fabric_mod_name + "_tpg {\n"
 	buf += "	/* SAS port target portal group tag for TCM */\n"
@@ -163,6 +165,7 @@ def
tcm_mod_build_iSCSI_include(fabric_mod_dir_var, fabric_mod_name):
 	buf += "	char iport_name[" + fabric_mod_name.upper() + "_NAMELEN];\n"
 	buf += "	/* Returned by " + fabric_mod_name + "_make_nodeacl() */\n"
 	buf += "	struct se_node_acl se_node_acl;\n"
+	buf += "	struct se_portal_group *se_tpg;\n"
 	buf += "};\n\n"
 	buf += "struct " + fabric_mod_name + "_tpg {\n"
 	buf += "	/* iSCSI target portal group tag for TCM */\n"
@@ -278,6 +281,7 @@ def tcm_mod_build_configfs(proto_ident,
fabric_mod_dir_var, fabric_mod_name):
 	buf += "	 * Locate our struct " + fabric_mod_name + "_nacl and set
the FC Nport WWPN\n"
 	buf += "	 */\n"
 	buf += "	nacl = container_of(se_nacl, struct " + fabric_mod_name +
"_nacl, se_node_acl);\n"
+	buf += "	nacl->se_tpg = se_tpg;\n"

 	if proto_ident == "FC" or proto_ident == "SAS":
 		buf += "	nacl->" + fabric_mod_init_port + "_wwpn = wwpn;\n"
@@ -289,6 +293,7 @@ def tcm_mod_build_configfs(proto_ident,
fabric_mod_dir_var, fabric_mod_name):
 	buf += "{\n"
 	buf += "	struct " + fabric_mod_name + "_nacl *nacl = container_of(se_acl,\n"
 	buf += "				struct " + fabric_mod_name + "_nacl, se_node_acl);\n"
+	buf += "	core_tpg_del_initiator_node_acl(nacl->se_tpg, se_acl, 1);\n"
 	buf += "	kfree(nacl);\n"
 	buf += "}\n\n"

-- 
1.7.1
