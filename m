From: Matthew Wilcox <willy@linux.intel.com>
Subject: [PATCH] mpt2sas: Remove queuecommand wrapper
Date: Mon, 4 Jul 2011 15:27:13 -0400
Message-ID: <20110704192713.GZ4061@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:16096 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356Ab1GDT1P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2011 15:27:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: DL-MPTFusionLinux@lsi.com


Now that mpt2sas no longer uses the serial_number, we can remove the
wrapper that acquires the host_lock around queuecommand.  This is the
most contended lock for one benchmark, and on a 8-socket machine this
patch leads to a 70% application-level improvement.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index a7dbc68..67708b3 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3680,9 +3680,9 @@ _scsih_setup_direct_io(struct MPT2SAS_ADAPTER *ioc, struct scsi_cmnd *scmd,
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
@@ -3690,7 +3690,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	u32 mpi_control;
 	u16 smid;
 
-	scmd->scsi_done = done;
 	sas_device_priv_data = scmd->device->hostdata;
 	if (!sas_device_priv_data || !sas_device_priv_data->sas_target) {
 		scmd->result = DID_NO_CONNECT << 16;
@@ -3814,8 +3813,6 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 	return SCSI_MLQUEUE_HOST_BUSY;
 }
 
-static DEF_SCSI_QCMD(_scsih_qcmd)
-
 /**
  * _scsih_normalize_sense - normalize descriptor and fixed format sense data
  * @sense_buffer: sense data returned by target
