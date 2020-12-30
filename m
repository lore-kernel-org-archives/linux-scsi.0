Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38708C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CB03207B6
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Dec 2020 04:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgL3Etw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Dec 2020 23:49:52 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:39095 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgL3Etw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Dec 2020 23:49:52 -0500
IronPort-SDR: rJWQLLV+0JTbI2mk9p9/3anWESmbdsZB/XmF0q+6a3NZOgVctQRRMVT/1aThA8Vp4q73UBc0hO
 vRIUSldh3AKZVa4kBjPXmYw1rysBeKTLL0EJMMlF9jozOykGHcmLIKmnjNCeojUdHoybhZasys
 WAUlzHAoH9f0UqfQtHB2ASIownWTRbU6SAaHiLMMhI9Ft7jLa62ikgHuEddR6P9rPHcDvIocif
 C4/oJ/mfiX3D//jiisqNEGZaKSgcd/KnQSS1SWUXnXD/HB4/sD92XGpU4xI1KrLYHb4fL8phN3
 YqM=
X-IronPort-AV: E=Sophos;i="5.78,460,1599548400"; 
   d="scan'208";a="101338725"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Dec 2020 21:47:59 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 29 Dec 2020 21:47:59 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 29 Dec 2020 21:47:59 -0700
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 7/8] pm80xx: Log SATA IOMB completion status on failure.
Date:   Wed, 30 Dec 2020 10:27:42 +0530
Message-ID: <20201230045743.14694-8-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
In-Reply-To: <20201230045743.14694-1-Viswas.G@microchip.com.com>
References: <20201230045743.14694-1-Viswas.G@microchip.com.com>
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

