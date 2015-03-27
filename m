From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 22/22] target: Rename se_port/se_device export to target_* prefix
Date: Fri, 27 Mar 2015 08:05:12 +0000
Message-ID: <1427443512-8925-23-git-send-email-nab@daterainc.com>
References: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:32907 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbbC0IGf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2015 04:06:35 -0400
Received: by obvd1 with SMTP id d1so1601712obv.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2015 01:06:34 -0700 (PDT)
In-Reply-To: <1427443512-8925-1-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This includes:

  - target_alloc_port
  - target_export_port
  - target_release_port
  - target_dev_export
  - target_dev_unexport

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c   | 16 ++++++++--------
 drivers/target/target_core_internal.h |  4 ++--
 drivers/target/target_core_tpg.c      |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 5b225d8..efbc840 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -486,7 +486,7 @@ void target_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 	mutex_unlock(&tpg->acl_node_mutex);
 }
 
-static struct se_port *core_alloc_port(struct se_device *dev)
+static struct se_port *target_alloc_port(struct se_device *dev)
 {
 	struct se_port *port, *port_tmp;
 
@@ -538,7 +538,7 @@ again:
 	return port;
 }
 
-static void core_export_port(
+static void target_export_port(
 	struct se_device *dev,
 	struct se_portal_group *tpg,
 	struct se_port *port,
@@ -580,7 +580,7 @@ static void core_export_port(
 /*
  *	Called with struct se_device->se_port_lock spinlock held.
  */
-static void core_release_port(struct se_device *dev, struct se_port *port)
+static void target_release_port(struct se_device *dev, struct se_port *port)
 	__releases(&dev->se_port_lock) __acquires(&dev->se_port_lock)
 {
 	/*
@@ -599,7 +599,7 @@ static void core_release_port(struct se_device *dev, struct se_port *port)
 	kfree(port);
 }
 
-int core_dev_export(
+int target_dev_export(
 	struct se_device *dev,
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
@@ -607,7 +607,7 @@ int core_dev_export(
 	struct se_hba *hba = dev->se_hba;
 	struct se_port *port;
 
-	port = core_alloc_port(dev);
+	port = target_alloc_port(dev);
 	if (IS_ERR(port))
 		return PTR_ERR(port);
 
@@ -617,11 +617,11 @@ int core_dev_export(
 	dev->export_count++;
 	spin_unlock(&hba->device_lock);
 
-	core_export_port(dev, tpg, port, lun);
+	target_export_port(dev, tpg, port, lun);
 	return 0;
 }
 
-void core_dev_unexport(
+void target_dev_unexport(
 	struct se_device *dev,
 	struct se_portal_group *tpg,
 	struct se_lun *lun)
@@ -637,7 +637,7 @@ void core_dev_unexport(
 	spin_unlock(&lun->lun_sep_lock);
 
 	spin_lock(&dev->se_port_lock);
-	core_release_port(dev, port);
+	target_release_port(dev, port);
 	spin_unlock(&dev->se_port_lock);
 
 	spin_lock(&hba->device_lock);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 6c8b7fb..240e5ba 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -14,9 +14,9 @@ int	target_enable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
 int	target_disable_device_list_for_node(struct se_lun *, struct se_lun_acl *,
 		u32, u32, struct se_node_acl *, struct se_portal_group *);
 void	target_clear_lun_from_tpg(struct se_lun *, struct se_portal_group *);
-int	core_dev_export(struct se_device *, struct se_portal_group *,
+int	target_dev_export(struct se_device *, struct se_portal_group *,
 		struct se_lun *);
-void	core_dev_unexport(struct se_device *, struct se_portal_group *,
+void	target_dev_unexport(struct se_device *, struct se_portal_group *,
 		struct se_lun *);
 struct se_lun *core_dev_add_lun(struct se_portal_group *, struct se_device *, u32);
 void	core_dev_del_lun(struct se_portal_group *, struct se_lun *);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index b10071d..ee6af20 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -795,7 +795,7 @@ int target_add_lun(
 	if (ret < 0)
 		return ret;
 
-	ret = core_dev_export(dev, tpg, lun);
+	ret = target_dev_export(dev, tpg, lun);
 	if (ret < 0) {
 		percpu_ref_exit(&lun->lun_ref);
 		return ret;
@@ -816,7 +816,7 @@ void target_remove_lun(
 	target_clear_lun_from_tpg(lun, tpg);
 	transport_clear_lun_ref(lun);
 
-	core_dev_unexport(lun->lun_se_dev, tpg, lun);
+	target_dev_unexport(lun->lun_se_dev, tpg, lun);
 
 	mutex_lock(&tpg->tpg_lun_mutex);
 	lun->lun_status = TRANSPORT_LUN_STATUS_FREE;
-- 
1.9.1

