From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 02/05] mpt2sas: Send default descriptor for RAID pass through in mpt2ctl
Date: Mon, 5 Apr 2010 14:19:21 +0530
Message-ID: <20100405084912.GC28900@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:60791 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752103Ab0DEJVN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2010 05:21:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


RAID_SCSI_IO_PASSTHROUGH: Driver needs to be sending the default
descriptor for RAID Passthru, currently its sending SCSI_IO descriptor.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index ddaa99c..d88e975 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -744,8 +744,11 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 		    mpt2sas_base_get_sense_buffer_dma(ioc, smid);
 		priv_sense = mpt2sas_base_get_sense_buffer(ioc, smid);
 		memset(priv_sense, 0, SCSI_SENSE_BUFFERSIZE);
-		mpt2sas_base_put_smid_scsi_io(ioc, smid,
-		    le16_to_cpu(mpi_request->FunctionDependent1));
+		if (mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST)
+			mpt2sas_base_put_smid_scsi_io(ioc, smid,
+			    le16_to_cpu(mpi_request->FunctionDependent1));
+		else
+			mpt2sas_base_put_smid_default(ioc, smid);
 		break;
 	}
 	case MPI2_FUNCTION_SCSI_TASK_MGMT:
