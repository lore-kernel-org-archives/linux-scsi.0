Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD7B0C2BB40
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A67E02312F
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726746AbgLFKOq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 05:14:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgLFKO3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 05:14:29 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F797C0613D0;
        Sun,  6 Dec 2020 02:13:49 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id ce23so11383092ejb.8;
        Sun, 06 Dec 2020 02:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o3woUKLEE6wEcnBKypRYNGZMB9+xn3IKHhO5cYS1A30=;
        b=V0iZLo5XMiinxvv5L1ffXpJRF9rSKaReN2td6SRBqn7Y6+7nL0onHO3zBfK9UJYoYd
         vc29jT9G/xaV1hMEHbr4zXbfNa4P86cHCFjnsJlzf562mmFakLh3XSm38Sd7FcUhHqVE
         pEq8U7hQRxkHt2E9EmwAQuSqDefrrSdQaCdgiwCNzndhw64KO8JhzCKgvzbYhMHmTKSQ
         DE4NmQEC6m24xEl86hLo+cF+fGUXSJkp/OxQK15aNFFCZlPboOe4BqSFmL1WYqjRAo9M
         UIt1VOSVUz0qIwUSOGsDRUIn7KX/WGyN8FUJNLSgsy+UBIpcSXPiVFnMel3ko2p6kxIY
         mPRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=o3woUKLEE6wEcnBKypRYNGZMB9+xn3IKHhO5cYS1A30=;
        b=IdhRPHVy05+oLOY25rqibLMB2z2M9cq0JfR6RGh5v88lqk4QKobtsjzv3koJGORuUO
         KcA+Y7KB3bWhgWnG+YB8AYvC5UO78L/rvNzIA4aTUOH/CVhugfmt6FRVRfBPpCTMiGcY
         4z3Ozul04bKASZW2bW/C5e5IguYWh9wJsSSe86zcI7nAbkvoNd+usvpg8vm+wBURDk6Z
         AmyQeGFw3uch/n4vGtNsqOiixvxrkpoduuMpBXD9/D4uaWiZzMyeUyalY9a6b9rjtTbU
         szRFy4J4ZwaSppeYepKh/MasLF1P0Cd6HrNUGvUlzhmWfbzGPyDmletz8+/LirlZaL6I
         blbw==
X-Gm-Message-State: AOAM530mRo3WqLiwoMsayR4ptOV0Tu4r2TWCCgtCs4bddQD5tp1uhByp
        h7m/fjrIFC5N2mYAPbjhQDA=
X-Google-Smtp-Source: ABdhPJzRdaxYklwSkZt+6LjbGOc9MFgHtdT72fpEr09ToDDfoWdDtJJtfXne6HdYWuBV7MaGqqq+5w==
X-Received: by 2002:a17:906:9613:: with SMTP id s19mr14721362ejx.351.1607249627830;
        Sun, 06 Dec 2020 02:13:47 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id f24sm7701919ejf.117.2020.12.06.02.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 02:13:47 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] Three changes for UFS WriteBooster
Date:   Sun,  6 Dec 2020 11:13:32 +0100
Message-Id: <20201206101335.3418-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:
v1--v2:
  1. Take is_hibern8_wb_flush checkup out from function
     ufshcd_wb_need_flush() in patch 2/3
  2. Add UFSHCD_CAP_CLK_SCALING checkup in patch 1/3. that means
     only for the platform, which doesn't support UFSHCD_CAP_CLK_SCALING,
     can control WB through "wb_on".

Bean Huo (3):
  scsi: ufs: Add "wb_on" sysfs node to control WB on/off
  scsi: ufs: Keep device active mode only
    fWriteBoosterBufferFlushDuringHibernate == 1
  scsi: ufs: Changes comment in the function ufshcd_wb_probe()

 drivers/scsi/ufs/ufs-sysfs.c | 40 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs.h       |  2 ++
 drivers/scsi/ufs/ufshcd.c    | 30 +++++++++++++++++----------
 drivers/scsi/ufs/ufshcd.h    |  2 ++
 4 files changed, 63 insertions(+), 11 deletions(-)

-- 
2.17.1

