From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 4/7] mpt2sas: Remove use of DEF_SCSI_QCMD
Date: Thu, 27 Mar 2014 16:40:33 -0400
Message-ID: <3a4ad03264073e94f3453bda0955300ad96f5e95.1395952569.git.matthew.r.wilcox@intel.com>
References: <cover.1395952569.git.matthew.r.wilcox@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:3867 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086AbaC0Uky (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Mar 2014 16:40:54 -0400
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
 drivers/scsi/mpt2sas/mpt2sas_scsih.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 33586a3..7351843 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3950,9 +3950,9 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
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
 	struct _raid_device *raid_device;
@@ -3960,7 +3960,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	u32 mpi_control;
 	u16 smid;
 
-	scmd->scsi_done = done;
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -4036,7 +4035,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	    MPT_TARGET_FLAGS_RAID_COMPONENT)
 		mpi_request->Function = MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH;
 	else
-		mpi_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
+	mpi_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
 	mpi_request->DevHandle =
 	    cpu_to_le16(sas_device_priv_data->sas_target->handle);
 	mpi_request->DataLength = cpu_to_le32(scsi_bufflen(scmd));
@@ -4080,8 +4079,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
-static DEF_SCSI_QCMD(_scsih_qcmd)
-
 /**
  * _scsih_normalize_sense - normalize descriptor and fixed format sense data
  * @sense_buffer: sense data returned by target
-- 
1.9.0

