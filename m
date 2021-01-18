Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86A1EC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D72622EBF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389935AbhARVQT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:16:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389244AbhARKN1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7320AC061573;
        Mon, 18 Jan 2021 02:12:40 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964645;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ffKFiIfsdlVoCQPH4teIKyoKFvuwHjXDgJhZnpJWeQ0=;
        b=vx2TRRBgzWA5WmfqgoAjafYaPV5T9Rh14XR9pucsvI1crKZjsp0LZuaSHc5elX1WMMle3f
        hnaukAvESK4kOKtVBh91HosjwwQLoDvC6ALnhOXoRpn7taDJuQDPFGjgeWYiO8hslQRoIk
        0ub80B42h+lKuNnOiV+PkmHpAFdqwX8QB5mDQeI6LKj2Z8C73A03C/UzddYDqEFEU5/2hA
        S4O2A3jT8lASW/jPcDMCqjgDVKzkzSMRmCi28SoXJ4vT22pivnDK6ErZhaAI3E/aGHQT5S
        yUGZuZhhSKoOBbfZ3ZhwJL2DnZRb5Q7VMkS+IhYfIbNAyy1udNDpnQUdhcvryg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ffKFiIfsdlVoCQPH4teIKyoKFvuwHjXDgJhZnpJWeQ0=;
        b=m9Dfo1v0NBO/HPtGAmYNWr2uQ68hyJj6f2y5NP81iYdQcyYGEGrG+3+nMf3Z6hX+/lJqai
        tUtdEitj419M1UBg==
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
Subject: [PATCH v3 08/19] scsi: libsas: Pass gfp_t flags to event notifiers
Date:   Mon, 18 Jan 2021 11:09:44 +0100
Message-Id: <20210118100955.1761652-9-a.darwish@linutronix.de>
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

  - sas_enable_revalidation(): process, acquires mutex
  - sas_resume_ha(): process, calls wait_event_timeout()

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_event.c | 3 ++-
 drivers/scsi/libsas/sas_init.c  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index ba266a17250a..25f3aaea8142 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -109,7 +109,8 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
 
 		sas_phy = container_of(port->phy_list.next, struct asd_sas_phy,
 				port_phy_el);
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy,
+				PORTE_BROADCAST_RCVD, GFP_KERNEL);
 	}
 	mutex_unlock(&ha->disco_mutex);
 }
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index f8ae1f0f17d3..9ce0cd214eb9 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -404,7 +404,8 @@ void sas_resume_ha(struct sas_ha_struct *ha)
 
 		if (phy->suspended) {
 			dev_warn(&phy->phy->dev, "resume timeout\n");
-			sas_notify_phy_event(phy, PHYE_RESUME_TIMEOUT);
+			sas_notify_phy_event_gfp(phy, PHYE_RESUME_TIMEOUT,
+						 GFP_KERNEL);
 		}
 	}
 
-- 
2.30.0

