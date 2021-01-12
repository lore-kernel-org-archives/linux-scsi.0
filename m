Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78FE0C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 326392310C
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbhALLIc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731365AbhALLI3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:08:29 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05083C061786;
        Tue, 12 Jan 2021 03:07:49 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610449667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SNb2IakLCgQd/7e0qMuWGkyLlnQgmHOVsUAdrqnm4NQ=;
        b=AtV/73PKX5ybuwwUutUgYOTYhXTVAMZLW9gVcHXNeoDBuGY7Dp7fZtOpXFqCz0yKyXyN6L
        5aCzvhAAbYy4L2GNt/I3D2hgoQuS/iDD3plTAuIB+ww1svL1pMxuiEW3cGSw5gcEIxDMFA
        7dN9o5qiYf/kJ0CPockKET9OPk16fqxgPeaqsITTyHVVPd0h9WhuczDMYbCAACNhtud8dj
        ACY5UXlaO4y9fYOAiVVC4auQBVIR/34KZTP4k8TnGH7GC8uRbYj5yTAZ6q02bXi9V/ecfz
        uaPgEbKDEiwXDwNGSzAv9JdVbsRrbjqtUOiGqfCMfh4dX2JdgQ+cWvtGnMgcTw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610449667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SNb2IakLCgQd/7e0qMuWGkyLlnQgmHOVsUAdrqnm4NQ=;
        b=zzhC1Twy5xU13oMzTd/orWPcede/eCjDrK7Nn5w0/RYRsyw8w/Vop4GzdufcamzcA50wVT
        r712V7EERid2bUDQ==
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
Subject: [PATCH v2 12/19] scsi: libsas: event notifiers API: Add gfp_t flags parameter
Date:   Tue, 12 Jan 2021 12:06:40 +0100
Message-Id: <20210112110647.627783-13-a.darwish@linutronix.de>
In-Reply-To: <20210112110647.627783-1-a.darwish@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All call-sites of below libsas APIs:

  - sas_alloc_event()
  - sas_notify_port_event()
  - sas_notify_phy_event()

have been converted to use the _gfp()-suffixed version.  Modify the
original APIs above to take a gfp_t flags parameter by default.

For bisectability, call-sites will be modified again to use the original
libsas APIs (while passing gfp_t). The temporary _gfp()-suffixed
versions can then be removed.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 Documentation/scsi/libsas.rst      |  4 +-
 drivers/scsi/libsas/sas_event.c    | 61 +++++++++---------------------
 drivers/scsi/libsas/sas_init.c     | 12 ++----
 drivers/scsi/libsas/sas_internal.h |  4 +-
 include/scsi/libsas.h              |  6 ++-
 5 files changed, 30 insertions(+), 57 deletions(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index 0cb0f9ce5e23..73020c1cb019 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -189,8 +189,8 @@ num_phys
 The event interface::
 
 	/* LLDD calls these to notify the class of an event. */
-	void sas_notify_port_event(struct sas_phy *, enum port_event);
-	void sas_notify_phy_event(struct sas_phy *, enum phy_event);
+	void sas_notify_port_event(struct sas_phy *, enum port_event, gfp_t);
+	void sas_notify_phy_event(struct sas_phy *, enum phy_event, gfp_t);
 	void sas_notify_port_event_gfp(struct sas_phy *, enum port_event, gfp_t);
 	void sas_notify_phy_event_gfp(struct sas_phy *, enum phy_event, gfp_t);
 
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 922056644da5..3d0cc407b33f 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -132,14 +132,19 @@ static void sas_phy_event_worker(struct work_struct *work)
 	sas_free_event(ev);
 }
 
