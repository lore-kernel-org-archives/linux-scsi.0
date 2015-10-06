From: Lee Duncan <lduncan@suse.com>
Subject: [PATCHv3 1/1] SCSI: update hosts module to use idr index management
Date: Tue,  6 Oct 2015 12:08:20 -0700
Message-ID: <e86885050b0dd09b2ed47a5dd5fd705cd747cc94.1444157464.git.lduncan@suse.com>
References: <cover.1444157464.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1444157464.git.lduncan@suse.com>
In-Reply-To: <cover.1444157464.git.lduncan@suse.com>
References: <cover.1444157464.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lee Duncan <lduncan@suse.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <tj@kernel.org>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Update the SCSI hosts module to use idr to manage
its host_no index instead of an ATOMIC integer. This
also allows using idr_find() to look up the SCSI
host structure given the host number.

This means that the SCSI host number will now
be reclaimable.

Signed-off-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/hosts.c | 61 ++++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e01084..afe7bd962ddb 100644
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
@@ -41,8 +41,8 @@
 #include "scsi_priv.h"
 #include "scsi_logging.h"
 
-
-static atomic_t scsi_host_next_hn = ATOMIC_INIT(0);	/* host_no for next new host */
+static DEFINE_IDR(host_index_idr);
+static DEFINE_SPINLOCK(host_index_lock);
 
 
 static void scsi_host_cls_release(struct device *dev)
@@ -337,6 +337,10 @@ static void scsi_host_dev_release(struct device *dev)
 
 	kfree(shost->shost_data);
 
+	spin_lock(&host_index_lock);
+	idr_remove(&host_index_idr, shost->host_no);
+	spin_unlock(&host_index_lock);
+
 	if (parent)
 		put_device(parent);
 	kfree(shost);
@@ -370,6 +374,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
 	struct Scsi_Host *shost;
 	gfp_t gfp_mask = GFP_KERNEL;
+	int index;
 
 	if (sht->unchecked_isa_dma && privsize)
 		gfp_mask |= __GFP_DMA;
@@ -388,11 +393,15 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
 
-	/*
-	 * subtract one because we increment first then return, but we need to
-	 * know what the next host number was before increment
-	 */
-	shost->host_no = atomic_inc_return(&scsi_host_next_hn) - 1;
+	idr_preload(GFP_KERNEL);
+	spin_lock(&host_index_lock);
+	index = idr_alloc(&host_index_idr, shost, 0, 0, GFP_NOWAIT);
+	spin_unlock(&host_index_lock);
+	idr_preload_end();
+	if (index < 0)
+		goto fail_kfree;
+	shost->host_no = index;
+
 	shost->dma_channel = 0xff;
 
 	/* These three are default values which can be overridden */
@@ -477,7 +486,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
-		goto fail_kfree;
+		goto fail_idr_remove;
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
@@ -493,6 +502,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
  fail_kthread:
 	kthread_stop(shost->ehandler);
+ fail_idr_remove:
+	spin_lock(&host_index_lock);
+	idr_remove(&host_index_idr, shost->host_no);
+	spin_unlock(&host_index_lock);
  fail_kfree:
 	kfree(shost);
 	return NULL;
@@ -522,15 +535,6 @@ void scsi_unregister(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL(scsi_unregister);
 
-static int __scsi_host_match(struct device *dev, const void *data)
-{
-	struct Scsi_Host *p;
-	const unsigned short *hostnum = data;
-
-	p = class_to_shost(dev);
-	return p->host_no == *hostnum;
-}
-
 /**
  * scsi_host_lookup - get a reference to a Scsi_Host by host no
  * @hostnum:	host number to locate
@@ -539,21 +543,17 @@ static int __scsi_host_match(struct device *dev, const void *data)
  *	A pointer to located Scsi_Host or NULL.
  *
  *	The caller must do a scsi_host_put() to drop the reference
- *	that scsi_host_get() took. The put_device() below dropped
- *	the reference from class_find_device().
+ *	that scsi_host_get() takes.
  **/
 struct Scsi_Host *scsi_host_lookup(unsigned short hostnum)
 {
-	struct device *cdev;
-	struct Scsi_Host *shost = NULL;
-
-	cdev = class_find_device(&shost_class, NULL, &hostnum,
-				 __scsi_host_match);
-	if (cdev) {
-		shost = scsi_host_get(class_to_shost(cdev));
-		put_device(cdev);
-	}
-	return shost;
+	struct Scsi_Host *shost;
+
+	spin_lock(&host_index_lock);
+	shost = idr_find(&host_index_idr, hostnum);
+	spin_unlock(&host_index_lock);
+
+	return shost ? scsi_host_get(shost) : NULL;
 }
 EXPORT_SYMBOL(scsi_host_lookup);
 
@@ -588,6 +588,7 @@ int scsi_init_hosts(void)
 void scsi_exit_hosts(void)
 {
 	class_unregister(&shost_class);
+	idr_destroy(&host_index_idr);
 }
 
 int scsi_is_host_device(const struct device *dev)
-- 
2.1.4
