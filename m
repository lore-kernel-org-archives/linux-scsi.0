Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 606DBC43461
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 13:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F08C224D1
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 13:48:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sslab.ics.keio.ac.jp header.i=@sslab.ics.keio.ac.jp header.b="XXNR65cR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730183AbgIHNrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 09:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729911AbgIHNmM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 09:42:12 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C3AC0619C4
        for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2020 06:36:12 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d6so3913301pfn.9
        for <linux-scsi@vger.kernel.org>; Tue, 08 Sep 2020 06:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sslab.ics.keio.ac.jp; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ehTU8VuqCe4uQqnVpDe9geOxORvh8qag6CqSgGb/x38=;
        b=XXNR65cRXkVSPXHNMlGccTpQI7cOqRyhk5d8MsIws07AR035m+bxTug70SDBbKciK5
         2lYRSm8fhoP+SbAUu7pr7CorYMYDf8ArGi3ZDTGpK4TqR6w3vHrr/iW4tbDJwhKJjYVE
         ryBEybf6RG9DjezNonEi/3yWFDJBF0DAYhs6k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ehTU8VuqCe4uQqnVpDe9geOxORvh8qag6CqSgGb/x38=;
        b=T+PvOpJ+slGSa9DXPCg4zUTxvCUMYgzmt4bVEWFIqCTlKfHhWNOxdZjCpwJPWW5mrD
         i9I/uCuAGZKShrHRYM+a/KCjgVVpCa7mE1tRmwJFuNUFkXVN78Jzayb2fEu5lb9TeX5Q
         9AfVp20y1Hl3tKN1WltPK8X/By9J+C+KL0y79VFLQOPMaHyO/Dl+rbXC1GCEOhraZ42n
         dOnSE6Vt6oFj/rGX2RdFsxzTFXh8lFUCUJrytXkF6MDb9mvn/uE6jIMhxCLPcJCs5V2p
         XnUWud3MTq4RjbXw3wAZiICrwJFjXMDuGktfInsmLOpl0GLO5AmFklHb0T4D/d0L2J7m
         EPGg==
X-Gm-Message-State: AOAM5300B0kTqA3UXww9GvYPMCj18rNANgdcyu9S11yUVOSeyescO33f
        gHiGvwFHBTHuhfC0ktnMW683OQ==
X-Google-Smtp-Source: ABdhPJwhXtG+H2LqAISEDK2z1kRlZcOQuBM48N1pdIL7c/KejeE7ihVjm7S4Fd1HckDMPESkOFR8iA==
X-Received: by 2002:a17:902:c410:: with SMTP id k16mr24241546plk.123.1599572171471;
        Tue, 08 Sep 2020 06:36:11 -0700 (PDT)
Received: from brooklyn.i.sslab.ics.keio.ac.jp (sslab-relay.ics.keio.ac.jp. [131.113.126.173])
        by smtp.googlemail.com with ESMTPSA id b20sm19856758pfb.198.2020.09.08.06.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 06:36:10 -0700 (PDT)
From:   Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     keitasuzuki.park@sslab.ics.keio.ac.jp,
        takafumi@sslab.ics.keio.ac.jp, Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: hpsa: fix memory leak in hpsa_init_one
Date:   Tue,  8 Sep 2020 13:35:32 +0000
Message-Id: <20200908133533.16744-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
X-Mailer: git-send-email 2.17.1
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When hpsa_scsi_add_host fails, h->lastlogicals is leaked since it lacks
free in the error handler.

Fix this by adding free when hpsa_scsi_add_host fails.

Signed-off-by: Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
---
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

