From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 2/10] mpt2sas: Return -ENODATA on IOCTL timeout
Date: Wed, 16 Dec 2009 18:51:05 +0530
Message-ID: <20091216132057.GC31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:54871 "HELO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754764AbZLPNs2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 08:48:28 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


The driver was modified to return -ENODATA when there is a timeout
via ioctl path.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Reviewed-by: Eric Moore <eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 84a124f..198ecdd 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -891,6 +891,7 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc,
 
  issue_host_reset:
 	if (issue_reset) {
+		ret = -ENODATA;
 		if ((mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST ||
 		    mpi_request->Function ==
 		    MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) {
