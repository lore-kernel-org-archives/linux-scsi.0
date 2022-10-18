Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0DC3C433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Oct 2022 20:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiJRUaJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Oct 2022 16:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJRUaH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2022 16:30:07 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CF158DE0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:04 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id s196so13020405pgs.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 Oct 2022 13:30:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QiLpdQj0yY2lCIy57wukYDHK1U7GkFhzO2Lytv0JYRc=;
        b=X+95D/j5g3nwJdGfBqiCeooGzEi6HlIiD+r4JOBzPwk6UvHmSdYprRbppWd/2BH6on
         TbPMsnfJazoi29mfdhaTZSY2kZKgwRE+9O1BXreermiEZzn1gI3oNO5Vp87CFxE5LORQ
         uaOdEjLfVce6TZ3ponZE6BWUy1QWrP+/vT6DgFUfH7/TTTJeAVQB7S0df7ANT2an3hLP
         gMAJ6mk3gMWtmrVN9/bwpa30y9A2wRTHhfXaRJCcwGRKMF42U02pMc+Lac6DtEhVZtRX
         ynwD1HKUmX8+T7zRjBHntn47UaiWMW1wdbsjX7bHxuagFXDEhpEWrT4QMupmg2BGw5z4
         356Q==
X-Gm-Message-State: ACrzQf1Xg8XjPYmWirg1uF/zZPDLXxwiD4jN5WxMC2+CwcNq/F/arOLI
        1QRRK1LkTg7fp81m+HzPEts=
X-Google-Smtp-Source: AMsMyM42mZZg2hbKH8UqdtUa4AHJXwDZGJYOW/zw3oxOLrYDP/DI5Z0fw6bCMFf0+fxaJn9OljfLYw==
X-Received: by 2002:a05:6a00:a96:b0:558:8915:2f0e with SMTP id b22-20020a056a000a9600b0055889152f0emr4998901pfl.38.1666125004328;
        Tue, 18 Oct 2022 13:30:04 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:522b:67a3:58b:5d29])
        by smtp.gmail.com with ESMTPSA id h137-20020a62838f000000b005624ce0beb5sm9643677pfe.43.2022.10.18.13.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 13:30:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 00/10] Fix a deadlock in the UFS driver
Date:   Tue, 18 Oct 2022 13:29:48 -0700
Message-Id: <20221018202958.1902564-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
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

Changes compared to v3:
* Added two patches: one patch to reduce the START STOP UNIT timeout and another
  patch that introduces the ufshcd_execute_start_stop() function.
* Modified patch 3 such that it introduces a new flag (SCMD_FAIL_IF_RECOVERING)
  instead of modifying the behavior for the REQ_FAILFAST flags.

Changes compared to v2:
* Replaced the custom error handling code in ufshcd_eh_timed_out() with a call
  to ufshcd_link_recovery().

Changes compared to v1:
* Added support in the SCSI core for failing SCSI commands quickly during host
  recovery.
* Removed the patch that splits the ufshcd_err_handler() function.
* Fixed the code in ufshcd_eh_timed_out() for handling command timeouts.
* Removed the power management notifier again.

Bart Van Assche (10):
  scsi: core: Fix a race between scsi_done() and scsi_timeout()
  scsi: core: Change the return type of .eh_timed_out()
  scsi: core: Support failing requests while recovering
  scsi: ufs: Remove an outdated comment
  scsi: ufs: Use 'else' in ufshcd_set_dev_pwr_mode()
  scsi: ufs: Reduce the START STOP UNIT timeout
  scsi: ufs: Try harder to change the power mode
  scsi: ufs: Track system suspend / resume activity
  scsi: ufs: Introduce the function ufshcd_execute_start_stop()
  scsi: ufs: Fix a deadlock between PM and the SCSI error handler

 Documentation/scsi/scsi_eh.rst            |  7 +-
 drivers/message/fusion/mptsas.c           |  8 +--
 drivers/scsi/libiscsi.c                   | 26 +++----
 drivers/scsi/megaraid/megaraid_sas_base.c |  7 +-
 drivers/scsi/mvumi.c                      |  4 +-
 drivers/scsi/qla4xxx/ql4_os.c             |  8 +--
 drivers/scsi/scsi_error.c                 | 41 +++++------
 drivers/scsi/scsi_lib.c                   |  8 ++-
 drivers/scsi/scsi_transport_fc.c          |  7 +-
 drivers/scsi/scsi_transport_srp.c         |  8 +--
 drivers/scsi/storvsc_drv.c                |  4 +-
 drivers/scsi/virtio_scsi.c                |  4 +-
 drivers/ufs/core/ufshcd.c                 | 86 ++++++++++++++++++-----
 include/scsi/libiscsi.h                   |  2 +-
 include/scsi/scsi_cmnd.h                  |  3 +-
 include/scsi/scsi_host.h                  | 14 +++-
 include/scsi/scsi_transport_fc.h          |  2 +-
 include/scsi/scsi_transport_srp.h         |  2 +-
 include/ufs/ufshcd.h                      |  5 +-
 19 files changed, 155 insertions(+), 91 deletions(-)

