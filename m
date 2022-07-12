Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78882C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 22:19:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231994AbiGLWTr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 18:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiGLWTq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 18:19:46 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 180C332EF8
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:19:45 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id a15so9430817pjs.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jul 2022 15:19:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A8Z7wkjXbKpHHRlCKwHdoHFral+1oHBUj3RnzdzEQVA=;
        b=0o3nqB+tEmD6nbEeEgot6y06BJV5YwGL/5LOatIxW4wu3/aHnKzdg+cwTNL6lxo25u
         wsGSI9nXcI90KYqscRDNt9udA39DRtS/Xm4Rbq+GBNNIjbz5UbulUjMeAKctsqoDm+TY
         W3MbbN4kZ71oOj/e50Y3DNAoNtPGk8zUXCc9CsgyOEKH6wWJQiCoUs1ncRfwtGGy6Ej+
         KdqNciyT7btDieZkNTfZnUvOOJW1lrXmNJAb4kOhpLTVxgZuQZeha0cjmX2iXql8p5j7
         YkF0JnXs9ac+A7T34ltvW+c1RjTWjajSjmHqFFQihigtSVcr4ImM5A2l3AHrai9PjbYr
         BSxA==
X-Gm-Message-State: AJIora/BYao1KDJfaPoidfHFTfzw7SVRu9T9L7ENo41FEANpy0kyD1lF
        P2QRO8xOOgVak05Z/c59CZk=
X-Google-Smtp-Source: AGRyM1u4xEo/RtzwywV5WkJn3BfQFbW3/XmfKjdRFvxMXJdWEwH6MX/TSrYvJBBX9XCU5BV01oCn6Q==
X-Received: by 2002:a17:90b:1d0d:b0:1ef:afd1:9f25 with SMTP id on13-20020a17090b1d0d00b001efafd19f25mr6574816pjb.200.1657664384190;
        Tue, 12 Jul 2022 15:19:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:de3c:137c:f4d2:d291])
        by smtp.gmail.com with ESMTPSA id w12-20020a63f50c000000b0040d0a57be02sm6640192pgh.31.2022.07.12.15.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 15:19:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/4] Call blk_mq_free_tag_set() earlier
Date:   Tue, 12 Jul 2022 15:19:32 -0700
Message-Id: <20220712221936.1199196-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes a recently reported use-after-free in the SRP driver.
Please consider this patch series for kernel v5.20.

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

Bart Van Assche (2):
  scsi: core: Make sure that targets outlive devices
  scsi: core: Call blk_mq_free_tag_set() earlier

Ming Lei (2):
  scsi: core: Make sure that hosts outlive targets
  scsi: core: Simplify LLD module reference counting

 drivers/scsi/hosts.c       | 18 +++++++++++++-----
 drivers/scsi/scsi.c        |  9 ++++++---
 drivers/scsi/scsi_lib.c    |  3 +++
 drivers/scsi/scsi_scan.c   |  9 +++++++++
 drivers/scsi/scsi_sysfs.c  | 29 +++++++++++++++++------------
 include/scsi/scsi_device.h |  2 ++
 include/scsi/scsi_host.h   |  3 +++
 7 files changed, 53 insertions(+), 20 deletions(-)

