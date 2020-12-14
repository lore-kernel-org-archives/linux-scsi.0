Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 744D9C4361B
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45CA722583
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 16:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502034AbgLNQTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 11:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440214AbgLNQQJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 11:16:09 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76B42C0613D3;
        Mon, 14 Dec 2020 08:15:28 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id b73so17696451edf.13;
        Mon, 14 Dec 2020 08:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vXJYk1sYt5MnW2qjVCNzPOZOPPYy5lNnvQwIx2hLAi8=;
        b=afw5ng7ISHEBh1H2Mp6fdH8KTcbpxWvMnlFQWWizwUr965g5XSyvSouqIWRPjFmGu1
         E02ER9J6y6wLX9C8AkjU2hw+xceMkHbApwtSK50RvITVp2R0Vi6X1XFQheO8QqjuGAyT
         7043ObGhn6VUUFzMELmdLB2FYlIjCafsDByTz9rlrjxZ+/khn8jFfMxWBk0v6eN3SLuI
         n9ro/50RaEW0DMBPOWE5YRmc2LDvNZVUB/dFqgnXhVBSj7TVoUrGQemrS89vBzGkwBbd
         rL9OyjB57jWVFTZQXkZDLTLRnw2yQXcluSAMvods+blYcjdigZJIYdv3J8SP3pCC8hUX
         kJVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vXJYk1sYt5MnW2qjVCNzPOZOPPYy5lNnvQwIx2hLAi8=;
        b=gOY5Jw9TmbLnyZuIO0CQnH4WLvTQ9szNRMHAf2TXtG2shNH5l8wYaZcMHrM3YOnXBm
         rMLKck4jJOqF092mMzNj7L7BscYTvqB2P9+o/HYr7OM3icBvu/VEKq2Y+f7LFIk3SHmy
         bzhMEpzjBUEstAsCK22u/gTIcb0DRhuMG5JdCJQyP6AT43/N+sm/aaeVoeO0sFcHE6/U
         1L3voIeobn517fNhxFQgTUh+B2Ig0VOPfCH4V6WmvbAbYvDWP+NIjDMMdeeM1LGRWd2C
         WrlkUL+mhFohHVt3qznOZsT8m6tPP/7Mj2Pd/H3sgiaohONlVuTwEyLQfS3mjoujfMtc
         TIPQ==
X-Gm-Message-State: AOAM530c27U1GdEkxqYl2XPekyI5mgcCEMV20Z/CWD2ZupgT4gHcsQLV
        Xe+R9357vKk7tRLRR2b3GrQ=
X-Google-Smtp-Source: ABdhPJw9pRKSZ3/vKqQA8zaFmdzSG3scbpzu2FMa0zbiVm5gq0BDrWLSKFSMAgqweH+2hdEof7WykA==
X-Received: by 2002:aa7:c3d3:: with SMTP id l19mr26084730edr.366.1607962527256;
        Mon, 14 Dec 2020 08:15:27 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id i13sm6646056edu.22.2020.12.14.08.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 08:15:26 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] Several changes for the UPIU trace
Date:   Mon, 14 Dec 2020 17:14:56 +0100
Message-Id: <20201214161502.13440-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:

V1--V2:
  1. Convert __get_str(str) to __print_symbolic()
  2. Add new patches 1/6, 2/6,3/6
  3. Use __print_symbolic() in patch 6/6

Bean Huo (6):
  scsi: ufs: Remove stringize operator '#' restriction
  scsi: ufs: Use __print_symbolic() for UFS trace string print
  scsi: ufs: Don't call trace_ufshcd_upiu() in case trace poit is
    disabled
  scsi: ufs: Distinguish between query REQ and query RSP in query trace
  scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM
    UPIU trace
  scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM

 drivers/scsi/ufs/ufs.h     |  17 ++++++
 drivers/scsi/ufs/ufshcd.c  |  72 ++++++++++++++++---------
 include/trace/events/ufs.h | 108 +++++++++++++++++++++++--------------
 3 files changed, 131 insertions(+), 66 deletions(-)

-- 
2.17.1

