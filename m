From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 10/11] iscsi bugfixes: fix mem leaks in libiscsi
Date: Mon, 24 Jul 2006 15:47:50 -0500
Message-ID: <1153774070.1040.42.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:19648 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751446AbWGXUvT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:51:19 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKowgW012571
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:51:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

We were leaking some strings. This patch just frees them.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index c628c63..5884cd2 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1357,6 +1357,8 @@ void iscsi_session_teardown(struct iscsi
 	iscsi_pool_free(&session->mgmtpool, (void**)session->mgmt_cmds);
 	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
 
+	kfree(session->targetname);
+
 	iscsi_destroy_session(cls_session);
 	scsi_host_put(shost);
 	module_put(owner);
@@ -1491,6 +1493,7 @@ void iscsi_conn_teardown(struct iscsi_cl
 
 	spin_lock_bh(&session->lock);
 	kfree(conn->data);
+	kfree(conn->persistent_address);
 	__kfifo_put(session->mgmtpool.queue, (void*)&conn->login_mtask,
 		    sizeof(void*));
 	list_del(&conn->item);


