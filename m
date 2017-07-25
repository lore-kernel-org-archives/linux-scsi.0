From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [RFC 2/9] zfcp: decouple TMF response handler from scsi_cmnd
Date: Tue, 25 Jul 2017 16:14:20 +0200
Message-ID: <20170725141427.35258-3-maier@linux.vnet.ibm.com>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38483 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752326AbdGYOOw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 10:14:52 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6PECvqQ068002
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:14:52 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bx4wdr6xv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:14:51 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 25 Jul 2017 15:14:49 +0100
In-Reply-To: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc: linux-s390@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

Do not get scsi_device via req->data any more, but pass an optional(!)
scsi_device to zfcp_fsf_fcp_handler_common(). The latter must now guard
any access to scsi_device as it can be NULL.

Since we always have at least a zfcp port as scope, pass this as mandatory
argument to zfcp_fsf_fcp_handler_common() because we cannot get it through
scsi_device => zfcp_scsi_dev => port any more.

Hence, the callers of zfcp_fsf_fcp_handler_common() must resolve req->data.

TMF handling now has different context data in fsf_req->data
depending on the TMF scope in fcp_cmnd->fc_tm_flags:
* scsi_device if FCP_TMF_LUN_RESET,
* zfcp_port if FCP_TMF_TGT_RESET.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c | 72 ++++++++++++++++++++++++++++----------------
 1 file changed, 46 insertions(+), 26 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 69d1dc3ec79d..8b2b2ea552d6 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2035,27 +2035,30 @@ static void zfcp_fsf_req_trace(struct zfcp_fsf_req *req, struct scsi_cmnd *scsi)
 			    sizeof(blktrc));
 }
 
-static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req)
+/**
+ * zfcp_fsf_fcp_handler_common() - FCP response handler common to I/O and TMF.
+ * @req: Pointer to FSF request.
+ * @port: Pointer to zfcp port.
+ * @sdev: Pointer to SCSI device, or %NULL with Target Reset TMF.
+ */
+static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req,
+					struct zfcp_port *port,
+					struct scsi_device *sdev)
 {
-	struct scsi_cmnd *scmnd = req->data;
-	struct scsi_device *sdev = scmnd->device;
-	struct zfcp_scsi_dev *zfcp_sdev;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR))
 		return;
 
-	zfcp_sdev = sdev_to_zfcp(sdev);
-
 	switch (header->fsf_status) {
 	case FSF_HANDLE_MISMATCH:
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(zfcp_sdev->port->adapter, 0, "fssfch1");
+		zfcp_erp_adapter_reopen(req->adapter, 0, "fssfch1");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_FCPLUN_NOT_VALID:
 	case FSF_LUN_HANDLE_NOT_VALID:
-		zfcp_erp_port_reopen(zfcp_sdev->port, 0, "fssfch2");
+		zfcp_erp_port_reopen(port, 0, "fssfch2");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
@@ -2066,10 +2069,10 @@ static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req)
 			"Incorrect direction %d, LUN 0x%016Lx on port "
 			"0x%016Lx closed\n",
 			req->qtcb->bottom.io.data_direction,
-			(unsigned long long)zfcp_scsi_dev_lun(sdev),
-			(unsigned long long)zfcp_sdev->port->wwpn);
-		zfcp_erp_adapter_shutdown(zfcp_sdev->port->adapter, 0,
-					  "fssfch3");
+			sdev ? (unsigned long long)zfcp_scsi_dev_lun(sdev) :
+			ZFCP_DBF_INVALID_LUN,
+			(unsigned long long)port->wwpn);
+		zfcp_erp_adapter_shutdown(req->adapter, 0, "fssfch3");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_CMND_LENGTH_NOT_VALID:
@@ -2077,29 +2080,32 @@ static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req)
 			"Incorrect CDB length %d, LUN 0x%016Lx on "
 			"port 0x%016Lx closed\n",
 			req->qtcb->bottom.io.fcp_cmnd_length,
