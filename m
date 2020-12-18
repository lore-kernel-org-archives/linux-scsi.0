Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92F39C3527A
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70BFB23B6C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387751AbgLRUpd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731972AbgLRUpc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 15:45:32 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8099C0617B0;
        Fri, 18 Dec 2020 12:44:51 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608324290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TGp8RYrejIhCe6v5PxYLeKCMdj/9pcbsyPRecLy7Si0=;
        b=dQdBxVzyeBpVhk+RaMvZR+AIpzVZk6wh5QInp3fjMSNp6rKDknUrNna4wVtyM0eRh13Yb8
        LR3Wnu8G7jeU0DNvO47to9/mkQc6fBO24rMAxb4T4n4tGV4deZYm+SNzqYBsVpNkQFjdYP
        L1RA+UklB29cwfAuHGN4mJLwAITPPxPLqdTjGe4QmBdC9WvNZdX2bdWsxyUDK1V74f8BYb
        8Ov+v24J1rZwgzvq/ZR+DDfeY9MU5f7W+ESaMU7vcVUrqsd34imA+kvEZdw7Lhc3NQ0S0d
        1XXQDGVrfMb6bI9b+qJ9YUNucEwTIx/ML2qb06Xc1wVteK0Va5pcWDeatdisVA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608324290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TGp8RYrejIhCe6v5PxYLeKCMdj/9pcbsyPRecLy7Si0=;
        b=xaqaFReK8XwLG0Y2cxVEv354avu8UAsOqB+egiQxraiBkeglW2VOAZZPnWTaX8wmLJv98C
        tSgbcnW3EefK2fBw==
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
Subject: [PATCH 10/11] scsi: hisi_sas: Pass gfp_t flags to libsas event notifiers
Date:   Fri, 18 Dec 2020 21:43:53 +0100
Message-Id: <20201218204354.586951-11-a.darwish@linutronix.de>
In-Reply-To: <20201218204354.586951-1-a.darwish@linutronix.de>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the new libsas event notifiers API, which requires callers to
explicitly pass the gfp_t memory allocation flags.

Below are the context analysis for modified functions:

=> hisi_sas_bytes_dmaed():

Since it is invoked from both process and atomic contexts, let its
callers pass the gfp_t flags:

  * hisi_sas_main.c:
  ------------------

    hisi_sas_phyup_work(): workqueue context
      -> hisi_sas_bytes_dmaed(..., GFP_KERNEL)

    hisi_sas_controller_reset_done(): has an msleep()
      -> hisi_sas_rescan_topology()
        -> hisi_sas_phy_down()
          -> hisi_sas_bytes_dmaed(..., GFP_KERNEL)

    hisi_sas_debug_I_T_nexus_reset(): calls wait_for_completion_timeout()
      -> hisi_sas_phy_down()
        -> hisi_sas_bytes_dmaed(..., GFP_KERNEL)

  * hisi_sas_v1_hw.c:
  -------------------

    int_abnormal_v1_hw(): irq handler
      -> hisi_sas_phy_down()
        -> hisi_sas_bytes_dmaed(..., GFP_ATOMIC)

  * hisi_sas_v[23]_hw.c:
  ----------------------

    int_phy_updown_v[23]_hw(): irq handler
      -> phy_down_v[23]_hw()
        -> hisi_sas_phy_down()
          -> hisi_sas_bytes_dmaed(..., GFP_ATOMIC)

=> int_bcast_v1_hw() and phy_bcast_v3_hw():

Both are invoked exclusively from irq handlers. Pass GFP_ATOMIC.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 26 +++++++++++++++-----------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  5 +++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  5 +++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  5 +++--
 5 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index a25cfc11c96d..e08c71bf607d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -658,7 +658,8 @@ extern void hisi_sas_scan_start(struct Scsi_Host *shost);
 extern int hisi_sas_host_reset(struct Scsi_Host *shost, int reset_type);
 extern void hisi_sas_phy_enable(struct hisi_hba *hisi_hba, int phy_no,
 				int enable);
-extern void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy);
+extern void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy,
+			      gfp_t gfp_flags);
 extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
 				    struct sas_task *task,
 				    struct hisi_sas_slot *slot);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 274ccf18ce2d..f9332f62739b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -618,7 +618,8 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	return rc;
 }
 
-static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
+static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no,
+				 gfp_t gfp_flags)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
@@ -634,7 +635,7 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 	}
 
 	sas_ha = &hisi_hba->sha;
-	sas_ha->notify_phy_event(sas_phy, PHYE_OOB_DONE);
+	sas_ha->notify_phy_event_gfp(sas_phy, PHYE_OOB_DONE, gfp_flags);
 
 	if (sas_phy->phy) {
 		struct sas_phy *sphy = sas_phy->phy;
@@ -662,7 +663,7 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 	}
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
-	sas_ha->notify_port_event(sas_phy, PORTE_BYTES_DMAED);
+	sas_ha->notify_port_event_gfp(sas_phy, PORTE_BYTES_DMAED, gfp_flags);
 }
 
 static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
