Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 377F1C3526C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BFC223B74
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387725AbgLRUpY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:45:24 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54814 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387722AbgLRUpX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 15:45:23 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608324280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kOjBruHLQvlcZqNK6UmDLr9wDXFlmep7M9DE9Ugb7rQ=;
        b=shw/mFXpyM77P3ijDyOXeaHCDseGBGKJcAs6PBeCPL83wFxEibYFJxerPTIqxUafjOXGI1
        a3aVcsAYNT4WgfvOHc/7ov0s7jv5DuCop30GZC7JCD+gVCK1rkJdn1l6gbl3pkSiTDlyN9
        xAUtfLuIHFcqlNqjfkuQBy7Y9wavz9KeF5WBN2M9JxYVtSSOol55s9ueoLtqNRS7yRZnJj
        5j2NfJ1esyo8dPZ0SP2XooH4QB4YkYRv4psyYFfpnCDIx00641GVyMh8S6qKZ76Xn83wva
        n3oexOlxNol9fvwO32VsiWFRTeFp1qEpD6P6EpzJqnOuWVe4Cuuu/0r/owdURQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608324280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kOjBruHLQvlcZqNK6UmDLr9wDXFlmep7M9DE9Ugb7rQ=;
        b=gEcuf05Ojq/rn/8yPzoJdngdSvcIGJK4y91/XxyN/yAzWajqZYxadkybhxaEkGU9uvK4HR
        54SAa07gD0w1ntDg==
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Daniel Wagner <dwagner@suse.de>,
        Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH 08/11] scsi: pm80xx: Pass gfp_t flags to libsas event notifiers
Date:   Fri, 18 Dec 2020 21:43:51 +0100
Message-Id: <20201218204354.586951-9-a.darwish@linutronix.de>
In-Reply-To: <20201218204354.586951-1-a.darwish@linutronix.de>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
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
 drivers/scsi/pm8001/pm8001_sas.c |  8 +++----
 drivers/scsi/pm8001/pm80xx_hwi.c | 30 ++++++++++++-------------
 3 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 2b7b2954ec31..36eb5cc6f2fa 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3306,7 +3306,7 @@ void pm8001_bytes_dmaed(struct pm8001_hba_info *pm8001_ha, int i)
 	PM8001_MSG_DBG(pm8001_ha, pm8001_printk("phy %d byte dmaded.\n", i));
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
-	pm8001_ha->sas->notify_port_event(sas_phy, PORTE_BYTES_DMAED);
+	pm8001_ha->sas->notify_port_event_gfp(sas_phy, PORTE_BYTES_DMAED, GFP_ATOMIC);
 }
 
 /* Get the link rate speed  */
@@ -3467,7 +3467,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	else if (phy->identify.device_type != SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
 	phy->sas_phy.oob_mode = SAS_OOB_MODE;
-	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_ha->notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, &pPayload->sas_identify,
 		sizeof(struct sas_identify_frame)-4);
@@ -3512,7 +3512,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->phy_type |= PORT_TYPE_SATA;
 	phy->phy_attached = 1;
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
-	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_ha->notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
 		sizeof(struct dev_to_host_fis));
@@ -3879,12 +3879,12 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 	case HW_EVENT_SATA_SPINUP_HOLD:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_SATA_SPINUP_HOLD\n"));
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
+		sas_ha->notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_DOWN:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_PHY_DOWN\n"));
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
+		sas_ha->notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 		phy->phy_attached = 0;
 		phy->phy_state = 0;
 		hw_event_phy_down(pm8001_ha, piomb);
@@ -3894,7 +3894,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			pm8001_printk("HW_EVENT_PORT_INVALID\n"));
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	/* the broadcast change primitive received, tell the LIBSAS this event
 	to revalidate the sas domain*/
