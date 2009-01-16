From: michaelc@cs.wisc.edu
Subject: [PATCH 1/2] libiscsi: fix iscsi pool leak
Date: Fri, 16 Jan 2009 12:36:51 -0600
Message-ID: <12321310122973-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48689 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757249AbZAPSg6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2009 13:36:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

I am not sure what happened. It looks like we have always leaked
the q->queue that is allocated from the kfifo_init call. nab finally
noticed that we were leaking and this patch fixes it by adding a
kfree call to iscsi_pool_free. kfifo_free is not used per kfifo_init's
instructions to use kfree.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 7225b6e..257c241 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1981,6 +1981,7 @@ void iscsi_pool_free(struct iscsi_pool *q)
 		kfree(q->pool[i]);
 	if (q->pool)
 		kfree(q->pool);
+	kfree(q->queue);
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
-- 
1.6.0.4

