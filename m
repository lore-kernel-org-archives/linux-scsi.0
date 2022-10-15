Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C02CBC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Oct 2022 00:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiJOAYd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 20:24:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJOAYc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 20:24:32 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754C7A3AB0
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:29 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id z20so6121232plb.10
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JI6kobT5QrUwxQycV5YZ2kZDypC3SieNcO1vU7VLC/o=;
        b=OkD3e6+7llVAvxz+gqJlyK48O1kgmETbyb5HU2tSYBBHw39EyBTUykBA2itsPDnfIs
         tF1vUYfvEry11xFUBZN9E6G/oq/6Mg1GQqeli26FN6rc2Smr/cZOBwuz6W9XZnezru3+
         acedT0Kp5rBcB966OXXb/PDT/wuzAIt4GPRMP71ErIbJMm+avbOgxc9wKPLQTQEDqoQj
         OL5B5owOFZ41WVzslQriAOYaaGVmi9eN4H6R54q3/Qmwd9quZ5FVbuzYYDLEk4VtZN24
         Of5tRvdjimS+Eieki1Y7gHEp+lB3Oi9R3p88rQ6nXY7kDFbR1jLy9sqxl7wgE/xKyQIb
         UGhg==
X-Gm-Message-State: ACrzQf1oJKmIEBeK98iBOv5hYtG9QNqMbEHVbOtmVyZOXcXYbnZzSObk
        deNi6GkSsI1LPuGMfs6A9qmVnCrim5w=
X-Google-Smtp-Source: AMsMyM7guklvFrrRpTO8wds0HTrHrFtGECovPAEAuWKI2imFlMryPwLaFyzBArrc7JsL94bUaZdgXg==
X-Received: by 2002:a17:902:ec89:b0:178:3ea4:2960 with SMTP id x9-20020a170902ec8900b001783ea42960mr415902plg.160.1665793468818;
        Fri, 14 Oct 2022 17:24:28 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y17-20020a634951000000b0046a1c832e9fsm1937953pgk.34.2022.10.14.17.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:24:28 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v7 0/8] Prepare for constifying SCSI host templates
Date:   Fri, 14 Oct 2022 17:24:10 -0700
Message-Id: <20221015002418.30955-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3
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

Changes compared to v6:
- Rebased this patch series on top of kernel v6.1-rc1.

Changes compared to v5:
- Addressed John Garry's feedback on patch 4/7.
- Dropped the kernel/module patch and replaced it with a series of patches
  that rework the scsi_device_put() calls that happen from atomic context and
  one patch that makes scsi_device_put() synchronous.

Changes compared to v4:
- Added three additional patches: fail host creation if creating the proc
  directory fails, a use-after-free fix and an improvement for the kernel
  module unload code.

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

Bart Van Assche (8):
  scsi: esas2r: Initialize two host template members implicitly
  scsi: esas2r: Introduce scsi_template_proc_dir()
  scsi: core: Fail host creation if creating the proc directory fails
  scsi: core: Introduce a new list for SCSI proc directory entries
  scsi: core: Rework scsi_single_lun_run()
  scsi: ufs: Simplify ufshcd_set_dev_pwr_mode()
  scsi: core: Remove the put_device() call from scsi_device_get()
  scsi: core: Release SCSI devices synchronously

 drivers/scsi/esas2r/esas2r_main.c |  19 +++--
 drivers/scsi/hosts.c              |   3 +-
 drivers/scsi/scsi.c               |  12 +--
 drivers/scsi/scsi_lib.c           |  32 ++++---
 drivers/scsi/scsi_priv.h          |   6 +-
 drivers/scsi/scsi_proc.c          | 137 +++++++++++++++++++++++++-----
 drivers/scsi/scsi_sysfs.c         |  22 +----
 drivers/ufs/core/ufshcd.c         |   9 +-
 include/scsi/scsi_device.h        |   1 -
 include/scsi/scsi_host.h          |  18 ++--
 10 files changed, 164 insertions(+), 95 deletions(-)

