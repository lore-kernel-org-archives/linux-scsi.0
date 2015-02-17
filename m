From: Viswas G <Viswas.G@microsemi.com>
Subject: [PATCH V2 8/9] pm80xx : panic on ncq error cleaning up the read log.
Date: Wed, 18 Feb 2015 05:06:49 +0530
Message-ID: <20150217233650.9091-9-Viswas.G@microsemi.com>
References: <20150217233650.9091-1-Viswas.G@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03hn0249.outbound.protection.outlook.com ([104.47.41.249]:1609
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752251AbdIMKmV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Sep 2017 06:42:21 -0400
In-Reply-To: <20150217233650.9091-1-Viswas.G@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasanthalakshmi.Tharmarajan@microsemi.com, Viswas.G@microsemi.com, deepak.ukey@microsemi.com, Raj.Dinesh@microsemi.com, jinpu.wang@profitbricks.com, martin.petersen@oracle.com

when there's an error in 'ncq mode' the host has to read the ncq
error log (10h) to clear the error state. however, the ccb that
is setup for doing this doesn't setup the ccb so that the
previous state is cleared. if the ccb was previously used for an IO
n_elems is set and pm8001_ccb_task_free() treats this as the signal
to go free a scatter-gather list (that's already been free-ed).

Signed-off-by: Deepak Ukey <deepak.ukey@microsemi.com>
Signed-off-by: Viswas G <Viswas.G@microsemi.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 92d2045dea68..f2c0839afbe3 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1489,6 +1489,7 @@ static void pm80xx_send_read_log(struct pm8001_hba_info *pm8001_ha,
 	ccb->device = pm8001_ha_dev;
 	ccb->ccb_tag = ccb_tag;
 	ccb->task = task;
+	ccb->n_elem = 0;
 	pm8001_ha_dev->id |= NCQ_READ_LOG_FLAG;
 	pm8001_ha_dev->id |= NCQ_2ND_RLE_FLAG;
 
-- 
2.12.3
