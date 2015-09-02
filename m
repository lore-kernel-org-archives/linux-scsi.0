From: Lee Duncan <lduncan@suse.com>
Subject: [PATCHv3] Update scsi host to use ida for host number
Date: Tue,  1 Sep 2015 17:03:28 -0700
Message-ID: <1441152208-20634-1-git-send-email-lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751169AbbIBADh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Sep 2015 20:03:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@Parallels.com, hare@suse.com, jthumshirn@suse.de, Lee Duncan <lduncan@suse.com>

Each Scsi_host instance gets a host number starting
at 0, but this is implemented with an atomic integer,
and rollover doesn't seem to have been considered.
Another side-effect of this design is that scsi host
numbers used by iscsi are never reused, thereby  making
rollover more likely. This patch converts Scsi_host
instances to use ida to manage their instance
numbers.

This also means that host instance numbers will be
reused, when available.

Changes from v2:
* Use host_put_index() throughout
* Put host index code together
Changes from v1:
* Added inline host_put_index() and its use

Signed-off-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/hosts.c | 47 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e01084..a47944867e65 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -33,7 +33,7 @@
 #include <linux/transport_class.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-
+#include <linux/idr.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
@@ -42,8 +42,6 @@
 #include "scsi_logging.h"
 
 
-static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);	/* host_no for next new host */
-
 
 static void scsi_host_cls_release(struct device *dev)
 {
@@ -304,6 +302,31 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 }
 EXPORT_SYMBOL(scsi_add_host_with_dma);
 
+static DEFINE_SPINLOCK(host_index_lock);
+static DEFINE_IDA(host_index_ida);
+
+static int host_get_index(int *index)
+{
+	int error = -ENOMEM;
+
+	do {
+		if (!ida_pre_get(&host_index_ida, GFP_KERNEL))
+			break;
+		spin_lock(&host_index_lock);
+		error = ida_get_new(&host_index_ida, index);
+		spin_unlock(&host_index_lock);
+	} while (error == -EAGAIN);
+
+	return error;
+}
+
+static inline void host_put_index(int index)
+{
+	spin_lock(&host_index_lock);
+	ida_remove(&host_index_ida, index);
+	spin_unlock(&host_index_lock);
+}
+
 static void scsi_host_dev_release(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
@@ -337,6 +360,8 @@ static void scsi_host_dev_release(struct device *dev)
 
 	kfree(shost->shost_data);
 
+	host_put_index(shost->host_no);
+
 	if (parent)
 		put_device(parent);
 	kfree(shost);
@@ -370,6 +395,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
 	struct Scsi_Host *shost;
 	gfp_t gfp_mask = GFP_KERNEL;
+	int index;
+	int error;
 
 	if (sht->unchecked_isa_dma && privsize)
 		gfp_mask |= __GFP_DMA;
@@ -388,11 +415,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
 
-	/*
-	 * subtract one because we increment first then return, but we need to
-	 * know what the next host number was before increment
-	 */
-	shost->host_no = atomic_inc_return(&scsi_host_next_hn) - 1;
+	error = host_get_index(&index);
+	if (error < 0)
+		goto fail_kfree;
+	shost->host_no = index;
+
 	shost->dma_channel = 0xff;
 
 	/* These three are default values which can be overridden */
@@ -477,7 +504,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
-		goto fail_kfree;
+		goto fail_free_index;
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
@@ -493,6 +520,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
  fail_kthread:
 	kthread_stop(shost->ehandler);
+ fail_free_index:
+	host_put_index(index);
  fail_kfree:
 	kfree(shost);
 	return NULL;
-- 
2.1.4

