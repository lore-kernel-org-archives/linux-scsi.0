Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F80C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 16:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BA3460F9E
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 16:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243830AbhIFQKM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 12:10:12 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:28185 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243365AbhIFQKM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 12:10:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1630944547; x=1662480547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QuMv62qGete1Ir6XfymEroOfmpoVY7HpWofR3YoSteI=;
  b=NXoVSSGWCUSZ36ozVHLYwV4cwIhRgzQu83c/jy+3N0ooN6SsRhoJVFwb
   1jXs7yjMBkJ8Aa6eQkwO2uFOpqBR1CH3Q1kLZ4daAoldQY/Z3EU+G38KV
   gd/gCI6OdoppvFNwIwRMIQ+p3osus7Y6pS/tNr/cNbfzI5zsNrFETZuL+
   d2K0aUIdFrnJcAo7AB/EQtYwpI+blG+EPLbt3Q5VEpz5xeCMlRc7Xgtso
   zzAr6xA6sZUO3iGxger/rCSIFQzSE4KbnxO+EMKuNSavrEHwMekxusAxg
   8BCwShKy4PohK9UUWdZS1U1p1j0rivSS3ZpSZXsP0+V3Y+tsmLj+yfLuy
   g==;
IronPort-SDR: 5bv6QqgZAKLVCKDbE4artys/diPmxu52sr7PecXYVXbPA1OSS7ACPbZPKwEnGFg2F/T+pWaC0x
 PsRS4RuC49mjXgPMmaz2+Rfer99ICfrVd3YtB7P2xdvkwzBSTRspCvYEK/ayd60HZXsCR4JQXb
 9qTIRABjh8UjVRJAOKPR9isxoIrOC7Qyb1KYIa9E3KDG0U2NFNgjKWimI4VY0Pw3Ow2YaPxE2v
 M09NlWnWUsalPMm4rOcSltLGBcSI0Vyrl6KN+ovmVCqJK0TI/1lV8KbQIOcT61XkPEymClLgF/
 B1qHpSclA5/2RNe5/E+VPt8i
X-IronPort-AV: E=Sophos;i="5.85,272,1624345200"; 
   d="scan'208";a="130876427"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Sep 2021 09:09:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 6 Sep 2021 09:09:06 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 6 Sep 2021 09:09:06 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 4/4] scsi: pm80xx: fix memory leak during rmmod
Date:   Mon, 6 Sep 2021 22:34:04 +0530
Message-ID: <20210906170404.5682-5-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210906170404.5682-1-Ajish.Koshy@microchip.com>
References: <20210906170404.5682-1-Ajish.Koshy@microchip.com>
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
Acked-by: Jack Wang <jinpu.wang@ionos.com>
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

