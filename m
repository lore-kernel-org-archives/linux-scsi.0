Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FD9BEB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 16:02:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232421AbjGUQCc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 12:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbjGUQCL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 12:02:11 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85782D7F
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 09:02:09 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1b8bd586086so15801435ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 09:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689955329; x=1690560129;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ads2tvNQYf4Lt2uFdH7HVBipxYyzC/gcbPghJ2mZ6VQ=;
        b=TnCP6bhWH5aDkLvROE/9or4DyEXdbKscNWVMgYn6KKEdsd8KcIM5zhjYcCQRTm5+Vw
         z/A2sFlR1TSvCqwCVsr49XrUQj3wALDyFuRV9r+Ka702V+MG/NMA8A2DxWLQ/oHfAwZL
         NScpG787gFOq2ELh9jaBebhRp/A17yPIt6s0ZsiWJvLuaP8t/yMdnu5jnWvFZtBKiuvO
         pqZEuvJum0784MkjOcgPh10HS0Y8/aeqzSuOtNgannzYN/nNpBRWqBFwXIDKBoJH2rAI
         NAujDpJ2n6E/aNq4/0lHu1V5i7vgQfCV9f4QzW4ogHiEDTMGqCQIlwt4X2LojTDV9LJd
         nj9A==
X-Gm-Message-State: ABy/qLZaLN3EpsldZ3vCvUdkbXNon8JrxgSgaHFIBNfi5TXfM9p0qJfJ
        wcFVnaHOsdThi2Z4av2t0RI=
X-Google-Smtp-Source: APBJJlHamcoKjOVZptFf69pWMrgF41/U8l1iS8wJgy3jkkuwuhbCEYIYnIhzIti48kDcFE7qj26G+w==
X-Received: by 2002:a17:902:d4d2:b0:1b8:e41:f43f with SMTP id o18-20020a170902d4d200b001b80e41f43fmr2763473plg.27.1689955328996;
        Fri, 21 Jul 2023 09:02:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5043:9124:70cb:43f9])
        by smtp.gmail.com with ESMTPSA id s24-20020a170902a51800b001b890b3bbb1sm3652298plq.211.2023.07.21.09.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:02:08 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] Fix residual handling in two SCSI LLDs
Date:   Fri, 21 Jul 2023 09:01:31 -0700
Message-ID: <20230721160154.874010-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes the documentation of scsi_set_resid() and also fixes
residual handling in two SCSI LLDs. Please consider this patch series for the
next merge window.

Thanks,

Bart.

Bart Van Assche (3):
  scsi: core: Fix the scsi_set_resid() documentation
  scsi: ufs: Fix residual handling
  RDMA/srp: Fix residual handling

 Documentation/scsi/scsi_mid_low_api.rst |  4 ++--
 drivers/infiniband/ulp/srp/ib_srp.c     |  4 ----
 drivers/ufs/core/ufshcd.c               | 19 ++++++++++++++++---
 include/ufs/ufs.h                       |  6 ++++++
 4 files changed, 24 insertions(+), 9 deletions(-)

