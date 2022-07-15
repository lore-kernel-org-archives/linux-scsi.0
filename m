Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F1BC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jul 2022 21:25:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbiGOVZc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Jul 2022 17:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiGOVZb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jul 2022 17:25:31 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFF143E68
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 14:25:31 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id 72so5509119pge.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Jul 2022 14:25:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CUzJIQsuVaw3lYR1AV1j5NxQwgFjob4O0Dbw1ApFj0Y=;
        b=XSI4D6koW4cI79PJSOPz7+lqKCpX4qUQ7fNtk1DXgoCKOnR9ib7QhNamO2OnSTL3Ii
         5jcL30ft6IxcGhSyTP91JwHkU8lIi5fvEce6hXAxmqNo9Sayzyx7HPwYx1RMihyRklx/
         1xSJWC3JBgYE67/cCoWl9wPrIkYeSlL9bQT31SKyb8UlEwHdUFohJdYO2IIEkO8viqt0
         gpRE9uN2y9WmBpbvf7H6RcZRLu3UA1B6vRgoX6aXQURtABvdAt1nHuL410g1pG2+CkLT
         swVtUAJL71CCpKtFFhIu1YlAO1hXAb27ItgChYboR5a+QrDoE6XlpMi1Z5U+drouCbbG
         IpXw==
X-Gm-Message-State: AJIora8/QJkfxYhE2Dt6IP2kslCzN5Abz/tDsOFjzvEN7okIluKe0IHI
        dtX5xogLJGuTlL17t+SqzlI=
X-Google-Smtp-Source: AGRyM1sSNTg5CfTS3JXiNoZdPVuEEjAslJEm2CcEEOg4A734gL9ltkj6R9tGHB+aEVNxQvh0qOOmbQ==
X-Received: by 2002:a63:84c7:0:b0:412:a0b2:3add with SMTP id k190-20020a6384c7000000b00412a0b23addmr14083491pgd.511.1657920330587;
        Fri, 15 Jul 2022 14:25:30 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:276e:f777:f438:e01d])
        by smtp.gmail.com with ESMTPSA id e35-20020a630f23000000b0040c40b022fbsm3535944pgl.94.2022.07.15.14.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 14:25:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/5] Prepare for upstreaming Pixel 6 UFS support
Date:   Fri, 15 Jul 2022 14:25:10 -0700
Message-Id: <20220715212515.347664-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
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

Changes compared to v1:
- Addressed Avi's review comments.
- Added patch "Allow UFS host drivers to override the sg entry size".

Bart Van Assche (4):
  scsi: ufs: Reduce the clock scaling latency
  scsi: ufs: Move a clock scaling check
  scsi: ufs: Pass the clock scaling timeout as an argument
  scsi: ufs: Add suspend/resume SCSI command processing support

Eric Biggers (1):
  scsi: ufs: Allow UFS host drivers to override the sg entry size

 drivers/ufs/core/ufshcd.c | 89 +++++++++++++++++++++++++++------------
 drivers/ufs/host/Kconfig  | 10 +++++
 include/ufs/ufshcd.h      | 35 +++++++++++++++
 include/ufs/ufshci.h      |  9 +++-
 4 files changed, 114 insertions(+), 29 deletions(-)

