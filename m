From: michaelc@cs.wisc.edu
Subject: [PATCH 01/14] libiscsi: fix iscsi pool error path
Date: Thu,  5 Mar 2009 14:45:55 -0600
Message-ID: <12362859693831-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52740 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbZCEUqR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:17 -0500
In-Reply-To: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jean Delvare <jdelvare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>

From: Jean Delvare <jdelvare@suse.de>

Memory freeing in iscsi_pool_free() looks wrong to me. Either q->pool
can be NULL and this should be tested before dereferencing it, or it
can't be NULL and it shouldn't be tested at all. As far as I can see,
the only case where q->pool is NULL is on early error in
iscsi_pool_init(). One possible way to fix the bug is thus to not
call iscsi_pool_free() in this case (nothing needs to be freed anyway)
and then we can get rid of the q->pool check.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 809d32d..c33e28f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1944,7 +1944,7 @@ iscsi_pool_init(struct iscsi_pool *q, int max, void ***items, int item_size)
 		num_arrays++;
 	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
 	if (q->pool == NULL)
-		goto enomem;
+		return -ENOMEM;
 
 	q->queue = kfifo_init((void*)q->pool, max * sizeof(void*),
 			      GFP_KERNEL, NULL);
@@ -1979,8 +1979,7 @@ void iscsi_pool_free(struct iscsi_pool *q)
 
 	for (i = 0; i < q->max; i++)
 		kfree(q->pool[i]);
-	if (q->pool)
-		kfree(q->pool);
+	kfree(q->pool);
 	kfree(q->queue);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
-- 
1.6.0.6

