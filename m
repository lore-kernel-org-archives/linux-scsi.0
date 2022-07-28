Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721E8C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 22:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiG1WTY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 18:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbiG1WTL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 18:19:11 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71423796B8
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:19:02 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id t2so2993185ply.2
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jul 2022 15:19:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XYtOulIxnPBrTj3ASrifhveVbA3K/e9aW4j2L9nkkJY=;
        b=Ok14G1EVMYRTBSrAipumuogjCg/JazF9eIRaKPgVWEAi13jhQUgg4aPZ073+yxZINM
         eBeVHoDIti6EzfR3Sksj0FnWSzxLJB3YH58ZFV2bvdsijGS6AXAt+AzEaoSDgSAtb/KO
         DlA/ssR5Kme4zM2TmN25Y4aF6TFB1Ty3Q30/YsGgIQ7leUztia9Q0Q9O9Oy1Z/TyvwwE
         f2CzaCU0GlNZQ6Rs9WUv1r7cEu7WGq51G6t691NFm1UEUoKirq3RyajaianMGNi1uxO2
         Iki2hXg4AR79dg5JoyDlU+wql7SgO+Nd8hLMMjnoBbmE+7thPmnIjaFi6sulDMjNeB+Q
         6TNw==
X-Gm-Message-State: ACgBeo1fXh333oIoSeFR/Wyt1zMCXTVfVDTQsJMovOBvKXgjkY6fBgcU
        5vG3GS3xrA4YnpTuhvUFmJg=
X-Google-Smtp-Source: AA6agR7SxAsogFHmviAxSo58N+sBtjdLFuxgKvlnf7tFmIFCltWZlx+kfgMlzXEe5uSx4sz0Ta11Ew==
X-Received: by 2002:a17:902:ce8b:b0:16d:68e0:75ee with SMTP id f11-20020a170902ce8b00b0016d68e075eemr913306plg.82.1659046741781;
        Thu, 28 Jul 2022 15:19:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9520:2952:8318:8e3e])
        by smtp.gmail.com with ESMTPSA id k11-20020a170902c40b00b0016dc8932725sm1556709plk.285.2022.07.28.15.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:19:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 0/4] Call blk_mq_free_tag_set() earlier
Date:   Thu, 28 Jul 2022 15:18:47 -0700
Message-Id: <20220728221851.1822295-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes a recently reported use-after-free in the SRP driver.
Please consider this patch series for kernel v5.20.

Changes compared to v4:
- Left out the scsi_mq_destroy_tags() changes.

Changes compared to v3:
- Added a patch to delay scsi_remove_target() until dependent devices have been
  removed.
- Split a patch into two patches.

Changes compared to v2:
- Dropped the patch that simplifies scsi_forget_host().
- Replaced patch 2/3 with a patch from Ming Lei.

Changes compared to v1:
- Expanded this series from one to three patches.
- Fixed the description of patch 3/3.

Thanks,

Bart.

Bart Van Assche (2):
  scsi: core: Make sure that targets outlive devices
  scsi: core: Call blk_mq_free_tag_set() earlier

Ming Lei (2):
  scsi: core: Make sure that hosts outlive targets
  scsi: core: Simplify LLD module reference counting

 drivers/scsi/hosts.c       | 18 +++++++++++++-----
 drivers/scsi/scsi.c        |  9 ++++++---
 drivers/scsi/scsi_scan.c   |  9 +++++++++
 drivers/scsi/scsi_sysfs.c  | 29 +++++++++++++++++------------
 include/scsi/scsi_device.h |  2 ++
 include/scsi/scsi_host.h   |  3 +++
 6 files changed, 50 insertions(+), 20 deletions(-)

