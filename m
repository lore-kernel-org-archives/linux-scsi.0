Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D40C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3AC0229EF
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Jan 2021 11:36:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbhAELfk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Jan 2021 06:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbhAELfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2021 06:35:40 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47D0C061574;
        Tue,  5 Jan 2021 03:34:59 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c7so30716709edv.6;
        Tue, 05 Jan 2021 03:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qPPsLZerWFE51BU3W/KJIZQXqWk6zyP9GwJShb46KIw=;
        b=dneJjqT+vxmq/8CRmRyETdxa85FevxqTJHh6UJ1r6jU07KcM57uUImPCeGBwgKZP3M
         Hxgri8LVjpd1YZvCq7JQKnoYEl8OOwDjmZtYE0ncSjRtYI5Wacy9IyJqLwTrEAQ7Pca4
         fIIJuxfETbRMnkQrSCoHfQAipUwflyhCpqj+vMjdGRXL5t4DdBDpyoGTcnhOwyWUPhyU
         lu+MzVBoa04xeWunzW77P/mDzlCuUFZtxcgx24UdAX3P+aT4/Cc67cclE+Ab+7NifZPS
         s7ghnoRZYNpSa3LR6N00x2lW5/LVKMdj3sUrkIN8D1eVn1VXnEBYy9pe8itEM71Rt4yc
         pQvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qPPsLZerWFE51BU3W/KJIZQXqWk6zyP9GwJShb46KIw=;
        b=XHInebBYvow0y6FJsg5z/9nd8y70R8m10r4NluLw9SkAvU+COEdGGgrVIAUQClkWk+
         ylS6BPbtxSQO7WCGSLa+rCwxKVAcJVdvAzUjbquptcalqTuMXjiiLj1Ot/3kej/BpJB/
         5qAH0IK6inlwlWT+3nEZEPsAWEI/Igp44jwkc7/mrQH1ItsC/SPRpYKpTNIbMb87uaaf
         DfFceSNcc3KK2L+/LMZZGxbklqjzWsKD6o+x2tUSDOctzC1D9RVGH9jqJVaPrrQ7aOOO
         aPPZ6li00HxVMhfebuT2Hjh5t0PVfsANai/YPRjOR39wApiklS/C085b1B15R6eXhNNB
         M/ew==
X-Gm-Message-State: AOAM5308VzUm6ZSOjUL33tGfxjZYrSyyy+UnXYjSuTdlWZvyfWHs1zrj
        Fnz6uVxBnn9VA6RcNn8aAAcypJlOHXV+Vg==
X-Google-Smtp-Source: ABdhPJxm3USVINeJ8h6gD3kKlwkytvRUK2Vr8pwFVQS3hzpKcxTrhVskjFBUrisRYiEJAepnBfHbEg==
X-Received: by 2002:a50:9354:: with SMTP id n20mr76891365eda.231.1609846498475;
        Tue, 05 Jan 2021 03:34:58 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.gmail.com with ESMTPSA id n17sm24640772ejh.49.2021.01.05.03.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 03:34:58 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rostedt@goodmis.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/6] Several changes for the UPIU trace
Date:   Tue,  5 Jan 2021 12:34:40 +0100
Message-Id: <20210105113446.16027-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:

V3--v4:
 1. Rebase patch onto 5.12/scsi-queue
 2. Incorporate Avri's suggestion in patch 2/6

V2--V3:
  1. Fix a typo in patch 1/6 (Reported-by: Joe Perches <joe@perches.com>)

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

