Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC4DCC4332F
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 23:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiLHXof (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 18:44:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiLHXoI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 18:44:08 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F85A3AC15
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 15:44:06 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id t2so114304ply.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Dec 2022 15:44:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0nrNVlNOwAxazJvmsTE1rK3sdQfMPeju4ArQiY56A7w=;
        b=F4wdlCFvCitjbAAN6floe6taQrfEz3H+PlprzJjb1vPt8nhroFvFOP7ZBCFHDYVnf9
         vB3WbQsRKMPDN04Zq4oWTpn+S0//Rnp9jWNzYFF0n0pxgzR3vOTaw2hkcEv0+vc3ciwk
         trMy8KGIAwmKqrxJk76GxCWLUBPCkjIpuiVMJTMGqjRRwIeX/ttj1rNuwK+GNB3DtjxC
         Ijyb55Y6FVSt6I7mxG2IqmW2PI+eDvMhd4cuexdsRVS37VuqGTfZqLwU2EjUll24iB/K
         tK2NF66JV7qUXQ6Nv2N2sOp0dhaZi4c1Mw8q0xbRCFxJt/KqBlM2+vZZdtwYWqlMzbpo
         o1Ww==
X-Gm-Message-State: ANoB5pngujrNTG6N/SsN3AEyC+LlUbTabVem162xYOQg7XP/OGihci3k
        +u50pnbPAAsZgirOZjRoBRU9H/i7lKk=
X-Google-Smtp-Source: AA0mqf4P4OusyyDzXbZqhm3nNjxVbhzCzZr5/PbpbKTC/YaRAH2k6pjn5Nttn6L0mtt7hPO9/xMdbQ==
X-Received: by 2002:a17:90b:310f:b0:219:d84:4446 with SMTP id gc15-20020a17090b310f00b002190d844446mr3632830pjb.26.1670543045330;
        Thu, 08 Dec 2022 15:44:05 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id t15-20020a17090a2f8f00b00213d28a6dedsm148553pjd.13.2022.12.08.15.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 15:44:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 0/3] Prepare for upstreaming Pixel 6 and 7 UFS support
Date:   Thu,  8 Dec 2022 15:43:55 -0800
Message-Id: <20221208234358.252031-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The patches in this series are a first step towards integrating support in the
upstream kernel for the UFS controller in the Pixel 6 and 7. Please consider
these patches for the next merge window.

Note: instructions for downloading the Pixel kernel source code are available
at https://source.android.com/setup/build/building-kernels.

Thank you,

Bart.

Changes compared to v4:
- Dropped two patches. Dropped one patch without Reviewed-by tag and another
  patch that exports two functions without adding in-tree callers.

Changes compared to v3:
- Changed SCSI_UFS_VARIABLE_SG_ENTRY_SIZE from user-selectable into selected
  only if needed.

Changes compared to v2:
- Addressed more review comments from Avri.

Changes compared to v1:
- Addressed Avri's review comments.
- Added patch "Allow UFS host drivers to override the sg entry size".
Bart Van Assche (2):
  scsi: ufs: Reduce the clock scaling latency
  scsi: ufs: Pass the clock scaling timeout as an argument

Eric Biggers (1):
  scsi: ufs: Allow UFS host drivers to override the sg entry size

 drivers/ufs/core/ufshcd.c | 60 ++++++++++++++++++++++-----------------
 drivers/ufs/host/Kconfig  |  4 +++
 include/ufs/ufshcd.h      | 30 ++++++++++++++++++++
 include/ufs/ufshci.h      |  9 ++++--
 4 files changed, 75 insertions(+), 28 deletions(-)

