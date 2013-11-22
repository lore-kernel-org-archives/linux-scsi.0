From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 4/8] scsi_transport_iscsi: Export ISCSI_PARAM_LOCAL_IPADDR attr for iscsi_connection
Date: Fri, 22 Nov 2013 05:28:20 -0500
Message-ID: <1385116104-19784-5-git-send-email-vikas.chaudhary@qlogic.com>
References: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:18607 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755433Ab3KVLBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Nov 2013 06:01:15 -0500
In-Reply-To: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

This attribute specifies the local IP address used to establish connection.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 4 ++++
 include/scsi/iscsi_if.h             | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4cf918a..fd8ffe6 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -3772,6 +3772,7 @@ iscsi_conn_attr(ipv6_flow_label, ISCSI_PARAM_IPV6_FLOW_LABEL);
 iscsi_conn_attr(is_fw_assigned_ipv6, ISCSI_PARAM_IS_FW_ASSIGNED_IPV6);
 iscsi_conn_attr(tcp_xmit_wsf, ISCSI_PARAM_TCP_XMIT_WSF);
 iscsi_conn_attr(tcp_recv_wsf, ISCSI_PARAM_TCP_RECV_WSF);
+iscsi_conn_attr(local_ipaddr, ISCSI_PARAM_LOCAL_IPADDR);
 
 
 #define iscsi_conn_ep_attr_show(param)					\
@@ -3841,6 +3842,7 @@ static struct attribute *iscsi_conn_attrs[] = {
 	&dev_attr_conn_is_fw_assigned_ipv6.attr,
 	&dev_attr_conn_tcp_xmit_wsf.attr,
 	&dev_attr_conn_tcp_recv_wsf.attr,
+	&dev_attr_conn_local_ipaddr.attr,
 	NULL,
 };
 
@@ -3910,6 +3912,8 @@ static umode_t iscsi_conn_attr_is_visible(struct kobject *kobj,
 		param = ISCSI_PARAM_TCP_XMIT_WSF;
 	else if (attr == &dev_attr_conn_tcp_recv_wsf.attr)
 		param = ISCSI_PARAM_TCP_RECV_WSF;
+	else if (attr == &dev_attr_conn_local_ipaddr.attr)
+		param = ISCSI_PARAM_LOCAL_IPADDR;
 	else {
 		WARN_ONCE(1, "Invalid conn attr");
 		return 0;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 3851a73..fd0421c 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -618,6 +618,7 @@ enum iscsi_param {
 
 	ISCSI_PARAM_DISCOVERY_PARENT_IDX,
 	ISCSI_PARAM_DISCOVERY_PARENT_TYPE,
+	ISCSI_PARAM_LOCAL_IPADDR,
 	/* must always be last */
 	ISCSI_PARAM_MAX,
 };
-- 
1.8.2.GIT

