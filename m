Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4581CA9ECE
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 05:12:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5A6E2067D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 05:12:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbfJaFMc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 01:12:32 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:29240 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfJaFMc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 01:12:32 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa6.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa6.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: +Q8AIq8D7zuOnVyyUr11PPl2bwBgNXCQbL8XOhbHorTdStHsXAdZ78LgxcNb7nhzyZRB5g3db7
 YnR53JynBqNIKI0fVvsgZCqmQ2PRcZB9/nUTcxeOsGvFheqsgVmTfFRQvK7cYfbEB6UqFRAq5J
 xyQqaiUJpDdgs+lcgB4nITEz8TrFBzxGFs2sbcxYdz6x0f69lrBpz1jU91uGVRdLdIyuDxP0Pn
 vu1IJ8X9IDGrK5XczczMO9XPloI6RJE/uyYkH7Mm/ZJmyerrlRo2Cn1UzcctPguufo6kK9KooW
 7PI=
X-IronPort-AV: E=Sophos;i="5.68,250,1569308400"; 
   d="scan'208";a="52279699"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Oct 2019 22:12:21 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Wed, 30 Oct
 2019 22:12:20 -0700
Received: from localhost (10.41.130.49) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Wed, 30 Oct
 2019 22:12:19 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <jsperbeck@google.com>, <auradkar@google.com>,
        <ianyar@google.com>
Subject: [PATCH 09/12] pm80xx : Do not request 12G sas speeds.
Date:   Thu, 31 Oct 2019 10:42:38 +0530
Message-ID: <20191031051241.6762-10-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191031051241.6762-1-deepak.ukey@microchip.com>
References: <20191031051241.6762-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: peter chang <dpf@google.com>

occasionally, 6G capable drives fail to train at 6G on links that look
good from a signal-integrity perspective. PMC suggests configuring the
port to not even expect 12G.

Signed-off-by: peter chang <dpf@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 17 +++++++++++++++++
 drivers/scsi/pm8001/pm8001_sas.h  |  1 +
 drivers/scsi/pm8001/pm80xx_hwi.c  | 21 ++++-----------------
 3 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index b7cc3d05a3e0..86b619d10392 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -41,11 +41,20 @@
 #include <linux/slab.h>
 #include "pm8001_sas.h"
 #include "pm8001_chips.h"
+#include "pm80xx_hwi.h"
 
 static ulong logging_level = PM8001_FAIL_LOGGING | PM8001_IOERR_LOGGING;
 module_param(logging_level, ulong, 0644);
 MODULE_PARM_DESC(logging_level, " bits for enabling logging info.");
 
+static ulong link_rate = LINKRATE_15 | LINKRATE_30 | LINKRATE_60 | LINKRATE_120;
+module_param(link_rate, ulong, 0644);
+MODULE_PARM_DESC(link_rate, "Enable link rate.\n"
+		" 1: Link rate 1.5G\n"
+		" 2: Link rate 3.0G\n"
+		" 4: Link rate 6.0G\n"
+		" 8: Link rate 12.0G\n");
+
 static struct scsi_transport_template *pm8001_stt;
 
 /**
@@ -471,6 +480,14 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
 	pm8001_ha->shost = shost;
 	pm8001_ha->id = pm8001_id++;
 	pm8001_ha->logging_level = logging_level;
+	if (link_rate >= 1 && link_rate <= 15)
+		pm8001_ha->link_rate = (link_rate << 8);
+	else {
+		pm8001_ha->link_rate = LINKRATE_15 | LINKRATE_30 |
+			LINKRATE_60 | LINKRATE_120;
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+			"Setting link rate to default value\n"));
+	}
 	sprintf(pm8001_ha->name, "%s%d", DRV_NAME, pm8001_ha->id);
 	/* IOMB size is 128 for 8088/89 controllers */
 	if (pm8001_ha->chip_id != chip_8001)
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index d64883b80da9..f7be7b85624e 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -546,6 +546,7 @@ struct pm8001_hba_info {
 	struct tasklet_struct	tasklet[PM8001_MAX_MSIX_VEC];
 #endif
 	u32			logging_level;
+	u32			link_rate;
 	u32			fw_status;
 	u32			smp_exp_mode;
 	bool			controller_fatal_error;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 09008db2efdc..5ca9732f4704 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -37,6 +37,7 @@
  * POSSIBILITY OF SUCH DAMAGES.
  *
  */
+ #include <linux/version.h>
  #include <linux/slab.h>
  #include "pm8001_sas.h"
  #include "pm80xx_hwi.h"
@@ -4565,23 +4566,9 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 
 	PM8001_INIT_DBG(pm8001_ha,
 		pm8001_printk("PHY START REQ for phy_id %d\n", phy_id));
-	/*
-	 ** [0:7]	PHY Identifier
-	 ** [8:11]	link rate 1.5G, 3G, 6G
-	 ** [12:13] link mode 01b SAS mode; 10b SATA mode; 11b Auto mode
-	 ** [14]	0b disable spin up hold; 1b enable spin up hold
-	 ** [15] ob no change in current PHY analig setup 1b enable using SPAST
-	 */
-	if (!IS_SPCV_12G(pm8001_ha->pdev))
-		payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
-				LINKMODE_AUTO | LINKRATE_15 |
-				LINKRATE_30 | LINKRATE_60 | phy_id);
-	else
-		payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
-				LINKMODE_AUTO | LINKRATE_15 |
-				LINKRATE_30 | LINKRATE_60 | LINKRATE_120 |
-				phy_id);
 
+	payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
+			LINKMODE_AUTO | pm8001_ha->link_rate | phy_id);
 	/* SSC Disable and SAS Analog ST configuration */
 	/**
 	payload.ase_sh_lm_slr_phyid =
@@ -4594,7 +4581,7 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 	payload.sas_identify.dev_type = SAS_END_DEVICE;
 	payload.sas_identify.initiator_bits = SAS_PROTOCOL_ALL;
 	memcpy(payload.sas_identify.sas_addr,
-	  &pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
+	  &pm8001_ha->sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id = phy_id;
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opcode, &payload,
 			sizeof(payload), 0);
-- 
2.16.3

