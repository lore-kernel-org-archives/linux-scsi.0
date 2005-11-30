From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 7/8] iscsi: lower queue depth
Date: Tue, 29 Nov 2005 23:12:59 -0600
Message-ID: <1133327579.28356.44.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:49594 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751034AbVK3FNc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 00:13:32 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id jAU5DV0k009287
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:13:32 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Wang Zhenyu:

High queue depth was a problem for some targets so make queue_depth adjustable

>From Mike Christie

Make default queue_depth a little lower


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 287fea4..d9658b0 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2402,6 +2402,15 @@ fault:
 }
 
 static int
+iscsi_change_queue_depth(struct scsi_device *sdev, int depth)
+{
+	if (depth > ISCSI_MAX_CMD_PER_LUN)
+		depth = ISCSI_MAX_CMD_PER_LUN;
+	scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+	return sdev->queue_depth;
+}
+
+static int
 iscsi_pool_init(struct iscsi_queue *q, int max, void ***items, int item_size)
 {
 	int i;
@@ -3260,13 +3269,14 @@ iscsi_r2tpool_free(struct iscsi_session 
 static struct scsi_host_template iscsi_sht = {
 	.name			= "iSCSI Initiator over TCP/IP, v."
 				  ISCSI_VERSION_STR,
-        .queuecommand           = iscsi_queuecommand,
+	.queuecommand           = iscsi_queuecommand,
+	.change_queue_depth	= iscsi_change_queue_depth,
 	.can_queue		= ISCSI_XMIT_CMDS_MAX - 1,
 	.sg_tablesize		= ISCSI_SG_TABLESIZE,
-	.cmd_per_lun		= ISCSI_CMD_PER_LUN,
-        .eh_abort_handler       = iscsi_eh_abort,
-        .eh_host_reset_handler	= iscsi_eh_host_reset,
-        .use_clustering         = DISABLE_CLUSTERING,
+	.cmd_per_lun		= ISCSI_DEF_CMD_PER_LUN,
+	.eh_abort_handler       = iscsi_eh_abort,
+	.eh_host_reset_handler	= iscsi_eh_host_reset,
+	.use_clustering         = DISABLE_CLUSTERING,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 };
diff --git a/drivers/scsi/iscsi_tcp.h b/drivers/scsi/iscsi_tcp.h
index d23ae68..855f2df 100644
--- a/drivers/scsi/iscsi_tcp.h
+++ b/drivers/scsi/iscsi_tcp.h
@@ -71,7 +71,8 @@
 #define ISCSI_MGMT_CMDS_MAX		32	/* must be power of 2 */
 #define ISCSI_MGMT_ITT_OFFSET		0xa00
 #define ISCSI_SG_TABLESIZE		SG_ALL
-#define ISCSI_CMD_PER_LUN		128
+#define ISCSI_DEF_CMD_PER_LUN		32
+#define ISCSI_MAX_CMD_PER_LUN		128
 #define ISCSI_TCP_MAX_CMD_LEN		16
 
 #define ITT_MASK			(0xfff)


