Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32CC6C43219
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FAB222D08
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 00:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391759AbhALAZo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 19:25:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403832AbhAKXLw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 18:11:52 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C810C061786;
        Mon, 11 Jan 2021 15:11:12 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id i24so236757edj.8;
        Mon, 11 Jan 2021 15:11:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PNrKOWpeQ8TNDhDgZ+AtRxMiWuAnBXCXVKCEOv6JX3k=;
        b=slXzPALxignK5OGkPXKWGS1QKbGvx2b/m2Y6iE33SPoQTJCA0t/YYxSFv+i21d+MGS
         WxnJGlXLtNTB2P8QI7gaWCNKgFsVGCbjPzQxC13t06kRCgAB+VkJCaVsMI5qeFnLNtW/
         WMTSMR5IeHUV3S8R0GOXKrFQF4ADTI9+QdnmDDeOTXJ0xwEHNvyD2S3jAEP5P0dwXIVZ
         pjST+UONBFuHdQgUcOSipdmF2wfbqhf0OdO15LmxYcKdMEvszWx/r32cSLrdZ6Rqw7HD
         1PefNgTVXiBFo+ucJGucqa5WnG4k4M4JK0x78xIkrN91+T2Ky+dI3uB98To3qAeiB6gW
         fU9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PNrKOWpeQ8TNDhDgZ+AtRxMiWuAnBXCXVKCEOv6JX3k=;
        b=Dsi6DrqNwnbpZa5d+PfRKlN9hH/ZuR1NCPSB2JglpmEGqn4POzSHqjMvxKMXuMGfsf
         oQc/D6nQQ0e04Fxx4djgpGsUYuYRHg0fOVOkjU6Z3VM6PIoYokscEwsGlBgQYQZLBg7i
         7qdJQDFtafPpH6rGB0r4rVgmIC0qm2x95kMh51pEqALF/04Rhsq8RrJ+cAZrWdIaHDWx
         DtaTl25p0CLZqDdID8+kllpZogYF/D6SL5uZlLkxw3QxdW+m7At1srFlP4Muz/2S/Dxm
         ICGFKmVmliFSORpdvJ84NllPrqrqqGsi4jhSeMUETZN4JNIgjofGjLd3b17BXhKnPJX4
         NUlw==
X-Gm-Message-State: AOAM533Aug/wsrPxEIh36m3e2SG4VpGpToBXEaHBvAJEBRsR1TREL/6m
        Gi/pBNLxpiFc/IIWPLdpe8k=
X-Google-Smtp-Source: ABdhPJyChlVC1zSMOrcRlaoMGKhjGOzpVnhN3kYvxcBhVlZmfYuAhpweS3Yu7CC3rzmbpQ/qb6gq2w==
X-Received: by 2002:a50:e846:: with SMTP id k6mr1175118edn.245.1610406671087;
        Mon, 11 Jan 2021 15:11:11 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id ch30sm598175edb.8.2021.01.11.15.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 15:11:10 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ebiggers@google.com, satyat@google.com,
        shipujin.t@gmail.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 0/2] Remove unnecessary devm_kfree
Date:   Tue, 12 Jan 2021 00:10:56 +0100
Message-Id: <20210111231058.14559-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:

V1-V2:
    1. Remove unused variable i in patch 1/2
    2. Add Eric Biggers review tag in patch 2/2

Bean Huo (2):
  scsi: hisi_sas: Remove unnecessary devm_kfree
  scsi: ufs: Remove unnecessary devm_kfree

 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 28 +-------------------------
 drivers/scsi/ufs/ufshcd-crypto.c       |  4 +---
 2 files changed, 2 insertions(+), 30 deletions(-)

-- 
2.17.1

