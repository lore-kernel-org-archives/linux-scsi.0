From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] target: Call missing list_del() for demo-mode MappedLUN disable
Date: Wed, 19 Jan 2011 23:26:02 -0800
Message-ID: <1295508362-20011-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.104]:42560 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753305Ab1ATHZ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2011 02:25:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, John Hawley <warthog9@kernel.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a v4.0 specific bug that was not properly addressed
in commit 31dd8f6971ad:

commit 31dd8f6971ad62f4a849d98cafecf23675575e88
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Sun Jan 16 20:50:54 2011 -0800

    target: Fix demo-mode MappedLUN shutdown UA/PR breakage

The main point is that list_del(&deve->alua_port_list); *must* be
called via core_update_device_list_for_node() for each demo-mode
struct se_node_acl specific MappedLUN that is being disabled when
a dynamic struct se_node_acl->device_list[] is being released in
core_free_device_list_for_node().

Reported-by: John Hawley <warthog9@kernel.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 89b3893..4c2bd9c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -369,15 +369,14 @@ int core_update_device_list_for_node(
 		/*
 		 * deve->se_lun_acl will be NULL for demo-mode created LUNs
 		 * that have not been explictly concerted to MappedLUNs ->
-		 * struct se_lun_acl.  This means that active UAs and
+		 * struct se_lun_acl, but we remove deve->alua_port_list from
+		 * port->sep_alua_list. This also means that active UAs and
 		 * NodeACL context specific PR metadata for demo-mode
 		 * MappedLUN *deve will be released below..
 		 */
-		if (deve->se_lun_acl != NULL) {
-			spin_lock_bh(&port->sep_alua_lock);
-			list_del(&deve->alua_port_list);
-			spin_unlock_bh(&port->sep_alua_lock);
-		}
+		spin_lock_bh(&port->sep_alua_lock);
+		list_del(&deve->alua_port_list);
+		spin_unlock_bh(&port->sep_alua_lock);
 	}
 
 	spin_lock_irq(&nacl->device_list_lock);
-- 
1.5.6.5

