Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE4FC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 10:48:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17F6B2222F
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 10:48:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389271AbhARKs1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 05:48:27 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55222 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389754AbhARKNb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:31 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rCoUnEGucDJKkx1I4wm0D1GIGgiWaqTeEVIetS2fm+4=;
        b=Q3xEKCocQgMx+JuhL1cJPT9+A+G1/5qYduRgToKI9PLcLpIOe9/wrDEln9LBeQcIxFNDS3
        9gd8ZCtW8zzFB5hCn/gMGvjGnvry29pb+lYShIZ9JVQ61w07VW+t5O5CI+3dhXf9b5E8+1
        1wvqCHNTjSJ3OP1XLYQQrsIU/aVHKRGF2Pi+wZc2FFX7wqGuSEvyMd6a/xG8I8yXRaWiCw
        BvOsMFbjDrfWpk4UU4jNYKbpKELGKC6FPx21NQirF+yFbduHz7o/26p9G/t8IwJSTHIUbJ
        yv10hMH5DV3w7Uk6VSZGAd7Wufr95Ik80ZW/yKa3ZhRWjdyu63kO+dx7xQt9xA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rCoUnEGucDJKkx1I4wm0D1GIGgiWaqTeEVIetS2fm+4=;
        b=9vHl+lAFxHJX7yhS1t9HtiVS04XjwW2xuJ746m6vtlxdAZ3EadGte6AKGSrfFYJs5MzSPZ
        3X+Rf8EWcHbQjhCQ==
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
Subject: [PATCH v3 18/19] scsi: mvsas: Switch back to original libsas event notifiers
Date:   Mon, 18 Jan 2021 11:09:54 +0100
Message-Id: <20210118100955.1761652-19-a.darwish@linutronix.de>
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
 drivers/scsi/mvsas/mv_sas.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 484e01428da2..1acea528f27f 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -229,7 +229,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i, gfp_t gfp_flags)
 		return;
 	}
 
-	sas_notify_phy_event_gfp(sas_phy, PHYE_OOB_DONE, gfp_flags);
+	sas_notify_phy_event(sas_phy, PHYE_OOB_DONE, gfp_flags);
 
 	if (sas_phy->phy) {
 		struct sas_phy *sphy = sas_phy->phy;
@@ -261,7 +261,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i, gfp_t gfp_flags)
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
 
-	sas_notify_port_event_gfp(sas_phy, PORTE_BYTES_DMAED, gfp_flags);
+	sas_notify_port_event(sas_phy, PORTE_BYTES_DMAED, gfp_flags);
 }
 
 void mvs_scan_start(struct Scsi_Host *shost)
@@ -1892,7 +1892,7 @@ static void mvs_work_queue(struct work_struct *work)
 			if (!(tmp & PHY_READY_MASK)) {
 				sas_phy_disconnected(sas_phy);
 				mvs_phy_disconnected(phy);
-				sas_notify_phy_event_gfp(sas_phy,
+				sas_notify_phy_event(sas_phy,
 					PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 				mv_dprintk("phy%d Removed Device\n", phy_no);
 			} else {
@@ -1905,7 +1905,7 @@ static void mvs_work_queue(struct work_struct *work)
 		}
 	} else if (mwq->handler & EXP_BRCT_CHG) {
 		phy->phy_event &= ~EXP_BRCT_CHG;
-		sas_notify_port_event_gfp(sas_phy,
+		sas_notify_port_event(sas_phy,
 				PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		mv_dprintk("phy%d Got Broadcast Change\n", phy_no);
 	}
-- 
2.30.0

