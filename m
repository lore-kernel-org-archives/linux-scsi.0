Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAFCCC433C1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 06:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7760F6196F
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 06:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhCVGsE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 02:48:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCVGrh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 02:47:37 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B85C061574;
        Sun, 21 Mar 2021 23:47:37 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id l13so11550349qtu.9;
        Sun, 21 Mar 2021 23:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qxYp036BZ0SZgOSmGvX8X7Hn/TlXHk9QL5sijC0E5IU=;
        b=ZPEKlJoPRutkgiKjUsvgWSdneYkiYLTSTXr+zWJTsXtj4cNAjipl4Z3XP6JkV82EaA
         GIAP3Dpu5NFss7Gr9BTDvPfOminNWh78eipR6D6i7yOe3FHKiSBFgHHlGeBMwCT/DG6N
         gqLaYogmCThxtCjOGca8UUrZF51RyKMxdGJf8oagyHmir9nbGwag+4G1QvDMgx7s4Sl9
         bikH8sanag1nLIZ2xoRug1nPJiiy1jYHPZvqUAK9iqvDBywAx7FwsbZ7UkA+JgZ1/i9T
         RwLYRUN0Qa2XkdaeW7zpX71c/C+QF88McRtW9PahDUiiutT8GZeHKkqr3Wn7p2mmJlm/
         0hkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qxYp036BZ0SZgOSmGvX8X7Hn/TlXHk9QL5sijC0E5IU=;
        b=S9Cv1OAkxnk2MCZoYa/9Xkpo8rMU9t5LFBleV3skcAk/7An2rnVH40bq/gkZ+Z8W+P
         8G975kzNabTzsbcB/x8hJcNEGN/qxnOnQBRKbGdnKStSV1AImzvFT4RSAHuLFe4V4Y9L
         e+TbP+LT8qwwtMXknzEFt4z86Io3Yy7WMcYf4iSd3QWUGqBHNlwEgxIZ2pLa1zhruDVt
         GDcGQJDqVa/8C8pEkp5EoxhqoUfuUap1oICkZ9CkYdP0hD//KftpACweN8otrIMmnwQR
         9JKT/FUXt/HhBDxOGcNCO5R1E76g2Wnxj3c36D0xhbLGE7E17LDcFOw3uZwjBb+rnxye
         koSg==
X-Gm-Message-State: AOAM530GcK9RwO90o6BlmkehV9GntFhnWgDL7/hhUyni5UzCYyYMX2hX
        OMwm6IAePzKtQ2WPuxVaHKE=
X-Google-Smtp-Source: ABdhPJxvFIfETV7B/ih6XnTWA/9UqGflt83D7fwhm1tfCKIiv6DMAW10SgTL1bky3xC6kdp2hVaAQw==
X-Received: by 2002:ac8:5a46:: with SMTP id o6mr8355716qta.289.1616395656703;
        Sun, 21 Mar 2021 23:47:36 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.40])
        by smtp.gmail.com with ESMTPSA id e14sm10193799qka.56.2021.03.21.23.47.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 23:47:35 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] scsi: scsi_dh: Fix a typo
Date:   Mon, 22 Mar 2021 12:17:24 +0530
Message-Id: <20210322064724.4108343-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/infrastruture/infrastructure/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/scsi_dh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 6f41e4b5a2b8..7b56e00c7df6 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 /*
- * SCSI device handler infrastruture.
+ * SCSI device handler infrastructure.
  *
  * Copyright IBM Corporation, 2007
  *      Authors:
--
2.31.0

