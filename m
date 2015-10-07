From: Lee Duncan <lduncan@suse.com>
Subject: [PATCHv4 1/1] SCSI: hosts: update to use ida_simple for host_no management
Date: Wed,  7 Oct 2015 16:51:34 -0700
Message-ID: <f89fe3933ae899dc01f2eddd2a0cefac3383cf3c.1444241058.git.lduncan@suse.com>
References: <cover.1444241058.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1444241058.git.lduncan@suse.com>
In-Reply-To: <cover.1444241058.git.lduncan@suse.com>
References: <cover.1444241058.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Update the SCSI hosts module to use the ida_simple*() routines
to manage its host_no index instead of an ATOMIC integer. This
means that the SCSI host number will now be reclaimable.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/hosts.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e01084..b6a5ffa886b7 100644
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
@@ -337,6 +337,8 @@ static void scsi_host_dev_release(struct device *dev)
 
 	kfree(shost->shost_data);
 
+	ida_simple_remove(&host_index_ida, shost->host_no);
+
 	if (parent)
 		put_device(parent);
 	kfree(shost);
@@ -370,6 +372,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
 	struct Scsi_Host *shost;
 	gfp_t gfp_mask = GFP_KERNEL;
+	int index;
 
 	if (sht->unchecked_isa_dma && privsize)
 		gfp_mask |= __GFP_DMA;
@@ -388,11 +391,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
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
@@ -477,7 +480,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
-		goto fail_kfree;
+		goto fail_index_remove;
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
@@ -493,6 +496,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
  fail_kthread:
 	kthread_stop(shost->ehandler);
+ fail_index_remove:
+	ida_simple_remove(&host_index_ida, shost->host_no);
  fail_kfree:
 	kfree(shost);
 	return NULL;
@@ -588,6 +593,7 @@ int scsi_init_hosts(void)
 void scsi_exit_hosts(void)
 {
 	class_unregister(&shost_class);
+	ida_destroy(&host_index_ida);
 }
 
 int scsi_is_host_device(const struct device *dev)
-- 
2.1.4
