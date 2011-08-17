From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 03/21] target: Use ERR_CAST inlined function
Date: Wed, 17 Aug 2011 23:17:07 +0000
Message-ID: <1313623045-15916-4-git-send-email-nab@linux-iscsi.org>
References: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:58296 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1HQXmS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 19:42:18 -0400
In-Reply-To: <1313623045-15916-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Thomas Meyer <thomas@m3y3r.de>

From: Thomas Meyer <thomas@m3y3r.de>

Use ERR_CAST inlined function instead of ERR_PTR(PTR_ERR(...))

The semantic patch that makes this output is available
in scripts/coccinelle/api/err_cast.cocci.

More information about semantic patching is available at
http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_configfs.c |    4 ++--
 drivers/target/target_core_fabric_configfs.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index f095e65..f1643db 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -268,7 +268,7 @@ struct se_tpg_np *lio_target_call_addnptotpg(
 				ISCSI_TCP);
 	if (IS_ERR(tpg_np)) {
 		iscsit_put_tpg(tpg);
-		return ERR_PTR(PTR_ERR(tpg_np));
+		return ERR_CAST(tpg_np);
 	}
 	pr_debug("LIO_Target_ConfigFS: addnptotpg done!\n");
 
@@ -1285,7 +1285,7 @@ struct se_wwn *lio_target_call_coreaddtiqn(
 
 	tiqn = iscsit_add_tiqn((unsigned char *)name);
 	if (IS_ERR(tiqn))
-		return ERR_PTR(PTR_ERR(tiqn));
+		return ERR_CAST(tiqn);
 	/*
 	 * Setup struct iscsi_wwn_stat_grps for se_wwn->fabric_stat_group.
 	 */
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index f165469..55bbe08 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -481,7 +481,7 @@ static struct config_group *target_fabric_make_nodeacl(
 
 	se_nacl = tf->tf_ops.fabric_make_nodeacl(se_tpg, group, name);
 	if (IS_ERR(se_nacl))
-		return ERR_PTR(PTR_ERR(se_nacl));
+		return ERR_CAST(se_nacl);
 
 	nacl_cg = &se_nacl->acl_group;
 	nacl_cg->default_groups = se_nacl->acl_default_groups;
-- 
1.7.6

