Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06E11C3526C
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:44:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B6D23B9B
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:44:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387614AbgLRUos (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgLRUor (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 15:44:47 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B03C0617B0;
        Fri, 18 Dec 2020 12:44:07 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608324245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CSyD8eNkngoaI3NbzsM+TfQj723h4sB9336DYpAzbY=;
        b=1ou7TmTjWhstIOSB/eNl1aXXQWe65lIMApmdVw/8xkjMPQogPm4AAB5jxQdb4fHk4jNU7c
        FhWhF/6KDGZB2qMtE7Cmbhy7RHx9+uoV9VIuogkvPKW1Tlwalfpx/gBclhU0fEYtmLmKvN
        L2VC0OmwgPK59E9aGLc9xI8u4KMhTjq2pBmWlinIpHqjQx3PkEcyfmgwsoYCi5x59Zlrt9
        9tXyv02iEnvFNeYtXbTerAghX7PnkvIg+sQ9pouSM/YjGX4qYk2JCcD+9IjDMimotNu8+W
        AhprvQjxW3cyKE8C3474o9CQWeK9xZgL5V/q0VWlKaWQJstMgK6Duai9SM2J7w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608324245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CSyD8eNkngoaI3NbzsM+TfQj723h4sB9336DYpAzbY=;
        b=vceldZlcWDPwO9ii4coQNbbXxXG7V19UVqfc2W/Z8w466FIqD6a0vFgusr8taAHYb+Eg4M
        Z6XDwuabOuW3jWBQ==
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
Subject: [PATCH 02/11] scsi: libsas: Introduce a _gfp() variant of event notifiers
Date:   Fri, 18 Dec 2020 21:43:45 +0100
Message-Id: <20201218204354.586951-3-a.darwish@linutronix.de>
In-Reply-To: <20201218204354.586951-1-a.darwish@linutronix.de>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

sas_alloc_event() uses in_interrupt() to decide which allocation should
be used.

The usage of in_interrupt() in drivers is phased out and Linus clearly
requested that code which changes behaviour depending on context should
either be separated or the context be conveyed in an argument passed by
the caller, which usually knows the context.

The in_interrupt() check is also only partially correct, because it
fails to choose the correct code path when just preemption or interrupts
are disabled. For example, as in the following call chain:

  drivers/scsi/mvsas/mv_sas.c :: mvs_work_queue() [process context]
  spin_lock_irqsave()
    -> sas_ha->notify_phy_event()
    == drivers/scsi/libsas/sas_event.c :: sas_notify_phy_event()
      -> sas_alloc_event()
        -> in_interrupt() = false
          -> invalid GFP_KERNEL allocation
    -> sas_ha->notify_port_event()
    == drivers/scsi/libsas/sas_event.c :: sas_notify_port_event()
      -> sas_alloc_event()
        -> in_interrupt() = false
          -> invalid GFP_KERNEL allocation

Introduce sas_alloc_event_gfp(), sas_ha_struct::notify_port_event_gfp(),
and sas_ha_struct::notify_phy_event_gfp(), which all behave like the non
_gfp() variants but use a caller passed GFP mask for allocations.

After all callers are converted to pass the GFP context, the non _gfp()
variants will be removed.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: stable@vger.kernel.org
Cc: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 Documentation/scsi/libsas.rst      |  2 +
 drivers/scsi/libsas/sas_event.c    | 65 +++++++++++++++++++++++++-----
 drivers/scsi/libsas/sas_init.c     | 20 ++++++---
 drivers/scsi/libsas/sas_internal.h |  2 +
 include/scsi/libsas.h              |  2 +
 5 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index f9b77c7879db..dc85d0e4c107 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -191,6 +191,8 @@ The event interface::
 	/* LLDD calls these to notify the class of an event. */
 	void (*notify_port_event)(struct sas_phy *, enum port_event);
 	void (*notify_phy_event)(struct sas_phy *, enum phy_event);
+	void (*notify_port_event_gfp)(struct sas_phy *, enum port_event, gfp_t);
+	void (*notify_phy_event_gfp)(struct sas_phy *, enum phy_event, gfp_t);
 
 When sas_register_ha() returns, those are set and can be
 called by the LLDD to notify the SAS layer of such events
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index a1852f6c042b..ed5a8325dca7 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -131,18 +131,14 @@ static void sas_phy_event_worker(struct work_struct *work)
 	sas_free_event(ev);
 }
 
-static int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
+static int __sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
+				   struct asd_sas_event *ev)
 {
-	struct asd_sas_event *ev;
 	struct sas_ha_struct *ha = phy->ha;
 	int ret;
 
 	BUG_ON(event >= PORT_NUM_EVENTS);
 
-	ev = sas_alloc_event(phy);
-	if (!ev)
-		return -ENOMEM;
-
 	INIT_SAS_EVENT(ev, sas_port_event_worker, phy, event);
 
 	ret = sas_queue_event(event, &ev->work, ha);
@@ -152,18 +148,39 @@ static int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
 	return ret;
 }
 
