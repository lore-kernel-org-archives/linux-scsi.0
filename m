Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA6F8C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 09:59:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD28E61029
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 09:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbhEQKAb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 06:00:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34587 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236274AbhEQJ7z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 05:59:55 -0400
Received: from mail-ej1-f72.google.com ([209.85.218.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <juerg.haefliger@canonical.com>)
        id 1lia1G-0002Sb-TW
        for linux-scsi@vger.kernel.org; Mon, 17 May 2021 09:58:38 +0000
Received: by mail-ej1-f72.google.com with SMTP id y12-20020a170906558cb02903d65e5767ebso543550ejp.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 02:58:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SBjcovMcJ4H/KV7YFF8hsif22PyqV7UihiYg3q7oL80=;
        b=pgkW3uH2PgRq2EAWytecnZLuN3ca5vuxVEs36ZiAS4gT8+yoQvMD0pleH6x6Hn0Xyw
         5MSD0ayAh9diKCS37pFg2H6aSG1D+y09GRpEkmXh6h07+ew30nlYEuiaXpBR7Dk5FGjF
         imMTowD3KNpbmi9iBwtLJZu6xtKPiX2lHmlBMw7MndyGDcP5OFzJ/ViollUvWhOAHpr/
         VYd/6YcZx7NGOjufaYZfefAHzbtdrbh1CviJ8xxeIv/WXkTUiRyTb6V8sYATcZY7hJ08
         2sgZDSb6zgbehDnbNuEZCKDu3rm6iIhskoI8pZEqpGBWFcAx6W2rngk3cs7Rof+zJak6
         77IA==
X-Gm-Message-State: AOAM533nWn0Bit3LPvEnvj+FczdG+1Z8QPMQJQZsObuK4x5PBJBdsW0j
        oLmS5HBlBTFj5Trmzj9CmK+gH+YSzZx2fDu/YtbGqBNpBdNe8pQaQyBBTBhWDb6ja4oMFwuWGI9
        Wt/0teNfeTPtvF7QwokgnS49MYrQMjG+Oy1FEPk0=
X-Received: by 2002:a05:6402:19a7:: with SMTP id o7mr31417022edz.22.1621245517941;
        Mon, 17 May 2021 02:58:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjVbKinq9KaD/Ql0BY02wWm1LkfUNxBYm6cyHlXXoI2sY6X6qpn5L7XW1kPA7eTqkRs9uxQg==
X-Received: by 2002:a05:6402:19a7:: with SMTP id o7mr31416982edz.22.1621245517486;
        Mon, 17 May 2021 02:58:37 -0700 (PDT)
Received: from gollum.fritz.box ([194.191.244.86])
        by smtp.gmail.com with ESMTPSA id i8sm8803648ejj.68.2021.05.17.02.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 02:58:37 -0700 (PDT)
From:   Juerg Haefliger <juerg.haefliger@canonical.com>
X-Google-Original-From: Juerg Haefliger <juergh@canonical.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, juergh@canonical.com
Subject: [PATCH] scsi: Remove leading spaces in Kconfig
Date:   Mon, 17 May 2021 11:58:35 +0200
Message-Id: <20210517095835.81733-1-juergh@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove leading spaces before tabs in Kconfig file(s) by running the
following command:

  $ find drivers/scsi -name 'Kconfig*' | xargs sed -r -i 's/^[ ]+\t/\t/'

Signed-off-by: Juerg Haefliger <juergh@canonical.com>
---
 drivers/scsi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 3d114be5b662..c5612896cdb9 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -311,7 +311,7 @@ source "drivers/scsi/cxlflash/Kconfig"
 config SGIWD93_SCSI
 	tristate "SGI WD93C93 SCSI Driver"
 	depends on SGI_HAS_WD93 && SCSI
-  	help
+	help
 	  If you have a Western Digital WD93 SCSI controller on
 	  an SGI MIPS system, say Y.  Otherwise, say N.
 
-- 
2.27.0

