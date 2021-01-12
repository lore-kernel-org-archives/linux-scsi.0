Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120ACC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD58723102
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730723AbhALLIR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:08:17 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45214 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbhALLIQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:08:16 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610449652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XXEAo24xIFlcxphDv6jXhANB4OxlDfox1c7cBXRbZ7M=;
        b=lYRsF0fYLrqPdrqrGa4TRd06gQ+AQEhdB14Rj34scF4s59YyIHbdSQ91rMkuED7NpSyxmb
        jqPjNvPpYbRHJ5CzqYxSXHBh/FIrW8KoBmtcHMA8H3lcPDRchk3j+z3o7WjkYFJMTwOtCN
        jsBGsiUoO7bAsNYEYQdj1yl94kkmzTAMNid7Y8o76Zlb89XnbanwuKJnFgYnnWnuhBOx4e
        1ZIrEZT/LvGw0p5zTnTXdvD7soQswbxzsgv5sZo/xduT/dqQH5I+1lJE5ey8hguuDwqsfu
        h5qnAUEl6ykDfuKSgOnFgQfO7NIBDl+fPuWoPeCGLO9YA0jyjHAmLH24mgr2yQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610449652;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XXEAo24xIFlcxphDv6jXhANB4OxlDfox1c7cBXRbZ7M=;
        b=cCtKJ88MWLqszdkynYjHZj4+9iKMLVveHy9mcjKGivcKHssvtiJBBcgQoHKH570jvoctgA
        yx1SCrTPuG5JNKCw==
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     linux-scsi@vger.kernel.org, intel-linux-scu@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH v2 09/19] scsi: pm80xx: Pass gfp_t flags to libsas event notifiers
Date:   Tue, 12 Jan 2021 12:06:37 +0100
Message-Id: <20210112110647.627783-10-a.darwish@linutronix.de>
In-Reply-To: <20210112110647.627783-1-a.darwish@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the new libsas event notifiers API, which requires callers to
explicitly pass the gfp_t memory allocation flags.

Call chain analysis, pm8001_hwi.c:

  pm8001_interrupt_handler_msix() || pm8001_interrupt_handler_intx() || pm8001_tasklet()
    -> PM8001_CHIP_DISP->isr() = pm80xx_chip_isr()
      -> process_oq [spin_lock_irqsave(&pm8001_ha->lock, ...)]
        -> process_one_iomb()
          -> mpi_hw_event()
            -> hw_event_sas_phy_up()
              -> pm8001_bytes_dmaed()
            -> hw_event_sata_phy_up
              -> pm8001_bytes_dmaed()

All functions are invoked by process_one_iomb(), which is invoked by the
interrupt service routine and the tasklet handler. A similar call chain
is also found at pm80xx_hwi.c. Pass GFP_ATOMIC.

For pm8001_sas.c, pm8001_phy_control() runs in task context as it calls
wait_for_completion() and msleep().  Pass GFP_KERNEL.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 38 ++++++++++++++++----------------
 drivers/scsi/pm8001/pm8001_sas.c |  9 ++++----
 drivers/scsi/pm8001/pm80xx_hwi.c | 30 ++++++++++++-------------
 3 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index dd15246d5b03..85b9a168794e 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3179,7 +3179,7 @@ void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)
 	pm8001_dbg(pm8001_ha, MSG, "phy %d byte dmaded.\n", i);
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
-	sas_notify_port_event(sas_phy, PORTE_BYTES_DMAED);
+	sas_notify_port_event_gfp(sas_phy, PORTE_BYTES_DMAED, GFP_ATOMIC);
 }
 
 /* Get the link rate speed  */
@@ -3336,7 +3336,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	else if (phy->identify.device_type != SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
 	phy->sas_phy.oob_mode = SAS_OOB_MODE;
-	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, &pPayload->sas_identify,
 		sizeof(struct sas_identify_frame)-4);
@@ -3379,7 +3379,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->phy_type |= PORT_TYPE_SATA;
 	phy->phy_attached = 1;
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
-	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
 		sizeof(struct dev_to_host_fis));
@@ -3726,11 +3726,11 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
-		sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
+		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_DOWN:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
-		sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
+		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 		phy->phy_attached = 0;
 		phy->phy_state = 0;
 		hw_event_phy_down(pm8001_ha, piomb);
