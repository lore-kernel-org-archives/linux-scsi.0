Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F30B1C35296
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE27C23B70
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388257AbgLRUpi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731972AbgLRUpg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 15:45:36 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DADEC06138C;
        Fri, 18 Dec 2020 12:44:56 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608324294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iVAD+aDlMv+qFojj+svoaj4JfsRPU0GOUX34CODHS0g=;
        b=UJlvRPf9v3+QhaZMLh+anR8EF464ohqGZqW5XZJwujVhCMqqFF7590vNerLtlQnbd3eiam
        aTdc+dugtQdqewEqXPx3RTOjWoG8Dr6EKjLXUrjJGT8jUd61i2llU/7eEq20oU/EGS1xZf
        WrjJQ3rd7PWDraNHaOHp0FEqUb3CvhdGIL8/IlnJD8x6fl2GCtcIKlP0nm1xVHNQZ8rAX8
        H0bPaV/AwYl+9RQHO0k2CRWHklWeacbLn8nstQABBNu3quUgy2RGDzlY1OVo7dwiYs6CVX
        V7la8M7YZNnOiIS84Ql0XIGxqAk2QNSq6hhxtDP1FR6pqoZvHRe0UlS9HWBS3w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608324294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iVAD+aDlMv+qFojj+svoaj4JfsRPU0GOUX34CODHS0g=;
        b=6Obq+kpjZ+QC+Z9f73u5+K3n2thYYnxvlTVpaHY6IympfJC/ed0eOXh99hOlOUZyCohqpc
        pDH4oGkyTyOdfKBA==
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
Subject: [PATCH 11/11] scsi: libsas: event notifiers: Remove non _gfp() variants
Date:   Fri, 18 Dec 2020 21:43:54 +0100
Message-Id: <20201218204354.586951-12-a.darwish@linutronix.de>
In-Reply-To: <20201218204354.586951-1-a.darwish@linutronix.de>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All call-sites of below libsas APIs:

  - sas_alloc_event()
  - sas_ha_struct::notify_port_event()
  - sas_ha_struct::notify_phy_event()

have been converted to use the new _gfp()-suffixed version.

Remove the old APIs from libsas code, headers, and documentation.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 Documentation/scsi/libsas.rst      |  2 -
 drivers/scsi/libsas/sas_event.c    | 72 +++++++-----------------------
 drivers/scsi/libsas/sas_init.c     | 15 +------
 drivers/scsi/libsas/sas_internal.h |  2 -
 include/scsi/libsas.h              |  2 -
 5 files changed, 18 insertions(+), 75 deletions(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index dc85d0e4c107..7e1bf710760b 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -189,8 +189,6 @@ num_phys
 The event interface::
 
 	/* LLDD calls these to notify the class of an event. */
-	void (*notify_port_event)(struct sas_phy *, enum port_event);
-	void (*notify_phy_event)(struct sas_phy *, enum phy_event);
 	void (*notify_port_event_gfp)(struct sas_phy *, enum port_event, gfp_t);
 	void (*notify_phy_event_gfp)(struct sas_phy *, enum phy_event, gfp_t);
 
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 31b733eeabf6..23aeb67f6381 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -131,57 +131,21 @@ static void sas_phy_event_worker(struct work_struct *work)
 	sas_free_event(ev);
 }
 
-static int __sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
-				   struct asd_sas_event *ev)
-{
-	struct sas_ha_struct *ha = phy->ha;
-	int ret;
-
-	BUG_ON(event >= PORT_NUM_EVENTS);
-
-	INIT_SAS_EVENT(ev, sas_port_event_worker, phy, event);
-
-	ret = sas_queue_event(event, &ev->work, ha);
-	if (ret != 1)
-		sas_free_event(ev);
-
-	return ret;
-}
-
 static int sas_notify_port_event_gfp(struct asd_sas_phy *phy,
 				     enum port_event event,
 				     gfp_t gfp_flags)
