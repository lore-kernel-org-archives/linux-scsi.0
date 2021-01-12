Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48DB8C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:08:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C6DC2310C
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730442AbhALLIK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:08:10 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45196 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbhALLIK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:08:10 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610449648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HPSAiQuTaUq/+UoZvR6qPMlwgesT7E3LJM84qLoAvp4=;
        b=JmLRKdM2nfQLDBLW5YyXZkwFTOjZMp7hRVy3Gj+nBmQC5/iSz5ltuvbVHJ0UmOekBrWB7G
        iYXFtF+ZuurJMxnanfNPwWcTgConeHsy14MTDUBp+NfN4Gn/jT+fOtB2kHRY/mwjx9nYEW
        l9S1OkXD/5iRIs3KRBMDXYFrbha0GImZMOJwTvlbHI8mcZARNEVyAit+7oPVU+nzQzEeGY
        XSxxhDa+WRYgewoTyey5BkRAcUmbgqQJMfbj7OzX4SZSyQ4NGudQoQZ0o/Fi59LBnjDSIS
        yjt0UHKuWcG5KXmCOQ4TNNcpiNPb6/BcekEhtkRyDn9RUELci3nvgyix3Fvzng==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610449648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HPSAiQuTaUq/+UoZvR6qPMlwgesT7E3LJM84qLoAvp4=;
        b=AoTq9zRUqYV74afnIh76mx5CqVLjDUFPI/eWwFneHtLLegLYeu6+Rb0HSM0wXUELMFU8Le
        DDzYyN5qYCo39ZDw==
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
Subject: [PATCH v2 08/19] scsi: libsas: Pass gfp_t flags to event notifiers
Date:   Tue, 12 Jan 2021 12:06:36 +0100
Message-Id: <20210112110647.627783-9-a.darwish@linutronix.de>
In-Reply-To: <20210112110647.627783-1-a.darwish@linutronix.de>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the new libsas event notifiers API, which requires callers to
explicitly pass the gfp_t memory allocation flags.

Context analysis:

  - sas_enable_revalidation(): process, acquires mutex
  - sas_resume_ha(): process, calls wait_event_timeout()

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: John Garry <john.garry@huawei.com>
Cc: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/libsas/sas_event.c | 3 ++-
 drivers/scsi/libsas/sas_init.c  | 2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index 31fc32b9bb4e..922056644da5 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -109,7 +109,8 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
 
 		sas_phy = container_of(port->phy_list.next, struct asd_sas_phy,
 				port_phy_el);
-		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		sas_notify_port_event_gfp(sas_phy,
+				PORTE_BROADCAST_RCVD, GFP_KERNEL);
 	}
 	mutex_unlock(&ha->disco_mutex);
 }
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 1c78347fbcc6..b8567902f0ce 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -404,7 +404,7 @@ void sas_resume_ha(struct sas_ha_struct *ha)
 
 		if (phy->suspended) {
 			dev_warn(&phy->phy->dev, "resume timeout\n");
-			sas_notify_phy_event(phy, PHYE_RESUME_TIMEOUT);
+			sas_notify_phy_event_gfp(phy, PHYE_RESUME_TIMEOUT, GFP_KERNEL);
 		}
 	}
 
-- 
2.30.0

