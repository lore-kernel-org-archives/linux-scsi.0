Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 863EFC433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D02022DA7
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437842AbhARULm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437857AbhARULa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:11:30 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EAE6C061573;
        Mon, 18 Jan 2021 12:10:50 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id s11so11670823edd.5;
        Mon, 18 Jan 2021 12:10:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J2lGSje/t96HRnhu7U2uaaKspvjeI4RxTKrY+0OroNo=;
        b=HCo5aaSUvJDkL5g8BT99WGeWQTYwt9Km77uI5q1/PdWgXrDRWwCHXPmS2oYb5lGgkP
         xV3QFvYD4JiZUPpMFqGmsduB9yg+GfwiJl/FurnaWhdmjKZPDVT0wiNGDak4gr0EdLSE
         0NS5RAhptwI5CzeWIRoOzku8t5D70rOevZMcbjnjRAEFiWsUiCJrB/+yHas0/eptmTj2
         v/MJ1yG2VvPAthHjsqsuImzuS8aKeESsSoLdvEBEDe/Y7GewcgmlvwH8YC3N/S0DdgJJ
         lWSSfJOPF2Yk8HVqiq241CPtK5CHBY+pUmIFftt3b4YnlkrsypgCbPt3xHzpp2odhNx8
         JWyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J2lGSje/t96HRnhu7U2uaaKspvjeI4RxTKrY+0OroNo=;
        b=sx2InV28uLcN3+NbAMX3PH4V2EJLI8DoY3CV3Q8PpJTrUxyCn1+uNCHX2i2gunQUK2
         TZSl2oPgoq3bs93LZ7JX5ZN5KX55SyxpUDjBIZOhM7LnhTutk9N/aZ3ca8KlE/Qm4DVj
         K8rarAszdDRRnKs1nsFjD11+D11Uv4pXcMRTCiYGzgrMeW7E3bEYhCSqfhVaUhJJXhnA
         OQCygXIMk4m17uOOrHx1AjzwuR6U/Sh4fwrqCy4MzIrf64xQUYHiaPFoT18vVF6rmszA
         COx+L92Cbaa612y4J79rAvM9YtVsgrCSRjMaRWeEUCQnYTA5FpO0v/QMT8xcxAn+b+7n
         eTUg==
X-Gm-Message-State: AOAM532DmGlF74yLFfzMxxCeiV9Ip7I0thRK0yn4GWScQRXYo+SdBNCh
        PVlG9rLR+PkQmRZHK51AS9Q=
X-Google-Smtp-Source: ABdhPJwsPGDVkoWyMaKh4k/5jFkQDyIAlKMitx5et0e6NS019tRR/reJIBp1FbTZaER81rPV2ArwPA==
X-Received: by 2002:a05:6402:70a:: with SMTP id w10mr878192edx.184.1611000648770;
        Mon, 18 Jan 2021 12:10:48 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id qh13sm3972543ejb.33.2021.01.18.12.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:10:48 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/6] Several changes for UFS WriteBooster
Date:   Mon, 18 Jan 2021 21:10:33 +0100
Message-Id: <20210118201039.2398-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:

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
  docs: ABI: Add wb_on documentation for UFS sysfs
  scsi: ufs: Changes comment in the function ufshcd_wb_probe()
  scsi: ufs: Remove two WB related fields from struct ufs_dev_info
  scsi: ufs: Group UFS WB related flags to struct ufs_dev_info
  scsi: ufs: Cleanup WB buffer flush toggle implementation

 Documentation/ABI/testing/sysfs-driver-ufs |   8 ++
 drivers/scsi/ufs/ufs-sysfs.c               |  46 +++++++++
 drivers/scsi/ufs/ufs.h                     |  29 +++---
 drivers/scsi/ufs/ufshcd.c                  | 103 ++++++++-------------
 drivers/scsi/ufs/ufshcd.h                  |   6 +-
 5 files changed, 110 insertions(+), 82 deletions(-)

-- 
2.17.1

