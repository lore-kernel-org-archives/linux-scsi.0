From: Jean Delvare <jdelvare@suse.de>
Subject: [PATCH] [SCSI] libiscsi: fix iscsi pool error path
Date: Wed, 18 Feb 2009 20:35:23 +0100
Message-ID: <200902182035.23939.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:49126 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011AbZBRTfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Feb 2009 14:35:24 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

Memory freeing in iscsi_pool_free() looks wrong to me. Either q->pool
can be NULL and this should be tested before dereferencing it, or it
can't be NULL and it shouldn't be tested at all. As far as I can see,
the only case where q->pool is NULL is on early error in
iscsi_pool_init(). One possible way to fix the bug is thus to not
call iscsi_pool_free() in this case (nothing needs to be freed anyway)
and then we can get rid of the q->pool check.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Mike Christie <michaelc@cs.wisc.edu>
---
Another possible fix is to move the q->pool check one line up. Both
are fine with me.

 drivers/scsi/libiscsi.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.29-rc5.orig/drivers/scsi/libiscsi.c	2009-01-29 08:27:19.000000000 +0100
+++ linux-2.6.29-rc5/drivers/scsi/libiscsi.c	2009-02-16 21:19:14.000000000 +0100
@@ -1944,7 +1944,7 @@ iscsi_pool_init(struct iscsi_pool *q, in
 		num_arrays++;
 	q->pool = kzalloc(num_arrays * max * sizeof(void*), GFP_KERNEL);
 	if (q->pool == NULL)
-		goto enomem;
+		return -ENOMEM;
 
 	q->queue = kfifo_init((void*)q->pool, max * sizeof(void*),
 			      GFP_KERNEL, NULL);
@@ -1979,8 +1979,7 @@ void iscsi_pool_free(struct iscsi_pool *
 
 	for (i = 0; i < q->max; i++)
 		kfree(q->pool[i]);
-	if (q->pool)
-		kfree(q->pool);
+	kfree(q->pool);
 	kfree(q->queue);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);

-- 
Jean Delvare
Suse L3
