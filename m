From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 6/8] zfcp: evaluate plogi payload to set maxframe_size, supported_classes of rports
Date: Mon, 22 May 2006 18:24:33 +0200
Message-ID: <20060522162433.GA25275@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:17705 "EHLO
	mtagate1.uk.ibm.com") by vger.kernel.org with ESMTP
	id S1750959AbWEVQ1H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 May 2006 12:27:07 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate1.uk.ibm.com (8.13.6/8.13.6) with ESMTP id k4MGR6Fv157838
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 16:27:06 GMT
Received: from d06av02.portsmouth.uk.ibm.com (d06av02.portsmouth.uk.ibm.com [9.149.37.228])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4MGS62o132858
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:28:06 +0100
Received: from d06av02.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av02.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k4MGR58g026281
	for <linux-scsi@vger.kernel.org>; Mon, 22 May 2006 17:27:05 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Ralph Wuerthner <rwuerthn@de.ibm.com>

From: Ralph Wuerthner <rwuerthn@de.ibm.com>

zfcp: evaluate plogi payload to set maxframe_size, supported_classes of rports

Evaluate PLOGI payload to set maxframe_size and supported_classes for
remote ports.

Signed-off-by: Ralph Wuerthner <rwuerthn@de.ibm.com>
Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

---

c9c2c3852d56c6768ffccf4f0d8c2ce589522d14
 drivers/s390/scsi/zfcp_aux.c  |   21 +++++++++++++++++++++
 drivers/s390/scsi/zfcp_def.h  |    2 ++
 drivers/s390/scsi/zfcp_erp.c  |    6 +++++-
 drivers/s390/scsi/zfcp_ext.h  |    1 +
 drivers/s390/scsi/zfcp_fsf.c  |    7 ++++---
 drivers/s390/scsi/zfcp_scsi.c |    1 +
 6 files changed, 34 insertions(+), 4 deletions(-)

c9c2c3852d56c6768ffccf4f0d8c2ce589522d14
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index bdaad55..9cd789b 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -1748,4 +1748,25 @@ zfcp_handle_els_rjt(u32 sq, struct zfcp_
 	return ret;
 }
 
+/**
+ * zfcp_plogi_evaluate - evaluate PLOGI playload and copy important fields
+ * into zfcp_port structure
+ * @port: zfcp_port structure
+ * @plogi: plogi payload
+ */
+void
+zfcp_plogi_evaluate(struct zfcp_port *port, struct fsf_plogi *plogi)
+{
+	port->maxframe_size = plogi->serv_param.common_serv_param[7] |
+		((plogi->serv_param.common_serv_param[6] & 0x0F) << 8);
+	if (plogi->serv_param.class1_serv_param[0] & 0x80)
+		port->supported_classes |= FC_COS_CLASS1;
+	if (plogi->serv_param.class2_serv_param[0] & 0x80)
+		port->supported_classes |= FC_COS_CLASS2;
+	if (plogi->serv_param.class3_serv_param[0] & 0x80)
+		port->supported_classes |= FC_COS_CLASS3;
+	if (plogi->serv_param.class4_serv_param[0] & 0x80)
+		port->supported_classes |= FC_COS_CLASS4;
+}
+
 #undef ZFCP_LOG_AREA
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index e93272f..a67d608 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -959,6 +959,8 @@ struct zfcp_port {
 	u32		       handle;	       /* handle assigned by FSF */
 	struct zfcp_erp_action erp_action;     /* pending error recovery */
         atomic_t               erp_counter;
+	u32                    maxframe_size;
+	u32                    supported_classes;
 };
 
 /* the struct device sysfs_device must be at the beginning of this structure.
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index ce852c0..05c47f6 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -3257,8 +3257,12 @@ zfcp_erp_action_cleanup(int action, stru
 						"(adapter %s, wwpn=0x%016Lx)\n",
 						zfcp_get_busid_by_port(port),
 						port->wwpn);
-			else
+			else {
 				scsi_flush_work(adapter->scsi_host);
+				port->rport->maxframe_size = port->maxframe_size;
+				port->rport->supported_classes =
+					port->supported_classes;
+			}
 		}
 		zfcp_port_put(port);
 		break;
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 6be2bb7..ab38b8c 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -115,6 +115,7 @@ extern int  zfcp_nameserver_enqueue(stru
 extern int  zfcp_ns_gid_pn_request(struct zfcp_erp_action *);
 extern int  zfcp_check_ct_response(struct ct_hdr *);
 extern int  zfcp_handle_els_rjt(u32, struct zfcp_ls_rjt_par *);
+extern void zfcp_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
 
 /******************************* SCSI ****************************************/
 extern int  zfcp_adapter_scsi_register(struct zfcp_adapter *);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 55785ac..6335f92 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2560,8 +2560,7 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 		if (!atomic_test_mask(ZFCP_STATUS_PORT_NO_WWPN, &port->status))
 		{
 			if (fsf_req->qtcb->bottom.support.els1_length <
-			    ((((unsigned long) &plogi->serv_param.wwpn) -
-			      ((unsigned long) plogi)) + sizeof (u64))) {
+			    sizeof (struct fsf_plogi)) {
 				ZFCP_LOG_INFO(
 					"warning: insufficient length of "
 					"PLOGI payload (%i)\n",
@@ -2580,8 +2579,10 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 					atomic_clear_mask(
 						ZFCP_STATUS_PORT_DID_DID,
 						&port->status);
-				} else
+				} else {
 					port->wwnn = plogi->serv_param.wwnn;
+					zfcp_plogi_evaluate(port, plogi);
+				}
 			}
 		}
 		break;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index f198814..30e8719 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -805,6 +805,7 @@ struct fc_function_template zfcp_transpo
 	.show_starget_port_name = 1,
 	.show_starget_node_name = 1,
 	.show_rport_supported_classes = 1,
+	.show_rport_maxframe_size = 1,
 	.show_host_node_name = 1,
 	.show_host_port_name = 1,
 	.show_host_permanent_port_name = 1,
-- 
1.3.3.gd5e3d