@@ -868,7 +869,7 @@ static void hisi_sas_phyup_work(struct work_struct *work)
 
 	if (phy->identify.target_port_protocols == SAS_PROTOCOL_SSP)
 		hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
-	hisi_sas_bytes_dmaed(hisi_hba, phy_no);
+	hisi_sas_bytes_dmaed(hisi_hba, phy_no, GFP_KERNEL);
 }
 
 static void hisi_sas_linkreset_work(struct work_struct *work)
@@ -1438,11 +1439,12 @@ static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 state)
 				_sas_port = sas_port;
 
 				if (dev_is_expander(dev->dev_type))
-					sas_ha->notify_port_event(sas_phy,
-							PORTE_BROADCAST_RCVD);
+					sas_ha->notify_port_event_gfp(sas_phy,
+								      PORTE_BROADCAST_RCVD,
+								      GFP_KERNEL);
 			}
 		} else {
-			hisi_sas_phy_down(hisi_hba, phy_no, 0);
+			hisi_sas_phy_down(hisi_hba, phy_no, 0, GFP_KERNEL);
 		}
 	}
 }
@@ -1796,7 +1798,7 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 
 		/* report PHY down if timed out */
 		if (!ret)
-			hisi_sas_phy_down(hisi_hba, sas_phy->id, 0);
+			hisi_sas_phy_down(hisi_hba, sas_phy->id, 0, GFP_KERNEL);
 	} else if (sas_dev->dev_status != HISI_SAS_DEV_INIT) {
 		/*
 		 * If in init state, we rely on caller to wait for link to be
@@ -2196,7 +2198,8 @@ static void hisi_sas_phy_disconnected(struct hisi_sas_phy *phy)
 	spin_unlock_irqrestore(&phy->lock, flags);
 }
 
-void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
+void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy,
+		       gfp_t gfp_flags)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
@@ -2205,7 +2208,7 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 
 	if (rdy) {
 		/* Phy down but ready */
-		hisi_sas_bytes_dmaed(hisi_hba, phy_no);
+		hisi_sas_bytes_dmaed(hisi_hba, phy_no, gfp_flags);
 		hisi_sas_port_notify_formed(sas_phy);
 	} else {
 		struct hisi_sas_port *port  = phy->port;
@@ -2216,7 +2219,8 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 			return;
 		}
 		/* Phy down and not ready */
-		sas_ha->notify_phy_event(sas_phy, PHYE_LOSS_OF_SIGNAL);
+		sas_ha->notify_phy_event_gfp(sas_phy, PHYE_LOSS_OF_SIGNAL,
+					     gfp_flags);
 		sas_phy_disconnected(sas_phy);
 
 		if (port) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 45e866cb9164..56b2ca5544e1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1424,7 +1424,7 @@ static irqreturn_t int_bcast_v1_hw(int irq, void *p)
 	}
 
 	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sha->notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 
 end:
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
@@ -1453,7 +1453,8 @@ static irqreturn_t int_abnormal_v1_hw(int irq, void *p)
 		u32 phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
 
 		hisi_sas_phy_down(hisi_hba, phy_no,
-				  (phy_state & 1 << phy_no) ? 1 : 0);
+				  (phy_state & 1 << phy_no) ? 1 : 0,
+				  GFP_ATOMIC);
 	}
 
 	if (irq_value & CHL_INT0_ID_TIMEOUT_MSK)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index b57177b52fac..a8cc89abcc6b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2734,7 +2734,8 @@ static int phy_down_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 	phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
 	dev_info(dev, "phydown: phy%d phy_state=0x%x\n", phy_no, phy_state);
-	hisi_sas_phy_down(hisi_hba, phy_no, (phy_state & 1 << phy_no) ? 1 : 0);
+	hisi_sas_phy_down(hisi_hba, phy_no, (phy_state & 1 << phy_no) ? 1 : 0,
+			  GFP_ATOMIC);
 
 	sl_ctrl = hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL,
@@ -2825,7 +2826,7 @@ static void phy_bcast_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
 	if ((bcast_status & RX_BCAST_CHG_MSK) &&
 	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_RX_BCST_ACK_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 0);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 960de375ce69..efba79252ddc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1578,7 +1578,8 @@ static irqreturn_t phy_down_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 	phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
 	dev_info(dev, "phydown: phy%d phy_state=0x%x\n", phy_no, phy_state);
-	hisi_sas_phy_down(hisi_hba, phy_no, (phy_state & 1 << phy_no) ? 1 : 0);
+	hisi_sas_phy_down(hisi_hba, phy_no, (phy_state & 1 << phy_no) ? 1 : 0,
+			  GFP_ATOMIC);
 
 	sl_ctrl = hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL,
@@ -1605,7 +1606,7 @@ static irqreturn_t phy_bcast_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
 	if ((bcast_status & RX_BCAST_CHG_MSK) &&
 	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sas_ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_ha->notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_RX_BCST_ACK_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 0);
-- 
2.29.2

