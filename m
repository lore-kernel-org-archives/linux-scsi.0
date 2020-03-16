Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70F5C1975A
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 07:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4D7520679
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 07:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgCPHkI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 03:40:08 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:52664 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729582AbgCPHkH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 03:40:07 -0400
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.21 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.21;
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
  client-ip=208.19.100.21; receiver=esa5.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dkim=none (message not signed) header.i=none; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: 380byJwVRkHbldx2nkFyOKsirtBGf0k0IXHIkhUA8fIO1gVDVoteB8UWLkY8xMMRczke5sEgY2
 2NAGDD9Y8mUgwoXXpi4H2oMjBSSSNfIv2+IbTQNxBKKXulNy7kSYGm0JMRQMkmC6lDBbkNAuY5
 l/SS+wr91ICZa8jjcW6KTnSgT6qFDY1pqoej1iX0mjDzDYabLi7D3lr4uQRQmLs7clLH1+qllH
 K5QUITetU0q85va3C8nHiX2Fei4djUYJLcxYEi82594c5hZApVWcnQSUE1K1o4bD87gHqCLB3U
 +BY=
X-IronPort-AV: E=Sophos;i="5.70,559,1574146800"; 
   d="scan'208";a="68990099"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.21])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2020 00:40:02 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX1.microsemi.net
 (10.100.34.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Mon, 16 Mar
 2020 00:40:00 -0700
Received: from localhost (10.41.130.51) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Mon, 16 Mar
 2020 00:40:00 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V3 4/6] pm80xx : Cleanup initialization loading fail path.
Date:   Mon, 16 Mar 2020 13:19:04 +0530
Message-ID: <20200316074906.9119-5-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20200316074906.9119-1-deepak.ukey@microchip.com>
References: <20200316074906.9119-1-deepak.ukey@microchip.com>
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
Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
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

