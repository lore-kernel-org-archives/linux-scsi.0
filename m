Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5DD2C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 10:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E7A32222F
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 10:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389183AbhARKsV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 05:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389753AbhARKNa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:30 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B484C0613D3;
        Mon, 18 Jan 2021 02:12:49 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yewws0s6s3/xuCM1cWNhQ98mFYo9ii8BH+uQAWu4Oo4=;
        b=OTOZq5CsdtFsbsnCvZJw2i0TQrGOwFvOVj//JwDcuvxNUmDNPSiLgYR+5t/6toqrFVc7QS
        L90AicuyqKvV7qZW3KKL5hm+Ac75V+VNysRSVJa42OqPdkFyZcL7Na0zerkkT5hEG1FpGu
        VbD2ddPYUCQp9SoRQFQkfdLox1pEA097wkn7xOxL2gJwXed1OPRkSRCy5wan1cYp1S9Fls
        gXqcB15R09FeKCZjDqGk7G3hHz3KyggRfFmxM5qs5A1vHKvHThX+9Rl6VT367Gj/6gkcMJ
        +MIuO/YNUDgLO6BZDi6Bq7RTbm8aulArqHEehZdlcxZSdgYrWXOijauhjOuJMg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yewws0s6s3/xuCM1cWNhQ98mFYo9ii8BH+uQAWu4Oo4=;
        b=Emv3JrlRdpAqT9VOyXO0/sgAH5YjfXe7YwkCtryMgzPh3SPw/4HCZqFT5TykOfu8aunHYk
        4dQ1YonUvjxyHEBg==
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
Subject: [PATCH v3 17/19] scsi: isci: Switch back to original libsas event notifiers
Date:   Mon, 18 Jan 2021 11:09:53 +0100
Message-Id: <20210118100955.1761652-18-a.darwish@linutronix.de>
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
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
---
 drivers/scsi/isci/port.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/isci/port.c b/drivers/scsi/isci/port.c
index e50c3b0deeb3..448a8c31ba35 100644
--- a/drivers/scsi/isci/port.c
+++ b/drivers/scsi/isci/port.c
@@ -164,8 +164,8 @@ static void isci_port_bc_change_received(struct isci_host *ihost,
 		"%s: isci_phy = %p, sas_phy = %p\n",
 		__func__, iphy, &iphy->sas_phy);
 
-	sas_notify_port_event_gfp(&iphy->sas_phy,
-				  PORTE_BROADCAST_RCVD, GFP_ATOMIC);
+	sas_notify_port_event(&iphy->sas_phy,
+			      PORTE_BROADCAST_RCVD, GFP_ATOMIC);
 	sci_port_bcn_enable(iport);
 }
 
@@ -224,8 +224,8 @@ static void isci_port_link_up(struct isci_host *isci_host,
 	/* Notify libsas that we have an address frame, if indeed
 	 * we've found an SSP, SMP, or STP target */
 	if (success)
-		sas_notify_port_event_gfp(&iphy->sas_phy,
-					  PORTE_BYTES_DMAED, GFP_ATOMIC);
+		sas_notify_port_event(&iphy->sas_phy,
+				      PORTE_BYTES_DMAED, GFP_ATOMIC);
 }
 
 
@@ -271,8 +271,8 @@ static void isci_port_link_down(struct isci_host *isci_host,
 	 * isci_port_deformed and isci_dev_gone functions.
 	 */
 	sas_phy_disconnected(&isci_phy->sas_phy);
-	sas_notify_phy_event_gfp(&isci_phy->sas_phy,
-				 PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
+	sas_notify_phy_event(&isci_phy->sas_phy,
+			     PHYE_LOSS_OF_SIGNAL, GFP_ATOMIC);
 
 	dev_dbg(&isci_host->pdev->dev,
 		"%s: isci_port = %p - Done\n", __func__, isci_port);
-- 
2.30.0