@@ -3739,7 +3739,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	/* the broadcast change primitive received, tell the LIBSAS this event
 	to revalidate the sas domain*/
@@ -3750,20 +3750,20 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
+		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3772,7 +3772,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			HW_EVENT_LINK_ERR_INVALID_DWORD, port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_DISPARITY_ERROR:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3782,7 +3782,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_CODE_VIOLATION:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3792,7 +3792,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3802,7 +3802,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_MALFUNCTION:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_MALFUNCTION\n");
@@ -3812,7 +3812,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_INBOUND_CRC_ERROR\n");
@@ -3822,13 +3822,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		break;
 	case HW_EVENT_HARD_RESET_RECEIVED:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
-		sas_notify_port_event(sas_phy, PORTE_HARD_RESET);
+		sas_notify_port_event_gfp(sas_phy, PORTE_HARD_RESET, GFP_ATOMIC);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3838,20 +3838,20 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, MSG,
 			   "HW_EVENT_PORT_RECOVERY_TIMER_TMO\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RECOVER:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RECOVER\n");
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index e21c6cfff4cb..a183293064b0 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -207,16 +207,16 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			if (pm8001_ha->phy[phy_id].phy_state ==
 				PHY_STATE_LINK_UP_SPCV) {
 				sas_phy_disconnected(&phy->sas_phy);
-				sas_notify_phy_event(&phy->sas_phy,
-					PHYE_LOSS_OF_SIGNAL);
+				sas_notify_phy_event_gfp(&phy->sas_phy,
+					PHYE_LOSS_OF_SIGNAL, GFP_KERNEL);
 				phy->phy_attached = 0;
 			}
 		} else {
 			if (pm8001_ha->phy[phy_id].phy_state ==
 				PHY_STATE_LINK_UP_SPC) {
 				sas_phy_disconnected(&phy->sas_phy);
-				sas_notify_phy_event(&phy->sas_phy,
-					PHYE_LOSS_OF_SIGNAL);
+				sas_notify_phy_event_gfp(&phy->sas_phy,
+					PHYE_LOSS_OF_SIGNAL, GFP_KERNEL);
 				phy->phy_attached = 0;
 			}
 		}
@@ -1341,4 +1341,3 @@ int pm8001_clear_task_set(struct domain_device *dev, u8 *lun)
 	tmf_task.tmf = TMF_CLEAR_TASK_SET;
 	return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
 }
-
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index f617177b7bb3..f849756e6ceb 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3287,7 +3287,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	else if (phy->identify.device_type != SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
 	phy->sas_phy.oob_mode = SAS_OOB_MODE;
-	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, &pPayload->sas_identify,
 		sizeof(struct sas_identify_frame)-4);
@@ -3334,7 +3334,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->phy_type |= PORT_TYPE_SATA;
 	phy->phy_attached = 1;
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
-	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
 		sizeof(struct dev_to_host_fis));
@@ -3417,7 +3417,7 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 	}
 	if (port_sata && (portstate != PORT_IN_RESET))
-		sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
+		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 }
 
 static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
@@ -3515,7 +3515,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
-		sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
+		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_DOWN:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
@@ -3531,7 +3531,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	/* the broadcast change primitive received, tell the LIBSAS this event
 	to revalidate the sas domain*/
@@ -3542,20 +3542,20 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
+		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3592,7 +3592,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_INBOUND_CRC_ERROR\n");
@@ -3602,13 +3602,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_HARD_RESET_RECEIVED:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
-		sas_notify_port_event(sas_phy, PORTE_HARD_RESET);
+		sas_notify_port_event_gfp(sas_phy, PORTE_HARD_RESET, GFP_ATOMIC);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3618,7 +3618,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
@@ -3626,7 +3626,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		if (pm8001_ha->phy[phy_id].reset_completion) {
 			pm8001_ha->phy[phy_id].port_reset_status =
 					PORT_RESET_TMO;
@@ -3643,8 +3643,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
 			if (port->wide_port_phymap & (1 << i)) {
 				phy = &pm8001_ha->phy[i];
-				sas_notify_phy_event(&phy->sas_phy,
-						PHYE_LOSS_OF_SIGNAL);
+				sas_notify_phy_event_gfp(&phy->sas_phy,
+						PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 				port->wide_port_phymap &= ~(1 << i);
 			}
 		}
-- 
2.30.0

