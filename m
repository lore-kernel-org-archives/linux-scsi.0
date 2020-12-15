Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9D5C3526C
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC85222D08
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Dec 2020 00:00:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbgLPAAr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 19:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730231AbgLOXGM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 18:06:12 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F22C061793;
        Tue, 15 Dec 2020 15:05:32 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id u19so22858617edx.2;
        Tue, 15 Dec 2020 15:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f7i9PtN45U0UcFrfF4C9zZcvaiZJrrBU8O2nLkXVNNY=;
        b=vaEJrBaeXVXGjz/7marcrAvcGt+pNp8wFg3xnAEXbXFvrltLW4kVon8tyspPKjRg6B
         HAq1OkTZKKL0W6D+iU3cOkjuk5waXM6DwT2Cd2C1k5EFYnWjuvnMUJbmtXYjWhHjJiHh
         qAm3jojaIhzV2R5NPXfaizMMYu6NoRlUbF+0olmuX4f9aaXYf3tTHt2iESYs1xkHacLr
         t1tXs4lTmOvxZ5KrhhDTuDOAGjRfdXk4gsN/rbnlFSVlE00pRoVgHm8yIGoMzPw9hAXx
         t44klwYbhsNzDpWsFG2ZrKbkFOOJpEV728dt3rUzQ6ZU/9x8Xn58MAncBm3mfuC9Nt9/
         VP7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=f7i9PtN45U0UcFrfF4C9zZcvaiZJrrBU8O2nLkXVNNY=;
        b=mMYa2wssNq66V6ol1nzismmX3YBuyGaTWpYAtW+sVjVYbNVrzhIdqbKCAAIfYg5FZi
         gadC/FSP++8JsSWYpFQcO1chHAmOQhxy6VMbR1c7qvNlon+t0wyH3XAZepPePhIWNNNE
         A3hhZZdY5BRfXbiQVbOmY8SU2gjdw8ep++S/YPtj5uChf0T5zh6c4lGCL5nLz5Vh85mL
         OSeaAWW97+DnZI8CV0adzqnz+LE4LjWuorKhQuGet0rzxZKEPKx8rAGKSJCtR7oFAXRt
         SaWl2zsEoomiHXHSHI3qGcum89jgWSt9j8UCBUYsCwFQ/1HwEvcx7JcmG84XCJv2vQf1
         tEAg==
X-Gm-Message-State: AOAM530ntMjzTEh7QZRD2JIEcXUDfSzA18BzwLUF3d5bv9HS/3NGmwUP
        cUQgwb+jl0fdsvIthDLKMXc=
X-Google-Smtp-Source: ABdhPJxG/rjDJGeTZhHgpKRGCnYq5XHIiU2WyYVt4L1YCHsj5g6UZUC3FFE4zo1nE2O7N+3BVFa4nw==
X-Received: by 2002:a50:ec18:: with SMTP id g24mr4299005edr.6.1608073530937;
        Tue, 15 Dec 2020 15:05:30 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id e11sm19280455edj.44.2020.12.15.15.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 15:05:30 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/7] Several changes for UFS WriteBooster
Date:   Wed, 16 Dec 2020 00:05:12 +0100
Message-Id: <20201215230519.15158-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:
V--V5:
  1. Add patch "docs: ABI: Add wb_on documentation for UFS sysfs"
  2. Unify WB related flags with wb_* prefix (Stanley Chu)
  3. Delete d_ext_ufs_feature_sup (Stanley Chu)
  4. Incorporate Stanley's suggestion to patch 6/7
  5. Replace scnprintf() with sysfs_emit() in 1/7 (Greg KH)

v3--v4:
  1. Rebase patch on 5.11/scsi-staging
  2. Add WB cleanup patches 3/6, 4/6 adn 5/6

v2--v3:
  1. Change multi-line comments style in patch 1/3 (Can Guo)

v1--v2:
  1. Take is_hibern8_wb_flush checkup out from function
     ufshcd_wb_need_flush() in patch 2/3
  2. Add UFSHCD_CAP_CLK_SCALING checkup in patch 1/3. that means
     only for the platform, which doesn't support UFSHCD_CAP_CLK_SCALING,
     can control WB through "wb_on".

Bean Huo (7):
  scsi: ufs: Add "wb_on" sysfs node to control WB on/off
  docs: ABI: Add wb_on documentation for UFS sysfs
  scsi: ufs: Changes comment in the function ufshcd_wb_probe()
  scsi: ufs: Remove two WB related fields from struct ufs_dev_info
  scsi: ufs: Group UFS WB related flags to struct ufs_dev_info
  scsi: ufs: Cleanup WB buffer flush toggle implementation
  scsi: ufs: Keep device active mode only
    fWriteBoosterBufferFlushDuringHibernate == 1

 Documentation/ABI/testing/sysfs-driver-ufs |   8 ++
 drivers/scsi/ufs/ufs-sysfs.c               |  41 +++++++
 drivers/scsi/ufs/ufs.h                     |  30 ++---
 drivers/scsi/ufs/ufshcd.c                  | 124 +++++++++------------
 drivers/scsi/ufs/ufshcd.h                  |   6 +-
 5 files changed, 122 insertions(+), 87 deletions(-)

-- 
2.17.1