@@ -3906,14 +3906,14 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_ERROR:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_PHY_ERROR\n"));
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
+		sas_ha->notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3921,7 +3921,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3930,7 +3930,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			HW_EVENT_LINK_ERR_INVALID_DWORD, port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_DISPARITY_ERROR:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3940,7 +3940,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_CODE_VIOLATION:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3950,7 +3950,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_LOSS_OF_DWORD_SYNCH:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3960,7 +3960,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_MALFUNCTION:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3972,7 +3972,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3984,14 +3984,14 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 	case HW_EVENT_HARD_RESET_RECEIVED:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_HARD_RESET_RECEIVED\n"));
-		sas_ha->notify_port_event(sas_phy, PORTE_HARD_RESET);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_HARD_RESET, GFP_ATOMIC);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_ID_FRAME_TIMEOUT\n"));
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -4001,21 +4001,21 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void* piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_PORT_RESET_TIMER_TMO\n"));
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RECOVERY_TIMER_TMO:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_PORT_RECOVERY_TIMER_TMO\n"));
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RECOVER:
 		PM8001_MSG_DBG(pm8001_ha,
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 9889bab7d31c..8850e62550a3 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -209,8 +209,8 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 				PHY_STATE_LINK_UP_SPCV) {
 				sas_ha = pm8001_ha->sas;
 				sas_phy_disconnected(&phy->sas_phy);
-				sas_ha->notify_phy_event(&phy->sas_phy,
-					PHYE_LOSS_OF_SIGNAL);
+				sas_ha->notify_phy_event_gfp(&phy->sas_phy,
+							     PHYE_LOSS_OF_SIGNAL, GFP_KERNEL);
 				phy->phy_attached = 0;
 			}
 		} else {
@@ -218,8 +218,8 @@ int pm8001_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 				PHY_STATE_LINK_UP_SPC) {
 				sas_ha = pm8001_ha->sas;
 				sas_phy_disconnected(&phy->sas_phy);
-				sas_ha->notify_phy_event(&phy->sas_phy,
-					PHYE_LOSS_OF_SIGNAL);
+				sas_ha->notify_phy_event_gfp(&phy->sas_phy,
+							     PHYE_LOSS_OF_SIGNAL, GFP_KERNEL);
 				phy->phy_attached = 0;
 			}
 		}
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 7593f248afb2..a6fd08ae4402 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3355,7 +3355,7 @@ hw_event_sas_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	else if (phy->identify.device_type != SAS_PHY_UNUSED)
 		phy->identify.target_port_protocols = SAS_PROTOCOL_SMP;
 	phy->sas_phy.oob_mode = SAS_OOB_MODE;
-	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_ha->notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, &pPayload->sas_identify,
 		sizeof(struct sas_identify_frame)-4);
@@ -3403,7 +3403,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->phy_type |= PORT_TYPE_SATA;
 	phy->phy_attached = 1;
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
-	sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+	sas_ha->notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
 	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
 		sizeof(struct dev_to_host_fis));
@@ -3489,7 +3489,7 @@ hw_event_phy_down(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	if (port_sata && (portstate != PORT_IN_RESET)) {
 		struct sas_ha_struct *sas_ha = pm8001_ha->sas;
 
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
+		sas_ha->notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 	}
 }
 
@@ -3591,7 +3591,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case HW_EVENT_SATA_SPINUP_HOLD:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_SATA_SPINUP_HOLD\n"));
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
+		sas_ha->notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_DOWN:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3610,7 +3610,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			pm8001_printk("HW_EVENT_PORT_INVALID\n"));
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	/* the broadcast change primitive received, tell the LIBSAS this event
 	to revalidate the sas domain*/
@@ -3622,14 +3622,14 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_CHANGE;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PHY_ERROR:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_PHY_ERROR\n"));
 		sas_phy_disconnected(&phy->sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
+		sas_ha->notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_BROADCAST_EXP:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3637,7 +3637,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_EXP;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_INVALID_DWORD:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3676,7 +3676,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 		sas_phy->sas_prim = HW_EVENT_BROADCAST_SES;
 		spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		break;
 	case HW_EVENT_INBOUND_CRC_ERROR:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3688,14 +3688,14 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	case HW_EVENT_HARD_RESET_RECEIVED:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_HARD_RESET_RECEIVED\n"));
-		sas_ha->notify_port_event(sas_phy, PORTE_HARD_RESET);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_HARD_RESET, GFP_ATOMIC);
 		break;
 	case HW_EVENT_ID_FRAME_TIMEOUT:
 		PM8001_MSG_DBG(pm8001_ha,
 			pm8001_printk("HW_EVENT_ID_FRAME_TIMEOUT\n"));
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_LINK_ERR_PHY_RESET_FAILED:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3705,7 +3705,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		break;
 	case HW_EVENT_PORT_RESET_TIMER_TMO:
 		PM8001_MSG_DBG(pm8001_ha,
@@ -3714,7 +3714,7 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 			port_id, phy_id, 0, 0);
 		sas_phy_disconnected(sas_phy);
 		phy->phy_attached = 0;
-		sas_ha->notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 		if (pm8001_ha->phy[phy_id].reset_completion) {
 			pm8001_ha->phy[phy_id].port_reset_status =
 					PORT_RESET_TMO;
@@ -3731,8 +3731,8 @@ static int mpi_hw_event(struct pm8001_hba_info *pm8001_ha, void *piomb)
 		for (i = 0; i < pm8001_ha->chip->n_phy; i++) {
 			if (port->wide_port_phymap & (1 << i)) {
 				phy = &pm8001_ha->phy[i];
-				sas_ha->notify_phy_event(&phy->sas_phy,
-						PHYE_LOSS_OF_SIGNAL);
+				sas_ha->notify_phy_event_gfp(&phy->sas_phy,
+							     PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 				port->wide_port_phymap &= ~(1 << i);
 			}
 		}
-- 
2.29.2

