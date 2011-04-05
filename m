From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 1/2] mpt2sas: Remove acquisition of host_lock
Date: Tue, 5 Apr 2011 17:43:55 -0400
Message-ID: <20110405214355.GQ4183@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:22344 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184Ab1DEVoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 5 Apr 2011 17:44:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, DL-MPTFusionLinux@lsi.com


We can eliminate the use of the scsi command serial_number, as the race
that the driver is checking for cannot happen.

Then the driver no longer needs to use the DEF_SCSI_QCMD() macro and no
longer acquires the host_lock.  This improves performance substantially
on high-IOPS workloads.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5ded3db..863218f 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2031,7 +2031,6 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 	u16 smid = 0;
 	u32 ioc_state;
 	unsigned long timeleft;
-	struct scsi_cmnd *scmd_lookup;
 	int rc;
 
 	mutex_lock(&ioc->tm_cmds.mutex);
@@ -2132,12 +2131,7 @@ mpt2sas_scsih_issue_tm(struct MPT2SAS_ADAPTER *ioc, u16 handle, uint channel,
 		goto bypass_sanity_checks;
 	switch (type) {
 	case MPI2_SCSITASKMGMT_TASKTYPE_ABORT_TASK:
-		scmd_lookup = _scsih_scsi_lookup_get(ioc, smid_task);
-		if (scmd_lookup && (scmd_lookup->serial_number ==
-		    scmd->serial_number))
-			rc = FAILED;
-		else
-			rc = SUCCESS;
+		rc = SUCCESS;
 		break;
 
 	case MPI2_SCSITASKMGMT_TASKTYPE_TARGET_RESET:
@@ -3358,16 +3352,15 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
  * SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
  */
 static int
-_scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
+_scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 {
-	struct MPT2SAS_ADAPTER *ioc = shost_priv(scmd->device->host);
+	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
 	struct MPT2SAS_TARGET *sas_target_priv_data;
 	Mpi2SCSIIORequest_t *mpi_request;
 	u32 mpi_control;
 	u16 smid;
 
-	scmd->scsi_done = done;
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -3484,8 +3477,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
-static DEF_SCSI_QCMD(_scsih_qcmd)
-
 /**
  * _scsih_normalize_sense - normalize descriptor and fixed format sense data
  * @sense_buffer: sense data returned by target

