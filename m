Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8412C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71C9E222B3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 21:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394461AbhARVMu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 16:12:50 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55212 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389745AbhARKN3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:29 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xTiNsIBa59THcsevJRE+EeFn5TKH8F5bbL95uC706VA=;
        b=ka1t3IR86Q+9e2uN+9+j13J1LdMnq89Zvppoq+Zl/6r7n9KT1qO4DKNd819mNFKLfYM+aE
        hrLesJUrQ+tA3rpgTRc82+VK5kp7DJFxuk49Ejqw31EQxfUi7Ku5lPCUaOKKzA6iOLJqpR
        NHKZscIxzIEVBSuUKc+ttMeKCz28MSxNcsda/Zsq3iTc9N6MNi521ivHrVeL62Skz1cnZ/
        vWswQP5r6oXEoNHe4oujx2Y7Zx8wVMaInX+0IVmCoc2i7QkHJ8NOjVBwf7oeeNn3GE7CnG
        FdbzRlNHb97NNoPy0zFj5oOMnheSZz11gxdpqc8nlODbvaCUj4o1hQN5yUtVZA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xTiNsIBa59THcsevJRE+EeFn5TKH8F5bbL95uC706VA=;
        b=W6R5b8bJ9oT5kC2wqiGwDm7TsvE9HMtXqz4qlRRfBsez/E4RDQERKePEnINBhTs/5GgWJo
        ObTFszyjZIaK1BDA==
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
Subject: [PATCH v3 12/19] scsi: libsas: event notifiers API: Add gfp_t flags parameter
Date:   Mon, 18 Jan 2021 11:09:48 +0100
Message-Id: <20210118100955.1761652-13-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
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
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 Documentation/scsi/libsas.rst      |  4 +-
 drivers/scsi/libsas/sas_event.c    | 62 +++++++++---------------------
 drivers/scsi/libsas/sas_init.c     | 12 ++----
 drivers/scsi/libsas/sas_internal.h |  5 ++-
 include/scsi/libsas.h              |  6 ++-
 5 files changed, 31 insertions(+), 58 deletions(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index ea63ab3a9216..c65086470a15 100644
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
index 25f3aaea8142..3d0cc407b33f 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -132,15 +132,19 @@ static void sas_phy_event_worker(struct work_struct *work)
 	sas_free_event(ev);
 }
 
-static int __sas_notify_port_event(struct asd_sas_phy *phy,
-				   enum port_event event,
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
@@ -149,41 +153,28 @@ static int __sas_notify_port_event(struct asd_sas_phy *phy,
 
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
@@ -192,28 +183,11 @@ static inline int __sas_notify_phy_event(struct asd_sas_phy *phy,
 
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
index 9ce0cd214eb9..f06b83211e3b 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -585,8 +585,8 @@ sas_domain_attach_transport(struct sas_domain_function_template *dft)
 }
 EXPORT_SYMBOL_GPL(sas_domain_attach_transport);
 
-static struct asd_sas_event *__sas_alloc_event(struct asd_sas_phy *phy,
-					       gfp_t gfp_flags)
+struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy,
+				      gfp_t gfp_flags)
 {
 	struct asd_sas_event *event;
 	struct sas_ha_struct *sas_ha = phy->ha;
@@ -619,15 +619,11 @@ static struct asd_sas_event *__sas_alloc_event(struct asd_sas_phy *phy,
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
index 52e09c3e2b50..294cdcb4ce42 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -48,7 +48,7 @@ int sas_show_oob_mode(enum sas_oob_mode oob_mode, char *buf);
 int  sas_register_phys(struct sas_ha_struct *sas_ha);
 void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 
-struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy);
+struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy, gfp_t gfp_flags);
 struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
 					  gfp_t gfp_flags);
 void sas_free_event(struct asd_sas_event *event);
@@ -78,7 +78,8 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 			enum phy_func phy_func, struct sas_phy_linkrates *);
 int sas_smp_get_phy_events(struct sas_phy *phy);
 
-int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event);
+int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
+			 gfp_t flags);
 int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
 			     gfp_t flags);
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
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

