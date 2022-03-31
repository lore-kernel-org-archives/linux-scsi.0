Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37FFFC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:34:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242500AbiCaWg2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233852AbiCaWg0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:36:26 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 567061C4B21
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:34:38 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id gp15-20020a17090adf0f00b001c7cd11b0b3so3625869pjb.3
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:34:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S6cIRsel8hMDagV1uWLiUWICUfui4tO7AOAIok2mlL4=;
        b=J+CoXvzYn/jdni+BA0c0044QKqF46nHS7b6ZhOGVqMCCKrdQ8ytte28UZhtQP64v79
         jbPTTFKdjlroS4d2jgsCNrwGc5wyza/8MtL6m1qSqZECp6Y2UIyy3Of73kY6FanNH23y
         tLuGBlxqtrw3j1ZvhLqHzqpiuKZPQ8rl3L1RkqKikHhd77j9ZBEDxGXISaDfitxi5TKG
         M51QhO0mrYByy5pLsJyZjMQzE3Hrvkmuuck7c7kqS9UadJRLvckRH9PK188juLlYjOyC
         MKXSHSAmye62ZWNgpDhmxQwaWmJEsVq7td6DHFSxOazrtmgirsPc5SIJZGXNMmUOevtt
         8A1Q==
X-Gm-Message-State: AOAM532f2EbGOZ6D4Ok4pDNjch/BgKFousxNHe9JmKtCDYyNOr9si8hl
        2j40N6GPIAF7zZCUKJLNdfkNcp7nTuQ=
X-Google-Smtp-Source: ABdhPJxcx3V3BYF4GrbOBCq6s5gGdaJpbteywBmf/qMU8EY0t46iOKXmgMQ1ZuEl1Mrp8ZFmwlj+iQ==
X-Received: by 2002:a17:902:ec89:b0:153:f480:5089 with SMTP id x9-20020a170902ec8900b00153f4805089mr7046123plg.166.1648766077669;
        Thu, 31 Mar 2022 15:34:37 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:34:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/29] UFS patches for kernel v5.19
Date:   Thu, 31 Mar 2022 15:33:55 -0700
Message-Id: <20220331223424.1054715-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series includes the following changes:
- Separation of UFS core and UFS driver source code into separate directories.
- Split the ufshcd.h header file into two header files - one file that
  defines the interface with UFS drivers and another file with definitions
  only used in the core.
- Multiple source code cleanup patches.
- A few patches with minor functional changes.

Please consider these changes for kernel v5.19.

Thank you,

Bart.

