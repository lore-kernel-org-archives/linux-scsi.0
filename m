Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CB9C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 674FA229C6
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389745AbhARVOR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:14:17 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55220 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389750AbhARKN2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:28 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/UXteJ4q1RUvbDYgjdibBzKfEcwwMRlj+E7dvre1TI0=;
        b=pAqmAlg1z7mJ+SViKIpMJGSPkSknvLg8+gCfWhK/NRenAFZPKzb0j2sKy+GRDZjkwNOogm
        IcT7MdKYlqgJ5Xg0KFqdEhxpYD0r81nQUZJRx5A7/mQadalPTAqkY/2qoGmHxPh9IzddTI
        IkGGriiXMZ4Ta3F5mq9DuPndXKjllNP069RGeKLvJJmsuPO/5J8vbbKoKK9B4A257qf882
        OeAdRjIRt/jqdIW0I3CxYqAROBZ/sMrnKXgo8sOzT22sNAdUNfCLZZQRgYo58D4jLPzziv
        kFbRyzv6MqRit2iiq7zD7VGllcBeMoDKbHZe9Ea4+DuCKXfIWJv8cTgxi+62KQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/UXteJ4q1RUvbDYgjdibBzKfEcwwMRlj+E7dvre1TI0=;
        b=ehG/U/01RZlEXQDkzKHw3AFchjNZA+XgsHlywWTQuQ1TkxMP6ntbv6Tahk9Dsh/V7y8p1N
        aQL5x0wwy2qvKNBg==
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
Subject: [PATCH v3 16/19] scsi: libsas: Switch back to original event notifiers API
Date:   Mon, 18 Jan 2021 11:09:52 +0100
Message-Id: <20210118100955.1761652-17-a.darwish@linutronix.de>
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

Switch back to the original event notifiers API, while still passing GFP
context.  The _gfp() notifier variants will be removed afterwards.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_event.c | 6 +++---
 drivers/scsi/libsas/sas_init.c  | 8 ++++----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 3d0cc407b33f..542831887769 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -109,7 +109,7 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
 
 		sas_phy = container_of(port->phy_list.next, struct asd_sas_phy,
 				port_phy_el);
-		sas_notify_port_event_gfp(sas_phy,
+		sas_notify_port_event(sas_phy,
 				PORTE_BROADCAST_RCVD, GFP_KERNEL);
 	}
 	mutex_unlock(&ha->disco_mutex);
@@ -141,7 +141,7 @@ int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
 
 	BUG_ON(event >= PORT_NUM_EVENTS);
 
-	ev = sas_alloc_event_gfp(phy, gfp_flags);
+	ev = sas_alloc_event(phy, gfp_flags);
 	if (!ev)
 		return -ENOMEM;
 
@@ -171,7 +171,7 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
 
 	BUG_ON(event >= PHY_NUM_EVENTS);
 
-	ev = sas_alloc_event_gfp(phy, gfp_flags);
+	ev = sas_alloc_event(phy, gfp_flags);
 	if (!ev)
 		return -ENOMEM;
 
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index f06b83211e3b..62260e84ca2d 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -404,8 +404,8 @@ void sas_resume_ha(struct sas_ha_struct *ha)
 
 		if (phy->suspended) {
 			dev_warn(&phy->phy->dev, "resume timeout\n");
-			sas_notify_phy_event_gfp(phy, PHYE_RESUME_TIMEOUT,
-						 GFP_KERNEL);
+			sas_notify_phy_event(phy, PHYE_RESUME_TIMEOUT,
+					     GFP_KERNEL);
 		}
 	}
 
@@ -604,8 +604,8 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy,
 			if (cmpxchg(&phy->in_shutdown, 0, 1) == 0) {
 				pr_notice("The phy%d bursting events, shut it down.\n",
 					  phy->id);
-				sas_notify_phy_event_gfp(phy, PHYE_SHUTDOWN,
-							 gfp_flags);
+				sas_notify_phy_event(phy, PHYE_SHUTDOWN,
+						     gfp_flags);
 			}
 		} else {
 			/* Do not support PHY control, stop allocating events */
-- 
2.30.0

