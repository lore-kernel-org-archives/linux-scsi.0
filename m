Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1198C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 12:41:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBD1C2083B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 12:41:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="C85Y7VIN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbgG2MlQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 08:41:16 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:27304 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2MlP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 08:41:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1596026474; x=1627562474;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TEc5DSpAmCmxbrBrINUAvHCtF0GFUWkivyKB211/rcw=;
  b=C85Y7VIN1zL2EaNdRvNWCsBRFiYUOwswVlQgCWwGf/OJXDVeMrFSyhEl
   2qZbC0HIxFZEVvbZQ8Zt30Fv8LyErphSzmPgfUoKRv1Q/v+9syXiuQH6O
   tH2Dx4xptVewE5BCtuqWfU7iByoO/jP940jkNYJXTQFo9OCtdW0m9Q9bd
   7Kl0Tbw484xSgCUm1d9uF+IwvxRlwn/gmfH2KuNlpye/QVjHvUclDTgSY
   fR0XVSHm0oZl0NelM3z+TT9Q6J9eDkU/AjWHB8qEW6gWBwkSmqupafXRe
   vNoN67rwvxZwnKuEXULSnrofFPAvM7AaOoYJzideN/lpY2ntCFZ8WaicJ
   A==;
IronPort-SDR: CTSQj+6JFhIP9OZjQp8tsk94HQklZ9E/b+DvSCuaHfHUPX73n4zdDRHnp1Gti7iR0DGiiILgu4
 SkyPll9ecGx/i9LtBsdw6YheDpYdRzja1dLv6gLWAnoAXSBJEP2U3N4DBfDhjkZe7rCPFswCwz
 pMcC6JfgRkHPs7NLgw0IGSNcFu+WCou0p5/BAKAxmpLL4AtaGXo/mcKvTKgxjhh2O7G34MlJjG
 OE2vuw5Ed7P4GeS4nM2/3qqX7Reh4WoAfhqySjoxvgW01UDy7VzLRY57rnWsGHoqSuK3Stnzb4
 bss=
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="81636765"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.22])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jul 2020 05:41:13 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX2.microsemi.net
 (10.100.34.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 29 Jul
 2020 05:41:13 -0700
Received: from localhost (10.41.130.51) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1979.3 via Frontend Transport; Wed, 29 Jul
 2020 05:41:12 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V4 1/2] pm80xx : Support for get phy profile functionality.
Date:   Wed, 29 Jul 2020 18:20:49 +0530
Message-ID: <20200729125050.5821-2-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20200729125050.5821-1-deepak.ukey@microchip.com>
References: <20200729125050.5821-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

Added the support to get the phy profile which gives information
about the phy states, port and errors on phy.

Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/scsi/pm8001/pm8001_ctl.h  | 20 +++++++++
 drivers/scsi/pm8001/pm8001_init.c |  2 +
 drivers/scsi/pm8001/pm8001_sas.h  |  5 +++
 drivers/scsi/pm8001/pm80xx_hwi.c  | 88 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/pm8001/pm80xx_hwi.h  |  2 +
 5 files changed, 115 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.h b/drivers/scsi/pm8001/pm8001_ctl.h
index d0d43a250b9e..02dc04a1fbe8 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.h
+++ b/drivers/scsi/pm8001/pm8001_ctl.h
@@ -41,6 +41,26 @@
 #ifndef PM8001_CTL_H_INCLUDED
 #define PM8001_CTL_H_INCLUDED
 
