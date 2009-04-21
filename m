From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 7/10] mpt2sas : Broadcast Primative AEN bug fix
Date: Tue, 21 Apr 2009 15:41:32 -0600
Message-ID: <20090421214131.GH18563@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og56.obsmtp.com ([64.18.14.177]:55941 "EHLO
	chip3og56.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758679AbZDUVjt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 17:39:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org

Bug fix in the broadcast primative async event code where the driver would
stop sending tm queries after the first queury was completed. This was due
driver not reseting the tm_cmds.status field back to MPT2_CMD_NOT_USED after
completing a task management request.

An addtional fix adding sanity check to insure sas_device->starget set to NULL.
During multipath testing fail over/fail back, the mid layer was holding onto
sdev longer than the fail back period, thus starget was getting set to NULL 
for device being added.

Signed-off-by: Eric Moore <eric.moore@lsi.com>

diff -uarpN a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-09 16:43:07.000000000 -0600
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2009-04-13 15:58:57.000000000 -0600
@@ -516,12 +516,8 @@ _scsih_sas_device_add(struct MPT2SAS_ADA
 	handle = sas_device->handle;
 	parent_handle = sas_device->parent_handle;
 	sas_address = sas_device->sas_address;
-	if (!mpt2sas_transport_port_add(ioc, handle, parent_handle)) {
+	if (!mpt2sas_transport_port_add(ioc, handle, parent_handle))
 		_scsih_sas_device_remove(ioc, sas_device);
-	} else if (!sas_device->starget) {
-		mpt2sas_transport_port_remove(ioc, sas_address, parent_handle);
-		_scsih_sas_device_remove(ioc, sas_device);
-	}
 }
 
 /**
@@ -1203,7 +1199,9 @@ scsih_target_destroy(struct scsi_target
 	rphy = dev_to_rphy(starget->dev.parent);
 	sas_device = mpt2sas_scsih_sas_device_find_by_sas_address(ioc,
 	   rphy->identify.sas_address);
-	if (sas_device)
+	if (sas_device && (sas_device->starget == starget) &&
+	    (sas_device->id == starget->id) &&
+	    (sas_device->channel == starget->channel))
 		sas_device->starget = NULL;
 
 	spin_unlock_irqrestore(&ioc->sas_device_lock, flags);
@@ -3924,7 +3922,7 @@ _scsih_sas_broadcast_primative_event(str
 
 		mpt2sas_scsih_issue_tm(ioc, handle, lun,
 		    MPI2_SCSITASKMGMT_TASKTYPE_QUERY_TASK, smid, 30);
-		termination_count += le32_to_cpu(mpi_reply->TerminationCount);
+		ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 
 		if ((mpi_reply->IOCStatus == MPI2_IOCSTATUS_SUCCESS) &&
 		    (mpi_reply->ResponseCode ==
@@ -3934,10 +3932,10 @@ _scsih_sas_broadcast_primative_event(str
 			continue;
 
 		mpt2sas_scsih_issue_tm(ioc, handle, lun,
-		    MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET, smid, 30);
+		    MPI2_SCSITASKMGMT_TASKTYPE_ABRT_TASK_SET, 0, 30);
+		ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 		termination_count += le32_to_cpu(mpi_reply->TerminationCount);
 	}
-	ioc->tm_cmds.status = MPT2_CMD_NOT_USED;
 	ioc->broadcast_aen_busy = 0;
 	mutex_unlock(&ioc->tm_cmds.mutex);
 
