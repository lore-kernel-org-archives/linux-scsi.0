From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH] mpt2sas: WarpDrive Infinite command retries due to wrong
 scsi command entry in MPI message
Date: Tue, 5 Jul 2011 12:40:23 +0530
Message-ID: <20110705071015.GA16092@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:57068 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759Ab1GEGqE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jul 2011 02:46:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Issue:
This issue is seen on LSI H/W WarpDrive SSS6200
When filed direct I/O is tried as volume I/O the scmd field in internal lookup 
table get cleared and because of that the retried volume I/O never gets 
reported as completed to SML.

Result:  
     I/O timeout and Error handling thread will kicking off 

Fix: Setting back the scmd in the lookup table before retrying the failed 
     direct i/o

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 939f283..6abd2fc 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -4258,6 +4258,7 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	u32 log_info;
 	struct MPT2SAS_DEVICE *sas_device_priv_data;
 	u32 response_code = 0;
+	unsigned long flags;
 
 	mpi_reply = mpt2sas_base_get_reply_virt_addr(ioc, reply);
 	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
@@ -4282,6 +4283,9 @@ _scsih_io_done(struct MPT2SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 	 * the failed direct I/O should be redirected to volume
 	 */
 	if (_scsih_scsi_direct_io_get(ioc, smid)) {
+		spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
+		ioc->scsi_lookup[smid - 1].scmd = scmd;
+		spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
 		_scsih_scsi_direct_io_set(ioc, smid, 0);
 		memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
 		mpi_request->DevHandle =
