From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 08/19] aacraid: Print ctrl status before eh reset
Date: Sun, 7 May 2017 04:26:53 -0700
Message-ID: <20170507112704.21940-9-RaghavaAditya.Renukunta@microsemi.com>
References: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0073.outbound.protection.outlook.com ([104.47.38.73]:56168
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754623AbdEGVkU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:40:20 -0400
In-Reply-To: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

Log the status of the controller before issuing a reset.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/linit.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 0a8d303..3dea438 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -827,6 +827,7 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 	int count;
 	u32 bus, cid;
 	int ret = FAILED;
+	int status = 0;
 
 	bus = aac_logical_to_phys(scmd_channel(cmd));
 	cid = scmd_id(cmd);
@@ -921,6 +922,14 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 		pr_err("%s: Host adapter reset request. SCSI hang ?\n",
 					AAC_DRIVERNAME);
 
+		/*
+		 * Check the health of the controller
+		 */
+		status = aac_adapter_check_health(aac);
+		if (status)
+			dev_err(&aac->pdev->dev, "Adapter health - %d\n",
+									status);
+
 		count = get_num_of_incomplete_fibs(aac);
 		if (count == 0)
 			return SUCCESS;
-- 
2.7.4
