From: <Viswas.G@pmcs.com>
Subject: [PATCH 5/8] pm80xx: Remove unnecessary phy disconnect while link error
Date: Wed, 29 Jul 2015 11:57:17 +0530
Message-ID: <1438151240-4097-6-git-send-email-Viswas.G@pmcs.com>
References: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:43901 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280AbbG2G0Y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2015 02:26:24 -0400
In-Reply-To: <1438151240-4097-1-git-send-email-Viswas.G@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: xjtuwjp@gmail.com, JBottomley@parallels.com, Tomas Henzl <thenzl@redhat.com>, Suresh.Thiagarajan@pmcs.com, Viswas.G@pmcs.com

From: Viswas G <Viswas.G@pmcs.com>

If the link error happens, we don't need to disconnect the phy,
which will remove the drive. Instead acknowledging the controller
and logging the error will be enough.

Signed-off-by: Viswas G <Viswas.G@pmcs.com>
Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com> 
---
 drivers/scsi/pm8001/pm80xx_hwi.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index dced9f7..3d8b4ae 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3176,9 +3176,6 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("HW_EVENT_LINK_ERR_INVALID_DWORD\n"));
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_INVALID_DWORD, port_id, phy_id, 0, 0);
-		sas_phy_disconnected(sas_phy);
-		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_DISPARITY_ERROR:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3186,9 +3183,6 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_DISPARITY_ERROR,
 			port_id, phy_id, 0, 0);
-		sas_phy_disconnected(sas_phy);
-		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_CODE_VIOLATION:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3196,9 +3190,6 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_CODE_VIOLATION,
 			port_id, phy_id, 0, 0);
-		sas_phy_disconnected(sas_phy);
-		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH:
 		PM8001_MSG_DBG(pm8001_ha, pm8001_printk(
@@ -3206,9 +3197,6 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm80xx_hw_event_ack_req(pm8001_ha, 0,
 			HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH,
 			port_id, phy_id, 0, 0);
-		sas_phy_disconnected(sas_phy);
-		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
 		break;
 	case HW_EVENT_MALFUNCTION:
 		PM8001_MSG_DBG(pm8001_ha,
-- 
1.7.1

