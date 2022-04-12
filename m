Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47BB4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241211AbiDLSVY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbiDLSVX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:21:23 -0400
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B2A1143
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:01 -0700 (PDT)
Received: by mail-pf1-f171.google.com with SMTP id w7so18173566pfu.11
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:19:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hDhnJmbALOf+cGTITbDscBAa8fAfYb1Dj201XUgWf4U=;
        b=u0V6TU3hpBGkvdW5Vj27MSpuw/YpbU4Nvw3aVgkFiAgTzdAzD49iKw8ogijBz3PmuL
         mTsvGNxvN9gTWcU5D6CJjbAhHr5kJd4v3w1nC62Hs0P1/lj3QclD5TPeO8NYzCH6GXHd
         XuQLqc8rNhfQTLJl/pfspSBUq36JlB+Bu2TBL82EOGqjRiDFVfQeLjOfU/BgwK+GcAqS
         ITnHegjZnuR638QNCSw1RsWTWaA8GJL9jb+uETFkCdRxCHJNu+J+WcxRaMHkEmeIwJmI
         NY2ACroBpce649Y1BiIUMxR4Qp8FCt8oZxqh1xfF+BaNHv8Si+PBK7rPAwLg8rL37n3E
         u26A==
X-Gm-Message-State: AOAM53144FAle1vRITLEJ1aOWLBIth3/rub7C62aqfnerXX1HDIVOYcf
        y4KcBnFueTVPLMfTfRpSZ8lQQ0XBwolZAA==
X-Google-Smtp-Source: ABdhPJw/iG/6aK8gizspu2Zg4nrDMdxBOYoMFaKQIdO14FFJvjH/RCUndTVy9lMCMe/rISVD2EQuIA==
X-Received: by 2002:a63:485d:0:b0:39d:8ebf:9acf with SMTP id x29-20020a63485d000000b0039d8ebf9acfmr4316779pgk.351.1649787541019;
        Tue, 12 Apr 2022 11:19:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:19:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/29] UFS patches for kernel v5.19
Date:   Tue, 12 Apr 2022 11:18:24 -0700
Message-Id: <20220412181853.3715080-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
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

Changes compared to v1:
* Added a new patch with a source code comment spelling fix.
* Included a HPB change in patch "Simplify statements that return a boolean".
* Removed a superfluous test from patch "Remove ufshcd_lrb.sense_buffer".
* Dropped patch "Remove the LUN quiescing code from ufshcd_wl_shutdown()".
* Fixed indentation in patch "Make the config_scaling_param calls type safe".
* Improved the description of patch "Remove locking from around single register
  writes".
* Modified patch "Minimize #include directives" such that the current order of
  #include directives is preserved.
* Fixed support for CONFIG_SCSI_UFS_HWMON=n in patch "Split the ufshcd.h header
  file".
* In patch "Split the drivers/scsi/ufs directory", moved the UFS source files
  from drivers/scsi/ufs/ into drivers/ufs/.

