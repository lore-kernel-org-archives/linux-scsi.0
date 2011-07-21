From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 014/103] target: dev->dev_status_queue_obj is unused
Date: Thu, 21 Jul 2011 00:04:50 -0700
Message-ID: <1311231979-6631-15-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm7.bullet.mail.bf1.yahoo.com ([98.139.212.166]:40273 "HELO
	nm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752378Ab1GUHH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:26 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

Looks safe to remove.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    |    1 -
 drivers/target/target_core_transport.c |   12 ------------
 include/target/target_core_base.h      |    1 -
 3 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 818c65b..f03e0cc 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -755,7 +755,6 @@ void se_release_device_for_hba(struct se_device *dev)
 	core_scsi3_free_all_registrations(dev);
 	se_release_vpd_for_dev(dev);
 
-	kfree(dev->dev_status_queue_obj);
 	kfree(dev->dev_queue_obj);
 	kfree(dev);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ae153bf..fffa905 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1642,17 +1642,6 @@ struct se_device *transport_add_device_to_core_hba(
 	}
 	transport_init_queue_obj(dev->dev_queue_obj);
 
-	dev->dev_status_queue_obj = kzalloc(sizeof(struct se_queue_obj),
-					GFP_KERNEL);
-	if (!(dev->dev_status_queue_obj)) {
-		printk(KERN_ERR "Unable to allocate memory for"
-				" dev->dev_status_queue_obj\n");
-		kfree(dev->dev_queue_obj);
-		kfree(dev);
-		return NULL;
-	}
-	transport_init_queue_obj(dev->dev_status_queue_obj);
-
 	dev->dev_flags		= device_flags;
 	dev->dev_status		|= TRANSPORT_DEVICE_DEACTIVATED;
 	dev->dev_ptr		= (void *) transport_dev;
@@ -1753,7 +1742,6 @@ out:
 
 	se_release_vpd_for_dev(dev);
 
-	kfree(dev->dev_status_queue_obj);
 	kfree(dev->dev_queue_obj);
 	kfree(dev);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e35e9e4..b2b4cf9 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -784,7 +784,6 @@ struct se_device {
 	struct se_obj		dev_access_obj;
 	struct se_obj		dev_export_obj;
 	struct se_queue_obj	*dev_queue_obj;
-	struct se_queue_obj	*dev_status_queue_obj;
 	spinlock_t		delayed_cmd_lock;
 	spinlock_t		ordered_cmd_lock;
 	spinlock_t		execute_task_lock;
-- 
1.7.6

