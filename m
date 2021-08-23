Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 498A8C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 07:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 162A760F92
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 07:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235076AbhHWH30 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 03:29:26 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:9105 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234993AbhHWH3Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 03:29:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1629703722; x=1661239722;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BDWpPTiMgVnLmdLcw+Clhv4Q4lMPvakgDLNWza6F1oc=;
  b=cLMQs4JftLsbh10v2kvvLdWAyF7nag87kldEI9aW2dkVj5RM7VIaH6rO
   8vo1XWuZFHMRfmWcG7vLFdhBRCZDxX3rAWBnukcdsudxC4at9HLnq4Epb
   RLtaO2MC8ryKilt8zG3I1Luv/L1RzSdSTYzQZ9Jlyajej5QlWwlW6PSKz
   O3ZBhj4MFx+Z09k83LYMZ9Rwv6vtLPrVQ2uPquiTHTIOP/YeO5T7d6AnH
   +ydhdc4qiScYQzuD63s4zUsFqtVLrQ5zCJB3nvBl+WmHgZT8gR4fVTujy
   J9tWeDXfv662IHP2G7gji+a1yKqfJu95llnU3hGDH276T31On9yqv0Vfa
   g==;
IronPort-SDR: Q2SbYcdgyf1cjO5Xui+8XuzeK6QLJVrRcAND66HhrTu95aFsAD76dFAgYPMVHrK4YP2BvddIYi
 t2pVP1hNOl85BgX/IseiwM4Z248CcBM9m0JBP8V3qu5Mva9JExpxvTtOBwMUY6R1qUbECCfOUH
 m0DgWkg/8+0y6NM9SjL5LkcKZ5xTeyN8y7uHzFs+N4As+7xwx9nHjgWhyL931y8+6exBi8pha3
 zqo73iER9fvKVspd2c8SqtX0noZrZnITJ3fjJJCV/bafFVSYgjgqyC8aIP6jLNn4b0r2mIGaW7
 l5h4+oOi6KMz5VQty9WpmDEY
X-IronPort-AV: E=Sophos;i="5.84,343,1620716400"; 
   d="scan'208";a="66749187"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Aug 2021 00:28:41 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 23 Aug 2021 00:28:41 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 23 Aug 2021 00:28:41 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 4/4] scsi: pm80xx: fix memory leak during rmmod
Date:   Mon, 23 Aug 2021 13:53:38 +0530
Message-ID: <20210823082338.67309-5-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210823082338.67309-1-Ajish.Koshy@microchip.com>
References: <20210823082338.67309-1-Ajish.Koshy@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Driver fails to release memory allocated. This will lead
to memory leak during driver removal.

Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 11 +++++++++++
 drivers/scsi/pm8001/pm8001_sas.h  |  1 +
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 613455a3e686..7082fecf7ce8 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1199,6 +1199,7 @@ pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
 		goto err_out;
 
 	/* Memory region for ccb_info*/
+	pm8001_ha->ccb_count = ccb_count;
 	pm8001_ha->ccb_info =
 		kcalloc(ccb_count, sizeof(struct pm8001_ccb_info), GFP_KERNEL);
 	if (!pm8001_ha->ccb_info) {
@@ -1260,6 +1261,16 @@ static void pm8001_pci_remove(struct pci_dev *pdev)
 			tasklet_kill(&pm8001_ha->tasklet[j]);
 #endif
 	scsi_host_put(pm8001_ha->shost);
+
+	for (i = 0; i < pm8001_ha->ccb_count; i++) {
+		dma_free_coherent(&pm8001_ha->pdev->dev,
+			sizeof(struct pm8001_prd) * PM8001_MAX_DMA_SG,
+			pm8001_ha->ccb_info[i].buf_prd,
+			pm8001_ha->ccb_info[i].ccb_dma_handle);
+	}
+	kfree(pm8001_ha->ccb_info);
+	kfree(pm8001_ha->devices);
+
 	pm8001_free(pm8001_ha);
 	kfree(sha->sas_phy);
 	kfree(sha->sas_port);
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index 3274d88a9ccc..7e999768bfd2 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -518,6 +518,7 @@ struct pm8001_hba_info {
 	u32			iomb_size; /* SPC and SPCV IOMB size */
 	struct pm8001_device	*devices;
 	struct pm8001_ccb_info	*ccb_info;
+	u32			ccb_count;
 #ifdef PM8001_USE_MSIX
 	int			number_of_intr;/*will be used in remove()*/
 	char			intr_drvname[PM8001_MAX_MSIX_VEC]
-- 
2.27.0

