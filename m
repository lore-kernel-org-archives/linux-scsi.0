Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7752E7D0A6
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 19:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbjIUTZC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 15:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjIUTZB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 15:25:01 -0400
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4650FD5BC5
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 12:24:55 -0700 (PDT)
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-6c0f3f24c27so796185a34.2
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2023 12:24:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695324294; x=1695929094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FdVRT32ydCZpe3KPPlQ+TAjponX+fmmWG7mWw+SNPgs=;
        b=oev/R48XIOKnrp3hfns11tZJh83USDEOiwft34BXddCvvX/zxLuEVSWmywGfC/vN2/
         JQuxCf+OPpts4NUOxV/Z65DKE6RUb6yrdDRavQ3rBXJDWpBbnOpQ+sqvlS+E7VW69l/a
         og2B6w/x3UABt9r9tTYQS6aQUDWVu6bxc3l5jw55ypbG4Pkr2nUb/RWB1GIf32wcMzFk
         SP06nAfqce822kWB7fHjg2+kDeJkzs3gLenKS8CrhnkFG6wWsMzHhsW7qZdTfzO+Kd+c
         d6WDM6wP685DtHNpVX3VN9IuF3FVkAMwjxyxHkB6LSMnlOaYRmKa8NSy8C0vjTjeHlxb
         /Ksg==
X-Gm-Message-State: AOJu0Yy4gU8F94G+1NCQw+oD2aUxe8djQ1CLiGMRWSNIuXAD9Os4PHRr
        /4NXQE7WD4lWb0W7IbGv5p0=
X-Google-Smtp-Source: AGHT+IGYkyYWkZCh2ONwnTzEoPAyBZfgbiptqVwfcbt7sZIl+8gmSXXRXrmZk+H7Q0AZT32bT05rag==
X-Received: by 2002:a05:6830:1e5a:b0:6bc:86f1:f24e with SMTP id e26-20020a0568301e5a00b006bc86f1f24emr7605933otj.12.1695324294403;
        Thu, 21 Sep 2023 12:24:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6903:9a1f:51f3:593e])
        by smtp.gmail.com with ESMTPSA id fm1-20020a056a002f8100b00679a4b56e41sm1760061pfb.43.2023.09.21.12.24.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Sep 2023 12:24:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/4] UFS core patches
Date:   Thu, 21 Sep 2023 12:22:45 -0700
Message-ID: <20230921192335.676924-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.515.g380fc7ccd1-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider these UFS core patches for the next merge window.

Thanks,

Bart.

Changes compared to v1:
- In patch 1/4, instead of preserving the WARN_ONCE() statements, remove these.
- Added a reference to CDL in the description of patch 4/4.

Bart Van Assche (4):
  scsi: ufs: Remove request tag range checks
  scsi: ufs: Move the 4K alignment code into the Exynos driver
  scsi: ufs: Simplify ufshcd_comp_scsi_upiu()
  scsi: ufs: Set the Command Priority (CP) flag for RT requests

 drivers/ufs/core/ufshcd.c     | 32 ++++++++++++--------------------
 drivers/ufs/host/ufs-exynos.c |  9 +++++++--
 include/ufs/ufs.h             |  3 ++-
 include/ufs/ufshcd.h          |  7 ++-----
 4 files changed, 23 insertions(+), 28 deletions(-)

