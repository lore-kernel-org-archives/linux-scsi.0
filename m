From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 1/2] target: Fix APTPL metadata handling for dynamic MappedLUNs
Date: Sat,  4 Oct 2014 05:14:24 +0000
Message-ID: <1412399665-15057-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:65058 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaJDFnY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Oct 2014 01:43:24 -0400
Received: by mail-oi0-f52.google.com with SMTP id a3so1659709oib.25
        for <linux-scsi@vger.kernel.org>; Fri, 03 Oct 2014 22:43:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a bug in handling of SPC-3 PR Activate Persistence
across Target Power Loss (APTPL) logic where re-creation of state for
MappedLUNs from dynamically generated NodeACLs did not occur during
I_T Nexus establishment.

It adds the missing core_scsi3_check_aptpl_registration() call during
core_tpg_check_initiator_node_acl() -> core_tpg_add_node_to_devs() in
order to replay any pre-loaded APTPL metadata state associated with
the newly connected SCSI Initiator Port.

Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c |    3 ++-
 drivers/target/target_core_pr.c     |    6 +++---
 drivers/target/target_core_pr.h     |    2 +-
 drivers/target/target_core_tpg.c    |    8 ++++++++
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f5057a2..d18dd8b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1399,7 +1399,8 @@ int core_dev_add_initiator_node_lun_acl(
 	 * Check to see if there are any existing persistent reservation APTPL
 	 * pre-registrations that need to be enabled for this LUN ACL..
 	 */
-	core_scsi3_check_aptpl_registration(lun->lun_se_dev, tpg, lun, lacl);
+	core_scsi3_check_aptpl_registration(lun->lun_se_dev, tpg, lun, nacl,
+					    lacl->mapped_lun);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 48a8010..a06edb5 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -937,10 +937,10 @@ int core_scsi3_check_aptpl_registration(
 	struct se_device *dev,
 	struct se_portal_group *tpg,
 	struct se_lun *lun,
-	struct se_lun_acl *lun_acl)
+	struct se_node_acl *nacl,
+	u32 mapped_lun)
 {
-	struct se_node_acl *nacl = lun_acl->se_lun_nacl;
-	struct se_dev_entry *deve = nacl->device_list[lun_acl->mapped_lun];
+	struct se_dev_entry *deve = nacl->device_list[mapped_lun];
 
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return 0;
diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
index 2ee2936..749fd7b 100644
--- a/drivers/target/target_core_pr.h
+++ b/drivers/target/target_core_pr.h
@@ -60,7 +60,7 @@ extern int core_scsi3_alloc_aptpl_registration(
 			unsigned char *, u16, u32, int, int, u8);
 extern int core_scsi3_check_aptpl_registration(struct se_device *,
 			struct se_portal_group *, struct se_lun *,
-			struct se_lun_acl *);
+			struct se_node_acl *, u32);
 extern void core_scsi3_free_pr_reg_from_nacl(struct se_device *,
 					     struct se_node_acl *);
 extern void core_scsi3_free_all_registrations(struct se_device *);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 6ec5873..aa2b2d0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -40,6 +40,7 @@
 #include <target/target_core_fabric.h>
 
 #include "target_core_internal.h"
+#include "target_core_pr.h"
 
 extern struct se_device *g_lun0_dev;
 
@@ -166,6 +167,13 @@ void core_tpg_add_node_to_devs(
 
 		core_enable_device_list_for_node(lun, NULL, lun->unpacked_lun,
 				lun_access, acl, tpg);
+		/*
+		 * Check to see if there are any existing persistent reservation
+		 * APTPL pre-registrations that need to be enabled for this dynamic
+		 * LUN ACL now..
+		 */
+		core_scsi3_check_aptpl_registration(dev, tpg, lun, acl,
+						    lun->unpacked_lun);
 		spin_lock(&tpg->tpg_lun_lock);
 	}
 	spin_unlock(&tpg->tpg_lun_lock);
-- 
1.7.10.4

