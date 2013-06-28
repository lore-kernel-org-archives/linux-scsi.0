From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 2/7][SCSI] mpt3sas: Updated the Hardware timing requirements
Date: Sat, 29 Jun 2013 03:51:19 +0530
Message-ID: <20130628222119.GA5046@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:17526
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755423Ab3F1LZ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jun 2013 07:25:58 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com


Hardware timing requirements is updated in order to comply with firmware requirement.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 673a1b5..5dc280c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4090,11 +4090,15 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 	writel(host_diagnostic | MPI2_DIAG_RESET_ADAPTER,
 	     &ioc->chip->HostDiagnostic);
 
-	/* don't access any registers for 50 milliseconds */
-	msleep(50);
+	/*This delay allows the chip PCIe hardware time to finish reset tasks*/
+	if (sleep_flag == CAN_SLEEP)
+		msleep(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
+	else
+		mdelay(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
 
-	/* 300 second max wait */
-	for (count = 0; count < 3000000 ; count++) {
+	/* Approximately 300 second max wait */
+	for (count = 0; count < (300000000 /
+		MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC); count++) {
 
 		host_diagnostic = readl(&ioc->chip->HostDiagnostic);
 
@@ -4103,11 +4107,13 @@ _base_diag_reset(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
 		if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
 			break;
 
-		/* wait 1 msec */
+		/* Wait to pass the second read delay window */
 		if (sleep_flag == CAN_SLEEP)
-			usleep_range(1000, 1500);
+			msleep(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC
+								/ 1000);
 		else
-			mdelay(1);
+			mdelay(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC
+								/ 1000);
 	}
 
 	if (host_diagnostic & MPI2_DIAG_HCB_MODE) {
-- 
1.7.3


