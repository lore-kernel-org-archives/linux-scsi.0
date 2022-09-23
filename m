Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE0DC04A95
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 20:11:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbiIWULq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 16:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiIWULp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 16:11:45 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47945122045
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:11:45 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id q9so1216992pgq.8
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 13:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=g39mT2+aIiK3JVV6XscjN6Cts528Fe5xlzGunO748Vk=;
        b=p8Jpy6UaerzNbnCU3glFuOdJ4YjhSiUUXYUYKw94D7TcTW4f3eVRcM1OcbLBT4uYs8
         2X38lYp5aTmq1L9DBProsE68BhrAZ8vTTiwQyarFGnCqB/WVM44qzbw2U/d9+P9IIb7k
         25ZrLli30vE1BkchAXRRCUCiMvpo7EDmVQNBBU9BW890nw7Bvwyb/siaa6Ga0Z21Xi2D
         1QWSDv/dwONW2mNHPY1tMFGusaapjIQouxW2fqgyL69yWByjjRqFuL1QTFGVVua9ZXFf
         FMZuYrwesG+X4wOFucEEFApEPStRHeozOgbVcSjdTdgwjR9EinQXEtiitW19FcrATr7M
         e9+Q==
X-Gm-Message-State: ACrzQf0E4nxyGVcnV4KqqlZ8FXyKhfniVEWUQWpMd20bHOcPvGL7C8S0
        HT2rbOm1hRFNmXN2EAWWlf0=
X-Google-Smtp-Source: AMsMyM6ySP9ZvmngFTZALwW/c+eQ636vusMlLuUDrwqpxQo6r0cMJH0xewhUzJaINlasN3qi4MqU7g==
X-Received: by 2002:a05:6a00:234b:b0:545:fec9:abca with SMTP id j11-20020a056a00234b00b00545fec9abcamr10929759pfj.14.1663963904537;
        Fri, 23 Sep 2022 13:11:44 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:aa13:bc38:2a63:318e])
        by smtp.gmail.com with ESMTPSA id b7-20020a170902650700b001754fa42065sm6388435plk.143.2022.09.23.13.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:11:43 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/8] Fix a deadlock in the UFS driver
Date:   Fri, 23 Sep 2022 13:11:30 -0700
Message-Id: <20220923201138.2113123-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series fixes a deadlock in the UFS driver between the suspend/resume
code and the SCSI error handler. Please consider this patch series for the next
merge window.

Thanks,

Bart.

Bart Van Assche (8):
  scsi: core: Fix a race between scsi_done() and scsi_times_out()
  scsi: core: Change the return type of .eh_timed_out()
  scsi: ufs: Remove an outdated comment
  scsi: ufs: Use 'else' in ufshcd_set_dev_pwr_mode()
  scsi: ufs: Try harder to change the power mode
  scsi: ufs: Split ufshcd_err_handler()
  scsi: ufs: Add a PM notifier
  scsi: ufs: Fix deadlock between power management and error handler

 Documentation/scsi/scsi_eh.rst            |  7 +-
 drivers/message/fusion/mptsas.c           |  8 +-
 drivers/scsi/libiscsi.c                   | 26 +++---
 drivers/scsi/megaraid/megaraid_sas_base.c |  7 +-
 drivers/scsi/mvumi.c                      |  4 +-
 drivers/scsi/qla4xxx/ql4_os.c             |  8 +-
 drivers/scsi/scsi_error.c                 | 38 ++++-----
 drivers/scsi/scsi_transport_fc.c          |  8 +-
 drivers/scsi/scsi_transport_srp.c         |  8 +-
 drivers/scsi/storvsc_drv.c                |  4 +-
 drivers/scsi/virtio_scsi.c                |  4 +-
 drivers/ufs/core/ufshcd.c                 | 98 ++++++++++++++++++-----
 include/scsi/libiscsi.h                   |  2 +-
 include/scsi/scsi_host.h                  | 14 +++-
 include/scsi/scsi_transport_fc.h          |  2 +-
 include/scsi/scsi_transport_srp.h         |  2 +-
 include/ufs/ufshcd.h                      |  7 +-
 17 files changed, 161 insertions(+), 86 deletions(-)