+struct phy_status {
+	char		phy_id;
+	unsigned int	phy_state:4;
+	unsigned int	nlr:4;
+	unsigned int	plr:4;
+	unsigned int	reserved1:12;
+	unsigned char	port_id;
+	unsigned int	prts:4;
+	unsigned int	reserved2:20;
+} __packed;
+
+struct phy_errcnt {
+	unsigned int	InvalidDword;
+	unsigned int	runningDisparityError;
+	unsigned int	codeViolation;
+	unsigned int	LossOfSyncDW;
+	unsigned int	phyResetProblem;
+	unsigned int	inboundCRCError;
+};
+
 #define IOCTL_BUF_SIZE		4096
 #define HEADER_LEN			28
 #define SIZE_OFFSET			16
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 9e99262a2b9d..ff65d6cf6d31 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -398,6 +398,8 @@ static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha,
 		pm8001_ha->ccb_info[i].task = NULL;
 		pm8001_ha->ccb_info[i].ccb_tag = 0xffffffff;
 		pm8001_ha->ccb_info[i].device = NULL;
+		pm8001_ha->ccb_info[i].completion = NULL;
+		pm8001_ha->ccb_info[i].resp_buf = NULL;
 		++pm8001_ha->tags_num;
 	}
 	pm8001_ha->flags = PM8001F_INIT_TIME;
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index ae7ba9b3c4bc..488af79dec47 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -56,6 +56,7 @@
 #include <scsi/sas_ata.h>
 #include <linux/atomic.h>
 #include "pm8001_defs.h"
+#include "pm8001_ctl.h"
 
 #define DRV_NAME		"pm80xx"
 #define DRV_VERSION		"0.1.39"
@@ -244,6 +245,8 @@ struct pm8001_dispatch {
 	int (*sas_diag_execute_req)(struct pm8001_hba_info *pm8001_ha,
 		u32 state);
 	int (*sas_re_init_req)(struct pm8001_hba_info *pm8001_ha);
+	int (*get_phy_profile_req)(struct pm8001_hba_info *pm8001_ha,
+		int phy, int page, struct completion *comp, void *buf);
 };
 
 struct pm8001_chip_info {
@@ -318,6 +321,8 @@ struct pm8001_ccb_info {
 	struct pm8001_prd	buf_prd[PM8001_MAX_DMA_SG];
 	struct fw_control_ex	*fw_control_context;
 	u8			open_retry;
+	struct completion	*completion;
+	void			*resp_buf;
 };
 
 struct mpi_mem {
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 4d205ebaee87..baccb082e65f 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3792,7 +3792,6 @@ static int mpi_set_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
 	PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
 			"SET CONTROLLER RESP: status 0x%x qlfr_pgcd 0x%x\n",
 			status, err_qlfr_pgcd));
-
 	return 0;
 }
 
@@ -3818,9 +3817,63 @@ static int mpi_get_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
 static int mpi_get_phy_profile_resp(struct pm8001_hba_info *pm8001_ha,
 			void *piomb)
 {
+	u32 tag, page_code;
+	struct phy_status *phy_status, *phy_stat;
+	struct phy_errcnt *phy_err, *phy_err_cnt;
+	struct pm8001_ccb_info *ccb;
+	struct get_phy_profile_resp *pPayload =
+		(struct get_phy_profile_resp *)(piomb + 4);
+	u32 status = le32_to_cpu(pPayload->status);
+
+	page_code = (u8)((pPayload->ppc_phyid & 0xFF00) >> 8);
+
 	PM8001_MSG_DBG(pm8001_ha,
-			pm8001_printk(" pm80xx_addition_functionality\n"));
+		pm8001_printk(" pm80xx_addition_functionality\n"));
+	if (status) {
+		/* status is FAILED */
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+			"mpiGetPhyProfileReq failed  with status 0x%08x\n",
+			status));
+	}
 
