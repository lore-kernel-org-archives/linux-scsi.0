From: Lee Duncan <lduncan@suse.com>
Subject: [PATCHv2] SCSI: usd ida for host number management
Date: Wed, 20 Jan 2016 11:48:00 -0800
Message-ID: <1453319280-15417-1-git-send-email-lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com, emilne@redhat.com, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

Update the SCSI hosts module to use ida to manage its
host_no index instead of an ATOMIC integer. This means
that the SCSI host number will now be reclaimable.

Use the ida "simple" mechanism, since there should be no
need for a separate spin lock current usage. Ida was chosen
over idr because the hosts module already has its
own instance and locking mechanisms that aren't easily
changed.

Changes from v1:
* First version used regular ida routines

Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/hosts.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 82ac1cd818ac..94025c5cf797 100644
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
@@ -42,7 +42,7 @@
 #include "scsi_logging.h"
 
 
-static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);	/* host_no for next new host */
+static DEFINE_IDA(host_index_ida);
 
 
 static void scsi_host_cls_release(struct device *dev)
@@ -355,6 +355,8 @@ static void scsi_host_dev_release(struct device *dev)
 
 	kfree(shost->shost_data);
 
+	ida_simple_remove(&host_index_ida, shost->host_no);
+
 	if (parent)
 		put_device(parent);
 	kfree(shost);
@@ -388,6 +390,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
 	struct Scsi_Host *shost;
 	gfp_t gfp_mask = GFP_KERNEL;
+	int index;
 
 	if (sht->unchecked_isa_dma && privsize)
 		gfp_mask |= __GFP_DMA;
@@ -406,11 +409,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
 
-	/*
-	 * subtract one because we increment first then return, but we need to
-	 * know what the next host number was before increment
-	 */
-	shost->host_no = atomic_inc_return(&scsi_host_next_hn) - 1;
+	index = ida_simple_get(&host_index_ida, 0, 0, GFP_KERNEL);
+	if (index < 0)
+		goto fail_kfree;
+	shost->host_no = index;
+
 	shost->dma_channel = 0xff;
 
 	/* These three are default values which can be overridden */
@@ -495,7 +498,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
-		goto fail_kfree;
+		goto fail_index_remove;
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
@@ -511,6 +514,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
  fail_kthread:
 	kthread_stop(shost->ehandler);
+ fail_index_remove:
+	ida_simple_remove(&host_index_ida, shost->host_no);
  fail_kfree:
 	kfree(shost);
 	return NULL;
@@ -606,6 +611,7 @@ int scsi_init_hosts(void)
 void scsi_exit_hosts(void)
 {
 	class_unregister(&shost_class);
+	ida_destroy(&host_index_ida);
 }
 
 int scsi_is_host_device(const struct device *dev)
-- 
2.1.4
