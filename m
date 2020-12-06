Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B57C4167B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 16:43:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F3E2336D
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 16:43:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgLFQna (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 11:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbgLFQn3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 11:43:29 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D26C0613D0;
        Sun,  6 Dec 2020 08:42:42 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id x16so16004779ejj.7;
        Sun, 06 Dec 2020 08:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Q6ExZ117A0aM/vhFUmbVwSY0OK3ssVDA0XzgyTgogbY=;
        b=oa5Ad8htSNHvj/Tdm++f/s9AvO7MoWOrXJPAb0LPxHNfb06kZbPQliv8BmR+toZIZx
         n2LBLRyULnezXirBOE6iL2pe1Ws+o61u7/bqMHrtIgTQpFfc1LnIDgbXKdM8S2bp4vmw
         Fh8QSyyo9uO4LZy87oDnh8eg3ivL2Vyqyt809od1mUvAS2UXp6SZS+WJs6XDcVlIvUiL
         Xexr7BjA9sMuGNd7E7Pzb6dWzUyKBYeNnhtgt7DmEnfHPtGfklX8gL4l70+huUesGrF6
         3GNmIG/Kd0ZXHKG/k+Tdqfnahim/T8GujSAF6djpBb5b4er2Yl0G6HjJptr4/UTyXNP7
         2QfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Q6ExZ117A0aM/vhFUmbVwSY0OK3ssVDA0XzgyTgogbY=;
        b=aCBhZPYibcOXyUwxEilEIVvjoOZAus710s+amdeS+zH7i75aklZjPuKfqp2zm8/jeo
         oye+FvCI1vt19LoKMdMgvBMp1SKxzwVMPcwTt0zBi0++4Y1jGFdeqVHeC1ZSWVwgRVAt
         NAocn/iE9bGM9UPVeC7JT3994bzibiAs0oHkDOGNq8oHO7TyIrgpNdhPYI7PNdnIp/zg
         +8UoBrCwB8R4QOldqFCV0CRfagW6KS3qbVbsxPR5DW0MLRYVYGNJvF60seX0C6Ws3Gtt
         JBRZvB9ymR87vAwY/jn6PzXFIom+XKdmdv95V1w/XKhiveO/Ec7knSbisQJMjZ+YPVBe
         wj/Q==
X-Gm-Message-State: AOAM533D6KY5yw0YDKeghteS4yV7NqYut3+qhTkqCZF28+ZUEiR8PMNH
        bKVNk/tV/pO0afk8n1MCn+U=
X-Google-Smtp-Source: ABdhPJwRwV6diyTTT5KoBZRaVFt58XwWp1CREVd+1bXwTOoMBkPt0oikx99d/RIKB5NW8OQjqusfkw==
X-Received: by 2002:a17:906:3ecf:: with SMTP id d15mr15817372ejj.297.1607272961621;
        Sun, 06 Dec 2020 08:42:41 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id e19sm9157524edr.61.2020.12.06.08.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 08:42:41 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: [PATCH v1 0/3] Three fixes for the UPIU trace
Date:   Sun,  6 Dec 2020 17:42:23 +0100
Message-Id: <20201206164226.6595-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>



Bean Huo (3):
  scsi: ufs: Distinguish between query REQ and query RSP in query trace
  scsi: ufs: Distinguish between TM request UPIU and response UPIU in TM
    UPIU trace
  scsi: ufs: Make UPIU trace easier differentiate among CDB, OSF, and TM

 drivers/scsi/ufs/ufshcd.c  | 21 ++++++++++++++++-----
 include/trace/events/ufs.h | 10 +++++++---
 2 files changed, 23 insertions(+), 8 deletions(-)

-- 
2.17.1

