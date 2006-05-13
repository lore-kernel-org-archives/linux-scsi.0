From: Matthew Wilcox <matthew@wil.cx>
Subject: Some fixes for the SRP driver
Date: Fri, 12 May 2006 22:44:45 -0600
Message-ID: <20060513044445.GQ12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54746 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S932328AbWEMEoq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 May 2006 00:44:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-scsi@vger.kernel.org


Hi Roland,

I happened to glance at the SRP driver this evening and found some
problems, so here's a patch to fix them.  Only lightly compile-tested,
but the fixes seem obvious enough.

First, the host has a mutex_lock to protect the list of targets.
This seems very wasteful as it's normally only used to protect a simple
list add/delete operation, and the one case that isn't isn't going to
take long either.

Second, you use list_for_each_entry_safe() when you aren't modifying the
list.  I changed it to just list_for_each_entry().

Third, SCAN_WILD_CARD is indeed available from <scsi/scsi.h>, which you
already include.


I have some further suggestions:

 - You might consider moving this driver to drivers/scsi.  It's actually
   fairly small compared to most scsi drivers, and basically you've got
   two files plus Kbuild/Kconfig machinery.  Seems a bit silly, plus
   people would notice this scsi driver more readily.
 - I'm not convinced you need the target list/lock I mention above.
   The Scsi_Host structure has a list of associated targets, although
   I don't see a good iterator for them right now.


Anyway, feel free to use whichever pieces of this patch interest you:

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: drivers/infiniband/ulp/srp/ib_srp.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/infiniband/ulp/srp/ib_srp.c,v
retrieving revision 1.9
diff -u -p -r1.9 ib_srp.c
--- drivers/infiniband/ulp/srp/ib_srp.c	27 Apr 2006 04:58:48 -0000	1.9
+++ drivers/infiniband/ulp/srp/ib_srp.c	13 May 2006 04:27:29 -0000
@@ -357,9 +357,9 @@ static void srp_remove_work(void *target
 	target->state = SRP_TARGET_REMOVED;
 	spin_unlock_irq(target->scsi_host->host_lock);
 
-	mutex_lock(&target->srp_host->target_mutex);
+	spin_lock(&target->srp_host->target_lock);
 	list_del(&target->list);
-	mutex_unlock(&target->srp_host->target_mutex);
+	spin_unlock(&target->srp_host->target_lock);
 
 	scsi_remove_host(target->scsi_host);
 	ib_destroy_cm_id(target->cm_id);
@@ -1339,15 +1339,14 @@ static int srp_add_target(struct srp_hos
 	if (scsi_add_host(target->scsi_host, host->dev->dma_device))
 		return -ENODEV;
 
-	mutex_lock(&host->target_mutex);
+	spin_lock(&host->target_lock);
 	list_add_tail(&target->list, &host->target_list);
-	mutex_unlock(&host->target_mutex);
+	spin_unlock(&host->target_lock);
 
 	target->state = SRP_TARGET_LIVE;
 
-	/* XXX: are we supposed to have a definition of SCAN_WILD_CARD ?? */
 	scsi_scan_target(&target->scsi_host->shost_gendev,
-			 0, target->scsi_id, ~0, 0);
+			 0, target->scsi_id, SCAN_WILD_CARD, 0);
 
 	return 0;
 }
@@ -1612,7 +1611,7 @@ static struct srp_host *srp_add_port(str
 		return NULL;
 
 	INIT_LIST_HEAD(&host->target_list);
-	mutex_init(&host->target_mutex);
+	spin_lock_init(&host->target_lock);
 	init_completion(&host->released);
 	host->dev  = device;
 	host->port = port;
@@ -1713,15 +1712,14 @@ static void srp_remove_one(struct ib_dev
 		 * Mark all target ports as removed, so we stop queueing
 		 * commands and don't try to reconnect.
 		 */
-		mutex_lock(&host->target_mutex);
-		list_for_each_entry_safe(target, tmp_target,
-					 &host->target_list, list) {
+		spin_lock(&host->target_lock);
+		list_for_each_entry(target, &host->target_list, list) {
 			spin_lock_irqsave(target->scsi_host->host_lock, flags);
 			if (target->state != SRP_TARGET_REMOVED)
 				target->state = SRP_TARGET_REMOVED;
 			spin_unlock_irqrestore(target->scsi_host->host_lock, flags);
 		}
-		mutex_unlock(&host->target_mutex);
+		spin_unlock(&host->target_lock);
 
 		/*
 		 * Wait for any reconnection tasks that may have
Index: drivers/infiniband/ulp/srp/ib_srp.h
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/infiniband/ulp/srp/ib_srp.h,v
retrieving revision 1.5
diff -u -p -r1.5 ib_srp.h
--- drivers/infiniband/ulp/srp/ib_srp.h	3 Apr 2006 13:44:16 -0000	1.5
+++ drivers/infiniband/ulp/srp/ib_srp.h	13 May 2006 04:27:29 -0000
@@ -37,7 +37,7 @@
 
 #include <linux/types.h>
 #include <linux/list.h>
-#include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <linux/scatterlist.h>
 
 #include <scsi/scsi_host.h>
@@ -85,7 +85,7 @@ struct srp_host {
 	struct ib_mr	       *mr;
 	struct class_device	class_dev;
 	struct list_head	target_list;
-	struct mutex            target_mutex;
+	spinlock_t              target_lock;
 	struct completion	released;
 	struct list_head	list;
 };