-{
-	struct asd_sas_event *ev;
-
-	ev = sas_alloc_event_gfp(phy, gfp_flags);
-	if (!ev)
-		return -ENOMEM;
-
-	return __sas_notify_port_event(phy, event, ev);
-}
-
-static int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
-{
-	struct asd_sas_event *ev;
-
-	ev = sas_alloc_event(phy);
-	if (!ev)
-		return -ENOMEM;
-
-	return __sas_notify_port_event(phy, event, ev);
-}
-
-static inline int __sas_notify_phy_event(struct asd_sas_phy *phy,
-					 enum phy_event event,
-					 struct asd_sas_event *ev)
 {
 	struct sas_ha_struct *ha = phy->ha;
+	struct asd_sas_event *ev;
 	int ret;
 
-	BUG_ON(event >= PHY_NUM_EVENTS);
+	BUG_ON(event >= PORT_NUM_EVENTS);
 
-	INIT_SAS_EVENT(ev, sas_phy_event_worker, phy, event);
+	ev = sas_alloc_event_gfp(phy, gfp_flags);
+	if (!ev)
+		return -ENOMEM;
+
+	INIT_SAS_EVENT(ev, sas_port_event_worker, phy, event);
 
 	ret = sas_queue_event(event, &ev->work, ha);
 	if (ret != 1)
@@ -193,31 +157,27 @@ static inline int __sas_notify_phy_event(struct asd_sas_phy *phy,
 int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
 			     gfp_t gfp_flags)
 {
+	struct sas_ha_struct *ha = phy->ha;
 	struct asd_sas_event *ev;
+	int ret;
+
+	BUG_ON(event >= PHY_NUM_EVENTS);
 
 	ev = sas_alloc_event_gfp(phy, gfp_flags);
 	if (!ev)
 		return -ENOMEM;
 
-	return __sas_notify_phy_event(phy, event, ev);
-}
+	INIT_SAS_EVENT(ev, sas_phy_event_worker, phy, event);
 
-int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
-{
-	struct asd_sas_event *ev;
+	ret = sas_queue_event(event, &ev->work, ha);
+	if (ret != 1)
+		sas_free_event(ev);
 
-	ev = sas_alloc_event(phy);
-	if (!ev)
-		return -ENOMEM;
-
-	return __sas_notify_phy_event(phy, event, ev);
+	return ret;
 }
 
 int sas_init_events(struct sas_ha_struct *sas_ha)
 {
-	sas_ha->notify_port_event = sas_notify_port_event;
-	sas_ha->notify_phy_event = sas_notify_phy_event;
-
 	sas_ha->notify_port_event_gfp = sas_notify_port_event_gfp;
 	sas_ha->notify_phy_event_gfp = sas_notify_phy_event_gfp;
 
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 2d2116f827c6..e08351f909fb 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -590,8 +590,8 @@ sas_domain_attach_transport(struct sas_domain_function_template *dft)
 }
 EXPORT_SYMBOL_GPL(sas_domain_attach_transport);
 
-static struct asd_sas_event * __sas_alloc_event(struct asd_sas_phy *phy,
-						gfp_t gfp_flags)
+struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
+					  gfp_t gfp_flags)
 {
 	struct asd_sas_event *event;
 	struct sas_ha_struct *sas_ha = phy->ha;
@@ -623,17 +623,6 @@ static struct asd_sas_event * __sas_alloc_event(struct asd_sas_phy *phy,
 	return event;
 }
 
-struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
-{
-	return __sas_alloc_event(phy, in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
-}
-
-struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
-					  gfp_t gfp_flags)
-{
-	return __sas_alloc_event(phy, gfp_flags);
-}
-
 void sas_free_event(struct asd_sas_event *event)
 {
 	struct asd_sas_phy *phy = event->phy;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 437a697b6f73..b0422d47675b 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -48,7 +48,6 @@ int sas_show_oob_mode(enum sas_oob_mode oob_mode, char *buf);
 int  sas_register_phys(struct sas_ha_struct *sas_ha);
 void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 
-struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy);
 struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy, gfp_t gfp_flags);
 void sas_free_event(struct asd_sas_event *event);
 
@@ -78,7 +77,6 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 			enum phy_func phy_func, struct sas_phy_linkrates *);
 int sas_smp_get_phy_events(struct sas_phy *phy);
 
-int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
 int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event, gfp_t flags);
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index f7c2530bbd9d..fdd338fa65c9 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -392,8 +392,6 @@ struct sas_ha_struct {
 				* their siblings when forming wide ports */
 
 	/* LLDD calls these to notify the class of an event. */
-	int (*notify_port_event)(struct asd_sas_phy *, enum port_event);
-	int (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
 	int (*notify_port_event_gfp)(struct asd_sas_phy *, enum port_event, gfp_t);
 	int (*notify_phy_event_gfp)(struct asd_sas_phy *, enum phy_event, gfp_t);
 
-- 
2.29.2

