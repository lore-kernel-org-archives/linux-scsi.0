Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7610CC432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C4CE206DC
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 10:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfKNKIz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 05:08:55 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:37022 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfKNKIy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 05:08:54 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa5.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa5.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: /SCl1I6eDTAaiFPcO5wLq0hgOtsK5r3RhQe9/6BvPg/4mrcdwPI344hvQiPczjShJATwl0Z0iE
 Vu21AuztUO5ksXq/lHte8o+SrwFOp5L5x0kv12XqxNkMgnvKACqC/pxGQ/PWcM0HrkizT0zEUR
 2uv1QHCVjI9KBQVKT5HH4ZG9A0oEAUR8BkBv/n9ZHiyl/adKtYIUsgoOnxwJ/6HR+SNStsKQei
 epsl2Pfh2r4FViV76Je68skbTAjp8fOvF8jZUQTdAe3Ir32SfgvSwJ6I3MM8nAnmPmyJwXzASX
 HwM=
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="55582507"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Nov 2019 03:08:54 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 14 Nov
 2019 02:08:53 -0800
Received: from localhost (10.41.130.49) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 14 Nov
 2019 02:08:52 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <jsperbeck@google.com>, <auradkar@google.com>,
        <ianyar@google.com>
Subject: [PATCH V2 12/13] pm80xx : Tie the interrupt name to the module instance.
Date:   Thu, 14 Nov 2019 15:39:09 +0530
Message-ID: <20191114100910.6153-13-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191114100910.6153-1-deepak.ukey@microchip.com>
References: <20191114100910.6153-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vikram Auradkar <auradkar@google.com>

With msix enabled, the interrupt instances are <prefix><index> where
the prefix is fixed for all module instances, making it a little
harder to track down what's what.

Signed-off-by: Vikram Auradkar <auradkar@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 11 ++++++-----
 drivers/scsi/pm8001/pm8001_sas.h  |  2 ++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 86b619d10392..485f0afc53f9 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -894,7 +894,6 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 	u32 number_of_intr;
 	int flag = 0;
 	int rc;
-	static char intr_drvname[PM8001_MAX_MSIX_VEC][sizeof(DRV_NAME)+3];
 
 	/* SPCv controllers supports 64 msi-x */
 	if (pm8001_ha->chip_id == chip_8001) {
@@ -915,14 +914,16 @@ static u32 pm8001_setup_msix(struct pm8001_hba_info *pm8001_ha)
 				rc, pm8001_ha->number_of_intr));
 
 	for (i = 0; i < number_of_intr; i++) {
-		snprintf(intr_drvname[i], sizeof(intr_drvname[0]),
-				DRV_NAME"%d", i);
+		snprintf(pm8001_ha->intr_drvname[i],
+			sizeof(pm8001_ha->intr_drvname[0]),
+			"%s-%d", pm8001_ha->name, i);
 		pm8001_ha->irq_vector[i].irq_id = i;
 		pm8001_ha->irq_vector[i].drv_inst = pm8001_ha;
 
 		rc = request_irq(pci_irq_vector(pm8001_ha->pdev, i),
 			pm8001_interrupt_handler_msix, flag,
-			intr_drvname[i], &(pm8001_ha->irq_vector[i]));
+			pm8001_ha->intr_drvname[i],
+			&(pm8001_ha->irq_vector[i]));
 		if (rc) {
 			for (j = 0; j < i; j++) {
 				free_irq(pci_irq_vector(pm8001_ha->pdev, i),
@@ -963,7 +964,7 @@ static u32 pm8001_request_irq(struct pm8001_hba_info *pm8001_ha)
 	pm8001_ha->irq_vector[0].irq_id = 0;
 	pm8001_ha->irq_vector[0].drv_inst = pm8001_ha;
 	rc = request_irq(pdev->irq, pm8001_interrupt_handler_intx, IRQF_SHARED,
-		DRV_NAME, SHOST_TO_SAS_HA(pm8001_ha->shost));
+		pm8001_ha->name, SHOST_TO_SAS_HA(pm8001_ha->shost));
 	return rc;
 }
 
diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
index f7be7b85624e..a55b03bca529 100644
--- a/drivers/scsi/pm8001/pm8001_sas.h
+++ b/drivers/scsi/pm8001/pm8001_sas.h
@@ -541,6 +541,8 @@ struct pm8001_hba_info {
 	struct pm8001_ccb_info	*ccb_info;
 #ifdef PM8001_USE_MSIX
 	int			number_of_intr;/*will be used in remove()*/
+	char			intr_drvname[PM8001_MAX_MSIX_VEC]
+				[PM8001_NAME_LENGTH+1+3+1];
 #endif
 #ifdef PM8001_USE_TASKLET
 	struct tasklet_struct	tasklet[PM8001_MAX_MSIX_VEC];
-- 
2.16.3

