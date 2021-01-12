Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C2B4C4332D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:08:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 354912310D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:08:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732439AbhALLIp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:08:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731569AbhALLIo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:08:44 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEA5C06179F;
        Tue, 12 Jan 2021 03:08:03 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610449682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q1vmJ9sjghxiU3Rhan/JlbacZBt1Libkv+i2Mx4BgVQ=;
        b=o/x2YXYCaQEd11h93be3BqJrcpFK6yc17oK9m/jvUnCxrSNYgtmbAyIfaBuhe6Fk495rpR
        ZgXbh+x3BS1sJKQB+RrPICkgsD8SDH3vHlterHahEw15YPGx0dO0N1c2h3DYJOTOy1t4q+
        lv13PJ7x9rBjYtVxHoNWwyYhlzdTgwgjjQhAij6/pcH188018Agi0Ekt2gL0JT6pYIr6ut
        aN+L/K4+vFo0TLLawpiB7q2MzmWUJI+9xXG2egvPdt1B3DBvgfFbtgb8IQFiRSZ+SWDd/A
        zG7LAuT15sv5xDK0gCotJpaoMFUxTCKh7ZcpjFcXSLeQVk0MOo9nJp+j5uFnVQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610449682;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q1vmJ9sjghxiU3Rhan/JlbacZBt1Libkv+i2Mx4BgVQ=;
        b=gwbOE0uUQjiUpAOwt/NFxepaZFuVe4+Q346FLvJmBm5E7RzF593yj+qXjmFcasWz2RxwGG
        1GybRafjydX21ZBQ==
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
Subject: [PATCH v2 15/19] scsi: pm80xx: Switch back to original libsas event notifiers
Date:   Tue, 12 Jan 2021 12:06:43 +0100
Message-Id: <20210112110647.627783-16-a.darwish@linutronix.de>
In-Reply-To: <20210112110647.627783-1-a.darwish@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

libsas event notifiers required an extension where gfp_t flags must be
explicitly passed. For bisectability, a temporary _gfp() variant of such
functions were added. All call sites then got converted use the _gfp()
variants and explicitly pass GFP context. Having no callers left, the
original libsas notifiers were then modified to accept gfp_t flags by
default.

Switch back to the original libas API, while still passing GFP context.
The libsas _gfp() variants will be removed afterwards.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 38 ++++++++++++++++----------------
 drivers/scsi/pm8001/pm8001_sas.c |  4 ++--
 drivers/scsi/pm8001/pm80xx_hwi.c | 28 +++++++++++------------
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 85b9a168794e..a7dcfa68ea83 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3179,7 +3179,7 @@ void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)
 	pm8001_dbg(pm8001_ha, MSG, "phy %d byte dmaded.\n", i);
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
-	sas_notify_port_event_gfp(sas_phy, PORTE_BYTES_DMAED, GFP_ATOMIC);
+	sas_notify_port_event(sas_phy, PORTE_BYTES_DMAED, GFP_ATOMIC);
 }
 
 /* Get the link rate speed  */
@@ -3336,7 +3336,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	else if (phy->identify.device_type != SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
 	phy->sas_phy.oob_mode = SAS_OOB_MODE;
-	sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
+	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, &pPayload->sas_identify,
 		sizeof(struct sas_identify_frame)-4);
@@ -3379,7 +3379,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->phy_type |= PORT_TYPE_SATA;
 	phy->phy_attached = 1;
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
-	sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
+	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
 		sizeof(struct dev_to_host_fis));
@@ -3726,11 +3726,11 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD, GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_DOWN:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 		phy->phy_attached = 0;
 		phy->phy_state = 0;
 		hw_event_phy_down(pm8001_ha, piomb);
@@ -3739,7 +3739,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	/* the broadcast change primitive received, tell the LIBSAS this event
 	to revalidate the sas domain*/
@@ -3750,20 +3750,20 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR, GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3772,7 +3772,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			HW_EVENT_LINK_ERR_INVALID_DWORD, port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_DISPARITY_ERROR:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3782,7 +3782,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_CODE_VIOLATION:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3792,7 +3792,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3802,7 +3802,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_MALFUNCTION:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_MALFUNCTION\n");
@@ -3812,7 +3812,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_INBOUND_CRC_ERROR\n");
@@ -3822,13 +3822,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		break;
 	case HW_EVENT_HARD_RESET_RECEIVED:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
-		sas_notify_port_event_gfp(sas_phy, PORTE_HARD_RESET, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_HARD_RESET, GFP_ATOMIC);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3838,20 +3838,20 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, MSG,
 			   "HW_EVENT_PORT_RECOVERY_TIMER_TMO\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RECOVER:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RECOVER\n");
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a183293064b0..c4f111e73f9c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -207,7 +207,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			if (pm8001_ha->phy[phy_id].phy_state ==
 				PHY_STATE_LINK_UP_SPCV) {
 				sas_phy_disconnected(&phy->sas_phy);
-				sas_notify_phy_event_gfp(&phy->sas_phy,
+				sas_notify_phy_event(&phy->sas_phy,
 					PHYE_LOSS_OF_SIGNAL, GFP_KERNEL);
 				phy->phy_attached = 0;
 			}
@@ -215,7 +215,7 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			if (pm8001_ha->phy[phy_id].phy_state ==
 				PHY_STATE_LINK_UP_SPC) {
 				sas_phy_disconnected(&phy->sas_phy);
-				sas_notify_phy_event_gfp(&phy->sas_phy,
+				sas_notify_phy_event(&phy->sas_phy,
 					PHYE_LOSS_OF_SIGNAL, GFP_KERNEL);
 				phy->phy_attached = 0;
 			}
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index f849756e6ceb..abd65323be6b 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3287,7 +3287,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	else if (phy->identify.device_type != SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
 	phy->sas_phy.oob_mode = SAS_OOB_MODE;
-	sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
+	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, &pPayload->sas_identify,
 		sizeof(struct sas_identify_frame)-4);
@@ -3334,7 +3334,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->phy_type |= PORT_TYPE_SATA;
 	phy->phy_attached = 1;
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
-	sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
+	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
 		sizeof(struct dev_to_host_fis));
@@ -3417,7 +3417,7 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 	}
 	if (port_sata && (portstate != PORT_IN_RESET))
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 }
 
 static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
@@ -3515,7 +3515,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD, GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_DOWN:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
@@ -3531,7 +3531,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	/* the broadcast change primitive received, tell the LIBSAS this event
 	to revalidate the sas domain*/
@@ -3542,20 +3542,20 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR, GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3592,7 +3592,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_INBOUND_CRC_ERROR\n");
@@ -3602,13 +3602,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_HARD_RESET_RECEIVED:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
-		sas_notify_port_event_gfp(sas_phy, PORTE_HARD_RESET, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_HARD_RESET, GFP_ATOMIC);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
 		pm8001_dbg(pm8001_ha, MSG,
@@ -3618,7 +3618,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
@@ -3626,7 +3626,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		if (pm8001_ha->phy[phy_id].reset_completion) {
 			pm8001_ha->phy[phy_id].port_reset_status =
 					PORT_RESET_TMO;
@@ -3643,7 +3643,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
 			if (port->wide_port_phymap & (1 << i)) {
 				phy = &pm8001_ha->phy[i];
-				sas_notify_phy_event_gfp(&phy->sas_phy,
+				sas_notify_phy_event(&phy->sas_phy,
 						PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 				port->wide_port_phymap &= ~(1 << i);
 			}
-- 
2.30.0

