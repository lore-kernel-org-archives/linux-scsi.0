Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B489C001B0
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbjGXUJI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjGXUJH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:09:07 -0400
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3F710D9
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:09:06 -0700 (PDT)
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3a3df1ee4a3so2519722b6e.3
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:09:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690229346; x=1690834146;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hPH75LFSXng5YSXSx91RHQhZHF6NFSllti+W61i1Hl8=;
        b=XQiSbPAJX+apHYJKZstcR1W4zc28Q0irGvX4T6q0wlmJ2xkKY3ldRNLCt9FxY3ECwj
         9CRMO+tYws352v4/pK4RN2d8r4auzv9Bo4sQ80HqjsnwzBDpknoiwDrYcbG+rsv31zZx
         qJ4jFqIcZy4ljAdLNMr9I7oAElBVSQ8PRQ30hq3DyGaU25hvlwhITrwGa4hBDXtSWaqK
         1GB/YnQp1FP1JHOt4pZdz5KiNe8hMZFvXsARvo6c6c0VVzv8zlLlloB/Qu+7Sr1xTB6u
         aUpt1o8jv9vhj4vcodqeeI2O0J4R0rYcvYqiHtDoKQjoSGG+PR5dgGLM5Ud0Jz5OXsWW
         WM4Q==
X-Gm-Message-State: ABy/qLaJKrZ7pLlp93tduM3sMHFIDZMti4MXxCCQeGkK4vTcwfp8mtqp
        yngNLCkjX6tnn0OOey8L8T0=
X-Google-Smtp-Source: APBJJlGEeUpFtSNJT/rSzu7byXMUcuGc9+pdUqHXTZb6VqcvNiaDhl6JwgvamC6jygQftx7pu+fCMA==
X-Received: by 2002:a05:6808:15a1:b0:3a4:6691:9340 with SMTP id t33-20020a05680815a100b003a466919340mr10415117oiw.41.1690229345727;
        Mon, 24 Jul 2023 13:09:05 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id e23-20020a17090ab39700b002609cadc56esm6726861pjr.11.2023.07.24.13.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:09:05 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] Fix residual handling in two SCSI LLDs
Date:   Mon, 24 Jul 2023 13:08:28 -0700
Message-ID: <20230724200843.3376570-1-bvanassche@acm.org>
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

Changes compared to v1:
- Left out a patch that has already been queued.
- Left out the device conformance checks.

Bart Van Assche (2):
  scsi: ufs: Fix residual handling
  RDMA/srp: Fix residual handling

 drivers/infiniband/ulp/srp/ib_srp.c |  4 ----
 drivers/ufs/core/ufshcd.c           | 12 ++++++++++--
 include/ufs/ufs.h                   |  6 ++++++
 3 files changed, 16 insertions(+), 6 deletions(-)

