From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 4/8] [SCSI] mpt2sas : Update the timing requirements for
 issuing a Hard Reset as per the MPI spec
Date: Fri, 1 Feb 2013 21:55:43 +0530
Message-ID: <20130201162543.GA21627@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:33778 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841Ab3BAFcn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2013 00:32:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, sreekanth.reddy@lsi.com, Nagalakshmi.Nandigama@lsi.com, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, sathya.prakash@lsi.com

Updated the mpt2sas driver code that issues hard reset to comply with the timing requirements
mentioned in MPI specifications rev V.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index ce89b14..fc91a5a 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3920,11 +3920,15 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	writel(host_diagnostic | MPI2_DIAG_RESET_ADAPTER,
 	     &ioc->chip->HostDiagnostic);
 
-	/* don't access any registers for 50 milliseconds */
-	msleep(50);
+	/* This delay allows the chip PCIe hardware time to finish reset tasks*/
+	if (sleep_flag == CAN_SLEEP)
+		msleep(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
+	else
+		mdelay(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
 
-	/* 300 second max wait */
-	for (count = 0; count < 3000000 ; count++) {
+	/* Approximately 300 second max wait */
+	for (count = 0; count < (300000000 /
+	    MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC); count++) {
 
 		host_diagnostic = readl(&ioc->chip->HostDiagnostic);
 
@@ -3933,11 +3937,13 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 		if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
 			break;
 
-		/* wait 100 msec */
+		/* Wait to pass the second read delay window */
 		if (sleep_flag == CAN_SLEEP)
-			msleep(1);
+			msleep(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC\
+				/1000);
 		else
-			mdelay(1);
+			mdelay(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC\
+				/1000);
 	}
 
 	if (host_diagnostic & MPI2_DIAG_HCB_MODE) {
