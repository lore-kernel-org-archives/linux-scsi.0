Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71454C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 458E222D6E
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437643AbhARVPf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389749AbhARKN1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14BDFC0613C1;
        Mon, 18 Jan 2021 02:12:46 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xqHw2udYdfrv+Zy2Tozyr68OvQ7itsLtdUshJ43k/3Y=;
        b=CGjdiavR5s9vxvT5iQCrmSRmh/F0NUugQmaPNV8KWhghUXv1UcApccpmoCp/HkdVymTOUb
        gE3G5fbmrXpMrok+Op/hjFOcX1wBL4aQIzIq5XsYgARCbKoR2pH83vuc+G7jVLlMxa1zko
        m8nst3d76vxM7thBGsxaUW+DeoeYEjOLcXXUnSa5bqCSN+/K+EeCqUeisKvRwYdtrcsUFY
        zPAFlIpwDVykjL1TymmcHRVxhYz6XWhyqxitmBbkZuyAGpMtwaSdx4RKthRhEGbBM9Bx7R
        jjkqB1LQn9dJnuNuDh7LQjJZBzfHMffY6siTR0c9/KZMprmXxDWoTOzd5e0+xw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xqHw2udYdfrv+Zy2Tozyr68OvQ7itsLtdUshJ43k/3Y=;
        b=l6Zd9y4PKvSi7T+L5mA111083/IlaXpTkWzQYz8OA4G25CrnBJ8LI/UZ0p4G+ssUzPMvZs
        q1cFfz/uPl96/sDg==
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
Subject: [PATCH v3 14/19] scsi: aic94xx: Switch back to original libsas event notifiers
Date:   Mon, 18 Jan 2021 11:09:50 +0100
Message-Id: <20210118100955.1761652-15-a.darwish@linutronix.de>
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
 drivers/scsi/aic94xx/aic94xx_scb.c | 29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 76a4c21144d8..68214a58b160 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -80,8 +80,8 @@ static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 		ASD_DPRINTK("phy%d: device unplugged\n", phy_id);
 		asd_turn_led(asd_ha, phy_id, 0);
 		sas_phy_disconnected(&phy->sas_phy);
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL,
-					 GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_LOSS_OF_SIGNAL,
+				     GFP_ATOMIC);
 		break;
 	case CURRENT_OOB_DONE:
 		/* hot plugged device */
@@ -89,14 +89,13 @@ static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 		get_lrate_mode(phy, oob_mode);
 		ASD_DPRINTK("phy%d device plugged: lrate:0x%x, proto:0x%x\n",
 			    phy_id, phy->sas_phy.linkrate, phy->sas_phy.iproto);
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_DONE,
-					 GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 		break;
 	case CURRENT_SPINUP_HOLD:
 		/* hot plug SATA, no COMWAKE sent */
 		asd_turn_led(asd_ha, phy_id, 1);
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_SPINUP_HOLD,
-					 GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_SPINUP_HOLD,
+				     GFP_ATOMIC);
 		break;
 	case CURRENT_GTO_TIMEOUT:
 	case CURRENT_OOB_ERROR:
@@ -104,8 +103,7 @@ static void asd_phy_event_tasklet(struct asd_ascb *ascb,
 			    dl->status_block[1]);
 		asd_turn_led(asd_ha, phy_id, 0);
 		sas_phy_disconnected(&phy->sas_phy);
-		sas_notify_phy_event_gfp(&phy->sas_phy, PHYE_OOB_ERROR,
-					 GFP_ATOMIC);
+		sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_ERROR, GFP_ATOMIC);
 		break;
 	}
 }
@@ -236,7 +234,7 @@ static void asd_bytes_dmaed_tasklet(struct asd_ascb *ascb,
 	spin_unlock_irqrestore(&phy->sas_phy.frame_rcvd_lock, flags);
 	asd_dump_frame_rcvd(phy, dl);
 	asd_form_port(ascb->ha, phy);
-	sas_notify_port_event_gfp(&phy->sas_phy, PORTE_BYTES_DMAED, GFP_ATOMIC);
+	sas_notify_port_event(&phy->sas_phy, PORTE_BYTES_DMAED, GFP_ATOMIC);
 }
 
 static void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
@@ -272,7 +270,7 @@ static void asd_link_reset_err_tasklet(struct asd_ascb *ascb,
 	asd_turn_led(asd_ha, phy_id, 0);
 	sas_phy_disconnected(sas_phy);
 	asd_deform_port(asd_ha, phy);
-	sas_notify_port_event_gfp(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
+	sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, GFP_ATOMIC);
 
 	if (retries_left == 0) {
 		int num = 1;
@@ -317,8 +315,8 @@ static void asd_primitive_rcvd_tasklet(struct asd_ascb *ascb,
 			spin_lock_irqsave(&sas_phy->sas_prim_lock, flags);
 			sas_phy->sas_prim = ffs(cont);
 			spin_unlock_irqrestore(&sas_phy->sas_prim_lock, flags);
-			sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD,
-						  GFP_ATOMIC);
+			sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD,
+					      GFP_ATOMIC);
 			break;
 
 		case LmUNKNOWNP:
@@ -339,8 +337,8 @@ static void asd_primitive_rcvd_tasklet(struct asd_ascb *ascb,
 			/* The sequencer disables all phys on that port.
 			 * We have to re-enable the phys ourselves. */
 			asd_deform_port(asd_ha, phy);
-			sas_notify_port_event_gfp(sas_phy, PORTE_HARD_RESET,
-						  GFP_ATOMIC);
+			sas_notify_port_event(sas_phy, PORTE_HARD_RESET,
+					      GFP_ATOMIC);
 			break;
 
 		default:
@@ -571,8 +569,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		/* the device is gone */
 		sas_phy_disconnected(sas_phy);
 		asd_deform_port(asd_ha, phy);
-		sas_notify_port_event_gfp(sas_phy, PORTE_TIMER_EVENT,
-					  GFP_ATOMIC);
+		sas_notify_port_event(sas_phy, PORTE_TIMER_EVENT, GFP_ATOMIC);
 		break;
 	default:
 		ASD_DPRINTK("%s: phy%d: unknown event:0x%x\n", __func__,
-- 
2.30.0