+	tag = le32_to_cpu(pPayload->tag);
+	ccb = &pm8001_ha->ccb_info[tag];
+	if (ccb->completion != NULL) {
+		if (status) {
+			/* signal fail status */
+			memset(&ccb->resp_buf, 0xff, sizeof(ccb->resp_buf));
+		} else if (page_code == SAS_PHY_GENERAL_STATUS_PAGE) {
+			phy_status = (struct phy_status *)ccb->resp_buf;
+			phy_stat =
+			(struct phy_status *)pPayload->ppc_specific_rsp;
+			phy_status->phy_id =
+				le32_to_cpu((__force __le32)phy_stat->phy_id);
+			phy_status->phy_state =
+				le32_to_cpu((__force __le32)phy_stat->phy_state);
+			phy_status->plr =
+				le32_to_cpu((__force __le32)phy_stat->plr);
+			phy_status->nlr =
+				le32_to_cpu((__force __le32)phy_stat->nlr);
+			phy_status->port_id =
+				le32_to_cpu((__force __le32)phy_stat->port_id);
+			phy_status->prts =
+				le32_to_cpu((__force __le32)phy_stat->prts);
+		} else if (page_code == SAS_PHY_ERR_COUNTERS_PAGE) {
+			phy_err = (struct phy_errcnt *)ccb->resp_buf;
+			phy_err_cnt =
+			(struct phy_errcnt *)pPayload->ppc_specific_rsp;
+			phy_err->InvalidDword =
+			le32_to_cpu((__force __le32)phy_err_cnt->InvalidDword);
+			phy_err->runningDisparityError = le32_to_cpu
+			((__force __le32)phy_err_cnt->runningDisparityError);
+			phy_err->LossOfSyncDW = le32_to_cpu
+			((__force __le32)phy_err_cnt->LossOfSyncDW);
+			phy_err->phyResetProblem = le32_to_cpu
+			((__force __le32)phy_err_cnt->phyResetProblem);
+		}
+		complete(ccb->completion);
+	}
+	pm8001_tag_free(pm8001_ha, tag);
 	return 0;
 }
 
@@ -5013,6 +5066,36 @@ pm80xx_chip_isr(struct pm8001_hba_info *pm8001_ha, u8 vec)
 	return IRQ_HANDLED;
 }
 
+static int pm8001_chip_get_phy_profile(struct pm8001_hba_info *pm8001_ha,
+	int phy_id, int page_code, struct completion *comp, void *buf)
+{
+	u32 tag;
+	struct get_phy_profile_req payload;
+	struct inbound_queue_table *circularQ;
+	struct pm8001_ccb_info *ccb;
+	int rc, ppc_phyid;
+	u32 opc = OPC_INB_GET_PHY_PROFILE;
+
+	memset(&payload, 0, sizeof(payload));
+
+	rc = pm8001_tag_alloc(pm8001_ha, &tag);
+	if (rc)
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk("Invalid tag\n"));
+
+	ccb = &pm8001_ha->ccb_info[tag];
+	ccb->completion = comp;
+	ccb->resp_buf = buf;
+	circularQ = &pm8001_ha->inbnd_q_tbl[0];
+
+	payload.tag = cpu_to_le32(tag);
+	ppc_phyid = (page_code & 0xFF)  << 8 | (phy_id & 0xFF);
+	payload.ppc_phyid = cpu_to_le32(ppc_phyid);
+
+	pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+			sizeof(payload), 0);
+	return rc;
+}
+
 void mpi_set_phy_profile_req(struct pm8001_hba_info *pm8001_ha,
 	u32 operation, u32 phyid, u32 length, u32 *buf)
 {
@@ -5113,4 +5196,5 @@ const struct pm8001_dispatch pm8001_80xx_dispatch = {
 	.set_nvmd_req		= pm8001_chip_set_nvmd_req,
 	.fw_flash_update_req	= pm8001_chip_fw_flash_update_req,
 	.set_dev_state_req	= pm8001_chip_set_dev_state_req,
+	.get_phy_profile_req	= pm8001_chip_get_phy_profile,
 };
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index 701951a0f715..b5119c5479da 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -175,7 +175,9 @@
 #define PHY_STOP_ERR_DEVICE_ATTACHED	0x1046
 
 /* phy_profile */
+#define SAS_PHY_ERR_COUNTERS_PAGE	0x01
 #define SAS_PHY_ANALOG_SETTINGS_PAGE	0x04
+#define SAS_PHY_GENERAL_STATUS_PAGE	0x05
 #define PHY_DWORD_LENGTH		0xC
 
 /* Thermal related */
-- 
2.16.3

