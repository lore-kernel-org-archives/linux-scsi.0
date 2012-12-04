From: Xiaotian Feng <xtfeng@gmail.com>
Subject: [PATCH] megaraid: fix use of delayed work
Date: Tue,  4 Dec 2012 19:33:54 +0800
Message-ID: <1354620834-2953-1-git-send-email-xtfeng@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, tj@kernel.org
Cc: Xiaotian Feng <xtfeng@gmail.com>, Xiaotian Feng <dannyfeng@tencent.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

megaraid use INIT_WORK to declare a hotplug_work, but cast the hotplug_work
from work_struct to delayed_work and schedule_delayed_work on it. This is
very dangerous, as other part of delayed_work might be kernel memories allocated
by others.

With commit 8852aac, schedule_delayed_work() will check dwork->timer before
queue_work, this will cause megaraid code to hit the BUG_ON in workqueue code.
Change megaraid code to use delayed work.

Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/megaraid/megaraid_sas.h      |    2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |   14 ++++++--------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 16b7a72..3b2365c 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1276,7 +1276,7 @@ struct megasas_evt_detail {
 } __attribute__ ((packed));
 
 struct megasas_aen_event {
-	struct work_struct hotplug_work;
+	struct delayed_work hotplug_work;
 	struct megasas_instance *instance;
 };
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index d2c5366..e4f2baa 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2060,9 +2060,9 @@ megasas_service_aen(struct megasas_instance *instance, struct megasas_cmd *cmd)
 		} else {
 			ev->instance = instance;
 			instance->ev = ev;
-			INIT_WORK(&ev->hotplug_work, megasas_aen_polling);
-			schedule_delayed_work(
-				(struct delayed_work *)&ev->hotplug_work, 0);
+			INIT_DELAYED_WORK(&ev->hotplug_work,
+					  megasas_aen_polling);
+			schedule_delayed_work(&ev->hotplug_work, 0);
 		}
 	}
 }
@@ -4352,8 +4352,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 	/* cancel the delayed work if this work still in queue */
 	if (instance->ev != NULL) {
 		struct megasas_aen_event *ev = instance->ev;
-		cancel_delayed_work_sync(
-			(struct delayed_work *)&ev->hotplug_work);
+		cancel_delayed_work_sync(&ev->hotplug_work);
 		instance->ev = NULL;
 	}
 
@@ -4545,8 +4544,7 @@ static void __devexit megasas_detach_one(struct pci_dev *pdev)
 	/* cancel the delayed work if this work still in queue*/
 	if (instance->ev != NULL) {
 		struct megasas_aen_event *ev = instance->ev;
-		cancel_delayed_work_sync(
-			(struct delayed_work *)&ev->hotplug_work);
+		cancel_delayed_work_sync(&ev->hotplug_work);
 		instance->ev = NULL;
 	}
 
@@ -5190,7 +5188,7 @@ static void
 megasas_aen_polling(struct work_struct *work)
 {
 	struct megasas_aen_event *ev =
-		container_of(work, struct megasas_aen_event, hotplug_work);
+		container_of(work, struct megasas_aen_event, hotplug_work.work);
 	struct megasas_instance *instance = ev->instance;
 	union megasas_evt_class_locale class_locale;
 	struct  Scsi_Host *host;
-- 
1.7.9.6 (Apple Git-31.1)
