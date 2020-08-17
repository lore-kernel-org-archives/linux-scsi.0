Return-Path: <SRS0=twx4=B3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B46C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3EDF207DF
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Aug 2020 08:54:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NYaF30VK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbgHQIy1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Aug 2020 04:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgHQIy0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2020 04:54:26 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C528C061388;
        Mon, 17 Aug 2020 01:54:26 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c10so7666976pjn.1;
        Mon, 17 Aug 2020 01:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=bnxXioh0yiQPsqDGs/WZdNyR4Y3nWYKtRgZSCeqOcrI=;
        b=NYaF30VKVufBHJunHpkSU90tB2On6qnirFVgvJbSy7BWgd5aHOmWhSNBusUaftjnzF
         IipaRvhNq/zWrI5KO0/2RSyvHozU28KuvPD+9TBIC9XXndXQkk+eE1bklOXbLGGsh0k3
         X40M2APBFkjc+hTd7qumcLuP7LNbWLM6Pzm7fUdYliDR6j2ThyvyhdPEB69vaWzmnHMu
         Ww6ExG+c5u10qzr8aepJlYsLL7p8O4Wg+9maVodhR5rFuTgnl36RWHqxjiejnsDvSpsh
         ArHH0BIStZoxkcd2Qyqr0qxUW0I3bhfY6IWcvZjJk6jjwaacny6Rq9KTn7l7oM8WeO/M
         lywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bnxXioh0yiQPsqDGs/WZdNyR4Y3nWYKtRgZSCeqOcrI=;
        b=Q1FCnqUmSKpP5lz+QiRHWg2TrAXY5haguT20sQgdh4BmYoDr95elL32VLPcuhJOfmm
         Brug2RRjCmwA7YlE+k7yOjw3JxNpSKS3y0RG2xUv6roRGXl9PSaw8b+Ps0254YAgRKUB
         tgYxQGZtzMThw+9gU1Ei7RWCdoAeagNGJfcQsBtHfufRTeVIPTGd1r3yuYo71rS3ddm0
         745NMf4owLXfFJQ5CnvI8jP7LoooiEgTV+c/I8ZLYmamQ6seQKqleOQphsivX+9D1StO
         BmrxWRTBF2FrPOs0TSoU6yo2i9KueLGXsYL6Ux0RUku99hqAf51dShfQdzMWBeueOeaB
         DnKA==
X-Gm-Message-State: AOAM53237I6D3Bqmc/ruBQb/5B+GJ9u6pvPuk+LbMmVMAhmb5ZoJHv3/
        xIggWM1OahLFn5rP50kXXSq5MVoAmmYbMQ==
X-Google-Smtp-Source: ABdhPJwcyGHQv4SvYAxbBC+SLIY12gRvJ0Zhc1zsyNnZoGYYOxMVvqk79RQml5YrTXuVqckLJjf7QA==
X-Received: by 2002:a17:90a:eb0f:: with SMTP id j15mr11147246pjz.26.1597654466055;
        Mon, 17 Aug 2020 01:54:26 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id x12sm18236990pff.48.2020.08.17.01.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:54:25 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com
Cc:     keescook@chromium.org, linux-scsi@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        Allen Pais <allen.lkml@gmail.com>
Subject: [PATCH 0/8] scsi: convert tasklets to use new tasklet_setup()
Date:   Mon, 17 Aug 2020 14:24:01 +0530
Message-Id: <20200817085409.25268-1-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts 
all the scsi drivers to use the new tasklet_setup() API

Allen Pais (8):
  scsi: aic94xx: convert tasklets to use new tasklet_setup() API
  scsi: esas2r: convert tasklets to use new tasklet_setup() API
  scsi: ibmvscsi: convert tasklets to use new tasklet_setup() API
  scsi: isci: convert tasklets to use new tasklet_setup() API
  scsi: megaraid: convert tasklets to use new tasklet_setup() API
  scsi: mvsas: convert tasklets to use new tasklet_setup() API
  scsi: pm8001: convert tasklets to use new tasklet_setup() API
  scsi: pmcraid: convert tasklets to use new tasklet_setup() API

 drivers/scsi/aic94xx/aic94xx_hwi.c          |  9 ++--
 drivers/scsi/esas2r/esas2r.h                |  2 +-
 drivers/scsi/esas2r/esas2r_init.c           |  4 +-
 drivers/scsi/esas2r/esas2r_main.c           |  4 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |  6 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c            |  8 +--
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c    |  7 ++-
 drivers/scsi/isci/host.c                    |  4 +-
 drivers/scsi/isci/host.h                    |  2 +-
 drivers/scsi/isci/init.c                    |  3 +-
 drivers/scsi/megaraid/megaraid_mbox.c       |  9 ++--
 drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 16 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 14 +++---
 drivers/scsi/mvsas/mv_init.c                |  8 +--
 drivers/scsi/pm8001/pm8001_init.c           | 55 ++++++++++++---------
 drivers/scsi/pm8001/pm8001_sas.h            |  6 ++-
 drivers/scsi/pmcraid.c                      | 29 +++++------
 drivers/scsi/pmcraid.h                      |  9 +++-
 19 files changed, 104 insertions(+), 93 deletions(-)

-- 
2.17.1

