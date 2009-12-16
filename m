From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 4/5] mptfusion: corrected if condition check for SCSIIO and PASSTHROUGH commands
Date: Wed, 16 Dec 2009 19:02:59 +0530
Message-ID: <20091216133252.GQ31161@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:33318 "HELO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933962AbZLPOAW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Dec 2009 09:00:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Modified the function type check to verify it is not
MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH or MPI_FUNCTION_SCSI_IO_REQUEST.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 352acd0..caa8f56 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -360,8 +360,8 @@ static int mptctl_bus_reset(MPT_ADAPTER *ioc, u8 function)
 	u16		 iocstatus;
 
 	/* bus reset is only good for SCSI IO, RAID PASSTHRU */
-	if (!(function == MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH) ||
-	    (function == MPI_FUNCTION_SCSI_IO_REQUEST)) {
+	if (!(function == MPI_FUNCTION_RAID_SCSI_IO_PASSTHROUGH ||
+		function == MPI_FUNCTION_SCSI_IO_REQUEST)) {
 		dtmprintk(ioc, printk(MYIOC_s_WARN_FMT
 			"TaskMgmt, not SCSI_IO!!\n", ioc->name));
 		return -EPERM;
