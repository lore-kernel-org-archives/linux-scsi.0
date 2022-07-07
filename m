Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7250C433EF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 18:21:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235690AbiGGSVm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 14:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235207AbiGGSVl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 14:21:41 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265714D4ED
        for <linux-scsi@vger.kernel.org>; Thu,  7 Jul 2022 11:21:41 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id o12so7473160pfp.5
        for <linux-scsi@vger.kernel.org>; Thu, 07 Jul 2022 11:21:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QXPEjNJkFy1DO+mUiZgsly1OEdZmFrbwezpxM9CZ8MA=;
        b=reVVBV64EnhQjsoEoeoRmvpcpYLgTckvZMV4KK8B4DXgiZpw9saGbgmC30CYu/1FrX
         rIZZ0fZ2SM5rSJ9FE960joyuCEaxU271hXBvMzx56u6RJIUa7M2ftRtKwIowfU4xiWBz
         w6ohsRjt4SdVuVwyFc0PQ3NuaUVuGKDdFQKD+qVTLq0TObeUYG4/uxBFoxpJOl78m5cS
         C5anI8KuDUWBG8nYuBpAHrCTXEcfUCKEZMJitYaL8VwGzSv+vZpTyClEeqOv6DZkJ2Di
         rKUOBkuf2OTEBvd2GchwtFdf4VcIzEQYFJdYmB2GJi6f5J88lSQiV27VA4DxuVK4GKDu
         O4aA==
X-Gm-Message-State: AJIora9uN/zsOEym3VoPCI8pJYzQ36IRGXwNwIXCxAaUf3yi8T5Se1gu
        Hyk2ElA8+YE2QVBwxnOZR58=
X-Google-Smtp-Source: AGRyM1svovHTvq61U6XNUDOqvBIbST70SHA29ywrf6P7ckMsJj96zuP/ero8sLRc32n+1B3NbJ4yJA==
X-Received: by 2002:a17:902:ab41:b0:16b:cd1c:1361 with SMTP id ij1-20020a170902ab4100b0016bcd1c1361mr32110602plb.171.1657218100347;
        Thu, 07 Jul 2022 11:21:40 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id n16-20020a170903111000b0016bdd124d46sm10490335plh.288.2022.07.07.11.21.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 11:21:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/2] Call blk_mq_free_tag_set() earlier
Date:   Thu,  7 Jul 2022 11:21:20 -0700
Message-Id: <20220707182122.3797-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes a recently reported use-after-free in the SRP driver.
Please consider this patch series for kernel v5.20.

Changes compared to v2:
- Dropped the patch that simplifies scsi_forget_host().
- Replaced patch 2/3 with a patch from Ming Lei.

Changes compared to v1:
- Expanded this series from one to three patches.
- Fixed the description of patch 3/3.

Bart Van Assche (1):
  scsi: core: Call blk_mq_free_tag_set() earlier

Ming Lei (1):
  scsi: core: Make sure that hosts outlive targets and devices

 drivers/scsi/hosts.c      | 19 ++++++++++++++-----
 drivers/scsi/scsi.c       |  9 ++++++---
 drivers/scsi/scsi_lib.c   |  3 +++
 drivers/scsi/scsi_scan.c  |  7 +++++++
 drivers/scsi/scsi_sysfs.c |  9 ---------
 include/scsi/scsi_host.h  |  3 +++
 6 files changed, 33 insertions(+), 17 deletions(-)

