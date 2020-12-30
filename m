Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA0A0C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F60A216C4
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgL3EtH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Dec 2020 23:49:07 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:26778 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgL3EtG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Dec 2020 23:49:06 -0500
IronPort-SDR: Zdrcv323kxbn5g3f/HVEU52RL+hqwGqgkQ2wlnpewcbCBCl5cxAmnNSDi3c9ftCk3CT/FnsyOV
 6vCQ4O5K0p2uQaE9ZMJcXaTtbtG6tauDh5rDPrvJSa4GfsL1Od1Q+kEpwvZXRWnegdNnNWZ2Kq
 O/q5KK3PAXT27zmsD1qoDhVWL0Z/VwzJat+R4PdXEX1VG+3AyN0GIlAmgRanxaLpxBnK8IEtEF
 2/w9F3F4YJsq6qWTXiS/Chs/1VdPiczT3AvYvj5G70cPmRY4qdLmfz+uzR3GDl/72wI8LvmmBw
 N3A=
X-IronPort-AV: E=Sophos;i="5.78,460,1599548400"; 
   d="scan'208";a="109308277"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Dec 2020 21:47:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Dec 2020 21:47:47 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 29 Dec 2020 21:47:47 -0700
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 1/8] pm80xx: No busywait in MPI init check
Date:   Wed, 30 Dec 2020 10:27:36 +0530
Message-ID: <20201230045743.14694-2-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20201230045743.14694-1-Viswas.G@microchip.com.com>
References: <20201230045743.14694-1-Viswas.G@microchip.com.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: akshatzen <akshatzen@google.com>

We do not need to busy wait during mpi_init_check. I confirmed that
mpi_init_check is not being invoked in an ATOMIC context. It is being
called from pm8001_pci_resume, pm8001_pci_probe. Hence we are
replacing the udelay which busy waits with msleep.

Signed-off-by: akshatzen <akshatzen@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 6 +++---
 drivers/scsi/pm8001/pm80xx_hwi.h | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 6772b0924dac..9c4b8b374ab8 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -997,7 +997,7 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
 		max_wait_count = SPC_DOORBELL_CLEAR_TIMEOUT;
 	}
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		value = pm8001_cr32(pm8001_ha, 0, MSGU_IBDB_SET);
 		value &= SPCv_MSGU_CFG_TABLE_UPDATE;
 	} while ((value != 0) && (--max_wait_count));
@@ -1010,9 +1010,9 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
 		return -EBUSY;
 	}
 	/* check the MPI-State for initialization upto 100ms*/
-	max_wait_count = 100 * 1000;/* 100 msec */
+	max_wait_count = 5;/* 100 msec */
 	do {
-		udelay(1);
+		msleep(FW_READY_INTERVAL);
 		gst_len_mpistate =
 			pm8001_mr32(pm8001_ha->general_stat_tbl_addr,
 					GST_GSTLEN_MPIS_OFFSET);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index ec48bc276de6..2b6b52551968 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -220,8 +220,8 @@
 #define SAS_DOPNRJT_RTRY_TMO            128
 #define SAS_COPNRJT_RTRY_TMO            128
 
-#define SPCV_DOORBELL_CLEAR_TIMEOUT	(30 * 1000 * 1000) /* 30 sec */
-#define SPC_DOORBELL_CLEAR_TIMEOUT	(15 * 1000 * 1000) /* 15 sec */
+#define SPCV_DOORBELL_CLEAR_TIMEOUT	(30 * 50) /* 30 sec */
+#define SPC_DOORBELL_CLEAR_TIMEOUT	(15 * 50) /* 15 sec */
 
 /*
   Making ORR bigger than IT NEXUS LOSS which is 2000000us = 2 second.
-- 
2.16.3

