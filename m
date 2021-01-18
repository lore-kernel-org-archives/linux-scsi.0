Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D203C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 11:11:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAA80223E8
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 11:11:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389192AbhARKsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 05:48:25 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:55226 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389755AbhARKNb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 05:13:31 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610964700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W6/Fxq6SJj3l0bOA5qvsrvqpyxVzx43C+xNlo/yLFZw=;
        b=T51AGJvCCyB37OPwZBIVl77FYUq4EN1NIy90CCgnRpC8idRs/C+eI6ukTwl+6LfDKqu9Ac
        xE5Hun1RLNa1ChFGAcJ0mAmMbqtjQ4CEZM4K2Cobw5tty5aHSmpaZP25gfM0ZEH2otaxGL
        ujeZT+kaUsMdh3UV7PghgAHvxuafTmYkrxuB23qjHWsn0PsXks6Z62fV372uPigXrOIhmT
        1x6ImdI7iko+UoSvrB8bSeQMY/FWEWRMAsrrnxnNYqFGVhD7ZnGO2sm64nkpGPG5U8R0+A
        GQCN5Wk3zQH6rXeyDsttm8JDaFblATdlez7aeQDap5QdKScrpEI7Y6VIG4+AUQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610964700;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W6/Fxq6SJj3l0bOA5qvsrvqpyxVzx43C+xNlo/yLFZw=;
        b=YosGUwS1s0wB0AUqsP5y5u17hHJtvhsyRWYKWbubU1zuixAPNwIkEwXVfHT6uXd5glLUCB
        BJ7WK0Kb6/BOoODQ==
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
Subject: [PATCH v3 19/19] scsi: libsas: Remove temporarily-added _gfp() API variants
Date:   Mon, 18 Jan 2021 11:09:55 +0100
Message-Id: <20210118100955.1761652-20-a.darwish@linutronix.de>
In-Reply-To: <20210118100955.1761652-1-a.darwish@linutronix.de>
References: <20210118100955.1761652-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These variants were added for bisectability. Remove them, as all call
sites have now been convertd to use the original API.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 Documentation/scsi/libsas.rst      |  2 --
 drivers/scsi/libsas/sas_event.c    | 14 --------------
 drivers/scsi/libsas/sas_init.c     |  7 -------
 drivers/scsi/libsas/sas_internal.h |  4 ----
 include/scsi/libsas.h              |  4 ----
 5 files changed, 31 deletions(-)

diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
index c65086470a15..6589dfefbc02 100644
--- a/Documentation/scsi/libsas.rst
+++ b/Documentation/scsi/libsas.rst
@@ -191,8 +191,6 @@ The event interface::
 	/* LLDD calls these to notify the class of an event. */
 	void sas_notify_port_event(struct sas_phy *, enum port_event, gfp_t);
 	void sas_notify_phy_event(struct sas_phy *, enum phy_event, gfp_t);
-	void sas_notify_port_event_gfp(struct sas_phy *, enum port_event, gfp_t);
-	void sas_notify_phy_event_gfp(struct sas_phy *, enum phy_event, gfp_t);
 
 The port notification::
 
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
index 62260e84ca2d..2b0f98ca6ec3 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -619,13 +619,6 @@ struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy,
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
index 294cdcb4ce42..d7a1fb5c10c6 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -49,8 +49,6 @@ int  sas_register_phys(struct sas_ha_struct *sas_ha);
 void sas_unregister_phys(struct sas_ha_struct *sas_ha);
 
 struct asd_sas_event *sas_alloc_event(struct asd_sas_phy *phy, gfp_t gfp_flags);
-struct asd_sas_event *sas_alloc_event_gfp(struct asd_sas_phy *phy,
-					  gfp_t gfp_flags);
 void sas_free_event(struct asd_sas_event *event);
 
 int  sas_register_ports(struct sas_ha_struct *sas_ha);
@@ -80,8 +78,6 @@ int sas_smp_get_phy_events(struct sas_phy *phy);
 
 int sas_notify_phy_event(struct asd_sas_phy *phy, enum phy_event event,
 			 gfp_t flags);
-int sas_notify_phy_event_gfp(struct asd_sas_phy *phy, enum phy_event event,
-			     gfp_t flags);
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

