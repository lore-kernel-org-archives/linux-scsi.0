From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [RFC 4/9] zfcp: decouple FSF request setup of TMF from scsi_cmnd
Date: Tue, 25 Jul 2017 16:14:22 +0200
Message-ID: <20170725141427.35258-5-maier@linux.vnet.ibm.com>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56305 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752339AbdGYOO7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 10:14:59 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6PEAU02001766
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:14:58 -0400
Received: from e06smtp13.uk.ibm.com (e06smtp13.uk.ibm.com [195.75.94.109])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bx3b2mavd-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:14:58 -0400
Received: from localhost
        by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 25 Jul 2017 15:14:55 +0100
In-Reply-To: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc: linux-s390@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

The scsi_device argument of zfcp_fc_fcp_tm() can now be NULL.

In zfcp_fsf_fcp_task_mgmt() resolve the still old argument scsi_cmnd
into scsi_device very early and only depend on scsi_device and derived
objects in the function body.

Scsi_device and derived zfcp_scsi_dev can later be NULL for the
target reset case, so do not depend on them unconditionally.
For the generic case, rather change to using zfcp_port directly.

This prepares to later change the function signature replacing the
scsi_cmnd argument with zfcp_port and an
optional scsi_device which can be NULL.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.h  |  6 ++++--
 drivers/s390/scsi/zfcp_fsf.c | 25 +++++++++++++++++--------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
index 24949868d027..0e5b01c33873 100644
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -235,13 +235,15 @@ void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi)
 /**
  * zfcp_fc_fcp_tm() - Setup FCP command as task management command.
  * @fcp: Pointer to FCP_CMND IU to set up.
- * @dev: Pointer to SCSI_device where to send the task management command.
+ * @dev: Pointer to SCSI device if LUN Reset TMF, or %NULL.
  * @tm_flags: Task management flags to setup tm command.
  */
 static inline
 void zfcp_fc_fcp_tm(struct fcp_cmnd *fcp, struct scsi_device *dev, u8 tm_flags)
 {
-	int_to_scsilun(dev->lun, (struct scsi_lun *) &fcp->fc_lun);
+	if (dev)
+		int_to_scsilun(dev->lun, (struct scsi_lun *) &fcp->fc_lun);
+
 	fcp->fc_tm_flags = tm_flags;
 }
 
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index f221a34c26df..2dc7d2a6f6ea 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2339,13 +2339,19 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
 {
 	struct zfcp_fsf_req *req = NULL;
 	struct fcp_cmnd *fcp_cmnd;
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scmnd->device);
-	struct zfcp_qdio *qdio = zfcp_sdev->port->adapter->qdio;
+	struct scsi_device *sdev = scmnd->device;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_port *port = zfcp_sdev->port;
+	struct zfcp_qdio *qdio = port->adapter->qdio;
 
-	if (unlikely(!(atomic_read(&zfcp_sdev->status) &
+	if (unlikely(!(atomic_read(&port->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return NULL;
 
+	if (unlikely(zfcp_sdev && !(atomic_read(&zfcp_sdev->status) &
+				    ZFCP_STATUS_COMMON_UNBLOCKED)))
+		return NULL;
+
 	spin_lock_irq(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
 		goto out;
@@ -2360,18 +2366,21 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
 	}
 
 	fcp_cmnd = &req->qtcb->bottom.io.fcp_cmnd.iu;
-	req->data = (fcp_cmnd->fc_tm_flags & FCP_TMF_LUN_RESET) ?
-		scmnd->device : (void *)sdev_to_zfcp(scmnd->device)->port;
+	if (fcp_cmnd->fc_tm_flags & FCP_TMF_LUN_RESET) {
+		req->data = sdev;
+		req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
+	} else
+		req->data = port;
+
 	req->handler = zfcp_fsf_fcp_task_mgmt_handler;
-	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
-	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
+	req->qtcb->header.port_handle = port->handle;
 	req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
 	req->qtcb->bottom.io.service_class = FSF_CLASS_3;
 	req->qtcb->bottom.io.fcp_cmnd_length = FCP_CMND_LEN;
 
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
-	zfcp_fc_fcp_tm(fcp_cmnd, scmnd->device, tm_flags);
+	zfcp_fc_fcp_tm(fcp_cmnd, sdev, tm_flags);
 
 	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
 	if (!zfcp_fsf_req_send(req))
-- 
2.11.2
