Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2323C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:12:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77CFA222B3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:12:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394421AbhARVBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:01:21 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55210 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389746AbhARKN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:29 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIS6zp2wrBPee1AZ+/RX31FHuG8CR3hAz0e6PhWRIws=;
        b=GEGmgNx2GRfJy+r4vAQ0wDWgyvZ7eVq7E6W2K6iHu2f0F8HLV+5VyK78vnxbVsPIeJLAe8
        8MhIgcMHWhCYRw8QntXD1DQqDnmXKdQCCVP40H4ifqvFE4V4qDEfBkcakYOcibGnYQQ1Jx
        sekcToGNRpoRQ9RVrfVf/k3i8UgSN2BnaVGYe0PsQhP984dcGhac1VLaJk717vC3zDl7Da
        2IgZQ7Ex8VzauLJYzXV8WZSuw77j4f3+gH22DjidjsEuAxkjMyQw5lgqWmdgrq9btgpZzq
        WXgYpNleIN3p3zpOit14RY9U+gNs02xuRRWe8mkJCxu/oOnOvYZNY/LLmEklPA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964660;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HIS6zp2wrBPee1AZ+/RX31FHuG8CR3hAz0e6PhWRIws=;
        b=PV3G4xM7H+QQDCSQLqKuXgTaYu48rR2GgJqL3Hy5U1XveEkeco5P0IJ/pqPNisN5qsDbqn
        JYELb3ylHEkXbKCQ==
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
Subject: [PATCH v3 11/19] scsi: hisi_sas: Pass gfp_t flags to libsas event notifiers
Date:   Mon, 18 Jan 2021 11:09:47 +0100
Message-Id: <20210118100955.1761652-12-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
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
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 26 +++++++++++++++-----------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  6 ++++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  6 ++++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  6 ++++--
 5 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index e821dd32dd28..873bfffa626d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -637,7 +637,8 @@ extern void hisi_sas_scan_start(struct Scsi_Host *shost);
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
index 76f8fc3fad59..54acaeab5bb7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -612,7 +612,8 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	return rc;
 }
 
-static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
+static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no,
+				 gfp_t gfp_flags)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
@@ -626,7 +627,7 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 		return;
 	}
 
-	sas_notify_phy_event(sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event_gfp(sas_phy, PHYE_OOB_DONE, gfp_flags);
 
 	if (sas_phy->phy) {
 		struct sas_phy *sphy = sas_phy->phy;
@@ -654,7 +655,7 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 	}
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
-	sas_notify_port_event(sas_phy, PORTE_BYTES_DMAED);
+	sas_notify_port_event_gfp(sas_phy, PORTE_BYTES_DMAED, gfp_flags);
 }
 
 static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
@@ -860,7 +861,7 @@ static void hisi_sas_phyup_work(struct work_struct *work)
 
 	if (phy->identify.target_port_protocols == SAS_PROTOCOL_SSP)
 		hisi_hba->hw->sl_notify_ssp(hisi_hba, phy_no);
-	hisi_sas_bytes_dmaed(hisi_hba, phy_no);
+	hisi_sas_bytes_dmaed(hisi_hba, phy_no, GFP_KERNEL);
 }
 
 static void hisi_sas_linkreset_work(struct work_struct *work)
@@ -1429,11 +1430,12 @@ static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 state)
 				_sas_port = sas_port;
 
 				if (dev_is_expander(dev->dev_type))
-					sas_notify_port_event(sas_phy,
-							PORTE_BROADCAST_RCVD);
+					sas_notify_port_event_gfp(sas_phy,
+							PORTE_BROADCAST_RCVD,
+							GFP_KERNEL);
 			}
 		} else {
-			hisi_sas_phy_down(hisi_hba, phy_no, 0);
+			hisi_sas_phy_down(hisi_hba, phy_no, 0, GFP_KERNEL);
 		}
 	}
 }
@@ -1787,7 +1789,7 @@ static int hisi_sas_debug_I_T_nexus_reset(struct domain_device *device)
 
 		/* report PHY down if timed out */
 		if (!ret)
-			hisi_sas_phy_down(hisi_hba, sas_phy->id, 0);
+			hisi_sas_phy_down(hisi_hba, sas_phy->id, 0, GFP_KERNEL);
 	} else if (sas_dev->dev_status != HISI_SAS_DEV_INIT) {
 		/*
 		 * If in init state, we rely on caller to wait for link to be
@@ -2187,7 +2189,8 @@ static void hisi_sas_phy_disconnected(struct hisi_sas_phy *phy)
 	spin_unlock_irqrestore(&phy->lock, flags);
 }
 
-void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
+void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy,
+		       gfp_t gfp_flags)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
@@ -2195,7 +2198,7 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 
 	if (rdy) {
 		/* Phy down but ready */
-		hisi_sas_bytes_dmaed(hisi_hba, phy_no);
+		hisi_sas_bytes_dmaed(hisi_hba, phy_no, gfp_flags);
 		hisi_sas_port_notify_formed(sas_phy);
 	} else {
 		struct hisi_sas_port *port  = phy->port;
@@ -2206,7 +2209,8 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy)
 			return;
 		}
 		/* Phy down and not ready */
-		sas_notify_phy_event(sas_phy, PHYE_LOSS_OF_SIGNAL);
+		sas_notify_phy_event_gfp(sas_phy,
+					 PHYE_LOSS_OF_SIGNAL, gfp_flags);
 		sas_phy_disconnected(sas_phy);
 
 		if (port) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 22eecc89d41b..2e660c0476f1 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1423,7 +1423,8 @@ static irqreturn_t int_bcast_v1_hw(int irq, void *p)
 	}
 
 	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
+					  GFP_ATOMIC);
 
 end:
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
@@ -1452,7 +1453,8 @@ static irqreturn_t int_abnormal_v1_hw(int irq, void *p)
 		u32 phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
 
 		hisi_sas_phy_down(hisi_hba, phy_no,
-				  (phy_state & 1 << phy_no) ? 1 : 0);
+				  (phy_state & 1 << phy_no) ? 1 : 0,
+				  GFP_ATOMIC);
 	}
 
 	if (irq_value & CHL_INT0_ID_TIMEOUT_MSK)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 10ba0680da04..da62dfdb724d 100644
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
@@ -2824,7 +2825,8 @@ static void phy_bcast_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
 	if ((bcast_status & RX_BCAST_CHG_MSK) &&
 	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
+					  GFP_ATOMIC);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_RX_BCST_ACK_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 0);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 9d9dcc11a866..0307248fd973 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1580,7 +1580,8 @@ static irqreturn_t phy_down_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 
 	phy_state = hisi_sas_read32(hisi_hba, PHY_STATE);
 	dev_info(dev, "phydown: phy%d phy_state=0x%x\n", phy_no, phy_state);
-	hisi_sas_phy_down(hisi_hba, phy_no, (phy_state & 1 << phy_no) ? 1 : 0);
+	hisi_sas_phy_down(hisi_hba, phy_no, (phy_state & 1 << phy_no) ? 1 : 0,
+			  GFP_ATOMIC);
 
 	sl_ctrl = hisi_sas_phy_read32(hisi_hba, phy_no, SL_CONTROL);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL,
@@ -1606,7 +1607,8 @@ static irqreturn_t phy_bcast_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
 	if ((bcast_status & RX_BCAST_CHG_MSK) &&
 	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
+					  GFP_ATOMIC);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_RX_BCST_ACK_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 0);
-- 
2.30.0

