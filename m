From: <Viswas.G@pmcs.com>
Subject: [PATCH 3/8] pm80xx: Update For Thermal Page Code
Date: Wed, 29 Jul 2015 11:57:15 +0530
Message-ID: <1438151240-4097-4-git-send-email-Viswas.G@pmcs.com>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:43879 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751790AbbG2G0N (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2015 02:26:13 -0400
In-Reply-To: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

From: Viswas G <Viswas.G@pmcs.com>

Thermal page code has been changed to 7 for the 12G controllers.

Signed-off-by: Viswas G <Viswas.G@pmcs.com>
Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com> 
---
 drivers/scsi/pm8001/pm80xx_hwi.c |    9 ++++++++-
 drivers/scsi/pm8001/pm80xx_hwi.h |    3 ++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 05cce46..dced9f7 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -843,6 +843,7 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
 	int rc;
 	u32 tag;
 	u32 opc = OPC_INB_SET_CONTROLLER_CONFIG;
+	u32 page_code;
 
 	memset(&payload, 0, sizeof(struct set_ctrl_cfg_req));
 	rc = pm8001_tag_alloc(pm8001_ha, &tag);
@@ -851,8 +852,14 @@ pm80xx_set_thermal_config(struct pm8001_hba_info *pm8001_ha)
 
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
 	payload.tag = cpu_to_le32(tag);
+
+	if (IS_SPCV_12G(pm8001_ha->pdev))
+		page_code = THERMAL_PAGE_CODE_7H;
+	else
+		page_code = THERMAL_PAGE_CODE_8H;
+
 	payload.cfg_pg[0] = (THERMAL_LOG_ENABLE << 9) |
-			(THERMAL_ENABLE << 8) | THERMAL_OP_CODE;
+				(THERMAL_ENABLE << 8) | page_code;
 	payload.cfg_pg[1] = (LTEMPHIL << 24) | (RTEMPHIL << 8);
 
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 9970a38..a083cc6 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -177,7 +177,8 @@
 /* Thermal related */
 #define	THERMAL_ENABLE			0x1
 #define	THERMAL_LOG_ENABLE		0x1
-#define THERMAL_OP_CODE			0x6
+#define THERMAL_PAGE_CODE_7H		0x6
+#define THERMAL_PAGE_CODE_8H		0x7
 #define LTEMPHIL			 70
 #define RTEMPHIL			100
 
-- 
1.7.1

