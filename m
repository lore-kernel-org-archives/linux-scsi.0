From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH V2 4/9] pm80xx : tag allocation for phy control request.
Date: Wed, 18 Feb 2015 05:06:45 +0530
Message-ID: <20150217233650.9091-5-Viswas.G@microsemi.com>
References: <20150217233650.9091-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03hn0220.outbound.protection.outlook.com ([104.47.40.220]:7620
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751905AbdIMKmL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Sep 2017 06:42:11 -0400
In-Reply-To: <20150217233650.9091-1-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, jinpu.wang@profitbricks.com, martin.petersen@oracle.com

tag is taken from the tag pool instead of using the hardcoded
tag value(1).

Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
Signed-off-by: Viswas G <Viswas.G@microsemi.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c |  3 +++
 drivers/scsi/pm8001/pm80xx_hwi.c | 10 +++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 10546faac58c..bc4a6f649ec9 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3198,11 +3198,13 @@ pm8001_mpi_get_nvmd_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
 {
+	u32 tag;
 	struct local_phy_ctl_resp *pPayload =
 		(struct local_phy_ctl_resp *)(piomb + 4);
 	u32 status = le32_to_cpu(pPayload->status);
 	u32 phy_id = le32_to_cpu(pPayload->phyop_phyid) & ID_BITS;
 	u32 phy_op = le32_to_cpu(pPayload->phyop_phyid) & OP_BITS;
+	tag = le32_to_cpu(pPayload->tag);
 	if (status != 0) {
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("%x phy execute %x phy op failed!\n",
@@ -3211,6 +3213,7 @@ int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("%x phy execute %x phy op success!\n",
 			phy_id, phy_op));
+	pm8001_tag_free(pm8001_ha, tag);
 	return 0;
 }
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 2b26445d1b97..baab8a19c78e 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4500,17 +4500,21 @@ static int pm80xx_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	u32 phyId, u32 phy_op)
 {
+	u32 tag;
+	int rc;
 	struct local_phy_ctl_req payload;
 	struct inbound_queue_table *circularQ;
 	int ret;
 	u32 opc = OPC_INB_LOCAL_PHY_CONTROL;
 	memset(&payload, 0, sizeof(payload));
+	rc = pm8001_tag_alloc(pm8001_ha, &tag);
+	if (rc)
+		return rc;
 	circularQ = &pm8001_ha->inbnd_q_tbl[0];
-	payload.tag = cpu_to_le32(1);
+	payload.tag = cpu_to_le32(tag);
 	payload.phyop_phyid =
 		cpu_to_le32(((phy_op & 0xFF) << 8) | (phyId & 0xFF));
-	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
-	return ret;
+	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload, 0);
 }
 
 static u32 pm80xx_chip_is_our_interupt(struct pm8001_hba_info *pm8001_ha)
-- 
2.12.3
