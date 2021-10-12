Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1376C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 19:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A41E6101D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 19:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhJLTU4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 15:20:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbhJLTUz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 15:20:55 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6262C061570
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 12:18:53 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g5so223337plg.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 12:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=ZZtSWSDRB78yGnECZJAWGcx+H4ZoF/5v88OV0c1KOp8=;
        b=JrtseSZjVsKMYKGARw7Rwp0QH2ZZGbGHch8gNzkppkgDwdQfaFaF6eXVr5jPiv+IhT
         2v36weENP4uA11RWDNCBwechb0NEi99M6zcAJ/wbBrpn6HbJfbzS54nqpaT4wo0sXG4Z
         vgHdfPMGUUDWpQLJ869AyGTAiwTj7s93B1G1Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ZZtSWSDRB78yGnECZJAWGcx+H4ZoF/5v88OV0c1KOp8=;
        b=jb36dLxI1Pnss3TAuKhmgrfK15nWvnMqlDiBf/2LvtLTTB87QwdGjjphNdADdD6NMI
         l/i6A5Zv9QqpRri7HRC7tCJgB41htfT2x+/435g4UnOohiBG87dE98R9Lzl2q7mJQG+Y
         yr41khQ05Llu7d5egX69qLmUy/67DO/rRuH5XIhlvyyTDRH5383pKQAIePXKTU7uDcpt
         U2ar6WFAlTLEYyJIsmIKpekLax6tzK08pSjJoPXjphMtmhcEO7PNphNkAewvEBHIZRxw
         3FBcpZ1+t6D/fBJXrxdjOYKfPFMfVlec9HiOGcRhUK1uYX03QVIXVddDlnCzE2zIHlwC
         7YWg==
X-Gm-Message-State: AOAM531YSGdR0TTFops5FMWWRbdL6wVSuJcWuFs1F06Y00p9TvI62uBg
        ZLsAq578klbqf817WGdVtedutHWUV3sErgLUajpj+CDKWgEb0HISM+U0UZAaststUqyqQ9a9QJL
        awC45NK5YyYSzd4gCozdISfMagV7iNpUYh2LQ2A6ykgyG56DlSdcyLui71bca5bsOmnVGVjluxx
        GMjV6pdgdB
X-Google-Smtp-Source: ABdhPJzGKDN3O/tBDaktpo3hU16Wf5BB+6oSbUB0ncVDe7C8QlxBkLPXeo/sx06EuW/bDHB9ng1RcA==
X-Received: by 2002:a17:90b:1d8f:: with SMTP id pf15mr8011887pjb.70.1634066332818;
        Tue, 12 Oct 2021 12:18:52 -0700 (PDT)
Received: from dev-jgu.dev.purestorage.com ([192.30.188.252])
        by smtp.googlemail.com with ESMTPSA id 139sm11838872pfz.35.2021.10.12.12.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 12:18:52 -0700 (PDT)
From:   Joy Gu <jgu@purestorage.com>
To:     linux-scsi@vger.kernel.org
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        bvanassche@acm.org, Joy Gu <jgu@purestorage.com>
Subject: [PATCH 0/2] scsi: qla2xxx: Fix bugs found by CodeSonar
Date:   Tue, 12 Oct 2021 12:18:32 -0700
Message-Id: <20211012191834.90306-1-jgu@purestorage.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Joy Gu (2):
  scsi: qla2xxx: Fix a memory leak in an error path of
    qla2x00_process_els()
  scsi: qla2xxx: Initialize uninitialized variables

 drivers/scsi/qla2xxx/qla_attr.c | 2 +-
 drivers/scsi/qla2xxx/qla_bsg.c  | 2 +-
 drivers/scsi/qla2xxx/qla_init.c | 6 +++---
 drivers/scsi/qla2xxx/qla_mbx.c  | 6 +++---
 drivers/scsi/qla2xxx/qla_nx2.c  | 2 +-
 drivers/scsi/qla2xxx/qla_os.c   | 8 ++++----
 6 files changed, 13 insertions(+), 13 deletions(-)

-- 
2.17.1

