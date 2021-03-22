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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D1A4C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 03:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C84761944
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 03:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhCVDWU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Mar 2021 23:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhCVDWB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Mar 2021 23:22:01 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41595C061574;
        Sun, 21 Mar 2021 20:22:01 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id cx5so8005280qvb.10;
        Sun, 21 Mar 2021 20:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xYLZRnjHYG+bHDPM8gW4BRB6qxcozKItH3oDIxTxLds=;
        b=I+VPygDWJcfEx9dy+CNio3QEeqYBK+PtiCIQ8dcZtS4IeZWiaXRBLpdVNj3uBjkwEF
         eeCVvJEUgI81pADi4pczgG6yzIDNIXrgU5TzUOsN1zGdoKchIjOaZqPKVCgL6VKgaWAb
         ABB/u35i1dmehN12NyZtEZJfuCKpU+IiP1ophhb7zVh0ovWX3W95K4EUCbEeqwOgjuwo
         CPjm0+3vnCb64yRHG83gFBYktOg8b//b2C1tmZM6wzNzi3omL9m9DmbyY5+0VUpm4gMG
         5t/JXKBurNjyJDh/2hB921Oy0KjDWIbG1ph4hdx0SesaVFT9K1vGm4lb/0GU4i8ypw0L
         ADNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xYLZRnjHYG+bHDPM8gW4BRB6qxcozKItH3oDIxTxLds=;
        b=LjIUhm8/44iIzC1HsI/vgDaICRvkISTGM0FDvQTp5HqiBOLixY+X7LQiqQoY8/HhDl
         6cwRxnQhE6W7U8tw0gCIdoNbJWmWAbQwefJyCzV8QiS44R29e1Nc2wbh+UbHFF9L0Z0T
         rv0vvX+AiQPv1dOePKvQ69SIswLWs6RILH5LGpZy+yl77g9VHmrXSz6vHeWpK9qwfIjC
         mN8Ueevo4+Bl/mOjMqd+AA+xgm/71FH1hvMTcU5t487wvk3SSOkRvsg4SEYQIbSanPz4
         CANtelqVBcw747HGnuQlxMR3wCiWukPN0uhOa7Gq/40E7r40lufpcfdFEKQeL/ujdyuL
         +X4g==
X-Gm-Message-State: AOAM530JZAOBhzWYk1YFQMV1cJ6Fjz+lwuSA+kdl4mGieqo0Vmx21/iC
        DTQvxW0YUAzoc7N85VCthQw=
X-Google-Smtp-Source: ABdhPJzFRLqbBANlRXbIPRExiU7fEpPebskd25FpiN9sB5dRQmEZeZvHisCVwadnOeQ/nbLR/GBgpg==
X-Received: by 2002:a05:6214:15d1:: with SMTP id p17mr19404680qvz.28.1616383320293;
        Sun, 21 Mar 2021 20:22:00 -0700 (PDT)
Received: from localhost.localdomain ([156.146.54.190])
        by smtp.gmail.com with ESMTPSA id 18sm10235065qkr.77.2021.03.21.20.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 20:21:59 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] scsi: mpt3sas: Fix a typo
Date:   Mon, 22 Mar 2021 08:51:45 +0530
Message-Id: <20210322032145.2242520-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/encloure/enclosure/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ac066f86bb14..398fd07ee9f5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5232,7 +5232,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
  * mpt3sas_free_enclosure_list - release memory
  * @ioc: per adapter object
  *
- * Free memory allocated during encloure add.
+ * Free memory allocated during enclosure add.
  */
 void
 mpt3sas_free_enclosure_list(struct MPT3SAS_ADAPTER *ioc)
--
2.31.0

