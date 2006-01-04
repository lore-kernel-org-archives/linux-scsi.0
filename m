From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH] dont decrement counters from scsi_kill_request
Date: Wed, 04 Jan 2006 01:44:47 -0600
Message-ID: <1136360688.9634.2.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:61315 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751195AbWADHoy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jan 2006 02:44:54 -0500
Received: from [192.168.0.5] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id k047irvg008088
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 4 Jan 2006 01:44:54 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This was debugged by zhenyu.z.wang@intel.com on the open-iscsi lists.

When we call scsi_kill_request() we have not yet incremented the
device and host busy counters so calling __scsi_done from
scsi_kill_request ends up doing extra decrements.

This patch has only been compile tested against scsi-misc. I am not
sure what the correct blk_complete_barrier_rq values should be. For
failures are we supposed to return zero or what is left in the command
and what how are we supposed set to indicate a error?

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>



diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a7f3f0c..4b6a9fc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1514,8 +1514,6 @@ static void scsi_kill_request(struct req
 {
 	struct scsi_cmnd *cmd = req->special;
 
-	blkdev_dequeue_request(req);
-
 	if (unlikely(cmd == NULL)) {
 		printk(KERN_CRIT "impossible request in %s.\n",
 				 __FUNCTION__);
@@ -1523,9 +1521,19 @@ static void scsi_kill_request(struct req
 	}
 
 	scsi_init_cmd_errh(cmd);
-	cmd->result = DID_NO_CONNECT << 16;
 	atomic_inc(&cmd->device->iorequest_cnt);
-	__scsi_done(cmd);
+
+	blkdev_dequeue_request(req);
+	req->errors = DID_NO_CONNECT << 16;
+
+	if (blk_complete_barrier_rq(q, req, cmd->bufflen  >> 9)); 
+		return;
+
+	scsi_release_buffers(cmd);
+	while (end_that_request_first(req, 0, req->nr_sectors))
+		;
+	end_that_request_last(req);
+	scsi_put_command(cmd);
 }
 
 /*


