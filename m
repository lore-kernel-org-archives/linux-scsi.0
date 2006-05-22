From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 7/8] zfcp: make use of fc_remote_port_delete when target port is unavailable
Date: Mon, 22 May 2006 18:25:56 +0200
Message-ID: <20060522162556.GA25284@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:16216 "EHLO
	mtagate4.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1750967AbWEVQ2c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 12:28:32 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.6/8.13.6) with ESMTP id k4MGSVYQ013572
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 16:28:31 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4MGTV2o066500
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:29:31 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4MGST29028415
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:28:29 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

zfcp: make use of fc_remote_port_delete when target port is unavailable

If zfcp's port erp fails we now call fc_remote_port_delete. This helps
to avoid offlined scsi devices if scsi commands time out due to path
failures. When an adapter erp fails we call fc_remote_port_delete for
all ports on that adapter.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

5e6ddf0106155dafeba89e81e5ec935b2614aeb8
 drivers/s390/scsi/zfcp_erp.c  |   22 ++++++++++++++++++++--
 drivers/s390/scsi/zfcp_ext.h  |    2 --
 drivers/s390/scsi/zfcp_scsi.c |    7 +++++++
 3 files changed, 27 insertions(+), 4 deletions(-)

5e6ddf0106155dafeba89e81e5ec935b2614aeb8
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index 05c47f6..4698553 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -3241,9 +3241,13 @@ zfcp_erp_action_cleanup(int action, stru
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
+		if (atomic_test_mask(ZFCP_STATUS_PORT_NO_WWPN,
+				     &port->status)) {
+			zfcp_port_put(port);
+			break;
+		}
+		
 		if ((result == ZFCP_ERP_SUCCEEDED)
-		    && !atomic_test_mask(ZFCP_STATUS_PORT_NO_WWPN,
-					 &port->status)
 		    && !port->rport) {
 			struct fc_rport_identifiers ids;
 			ids.node_name = port->wwnn;
@@ -3264,9 +3268,23 @@ zfcp_erp_action_cleanup(int action, stru
 					port->supported_classes;
 			}
 		}
+		if ((result != ZFCP_ERP_SUCCEEDED) && port->rport) {
+			fc_remote_port_delete(port->rport);
+			port->rport = NULL;
+		}
 		zfcp_port_put(port);
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
+		if (result != ZFCP_ERP_SUCCEEDED) {
+			struct zfcp_port *port;
+			list_for_each_entry(port, &adapter->port_list_head, list)
+				if (port->rport &&
+				    !atomic_test_mask(ZFCP_STATUS_PORT_WKA,
+						      &port->status)) {
+					fc_remote_port_delete(port->rport);
+					port->rport = NULL;
+				}
+		}
 		zfcp_adapter_put(adapter);
 		break;
 	default:
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index ab38b8c..d023660 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -132,8 +132,6 @@ extern int zfcp_scsi_command_async(struc
 				   struct scsi_cmnd *, struct timer_list *);
 extern int zfcp_scsi_command_sync(struct zfcp_unit *, struct scsi_cmnd *,
 				  struct timer_list *);
-extern void zfcp_set_fc_host_attrs(struct zfcp_adapter *);
-extern void zfcp_set_fc_rport_attrs(struct zfcp_port *);
 extern struct scsi_transport_template *zfcp_transport_template;
 extern struct fc_function_template zfcp_transport_functions;
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 30e8719..46e14f2 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -800,12 +800,18 @@ zfcp_reset_fc_host_stats(struct Scsi_Hos
 	}
 }
 
+static void zfcp_set_rport_dev_loss_tmo(struct fc_rport *rport, u32 timeout)
+{
+	rport->dev_loss_tmo = timeout;
+}
+
 struct fc_function_template zfcp_transport_functions = {
 	.show_starget_port_id = 1,
 	.show_starget_port_name = 1,
 	.show_starget_node_name = 1,
 	.show_rport_supported_classes = 1,
 	.show_rport_maxframe_size = 1,
+	.show_rport_dev_loss_tmo = 1,
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
 	.show_host_permanent_port_name = 1,
@@ -815,6 +821,7 @@ struct fc_function_template zfcp_transpo
 	.show_host_serial_number = 1,
 	.get_fc_host_stats = zfcp_get_fc_host_stats,
 	.reset_fc_host_stats = zfcp_reset_fc_host_stats,
+	.set_rport_dev_loss_tmo = zfcp_set_rport_dev_loss_tmo,
 	/* no functions registered for following dynamic attributes but
 	   directly set by LLDD */
 	.show_host_port_type = 1,
-- 
1.3.3.gd5e3d

