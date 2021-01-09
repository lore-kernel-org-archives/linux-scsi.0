Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15315C433DB
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9817235FC
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbhAIMaM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 07:30:12 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:58550 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbhAIMaL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 07:30:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610195411; x=1641731411;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=+UH1GFWNZL0c3SQyIVx/6vcCgjMv4VYJ5Vya3lAHH3c=;
  b=MYkqtLZoNRL/t7+zXzZ31GKAdi9K9yKSJpUU3CwX2zgXKjPpbzGL+1GF
   ktB257ukqUYLM8woaVGW+Obi6YGuXmJw6YeT0+PaQjjd6bU/tF4ECTNNc
   G46cdYBmMLaV+08VhlPESJxEXD0LlCd80BbvxN1yTwqtYQhywe6fsgbtH
   jkIwTRFHbFzrF2c4W1uxya7F7NZP3bUh5lvar60XOqYbqnZvKmq87bqU5
   eC8hrjCvZzpd1SyN4i81tMz90mZiIuRgfcnYhXDPqzIFpWU7jehgFvYiZ
   lfhp9Ayx7L0WjvPecQAsc+ldvJVhNUFqJugeDiwze7+CKJKS7rVhYTTr9
   Q==;
IronPort-SDR: BNvaIltLIeFHSCJAZ6uSpKVBdPy9LaZBmJNuEiTVRqBiPNXLe/k0xwp4Az3L07ppdxES3nSrmM
 BWfCFQVZ8CHAjyKuqe2fvuCBI+kN6npfC9MVbMZCletLYjJzTaupmKYcJ7WUoqW1Apy/bReRL3
 4kwWcMQtUToVL3P1u1T/Q/pLL9dvhOVn4Xeb+A2BhDJaigkFkGU2KahDgkVMB3IGNH24sPX6Am
 7neGq8EApqldwuMkaul1+gLAS3E71ibUZNfq75G7G+KFtFilyQ4w8MWiJnHP1D3tNL9nbN3FCV
 S3M=
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="110403305"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2021 05:28:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 9 Jan 2021 05:28:55 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 9 Jan 2021 05:28:55 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 1/8] pm80xx: No busywait in MPI init check
Date:   Sat, 9 Jan 2021 18:08:42 +0530
Message-ID: <20210109123849.17098-2-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210109123849.17098-1-Viswas.G@microchip.com>
References: <20210109123849.17098-1-Viswas.G@microchip.com>
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
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
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

