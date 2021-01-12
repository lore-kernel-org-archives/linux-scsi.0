Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D231C4332B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:08:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B0132311B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:08:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbhALLHq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbhALLHp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:07:45 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5000C061794;
        Tue, 12 Jan 2021 03:07:04 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610449623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kdBSJovm/gso5QCYPd5qSsIzo/N4ofUl2PfqbWUhWkQ=;
        b=I0myQ067afKmtD/KNQkJ63nzj0NCHIZTVoOWXBJuMRmsTNhCZyJ5wcyCMAouqHI1EzJXJl
        GnWaUKfX0uEwVVMdAIgN8mkH+qGARQCZVf0PbE2urJprMgplEjdeJcDlaYmC0e+XTMhKlN
        8Ca4EQP1LqkwgWw20L0UH8PDV8A5mTIbZ2bDxVmFqZvnuTsLF+EXLATQZxsYTSHhLtBu6r
        +CbPlQlxiG5b+YW4UjHqc60U60XmoesPvZqkDoTPF9YpS5PUtJyrBNqk6WiL+i4WtCZr4z
        fpx04fkxJTYfXNzF2I+bjOh6n4lnTP1LT4f9BJfD5XpE7iUnotgRXRy9qih4BA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610449623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kdBSJovm/gso5QCYPd5qSsIzo/N4ofUl2PfqbWUhWkQ=;
        b=UQI5cAma1EFH5m0KKYO2mFru0t+2AkQ+9Ngjjr8xX74N/az9FdMln/Y1NrK3NZN9EMkzGo
        uPgPMP/fknY03vCw==
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
Subject: [PATCH v2 03/19] scsi: libsas: Introduce a _gfp() variant of event notifiers
Date:   Tue, 12 Jan 2021 12:06:31 +0100
Message-Id: <20210112110647.627783-4-a.darwish@linutronix.de>
In-Reply-To: <20210112110647.627783-1-a.darwish@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
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
Cc: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 Documentation/scsi/libsas.rst      |  2 +
 drivers/scsi/libsas/sas_event.c    | 66 ++++++++++++++++++++++++------
 drivers/scsi/libsas/sas_init.c     | 20 ++++++---
 drivers/scsi/libsas/sas_internal.h |  2 +
 include/scsi/libsas.h              |  4 ++
 5 files changed, 76 insertions(+), 18 deletions(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index a183b1d84713..0cb0f9ce5e23 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -191,6 +191,8 @@ The event interface::
 	/* LLDD calls these to notify the class of an event. */
 	void sas_notify_port_event(struct sas_phy *, enum port_event);
 	void sas_notify_phy_event(struct sas_phy *, enum phy_event);
+	void sas_notify_port_event_gfp(struct sas_phy *, enum port_event, gfp_t);
+	void sas_notify_phy_event_gfp(struct sas_phy *, enum phy_event, gfp_t);
 
 When sas_register_ha() returns, those are set and can be
 called by the LLDD to notify the SAS layer of such events
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 112a1b76f63b..31fc32b9bb4e 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -131,18 +131,14 @@ static void sas_phy_event_worker(struct work_struct *work)
 	sas_free_event(ev);
 }
 
-int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
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
@@ -151,20 +147,41 @@ int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
 
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
@@ -173,5 +190,28 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
 
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
index 6dc2505d36af..1c78347fbcc6 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -584,16 +584,15 @@ sas_domain_attach_transport(struct sas_domain_function_template *dft)
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
 
@@ -604,7 +603,7 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
 			if (cmpxchg(&phy->in_shutdown, 0, 1) == 0) {
 				pr_notice("The phy%d bursting events, shut it down.\n",
 					  phy->id);
-				sas_notify_phy_event(phy, PHYE_SHUTDOWN);
+				sas_notify_phy_event_gfp(phy, PHYE_SHUTDOWN, gfp_flags);
 			}
 		} else {
 			/* Do not support PHY control, stop allocating events */
@@ -618,6 +617,17 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
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
index 53ea32ed17a7..d70d33b94668 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -49,6 +49,7 @@ int  sas_register_phys(struct sas_ha_struct *sas_ha);
 void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 
 struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy);
+struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy, gfp_t gfp_flags);
 void sas_free_event(struct asd_sas_event *event);
 
 int  sas_register_ports(struct sas_ha_struct *sas_ha);
@@ -77,6 +78,7 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 int sas_smp_get_phy_events(struct sas_phy *phy);
 
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
+int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event, gfp_t flags);
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

