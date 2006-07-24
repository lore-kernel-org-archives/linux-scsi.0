From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 11/11] iscsi bugfixes: update and move version number
Date: Mon, 24 Jul 2006 15:47:54 -0500
Message-ID: <1153774074.1040.43.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:20160 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932168AbWGXUvp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 16:51:45 -0400
Received: from [192.168.0.7] (c-24-118-221-159.hsd1.mn.comcast.net [24.118.221.159])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k6OKpOv9012574
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2006 15:51:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The version info is useful for iscsi tcp, iser and qla4xxx so move to
transport class.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 33534f6..058f094 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -43,13 +43,10 @@ #include <scsi/scsi_transport_iscsi.h>
 
 #include "iscsi_tcp.h"
 
-#define ISCSI_TCP_VERSION "1.0-595"
-
 MODULE_AUTHOR("Dmitry Yusupov <dmitry_yus@yahoo.com>, "
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI/TCP data-path");
 MODULE_LICENSE("GPL");
-MODULE_VERSION(ISCSI_TCP_VERSION);
 /* #define DEBUG_TCP */
 #define DEBUG_ASSERT
 
@@ -2317,8 +2314,7 @@ static void iscsi_tcp_session_destroy(st
 }
 
 static struct scsi_host_template iscsi_sht = {
-	.name			= "iSCSI Initiator over TCP/IP, v"
-				  ISCSI_TCP_VERSION,
+	.name			= "iSCSI Initiator over TCP/IP",
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
 	.can_queue		= ISCSI_XMIT_CMDS_MAX - 1,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 30a47c1..6b71bad 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -34,6 +34,7 @@ #include <scsi/iscsi_if.h>
 #define ISCSI_SESSION_ATTRS 11
 #define ISCSI_CONN_ATTRS 11
 #define ISCSI_HOST_ATTRS 0
+#define ISCSI_TRANSPORT_VERSION "1.1-646"
 
 struct iscsi_internal {
 	int daemon_pid;
@@ -1613,6 +1614,9 @@ static __init int iscsi_transport_init(v
 {
 	int err;
 
+	printk(KERN_INFO "Loading iSCSI transport class v%s.",
+		ISCSI_TRANSPORT_VERSION);
+
 	err = class_register(&iscsi_transport_class);
 	if (err)
 		return err;
@@ -1678,3 +1682,4 @@ MODULE_AUTHOR("Mike Christie <michaelc@c
 	      "Alex Aizman <itn780@yahoo.com>");
 MODULE_DESCRIPTION("iSCSI Transport Interface");
 MODULE_LICENSE("GPL");
+MODULE_VERSION(ISCSI_TRANSPORT_VERSION);