Bart Van Assche (29):
  scsi: ufs: Declare ufshcd_wait_for_register() static
  scsi: ufs: Remove superfluous boolean conversions
  scsi: ufs: Simplify statements that return a boolean
  scsi: ufs: Remove ufshcd_lrb.sense_bufflen
  scsi: ufs: Remove ufshcd_lrb.sense_buffer
  scsi: ufs: Use get_unaligned_be16() instead of be16_to_cpup()
  scsi: ufs: Remove the UFS_FIX() and END_FIX() macros
  scsi: ufs: Rename struct ufs_dev_fix into ufs_dev_quirk
  scsi: ufs: Declare the quirks array const
  scsi: ufs: Invert the return value of ufshcd_is_hba_active()
  scsi: ufs: Remove unused constants and code
  scsi: ufs: Switch to aggregate initialization
  scsi: ufs: Remove the LUN quiescing code from ufshcd_wl_shutdown()
  scsi: ufs: Make the config_scaling_param calls type safe
  scsi: ufs: Remove the driver version
  scsi: ufs: Rename sdev_ufs_device into ufs_device_wlun
  scsi: ufs: Use an SPDX license identifier in the Kconfig file
  scsi: ufs: Remove paths from source code comments
  scsi: ufs: Remove the TRUE and FALSE definitions
  scsi: ufs: Remove locking from around single register writes
  scsi: ufs: Introduce ufshcd_clkgate_delay_set()
  scsi: ufs: qcom: Fix ufs_qcom_resume()
  scsi: ufs: Remove unnecessary ufshcd-crypto.h include directives
  scsi: ufs: Fix kernel-doc syntax in ufshcd.h
  scsi: ufs: Minimize #include directives
  scsi: ufs: Split the ufshcd.h header file
  scsi: ufs: Move the struct ufs_ref_clk definition
  scsi: ufs: Move the ufs_is_valid_unit_desc_lun() definition
  scsi: ufs: Split the drivers/scsi/ufs directory

 drivers/scsi/Kconfig                          |   3 +-
 drivers/scsi/Makefile                         |   4 +-
 drivers/scsi/ufs-core/Kconfig                 |  82 ++++
 drivers/scsi/ufs-core/Makefile                |  10 +
 drivers/scsi/{ufs => ufs-core}/ufs-debugfs.c  |   4 +-
 drivers/scsi/{ufs => ufs-core}/ufs-debugfs.h  |   0
 .../{ufs => ufs-core}/ufs-fault-injection.c   |   4 +-
 .../{ufs => ufs-core}/ufs-fault-injection.h   |   0
 drivers/scsi/{ufs => ufs-core}/ufs-hwmon.c    |   4 +-
 drivers/scsi/{ufs => ufs-core}/ufs-sysfs.c    |   8 +-
 drivers/scsi/{ufs => ufs-core}/ufs-sysfs.h    |   3 +-
 drivers/scsi/{ufs => ufs-core}/ufs_bsg.c      |   6 +
 drivers/scsi/{ufs => ufs-core}/ufs_bsg.h      |   7 +-
 .../scsi/{ufs => ufs-core}/ufshcd-crypto.c    |   2 +-
 .../scsi/{ufs => ufs-core}/ufshcd-crypto.h    |   7 +-
 drivers/scsi/ufs-core/ufshcd-priv.h           | 296 ++++++++++++++
 drivers/scsi/{ufs => ufs-core}/ufshcd.c       | 254 ++++++------
 drivers/scsi/{ufs => ufs-core}/ufshpb.c       |  10 +-
 drivers/scsi/{ufs => ufs-core}/ufshpb.h       |   0
 drivers/scsi/ufs-drivers/Kconfig              | 118 ++++++
 drivers/scsi/{ufs => ufs-drivers}/Makefile    |  12 -
 .../scsi/{ufs => ufs-drivers}/cdns-pltfrm.c   |   5 +-
 .../{ufs => ufs-drivers}/tc-dwc-g210-pci.c    |   8 +-
 .../{ufs => ufs-drivers}/tc-dwc-g210-pltfrm.c |  10 +-
 .../scsi/{ufs => ufs-drivers}/tc-dwc-g210.c   |   8 +-
 .../scsi/{ufs => ufs-drivers}/tc-dwc-g210.h   |   2 +
 .../scsi/{ufs => ufs-drivers}/ti-j721e-ufs.c  |   0
 .../scsi/{ufs => ufs-drivers}/ufs-exynos.c    |  17 +-
 .../scsi/{ufs => ufs-drivers}/ufs-exynos.h    |   8 +-
 drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.c  |  17 +-
 drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.h  |   0
 .../{ufs => ufs-drivers}/ufs-mediatek-trace.h |   2 +-
 .../scsi/{ufs => ufs-drivers}/ufs-mediatek.c  |  40 +-
 .../scsi/{ufs => ufs-drivers}/ufs-mediatek.h  |   0
 .../scsi/{ufs => ufs-drivers}/ufs-qcom-ice.c  |   3 +-
 drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.c  |  49 +--
 drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.h  |   6 +-
 .../scsi/{ufs => ufs-drivers}/ufshcd-dwc.c    |   6 +-
 .../scsi/{ufs => ufs-drivers}/ufshcd-dwc.h    |   2 +
 .../scsi/{ufs => ufs-drivers}/ufshcd-pci.c    |  14 +-
 .../scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.c |  35 +-
 .../scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.h |   2 +-
 .../scsi/{ufs => ufs-drivers}/ufshci-dwc.h    |   0
 drivers/scsi/ufs/Kconfig                      | 211 ----------
 {drivers/scsi/ufs => include/scsi}/ufs.h      |  35 --
 .../scsi/ufs => include/scsi}/ufs_quirks.h    |  15 +-
 {drivers/scsi/ufs => include/scsi}/ufshcd.h   | 366 ++++--------------
 {drivers/scsi/ufs => include/scsi}/ufshci.h   |   2 +
 {drivers/scsi/ufs => include/scsi}/unipro.h   |  16 -
 49 files changed, 856 insertions(+), 857 deletions(-)
 create mode 100644 drivers/scsi/ufs-core/Kconfig
 create mode 100644 drivers/scsi/ufs-core/Makefile
 rename drivers/scsi/{ufs => ufs-core}/ufs-debugfs.c (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-debugfs.h (100%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-fault-injection.c (100%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-fault-injection.h (100%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-hwmon.c (98%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-sysfs.c (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufs-sysfs.h (95%)
 rename drivers/scsi/{ufs => ufs-core}/ufs_bsg.c (97%)
 rename drivers/scsi/{ufs => ufs-core}/ufs_bsg.h (77%)
 rename drivers/scsi/{ufs => ufs-core}/ufshcd-crypto.c (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufshcd-crypto.h (94%)
 create mode 100644 drivers/scsi/ufs-core/ufshcd-priv.h
 rename drivers/scsi/{ufs => ufs-core}/ufshcd.c (98%)
 rename drivers/scsi/{ufs => ufs-core}/ufshpb.c (99%)
 rename drivers/scsi/{ufs => ufs-core}/ufshpb.h (100%)
 create mode 100644 drivers/scsi/ufs-drivers/Kconfig
 rename drivers/scsi/{ufs => ufs-drivers}/Makefile (56%)
 rename drivers/scsi/{ufs => ufs-drivers}/cdns-pltfrm.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210-pci.c (98%)
 rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210-pltfrm.c (98%)
 rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/tc-dwc-g210.h (95%)
 rename drivers/scsi/{ufs => ufs-drivers}/ti-j721e-ufs.c (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-exynos.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-exynos.h (97%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-hisi.h (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-mediatek-trace.h (92%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-mediatek.c (97%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-mediatek.h (100%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-qcom-ice.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.c (98%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufs-qcom.h (98%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-dwc.c (98%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-dwc.h (95%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-pci.c (99%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.c (94%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshcd-pltfrm.h (98%)
 rename drivers/scsi/{ufs => ufs-drivers}/ufshci-dwc.h (100%)
 delete mode 100644 drivers/scsi/ufs/Kconfig
 rename {drivers/scsi/ufs => include/scsi}/ufs.h (93%)
 rename {drivers/scsi/ufs => include/scsi}/ufs_quirks.h (94%)
 rename {drivers/scsi/ufs => include/scsi}/ufshcd.h (82%)
 rename {drivers/scsi/ufs => include/scsi}/ufshci.h (99%)
 rename {drivers/scsi/ufs => include/scsi}/unipro.h (98%)

