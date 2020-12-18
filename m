Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49AECC4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083F523B6C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387629AbgLRUox (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:44:53 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54742 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgLRUox (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 15:44:53 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608324250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B9KcC1ajSdpj1hcMeoRWEPKCmZCap2GoxTUAs6kkrxU=;
        b=NFj9wLymGRnMqBpq2jBjrmpyzDFTz3ldaAG67WxkMQ2txOgUGK+iDqui8jDj94DK7S+UjS
        FBvUPbSf+ZljYh7S2w9PpwQB9X4Z6pVD3YMamyrxcc6oOxXIHIuiY6tyhWwmXlJBqYLkVU
        5NeqXuFD9ARAXzCdrrGbZ41ZYF5J7mhLC+qhOZjDmZM8z6zecyTfGTemKOQnVt73u3DTNj
        5abheIi0NLchI+vMPFABkSzvvB5tEYy/ehZr1kCij2Db6VGlkcWq+4lOu+fBoHK1vQ/s4J
        NvzlL1FDCeHmlzS9gdZgnDdlhrXzyLXzVbFa7heuRArtcoND+ssAtpZhIj/+uQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608324250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B9KcC1ajSdpj1hcMeoRWEPKCmZCap2GoxTUAs6kkrxU=;
        b=dBBzYaGQ2STnvNEWRUSa4ArHbAbFSSrEv9ZVAAWkGcOX6a2lnInl8+8XfgoWS4haNDHjWS
        YP8xnB6vLE0xKhCA==
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
Subject: [PATCH 03/11] scsi: mvsas: Pass gfp_t flags to libsas event notifiers
Date:   Fri, 18 Dec 2020 21:43:46 +0100
Message-Id: <20201218204354.586951-4-a.darwish@linutronix.de>
In-Reply-To: <20201218204354.586951-1-a.darwish@linutronix.de>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

mvsas calls the non _gfp version of the libsas event notifiers API,
leading to the buggy call chains below:

  mvsas/mv_sas.c :: mvs_work_queue() [process context]
  spin_lock_irqsave(mvs_info::lock, )
    -> sas_ha->notify_phy_event()
    == libsas/sas_event.c :: sas_notify_phy_event()
      -> sas_alloc_event()
        -> in_interrupt() = false
          -> invalid GFP_KERNEL allocation
    -> sas_ha->notify_port_event()
    == libsas/sas_event.c :: sas_notify_port_event()
      -> sas_alloc_event()
        -> in_interrupt() = false
          -> invalid GFP_KERNEL allocation

Use the new event notifiers API instead, which requires callers to
explicitly pass the gfp_t memory allocation flags.

Below are context analysis for the modified functions:

=> mvs_bytes_dmaed():

Since it is invoked from both process and atomic contexts, let its
callers pass the gfp_t flags. Call chains:

  scsi_scan.c: do_scsi_scan_host() [has msleep()]
    -> shost->hostt->scan_start()
    -> [mvsas/mv_init.c: Scsi_Host::scsi_host_template .scan_start = mvs_scan_start()]
    -> mvsas/mv_sas.c: mvs_scan_start()
      -> mvs_bytes_dmaed(..., GFP_KERNEL)

  mvsas/mv_sas.c: mvs_work_queue()
  spin_lock_irqsave(mvs_info::lock,)
    -> mvs_bytes_dmaed(..., GFP_ATOMIC)

  mvsas/mv_64xx.c: mvs_64xx_isr() || mvsas/mv_94xx.c: mvs_94xx_isr()
    -> mvsas/mv_chips.h: mvs_int_full()
      -> mvsas/mv_sas.c: mvs_int_port()
        -> mvs_bytes_dmaed(..., GFP_ATOMIC);

=> mvs_work_queue():

Invoked from process context, but it calls all the libsas event notifier
APIs under a spin_lock_irqsave(). Pass GFP_ATOMIC.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: stable@vger.kernel.org
Cc: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/mvsas/mv_sas.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a920eced92ec..30a34c5bdf6b 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -216,7 +216,7 @@ void mvs_set_sas_addr(struct mvs_info *mvi, int port_id, u32 off_lo,
 	MVS_CHIP_DISP->write_port_cfg_data(mvi, port_id, hi);
 }
 
-static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
+static void mvs_bytes_dmaed(struct mvs_info *mvi, int i, gfp_t gfp_flags)
 {
 	struct mvs_phy *phy = &mvi->phy[i];
 	struct asd_sas_phy *sas_phy = &phy->sas_phy;
@@ -230,7 +230,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 	}
 
 	sas_ha = mvi->sas;
-	sas_ha->notify_phy_event(sas_phy, PHYE_OOB_DONE);
+	sas_ha->notify_phy_event_gfp(sas_phy, PHYE_OOB_DONE, gfp_flags);
 
 	if (sas_phy->phy) {
 		struct sas_phy *sphy = sas_phy->phy;
@@ -262,8 +262,8 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
 
-	mvi->sas->notify_port_event(sas_phy,
-				   PORTE_BYTES_DMAED);
+	mvi->sas->notify_port_event_gfp(sas_phy,
+					PORTE_BYTES_DMAED, gfp_flags);
 }
 
 void mvs_scan_start(struct Scsi_Host *shost)
@@ -279,7 +279,7 @@ void mvs_scan_start(struct Scsi_Host *shost)
 	for (j = 0; j < core_nr; j++) {
 		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[j];
 		for (i = 0; i < mvi->chip->n_phy; ++i)
-			mvs_bytes_dmaed(mvi, i);
+			mvs_bytes_dmaed(mvi, i, GFP_KERNEL);
 	}
 	mvs_prv->scan_finished = 1;
 }
@@ -1895,21 +1895,21 @@ static void mvs_work_queue(struct work_struct *work)
 			if (!(tmp & PHY_READY_MASK)) {
 				sas_phy_disconnected(sas_phy);
 				mvs_phy_disconnected(phy);
-				sas_ha->notify_phy_event(sas_phy,
-					PHYE_LOSS_OF_SIGNAL);
+				sas_ha->notify_phy_event_gfp(sas_phy,
+							     PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 				mv_dprintk("phy%d Removed Device\n", phy_no);
 			} else {
 				MVS_CHIP_DISP->detect_porttype(mvi, phy_no);
 				mvs_update_phyinfo(mvi, phy_no, 1);
-				mvs_bytes_dmaed(mvi, phy_no);
+				mvs_bytes_dmaed(mvi, phy_no, GFP_ATOMIC);
 				mvs_port_notify_formed(sas_phy, 0);
 				mv_dprintk("phy%d Attached Device\n", phy_no);
 			}
 		}
 	} else if (mwq->handler & EXP_BRCT_CHG) {
 		phy->phy_event &= ~EXP_BRCT_CHG;
-		sas_ha->notify_port_event(sas_phy,
-				PORTE_BROADCAST_RCVD);
+		sas_ha->notify_port_event_gfp(sas_phy,
+					      PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		mv_dprintk("phy%d Got Broadcast Change\n", phy_no);
 	}
 	list_del(&mwq->entry);
@@ -2026,7 +2026,7 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 				mdelay(10);
 			}
 
-			mvs_bytes_dmaed(mvi, phy_no);
+			mvs_bytes_dmaed(mvi, phy_no, GFP_ATOMIC);
 			/* whether driver is going to handle hot plug */
 			if (phy->phy_event & PHY_PLUG_OUT) {
 				mvs_port_notify_formed(&phy->sas_phy, 0);
-- 
2.29.2

