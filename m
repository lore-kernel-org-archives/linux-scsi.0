Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BFB3C433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 12:00:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32EDB6112F
	for <linux-scsi@archiver.kernel.org>; Wed,  5 May 2021 12:00:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhEEMBf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 May 2021 08:01:35 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:50367 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbhEEMBe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 May 2021 08:01:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1620216038; x=1651752038;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=o//i9qrqbW2h/C1D6QFZ1ZmtHwKDnE1/uVsFOvmc3IU=;
  b=VHaJZCy0p3usLGP6u2T688Wh0Sm4wtfZ1WC2vARN9Xp+H6Fj+w4lriMy
   rLU+P80W2lEo9L8PQ0yKk/jPLhBlUuecOhkkDeTgIJmuSmAjOgugojZ+e
   /6qKe6BEiSaWY1LeFGNfimVt2siim6ByI6anve2qfvDSswKoOGYoKSYaO
   bGFLFxK1rbdkMKR/fHHNfAK1z8pg1pZRL3p5iZE5c/1kYUgmsY8k2QW3Z
   mA+dBpJPchCevRtnS/zkXZKGucyc+Sk93QdfYu0c2CcZatuGBvNp1LlVt
   KH3Ghzjup5E0s/RM1h0DQSf0cW00hmleus2+ds2AY/sPl7Mg1mmTj6Hfe
   A==;
IronPort-SDR: 6FcKfQSergi4ucUsLEYydEne+MAyio0XpJ3itm5Q5g9W0icFlKKzEyD+PGY9OJNlZtYA9ULFhV
 pXSuioHTrDiXr3bzdkdqGkhCTxaL1CALLychxqvV3/y/WOsePR8NA5IFBVAlsDKze8kvFnnRfd
 243PZiQgele7kbPeaA8+5MiaWo4ZH2s2ZtRGmcbdpcW52Z+gpQZjY+TvQRP4FwdLbPPUQLLbQx
 PWx3QUQ+YdJOGOE+qtMIql440DcqoFHO8ea2XwYIFTixVizkU+NqCRAFFTfS8csb0ryqwjp55N
 6dI=
X-IronPort-AV: E=Sophos;i="5.82,274,1613458800"; 
   d="scan'208";a="119019705"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 May 2021 05:00:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 5 May 2021 05:00:36 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 5 May 2021 05:00:36 -0700
From:   <ajish.koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 1/1] pm80xx: fix drive missing during rmmod & insmod in loop.
Date:   Wed, 5 May 2021 17:31:03 +0530
Message-ID: <20210505120103.24497-1-ajish.koshy@microchip.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Ajish Koshy <ajish.koshy@microchip.com>

Most of the time when driver is loaded after rmmod, during drive
discovery few drives are not showing up in lsscsi command. Here
sata drives are directly attached to the controller connected phys.
During device discovery, following identify command (qc timeout
(cmd 0xec)) is getting timedout during revalidation. This will trigger
abort from host side and controller successfully aborts the command
and returns success. Post this successful abort response ATA library
decides to mark the disk as NODEV.

To overcome this, inside pm8001_scan_start() after phy_start() call, added
get start response and wait for few milliseconds to trigger next phy start.
This few millisecond delay will give sufficient time for the controller
state machine to accept next phy start.

Signed-off-by: Ajish Koshy <ajish.koshy@microchip.com>
Signed-off-by: Viswas G <viswas.g@microchip.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c  | 10 ++++++----
 drivers/scsi/pm8001/pm8001_init.c |  2 +-
 drivers/scsi/pm8001/pm8001_sas.c  |  7 ++++++-
 drivers/scsi/pm8001/pm80xx_hwi.c  | 12 ++++++------
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index ecd06d2d7e81..71aa6af08340 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3765,11 +3765,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case HW_EVENT_PHY_START_STATUS:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_START_STATUS status = %x\n",
 			   status);
-		if (status == 0) {
+		if (status == 0)
 			phy->phy_state = 1;
-			if (pm8001_ha->flags == PM8001F_RUN_TIME &&
-					phy->enable_completion != NULL)
-				complete(phy->enable_completion);
+
+		if (pm8001_ha->flags == PM8001F_RUN_TIME &&
+				phy->enable_completion != NULL) {
+			complete(phy->enable_completion);
+			phy->enable_completion = NULL;
 		}
 		break;
 	case HW_EVENT_SAS_PHY_UP:
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 390c33df0357..af09bd282cb9 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1151,8 +1151,8 @@ static int pm8001_pci_probe(struct pci_dev *pdev,
 		goto err_out_shost;
 	}
 	list_add_tail(&pm8001_ha->list, &hba_list);
-	scsi_scan_host(pm8001_ha->shost);
 	pm8001_ha->flags = PM8001F_RUN_TIME;
+	scsi_scan_host(pm8001_ha->shost);
 	return 0;
 
 err_out_shost:
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index d28af413b93a..335cf37e6cb9 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -264,12 +264,17 @@ void pm8001_scan_start(struct Scsi_Host *shost)
 	int i;
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
+	DECLARE_COMPLETION_ONSTACK(completion);
 	pm8001_ha = sha->lldd_ha;
 	/* SAS_RE_INITIALIZATION not available in SPCv/ve */
 	if (pm8001_ha->chip_id == chip_8001)
 		PM8001_CHIP_DISP->sas_re_init_req(pm8001_ha);
-	for (i = 0; i < pm8001_ha->chip->n_phy; ++i)
+	for (i = 0; i < pm8001_ha->chip->n_phy; ++i) {
+		pm8001_ha->phy[i].enable_completion = &completion;
 		PM8001_CHIP_DISP->phy_start_req(pm8001_ha, i);
+		wait_for_completion(&completion);
+		msleep(300);
+	}
 }
 
 int pm8001_scan_finished(struct Scsi_Host *shost, unsigned long time)
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 4e980830f9f5..700530e969ac 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3487,13 +3487,13 @@ static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	pm8001_dbg(pm8001_ha, INIT,
 		   "phy start resp status:0x%x, phyid:0x%x\n",
 		   status, phy_id);
-	if (status == 0) {
+	if (status == 0)
 		phy->phy_state = PHY_LINK_DOWN;
-		if (pm8001_ha->flags == PM8001F_RUN_TIME &&
-				phy->enable_completion != NULL) {
-			complete(phy->enable_completion);
-			phy->enable_completion = NULL;
-		}
+
+	if (pm8001_ha->flags == PM8001F_RUN_TIME &&
+			phy->enable_completion != NULL) {
+		complete(phy->enable_completion);
+		phy->enable_completion = NULL;
 	}
 	return 0;
 
-- 
2.17.1

