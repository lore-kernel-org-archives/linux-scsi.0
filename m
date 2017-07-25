From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [RFC 3/9] zfcp: split FCP_CMND IU setup between SCSI I/O and TMF again
Date: Tue, 25 Jul 2017 16:14:21 +0200
Message-ID: <20170725141427.35258-4-maier@linux.vnet.ibm.com>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55935 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752328AbdGYOOy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 10:14:54 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6PEADLp000475
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:14:53 -0400
Received: from e06smtp15.uk.ibm.com (e06smtp15.uk.ibm.com [195.75.94.111])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bx3b2maru-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:14:53 -0400
Received: from localhost
        by e06smtp15.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 25 Jul 2017 15:14:52 +0100
In-Reply-To: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc: linux-s390@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

This reverts commit 2443c8b23aea ("[SCSI] zfcp: Merge FCP task management
setup with regular FCP command setup"), because this introduced a
dependency on the unsuitable SCSI command for scsi_eh / TMF.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.h  | 22 ++++++++++++++--------
 drivers/s390/scsi/zfcp_fsf.c |  4 ++--
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fc.h b/drivers/s390/scsi/zfcp_fc.h
index 41f22d3dc6d1..24949868d027 100644
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -206,21 +206,14 @@ struct zfcp_fc_wka_ports {
  * zfcp_fc_scsi_to_fcp - setup FCP command with data from scsi_cmnd
  * @fcp: fcp_cmnd to setup
  * @scsi: scsi_cmnd where to get LUN, task attributes/flags and CDB
- * @tm: task management flags to setup task management command
  */
 static inline
-void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi,
-			 u8 tm_flags)
+void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi)
 {
 	u32 datalen;
 
 	int_to_scsilun(scsi->device->lun, (struct scsi_lun *) &fcp->fc_lun);
 
-	if (unlikely(tm_flags)) {
-		fcp->fc_tm_flags = tm_flags;
-		return;
-	}
-
 	fcp->fc_pri_ta = FCP_PTA_SIMPLE;
 
 	if (scsi->sc_data_direction == DMA_FROM_DEVICE)
@@ -240,6 +233,19 @@ void zfcp_fc_scsi_to_fcp(struct fcp_cmnd *fcp, struct scsi_cmnd *scsi,
 }
 
 /**
+ * zfcp_fc_fcp_tm() - Setup FCP command as task management command.
+ * @fcp: Pointer to FCP_CMND IU to set up.
+ * @dev: Pointer to SCSI_device where to send the task management command.
+ * @tm_flags: Task management flags to setup tm command.
+ */
+static inline
+void zfcp_fc_fcp_tm(struct fcp_cmnd *fcp, struct scsi_device *dev, u8 tm_flags)
+{
+	int_to_scsilun(dev->lun, (struct scsi_lun *) &fcp->fc_lun);
+	fcp->fc_tm_flags = tm_flags;
+}
+
+/**
  * zfcp_fc_evap_fcp_rsp - evaluate FCP RSP IU and update scsi_cmnd accordingly
  * @fcp_rsp: FCP RSP IU to evaluate
  * @scsi: SCSI command where to update status and sense buffer
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 8b2b2ea552d6..f221a34c26df 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2265,7 +2265,7 @@ int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 
 	BUILD_BUG_ON(sizeof(struct fcp_cmnd) > FSF_FCP_CMND_SIZE);
 	fcp_cmnd = &req->qtcb->bottom.io.fcp_cmnd.iu;
-	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd, 0);
+	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd);
 
 	if ((scsi_get_prot_op(scsi_cmnd) != SCSI_PROT_NORMAL) &&
 	    scsi_prot_sg_count(scsi_cmnd)) {
@@ -2371,7 +2371,7 @@ struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
 
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
-	zfcp_fc_scsi_to_fcp(fcp_cmnd, scmnd, tm_flags);
+	zfcp_fc_fcp_tm(fcp_cmnd, scmnd->device, tm_flags);
 
 	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
 	if (!zfcp_fsf_req_send(req))
-- 
2.11.2
