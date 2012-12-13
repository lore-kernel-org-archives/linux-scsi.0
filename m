From: Xiaotian Feng <xtfeng@gmail.com>
Subject: [PATCH] megaraid: convert to work_struct
Date: Thu, 13 Dec 2012 16:53:18 +0800
Message-ID: <1355388798-12869-1-git-send-email-xtfeng@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tj@kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There's no need to use delayed work, convert to use work_struct and
cancel_work_sync().

Requested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas.h      |    2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |   15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 3b2365c..16b7a72 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1276,7 +1276,7 @@ struct megasas_evt_detail {
 } __attribute__ ((packed));
 
 struct megasas_aen_event {
-	struct delayed_work hotplug_work;
+	struct work_struct hotplug_work;
 	struct megasas_instance *instance;
 };
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index e4f2baa..416b280 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2060,9 +2060,8 @@ megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 		} else {
 			ev->instance = instance;
 			instance->ev = ev;
-			INIT_DELAYED_WORK(&ev->hotplug_work,
-					  megasas_aen_polling);
-			schedule_delayed_work(&ev->hotplug_work, 0);
+			INIT_WORK(&ev->hotplug_work, megasas_aen_polling);
+			schedule_work(&ev->hotplug_work);
 		}
 	}
 }
@@ -4349,10 +4348,10 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_HIBERNATE_SHUTDOWN);
 
-	/* cancel the delayed work if this work still in queue */
+	/* cancel the work if this work still in queue */
 	if (instance->ev != NULL) {
 		struct megasas_aen_event *ev = instance->ev;
-		cancel_delayed_work_sync(&ev->hotplug_work);
+		cancel_work_sync(&ev->hotplug_work);
 		instance->ev = NULL;
 	}
 
@@ -4541,10 +4540,10 @@ static void __devexit megasas_detach_one(struct pci_dev *pdev)
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 
-	/* cancel the delayed work if this work still in queue*/
+	/* cancel the work if this work still in queue*/
 	if (instance->ev != NULL) {
 		struct megasas_aen_event *ev = instance->ev;
-		cancel_delayed_work_sync(&ev->hotplug_work);
+		cancel_work_sync(&ev->hotplug_work);
 		instance->ev = NULL;
 	}
 
@@ -5188,7 +5187,7 @@ static void
 megasas_aen_polling(struct work_struct *work)
 {
 	struct megasas_aen_event *ev =
-		container_of(work, struct megasas_aen_event, hotplug_work.work);
+		container_of(work, struct megasas_aen_event, hotplug_work);
 	struct megasas_instance *instance = ev->instance;
 	union megasas_evt_class_locale class_locale;
 	struct  Scsi_Host *host;
-- 
1.7.9.5
