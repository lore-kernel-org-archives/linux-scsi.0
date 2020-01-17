Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 419A1C33CB1
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2000A2073A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 07:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgAQHKg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 02:10:36 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:10557 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgAQHKg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jan 2020 02:10:36 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  viswas.g@microsemi.com designates 208.19.100.23 as permitted
  sender) identity=mailfrom; client-ip=208.19.100.23;
  receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="viswas.g@microsemi.com"; x-conformance=spf_only;
  x-record-type="v=spf1"; x-record-text="v=spf1
  ip4:208.19.100.20 ip4:208.19.100.21 ip4:208.19.100.22
  ip4:208.19.100.23 ip4:208.19.99.221 ip4:208.19.99.222
  ip4:208.19.99.223 ip4:208.19.99.225 -all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@smtp.microsemi.com) identity=helo;
  client-ip=208.19.100.23; receiver=esa4.microchip.iphmx.com;
  envelope-from="viswas.g@microsemi.com";
  x-sender="postmaster@smtp.microsemi.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=viswas.g@microsemi.com; spf=None smtp.helo=postmaster@smtp.microsemi.com; dmarc=fail (p=none dis=none) d=microchip.com
IronPort-SDR: GK3P47qJoimE2fZlj+Himu7OIrgOhDXkO3jGpD4Hyi87Ct6D0/bmpZvMukjRcDzEiafmZyKfD2
 tkhI/+CY8hh6HEhr+hLOGRWq0Coez1N6c2TxrnlNCMz7WQ6dj1awSYeetZTAgV+4PEy8CkvtWc
 ADGLijz1cMD5NsVEpu9bfu7jQJHozfNgRUKbsdvv4Ip1KVypM05HCKGBCi+nxoHMvFjoCbDrkx
 Wg9rfiE8owvttVs3nGC5wm2G1Mbgp3r3x1fpXbaofKbq8Y2j4VHwL6gZbEYx7d5nEDtng+2teT
 tM4=
X-IronPort-AV: E=Sophos;i="5.70,329,1574146800"; 
   d="scan'208";a="61358146"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Jan 2020 00:10:36 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1847.3; Thu, 16 Jan
 2020 23:10:35 -0800
Received: from localhost (10.41.130.51) by avmbx2.microsemi.net (10.100.34.32)
 with Microsoft SMTP Server id 15.1.1847.3 via Frontend Transport; Thu, 16 Jan
 2020 23:10:34 -0800
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V2 04/13] pm80xx : Cleanup initialization loading fail path.
Date:   Fri, 17 Jan 2020 12:49:14 +0530
Message-ID: <20200117071923.7445-5-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
In-Reply-To: <20200117071923.7445-1-deepak.ukey@microchip.com>
References: <20200117071923.7445-1-deepak.ukey@microchip.com>
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

