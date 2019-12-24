Return-Path: <SRS0=FF7y=2O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F08CC2D0D0
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D712206CB
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Dec 2019 04:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfLXElX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Dec 2019 23:41:23 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:4204 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfLXElX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Dec 2019 23:41:23 -0500
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa3.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: dNG9L+sZXS0wF4dxCjFD4OchB1nOHylQ5sjT/UkH9IudXpNFng90lVVIVXaWI4jTkFI9T1dqNf
 jn66v20MiaBtVEwKkXzBNRbFmBbzaVE29mvzo4M23BwfY20fysfuIvLJ/b9lHNpNta/sY7KiBv
 aBV0DZeoIWQuinqJzClnpkt5vfCZmN9I6M7cew+lcjaaHUJChGuRyF1y4s+48vffseSSuYVaan
 nctAap8uY6ZNCVR1OKgcAegLzUOUZsTq4gRoAfMGSuCYp0A11w3XsI1qOkGRjsf7hg8ua51RjI
 lo8=
X-IronPort-AV: E=Sophos;i="5.69,350,1571727600"; 
   d="scan'208";a="61418506"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Dec 2019 21:41:01 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Mon, 23 Dec
 2019 20:41:00 -0800
Received: from localhost (10.41.130.49) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Mon, 23 Dec
 2019 20:41:00 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH 04/12] pm80xx : Cleanup initialization loading fail path.
Date:   Tue, 24 Dec 2019 10:11:35 +0530
Message-ID: <20191224044143.8178-5-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20191224044143.8178-1-deepak.ukey@microchip.com>
References: <20191224044143.8178-1-deepak.ukey@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peter Chang <dpf@google.com>

1)Move the instance tracking down after we think the instance is
good to go. avoids having a use-after free.
2)There are goto targets for trying to cleanup if the hw fails to
initialize, but there's some overlap depending on who thinks they
own the sub-structures.

Signed-off-by: Peter Chang <dpf@google.com>
Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Signed-off-by: Akshat Jain <akshatzen@google.com>
Signed-off-by: Yu Zheng <yuuzheng@google.com>
---
 drivers/scsi/pm8001/pm8001_init.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index a002eb5a3fe4..775517f9b39d 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1016,6 +1016,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 	struct pm8001_hba_info *pm8001_ha;
 	struct Scsi_Host *shost = NULL;
 	const struct pm8001_chip_info *chip;
+	struct sas_ha_struct *sha;
 
 	dev_printk(KERN_INFO, &pdev->dev,
 		"pm80xx: driver version %s\n", DRV_VERSION);
@@ -1044,12 +1045,12 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		goto err_out_regions;
 	}
 	chip = &pm8001_chips[ent->driver_data];
-	SHOST_TO_SAS_HA(shost) =
-		kzalloc(sizeof(struct sas_ha_struct), GFP_KERNEL);
-	if (!SHOST_TO_SAS_HA(shost)) {
+	sha = kzalloc(sizeof(struct sas_ha_struct), GFP_KERNEL);
+	if (!sha) {
 		rc = -ENOMEM;
 		goto err_out_free_host;
 	}
+	SHOST_TO_SAS_HA(shost) = sha;
 
 	rc = pm8001_prep_sas_ha_init(shost, chip);
 	if (rc) {
@@ -1070,7 +1071,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 			"pm8001_setup_irq failed [ret: %d]\n", rc));
 		goto err_out_shost;
 	}
-	list_add_tail(&pm8001_ha->list, &hba_list);
+
 	PM8001_CHIP_DISP->chip_soft_rst(pm8001_ha);
 	rc = PM8001_CHIP_DISP->chip_init(pm8001_ha);
 	if (rc) {
@@ -1105,8 +1106,12 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 
 	pm8001_post_sas_ha_init(shost, chip);
 	rc = sas_register_ha(SHOST_TO_SAS_HA(shost));
-	if (rc)
+	if (rc) {
+		PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
+			"sas_register_ha failed [ret: %d]\n", rc));
 		goto err_out_shost;
+	}
+	list_add_tail(&pm8001_ha->list, &hba_list);
 	scsi_scan_host(pm8001_ha->shost);
 	pm8001_ha->flags = PM8001F_RUN_TIME;
 	return 0;
@@ -1116,7 +1121,7 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 err_out_ha_free:
 	pm8001_free(pm8001_ha);
 err_out_free:
-	kfree(SHOST_TO_SAS_HA(shost));
+	kfree(sha);
 err_out_free_host:
 	scsi_host_put(shost);
 err_out_regions:
-- 
2.16.3

