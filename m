From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 09/11] mpt2sas: Default descriptor for RAID Passthru command.
Date: Wed, 17 Mar 2010 16:27:25 +0530
Message-ID: <20100317105714.GJ21264@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:55902 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754406Ab0CQL23 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Mar 2010 07:28:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


RAID_SCSI_IO_PASSTHROUGH: Driver needs to be send the default
descriptor for RAID Passthru, currently its sending SCSI_IO descriptor.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index d48c6f0..a682454 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3044,8 +3044,11 @@ _scsih_qcmd(struct scsi_cmnd *scmd, void (*done)(struct scsi_cmnd *))
 		}
 	}
 
-	mpt2sas_base_put_smid_scsi_io(ioc, smid,
-	    sas_device_priv_data->sas_target->handle);
+	if (likely(mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST))
+		mpt2sas_base_put_smid_scsi_io(ioc, smid,
+		    sas_device_priv_data->sas_target->handle);
+	else
+		mpt2sas_base_put_smid_default(ioc, smid);
 	return 0;
 
  out:
