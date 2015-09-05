From: Lee Duncan <lduncan@suse.com>
Subject: [PATCH 1/1] Update scsi hosts to use idr for host number mgmt
Date: Sat,  5 Sep 2015 13:44:53 -0700
Message-ID: <05a1b95993cbb2b0ce9be8e088203c23f0e49107.1441412269.git.lduncan@suse.com>
References: <cover.1441412268.git.lduncan@suse.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35963 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751442AbbIEUpE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 5 Sep 2015 16:45:04 -0400
In-Reply-To: <cover.1441412268.git.lduncan@suse.com>
In-Reply-To: <cover.1441412268.git.lduncan@suse.com>
References: <cover.1441412268.git.lduncan@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, hare@suse.com, jthumshirn@suse.de, JBottomley@Parallels.com, Lee Duncan <lduncan@suse.com>

Each Scsi_host instance gets a host number starting
at 0, but this was implemented with an atomic integer,
and rollover wasn't considered. Another problem with
this design is that scsi host numbers used by iscsi
are never reused, thereby making rollover more likely.
This patch converts Scsi_host instances to use idr
to manage their instance numbers and to simplify
instance number to pointer lookups.

This also means that host instance numbers will be
reused, when available.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/scsi/hosts.c | 59 +++++++++++++++++++++++++---------------------------
 1 file changed, 28 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 8bb173e01084..1127a50e5942 100644
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
+static DEFINE_SPINLOCK(host_index_lock);
+static DEFINE_IDR(host_index_idr);
 
 
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
+	int idr_ret;
 
 	if (sht->unchecked_isa_dma && privsize)
 		gfp_mask |= __GFP_DMA;
@@ -388,11 +393,14 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	init_waitqueue_head(&shost->host_wait);
 	mutex_init(&shost->scan_mutex);
 
-	/*
-	 * subtract one because we increment first then return, but we need to
-	 * know what the next host number was before increment
-	 */
-	shost->host_no = atomic_inc_return(&scsi_host_next_hn) - 1;
+	idr_preload(GFP_KERNEL);
+	spin_lock(&host_index_lock);
+	idr_ret = idr_alloc(&host_index_idr, shost, 0, 0, GFP_NOWAIT);
+	spin_unlock(&host_index_lock);
+	idr_preload_end();
+	if (idr_ret < 0)
+		goto fail_kfree;
+	shost->host_no = idr_ret;
 	shost->dma_channel = 0xff;
 
 	/* These three are default values which can be overridden */
@@ -477,7 +485,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 		shost_printk(KERN_WARNING, shost,
 			"error handler thread failed to spawn, error = %ld\n",
 			PTR_ERR(shost->ehandler));
-		goto fail_kfree;
+		goto fail_idr_remove;
 	}
 
 	shost->tmf_work_q = alloc_workqueue("scsi_tmf_%d",
@@ -493,6 +501,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 
  fail_kthread:
 	kthread_stop(shost->ehandler);
+ fail_idr_remove:
+	spin_lock(&host_index_lock);
+	idr_remove(&host_index_idr, shost->host_no);
+	spin_unlock(&host_index_lock);
  fail_kfree:
 	kfree(shost);
 	return NULL;
@@ -522,37 +534,21 @@ void scsi_unregister(struct Scsi_Host *shost)
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
+	struct Scsi_Host *shost;
+
+	spin_lock(&host_index_lock);
+	shost = idr_find(&host_index_idr, hostnum);
+	spin_unlock(&host_index_lock);
+
 	return shost;
 }
 EXPORT_SYMBOL(scsi_host_lookup);
@@ -588,6 +584,7 @@ int scsi_init_hosts(void)
 void scsi_exit_hosts(void)
 {
 	class_unregister(&shost_class);
+	idr_destroy(&host_index_idr);
 }
 
 int scsi_is_host_device(const struct device *dev)
-- 
2.1.4

