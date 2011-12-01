From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 06/08] [SCSI]  mpt2sas : Do not retry a timed out direct
 IO for warpdrive
Date: Thu, 1 Dec 2011 07:53:02 +0530
Message-ID: <201112010929.pB19TUjZ021225@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:44329 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751795Ab1LAJ3e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 04:29:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Do not retry a timed out direct IO for warpdrive 

When an I/O request to a WarpDrive is timed out by SML and if the
I/O request to the WarpDrive is sent as direct I/O then the aborted
direct I/O will be retried as normal Volume I/O and which results
in failure of Target Reset and results in host reset.
    
The fix is to not retry a failed IO to volume when the original
IO was sent as direct IO with an ioc status 
MPI2_IOCSTATUS_SCSI_TASK_TERMINATED.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index cedc2e2..c3e69b2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4440,11 +4440,14 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 		scmd->result = DID_NO_CONNECT << 16;
 		goto out;
 	}
+	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
 	/*
 	 * WARPDRIVE: If direct_io is set then it is directIO,
 	 * the failed direct I/O should be redirected to volume
 	 */
-	if (_scsih_scsi_direct_io_get(ioc, smid)) {
+	if (_scsih_scsi_direct_io_get(ioc, smid) &&
+	    ((ioc_status & MPI2_IOCSTATUS_MASK)
+	    != MPI2_IOCSTATUS_SCSI_TASK_TERMINATED)) {
 		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
 		ioc->scsi_lookup[smid - 1].scmd = scmd;
 		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
@@ -4478,7 +4481,6 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 
 	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
 	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
-	ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
 	if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
 		log_info =  le32_to_cpu(mpi_reply->IOCLogInfo);
 	else
