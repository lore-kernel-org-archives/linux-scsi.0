Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3D1CC433EA
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0B3220792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UQ2hj2xg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbgGUQng (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730752AbgGUQmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:42 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4980EC0619DB
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:42 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b6so21834539wrs.11
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7qx4BAfYgDhhPFQDU/HlyqhYfKsFS4W9mjWfkuFuELo=;
        b=UQ2hj2xg+Ir7KK2smznJVWTNOEUecpXzU+TAPLzCs6aF3Wyo8+OYyOfbAvGh5Gxmac
         s2GKxxFFysDjGsh2Z7jd2ZE416w9W8E2GolsKMgXWJx1IfSOlFbdPGHM8jljcMIyjDRl
         mDxD2wZ0uC1LO0xOeui+6tWArVFjAIJDSTnP7F0kiLOqlLtdaA4BNpiTD+5wE1yAvAdz
         tIQ4LT1G/dlRmBxhY6HEzD+xNDZZ5RS439RU+8GAzFHUD1aij52J0VjE+Pl8fgmzGj4D
         apYHyYOKUhJlUG3H9CPtP5W5UYPfyMPQfsKYMU64oqjbiEi5r29DpgXY8ZP7oX2aLJqn
         cyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qx4BAfYgDhhPFQDU/HlyqhYfKsFS4W9mjWfkuFuELo=;
        b=Am3oZuXm8wsMG02/YUVUf7/0UXmNSENgxKN+eSF2Fkn0TGjr98ppobHG4zCfxvr/qc
         2GOjZbr0TKLtjEM92GUZRkYfXeYqq9zg9Aqb76PIdHihRfAIXpQ40CeLEejiGfa0plbg
         fVpFuuenrIDdxU5cJMRrNhJC3mKJzs5/lDtkiQMEpiEzChxU9/dJWiU2tZYC02fFZ25f
         RC0o4Jx3I7EdY9+Kx4UqnyWv0WmEfQOv6KRmuaottWCb13Ta5/Ki0SGV9KgOpDB+wqCE
         zMdX9lT6oWotRuNwm6vKlDyK3dlIIdEMG0NmbMz493pO0OVj0189Obnydlf6C8kQc0rq
         T9cQ==
X-Gm-Message-State: AOAM533QwDPv3t/1pX7B2b5fPcwRKubVHlcWEnY/hFNSMB7G7rlnU76O
        3P84fGYf/dvICuDk5pbLb72Slg==
X-Google-Smtp-Source: ABdhPJza5eVdSeLB7HzXvhvbIEwD9pYzG9hkDzvYndt+77Ma1UqLtJqNJ76R7lpCbMqX/7lkigosJw==
X-Received: by 2002:a5d:6651:: with SMTP id f17mr29597442wrw.29.1595349761060;
        Tue, 21 Jul 2020 09:42:41 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:40 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Saurav Girepunje <saurav.girepunje@gmail.com>
Subject: [PATCH 31/40] scsi: csiostor: csio_init: Fix misnamed function parameter
Date:   Tue, 21 Jul 2020 17:41:39 +0100
Message-Id: <20200721164148.2617584-32-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/csiostor/csio_init.c:595: warning: Function parameter or member 'pln' not described in 'csio_shost_init'
 drivers/scsi/csiostor/csio_init.c:595: warning: Excess function parameter 'os_pln' description in 'csio_shost_init'

Cc: Saurav Girepunje <saurav.girepunje@gmail.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/csiostor/csio_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 8dea7d53788a9..390b07bf92b97 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -582,7 +582,7 @@ csio_hw_free(struct csio_hw *hw)
  * @hw:		The HW module.
  * @dev:	The device associated with this invocation.
  * @probe:	Called from probe context or not?
- * @os_pln:	Parent lnode if any.
+ * @pln:	Parent lnode if any.
  *
  * Allocates lnode structure via scsi_host_alloc, initializes
  * shost, initializes lnode module and registers with SCSI ML
-- 
2.25.1

