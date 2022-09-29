Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9611CC43219
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiI2WqC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiI2Wpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:45:34 -0400
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C822DC56
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:34 -0700 (PDT)
Received: by mail-pj1-f50.google.com with SMTP id x32-20020a17090a38a300b00209dced49cfso105817pjb.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=jcq8ftV/vBG3R7TxqFNyzVGF/cg0MtK1Xz6pzuDR7ps=;
        b=p6VL4rvU9aeiH+/oKid0stksjWdj7BO5We2eCv4vVv1hqMkPiI6vfi4u3xRCEPbCDw
         4exCE5uUyTg1ERLtynnjGA0s25kzpu5uq8zWFcNFM/v/Ua12mgr6QZaIbGKFGcH5rWVS
         5rot9mWi6BvurE2UN1UVA/Ya70Ehy/eBQPXO0SuXQ8I7lRC3Uf7CeeFoBNAkGEuBr5YM
         N7jdxEGpzI44cixhobqTVBAeezFjr2HgwRZ1IpALQwOGYsxip3m+67BySva63O624Xgq
         3PAZoRGK4niAMKY0fihhjIEDVXXyL3Ak6c3TPK7tJQ0ghIWLT5sKqpH0qtHqeFelp41v
         KmsQ==
X-Gm-Message-State: ACrzQf1kE7BJwKSXo+folAlI6IZ6T8GHCIoIC0fxKLWKBfHWlgHnXvCz
        SenNeoxn1AO1ZdHMJl8CAZboMr7yydE=
X-Google-Smtp-Source: AMsMyM671UMUN9DJvBZPdl1mIik8lqCg8bTPuDYEuAK/jEC0LPqNF22r95hoDt86/2DTrUcI+IgzKg==
X-Received: by 2002:a17:902:d2cc:b0:178:1742:c182 with SMTP id n12-20020a170902d2cc00b001781742c182mr5719926plc.98.1664491473789;
        Thu, 29 Sep 2022 15:44:33 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b0016d1b70872asm404508plk.134.2022.09.29.15.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:44:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 0/8] Prepare for constifying SCSI host templates
Date:   Thu, 29 Sep 2022 15:44:13 -0700
Message-Id: <20220929224421.587465-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series prepares for constifying SCSI host templates by moving the
members that are not constant out of the SCSI host template. This patch series
is based on Linus' master branch instead of the SCSI for-next branch. Please
consider this patch series for the next merge window.

Thanks,

Bart.

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
 drivers/scsi/scsi_sysfs.c         |  12 +--
 drivers/ufs/core/ufshcd.c         |   9 +-
 include/scsi/scsi_device.h        |   1 -
 include/scsi/scsi_host.h          |  18 ++--
 10 files changed, 164 insertions(+), 85 deletions(-)

