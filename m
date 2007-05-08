From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 1/5] zfcp: Locking for req_no and req_seq_no
Date: Tue, 8 May 2007 11:15:48 +0200
Message-ID: <200705081115.48290.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:40488 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966124AbXEHJNJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 05:13:09 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

From: Christof Schmitt <christof.schmitt@de.ibm.com>

There is a possible race condition while generating the unique
request ids and sequence numbers. Both might be read at the
same time and have the same value. Fix this by serializing the
access through the queue lock of the adapter: First call
zfcp_fsf_req_sbal_get that acquires the lock, then read and
increment the unique ids.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- linux-2.6.orig/drivers/s390/scsi/zfcp_fsf.c	2007-05-07 13:56:57.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2007-05-07 13:57:34.000000000 +0200
@@ -4645,23 +4645,22 @@
 	fsf_req->adapter = adapter;
 	fsf_req->fsf_command = fsf_cmd;
 	INIT_LIST_HEAD(&fsf_req->list);
-	
-	/* this is serialized (we are holding req_queue-lock of adapter */
-	if (adapter->req_no == 0)
-		adapter->req_no++;
-	fsf_req->req_id = adapter->req_no++;
-
 	init_timer(&fsf_req->timer);
-	zfcp_fsf_req_qtcb_init(fsf_req);

 	/* initialize waitqueue which may be used to wait on 
 	   this request completion */
 	init_waitqueue_head(&fsf_req->completion_wq);

         ret = zfcp_fsf_req_sbal_get(adapter, req_flags, lock_flags);
-        if(ret < 0) {
+        if (ret < 0)
                 goto failed_sbals;
-	}
+
+	/* this is serialized (we are holding req_queue-lock of adapter) */
+	if (adapter->req_no == 0)
+		adapter->req_no++;
+	fsf_req->req_id = adapter->req_no++;
+
+	zfcp_fsf_req_qtcb_init(fsf_req);

 	/*
 	 * We hold queue_lock here. Check if QDIOUP is set and let request fail


-------------------------------------------------------
