Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31815C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 18:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbiI0Snj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 14:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231639AbiI0Snd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 14:43:33 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D556FF3736
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:43:29 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id c24so9882857plo.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2022 11:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=daM1efRa9H1NnrlIjZ7OPx9hQ8Zot/aqgJWuGE+4KyY=;
        b=uc6pnPnP4PIR9MIsTEeam+kTGd1ueBK5eNFg8wwus114F0r7rtoVgxSQ1O1jhFXorL
         byVKVUDxEq6l5rFWuPf5kOiAML9isvP/zDuvL2PSJGd+CpU4LnivMo7yiMCyB6jwxzNI
         hcsSieA6W7+GJwr616KL4ou8LHBWLvJWsIsn/cM2pML5Rshvw8XPG51OI9SjedRON22I
         7advBIHLRedOR5hPNJzmlHJRia38B5BFlzECk4hI6aZFVY0agP+f2jscxiFI2IACgZyW
         0gO4lMbkWP+3CW/VYB/U5QP7hwCYrslhzI6GbxZLS4U1besTcPZG+t/rJg+bTCMlG8nk
         eE3A==
X-Gm-Message-State: ACrzQf3JPO9Lbv10bpnvva+3/F6El2+CjEColuuucc2sWdfgZ4kbK8H/
        F2qGMLfkrEDnuz4L4g/yN7A=
X-Google-Smtp-Source: AMsMyM7peZIyI7vERzgxfUvBA2IjTShTbmM+Ov+WZSPXju/0JmOinVck6rB4xAeiDad29rXc/acJPg==
X-Received: by 2002:a17:902:e751:b0:178:2976:41a0 with SMTP id p17-20020a170902e75100b00178297641a0mr27913519plf.12.1664304208533;
        Tue, 27 Sep 2022 11:43:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:457b:8ecb:16d:677])
        by smtp.gmail.com with ESMTPSA id x15-20020aa7956f000000b0052e987c64efsm2184083pfq.174.2022.09.27.11.43.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:43:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/8] Fix a deadlock in the UFS driver
Date:   Tue, 27 Sep 2022 11:43:01 -0700
Message-Id: <20220927184309.2223322-1-bvanassche@acm.org>
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

 Documentation/scsi/scsi_eh.rst            |  7 ++-
 drivers/message/fusion/mptsas.c           |  8 +--
 drivers/scsi/libiscsi.c                   | 26 ++++-----
 drivers/scsi/megaraid/megaraid_sas_base.c |  7 ++-
 drivers/scsi/mvumi.c                      |  4 +-
 drivers/scsi/qla4xxx/ql4_os.c             |  8 +--
 drivers/scsi/scsi_error.c                 | 41 +++++++-------
 drivers/scsi/scsi_lib.c                   |  8 +--
 drivers/scsi/scsi_transport_fc.c          |  6 +--
 drivers/scsi/scsi_transport_srp.c         |  8 +--
 drivers/scsi/storvsc_drv.c                |  4 +-
 drivers/scsi/virtio_scsi.c                |  4 +-
 drivers/ufs/core/ufshcd.c                 | 65 ++++++++++++++++++++---
 include/scsi/libiscsi.h                   |  2 +-
 include/scsi/scsi_host.h                  | 14 ++++-
 include/scsi/scsi_transport_fc.h          |  2 +-
 include/scsi/scsi_transport_srp.h         |  2 +-
 include/ufs/ufshcd.h                      |  5 +-
 18 files changed, 143 insertions(+), 78 deletions(-)

