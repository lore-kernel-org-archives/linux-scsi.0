From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH 2/3] mpt2sas: Run queuecommand outside the host_lock
Date: Fri, 1 Apr 2011 16:21:32 -0400
Message-ID: <20110401202132.GM4183@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:47641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168Ab1DAUVe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2011 16:21:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Dropping the host_lock here improves one I/O intensive benchmark by 10%.
This driver still uses the command serial number.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 5ded3db..28e1e21 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3358,16 +3358,16 @@ _scsih_eedp_error_handling(struct scsi_cmnd *scmd, u16 ioc_status)
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
+	scsi_cmd_get_serial(shost, scmd);
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -3484,8 +3484,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
-static DEF_SCSI_QCMD(_scsih_qcmd)
-
 /**
  * _scsih_normalize_sense - normalize descriptor and fixed format sense data
  * @sense_buffer: sense data returned by target
