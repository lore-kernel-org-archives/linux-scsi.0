Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03D5C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A46FA2310E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390753AbhALLJE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:09:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390300AbhALLJD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:09:03 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB58C0617A5;
        Tue, 12 Jan 2021 03:08:22 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610449701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JCZqbzWzFklPRkLfWg0UFOf5QwGiL2pMpZBSv06l/GU=;
        b=wMewkP1o8vTtb3PrUDte9nQ23UaFjV0TxAedAJ4IVaMvGv3kJ+nVQR5o3D8S68ifIMY3Dh
        hKJGeVRmY1ftZw2KgFkQGZZfFrV1wt6der2vLHno9dm7Y4KDzkA/rGo5iPqCTSYkFaceYN
        l7Q+SsG/DJ9s/qRSbgGhjtMOhml4TUl0Vsxk7UlKLZa/ZjJLMEBRMf7lSZYk7gShpIWycN
        0+XsNTeVgyIoiG3EJHmOgf5+lROVdvRxC7GF6PTMyZWh/WLCPJDQOoDuJMskGsVVSHIj0k
        hsKnIl+0i4R5SJOqbGjUjp5Ac3UzCjpgmXOjxYm4PgEVcHZ8U6UN96UawO8+Qg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610449701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JCZqbzWzFklPRkLfWg0UFOf5QwGiL2pMpZBSv06l/GU=;
        b=R7bvtEWKnm6C3vK3w7WShFYcu94H6QIx7VDBHU2vhfBW+PnXltmxdLgiBcwgW2inWI5g8o
        1mc/lHg4L/fU1HBw==
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
Subject: [PATCH v2 19/19] scsi: libsas: Remove temporarily-added _gfp() API variants
Date:   Tue, 12 Jan 2021 12:06:47 +0100
Message-Id: <20210112110647.627783-20-a.darwish@linutronix.de>
In-Reply-To: <20210112110647.627783-1-a.darwish@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These variants were added for bisectability. Remove them, as all call
sites have now been convertd to use the original API.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
---
 Documentation/scsi/libsas.rst      |  2 --
 drivers/scsi/libsas/sas_event.c    | 14 --------------
 drivers/scsi/libsas/sas_init.c     |  7 -------
 drivers/scsi/libsas/sas_internal.h |  2 --
 include/scsi/libsas.h              |  4 ----
 5 files changed, 29 deletions(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index 73020c1cb019..e31800d9a1ac 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -191,8 +191,6 @@ The event interface::
 	/* LLDD calls these to notify the class of an event. */
 	void sas_notify_port_event(struct sas_phy *, enum port_event, gfp_t);
 	void sas_notify_phy_event(struct sas_phy *, enum phy_event, gfp_t);
-	void sas_notify_port_event_gfp(struct sas_phy *, enum port_event, gfp_t);
-	void sas_notify_phy_event_gfp(struct sas_phy *, enum phy_event, gfp_t);
 
 When sas_register_ha() returns, those are set and can be
 called by the LLDD to notify the SAS layer of such events
diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 542831887769..f703115e7a25 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -155,13 +155,6 @@ int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
 }
 EXPORT_SYMBOL_GPL(sas_notify_port_event);
 
-int sas_notify_port_event_gfp(struct asd_sas_phy *phy, enum port_event event,
-			      gfp_t gfp_flags)
-{
-	return sas_notify_port_event(phy, event, gfp_flags);
-}
-EXPORT_SYMBOL_GPL(sas_notify_port_event_gfp);
-
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
 			 gfp_t gfp_flags)
 {
@@ -184,10 +177,3 @@ int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(sas_notify_phy_event);
-
-int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
-			     gfp_t gfp_flags)
-{
-	return sas_notify_phy_event(phy, event, gfp_flags);
-}
-EXPORT_SYMBOL_GPL(sas_notify_phy_event_gfp);
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 30dd35eb9449..6bfbf5fbd989 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -617,13 +617,6 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy,
 	return event;
 }
 
-struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
-					  gfp_t gfp_flags)
-{
-
-	return sas_alloc_event(phy, gfp_flags);
-}
-
 void sas_free_event(struct asd_sas_event *event)
 {
 	struct asd_sas_phy *phy = event->phy;
diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 9b39fd478328..5eef5a1c1997 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -49,7 +49,6 @@ int  sas_register_phys(struct sas_ha_struct *sas_ha);
 void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 
 struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy, gfp_t gfp_flags);
-struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy, gfp_t gfp_flags);
 void sas_free_event(struct asd_sas_event *event);
 
 int  sas_register_ports(struct sas_ha_struct *sas_ha);
@@ -78,7 +77,6 @@ int sas_smp_phy_control(struct domain_device *dev, int phy_id,
 int sas_smp_get_phy_events(struct sas_phy *phy);
 
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event, gfp_t flags);
-int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event, gfp_t flags);
 void sas_device_set_phy(struct domain_device *dev, struct sas_port *port);
 struct domain_device *sas_find_dev_by_rphy(struct sas_rphy *rphy);
 struct domain_device *sas_ex_to_ata(struct domain_device *ex_dev, int phy_id);
diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index fda56e151695..9271d7a49b90 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -706,9 +706,5 @@ int sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
 			  gfp_t gfp_flags);
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
 			 gfp_t gfp_flags);
-int sas_notify_port_event_gfp(struct asd_sas_phy *phy, enum port_event event,
-			      gfp_t gfp_flags);
-int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
-			     gfp_t gfp_flags);
 
 #endif /* _SASLIB_H_ */
-- 
2.30.0

