From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [RFC 5/9] zfcp: decouple SCSI setup of TMF from scsi_cmnd
Date: Tue, 25 Jul 2017 16:14:23 +0200
Message-ID: <20170725141427.35258-6-maier@linux.vnet.ibm.com>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43799 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752349AbdGYOPB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 10:15:01 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6PEBd1o029567
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:15:00 -0400
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bx4na0v8q-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:14:59 -0400
Received: from localhost
        by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 25 Jul 2017 15:14:57 +0100
In-Reply-To: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc: linux-s390@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

Actually change the signature of zfcp_fsf_fcp_task_mgmt().
Since it was prepared in the previous patch, we only need to delete
some local auto variables which are now the intended arguments.

Refactor zfcp_scsi_forget_cmnds() to now take a mandatory zfcp_port
and an optional zfcp_scsi_dev, which can be NULL for target reset,
instead of a mandatory zfcp_scsi_dev.

Prepare zfcp_fsf_fcp_task_mgmt's caller zfcp_task_mgmt_function()
to have its function body only depend on a mandatory zfcp_port
and an optional scsi_device, which can be NULL for target reset.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_ext.h  |  4 +++-
 drivers/s390/scsi/zfcp_fsf.c  | 15 ++++++++-------
 drivers/s390/scsi/zfcp_scsi.c | 28 +++++++++++++++++++---------
 3 files changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index f3101bc5d1bc..26772b0c1c39 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -118,7 +118,9 @@ extern int zfcp_fsf_send_els(struct zfcp_adapter *, u32,
 			     struct zfcp_fsf_ct_els *, unsigned int);
 extern int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
-extern struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *, u8);
+extern struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct zfcp_port *port,
+						   struct scsi_device *sdev,
+						   u8 tm_flags);
 extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *);
 extern void zfcp_fsf_reqid_check(struct zfcp_qdio *, int);
 
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 2dc7d2a6f6ea..7cc2d7ee1f56 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2329,19 +2329,20 @@ static void zfcp_fsf_fcp_task_mgmt_handler(struct zfcp_fsf_req *req)
 }
 
 /**
- * zfcp_fsf_fcp_task_mgmt - send SCSI task management command
- * @scmnd: SCSI command to send the task management command for
- * @tm_flags: unsigned byte for task management flags
- * Returns: on success pointer to struct fsf_req, NULL otherwise
+ * zfcp_fsf_fcp_task_mgmt() - Send SCSI task management command (TMF).
+ * @port: Pointer to zfcp port as scope for TMF.
+ * @sdev: Pointer to scsi device if LUN Reset TMF, or %NULL.
+ * @tm_flags: Unsigned byte for task management flags.
+ *
+ * Return: On success pointer to struct fsf_req, %NULL otherwise.
  */
-struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
+struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct zfcp_port *port,
+					    struct scsi_device *sdev,
 					    u8 tm_flags)
 {
 	struct zfcp_fsf_req *req = NULL;
 	struct fcp_cmnd *fcp_cmnd;
-	struct scsi_device *sdev = scmnd->device;
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
-	struct zfcp_port *port = zfcp_sdev->port;
 	struct zfcp_qdio *qdio = port->adapter->qdio;
 
 	if (unlikely(!(atomic_read(&port->status) &
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index cd0f811452b7..05c823ccb959 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -234,12 +234,20 @@ static void zfcp_scsi_forget_cmnd(struct zfcp_fsf_req *old_req, void *data)
 	old_req->data = NULL;
 }
 
-static void zfcp_scsi_forget_cmnds(struct zfcp_scsi_dev *zsdev, u8 tm_flags)
+/**
+ * zfcp_scsi_forget_cmnds() - Forget pending SCSI requests on given scope.
+ * @port: Pointer to zfcp port indicating scope.
+ * @zsdev: Pointer to zfcp scsi dev as scope, or %NULL if scope is only port.
+ * @tm_flags: Task management flags,
+ *            here we only handle %FCP_TMF_TGT_RESET or %FCP_TMF_LUN_RESET.
+ */
+static void zfcp_scsi_forget_cmnds(struct zfcp_port *port,
+				   struct zfcp_scsi_dev *zsdev, u8 tm_flags)
 {
-	struct zfcp_adapter *adapter = zsdev->port->adapter;
+	struct zfcp_adapter *adapter = port->adapter;
 	struct zfcp_scsi_req_filter filter = {
 		.tmf_scope = FCP_TMF_TGT_RESET,
-		.port_handle = zsdev->port->handle,
+		.port_handle = port->handle,
 	};
 	unsigned long flags;
 
@@ -260,19 +268,21 @@ static void zfcp_scsi_forget_cmnds(struct zfcp_scsi_dev *zsdev, u8 tm_flags)
 
 static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 {
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
-	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
-	unsigned int scsi_id = zfcp_sdev->port->starget_id;
+	struct scsi_device *sdev = scpnt->device;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_port *port = zfcp_sdev->port;
+	struct zfcp_adapter *adapter = port->adapter;
+	unsigned int scsi_id = port->starget_id;
 	u64 scsi_lun = ZFCP_DBF_INVALID_LUN;
 	struct zfcp_fsf_req *fsf_req = NULL;
 	int retval = SUCCESS, ret;
 	int retry = 3;
 
 	if (tm_flags == FCP_TMF_LUN_RESET)
-		scsi_lun = scpnt->device->lun;
+		scsi_lun = sdev->lun;
 
 	while (retry--) {
-		fsf_req = zfcp_fsf_fcp_task_mgmt(scpnt, tm_flags);
+		fsf_req = zfcp_fsf_fcp_task_mgmt(port, sdev, tm_flags);
 		if (fsf_req)
 			break;
 
@@ -306,7 +316,7 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 	} else {
 		zfcp_dbf_scsi_devreset("okay", adapter, tm_flags, fsf_req,
 				       scsi_id, scsi_lun);
-		zfcp_scsi_forget_cmnds(zfcp_sdev, tm_flags);
+		zfcp_scsi_forget_cmnds(port, zfcp_sdev, tm_flags);
 	}
 
 	zfcp_fsf_req_free(fsf_req);
-- 
2.11.2
