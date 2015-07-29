From: <Viswas.G@pmcs.com>
Subject: [PATCH 7/8] pm80xx: Handling Invalid SSP Response frame
Date: Wed, 29 Jul 2015 11:57:19 +0530
Message-ID: <1438151240-4097-8-git-send-email-Viswas.G@pmcs.com>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:35412 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752439AbbG2G0g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2015 02:26:36 -0400
In-Reply-To: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

From: Viswas G <Viswas.G@pmcs.com>

The request has to be retried incase if the length of the SSP
Response IU is invalid.

Signed-off-by: Viswas G <Viswas.G@pmcs.com>
Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com> 
---
 drivers/scsi/pm8001/pm80xx_hwi.c |    7 +++++++
 drivers/scsi/pm8001/pm80xx_hwi.h |    2 +-
 2 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 8817ce6..0e1628f 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -1609,6 +1609,13 @@ mpi_ssp_completion(struct pm8001_hba_info *pm8001_ha , void *piomb)
 		ts->stat = SAS_OPEN_REJECT;
 		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
 		break;
+	case IO_XFER_ERROR_INVALID_SSP_RSP_FRAME:
+		PM8001_IO_DBG(pm8001_ha,
+			pm8001_printk("IO_XFER_ERROR_INVALID_SSP_RSP_FRAME\n"));
+		ts->resp = SAS_TASK_COMPLETE;
+		ts->stat = SAS_OPEN_REJECT;
+		ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		break;
 	case IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED:
 		PM8001_IO_DBG(pm8001_ha,
 		pm8001_printk("IO_OPEN_CNX_ERROR_PROTOCOL_NOT_SUPPORTED\n"));
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index a083cc6..7a443ba 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -1175,7 +1175,7 @@ typedef struct SASProtocolTimerConfig SASProtocolTimerConfig_t;
 #define IO_XFER_ERROR_INTERNAL_CRC_ERROR	0x54
 #define MPI_IO_RQE_BUSY_FULL			0x55
 #define IO_XFER_ERR_EOB_DATA_OVERRUN		0x56
-#define IO_XFR_ERROR_INVALID_SSP_RSP_FRAME	0x57
+#define IO_XFER_ERROR_INVALID_SSP_RSP_FRAME	0x57
 #define IO_OPEN_CNX_ERROR_OPEN_PREEMPTED	0x58
 
 #define MPI_ERR_IO_RESOURCE_UNAVAILABLE		0x1004
-- 
1.7.1

