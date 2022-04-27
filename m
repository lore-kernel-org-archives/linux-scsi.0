Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699C9C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 23:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiD0Xmg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 19:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiD0Xmg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 19:42:36 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E634F5F25F
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 16:39:23 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id fv2so2751316pjb.4
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 16:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KvZsHEyEr2D1sOb2aA8GvPIlfMXz+vav8IYK+iBhqCo=;
        b=6tRuu9JhGIEDJG8rX8yEmoTbYW7SwJAYrBdt3ZbzfZfgXHF9Rw2GMkypVGgLimtCkK
         qG5CEa//8WKmPRaQy5904fxACe3uR18WLp/q3o8ORsN+EOo264lvHtwXzHuNkACDsZQ3
         zBs5bluMm3GiENiL13vWhchLPKYNpza5EC7om9JI5AZrMvaGYzM7YBLGbhqHtB0rsBQr
         1J8poHikNT09PRVdqwLk5l1ADg08ITYJSn7QMyYNAS/TxrjOv3WDJKqCNwWTUdb9P+f8
         M7mXHLFl9fPUM7hRZguISSBFHK1kQ5RpSVUQ0YCWyLfq9qiQC9T/ut3O2PCBi3VDMffN
         sllg==
X-Gm-Message-State: AOAM533bQzhLKpIPX2EgEAj3ivFtC/cswrI03dhVf85i6o3qK6iDubMu
        1SPSLiecO4Lsdxqta28UtJ0=
X-Google-Smtp-Source: ABdhPJxCf9Y1I4194nZB3Vhj1EBzeS6WEj4wkPo25s63ITQItqcwG8osI/ZtpnPOuWy4BU/l6exiQA==
X-Received: by 2002:a17:90b:4f92:b0:1cd:3a73:3a46 with SMTP id qe18-20020a17090b4f9200b001cd3a733a46mr36133325pjb.66.1651102763351;
        Wed, 27 Apr 2022 16:39:23 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6cbb:d78e:9b3:bb62])
        by smtp.gmail.com with ESMTPSA id f16-20020aa78b10000000b0050a81508653sm19817580pfd.198.2022.04.27.16.39.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 16:39:22 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] Prepare for upstreaming Pixel 6 UFS support
Date:   Wed, 27 Apr 2022 16:38:51 -0700
Message-Id: <20220427233855.2685505-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The UFS controller in the Google Pixel 6 phone requires that SCSI command
processing is suspended while reprogramming encryption keys. The patches in
this series are a first step towards integrating support in the upstream
kernel for the UFS controller in the Pixel 6. Please consider these patches
for inclusion in kernel v5.19.

Note: instructions for downloading the Pixel 6 source code are available at
https://source.android.com/setup/build/building-kernels.

Thanks,

Bart.

Bart Van Assche (4):
  scsi: ufs: Reduce the clock scaling latency
  scsi: ufs: Move a clock scaling check
  scsi: ufs: Pass the clock scaling timeout as an argument
  scsi: ufs: Add suspend/resume SCSI command processing support

 drivers/scsi/ufs/ufshcd.c | 50 ++++++++++++++++++++++++++++++++++-----
 drivers/scsi/ufs/ufshcd.h |  3 +++
 2 files changed, 47 insertions(+), 6 deletions(-)

