Return-Path: <SRS0=hn2k=XJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 486AFC4CEC9
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Sep 2019 15:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11A292081B
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Sep 2019 15:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KQ065vRz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfINP5n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Sep 2019 11:57:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42164 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfINP5n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Sep 2019 11:57:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id w22so19907587pfi.9
        for <linux-scsi@vger.kernel.org>; Sat, 14 Sep 2019 08:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7gb2w0lTEaHLV6TgMpWdbnseQk+uyKfIxwtSBRN98gg=;
        b=KQ065vRzhQDGDljsibjyRn0U6s9feJX2uvuSmQbsouYrpJ7Lo5kw5pg5kRGAJsqrRt
         wK4PzNVvTHN9wKux7kX+6C3V0VeHjveP/Dlf1O9frh7Jz89oMr3nOjFWxLIo48g8cV+q
         TxXGfBSKPTIzxDhp4LEr5ZAo//qjn4riLytzTEHwpGI49nAwQO6oFX9t5tQsl0CzJW/v
         ynBDLZr5KUWfMc2bPY2J70Vt18z1ipDEy9SOPtaaSw6D+qzqnrq7OUgWM/D/m7Zd+ZdP
         YKaLfZs0N4Nm7Izjne/SMK2yb0Jyiiwu1BMdiALpQCwhBW6uCujVYa0iujf7fpSK28xT
         U/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7gb2w0lTEaHLV6TgMpWdbnseQk+uyKfIxwtSBRN98gg=;
        b=JVSnSOWg6Sb5JgofzIcgBRKB3sl0Xa6ItoZeaSFRHaRAhEHPgTSnf3WNJvK+216FIn
         AVXOCoQPvYup3gzme8G31/5DEnbeRDZhLB3sEliLhsqfu/1irEJMIH0jXZbKL8kOIAqF
         Bm8cBCZ0RN3ViUjU+E6QNaVkhxSXJ7Q5GReac9zWVKADxKcJA7LmAB6QiI//7BAFFZEP
         AHYe4TFhTVDITqYa/Ms0yMSfpmfNGmexl+3T9wiM1Ur1OP70pGdUxyS/+leBrGz9lDhp
         0F7BfweFYENjLCbrZ2f+dsoaGLly7oTxD/osb66AFasYJMn3c9wHY18LioMS5pbkuUPs
         P7ig==
X-Gm-Message-State: APjAAAXQM4tamORfu260RXXuknEIrxT6Av3qUjk+7+V5FgKolVXlOhOT
        r2XZF4FAKA+7UPgowlaF//o=
X-Google-Smtp-Source: APXvYqxoVLEhkqBzNg4yYBW6glqiEDfOuc8EfnX0LwfR7W6FCcCDwK/JqgP+ENUTjNegMe8W/u0DdA==
X-Received: by 2002:a17:90a:9313:: with SMTP id p19mr11901716pjo.0.1568476661372;
        Sat, 14 Sep 2019 08:57:41 -0700 (PDT)
Received: from localhost.localdomain ([103.228.147.172])
        by smtp.gmail.com with ESMTPSA id h66sm6311825pjb.0.2019.09.14.08.57.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 Sep 2019 08:57:40 -0700 (PDT)
From:   aliasgar.surti500@gmail.com
To:     hare@suse.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Aliasgar Surti <aliasgar.surti500@gmail.com>
Subject: [PATCH] drivers: scsi: aic7xxx: made use of kmemdup instead of kmalloc
Date:   Sat, 14 Sep 2019 21:27:31 +0530
Message-Id: <20190914155731.29019-1-aliasgar.surti500@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Aliasgar Surti <aliasgar.surti500@gmail.com>

There is usage of kmalloc following memcpy in this driver file.

Instead of using these functions, this change is made to use kmemdup
which has the same functionality.

Signed-off-by: Aliasgar Surti <aliasgar.surti500@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index a9d40d3b90ef..295503d27332 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -6907,10 +6907,10 @@ ahc_loadseq(struct ahc_softc *ahc)
 	if (cs_count != 0) {
 
 		cs_count *= sizeof(struct cs);
-		ahc->critical_sections = kmalloc(cs_count, GFP_ATOMIC);
+		ahc->critical_sections = kmemdup(cs_table, cs_count,
+						 GFP_ATOMIC);
 		if (ahc->critical_sections == NULL)
 			panic("ahc_loadseq: Could not malloc");
-		memcpy(ahc->critical_sections, cs_table, cs_count);
 	}
 	ahc_outb(ahc, SEQCTL, PERRORDIS|FAILDIS|FASTMODE);
 
-- 
2.17.1

