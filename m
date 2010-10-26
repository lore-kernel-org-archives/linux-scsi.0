From: Hillf Danton <dhillf@gmail.com>
Subject: Re: [PATCH] libfc: add stats info against memory leakage in exchange pool
Date: Tue, 26 Oct 2010 21:24:44 +0800
Message-ID: <AANLkTi=QbmJM7qCFnAvdVXcE=4sprA7MtMzMLvHvtxmd@mail.gmail.com>
References: <AANLkTimzeO6Hou9ob4Z79twUY8RjwH6NP6ndKmoOUrEH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36682 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab0JZNYq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2010 09:24:46 -0400
Received: by wwe15 with SMTP id 15so4739835wwe.1
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2010 06:24:45 -0700 (PDT)
In-Reply-To: <AANLkTimzeO6Hou9ob4Z79twUY8RjwH6NP6ndKmoOUrEH@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: devel@open-fcoe.org
Cc: linux-scsi@vger.kernel.org

This is the second version, with a fault in the previous version fixed.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
+++ b/drivers/scsi/libfc/fc_exch.c	2010-10-26 21:24:22.000000000 +0800
@@ -67,6 +67,11 @@ struct workqueue_struct *fc_exch_workque
 struct fc_exch_pool {
 	u16		 next_index;
 	u16		 total_exches;
+
+	/* stats info against memory leakage */
+	atomic_t         allocated;
+	atomic_t         released;
+
 	spinlock_t	 lock;
 	struct list_head ex_list;
 };
@@ -326,6 +331,7 @@ static void fc_exch_release(struct fc_ex
 	struct fc_exch_mgr *mp;

 	if (atomic_dec_and_test(&ep->ex_refcnt)) {
+		atomic_inc(&ep->pool->released);
 		mp = ep->em;
 		if (ep->destructor)
 			ep->destructor(&ep->seq, ep->arg);
@@ -688,6 +694,7 @@ static struct fc_exch *fc_exch_em_alloc(
 	}
 	pool->next_index = index == mp->pool_max_index ? 0 : index + 1;

+	atomic_inc(&pool->allocated);
 	fc_exch_hold(ep);	/* hold for exch in mp */
 	spin_lock_init(&ep->ex_lock);
 	/*
@@ -1699,6 +1706,14 @@ restart:
 			goto restart;
 		}
 	}
+
+	if (atomic_read(&pool->allocated) != atomic_read(&pool->released))
+		printk(KERN_WARNING "libfc: host %u exch pool %p "
+			"allocated %d released %d\n",
+			lport->host->host_no, pool,
+			atomic_read(&pool->allocated),
+			atomic_read(&pool->released));
+
 	spin_unlock_bh(&pool->lock);
 }
