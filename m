Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3045AC41620
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07BE522CAD
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387820AbhASRDn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 12:03:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729921AbhASQjl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 11:39:41 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2714C061573;
        Tue, 19 Jan 2021 08:39:00 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id ke15so21718319ejc.12;
        Tue, 19 Jan 2021 08:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ucsJ2R0Qc3ilotuSyCarYzA2swB00TrKAEr7q7JMHN4=;
        b=mmdbVYi2HwyQ4tIqxxLvcaRKcU+g36mvoXU3UY2Podd8I1U87Gr0HR5o3ogjf22qz6
         SWsjtasH+k/nj9uTDPlcdD+tfqde8LdkImW1uq/UBT6Yev24cruxMMnsXv2GLhKAJ/C8
         Wlda/MqyoUjPaEpEpMdxAc92VTuWEC6U7eXo5qBA0r2cvBz1iU5AsvYaoXLM2OJLypEf
         yOOslc6ALykBqNuiVLK31j6G4UvbUGzUaciVVCgJSDw0YPO2mZ9bRjjwuhWTzzk5gpi+
         BaO2tpHxmsTNm2FWi2i4DRJi9rm2AXpRU3U7GJjaIJFIoxWKE/rEHgjj+l1EmB454VzO
         ZhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ucsJ2R0Qc3ilotuSyCarYzA2swB00TrKAEr7q7JMHN4=;
        b=lfvgpdeie0B7gQdqh7Fo/sNyzOfEsYu53Xr5hG3bVBWmUCEzqJmXKU/2nKVLToVGLh
         6489cCkiiwUnl49fXbrmTGfI6cxgYlI2alp/HAwyqgz0xPM0FvdbT0wnr2TRq3VteIFg
         tlioP3bA16mvst3vKsNJ4zl59B86pG+bFLUUolnUiEdNLnW8r+1hrTU8sptvrE2Prjng
         qMnZkDLQLiaGZRTrBKINwd7VmmbCRtgY/grQ341up4H4ZnaR2Nb2ByrwhLNMNIuV6cn0
         sEf4YxXiEcvnIpldvVMonVUgdukPNHV8mEha/Z3EGRhIxvNc9pdks7NpXw322Fv3gESn
         0g+g==
X-Gm-Message-State: AOAM532Jtz49RClWpi27Nr91yRmtNvPA2YWKzC/DfyeXvobBKMmR85V/
        8kxTEnwxzhg/JEc+jEOdmac=
X-Google-Smtp-Source: ABdhPJwz23xr0dlUxRjCf+BDTWI4R6JyuTpPt2DdQjNmQMnpFPJLTRH8vtmhYrN3n0yjwkQUzOJM9Q==
X-Received: by 2002:a17:906:1f03:: with SMTP id w3mr3572034ejj.463.1611074339411;
        Tue, 19 Jan 2021 08:38:59 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id k22sm9589993eji.101.2021.01.19.08.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 08:38:58 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 0/6] Several changes for UFS WriteBooster
Date:   Tue, 19 Jan 2021 17:38:41 +0100
Message-Id: <20210119163847.20165-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:

v6--v7:
 1. Change wb_on sysfs documentation and add information that WriteBooster
 is already enabled after power-on/reset(Incorporate Adrian Hunter's suggestion)

v5--v6:
 1. Remove original patch 7/7:
 "scsi: ufs: Keep device active mode only fWriteBoosterBufferFlushDuringHibernate == 1"
 2. Rebased patch onto 5.12/scsi-staging
 3. Add protection of PM ops and err_handler for the wb_on entry access

V4--V5:
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

Bean Huo (6):
  scsi: ufs: Add "wb_on" sysfs node to control WB on/off
  docs: ABI: Add wb_on documentation for new entry wb_on
  scsi: ufs: Changes comment in the function ufshcd_wb_probe()
  scsi: ufs: Remove two WB related fields from struct ufs_dev_info
  scsi: ufs: Group UFS WB related flags to struct ufs_dev_info
  scsi: ufs: Cleanup WB buffer flush toggle implementation

 Documentation/ABI/testing/sysfs-driver-ufs |  11 +++
 drivers/scsi/ufs/ufs-sysfs.c               |  46 +++++++++
 drivers/scsi/ufs/ufs.h                     |  29 +++---
 drivers/scsi/ufs/ufshcd.c                  | 103 ++++++++-------------
 drivers/scsi/ufs/ufshcd.h                  |   6 +-
 5 files changed, 113 insertions(+), 82 deletions(-)

-- 
2.17.1