-static int __sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
-				   struct asd_sas_event *ev)
+int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
+			  gfp_t gfp_flags)
 {
 	struct sas_ha_struct *ha = phy->ha;
+	struct asd_sas_event *ev;
 	int ret;
 
 	BUG_ON(event >= PORT_NUM_EVENTS);
 
+	ev = sas_alloc_event_gfp(phy, gfp_flags);
+	if (!ev)
+		return -ENOMEM;
+
 	INIT_SAS_EVENT(ev, sas_port_event_worker, phy, event);
 
 	ret = sas_queue_event(event, &ev->work, ha);
@@ -148,41 +153,28 @@ static int __sas_notify_port_event(struct asd_sas_phy *phy, enum port_event even
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sas_notify_port_event);
 
 int sas_notify_port_event_gfp(struct asd_sas_phy *phy, enum port_event event,
 			      gfp_t gfp_flags)
 {
-	struct asd_sas_event *ev;
-
-	ev = sas_alloc_event_gfp(phy, gfp_flags);
-	if (!ev)
-		return -ENOMEM;
-
-	return __sas_notify_port_event(phy, event, ev);
+	return sas_notify_port_event(phy, event, gfp_flags);
 }
 EXPORT_SYMBOL_GPL(sas_notify_port_event_gfp);
 
-int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event)
-{
-	struct asd_sas_event *ev;
-
-	ev = sas_alloc_event(phy);
-	if (!ev)
-		return -ENOMEM;
-
-	return __sas_notify_port_event(phy, event, ev);
-}
-EXPORT_SYMBOL_GPL(sas_notify_port_event);
-
-static inline int __sas_notify_phy_event(struct asd_sas_phy *phy,
-					 enum phy_event event,
-					 struct asd_sas_event *ev)
+int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
+			 gfp_t gfp_flags)
 {
 	struct sas_ha_struct *ha = phy->ha;
+	struct asd_sas_event *ev;
 	int ret;
 
 	BUG_ON(event >= PHY_NUM_EVENTS);
 
+	ev = sas_alloc_event_gfp(phy, gfp_flags);
+	if (!ev)
+		return -ENOMEM;
+
 	INIT_SAS_EVENT(ev, sas_phy_event_worker, phy, event);
 
 	ret = sas_queue_event(event, &ev->work, ha);
@@ -191,28 +183,11 @@ static inline int __sas_notify_phy_event(struct asd_sas_phy *phy,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(sas_notify_phy_event);
 
 int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
 			     gfp_t gfp_flags)
 {
-	struct asd_sas_event *ev;
-
-	ev = sas_alloc_event_gfp(phy, gfp_flags);
-	if (!ev)
-		return -ENOMEM;
-
-	return __sas_notify_phy_event(phy, event, ev);
+	return sas_notify_phy_event(phy, event, gfp_flags);
 }
 EXPORT_SYMBOL_GPL(sas_notify_phy_event_gfp);
-
-int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event)
-{
-	struct asd_sas_event *ev;
-
-	ev = sas_alloc_event(phy);
-	if (!ev)
-		return -ENOMEM;
-
-	return __sas_notify_phy_event(phy, event, ev);
-}
-EXPORT_SYMBOL_GPL(sas_notify_phy_event);
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index b8567902f0ce..0dc38385ecbd 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -584,8 +584,8 @@ sas_domain_attach_transport(struct sas_domain_function_template *dft)
 }
 EXPORT_SYMBOL_GPL(sas_domain_attach_transport);
 
-static struct asd_sas_event * __sas_alloc_event(struct asd_sas_phy *phy,
-						gfp_t gfp_flags)
+struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy,
+				      gfp_t gfp_flags)
 {
 	struct asd_sas_event *event;
 	struct sas_ha_struct *sas_ha = phy->ha;
@@ -617,15 +617,11 @@ static struct asd_sas_event * __sas_alloc_event(struct asd_sas_phy *phy,
 	return event;
 }
 
-struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy)
-{
-	return __sas_alloc_event(phy, in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);
-}
-
 struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
 					  gfp_t gfp_flags)
 {
-	return __sas_alloc_event(phy, gfp_flags);
+
+	return sas_alloc_event(phy, gfp_flags);
 }
 
 void sas_free_event(struct asd_sas_event *event)
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index d70d33b94668..9b39fd478328 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -48,7 +48,7 @@ int sas_show_oob_mode(enum sas_oob_mode oob_mode, char *buf);
 int  sas_register_phys(struct sas_ha_struct *sas_ha);
 void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 
-struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy);
+struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy, gfp_t gfp_flags);
 struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy, gfp_t gfp_flags);
 void sas_free_event(struct asd_sas_event *event);
 
@@ -77,7 +77,7 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 			enum phy_func phy_func, struct sas_phy_linkrates *);
 int sas_smp_get_phy_events(struct sas_phy *phy);
 
-int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
+int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event, gfp_t flags);
 int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event, gfp_t flags);
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index e6a43163ab5b..fda56e151695 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -702,8 +702,10 @@ struct sas_phy *sas_get_local_phy(struct domain_device *dev);
 
 int sas_request_addr(struct Scsi_Host *shost, u8 *addr);
 
-int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event);
-int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
+int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
+			  gfp_t gfp_flags);
+int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
+			 gfp_t gfp_flags);
 int sas_notify_port_event_gfp(struct asd_sas_phy *phy, enum port_event event,
 			      gfp_t gfp_flags);
 int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
-- 
2.30.0

