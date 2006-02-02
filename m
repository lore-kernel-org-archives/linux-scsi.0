From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 7/9] iscsi update: fix mgmt pool err path release
Date: Wed, 01 Feb 2006 21:07:09 -0600
Message-ID: <1138849629.3456.40.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:32948 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1423073AbWBBDHl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2006 22:07:41 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

>From ogerlitz@voltaire.com:

mgmtpool shoild be frees in immdata_alloc_fail label.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index f5ba940..a79e37b 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -3316,8 +3316,8 @@ iscsi_session_create(struct scsi_transpo
 r2tpool_alloc_fail:
 	for (cmd_i = 0; cmd_i < session->mgmtpool_max; cmd_i++)
 		kfree(session->mgmt_cmds[cmd_i]->data);
-	iscsi_pool_free(&session->mgmtpool, (void**)session->mgmt_cmds);
 immdata_alloc_fail:
+	iscsi_pool_free(&session->mgmtpool, (void**)session->mgmt_cmds);
 mgmtpool_alloc_fail:
 	iscsi_pool_free(&session->cmdpool, (void**)session->cmds);
 cmdpool_alloc_fail:


