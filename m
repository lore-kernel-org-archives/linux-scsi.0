From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 16/19] aacraid: Enable ctrl reset for both hba and arc
Date: Sun, 7 May 2017 04:27:01 -0700
Message-ID: <20170507112704.21940-17-RaghavaAditya.Renukunta@microsemi.com>
References: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0087.outbound.protection.outlook.com ([104.47.40.87]:12320
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754772AbdEGVkZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 7 May 2017 17:40:25 -0400
In-Reply-To: <20170507112704.21940-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, Prasad.Munirathnam@microsemi.com, RaghavaAditya.Renukunta@microsemi.com

Make sure that IOP and SOFT reset are enabled for both for both
arc and hba1000 controllers.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/linit.c | 77 +++++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 3dea438..d933d2f 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -828,6 +828,11 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 	u32 bus, cid;
 	int ret = FAILED;
 	int status = 0;
+	__le32 supported_options2 = 0;
+	bool is_mu_reset;
+	bool is_ignore_reset;
+	bool is_doorbell_reset;
+
 
 	bus = aac_logical_to_phys(scmd_channel(cmd));
 	cid = scmd_id(cmd);
@@ -900,9 +905,9 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 			msleep(1000);
 		}
 
-		if (ret != SUCCESS)
-			pr_err("%s: Host adapter reset request timed out\n",
-			AAC_DRIVERNAME);
+		if (ret == SUCCESS)
+			goto out;
+
 	} else {
 
 		/* Mark the assoc. FIB to not complete, eh handler does this */
@@ -918,44 +923,42 @@ static int aac_eh_reset(struct scsi_cmnd* cmd)
 				cmd->SCp.phase = AAC_OWNER_ERROR_HANDLER;
 			}
 		}
+	}
 
-		pr_err("%s: Host adapter reset request. SCSI hang ?\n",
-					AAC_DRIVERNAME);
+	pr_err("%s: Host adapter reset request. SCSI hang ?\n", AAC_DRIVERNAME);
+
+	/*
+	 * Check the health of the controller
+	 */
+	status = aac_adapter_check_health(aac);
+	if (status)
+		dev_err(&aac->pdev->dev, "Adapter health - %d\n", status);
+
+	count = get_num_of_incomplete_fibs(aac);
+	if (count == 0)
+		return SUCCESS;
 
-		/*
-		 * Check the health of the controller
-		 */
-		status = aac_adapter_check_health(aac);
-		if (status)
-			dev_err(&aac->pdev->dev, "Adapter health - %d\n",
-									status);
-
-		count = get_num_of_incomplete_fibs(aac);
-		if (count == 0)
-			return SUCCESS;
-
-		/*
-		 * This adapter needs a blind reset, only do so for
-		 * Adapters that support a register, instead of a commanded,
-		 * reset.
-		 */
-		if (((aac->supplement_adapter_info.supported_options2 &
-			  AAC_OPTION_MU_RESET) ||
-			  (aac->supplement_adapter_info.supported_options2 &
-			  AAC_OPTION_DOORBELL_RESET)) &&
-			  aac_check_reset &&
-			  ((aac_check_reset != 1) ||
-			   !(aac->supplement_adapter_info.supported_options2 &
-			    AAC_OPTION_IGNORE_RESET))) {
-			/* Bypass wait for command quiesce */
-			aac_reset_adapter(aac, 2, IOP_HWSOFT_RESET);
-		}
-		ret = SUCCESS;
-	}
 	/*
-	 * Cause an immediate retry of the command with a ten second delay
-	 * after successful tur
+	 * Check if reset is supported by the firmware
 	 */
+	supported_options2 = aac->supplement_adapter_info.supported_options2;
+	is_mu_reset = supported_options2 & AAC_OPTION_MU_RESET;
+	is_doorbell_reset = supported_options2 & AAC_OPTION_DOORBELL_RESET;
+	is_ignore_reset = supported_options2 & AAC_OPTION_IGNORE_RESET;
+	/*
+	 * This adapter needs a blind reset, only do so for
+	 * Adapters that support a register, instead of a commanded,
+	 * reset.
+	 */
+	if ((is_mu_reset || is_doorbell_reset)
+	 && aac_check_reset
+	 && (aac_check_reset != -1 || !is_ignore_reset)) {
+		/* Bypass wait for command quiesce */
+		aac_reset_adapter(aac, 2, IOP_HWSOFT_RESET);
+	}
+	ret = SUCCESS;
+
+out:
 	return ret;
 }
 
-- 
2.7.4
