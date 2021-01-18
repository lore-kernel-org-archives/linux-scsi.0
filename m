Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C78C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6722722D6E
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394649AbhARV06 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:26:58 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54928 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389243AbhARKLL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:11:11 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NkkVqWalPLNmP6iVYEJDDHa+oGp/xpN9IA9pHFCSXuc=;
        b=3eRqL9y+7byzmwk5sC5SAOBdhjvwnwTr0utAQkVdOvjkskWzHKPMbtzJUHvjhOOMgJFfPg
        pq/l3CaQKZ2rDwYXDLWl7r/NCEKrvJyc/WSyfRjuLyXsI718Q9Ij3NmuJCFCeWF/ifqFjR
        HsC06+E/cNTLpe9bzVI0IFbmpcfS9p+ObA7hGrOEUXl5xm+CTLL6L4t1+/JO2p05Jn/DMz
        0qXVVPFJVK21Ci8ZQHdYRaqXN33nsbLUMnH3lJA+hqw9G/1Cp/Ch6FTKLBz/xGkFXuRY5Z
        rV2zzLSfknhnVYNvTHtgeNpTvA1JzP9lb6ZLhGXJ4umwS2TiRCI4G905CR80eQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NkkVqWalPLNmP6iVYEJDDHa+oGp/xpN9IA9pHFCSXuc=;
        b=ZiRlKOwt0FrqWs3i3ZKpzeotwm2y9y52KBunqHiQ1LqlP7ErxJ2IOowZV3BVVTIdC+6OQ9
        MzMinMdqWmGT7HDw==
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
Subject: [PATCH v3 03/19] scsi: libsas: Introduce a _gfp() variant of event notifiers
Date:   Mon, 18 Jan 2021 11:09:39 +0100
Message-Id: <20210118100955.1761652-4-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
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

Introduce sas_alloc_event_gfp(), sas_notify_port_event_gfp(), and
sas_notify_phy_event_gfp(), which all behave like the non _gfp()
variants but use a caller-passed GFP mask for allocations.

For bisectability, all callers will be modified first to pass GFP
context, then the non _gfp() libsas API variants will be modified to
take a gfp_t by default.

Fixes: 1c393b970e0f ("scsi: libsas: Use dynamic alloced work to avoid sas event lost")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 Documentation/scsi/libsas.rst      |  2 +
 drivers/scsi/libsas/sas_event.c    | 67 ++++++++++++++++++++++++------
 drivers/scsi/libsas/sas_init.c     | 21 +++++++---
 drivers/scsi/libsas/sas_internal.h |  4 ++
 include/scsi/libsas.h              |  4 ++
 5 files changed, 80 insertions(+), 18 deletions(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index 6722e352444b..ea63ab3a9216 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -191,6 +191,8 @@ The event interface::
 	/* LLDD calls these to notify the class of an event. */
 	void sas_notify_port_event(struct sas_phy *, enum port_event);
 	void sas_notify_phy_event(struct sas_phy *, enum phy_event);
+	void sas_notify_port_event_gfp(struct sas_phy *, enum port_event, gfp_t);
+	void sas_notify_phy_event_gfp(struct sas_phy *, enum phy_event, gfp_t);
 
 The port notification::
 
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 112a1b76f63b..ba266a17250a 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -131,18 +131,15 @@ static void sas_phy_event_worker(struct work_struct *work)
 	sas_free_event(ev);
 }
 
-int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
+static int __sas_notify_port_event(struct asd_sas_phy *phy,
+				   enum port_event event,
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
@@ -151,20 +148,41 @@ int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
 
 	return ret;
 }
+
+int sas_notify_port_event_gfp(struct asd_sas_phy *phy, enum port_event event,
+			      gfp_t gfp_flags)
+{
+	struct asd_sas_event *ev;
+
+	ev = sas_alloc_event_gfp(phy, gfp_flags);
+	if (!ev)
+		return -ENOMEM;
+
+	return __sas_notify_port_event(phy, event, ev);
+}
+EXPORT_SYMBOL_GPL(sas_notify_port_event_gfp);
+
+int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
+{
+	struct asd_sas_event *ev;
+
+	ev = sas_alloc_event(phy);
+	if (!ev)
+		return -ENOMEM;
+
+	return __sas_notify_port_event(phy, event, ev);
+}
 EXPORT_SYMBOL_GPL(sas_notify_port_event);
 
-int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
+static inline int __sas_notify_phy_event(struct asd_sas_phy *phy,
+					 enum phy_event event,
+					 struct asd_sas_event *ev)
 {
-	struct asd_sas_event *ev;
 	struct sas_ha_struct *ha = phy->ha;
 	int ret;
 
 	BUG_ON(event >= PHY_NUM_EVENTS);
 
-	ev = sas_alloc_event(phy);
-	if (!ev)
-		return -ENOMEM;
-
 	INIT_SAS_EVENT(ev, sas_phy_event_worker, phy, event);
 
 	ret = sas_queue_event(event, &ev->work, ha);
@@ -173,5 +191,28 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
 
 	return ret;
 }
+
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
+EXPORT_SYMBOL_GPL(sas_notify_phy_event_gfp);
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
 EXPORT_SYMBOL_GPL(sas_notify_phy_event);
-
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 6dc2505d36af..f8ae1f0f17d3 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -584,16 +584,15 @@ sas_domain_attach_transport(struct sas_domain_function_template *dft)
 }
 EXPORT_SYMBOL_GPL(sas_domain_attach_transport);
 
-
-struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
+static struct asd_sas_event *__sas_alloc_event(struct asd_sas_phy *phy,
+					       gfp_t gfp_flags)
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
 
@@ -604,7 +603,8 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
 			if (cmpxchg(&phy->in_shutdown, 0, 1) == 0) {
 				pr_notice("The phy%d bursting events, shut it down.\n",
 					  phy->id);
-				sas_notify_phy_event(phy, PHYE_SHUTDOWN);
+				sas_notify_phy_event_gfp(phy, PHYE_SHUTDOWN,
+							 gfp_flags);
 			}
 		} else {
 			/* Do not support PHY control, stop allocating events */
@@ -618,6 +618,17 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
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
index 53ea32ed17a7..52e09c3e2b50 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -49,6 +49,8 @@ int  sas_register_phys(struct sas_ha_struct *sas_ha);
 void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 
 struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy);
+struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
+					  gfp_t gfp_flags);
 void sas_free_event(struct asd_sas_event *event);
 
 int  sas_register_ports(struct sas_ha_struct *sas_ha);
@@ -77,6 +79,8 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 int sas_smp_get_phy_events(struct sas_phy *phy);
 
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
+int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
+			     gfp_t flags);
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
 struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 3387149502e9..e6a43163ab5b 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -704,5 +704,9 @@ int sas_request_addr(struct Scsi_Host *shost, u8 *addr);
 
 int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event);
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
+int sas_notify_port_event_gfp(struct asd_sas_phy *phy, enum port_event event,
+			      gfp_t gfp_flags);
+int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
+			     gfp_t gfp_flags);
 
 #endif /* _SASLIB_H_ */
-- 
2.30.0