-int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
+static int sas_notify_port_event_gfp(struct asd_sas_phy *phy,
+				     enum port_event event,
+				     gfp_t gfp_flags)
 {
 	struct asd_sas_event *ev;
+
+	ev = sas_alloc_event_gfp(phy, gfp_flags);
+	if (!ev)
+		return -ENOMEM;
+
+	return __sas_notify_port_event(phy, event, ev);
+}
+
+static int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
+{
+	struct asd_sas_event *ev;
+
+	ev = sas_alloc_event(phy);
+	if (!ev)
+		return -ENOMEM;
+
+	return __sas_notify_port_event(phy, event, ev);
+}
+
+static inline int __sas_notify_phy_event(struct asd_sas_phy *phy,
+					 enum phy_event event,
+					 struct asd_sas_event *ev)
+{
 	struct sas_ha_struct *ha = phy->ha;
 	int ret;
 
 	BUG_ON(event >= PHY_NUM_EVENTS);
 
-	ev = sas_alloc_event(phy);
-	if (!ev)
-		return -ENOMEM;
-
 	INIT_SAS_EVENT(ev, sas_phy_event_worker, phy, event);
 
 	ret = sas_queue_event(event, &ev->work, ha);
@@ -173,10 +190,36 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
 	return ret;
 }
 
+int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
+			     gfp_t gfp_flags)
+{
+	struct asd_sas_event *ev;
+
+	ev = sas_alloc_event_gfp(phy, gfp_flags);
+	if (!ev)
+		return -ENOMEM;
+
+	return __sas_notify_phy_event(phy, event, ev);
+}
+
+int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
+{
+	struct asd_sas_event *ev;
+
+	ev = sas_alloc_event(phy);
+	if (!ev)
+		return -ENOMEM;
+
+	return __sas_notify_phy_event(phy, event, ev);
+}
+
 int sas_init_events(struct sas_ha_struct *sas_ha)
 {
 	sas_ha->notify_port_event = sas_notify_port_event;
 	sas_ha->notify_phy_event = sas_notify_phy_event;
 
+	sas_ha->notify_port_event_gfp = sas_notify_port_event_gfp;
+	sas_ha->notify_phy_event_gfp = sas_notify_phy_event_gfp;
+
 	return 0;
 }
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 21c43b18d5d5..9269d524158f 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -590,16 +590,15 @@ sas_domain_attach_transport(struct sas_domain_function_template *dft)
 }
 EXPORT_SYMBOL_GPL(sas_domain_attach_transport);
 
-
-struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
+static struct asd_sas_event * __sas_alloc_event(struct asd_sas_phy *phy,
+						gfp_t gfp_flags)
 {
 	struct asd_sas_event *event;
-	gfp_t flags = in_interrupt() ? GFP_ATOMIC : GFP_KERNEL;
 	struct sas_ha_struct *sas_ha = phy->ha;
 	struct sas_internal *i =
 		to_sas_internal(sas_ha->core.shost->transportt);
 
-	event = kmem_cache_zalloc(sas_event_cache, flags);
+	event = kmem_cache_zalloc(sas_event_cache, gfp_flags);
 	if (!event)
 		return NULL;
 
@@ -610,7 +609,7 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
 			if (cmpxchg(&phy->in_shutdown, 0, 1) == 0) {
 				pr_notice("The phy%d bursting events, shut it down.\n",
 					  phy->id);
-				sas_notify_phy_event(phy, PHYE_SHUTDOWN);
+				sas_notify_phy_event_gfp(phy, PHYE_SHUTDOWN, gfp_flags);
 			}
 		} else {
 			/* Do not support PHY control, stop allocating events */
@@ -624,6 +623,17 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
 	return event;
 }
 
+struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
+{
+	return __sas_alloc_event(phy, in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
+}
+
+struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
+					  gfp_t gfp_flags)
+{
+	return __sas_alloc_event(phy, gfp_flags);
+}
+
 void sas_free_event(struct asd_sas_event *event)
 {
 	struct asd_sas_phy *phy = event->phy;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 1f1d01901978..437a697b6f73 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -49,6 +49,7 @@ int  sas_register_phys(struct sas_ha_struct *sas_ha);
 void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 
 struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy);
+struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy, gfp_t gfp_flags);
 void sas_free_event(struct asd_sas_event *event);
 
 int  sas_register_ports(struct sas_ha_struct *sas_ha);
@@ -78,6 +79,7 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 int sas_smp_get_phy_events(struct sas_phy *phy);
 
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
+int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event, gfp_t flags);
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
 struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 4e2d61e8fb1e..f7c2530bbd9d 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -394,6 +394,8 @@ struct sas_ha_struct {
 	/* LLDD calls these to notify the class of an event. */
 	int (*notify_port_event)(struct asd_sas_phy *, enum port_event);
 	int (*notify_phy_event)(struct asd_sas_phy *, enum phy_event);
+	int (*notify_port_event_gfp)(struct asd_sas_phy *, enum port_event, gfp_t);
+	int (*notify_phy_event_gfp)(struct asd_sas_phy *, enum phy_event, gfp_t);
 
 	void *lldd_ha;		  /* not touched by sas class code */
 
-- 
2.29.2

