Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8FAC43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 18:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B8920770
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 18:59:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TY6WrvPq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgIIS7K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 14:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgIIS7F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 14:59:05 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8601C061573;
        Wed,  9 Sep 2020 11:59:04 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id s13so3321959wmh.4;
        Wed, 09 Sep 2020 11:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uXnjw/VPfhPNUnKOZ9x/3YdxbiHHO2depn2TRUMyriM=;
        b=TY6WrvPqQej5Qj53qINdsFDPIya8YtQdBfgYxZLIGMmAZsCV0LErKw8IEvAfAQgL2u
         XnZWLOfWp/5eXDPebRMSz5JYqi0faEf2xaFq4PxpvpQc4H++KNNRgxVHtF6GvRNEZuYw
         4c8D4VloFNUyQ/kkeNyiB7NqjkNm2CBY6ZqrtYb1oc/JPL6fObquZ68czZ++pO/vMB8F
         9A8V76itAmfXV/G5N8ZYIp6jF7/1NK5u1W+DpFCkLI9V9F+ylmA+jij7NyRC9PmrKgDh
         5pJCDZiIJ4rgth7oakgD/2A3SUoZdbJ7+54mb2+bOOLQ3QRB1ZxuJF5LSyscJ89nRZ+z
         tVMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uXnjw/VPfhPNUnKOZ9x/3YdxbiHHO2depn2TRUMyriM=;
        b=jewWnlBQXmG68rAzXDKt4b7V96MSaAf1zjz6G5gymKKUc7uXDjg21jT/CTW5a/aNWs
         4EA92aHdIpCzAUzHCffqYrS+LN04/v86olmFnUzzUbB/Egg/HjDfw00q3MU8cfelNpLV
         b/MLygUoqXBBzNaGGueBJHSa0vx8orWbiM2QySO11vz47zEqLBPfQ/vVoYSghu6fu2BR
         yAQSi70GY/UWCO/J5u2JViNIaOlWOLarvVmgM3Zkp7KulpE/fog6fhPcInFjsNCy+qGg
         nJwipqPgX4OIxu7NOFz687XdMRfJQbU49YLMtAYU+s2XELsLVGlPNIwfKTNnTf19J2Ea
         SCgg==
X-Gm-Message-State: AOAM533Nr2vZV7IGkj8W2gnHAFaMxXUcPdlt40WfOcsLxiKK5wI6tJG4
        cPGNs5TpRqUX8dbau11gNKs=
X-Google-Smtp-Source: ABdhPJzpUpzvO3ELbOUmyO9iu8+McZLz9g/0Xcglf5404MzZZKU07CevL6J1ZnBe9J5zNKU0Y1HEZw==
X-Received: by 2002:a1c:1fcc:: with SMTP id f195mr4663261wmf.127.1599677940990;
        Wed, 09 Sep 2020 11:59:00 -0700 (PDT)
Received: from localhost.localdomain (cpc83661-brig20-2-0-cust443.3-3.cable.virginm.net. [82.28.105.188])
        by smtp.gmail.com with ESMTPSA id j7sm5270080wrs.11.2020.09.09.11.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 11:59:00 -0700 (PDT)
From:   Alex Dewar <alex.dewar90@gmail.com>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: Use kmemdup in two places
Date:   Wed,  9 Sep 2020 19:58:55 +0100
Message-Id: <20200909185855.151964-1-alex.dewar90@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

kmemdup can be used instead of kmalloc+memcpy. Replace two occurrences
of this pattern.

Issue identified with Coccinelle.

Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_core.c | 3 +--
 drivers/scsi/aic7xxx/aic7xxx_core.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 1c617c0d5899..98b02e7d38bb 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -9402,10 +9402,9 @@ ahd_loadseq(struct ahd_softc *ahd)
 	if (cs_count != 0) {
 
 		cs_count *= sizeof(struct cs);
-		ahd->critical_sections = kmalloc(cs_count, GFP_ATOMIC);
+		ahd->critical_sections = kmemdup(cs_table, cs_count, GFP_ATOMIC);
 		if (ahd->critical_sections == NULL)
 			panic("ahd_loadseq: Could not malloc");
-		memcpy(ahd->critical_sections, cs_table, cs_count);
 	}
 	ahd_outb(ahd, SEQCTL0, PERRORDIS|FAILDIS|FASTMODE);
 
diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 2231c4afa531..725bb7f58054 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -6879,10 +6879,9 @@ ahc_loadseq(struct ahc_softc *ahc)
 	if (cs_count != 0) {
 
 		cs_count *= sizeof(struct cs);
-		ahc->critical_sections = kmalloc(cs_count, GFP_ATOMIC);
+		ahc->critical_sections = kmemdup(cs_table, cs_count, GFP_ATOMIC);
 		if (ahc->critical_sections == NULL)
 			panic("ahc_loadseq: Could not malloc");
-		memcpy(ahc->critical_sections, cs_table, cs_count);
 	}
 	ahc_outb(ahc, SEQCTL, PERRORDIS|FAILDIS|FASTMODE);
 
-- 
2.28.0

