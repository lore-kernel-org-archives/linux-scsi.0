From: Manjunath M B <Manjunath.MB@synopsys.com>
Subject: [PATCH 1/1] scsi: ufs: tc-dwc-g210 driver fix for 20-bit RMMI
Date: Tue, 12 Jul 2016 19:25:36 +0530
Message-ID: <1468331736-23825-1-git-send-email-manjumb@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:40037 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbcGLNzq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2016 09:55:46 -0400
Received: from dc8secmta1.synopsys.com (dc8secmta1.synopsys.com [10.13.218.200])
	by smtprelay.synopsys.com (Postfix) with ESMTP id 7231D10C0BB8
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 06:55:45 -0700 (PDT)
Received: from dc8secmta1.internal.synopsys.com (dc8secmta1.internal.synopsys.com [127.0.0.1])
	by dc8secmta1.internal.synopsys.com (Service) with ESMTP id 6417B27113
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 06:55:45 -0700 (PDT)
Received: from mailhost.synopsys.com (mailhost1.synopsys.com [10.12.238.239])
	by dc8secmta1.internal.synopsys.com (Service) with ESMTP id 465FB27102
	for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2016 06:55:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joao.Pinto@synopsys.com
Cc: linux-scsi@vger.kernel.org, Manjunath M B <Manjunath.MB@synopsys.com>

The code was checking on PA_CONNECTEDRXLANES and
PA_CONNECTEDTXLANES attributes to program the Lane#1
attributes. The correct attributes are PA_AVAILRXDATALANES and
PA_AVAILTXDATALANES respectively.

Signed-off-by: Manjunath M B <manjumb@synopsys.com>
---
 drivers/scsi/ufs/tc-dwc-g210.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/scsi/ufs/tc-dwc-g210.c
index d6c5388..70db6d9 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.c
+++ b/drivers/scsi/ufs/tc-dwc-g210.c
@@ -187,9 +187,9 @@ static int tc_dwc_g210_setup_20bit_rmmi_lane1(struct ufs_hba *hba)
 	};
 
 	/* Get the available lane count */
-	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILRXDATALANES),
 			&connected_rx_lanes);
-	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILTXDATALANES),
 			&connected_tx_lanes);
 
 	if (connected_tx_lanes == 2) {
-- 
1.9.1

