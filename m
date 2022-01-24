Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DD3C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jan 2022 08:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242112AbiAXIUU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jan 2022 03:20:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:33443 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236174AbiAXIUU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2022 03:20:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643012420; x=1674548420;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6iT14iqSsRIfzUKkeOK6swVtrBQq6boCnpjEOywEPjU=;
  b=ofmYmhbJaBie1zQwrmKrCN1Yasqqu6IXtfPtGNjOtanYbksIMKWFnnAM
   9MjjpJTR4A48/DWPBM6dRTPZFp+vvzgKe+hRiLUDHFQ0GysXOsNJaAHK8
   c+T5vbqPQuubEsghxmy6z02ETxlccWlBqX0NxG1v/iluMVk+mgDjjtTtt
   7kZUljoUrSEYaMD8IOkVBRjFe+1EyICmAK2OZ5hLPqd71GcpQ7bCD8mPL
   Pkgj4sZFau5R1l5Hk2++kOzIT0eMNAdc7wsw+DjlTUhnLZpvDvIQbpKnz
   hMg/UbZvr+r9EROtyXQ8/vyTsWxDKe6Cqqe4xiGuFvHjaKJFAJLkEWTCb
   A==;
IronPort-SDR: MQZnwIFDQPpTbXK2lFE2cdfDTCGqIbFUqQ48JB5xOpGLl5VzJSBCqXIaWGcx2dZOEH5BNlQUle
 IaU77HgtroW5p0HErEklH3z8KlqAJjMsrKtWPytuKraC6M4BWPme91R3fCqLvBnGryua+NoB8g
 UuZD806smmb2GzovqcIWvwaDgLfC0HKs+sMgdQLgbr/iEb+7IIN1dGEVWNs3Q9WSHKAX8hkl3V
 nzkitOHIGdTmQGuuRz60WF81/l3an1ukOXfg2zTnHiwEF6QUEzU5GDMn0/jMJ/uQh2hRZVBsob
 SrHu80nSEoG5DgZFU4Aka1og
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="150638654"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jan 2022 01:20:19 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Mon, 24 Jan 2022 01:20:19 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Mon, 24 Jan 2022 01:20:18 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH] scsi: pm80xx: Fix double completion for SATA devices
Date:   Mon, 24 Jan 2022 13:52:55 +0530
Message-ID: <20220124082255.86223-1-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For SATA devices, correct the double
completion issue.

Current code handles completions for sata
devices in  mpi_sata_completion() and
mpi_sata_event().

But at the time when any sata event happens,
for almost all the event types, the command
is still in the target. It is wrong to
complete the task in sata_event().

There are some events for which we get
sata_completions, for some needs recovery
procedure and for others abort.

All the tasks must be completed via
sata_completion() path.

Have just removed the task done related code
from sata_events().
For tasks where we don't get completions,
let top layer call abort() to abort the
command post timeout.

Signed-off-by: Ajish Koshy <Ajish.Koshy@microchip.com>
Signed-off-by: Viswas G <Viswas.G@microchip.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 18 ------------------
 drivers/scsi/pm8001/pm80xx_hwi.c | 26 --------------------------
 2 files changed, 44 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index c814e5071712..9ec310b795c3 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -2692,7 +2692,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	u32 tag = le32_to_cpu(psataPayload->tag);
 	u32 port_id = le32_to_cpu(psataPayload->port_id);
 	u32 dev_id = le32_to_cpu(psataPayload->device_id);
-	unsigned long flags;
 
 	if (event)
 		pm8001_dbg(pm8001_ha, FAIL, "SATA EVENT 0x%x\n", event);
@@ -2724,8 +2723,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
-		if (pm8001_dev)
-			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
@@ -2767,7 +2764,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
 			return;
 		}
 		break;
@@ -2853,20 +2849,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		ts->stat = SAS_OPEN_TO;
 		break;
 	}
-	spin_lock_irqsave(&t->task_state_lock, flags);
-	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
-	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
-	t->task_state_flags |= SAS_TASK_STATE_DONE;
-	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_dbg(pm8001_ha, FAIL,
-			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
-			   t, event, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
-	}
 }
 
 /*See the comments for mpi_ssp_completion */
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 0849ecc913c7..1e573be04407 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -2821,7 +2821,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 	u32 tag = le32_to_cpu(psataPayload->tag);
 	u32 port_id = le32_to_cpu(psataPayload->port_id);
 	u32 dev_id = le32_to_cpu(psataPayload->device_id);
-	unsigned long flags;
 
 	if (event)
 		pm8001_dbg(pm8001_ha, FAIL, "SATA EVENT 0x%x\n", event);
@@ -2854,8 +2853,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 		ts->resp = SAS_TASK_COMPLETE;
 		ts->stat = SAS_DATA_OVERRUN;
 		ts->residual = 0;
-		if (pm8001_dev)
-			atomic_dec(&pm8001_dev->running_req);
 		break;
 	case IO_XFER_ERROR_BREAK:
 		pm8001_dbg(pm8001_ha, IO, "IO_XFER_ERROR_BREAK\n");
@@ -2904,11 +2901,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 				IO_OPEN_CNX_ERROR_IT_NEXUS_LOSS);
 			ts->resp = SAS_TASK_COMPLETE;
 			ts->stat = SAS_QUEUE_FULL;
-			spin_unlock_irqrestore(&circularQ->oq_lock,
-					circularQ->lock_flags);
-			pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
-			spin_lock_irqsave(&circularQ->oq_lock,
-					circularQ->lock_flags);
 			return;
 		}
 		break;
@@ -3008,24 +3000,6 @@ static void mpi_sata_event(struct pm8001_hba_info *pm8001_ha,
 		ts->stat = SAS_OPEN_TO;
 		break;
 	}
-	spin_lock_irqsave(&t->task_state_lock, flags);
-	t->task_state_flags &= ~SAS_TASK_STATE_PENDING;
-	t->task_state_flags &= ~SAS_TASK_AT_INITIATOR;
-	t->task_state_flags |= SAS_TASK_STATE_DONE;
-	if (unlikely((t->task_state_flags & SAS_TASK_STATE_ABORTED))) {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		pm8001_dbg(pm8001_ha, FAIL,
-			   "task 0x%p done with io_status 0x%x resp 0x%x stat 0x%x but aborted by upper layer!\n",
-			   t, event, ts->resp, ts->stat);
-		pm8001_ccb_task_free(pm8001_ha, t, ccb, tag);
-	} else {
-		spin_unlock_irqrestore(&t->task_state_lock, flags);
-		spin_unlock_irqrestore(&circularQ->oq_lock,
-				circularQ->lock_flags);
-		pm8001_ccb_task_free_done(pm8001_ha, t, ccb, tag);
-		spin_lock_irqsave(&circularQ->oq_lock,
-				circularQ->lock_flags);
-	}
 }
 
 /*See the comments for mpi_ssp_completion */
-- 
2.27.0

