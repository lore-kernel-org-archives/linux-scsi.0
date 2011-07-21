From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 017/103] target: Rename se_dev->g_se_dev_list to se_dev_node
Date: Thu, 21 Jul 2011 00:04:53 -0700
Message-ID: <1311231979-6631-18-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm11-vm0.bullet.mail.bf1.yahoo.com ([98.139.213.136]:29947 "HELO
	nm11-vm0.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752035Ab1GUHGR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:17 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

The g_ annotation might lead one to believe this is a global variable,
when it is per-subsystem. Calling it se_dev_node also connotes the member
is for being put on a list, and it is not the head of a list itself.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_configfs.c |    6 +++---
 drivers/target/target_core_device.c   |    2 +-
 include/target/target_core_base.h     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index d140258..03cda0e 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2748,7 +2748,7 @@ static struct config_group *target_core_make_subdev(
 				" struct se_subsystem_dev\n");
 		goto unlock;
 	}
-	INIT_LIST_HEAD(&se_dev->g_se_dev_list);
+	INIT_LIST_HEAD(&se_dev->se_dev_node);
 	INIT_LIST_HEAD(&se_dev->t10_wwn.t10_vpd_list);
 	spin_lock_init(&se_dev->t10_wwn.t10_vpd_lock);
 	INIT_LIST_HEAD(&se_dev->t10_reservation.registration_list);
@@ -2785,7 +2785,7 @@ static struct config_group *target_core_make_subdev(
 		goto out;
 	}
 	spin_lock(&se_global->g_device_lock);
-	list_add_tail(&se_dev->g_se_dev_list, &se_global->g_se_dev_list);
+	list_add_tail(&se_dev->se_dev_node, &se_global->g_se_dev_list);
 	spin_unlock(&se_global->g_device_lock);
 
 	config_group_init_type_name(&se_dev->se_dev_group, name,
@@ -2882,7 +2882,7 @@ static void target_core_drop_subdev(
 	t = hba->transport;
 
 	spin_lock(&se_global->g_device_lock);
-	list_del(&se_dev->g_se_dev_list);
+	list_del(&se_dev->se_dev_node);
 	spin_unlock(&se_global->g_device_lock);
 
 	dev_stat_grp = &DEV_STAT_GRP(se_dev)->stat_group;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index f03e0cc..4d8da32 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1589,7 +1589,7 @@ int core_dev_setup_virtual_lun0(void)
 		ret = -ENOMEM;
 		goto out;
 	}
-	INIT_LIST_HEAD(&se_dev->g_se_dev_list);
+	INIT_LIST_HEAD(&se_dev->se_dev_node);
 	INIT_LIST_HEAD(&se_dev->t10_wwn.t10_vpd_list);
 	spin_lock_init(&se_dev->t10_wwn.t10_vpd_lock);
 	INIT_LIST_HEAD(&se_dev->t10_reservation.registration_list);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e35338d..8467a8d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -730,7 +730,7 @@ struct se_subsystem_dev {
 	struct t10_reservation_template t10_reservation;
 	spinlock_t      se_dev_lock;
 	void            *se_dev_su_ptr;
-	struct list_head g_se_dev_list;
+	struct list_head se_dev_node;
 	struct config_group se_dev_group;
 	/* For T10 Reservations */
 	struct config_group se_dev_pr_group;
-- 
1.7.6

