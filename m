From: brking@us.ibm.com
Subject: [PATCH 11/16] ipr: Use kref instead of a kobject
Date: Wed, 04 Aug 2004 17:32:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200408042232.i74MWeoo326250@westrelay02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:2489 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S267475AbUHDWcn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Aug 2004 18:32:43 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


The following patch converts ipr to use a kref rather than a kobject to
do reference counting on an internal data structure. The added overhead
of a kobject is not needed.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c |   25 ++++++++++---------------
 linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h |    3 ++-
 2 files changed, 12 insertions(+), 16 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_kobj_kref_convert drivers/scsi/ipr.h
--- linux-2.6.8-rc3/drivers/scsi/ipr.h~ipr_kobj_kref_convert	2004-08-04 17:17:36.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.h	2004-08-04 17:17:36.000000000 -0500
@@ -29,6 +29,7 @@
 #include <linux/types.h>
 #include <linux/completion.h>
 #include <linux/list.h>
+#include <linux/kref.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #ifdef CONFIG_KDB
@@ -1031,7 +1032,7 @@ struct ipr_ioa_dump {
 }__attribute__((packed, aligned (4)));
 
 struct ipr_dump {
-	struct kobject kobj;
+	struct kref kref;
 	struct ipr_ioa_cfg *ioa_cfg;
 	struct ipr_driver_dump driver_dump;
 	struct ipr_ioa_dump ioa_dump;
diff -puN drivers/scsi/ipr.c~ipr_kobj_kref_convert drivers/scsi/ipr.c
--- linux-2.6.8-rc3/drivers/scsi/ipr.c~ipr_kobj_kref_convert	2004-08-04 17:17:36.000000000 -0500
+++ linux-2.6.8-rc3-bjking1/drivers/scsi/ipr.c	2004-08-04 17:17:36.000000000 -0500
@@ -1795,13 +1795,13 @@ static void ipr_worker_thread(void *data
 
 	if (ioa_cfg->sdt_state == GET_DUMP) {
 		dump = ioa_cfg->dump;
-		if (!dump || !kobject_get(&dump->kobj)) {
+		if (!dump || !kref_get(&dump->kref)) {
 			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 			return;
 		}
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		ipr_get_ioa_dump(ioa_cfg, dump);
-		kobject_put(&dump->kobj);
+		kref_put(&dump->kref);
 
 		spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 		if (ioa_cfg->sdt_state == DUMP_OBTAINED)
@@ -2396,7 +2396,7 @@ static ssize_t ipr_read_dump(struct kobj
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	dump = ioa_cfg->dump;
 
-	if (ioa_cfg->sdt_state != DUMP_OBTAINED || !dump || !kobject_get(&dump->kobj)) {
+	if (ioa_cfg->sdt_state != DUMP_OBTAINED || !dump || !kref_get(&dump->kref)) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		return 0;
 	}
@@ -2404,7 +2404,7 @@ static ssize_t ipr_read_dump(struct kobj
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
 	if (off > dump->driver_dump.hdr.len) {
-		kobject_put(&dump->kobj);
+		kref_put(&dump->kref);
 		return 0;
 	}
 
@@ -2454,20 +2454,20 @@ static ssize_t ipr_read_dump(struct kobj
 		count -= len;
 	}
 
-	kobject_put(&dump->kobj);
+	kref_put(&dump->kref);
 	return rc;
 }
 
 /**
  * ipr_release_dump - Free adapter dump memory
- * @kobj:	kobject struct
+ * @kref:	kref struct
  *
  * Return value:
  *	nothing
  **/
-static void ipr_release_dump(struct kobject *kobj)
+static void ipr_release_dump(struct kref *kref)
 {
-	struct ipr_dump *dump = container_of(kobj,struct ipr_dump,kobj);
+	struct ipr_dump *dump = container_of(kref,struct ipr_dump,kref);
 	struct ipr_ioa_cfg *ioa_cfg = dump->ioa_cfg;
 	unsigned long lock_flags = 0;
 	int i;
@@ -2485,10 +2485,6 @@ static void ipr_release_dump(struct kobj
 	LEAVE;
 }
 
-static struct kobj_type ipr_dump_kobj_type = {
-	.release = ipr_release_dump,
-};
-
 /**
  * ipr_alloc_dump - Prepare for adapter dump
  * @ioa_cfg:	ioa config struct
@@ -2510,8 +2506,7 @@ static int ipr_alloc_dump(struct ipr_ioa
 	}
 
 	memset(dump, 0, sizeof(struct ipr_dump));
-	kobject_init(&dump->kobj);
-	dump->kobj.ktype = &ipr_dump_kobj_type;
+	kref_init(&dump->kref, ipr_release_dump);
 	dump->ioa_cfg = ioa_cfg;
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -2558,7 +2553,7 @@ static int ipr_free_dump(struct ipr_ioa_
 	ioa_cfg->dump = NULL;
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	kobject_put(&dump->kobj);
+	kref_put(&dump->kref);
 
 	LEAVE;
 	return 0;
_
