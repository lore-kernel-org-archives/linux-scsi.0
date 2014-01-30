From: Dave Jones <davej@redhat.com>
Subject: libsrp: remove unreachable kfree
Date: Thu, 30 Jan 2014 14:19:07 -0500
Message-ID: <20140130191907.GA13810@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbaA3TTQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jan 2014 14:19:16 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0UJJEqh005671
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2014 14:19:14 -0500
Received: from gelk.kernelslacker.org (ovpn-113-176.phx2.redhat.com [10.3.113.176])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s0UJJ8kU017353
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2014 14:19:14 -0500
Received: from gelk.kernelslacker.org (localhost [127.0.0.1])
	by gelk.kernelslacker.org (8.14.7/8.14.7) with ESMTP id s0UJJ7jE014729
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2014 14:19:07 -0500
Received: (from davej@localhost)
	by gelk.kernelslacker.org (8.14.7/8.14.7/Submit) id s0UJJ7A2014728
	for linux-scsi@vger.kernel.org; Thu, 30 Jan 2014 14:19:07 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

srp_iu_pool_alloc implements what seems like a standard "common exit path with gotos"
but there's only one way to reach it. Additionally the kfree(q->items) is unreachable.

fold the error path back into the if.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 0707ecdbaa32..f45758f15381 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -55,9 +55,12 @@ static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
 	q->pool = kcalloc(max, sizeof(struct iu_entry *), GFP_KERNEL);
 	if (!q->pool)
 		return -ENOMEM;
+
 	q->items = kcalloc(max, sizeof(struct iu_entry), GFP_KERNEL);
-	if (!q->items)
-		goto free_pool;
+	if (!q->items) {
+		kfree(q->pool);
+		return -ENOMEM;
+	}
 
 	spin_lock_init(&q->lock);
 	kfifo_init(&q->queue, (void *) q->pool, max * sizeof(void *));
@@ -68,11 +71,6 @@ static int srp_iu_pool_alloc(struct srp_queue *q, size_t max,
 		iue++;
 	}
 	return 0;
-
-	kfree(q->items);
-free_pool:
-	kfree(q->pool);
-	return -ENOMEM;
 }
 
 static void srp_iu_pool_free(struct srp_queue *q)
