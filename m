From: michaelc@cs.wisc.edu
Subject: [PATCH 06/13] libiscsi: change login data buffer allocation
Date: Tue,  2 Dec 2008 00:32:09 -0600
Message-ID: <1228199536-12595-7-git-send-email-michaelc@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-3-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-4-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-5-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-6-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52428 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbYLBGcY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:24 -0500
In-Reply-To: <1228199536-12595-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This modifies the login buffer allocation to use __get_free_pages.
It will allow drivers that want to send this data with zero copy
operations to easily line things up on page boundaries.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 656e213..0a99ca0 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2285,7 +2285,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 	}
 	spin_unlock_bh(&session->lock);
 
-	data = kmalloc(ISCSI_DEF_MAX_RECV_SEG_LEN, GFP_KERNEL);
+	data = (char *) __get_free_pages(GFP_KERNEL,
+					 get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	if (!data)
 		goto login_task_data_alloc_fail;
 	conn->login_task->data = conn->data = data;
@@ -2356,7 +2357,8 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	iscsi_suspend_tx(conn);
 
 	spin_lock_bh(&session->lock);
-	kfree(conn->data);
+	free_pages((unsigned long) conn->data,
+		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
 	__kfifo_put(session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
-- 
1.5.6.5

