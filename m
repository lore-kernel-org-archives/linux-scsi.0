From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] libfc: add stats info against memory leakage in exchange pool
Date: Sun, 24 Oct 2010 17:30:06 +0800
Message-ID: <AANLkTimzeO6Hou9ob4Z79twUY8RjwH6NP6ndKmoOUrEH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43137 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab0JXJaH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Oct 2010 05:30:07 -0400
Received: by wyf28 with SMTP id 28so2341066wyf.19
        for <linux-scsi@vger.kernel.org>; Sun, 24 Oct 2010 02:30:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

There seems stats info needed if mem leak is concerned.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_exch.c	2010-10-24 17:10:08.000000000 +0800
@@ -67,6 +67,11 @@ struct workqueue_struct *fc_exch_workque
 struct fc_exch_pool {
 	u16		 next_index;
 	u16		 total_exches;
+
+	/* stats info against memory leakage */
+	atomic_t	 allocated;
+	atomic_t	 released;
+
 	spinlock_t	 lock;
 	struct list_head ex_list;
 };
@@ -405,6 +410,8 @@ static void fc_exch_delete(struct fc_exc
 	fc_exch_ptr_set(pool, (ep->xid - ep->em->min_xid) >> fc_cpu_order,
 			NULL);
 	list_del(&ep->ex_list);
+	if (1 == atomic_read(&ep->ex_refcnt))
+		atomic_inc(&pool->released);
 	spin_unlock_bh(&pool->lock);
 	fc_exch_release(ep);	/* drop hold for exch in mp */
 }
@@ -689,6 +696,7 @@ static struct fc_exch *fc_exch_em_alloc(
 	pool->next_index = index == mp->pool_max_index ? 0 : index + 1;

 	fc_exch_hold(ep);	/* hold for exch in mp */
+	atomic_inc(&pool->allocated);
 	spin_lock_init(&ep->ex_lock);
 	/*
 	 * Hold exch lock for caller to prevent fc_exch_reset()
@@ -1699,6 +1707,12 @@ restart:
 			goto restart;
 		}
 	}
+	if (atomic_read(&pool->allocated) != atomic_read(&pool->released))
+		printk(KERN_WARNING "libfc: host %u exch pool %p "
+			"allocated %d released %d\n",
+			lport->host->host_no, pool,
+			atomic_read(&pool->allocated),
+			atomic_read(&pool->released));
 	spin_unlock_bh(&pool->lock);
 }
