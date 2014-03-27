From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 2/7] mpt3sas: Remove use of DEF_SCSI_QCMD
Date: Thu, 27 Mar 2014 16:40:31 -0400
Message-ID: <2ce8dda9284f463216f4c527d32fee497f9da3ac.1395952569.git.matthew.r.wilcox@intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52229 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747AbaC0Ukr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2014 16:40:47 -0400
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1395952569.git.matthew.r.wilcox@intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, willy@linux.intel.com

Removing the host_lock from the I/O submission path gives a huge
scalability improvement.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 952f6e0..18e713d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3515,7 +3515,7 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
 
 
 /**
- * _scsih_qcmd_lck - main scsi request entry point
+ * _scsih_qcmd - main scsi request entry point
  * @scmd: pointer to scsi command object
  * @done: function pointer to be invoked on completion
  *
@@ -3526,9 +3526,9 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
  * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
  */
 static int
-_scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
+_scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 {
-	struct MPT3SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
 	struct MPT3SAS_DEVICE *sas_device_priv_data;
 	struct MPT3SAS_TARGET *sas_target_priv_data;
 	Mpi2SCSIIORequest_t *mpi_request;
@@ -3541,7 +3541,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 		scsi_print_command(scmd);
 #endif
 
-	scmd->scsi_done = done;
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -3656,8 +3655,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
  out:
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
-static DEF_SCSI_QCMD(_scsih_qcmd)
-
 
 /**
  * _scsih_normalize_sense - normalize descriptor and fixed format sense data
-- 
1.9.0

