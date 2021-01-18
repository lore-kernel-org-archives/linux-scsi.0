Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17BEDC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1840229C6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394514AbhARVOO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:14:14 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55208 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389246AbhARKN2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:28 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iM+RgOikwGYn7inLq65ouZEt13gCzx3kP4vu3Puyl6c=;
        b=Lz9lt2eXy+VIElxgJszHBwNiQlaShSREtKo1+DNn42TXJcYa79ySOgG0e0fOU8hWmwKrs+
        GcVsc57skKuUlCWAeHDs9YBWJqwv91OrQ3F/NypCa/a0Fo8cl/NAQgo9ps4P1elcFwPmQn
        rW7L1dNaze/qI+9H9/y9/OEX9JPf3Sf8ghwKPMA3Ujaw7vE15/aRilMXCqMIiR+p8t4Vwc
        lmcESjGkWSaziiiz8bTURxH/OGm2P1TxBuQCPAiNwkRgtGHp0iS5sNMD5dv94gb2QUXoRk
        W4meF+qWjuA3mhuhJ9hdQ5W7GmucaIjoxXHYRpfHhLwOWufW3To/f6GGx5IosQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iM+RgOikwGYn7inLq65ouZEt13gCzx3kP4vu3Puyl6c=;
        b=4lTLgNF5kRzS+J50a3eLGP25dLR9u1cFMsT/ErpL01JYtfgFsKSmKQHFmlvC9IgJ2l3FoA
        1i3ee4HA0/UsjiCg==
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
Subject: [PATCH v3 10/19] scsi: aic94xx: Pass gfp_t flags to libsas event notifiers
Date:   Mon, 18 Jan 2021 11:09:46 +0100
Message-Id: <20210118100955.1761652-11-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the new libsas event notifiers API, which requires callers to
explicitly pass the gfp_t memory allocation flags.

Context analysis:

  aic94xx_hwi.c: asd_dl_tasklet_handler()
    -> asd_ascb::tasklet_complete()
    == escb_tasklet_complete()
      -> aic94xx_scb.c: asd_phy_event_tasklet()
      -> aic94xx_scb.c: asd_bytes_dmaed_tasklet()
      -> aic94xx_scb.c: asd_link_reset_err_tasklet()
      -> aic94xx_scb.c: asd_primitive_rcvd_tasklet()

All functions are invoked by escb_tasklet_complete(), which is invoked
by the tasklet handler. Pass GFP_ATOMIC.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/aic94xx/aic94xx_scb.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 770546177ca4..76a4c21144d8 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -80,7 +80,8 @@ static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 		ASD_DPRINTK("phy%d: device unplugged\n", phy_id);
 		asd_turn_led(asd_ha, phy_id, 0);
 		sas_phy_disconnected(&phy->sas_phy);
-		sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL);
+		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL,
+					 GFP_ATOMIC);
 		break;
 	case CURRENT_OOB_DONE:
 		/* hot plugged device */
@@ -88,12 +89,14 @@ static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 		get_lrate_mode(phy, oob_mode);
 		ASD_DPRINTK("phy%d device plugged: lrate:0x%x, proto:0x%x\n",
 			    phy_id, phy->sas_phy.linkrate, phy->sas_phy.iproto);
-		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE);
+		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE,
+					 GFP_ATOMIC);
 		break;
 	case CURRENT_SPINUP_HOLD:
 		/* hot plug SATA, no COMWAKE sent */
 		asd_turn_led(asd_ha, phy_id, 1);
-		sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD);
+		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD,
+					 GFP_ATOMIC);
 		break;
 	case CURRENT_GTO_TIMEOUT:
 	case CURRENT_OOB_ERROR:
@@ -101,7 +104,8 @@ static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 			    dl->status_block[1]);
 		asd_turn_led(asd_ha, phy_id, 0);
 		sas_phy_disconnected(&phy->sas_phy);
-		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR);
+		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR,
+					 GFP_ATOMIC);
 		break;
 	}
 }
@@ -232,7 +236,7 @@ static void asd_bytes_dmaed_tasklet(struct asd_ascb *ascb,
 	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
 	asd_dump_frame_rcvd(phy, dl);
 	asd_form_port(ascb->ha, phy);
-	sas_notify_port_event(&phy->sas_phy, PORTE_BYTES_DMAED);
+	sas_notify_port_event_gfp(&phy->sas_phy, PORTE_BYTES_DMAED, GFP_ATOMIC);
 }
 
 static void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
@@ -268,7 +272,7 @@ static void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
 	asd_turn_led(asd_ha, phy_id, 0);
 	sas_phy_disconnected(sas_phy);
 	asd_deform_port(asd_ha, phy);
-	sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR);
+	sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 
 	if (retries_left == 0) {
 		int num = 1;
@@ -313,7 +317,8 @@ static void asd_primitive_rcvd_tasklet(struct asd_ascb *ascb,
 			spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 			sas_phy->sas_prim = ffs(cont);
 			spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-			sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+			sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
+						  GFP_ATOMIC);
 			break;
 
 		case LmUNKNOWNP:
@@ -334,7 +339,8 @@ static void asd_primitive_rcvd_tasklet(struct asd_ascb *ascb,
 			/* The sequencer disables all phys on that port.
 			 * We have to re-enable the phys ourselves. */
 			asd_deform_port(asd_ha, phy);
-			sas_notify_port_event(sas_phy, PORTE_HARD_RESET);
+			sas_notify_port_event_gfp(sas_phy, PORTE_HARD_RESET,
+						  GFP_ATOMIC);
 			break;
 
 		default:
@@ -565,7 +571,8 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		/* the device is gone */
 		sas_phy_disconnected(sas_phy);
 		asd_deform_port(asd_ha, phy);
-		sas_notify_port_event(sas_phy, PORTE_TIMER_EVENT);
+		sas_notify_port_event_gfp(sas_phy, PORTE_TIMER_EVENT,
+					  GFP_ATOMIC);
 		break;
 	default:
 		ASD_DPRINTK("%s: phy%d: unknown event:0x%x\n", __func__,
-- 
2.30.0

