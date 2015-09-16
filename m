From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 02/17] Update scsi hosts to use idr for host number mgmt
Date: Wed, 16 Sep 2015 10:50:20 -0700
Message-ID: <c5ece2397e004538d993bff03afe39f09aae10cf.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
In-Reply-To: <cover.1442263513.git.lduncan@suse.com>
References: <cover.1442263513.git.lduncan@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, hare@suse.com, jthumshirn@suse.de, hch@infradead.org, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

Each Scsi_Host instance gets a host number starting
at 0, but this was implemented with an atomic integer,
and rollover wasn't considered. Another problem with
this design is that scsi host numbers used by iscsi
are never reused, thereby making rollover more likely.
This patch converts Scsi_Host instances to use idr
to manage their instance numbers and to simplify
instance number to pointer lookups.

This also means that host instance numbers will be
reused, when available.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/hosts.c | 59 ++++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e01084..61201bc03b98 100644
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
@@ -304,6 +302,19 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 }
 EXPORT_SYMBOL(scsi_add_host_with_dma);
 
+static DEFINE_SPINLOCK(host_index_lock);
+static DEFINE_IDR(host_index_idr);
+
+static inline int host_get_index(void *ptr)
+{
+	return idr_get_index(&host_index_idr, &host_index_lock, ptr);
+}
+
+static inline void host_put_index(int index)
+{
+	idr_put_index(&host_index_idr, &host_index_lock, index);
+}
+
 static void scsi_host_dev_release(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev);
@@ -337,6 +348,8 @@ static void scsi_host_dev_release(struct device *dev)
 
 	kfree(shost->shost_data);
 
+	host_put_index(shost->host_no);
+
 	if (parent)
 		put_device(parent);
 	kfree(shost);
@@ -370,6 +383,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 {
 	struct Scsi_Host *shost;
 	gfp_t gfp_mask = GFP_KERNEL;
+	int index;
 
 	if (sht->unchecked_isa_dma && privsize)
 		gfp_mask |= __GFP_DMA;
@@ -388,11 +402,11 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
 
-	/*
-	 * subtract one because we increment first then return, but we need to
-	 * know what the next host number was before increment
-	 */
-	shost->host_no = atomic_inc_return(&scsi_host_next_hn) - 1;
+	index = host_get_index(shost);
+	if (index < 0)
+		goto fail_kfree;
+	shost->host_no = index;
+
 	shost->dma_channel = 0xff;
 
 	/* These three are default values which can be overridden */
@@ -477,7 +491,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
-		goto fail_kfree;
+		goto fail_idr_remove;
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
@@ -493,6 +507,8 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
  fail_kthread:
 	kthread_stop(shost->ehandler);
+ fail_idr_remove:
+	host_put_index(shost->host_no);
  fail_kfree:
 	kfree(shost);
 	return NULL;
@@ -522,38 +538,16 @@ void scsi_unregister(struct Scsi_Host *shost)
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
  *
  * Return value:
  *	A pointer to located Scsi_Host or NULL.
- *
- *	The caller must do a scsi_host_put() to drop the reference
- *	that scsi_host_get() took. The put_device() below dropped
- *	the reference from class_find_device().
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
+	return idr_find(&host_index_idr, hostnum);
 }
 EXPORT_SYMBOL(scsi_host_lookup);
 
@@ -588,6 +582,7 @@ int scsi_init_hosts(void)
 void scsi_exit_hosts(void)
 {
 	class_unregister(&shost_class);
+	idr_destroy(&host_index_idr);
 }
 
 int scsi_is_host_device(const struct device *dev)
-- 
2.1.4
