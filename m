Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0652DC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3B43229C6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388570AbhARVMq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:12:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389752AbhARKN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:29 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2649C0613CF;
        Mon, 18 Jan 2021 02:12:47 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JV53PJBL+q2LIg8dEYozX9sLIMwqWIFTHdZau/CE/EQ=;
        b=P8WhA78N5qLC0BTonXwYpS7sozodJMzzrHGSW5Wrx5IRka3B5eGQg+V/aZfuNzv3nW11vF
        yDPv9GQZ+xNCLQOjn3U05vR/sYQSmFxd00J76VkpDqKI+8HmfoG1r/+MfICnN5lzoNdYIh
        uWPiXB9QfBAUPkcxED/vRvF1y8ysZH0oOeTofmAgA+ZTP0SimAfA+9ySs92XsiF9cCf0+P
        dNG6H0T5YCjiuv5mnz8VsciQEDu3RcSIpYWhkX+uvfRA07suaSAqoDJG3mpEISQWXM6NeU
        iXPhmGEUbVdBKU85RYY98i58gjOcvvNb1Y8qKA2DvDBwldDjo9TXaUUfOfLMfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JV53PJBL+q2LIg8dEYozX9sLIMwqWIFTHdZau/CE/EQ=;
        b=AmuhyzmenbT6Ub1fxo0FsM2/eSjE8qCahdIWmEG4dZzHFk0WoDHPj1j1Sg/Dxz2iAJEac3
        DZeMLJfdHBBcsECQ==
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH v3 15/19] scsi: pm80xx: Switch back to original libsas event notifiers
Date:   Mon, 18 Jan 2021 11:09:51 +0100
Message-Id: <20210118100955.1761652-16-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
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
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 40 +++++++++++++++-----------------
 drivers/scsi/pm8001/pm8001_sas.c |  5 ++--
 drivers/scsi/pm8001/pm80xx_hwi.c | 32 ++++++++++++-------------
 3 files changed, 36 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index c8bfa8e6f211..b3f136998025 100644
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
@@ -3726,12 +3726,12 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD,
+		sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_DOWN:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_DOWN\n");
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL,
+		sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL,
 			GFP_ATOMIC);
 		phy->phy_attached = 0;
 		phy->phy_state = 0;
@@ -3741,7 +3741,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	/* the broadcast change primitive received, tell the LIBSAS this event
@@ -3753,22 +3753,21 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR,
-			GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
@@ -3778,7 +3777,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			HW_EVENT_LINK_ERR_INVALID_DWORD, port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_DISPARITY_ERROR:
@@ -3789,7 +3788,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_CODE_VIOLATION:
@@ -3800,7 +3799,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH:
@@ -3811,7 +3810,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_MALFUNCTION:
@@ -3822,7 +3821,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
@@ -3833,14 +3832,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		break;
 	case HW_EVENT_HARD_RESET_RECEIVED:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
-		sas_notify_port_event_gfp(sas_phy, PORTE_HARD_RESET,
-			GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_HARD_RESET, GFP_ATOMIC);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
@@ -3851,14 +3849,14 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_RESET_TIMER_TMO\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
@@ -3866,7 +3864,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			   "HW_EVENT_PORT_RECOVERY_TIMER_TMO\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RECOVER:
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index da444facd52e..c4f111e73f9c 100644
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
@@ -1341,4 +1341,3 @@ int pm8001_clear_task_set(struct domain_device *dev, u8 *lun)
 	tmf_task.tmf = TMF_CLEAR_TASK_SET;
 	return pm8001_issue_ssp_tmf(dev, lun, &tmf_task);
 }
-
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index a43a4e5db043..b96633dc052c 100644
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
@@ -3417,8 +3417,8 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 
 	}
 	if (port_sata && (portstate != PORT_IN_RESET))
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL,
-					GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL,
+				GFP_ATOMIC);
 }
 
 static int mpi_phy_start_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
@@ -3516,7 +3516,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_SATA_SPINUP_HOLD:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_SATA_SPINUP_HOLD\n");
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD,
+		sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_DOWN:
@@ -3533,7 +3533,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PORT_INVALID\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	/* the broadcast change primitive received, tell the LIBSAS this event
@@ -3545,22 +3545,21 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_ERROR:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_PHY_ERROR\n");
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR,
-			GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_BROADCAST_EXP\n");
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
@@ -3598,7 +3597,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
@@ -3609,14 +3608,13 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		break;
 	case HW_EVENT_HARD_RESET_RECEIVED:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_HARD_RESET_RECEIVED\n");
-		sas_notify_port_event_gfp(sas_phy, PORTE_HARD_RESET,
-			GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_HARD_RESET, GFP_ATOMIC);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
 		pm8001_dbg(pm8001_ha, MSG, "HW_EVENT_ID_FRAME_TIMEOUT\n");
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
@@ -3627,7 +3625,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
@@ -3636,7 +3634,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR,
+		sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR,
 			GFP_ATOMIC);
 		if (pm8001_ha->phy[phy_id].reset_completion) {
 			pm8001_ha->phy[phy_id].port_reset_status =
@@ -3654,7 +3652,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
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

