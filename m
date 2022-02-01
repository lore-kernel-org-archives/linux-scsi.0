Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EB3FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:48:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbiBAVso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:48:44 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:31008 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235300AbiBAVso (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:48:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752124; x=1675288124;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=55GNMhVo0eq8tWzrWM4uU9abRD43u7HxSrKCAQWIO74=;
  b=IoXu9qZxcz7/GuBz5KF94+BvLEmtq28p2kW3Foguy7HU2hNzDLXiHgGW
   BP/j0Ws8TZX7tx5ZqG2hO0Cr7a6t9aiOuGmBwd73wGaXTd0/7rirW4EN7
   fZFZwH4wtk8DFirNlyrHCHq5RXrmQnyMrknyaRSMLXH/rlv+FtBE8bTDJ
   h9BnpGFAegQ7bBR64i20dJfRD6bcNdsvwYU4Wk42EgN71Op8raoWHHgT6
   Fq8bMNBpV+8N3aX7nMHDMGp3xmdE8QhluRWFzNRWPGqF09B1GKuQc6AS+
   RGbbIu/HQXPFoI1XPn7Nr8g/Z78WdZHS67/ZhtigT/wP017OEsMPpggQ5
   w==;
IronPort-SDR: 322xLewW2QjTHhLVpITwcdd/lLJWoFhrEBLeFackYE6pd04t66xGFrR4uueedvd4WY9qRa/7IN
 bCEAsh2wp/06/5DeQeYjz46RUFHFZSozy03EPmiuvkmrXmzlnaxauiDchx5LmoZAQYpeIU06Sw
 xb8TLOfjva/fsyCjWfXJYuO2AtdxJC19FUnOCe/lWue0YXmUI2l6bLuMbZ+v7OBUolIc569AgP
 n9RvJa2loS5yg5NpQI+vclEkGnOguGLPtTnMiDgdbsEgDePORXBu0wROkY6S0LUFgmPD+dfTxq
 DI4iFVHgERZz6ZMrU7RWaqyh
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="151639105"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:48:44 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:48:43 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:48:43 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id 655A970236E;
        Tue,  1 Feb 2022 15:48:43 -0600 (CST)
Subject: [PATCH 11/18] smartpqi: fix kdump issue when ctrl is locked up
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:48:43 -0600
Message-ID: <164375212337.440833.11955356190354940369.stgit@brunhilda.pdev.net>
In-Reply-To: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
References: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>

Avoid dropping into shell if the controller is in locked up state.

Driver issues SIS soft reset to bring back the controller to SIS mode
while OS boots into kdump mode.

If the controller is in lockup state, SIS soft reset does not work.

Since the controller lockup code has not been cleared, driver considers
the firmware is no longer up and running. Driver returns back an error
code to OS and the kdump fails.

Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Scott Teel <scott.teel@microchip.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microchip.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |   39 +++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index de53180fab9c..8bd4de6306db 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7986,6 +7986,21 @@ static int pqi_force_sis_mode(struct pqi_ctrl_info *ctrl_info)
 	return pqi_revert_to_sis_mode(ctrl_info);
 }
 
+static void pqi_perform_lockup_action(void)
+{
+	switch (pqi_lockup_action) {
+	case PANIC:
+		panic("FATAL: Smart Family Controller lockup detected");
+		break;
+	case REBOOT:
+		emergency_restart();
+		break;
+	case NONE:
+	default:
+		break;
+	}
+}
+
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
@@ -8010,8 +8025,15 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	 * commands.
 	 */
 	rc = sis_wait_for_ctrl_ready(ctrl_info);
-	if (rc)
+	if (rc) {
+		if (reset_devices) {
+			dev_err(&ctrl_info->pci_dev->dev,
+				"kdump init failed with error %d\n", rc);
+			pqi_lockup_action = REBOOT;
+			pqi_perform_lockup_action();
+		}
 		return rc;
+	}
 
 	/*
 	 * Get the controller properties.  This allows us to determine
@@ -8736,21 +8758,6 @@ static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info, unsigned int de
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 
-static void pqi_perform_lockup_action(void)
-{
-	switch (pqi_lockup_action) {
-	case PANIC:
-		panic("FATAL: Smart Family Controller lockup detected");
-		break;
-	case REBOOT:
-		emergency_restart();
-		break;
-	case NONE:
-	default:
-		break;
-	}
-}
-
 static struct pqi_raid_error_info pqi_ctrl_offline_raid_error_info = {
 	.data_out_result = PQI_DATA_IN_OUT_HARDWARE_ERROR,
 	.status = SAM_STAT_CHECK_CONDITION,


