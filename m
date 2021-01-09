Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F9E4C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3557523A5B
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbhAIMaa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 07:30:30 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45867 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbhAIMaa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 07:30:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610195429; x=1641731429;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=crgptfdo4ZvB/eP/lKCiawEC/FxPXC3A+NiZk4ydCYw=;
  b=yfEEP0wcIfiaDv3PtygdHkEXtS+8NDy+seKm8L/1cq9EXjGZaJ984cYp
   xLOV8z6ys4DBpO66bQUEo4kcAcNDlGSk1AUqIXG6xTVgulIxlezzJTgnx
   7TVllunp4y/U4qaOT286E1WDwL38rDLQnA2j5Z/B1l1cueUdlBfYhumNF
   sVmu5CJRbWIvJ35vxmzKOsb7qseB+SnHVqFlUk/UlTsha2kwkWXn1TjXG
   0uIQ0NLDiOAgLI9owURUYIVC1yPuJCu+ayIbSuiMvF0pHb8etEOGRR6NN
   G8uMQuSq418Z3JcgbyD6z5HTC2rzOq5NQkTkslDmf4DBDFDxTze4emfnK
   A==;
IronPort-SDR: 2UKqalPbVB94ePdmiP4HMhX5o2W+t+gLhNEqdWhz73inT/zJlQF4mCd4610xRiOoPtTm7Fy6/M
 W9Z43pVIlW0+yxXSJpAKePTDW8DVsoI8wORXBxq/zN1Rx443wDOyO2ISApaSLKhHpT0OYSbhYf
 rbvezR6hk3lfBStBuBanSezupCA3NSUboGb4B4VqPAuiiH/4pEx5L1Q/o9hXve8618s8I1mNU+
 2rOwEWO2/pCw9zGBS8FIWOK8MO+IHcy5M5LGfFBsMixa8ty+ZXAXanmtvUSItwKGkNfALljlyq
 YLY=
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="105371470"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2021 05:29:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 9 Jan 2021 05:29:07 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 9 Jan 2021 05:29:06 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 7/8] pm80xx: Log SATA IOMB completion status on failure.
Date:   Sat, 9 Jan 2021 18:08:48 +0530
Message-ID: <20210109123849.17098-8-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20210109123849.17098-1-Viswas.G@microchip.com>
References: <20210109123849.17098-1-Viswas.G@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Vishakha Channapattan <vishakhavc@google.com>

Added a log message in sata completion path to log the status of failed
command. If the status does not match any expected status, another
message will be logged.

On IO failure with known status, log message will be

[ 1712.951735] pm80xx0:: mpi_sata_completion 2269: IO failed device_id
16385 status 0x1 tag XX

If the firmware returns unexpected status, log message of the following
format will be logged -

[ 1712.951735] pm80xx0:: mpi_sata_completion XXXX: Unknown status
device_id XXXXX status 0xX tag XX

Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
Signed-off-by: Ruksar Devadi <Ruksar.devadi@microchip.com>
Signed-off-by: Ashokkumar N <Ashokkumar.N@microchip.com>
Signed-off-by: Radha Ramachandran <radha@google.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index df679e36954a..e7fef42b4f6c 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2437,10 +2437,11 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		return;
 	}
 
-	if (unlikely(status))
-		pm8001_dbg(pm8001_ha, IOERR,
-			   "status:0x%x, tag:0x%x, task::0x%p\n",
-			   status, tag, t);
+	if (status != IO_SUCCESS) {
+		pm8001_dbg(pm8001_ha, FAIL,
+			"IO failed device_id %u status 0x%x tag %d\n",
+			pm8001_dev->device_id, status, tag);
+	}
 
 	/* Print sas address of IO failed device */
 	if ((status != IO_SUCCESS) && (status != IO_OVERFLOW) &&
@@ -2762,7 +2763,9 @@ mpi_sata_completion(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			atomic_dec(&pm8001_dev->running_req);
 		break;
 	default:
-		pm8001_dbg(pm8001_ha, DEVIO, "Unknown status 0x%x\n", status);
+		pm8001_dbg(pm8001_ha, DEVIO,
+				"Unknown status device_id %u status 0x%x tag %d\n",
+			pm8001_dev->device_id, status, tag);
 		/* not allowed case. Therefore, return failed status */
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DEV_NO_RESPONSE;
-- 
2.16.3

