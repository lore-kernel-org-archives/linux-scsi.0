Return-Path: <SRS0=1SmL=YY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F31CA9ECF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 05:12:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 653972086D
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Oct 2019 05:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfJaFM0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Oct 2019 01:12:26 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:29216 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfJaFMZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Oct 2019 01:12:25 -0400
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
IronPort-SDR: CnTaMj7uIplhA9tVMAEnqOYP1/8+jhk/qGZstV0wFkNNIgo3aPgMjHzYHTIxk424UxZBF+BH5T
 oWxwI6nSz7I5D5SGRygQOBxrIAzFxASdM1SsDQawjoMmicUGnodA4OCRCMVHdoGuS276lYeCm3
 iUkrnbXNlNIOSvmpFoNxpSIqq5lpHVEugY2oJWeZPWKCjeUB5ZYnyfmcDlpi4fBDuow/5f169C
 sVlzKjhTPpVvqsRRonhTX7ORImcvCwrZHK+z9/I527vzMqsgSU9yUSl/JEUCdabO/PFGyQtON9
 iOU=
X-IronPort-AV: E=Sophos;i="5.68,250,1569308400"; 
   d="scan'208";a="52279651"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Oct 2019 22:12:12 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Wed, 30 Oct
 2019 22:12:11 -0700
Received: from localhost (10.41.130.49) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Wed, 30 Oct
 2019 22:12:11 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <jsperbeck@google.com>, <auradkar@google.com>,
        <ianyar@google.com>
Subject: [PATCH 05/12] pm80xx : Increase timeout for pm80xx mpi_uninit_check.
Date:   Thu, 31 Oct 2019 10:42:34 +0530
Message-ID: <20191031051241.6762-6-deepak.ukey@microchip.com>
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

From: ianyar <ianyar@google.com>

The function  mpi_uninit_check takes longer for inbound doorbell
register to be cleared. Increased the timeout substantially so
that the driver does not fail to load.

Signed-off-by: ianyar <ianyar@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
 drivers/scsi/pm8001/pm80xx_hwi.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 6057610263c1..9d04e5cfffb4 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -735,9 +735,9 @@ static int mpi_init_check(struct pm8001_hba_info *pm8001_ha)
 	pm8001_cw32(pm8001_ha, 0, MSGU_IBDB_SET, SPCv_MSGU_CFG_TABLE_UPDATE);
 	/* wait until Inbound DoorBell Clear Register toggled */
 	if (IS_SPCV_12G(pm8001_ha->pdev)) {
-		max_wait_count = 4 * 1000 * 1000;/* 4 sec */
+		max_wait_count = SPCV_DOORBELL_CLEAR_TIMEOUT;
 	} else {
-		max_wait_count = 2 * 1000 * 1000;/* 2 sec */
+		max_wait_count = SPC_DOORBELL_CLEAR_TIMEOUT;
 	}
 	do {
 		udelay(1);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index dc9ab7689060..701951a0f715 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -220,6 +220,9 @@
 #define SAS_DOPNRJT_RTRY_TMO            128
 #define SAS_COPNRJT_RTRY_TMO            128
 
+#define SPCV_DOORBELL_CLEAR_TIMEOUT	(30 * 1000 * 1000) /* 30 sec */
+#define SPC_DOORBELL_CLEAR_TIMEOUT	(15 * 1000 * 1000) /* 15 sec */
+
 /*
   Making ORR bigger than IT NEXUS LOSS which is 2000000us = 2 second.
   Assuming a bigger value 3 second, 3000000/128 = 23437.5 where 128
-- 
2.16.3

