Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 711D7C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346995AbiDSXBE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiDSXBD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:03 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9C038781
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:19 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id h5so25419006pgc.7
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cziufLRX6ONmmMJ4/3wlx8jv3I/reb4vMI0qvAlTSok=;
        b=ni9Nxwd/gjmT17nsj0iD70gtFWg08LkXqZMk0/PE7H4tz+FUz79H5X/N+RvBl9hVno
         O6d8bLngmHMdHy2ZsfxL5l8Gu+YivNRm4sDZiSb7I9lcPPgS6zL/hp+kSSpeaQ6gou8k
         9IexDII3DMecNw80yr2YzzDAn6uWTg31cDATEPSrzClW4Ht7cwP9TlI4O97S3OY14o0f
         q49/aBl7vzY6PZykBStpE2AwgRyoTIWC0mg+Jt8C2eZRUeb6SpePhBq4+GPyDKM7sYot
         /FAHcQyHiGsnV6FdoyUMlLMrh1Y2n4TnLuBiYqCnKqNXu7zrjC6RTAnsa0ohKcHVY1OT
         45Jg==
X-Gm-Message-State: AOAM533JXY6+1dplQvkpok7ReAU6eWBbsoW0TJQLpWzSLILfKQLGY8DO
        HrdmMco7TdSGwcZxiGz6nO0=
X-Google-Smtp-Source: ABdhPJz1QE2vFMz0z/IZmJkDsHJ+gyg2jdOs5SDgg1Pag7nw69FK3MjcI78cMAzdQI9NfnaM69/GVw==
X-Received: by 2002:a05:6a00:c8f:b0:50a:77a3:e7b with SMTP id a15-20020a056a000c8f00b0050a77a30e7bmr12160726pfv.41.1650409098280;
        Tue, 19 Apr 2022 15:58:18 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:17 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 00/28] Split the ufshcd.h header file
Date:   Tue, 19 Apr 2022 15:57:43 -0700
Message-Id: <20220419225811.4127248-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series includes the following changes:
- Split the ufshcd.h header file into two header files - one file that
  defines the interface with UFS drivers and another file with definitions
  only used in the core.
- Multiple source code cleanup patches.
- A few patches with minor functional changes.

Please consider these changes for kernel v5.19.

Thanks,

Bart.

Changes compared to v2:
* Dropped patch 29, the patch that splits the drivers/scsi/ufs directory.

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
Bart Van Assche (28):
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

 drivers/scsi/ufs/Kconfig              |  26 +-
 drivers/scsi/ufs/cdns-pltfrm.c        |   2 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c    |   1 +
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c |   1 +
 drivers/scsi/ufs/tc-dwc-g210.c        |   2 +
 drivers/scsi/ufs/tc-dwc-g210.h        |   2 +
 drivers/scsi/ufs/ufs-debugfs.c        |   1 +
 drivers/scsi/ufs/ufs-exynos.c         |   5 +-
 drivers/scsi/ufs/ufs-exynos.h         |   8 +-
 drivers/scsi/ufs/ufs-hisi.c           |   2 +
 drivers/scsi/ufs/ufs-hwmon.c          |   1 +
 drivers/scsi/ufs/ufs-mediatek.c       |  31 +--
 drivers/scsi/ufs/ufs-qcom-ice.c       |   2 +-
 drivers/scsi/ufs/ufs-qcom.c           |  28 +-
 drivers/scsi/ufs/ufs-qcom.h           |   6 +-
 drivers/scsi/ufs/ufs-sysfs.c          |   1 +
 drivers/scsi/ufs/ufs-sysfs.h          |   3 +-
 drivers/scsi/ufs/ufs.h                |  35 ---
 drivers/scsi/ufs/ufs_bsg.c            |   6 +
 drivers/scsi/ufs/ufs_bsg.h            |   7 +-
 drivers/scsi/ufs/ufs_quirks.h         |  15 +-
 drivers/scsi/ufs/ufshcd-crypto.h      |   5 +-
 drivers/scsi/ufs/ufshcd-dwc.c         |   2 +
 drivers/scsi/ufs/ufshcd-dwc.h         |   2 +
 drivers/scsi/ufs/ufshcd-pci.c         |   4 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c      |  28 +-
 drivers/scsi/ufs/ufshcd-priv.h        | 298 +++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c             | 232 ++++++++--------
 drivers/scsi/ufs/ufshcd.h             | 368 ++++++--------------------
 drivers/scsi/ufs/ufshci.h             |   2 +
 drivers/scsi/ufs/ufshpb.c             |  14 +-
 drivers/scsi/ufs/unipro.h             |  18 +-
 32 files changed, 578 insertions(+), 580 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-priv.h

