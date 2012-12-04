From: Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] workqueue fixes for 3.7-rc8
Date: Tue, 4 Dec 2012 08:24:08 -0800
Message-ID: <20121204162408.GH3885@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:35257 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab2LDQYO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2012 11:24:14 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <xtfeng@gmail.com>, Neela Syam Kolli <megaraidlinux@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org

Hello, Linus.

So, safe fixes my ass.  8852aac ("workqueue: mod_delayed_work_on()
shouldn't queue timer on 0 delay") had the side-effect of performing
delayed_work sanity checks even when @delay is 0, which should be fine
for any sane use cases.

Unfortunately, megaraid was being overly ingenious.  It seemingly
wanted to use cancel_delayed_work_sync() before cancel_work_sync() was
introduced, but didn't want to waste the space for full delayed_work
as it was only gonna use 0 @delay.  So, it only allocated space for
struct work_struct and then casted it to struct delayed_work and
passed it into delayed_work functions - truly awesome engineering
tradeoff to save some bytes.

Xiaotian fixed it by making megraid allocate full delayed_work for
now.  It should be converted to use work_struct and cancel_work_sync()
but I think we better do that after 3.7.

I added another commit to change BUG_ON()s in __queue_delayed_work()
to WARN_ON_ONCE()s so that the kernel doens't crash even if there are
more such abuses.

Please pull from the following branch to receive the two patches.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.7-fixes

----------------------------------------------------------------
Tejun Heo (1):
      workqueue: convert BUG_ON()s in __queue_delayed_work() to WARN_ON_ONCE()s

Xiaotian Feng (1):
      megaraid: fix BUG_ON() from incorrect use of delayed work

 drivers/scsi/megaraid/megaraid_sas.h      |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 14 ++++++--------
 kernel/workqueue.c                        |  4 ++--
 3 files changed, 9 insertions(+), 11 deletions(-)

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
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 084aa47..1dae900 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1361,8 +1361,8 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 
 	WARN_ON_ONCE(timer->function != delayed_work_timer_fn ||
 		     timer->data != (unsigned long)dwork);
-	BUG_ON(timer_pending(timer));
-	BUG_ON(!list_empty(&work->entry));
+	WARN_ON_ONCE(timer_pending(timer));
+	WARN_ON_ONCE(!list_empty(&work->entry));
 
 	/*
 	 * If @delay is 0, queue @dwork->work immediately.  This is for
