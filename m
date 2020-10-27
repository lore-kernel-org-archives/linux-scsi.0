Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52637C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 07:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E66AF22282
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 07:32:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sslab.ics.keio.ac.jp header.i=@sslab.ics.keio.ac.jp header.b="AaKZ/8Nh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2507696AbgJ0HcJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 03:32:09 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53281 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729485AbgJ0HcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Oct 2020 03:32:09 -0400
Received: by mail-pj1-f65.google.com with SMTP id g16so324765pjv.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2020 00:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NcMWCmHOonIb+1LTN2iMb66ykL+7lpVXj4Uxfeu7rtI=;
        b=AaKZ/8NhWkuQzPgVsnCPN3GSw6bdw25mbn/IdeCjWA8/UA4hNPMFmxif3jkHC/VrX6
         Yywin+8VyESOBYmoPPg/++yQZYHO1wYbecgoZqSdwZ5B7fiFvpjx07LHgdJIHKrYJ1N7
         BvmI4cNJPwSxAET6mAbR3UCBL4kPZiXbVhEOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NcMWCmHOonIb+1LTN2iMb66ykL+7lpVXj4Uxfeu7rtI=;
        b=kC3h7SE5YzJ4n1VbGW20MkIFkrFUIEtwRydaOEEK3zI0P95tBHuCt917PILTPKoSem
         xaWcG7f3DuC4/SuKL3s7rH2tvxfyQ7IzPJJcyiJiicv7lSC8W6yl4kwaOy8gcbjcZJPj
         Yep1nvwUBUwlPNiKFhUhkN4S1Tlh/DBHPeWM6zMQ5657gKGQXqbLTbSu5E4yjpXdvO7e
         GS3LVjbsX42A+qJz1erZPVjCLKrMBDiY8imIt+VEklhdAIQRbFfbDfuuXtvvoa+VpMFf
         UOvdWORI/jyalxn+BRoDVzlRmjRlnJa9KWpapxfSnxXYXlG4UWPovXMsGo5DYKElAUIu
         6+lw==
X-Gm-Message-State: AOAM532nB/vxcFk8c9f2N12wPlQcvePJrI9nhI+/l19InAqkCR5OxTdw
        M+L3NHWaJSs6lCy5TaxjCj7NBA==
X-Google-Smtp-Source: ABdhPJxYjiSEeVDnfuYzOTFVr/kmQaBsg/EP1pjwyl5GAhPm3GhUGsAP5fc7zjL3mq7zanKr5iwd9A==
X-Received: by 2002:a17:902:aa97:b029:d5:ac09:c5ec with SMTP id d23-20020a170902aa97b02900d5ac09c5ecmr856243plr.78.1603783927309;
        Tue, 27 Oct 2020 00:32:07 -0700 (PDT)
Received: from brooklyn.i.sslab.ics.keio.ac.jp (sslab-relay.ics.keio.ac.jp. [131.113.126.173])
        by smtp.googlemail.com with ESMTPSA id a203sm706002pfd.202.2020.10.27.00.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 00:32:06 -0700 (PDT)
From:   Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     keitasuzuki.park@sslab.ics.keio.ac.jp,
        takafumi@sslab.ics.keio.ac.jp, Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] scsi: hpsa: fix memory leak in hpsa_init_one
Date:   Tue, 27 Oct 2020 07:31:24 +0000
Message-Id: <20201027073125.14229-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAEYrHjmJRmcKX+F8R_wjd146FXnSHekodauG_eNQBXArE4OBeA@mail.gmail.com>
References: <CAEYrHjmJRmcKX+F8R_wjd146FXnSHekodauG_eNQBXArE4OBeA@mail.gmail.com>
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When hpsa_scsi_add_host fails, h->lastlogicals is leaked since it lacks
free in the error handler.

Fix this by adding free when hpsa_scsi_add_host fails.

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
---
v3: revert label name to numbered labels
v2: rename labels
 drivers/scsi/hpsa.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 48d5da59262b..aed59ec20ad9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -8854,7 +8854,7 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* hook into SCSI subsystem */
 	rc = hpsa_scsi_add_host(h);
 	if (rc)
-		goto clean7; /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
+		goto clean8; /* lastlogicals, perf, sg, cmd, irq, shost, pci, lu, aer/h */
 
 	/* Monitor the controller for firmware lockups */
 	h->heartbeat_sample_interval = HEARTBEAT_SAMPLE_INTERVAL;
@@ -8869,6 +8869,8 @@ static int hpsa_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 				HPSA_EVENT_MONITOR_INTERVAL);
 	return 0;
 
+clean8: /* lastlogicals, perf, sg, cmd, irq, shost, pci, lu, aer/h */
+	kfree(h->lastlogicals);
 clean7: /* perf, sg, cmd, irq, shost, pci, lu, aer/h */
 	hpsa_free_performant_mode(h);
 	h->access.set_intr_mask(h, HPSA_INTR_OFF);
-- 
2.17.1