Bart Van Assche (29):
  scsi: ufs: Fix a spelling error in a source code comment
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

 MAINTAINERS                                   |   9 +-
 drivers/Kconfig                               |   2 +
 drivers/Makefile                              |   1 +
 drivers/scsi/Kconfig                          |   1 -
 drivers/scsi/Makefile                         |   1 -
 drivers/scsi/ufs/Kconfig                      | 211 ----------
 drivers/ufs/Kconfig                           |  30 ++
 drivers/ufs/Makefile                          |   5 +
 drivers/ufs/core/Kconfig                      |  60 +++
 drivers/ufs/core/Makefile                     |  10 +
 drivers/{scsi/ufs => ufs/core}/ufs-debugfs.c  |   3 +-
 drivers/{scsi/ufs => ufs/core}/ufs-debugfs.h  |   0
 .../ufs => ufs/core}/ufs-fault-injection.c    |   0
 .../ufs => ufs/core}/ufs-fault-injection.h    |   0
 drivers/{scsi/ufs => ufs/core}/ufs-hwmon.c    |   3 +-
 drivers/{scsi/ufs => ufs/core}/ufs-sysfs.c    |   3 +-
 drivers/{scsi/ufs => ufs/core}/ufs-sysfs.h    |   3 +-
 drivers/{scsi/ufs => ufs/core}/ufs_bsg.c      |   6 +
 drivers/{scsi/ufs => ufs/core}/ufs_bsg.h      |   7 +-
 .../{scsi/ufs => ufs/core}/ufshcd-crypto.c    |   2 +-
 .../{scsi/ufs => ufs/core}/ufshcd-crypto.h    |   7 +-
 drivers/ufs/core/ufshcd-priv.h                | 298 ++++++++++++++
 drivers/{scsi/ufs => ufs/core}/ufshcd.c       | 236 +++++------
 drivers/{scsi/ufs => ufs/core}/ufshpb.c       |  16 +-
 drivers/{scsi/ufs => ufs/core}/ufshpb.h       |   0
 drivers/ufs/host/Kconfig                      | 114 ++++++
 drivers/{scsi/ufs => ufs/host}/Makefile       |  12 -
 drivers/{scsi/ufs => ufs/host}/cdns-pltfrm.c  |   2 +-
 .../{scsi/ufs => ufs/host}/tc-dwc-g210-pci.c  |   3 +-
 .../ufs => ufs/host}/tc-dwc-g210-pltfrm.c     |   1 +
 drivers/{scsi/ufs => ufs/host}/tc-dwc-g210.c  |   6 +-
 drivers/{scsi/ufs => ufs/host}/tc-dwc-g210.h  |   2 +
 drivers/{scsi/ufs => ufs/host}/ti-j721e-ufs.c |   0
 drivers/{scsi/ufs => ufs/host}/ufs-exynos.c   |  11 +-
 drivers/{scsi/ufs => ufs/host}/ufs-exynos.h   |   8 +-
 drivers/{scsi/ufs => ufs/host}/ufs-hisi.c     |  10 +-
 drivers/{scsi/ufs => ufs/host}/ufs-hisi.h     |   0
 .../ufs => ufs/host}/ufs-mediatek-trace.h     |   2 +-
 drivers/{scsi/ufs => ufs/host}/ufs-mediatek.c |  37 +-
 drivers/{scsi/ufs => ufs/host}/ufs-mediatek.h |   0
 drivers/{scsi/ufs => ufs/host}/ufs-qcom-ice.c |   2 +-
 drivers/{scsi/ufs => ufs/host}/ufs-qcom.c     |  36 +-
 drivers/{scsi/ufs => ufs/host}/ufs-qcom.h     |   6 +-
 drivers/{scsi/ufs => ufs/host}/ufshcd-dwc.c   |   6 +-
 drivers/{scsi/ufs => ufs/host}/ufshcd-dwc.h   |   2 +
 drivers/{scsi/ufs => ufs/host}/ufshcd-pci.c   |   6 +-
 .../{scsi/ufs => ufs/host}/ufshcd-pltfrm.c    |  32 +-
 .../{scsi/ufs => ufs/host}/ufshcd-pltfrm.h    |   2 +-
 drivers/{scsi/ufs => ufs/host}/ufshci-dwc.h   |   0
 {drivers/scsi/ufs => include/scsi}/ufs.h      |  35 --
 .../scsi/ufs => include/scsi}/ufs_quirks.h    |  15 +-
 {drivers/scsi/ufs => include/scsi}/ufshcd.h   | 376 ++++--------------
 {drivers/scsi/ufs => include/scsi}/ufshci.h   |   2 +
 {drivers/scsi/ufs => include/scsi}/unipro.h   |  18 +-
 54 files changed, 840 insertions(+), 820 deletions(-)
 delete mode 100644 drivers/scsi/ufs/Kconfig
 create mode 100644 drivers/ufs/Kconfig
 create mode 100644 drivers/ufs/Makefile
 create mode 100644 drivers/ufs/core/Kconfig
 create mode 100644 drivers/ufs/core/Makefile
 rename drivers/{scsi/ufs => ufs/core}/ufs-debugfs.c (99%)
 rename drivers/{scsi/ufs => ufs/core}/ufs-debugfs.h (100%)
 rename drivers/{scsi/ufs => ufs/core}/ufs-fault-injection.c (100%)
 rename drivers/{scsi/ufs => ufs/core}/ufs-fault-injection.h (100%)
 rename drivers/{scsi/ufs => ufs/core}/ufs-hwmon.c (98%)
 rename drivers/{scsi/ufs => ufs/core}/ufs-sysfs.c (99%)
 rename drivers/{scsi/ufs => ufs/core}/ufs-sysfs.h (95%)
 rename drivers/{scsi/ufs => ufs/core}/ufs_bsg.c (97%)
 rename drivers/{scsi/ufs => ufs/core}/ufs_bsg.h (77%)
 rename drivers/{scsi/ufs => ufs/core}/ufshcd-crypto.c (99%)
 rename drivers/{scsi/ufs => ufs/core}/ufshcd-crypto.h (94%)
 create mode 100644 drivers/ufs/core/ufshcd-priv.h
 rename drivers/{scsi/ufs => ufs/core}/ufshcd.c (98%)
 rename drivers/{scsi/ufs => ufs/core}/ufshpb.c (99%)
 rename drivers/{scsi/ufs => ufs/core}/ufshpb.h (100%)
 create mode 100644 drivers/ufs/host/Kconfig
 rename drivers/{scsi/ufs => ufs/host}/Makefile (56%)
 rename drivers/{scsi/ufs => ufs/host}/cdns-pltfrm.c (99%)
 rename drivers/{scsi/ufs => ufs/host}/tc-dwc-g210-pci.c (98%)
 rename drivers/{scsi/ufs => ufs/host}/tc-dwc-g210-pltfrm.c (98%)
 rename drivers/{scsi/ufs => ufs/host}/tc-dwc-g210.c (99%)
 rename drivers/{scsi/ufs => ufs/host}/tc-dwc-g210.h (95%)
 rename drivers/{scsi/ufs => ufs/host}/ti-j721e-ufs.c (100%)
 rename drivers/{scsi/ufs => ufs/host}/ufs-exynos.c (99%)
 rename drivers/{scsi/ufs => ufs/host}/ufs-exynos.h (97%)
 rename drivers/{scsi/ufs => ufs/host}/ufs-hisi.c (99%)
 rename drivers/{scsi/ufs => ufs/host}/ufs-hisi.h (100%)
 rename drivers/{scsi/ufs => ufs/host}/ufs-mediatek-trace.h (93%)
 rename drivers/{scsi/ufs => ufs/host}/ufs-mediatek.c (97%)
 rename drivers/{scsi/ufs => ufs/host}/ufs-mediatek.h (100%)
 rename drivers/{scsi/ufs => ufs/host}/ufs-qcom-ice.c (99%)
 rename drivers/{scsi/ufs => ufs/host}/ufs-qcom.c (98%)
 rename drivers/{scsi/ufs => ufs/host}/ufs-qcom.h (98%)
 rename drivers/{scsi/ufs => ufs/host}/ufshcd-dwc.c (98%)
 rename drivers/{scsi/ufs => ufs/host}/ufshcd-dwc.h (95%)
 rename drivers/{scsi/ufs => ufs/host}/ufshcd-pci.c (99%)
 rename drivers/{scsi/ufs => ufs/host}/ufshcd-pltfrm.c (94%)
 rename drivers/{scsi/ufs => ufs/host}/ufshcd-pltfrm.h (98%)
 rename drivers/{scsi/ufs => ufs/host}/ufshci-dwc.h (100%)
 rename {drivers/scsi/ufs => include/scsi}/ufs.h (93%)
 rename {drivers/scsi/ufs => include/scsi}/ufs_quirks.h (94%)
 rename {drivers/scsi/ufs => include/scsi}/ufshcd.h (81%)
 rename {drivers/scsi/ufs => include/scsi}/ufshci.h (99%)
 rename {drivers/scsi/ufs => include/scsi}/unipro.h (98%)

