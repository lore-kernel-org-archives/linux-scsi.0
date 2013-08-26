From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 4/9] target: Add global device list for EXTENDED_COPY
Date: Mon, 26 Aug 2013 22:03:03 +0000
Message-ID: <1377554588-28394-5-git-send-email-nab@daterainc.com>
References: <1377554588-28394-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377554588-28394-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Zach Brown <zab@redhat.com>, Kent Overstreet <kmo@daterainc.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

EXTENDED_COPY needs to be able to search a global list of devices
based on NAA WWN device identifiers, so add a simple g_device_list
protected by g_device_mutex.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: Roland Dreier <roland@purestorage.com>
Cc: Zach Brown <zab@redhat.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_device.c |   13 +++++++++++++
 include/target/target_core_base.h   |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index de89046..458944e 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -47,6 +47,9 @@
 #include "target_core_pr.h"
 #include "target_core_ua.h"
 
+DEFINE_MUTEX(g_device_mutex);
+LIST_HEAD(g_device_list);
+
 static struct se_hba *lun0_hba;
 /* not static, needed by tpg.c */
 struct se_device *g_lun0_dev;
@@ -1406,6 +1409,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	INIT_LIST_HEAD(&dev->delayed_cmd_list);
 	INIT_LIST_HEAD(&dev->state_list);
 	INIT_LIST_HEAD(&dev->qf_cmd_list);
+	INIT_LIST_HEAD(&dev->g_dev_node);
 	spin_lock_init(&dev->stats_lock);
 	spin_lock_init(&dev->execute_task_lock);
 	spin_lock_init(&dev->delayed_cmd_lock);
@@ -1525,6 +1529,11 @@ int target_configure_device(struct se_device *dev)
 	spin_lock(&hba->device_lock);
 	hba->dev_count++;
 	spin_unlock(&hba->device_lock);
+
+	mutex_lock(&g_device_mutex);
+	list_add_tail(&dev->g_dev_node, &g_device_list);
+	mutex_unlock(&g_device_mutex);
+
 	return 0;
 
 out_free_alua:
@@ -1543,6 +1552,10 @@ void target_free_device(struct se_device *dev)
 	if (dev->dev_flags & DF_CONFIGURED) {
 		destroy_workqueue(dev->tmr_wq);
 
+		mutex_lock(&g_device_mutex);
+		list_del(&dev->g_dev_node);
+		mutex_unlock(&g_device_mutex);
+
 		spin_lock(&hba->device_lock);
 		hba->dev_count--;
 		spin_unlock(&hba->device_lock);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 0783b2c..6b14f3c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -686,6 +686,7 @@ struct se_device {
 	struct list_head	delayed_cmd_list;
 	struct list_head	state_list;
 	struct list_head	qf_cmd_list;
+	struct list_head	g_dev_node;
 	/* Pointer to associated SE HBA */
 	struct se_hba		*se_hba;
 	/* T10 Inquiry and VPD WWN Information */
-- 
1.7.2.5
