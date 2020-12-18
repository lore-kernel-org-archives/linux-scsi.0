Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C3FC35270
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22CF523B70
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 20:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbgLRUpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 15:45:12 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54804 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387701AbgLRUpM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 15:45:12 -0500
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608324270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E+VKeQFAYnAIn23LYfHrbHWpfVo9CXIWaFYEXe0jlq4=;
        b=U1/gmwJ7WNcgz93NCaRsk8Dez9ABbVxlQymaxpypOstXoD9pj37siRvrP5v4pPS9duwYtr
        0FrwOGkLlKLkpX7gpT14bDBl6x9H5vfdQjZgxScuk1OvGufyYRe1qErnSoOlRVHJ0psGPm
        EQNB2EkTFZ+XpzX5sxpKmxAsMhubstYX2owY/nhVEW11UtMYyo6xjvFi9lYDd6njg61GQy
        D+CbrdV3PDH/ZugDln3y9/q7SQw2ttZf0L/Ci7ejUyuNx34nhHrodvcSGzK7aG8SgFAcTE
        Sj9PQgApEvPK116achRAFCWSch5zbkaEFWVQP3+HL0wqta8HlDK7FGWhsKP8vw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608324270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E+VKeQFAYnAIn23LYfHrbHWpfVo9CXIWaFYEXe0jlq4=;
        b=KCa+lCdqv3ZQgT4vbgKnl8Safvbt29+FdR9jl4Y6c2Kkympmfa4u2LLTfwp8HphLEkowZo
        RXaEaB6i74xJ5XDQ==
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
Subject: [PATCH 07/11] scsi: libsas: Pass gfp_t flags to event notifiers
Date:   Fri, 18 Dec 2020 21:43:50 +0100
Message-Id: <20201218204354.586951-8-a.darwish@linutronix.de>
In-Reply-To: <20201218204354.586951-1-a.darwish@linutronix.de>
References: <20201218204354.586951-1-a.darwish@linutronix.de>
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
 drivers/scsi/libsas/sas_event.c | 2 +-
 drivers/scsi/libsas/sas_init.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_event.c b/drivers/scsi/libsas/sas_event.c
index ed5a8325dca7..31b733eeabf6 100644
--- a/drivers/scsi/libsas/sas_event.c
+++ b/drivers/scsi/libsas/sas_event.c
@@ -109,7 +109,7 @@ void sas_enable_revalidation(struct sas_ha_struct *ha)
 
 		sas_phy = container_of(port->phy_list.next, struct asd_sas_phy,
 				port_phy_el);
-		ha->notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
+		ha->notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_KERNEL);
 	}
 	mutex_unlock(&ha->disco_mutex);
 }
diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 9269d524158f..2d2116f827c6 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -410,7 +410,7 @@ void sas_resume_ha(struct sas_ha_struct *ha)
 
 		if (phy->suspended) {
 			dev_warn(&phy->phy->dev, "resume timeout\n");
-			sas_notify_phy_event(phy, PHYE_RESUME_TIMEOUT);
+			sas_notify_phy_event_gfp(phy, PHYE_RESUME_TIMEOUT, GFP_KERNEL);
 		}
 	}
 
-- 
2.29.2

