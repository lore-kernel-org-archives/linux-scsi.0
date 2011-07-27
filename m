From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] target: Make standard INQUIRY return 'not connected' for tpg_virt_lun0
Date: Wed, 27 Jul 2011 00:45:17 +0000
Message-ID: <1311727518-1927-3-git-send-email-nab@linux-iscsi.org>
References: <1311727518-1927-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52617 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab1G0BJA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 21:09:00 -0400
In-Reply-To: <1311727518-1927-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Roland Dreier <roland@purestorage.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes target_emulate_inquiry_std() to set the 'not connected'
(0x35) bit in standard INQUIRY response data when we are processing a
request to a virtual LUN=0 mapping from struct se_device *g_lun0_dev that
have been setup for us in transport_lookup_cmd_lun().

This addresses an issue where qla2xxx FC clients need to be able
to create demo-mode I_T FC Nexuses by default, but should not be
exposing the default set of TPG LUNs to all FC clients.  This includes
adding an new optional target_core_fabric_ops->tpg_check_demo_mode_login_only()
caller to allow demo_mode nexuses to skip the old default of bulding
a demo-mode MappedLUNs list via core_tpg_add_node_to_devs().

Reported-by: Roland Dreier <roland@purestorage.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@risingtidesystems.com>
---
 drivers/target/target_core_cdb.c        |   11 ++++++++---
 drivers/target/target_core_tpg.c        |   12 ++++++++++--
 include/target/target_core_fabric_ops.h |    6 ++++++
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 3f84b16..4719e72 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -67,6 +67,7 @@ target_emulate_inquiry_std(struct se_cmd *cmd)
 {
 	struct se_lun *lun = cmd->se_lun;
 	struct se_device *dev = cmd->se_dev;
+	struct se_portal_group *tpg = lun->lun_sep->sep_tpg;
 	unsigned char *buf;
 
 	/*
@@ -81,9 +82,13 @@ target_emulate_inquiry_std(struct se_cmd *cmd)
 
 	buf = transport_kmap_first_data_page(cmd);
 
-	buf[0] = dev->transport->get_device_type(dev);
-	if (buf[0] == TYPE_TAPE)
-		buf[1] = 0x80;
+	if (dev == tpg->tpg_virt_lun0.lun_se_dev) {
+		buf[0] = 0x3f; /* Not connected */
+	} else {
+		buf[0] = dev->transport->get_device_type(dev);
+		if (buf[0] == TYPE_TAPE)
+			buf[1] = 0x80;
+	}
 	buf[2] = dev->transport->get_device_rev(dev);
 
 	/*
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 18f51b5..6cf0795 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -296,8 +296,16 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 		tpg->se_tpg_tfo->tpg_release_fabric_acl(tpg, acl);
 		return NULL;
 	}
-
-	core_tpg_add_node_to_devs(acl, tpg);
+	/*
+	 * Here we only create demo-mode MappedLUNs from the active
+	 * TPG LUNs if the fabric is not explictly asking for
+	 * tpg_check_demo_mode_login_only() == 1.
+	 */
+	if ((tpg->se_tpg_tfo->tpg_check_demo_mode_login_only != NULL) &&
+	    (tpg->se_tpg_tfo->tpg_check_demo_mode_login_only(tpg) == 1))
+		do { ; } while (0);
+	else
+		core_tpg_add_node_to_devs(acl, tpg);
 
 	spin_lock_bh(&tpg->acl_node_lock);
 	list_add_tail(&acl->acl_list, &tpg->acl_node_list);
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index 2de8fe9..126c675 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -27,6 +27,12 @@ struct target_core_fabric_ops {
 	int (*tpg_check_demo_mode_cache)(struct se_portal_group *);
 	int (*tpg_check_demo_mode_write_protect)(struct se_portal_group *);
 	int (*tpg_check_prod_mode_write_protect)(struct se_portal_group *);
+	/*
+	 * Optionally used by fabrics to allow demo-mode login, but not
+	 * expose any TPG LUNs, and return 'not connected' in standard
+	 * inquiry response
+	 */
+	int (*tpg_check_demo_mode_login_only)(struct se_portal_group *);
 	struct se_node_acl *(*tpg_alloc_fabric_acl)(
 					struct se_portal_group *);
 	void (*tpg_release_fabric_acl)(struct se_portal_group *,
-- 
1.7.2.5

