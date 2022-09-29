Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E34F2C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiI2WAd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiI2WAb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:00:31 -0400
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4D66127CA1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:00:30 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id r62so2574174pgr.12
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:00:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Qw6GrPHWsTEc2/azoOKQtjEcG3qN8F4oXK3O4NIkj+8=;
        b=usx3Zi5zXVaczVQrKDalwgsTIbKaG5RPekBSq+Z0e/NFr/MRgGlKIYOq1dWAbX1En6
         hWcWPs3HoMh2n7iArr3VweAZ9pciLLdlVs80FwgCnH/kiWZlWWTlCXa1lUj5JqvnhOQc
         fddVayyNQeB0DIjV5kup2/Fpn+E22wmympWzXEJutmYtacVG6QkV7Ftu21aSLZsCYcLn
         EZRZ3eGv4cc+GgqqgfeWdBQwsogxUCqcnCeU4PEdSYkY1wtw2ldlRkliQxYFt/8jn7SV
         Edj9dnghkcyGSXQJz58/TR2FT8zjJN5053W6/3trfJ1lz6A43GjWTy3Fmfnyb8pP5Chg
         0wXg==
X-Gm-Message-State: ACrzQf0HoNCsCTHgGnX9BuHow6is2sNIZ9mgsbFlk0SewxBOAVIDLwms
        RhxTG+eiCUqQ6vkfTdmn9KY=
X-Google-Smtp-Source: AMsMyM4CbXoc50kP2j9K3xWfMKV/fBtSxOOfQv7pSgc78xm6n0sun9KHKIHH7yAQqBIq4rhvcOB1zQ==
X-Received: by 2002:a05:6a00:852:b0:544:5907:7520 with SMTP id q18-20020a056a00085200b0054459077520mr5651074pfk.31.1664488829764;
        Thu, 29 Sep 2022 15:00:29 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id e3-20020a17090301c300b001782f94f8ebsm407787plh.3.2022.09.29.15.00.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:00:29 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/8] Fix a deadlock in the UFS driver
Date:   Thu, 29 Sep 2022 15:00:13 -0700
Message-Id: <20220929220021.247097-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
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

Changes compared to v2:
* Replaced the custom error handling code in ufshcd_eh_timed_out() with a call
  to ufshcd_link_recovery().

Changes compared to v1:
* Added support in the SCSI core for failing SCSI commands quickly during host
  recovery.
* Removed the patch that splits the ufshcd_err_handler() function.
* Fixed the code in ufshcd_eh_timed_out() for handling command timeouts.
* Removed the power management notifier again.

Bart Van Assche (8):
  scsi: core: Fix a race between scsi_done() and scsi_timeout()
  scsi: core: Change the return type of .eh_timed_out()
  scsi: core: Support failing requests while recovering
  scsi: ufs: Remove an outdated comment
  scsi: ufs: Use 'else' in ufshcd_set_dev_pwr_mode()
  scsi: ufs: Try harder to change the power mode
  scsi: ufs: Track system suspend / resume activity
  scsi: ufs: Fix a deadlock between PM and the SCSI error handler

 Documentation/scsi/scsi_eh.rst            |  7 ++--
 drivers/message/fusion/mptsas.c           |  8 ++---
 drivers/scsi/libiscsi.c                   | 26 +++++++-------
 drivers/scsi/megaraid/megaraid_sas_base.c |  7 ++--
 drivers/scsi/mvumi.c                      |  4 +--
 drivers/scsi/qla4xxx/ql4_os.c             |  8 ++---
 drivers/scsi/scsi_error.c                 | 41 +++++++++++------------
 drivers/scsi/scsi_lib.c                   |  8 +++--
 drivers/scsi/scsi_transport_fc.c          |  6 ++--
 drivers/scsi/scsi_transport_srp.c         |  8 ++---
 drivers/scsi/storvsc_drv.c                |  4 +--
 drivers/scsi/virtio_scsi.c                |  4 +--
 drivers/ufs/core/ufshcd.c                 | 37 +++++++++++++++-----
 include/scsi/libiscsi.h                   |  2 +-
 include/scsi/scsi_host.h                  | 14 +++++++-
 include/scsi/scsi_transport_fc.h          |  2 +-
 include/scsi/scsi_transport_srp.h         |  2 +-
 include/ufs/ufshcd.h                      |  5 ++-
 18 files changed, 115 insertions(+), 78 deletions(-)

