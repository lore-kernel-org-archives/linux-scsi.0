Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0480C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B57B722E00
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:33:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389591AbhARV0u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389308AbhARKLJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:11:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB78C061573;
        Mon, 18 Jan 2021 02:10:23 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fWch7q4X9I9Uk59vgur/xC+IuR+UeFD+mvuJnp1FdCw=;
        b=AVq9smyoqXl8QRQOILIrev2nt++sD4ifNl5b+wxPpM4RXcxQgOoWOPbnzxEuTp/F7Aq+qE
        fkb+PMWd2gi3SRF5v0TMJzCdmwTjC2iDDevLiEHDpnOZzGFAnIJBHCNaWqj+LscLThbj3l
        SrsoTFmuCr1PDDFQoBIRUppREiXgvquPYKcxXXUJNDl6PevyKLWF1Qg9eREG11FwBOemLy
        QYHQOXBucuK4FXMMwTqcUlvNgIB9bnPKtRlRJHkMyd3p0JgFUlglvGVzgqIbDZgHUo55Hp
        yZJEpQQDL6hf7PAQqzBuoYpjfBPyp1oAoeZ4hV87UtJRm+30T0O1/ECazpQNTA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964620;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fWch7q4X9I9Uk59vgur/xC+IuR+UeFD+mvuJnp1FdCw=;
        b=igLcECIwHI0B+U9Ie7aRiZWOKOBgFmoUoTj0BNOQJXrBKebtkqTOXwT5kIaJVMB1vXQ+Ed
        3aB70g4NEF5+z6BA==
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
Subject: [PATCH v3 04/19] scsi: mvsas: Pass gfp_t flags to libsas event notifiers
Date:   Mon, 18 Jan 2021 11:09:40 +0100
Message-Id: <20210118100955.1761652-5-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

mvsas calls the non _gfp version of the libsas event notifiers API,
leading to the buggy call chains below:

  mvsas/mv_sas.c: mvs_work_queue() [process context]
  spin_lock_irqsave(mvs_info::lock, )
    -> libsas/sas_event.c: sas_notify_phy_event()
      -> sas_alloc_event()
        -> in_interrupt() = false
          -> invalid GFP_KERNEL allocation
    -> libsas/sas_event.c: sas_notify_port_event()
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

Fixes: 1c393b970e0f ("scsi: libsas: Use dynamic alloced work to avoid sas event lost")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/mvsas/mv_sas.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index e5e3e95f78b0..484e01428da2 100644
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
@@ -229,7 +229,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 		return;
 	}
 
-	sas_notify_phy_event(sas_phy, PHYE_OOB_DONE);
+	sas_notify_phy_event_gfp(sas_phy, PHYE_OOB_DONE, gfp_flags);
 
 	if (sas_phy->phy) {
 		struct sas_phy *sphy = sas_phy->phy;
@@ -261,7 +261,7 @@ static void mvs_bytes_dmaed(struct mvs_info *mvi, int i)
 
 	sas_phy->frame_rcvd_size = phy->frame_rcvd_size;
 
-	sas_notify_port_event(sas_phy, PORTE_BYTES_DMAED);
+	sas_notify_port_event_gfp(sas_phy, PORTE_BYTES_DMAED, gfp_flags);
 }
 
 void mvs_scan_start(struct Scsi_Host *shost)
@@ -277,7 +277,7 @@ void mvs_scan_start(struct Scsi_Host *shost)
 	for (j = 0; j < core_nr; j++) {
 		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[j];
 		for (i = 0; i < mvi->chip->n_phy; ++i)
-			mvs_bytes_dmaed(mvi, i);
+			mvs_bytes_dmaed(mvi, i, GFP_KERNEL);
 	}
 	mvs_prv->scan_finished = 1;
 }
@@ -1892,20 +1892,21 @@ static void mvs_work_queue(struct work_struct *work)
 			if (!(tmp & PHY_READY_MASK)) {
 				sas_phy_disconnected(sas_phy);
 				mvs_phy_disconnected(phy);
-				sas_notify_phy_event(sas_phy,
-					PHYE_LOSS_OF_SIGNAL);
+				sas_notify_phy_event_gfp(sas_phy,
+					PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
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
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy,
+				PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 		mv_dprintk("phy%d Got Broadcast Change\n", phy_no);
 	}
 	list_del(&mwq->entry);
@@ -2022,7 +2023,7 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
 				mdelay(10);
 			}
 
-			mvs_bytes_dmaed(mvi, phy_no);
+			mvs_bytes_dmaed(mvi, phy_no, GFP_ATOMIC);
 			/* whether driver is going to handle hot plug */
 			if (phy->phy_event & PHY_PLUG_OUT) {
 				mvs_port_notify_formed(&phy->sas_phy, 0);
-- 
2.30.0

