Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B73C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 11:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14304229C6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 11:11:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389148AbhARKsR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 05:48:17 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55214 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389748AbhARKN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:29 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tZIkjwCTKmE8Eib8y4wjUibBMow6S+PJcbpOogmAT5w=;
        b=wltenRSeNT5KKW/GIwse6fJ8JJpb/5+nZlC5IKiRV9IMm4llUpRmAJKUqnlP3OSIUc8jmP
        WZ4b5R5UX4LPU8BTHllUvv+ROO7Y6cvQhYf3Fbrh5nCUq+ntsc28ftrK8wyH5Jnqc73L0o
        UzF/vykIfmBCLvxqHgZrDovHbR711qJQhex+08cmJ5GT0LYdZUVMu+Pm62GT6G4ICBWV5I
        ZH04VJ/kjSgHkzMY/PKdinQdoNRU6kowJMx1PLST8Ruxzt71qiopJBbnPjgT0ahqdBqqkI
        ZfqLAappGKFw1iXmzXfReoCd6UEUByPHUFpdNYadKkxv2PKP9prOBIYT0qRSkQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tZIkjwCTKmE8Eib8y4wjUibBMow6S+PJcbpOogmAT5w=;
        b=ybSBwFSryf46ni2tqE7X//IWezpi7d1EnIQX4ENnp7XIgqvuRt8qr2eZnseZvht8soKjrv
        T0CFamq75MYOwuBA==
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
Subject: [PATCH v3 13/19] scsi: hisi_sas: Switch back to original libsas event notifiers
Date:   Mon, 18 Jan 2021 11:09:49 +0100
Message-Id: <20210118100955.1761652-14-a.darwish@linutronix.de>
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
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 9 ++++-----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 4 ++--
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 54acaeab5bb7..625327e99b06 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -627,7 +627,7 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no,
 		return;
 	}
 
-	sas_notify_phy_event_gfp(sas_phy, PHYE_OOB_DONE, gfp_flags);
+	sas_notify_phy_event(sas_phy, PHYE_OOB_DONE, gfp_flags);
 
 	if (sas_phy->phy) {
 		struct sas_phy *sphy = sas_phy->phy;
@@ -655,7 +655,7 @@ static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no,
 	}
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
-	sas_notify_port_event_gfp(sas_phy, PORTE_BYTES_DMAED, gfp_flags);
+	sas_notify_port_event(sas_phy, PORTE_BYTES_DMAED, gfp_flags);
 }
 
 static struct hisi_sas_device *hisi_sas_alloc_dev(struct domain_device *device)
@@ -1430,7 +1430,7 @@ static void hisi_sas_rescan_topology(struct hisi_hba *hisi_hba, u32 state)
 				_sas_port = sas_port;
 
 				if (dev_is_expander(dev->dev_type))
-					sas_notify_port_event_gfp(sas_phy,
+					sas_notify_port_event(sas_phy,
 							PORTE_BROADCAST_RCVD,
 							GFP_KERNEL);
 			}
@@ -2209,8 +2209,7 @@ void hisi_sas_phy_down(struct hisi_hba *hisi_hba, int phy_no, int rdy,
 			return;
 		}
 		/* Phy down and not ready */
-		sas_notify_phy_event_gfp(sas_phy,
-					 PHYE_LOSS_OF_SIGNAL, gfp_flags);
+		sas_notify_phy_event(sas_phy, PHYE_LOSS_OF_SIGNAL, gfp_flags);
 		sas_phy_disconnected(sas_phy);
 
 		if (port) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 2e660c0476f1..7451377c4cb6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1423,8 +1423,8 @@ static irqreturn_t int_bcast_v1_hw(int irq, void *p)
 	}
 
 	if (!test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
-					  GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
+				      GFP_ATOMIC);
 
 end:
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT2,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index da62dfdb724d..502ad3e4f7cd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2825,8 +2825,8 @@ static void phy_bcast_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
 	if ((bcast_status & RX_BCAST_CHG_MSK) &&
 	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
-					  GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
+				      GFP_ATOMIC);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_RX_BCST_ACK_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 0);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 0307248fd973..28edf76e0f47 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1607,8 +1607,8 @@ static irqreturn_t phy_bcast_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 	bcast_status = hisi_sas_phy_read32(hisi_hba, phy_no, RX_PRIMS_STATUS);
 	if ((bcast_status & RX_BCAST_CHG_MSK) &&
 	    !test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags))
-		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
-					  GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
+				      GFP_ATOMIC);
 	hisi_sas_phy_write32(hisi_hba, phy_no, CHL_INT0,
 			     CHL_INT0_SL_RX_BCST_ACK_MSK);
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_RX_BCAST_CHK_MSK, 0);
-- 
2.30.0

