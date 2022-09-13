Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB56C54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Sep 2022 19:57:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiIMT5Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Sep 2022 15:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiIMT5W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Sep 2022 15:57:22 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C366F11C06
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 12:57:21 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id d64-20020a17090a6f4600b00202ce056566so7236569pjk.4
        for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2022 12:57:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=mML9zZA+oIZ9iFG70coxIyYs5MGiznyTxundYWd4lNA=;
        b=uax5NvZTfcqDHm+XKXTn8jNBk/R3yw+chNn/8Kx324X8Aap3knJBoI+VKAtpG382Qc
         KKjF49Q1nZBxuvNmqPBz3xH45iXHqqGgf9by7Pktuxm+HFsT5TMWdvNXbKKUyRfNf5fN
         eXASOtVBXvCDprkEIjCui8W0xILqhvXjoOu2sr52NVjX8M5vpXANNwzU8eRhHdlmk3Kr
         dkOMGAliNKttu0QI+3Dpxp5O5xGu/b3j1pjcw/VsjlngTRoYx9yAzOp4MtSWiy/rnFg0
         f9hg6OVizNlz/BQ73GQGql1R+M39/YjOtORwKrWFaUWf0QJIN9DNUR0h+l12VsxGg+4R
         mu4Q==
X-Gm-Message-State: ACgBeo04TRy/y/YCTjPXJ8wL01XhPyhNX8Q2aLnwEWP+HnqyLSUE1Yrf
        NPD/v7h65HMLjCnNx2gNp/KD4ZJMXEw=
X-Google-Smtp-Source: AA6agR4P5o6H9c2aHjvHocudyHtE1gAiuBxoVfTiG8vNW4beTogm265yi1Mvh87vYD30X13EPFJ7/w==
X-Received: by 2002:a17:903:228c:b0:178:3bc7:8a3f with SMTP id b12-20020a170903228c00b001783bc78a3fmr8341554plh.88.1663099041194;
        Tue, 13 Sep 2022 12:57:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:515b:d33a:21be:45a])
        by smtp.gmail.com with ESMTPSA id p15-20020a1709027ecf00b0017825ab5320sm6739987plb.251.2022.09.13.12.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Sep 2022 12:57:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/4] Prepare for constifying SCSI host templates
Date:   Tue, 13 Sep 2022 12:57:12 -0700
Message-Id: <20220913195716.3966875-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series prepares for constifying SCSI host templates by moving the
members that are not constant out of the SCSI host template. Please consider
this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v3:
- Changed the 'present' counter from 8 to 32 bits.
- Fixed a bug in an error path (reported by John Garry).
- Changed EXPORT_SYMBOL() into EXPORT_SYMBOL_GPL().
- Split patch 1/3 into two patches.

Changes compared to v2:
- Optimized the show_info == NULL case.
- Added a patch that removes the code that clears the module pointer in the host
  template.

Changes compared to v1:
- Fix the CONFIG_SCSI_PROC_FS=n build.

Bart Van Assche (4):
  scsi: esas2r: Initialize two host template members implicitly
  scsi: esas2r: Introduce scsi_template_proc_dir()
  scsi: core: Introduce a new list for SCSI proc directory entries
  scsi: core: Rework the code for dropping the LLD module reference

 drivers/scsi/esas2r/esas2r_main.c |  19 +++--
 drivers/scsi/scsi_priv.h          |   4 +-
 drivers/scsi/scsi_proc.c          | 120 ++++++++++++++++++++++++++----
 drivers/scsi/scsi_sysfs.c         |   7 +-
 include/scsi/scsi_device.h        |   1 +
 include/scsi/scsi_host.h          |  18 ++---
 6 files changed, 127 insertions(+), 42 deletions(-)

