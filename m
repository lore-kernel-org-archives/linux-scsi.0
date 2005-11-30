From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 1/8] iscsi: add rdma attr
Date: Tue, 29 Nov 2005 23:12:42 -0600
Message-ID: <1133327562.28356.37.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46522 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751012AbVK3FMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 00:12:50 -0500
Received: from [192.168.0.6] (c-69-180-176-191.hsd1.mn.comcast.net [69.180.176.191])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id jAU5CmFA009269
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 29 Nov 2005 23:12:49 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>From Erez Zilber:

Add AF and RDMA provider properties.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Alex Aizman <itn780@yahoo.com>
Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 4fea3e4..0027973 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -3590,6 +3590,8 @@ static struct iscsi_transport iscsi_tcp_
 	.name			= "tcp",
 	.caps			= CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_HDRDGST
 				  | CAP_DATADGST,
+	.af			= AF_INET,
+	.rdma			= 0,
 	.host_template		= &iscsi_sht,
 	.hostdata_size		= sizeof(struct iscsi_session),
 	.max_conn		= 1,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 49fd18c..bb2a3ee 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -117,6 +117,8 @@ show_transport_attr(caps, "0x%x");
 show_transport_attr(max_lun, "%d");
 show_transport_attr(max_conn, "%d");
 show_transport_attr(max_cmd_len, "%d");
+show_transport_attr(af, "%d");
+show_transport_attr(rdma, "%d");
 
 static struct attribute *iscsi_transport_attrs[] = {
 	&class_device_attr_handle.attr,
@@ -124,6 +126,8 @@ static struct attribute *iscsi_transport
 	&class_device_attr_max_lun.attr,
 	&class_device_attr_max_conn.attr,
 	&class_device_attr_max_cmd_len.attr,
+	&class_device_attr_af.attr,
+	&class_device_attr_rdma.attr,
 	NULL,
 };
 
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index f25041c..da44477 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -47,6 +47,8 @@ struct iscsi_transport {
 	struct module *owner;
 	char *name;
 	unsigned int caps;
+	unsigned short af;
+	unsigned short rdma;
 	struct scsi_host_template *host_template;
 	int hostdata_size;
 	int max_lun;