-			(unsigned long long)zfcp_scsi_dev_lun(sdev),
-			(unsigned long long)zfcp_sdev->port->wwpn);
-		zfcp_erp_adapter_shutdown(zfcp_sdev->port->adapter, 0,
-					  "fssfch4");
+			sdev ? (unsigned long long)zfcp_scsi_dev_lun(sdev) :
+			ZFCP_DBF_INVALID_LUN,
+			(unsigned long long)port->wwpn);
+		zfcp_erp_adapter_shutdown(req->adapter, 0, "fssfch4");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_set_port_status(zfcp_sdev->port,
+		zfcp_erp_set_port_status(port,
 					 ZFCP_STATUS_COMMON_ACCESS_BOXED);
-		zfcp_erp_port_reopen(zfcp_sdev->port,
+		zfcp_erp_port_reopen(port,
 				     ZFCP_STATUS_COMMON_ERP_FAILED, "fssfch5");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_BOXED:
-		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ACCESS_BOXED);
-		zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED,
-				    "fssfch6");
+		if (sdev) {
+			zfcp_erp_set_lun_status(
+				sdev, ZFCP_STATUS_COMMON_ACCESS_BOXED);
+			zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED,
+					    "fssfch6");
+		}
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		if (header->fsf_status_qual.word[0] ==
 		    FSF_SQ_INVOKE_LINK_TEST_PROCEDURE)
-			zfcp_fc_test_link(zfcp_sdev->port);
+			zfcp_fc_test_link(port);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
@@ -2108,6 +2114,7 @@ static void zfcp_fsf_fcp_handler_common(struct zfcp_fsf_req *req)
 static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 {
 	struct scsi_cmnd *scpnt;
+	struct scsi_device *sdev;
 	struct fcp_resp_with_ext *fcp_rsp;
 	unsigned long flags;
 
@@ -2119,7 +2126,8 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 		return;
 	}
 
-	zfcp_fsf_fcp_handler_common(req);
+	sdev = scpnt->device;
+	zfcp_fsf_fcp_handler_common(req, sdev_to_zfcp(sdev)->port, sdev);
 
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
 		set_host_byte(scpnt, DID_TRANSPORT_DISRUPTED);
@@ -2296,10 +2304,21 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 
 static void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req)
 {
+	struct fcp_cmnd *fcp_cmnd;
+	struct zfcp_port *port;
+	struct scsi_device *sdev;
 	struct fcp_resp_with_ext *fcp_rsp;
 	struct fcp_resp_rsp_info *rsp_info;
 
-	zfcp_fsf_fcp_handler_common(req);
+	fcp_cmnd = &req->qtcb->bottom.io.fcp_cmnd.iu;
+	if (fcp_cmnd->fc_tm_flags & FCP_TMF_LUN_RESET) {
+		sdev = req->data;
+		port = sdev_to_zfcp(sdev)->port;
+	} else {
+		sdev = NULL;
+		port = req->data;
+	}
+	zfcp_fsf_fcp_handler_common(req, port, sdev);
 
 	fcp_rsp = &req->qtcb->bottom.io.fcp_rsp.iu;
 	rsp_info = (struct fcp_resp_rsp_info *) &fcp_rsp[1];
@@ -2340,7 +2359,9 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
 		goto out;
 	}
 
-	req->data = scmnd;
+	fcp_cmnd = &req->qtcb->bottom.io.fcp_cmnd.iu;
+	req->data = (fcp_cmnd->fc_tm_flags & FCP_TMF_LUN_RESET) ?
+		scmnd->device : (void *)sdev_to_zfcp(scmnd->device)->port;
 	req->handler = zfcp_fsf_fcp_task_mgmt_handler;
 	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
 	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
@@ -2350,7 +2371,6 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
 
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
-	fcp_cmnd = &req->qtcb->bottom.io.fcp_cmnd.iu;
 	zfcp_fc_scsi_to_fcp(fcp_cmnd, scmnd, tm_flags);
 
 	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
-- 
2.11.2
