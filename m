From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/6] iscsi update: only preallocate login buffer
Date: Thu, 18 May 2006 20:31:34 -0500
Message-ID: <1148002294.3248.23.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60036 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932182AbWESBcx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 May 2006 21:32:53 -0400
Received: from [192.168.0.4] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k4J1WW4d007196
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 18 May 2006 20:32:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We only use the mtask data buffer for login tasks so we do not 
need to preallocate a buffer for every mtask. This saves
8 * 31 KB.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4750d48..580c050 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1258,15 +1258,6 @@ iscsi_session_setup(struct iscsi_transpo
 		if (mgmt_task_size)
 			mtask->dd_data = &mtask[1];
 		mtask->itt = ISCSI_MGMT_ITT_OFFSET + cmd_i;
-		mtask->data = kmalloc(DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH,
-				     GFP_KERNEL);
-		if (!mtask->data) {
-			int j;
-
-			for (j = 0; j < cmd_i; j++)
-				kfree(session->mgmt_cmds[j]->data);
-			goto immdata_alloc_fail;
-		}
 	}
 
 	if (scsi_add_host(shost, NULL))
@@ -1282,9 +1273,6 @@ iscsi_session_setup(struct iscsi_transpo
 cls_session_fail:
 	scsi_remove_host(shost);
 add_host_fail:
-	for (cmd_i = 0; cmd_i < session->mgmtpool_max; cmd_i++)
-		kfree(session->mgmt_cmds[cmd_i]->data);
-immdata_alloc_fail:
 	iscsi_pool_free(&session->mgmtpool, (void**)session->mgmt_cmds);
 mgmtpool_alloc_fail:
 	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
@@ -1305,13 +1293,9 @@ void iscsi_session_teardown(struct iscsi
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
-	int cmd_i;
 
 	scsi_remove_host(shost);
 
-	for (cmd_i = 0; cmd_i < session->mgmtpool_max; cmd_i++)
-		kfree(session->mgmt_cmds[cmd_i]->data);
-
 	iscsi_pool_free(&session->mgmtpool, (void**)session->mgmt_cmds);
 	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
 
@@ -1331,6 +1315,7 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	struct iscsi_session *session = class_to_transport_session(cls_session);
 	struct iscsi_conn *conn;
 	struct iscsi_cls_conn *cls_conn;
+	char *data;
 
 	cls_conn = iscsi_create_conn(cls_session, conn_idx);
 	if (!cls_conn)
@@ -1376,12 +1361,20 @@ iscsi_conn_setup(struct iscsi_cls_sessio
 	}
 	spin_unlock_bh(&session->lock);
 
+	data = kmalloc(DEFAULT_MAX_RECV_DATA_SEGMENT_LENGTH, GFP_KERNEL);
+	if (!data)
+		goto login_mtask_data_alloc_fail;
+	conn->login_mtask->data = data;
+
 	init_timer(&conn->tmabort_timer);
 	mutex_init(&conn->xmitmutex);
 	init_waitqueue_head(&conn->ehwait);
 
 	return cls_conn;
 
+login_mtask_data_alloc_fail:
+	__kfifo_put(session->mgmtpool.queue, (void*)&conn->login_mtask,
+		    sizeof(void*));
 login_mtask_alloc_fail:
 	kfifo_free(conn->mgmtqueue);
 mgmtqueue_alloc_fail:
@@ -1451,6 +1444,7 @@ void iscsi_conn_teardown(struct iscsi_cl
 	}
 
 	spin_lock_bh(&session->lock);
+	kfree(conn->login_mtask->data);
 	__kfifo_put(session->mgmtpool.queue, (void*)&conn->login_mtask,
 		    sizeof(void*));
 	list_del(&conn->item);


