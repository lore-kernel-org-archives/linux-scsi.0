From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 04/12] [SCSI] mpt2sas : Perform Target Reset instead of
 HBA reset when a SATA_PASSTHROUGH cmd timeout happens
Date: Tue, 20 Mar 2012 12:05:11 +0530
Message-ID: <201203200634.q2K6YdoW032023@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:45556 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754067Ab2CTGen (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 02:34:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: jejb@kernel.org

Perform Target Reset instead of HBA reset when a SATA_PASSTHROUGH cmd
timeout happens.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_ctl.c b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
index 43ad620..42f8d71 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_ctl.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_ctl.c
@@ -980,7 +980,8 @@ _ctl_do_mpt_command(struct MPT2SAS_ADAPTER *ioc, struct mpt2_ioctl_command karg,
 		ret = -ENODATA;
 		if ((mpi_request->Function == MPI2_FUNCTION_SCSI_IO_REQUEST ||
 		    mpi_request->Function ==
-		    MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH)) {
+		    MPI2_FUNCTION_RAID_SCSI_IO_PASSTHROUGH ||
+		    mpi_request->Function == MPI2_FUNCTION_SATA_PASSTHROUGH)) {
 			printk(MPT2SAS_INFO_FMT "issue target reset: handle "
 			    "= (0x%04x)\n", ioc->name,
 			    le16_to_cpu(mpi_request->FunctionDependent1));
