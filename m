Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A048FC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 518352310C
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732674AbhALLIt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbhALLIs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:08:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64994C0617A4;
        Tue, 12 Jan 2021 03:08:08 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610449686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oselqt4ZgrYmxaaSMDbxPxMVkm0XVJQ5rMdIZRjd8SQ=;
        b=Ih6v4Syws19oXQpIy3TYhOEsR6tpUJMvZTsBrq9R2N55cDbeRMM17mVfmlArhWTo7UMtye
        jgvY4/DO0rhqYnYrtkgLHxDbXpt1M+8VeM7tVFU3Paay/wo/qJWm2oqYmu+7/bgPAVyqkD
        aBprRqhn8CfmThtTlDfofC27j4D99GO5ifOJFsV8UBQ+vd4QH47yO9wCLDSHXAr5hQvLM5
        qZ6pAlwsf5HUvoemGLQNnhJ+GNSsE/h1V1adkiWx6uH8Ec8dDF1rA3xGLkEYdKde6wZv0V
        NF1aNI+fzfLpDepD2WthO+LXo4Ui0cZAoVt+wYvahnG6pnpOhgIuc/dAeVxotw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610449686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oselqt4ZgrYmxaaSMDbxPxMVkm0XVJQ5rMdIZRjd8SQ=;
        b=VKCl6+GIPtUtCE7z2STzWWRCdvTPEE5/GT8DjuU/kc8QyHBhyyOvHyZxTRpKVGLjPbk227
        nH7PFznh2Yr4XpDg==
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     linux-scsi@vger.kernel.org, intel-linux-scu@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH v2 16/19] scsi: libsas: Switch back to original event notifiers API
Date:   Tue, 12 Jan 2021 12:06:44 +0100
Message-Id: <20210112110647.627783-17-a.darwish@linutronix.de>
In-Reply-To: <20210112110647.627783-1-a.darwish@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
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
Cc: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_event.c | 6 +++---
 drivers/scsi/libsas/sas_init.c  | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

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
index 0dc38385ecbd..30dd35eb9449 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -404,7 +404,7 @@ void sas_resume_ha(struct sas_ha_struct *ha)
 
 		if (phy->suspended) {
 			dev_warn(&phy->phy->dev, "resume timeout\n");
-			sas_notify_phy_event_gfp(phy, PHYE_RESUME_TIMEOUT, GFP_KERNEL);
+			sas_notify_phy_event(phy, PHYE_RESUME_TIMEOUT, GFP_KERNEL);
 		}
 	}
 
@@ -603,7 +603,7 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy,
 			if (cmpxchg(&phy->in_shutdown, 0, 1) == 0) {
 				pr_notice("The phy%d bursting events, shut it down.\n",
 					  phy->id);
-				sas_notify_phy_event_gfp(phy, PHYE_SHUTDOWN, gfp_flags);
+				sas_notify_phy_event(phy, PHYE_SHUTDOWN, gfp_flags);
 			}
 		} else {
 			/* Do not support PHY control, stop allocating events */
-- 
2.30.0

