From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 5/8] libiscsi: Add local_ipaddr parameter in iscsi_conn struct
Date: Fri, 22 Nov 2013 05:28:21 -0500
Message-ID: <1385116104-19784-6-git-send-email-vikas.chaudhary@qlogic.com>
References: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:15539 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755149Ab3KVLBP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Nov 2013 06:01:15 -0500
In-Reply-To: <1385116104-19784-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com, Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

From: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>

Add local_ipaddr param and support get/set operations on it.

Signed-off-by: Adheer Chandravanshi <adheer.chandravanshi@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/libiscsi.c | 6 ++++++
 include/scsi/libiscsi.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index e399561..4046241 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2945,6 +2945,7 @@ void iscsi_conn_teardown(struct iscsi_cls_conn *cls_conn)
 	free_pages((unsigned long) conn->data,
 		   get_order(ISCSI_DEF_MAX_RECV_SEG_LEN));
 	kfree(conn->persistent_address);
+	kfree(conn->local_ipaddr);
 	kfifo_in(&session->cmdpool.queue, (void*)&conn->login_task,
 		    sizeof(void*));
 	if (session->leadconn == conn)
@@ -3269,6 +3270,8 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		sscanf(buf, "%d", &val);
 		session->discovery_sess = !!val;
 		break;
+	case ISCSI_PARAM_LOCAL_IPADDR:
+		return iscsi_switch_str_param(&conn->local_ipaddr, buf);
 	default:
 		return -ENOSYS;
 	}
@@ -3542,6 +3545,9 @@ int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	case ISCSI_PARAM_TCP_RECV_WSF:
 		len = sprintf(buf, "%u\n", conn->tcp_recv_wsf);
 		break;
+	case ISCSI_PARAM_LOCAL_IPADDR:
+		len = sprintf(buf, "%s\n", conn->local_ipaddr);
+		break;
 	default:
 		return -ENOSYS;
 	}
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 6ac9e17a..309f513 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -231,6 +231,7 @@ struct iscsi_conn {
 	uint8_t			ipv6_traffic_class;
 	uint8_t			ipv6_flow_label;
 	uint8_t			is_fw_assigned_ipv6;
+	char			*local_ipaddr;
 
 	/* MIB-statistics */
 	uint64_t		txdata_octets;
-- 
1.8.2.GIT

