Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD7DC6FA86
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 22:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiINW4u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbiINW4r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 18:56:47 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C7D7FE6A
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 15:56:47 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id jm11so16545454plb.13
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 15:56:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=77kQekpRlfQoxtUOrf2qfkxc06VNc8k+7dL4uHy9dHw=;
        b=0MCDDLXEXsp8IRhsBZ8ekASjnVMztruWYHnqjx6FOV+/T0YLBF/lJIKzUB5N97Z1g4
         jIwGslYWwxdqMmJU1qWfeqjuk3aHwH0sWGfNtC29Sw9FqH45XOhR2ZtYxnCRwDM1t3yM
         Ije/+199V2ATJbZNntJEL5evx6LCouSd3sLpHtAvriXrDSMQc8F2u1p3xQl53shaAQnf
         3NWC7ZD8FNCPki43htmVJLmO8inPzcUgkrPcA6bzZT4Cb6wYK0ROmVN7I7CyQc2O1fF4
         psVyFgZ4mtf8mK3gIjdaqjtWe8k9HAIalAsBlSEYRm7fnJMlp8U8HTEROIbrf4nTNTaz
         FWmA==
X-Gm-Message-State: ACrzQf3SyUnAMrWGTcczSjrfzPSZIru9qu9TkZvK8Ncf1g8FX0yYwdpo
        qtIpu7SOCJAEfYwQeYd/gBU=
X-Google-Smtp-Source: AMsMyM71Xt0d8BdGYzHjLbBM5zEiUY1eb8cme2EjzYQsgzl8s4ziapC025AcU2GX4kT8SUV733jmNw==
X-Received: by 2002:a17:902:dad2:b0:178:401c:f66d with SMTP id q18-20020a170902dad200b00178401cf66dmr1255620plx.157.1663196206558;
        Wed, 14 Sep 2022 15:56:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9147:e0c1:9227:cf53])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902d70900b0016d1b70872asm2606926ply.134.2022.09.14.15.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 15:56:45 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 0/7] Prepare for constifying SCSI host templates
Date:   Wed, 14 Sep 2022 15:56:14 -0700
Message-Id: <20220914225621.415631-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
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

Bart Van Assche (7):
  scsi: esas2r: Initialize two host template members implicitly
  scsi: esas2r: Introduce scsi_template_proc_dir()
  scsi: core: Fail host creation if creating the proc directory fails
  scsi: core: Introduce a new list for SCSI proc directory entries
  scsi: core: Fix a use-after-free related to releasing device handlers
  module: Improve support for asynchronous module exit code
  scsi: core: Improve SCSI device removal

 drivers/scsi/esas2r/esas2r_main.c |  19 +++--
 drivers/scsi/hosts.c              |   3 +-
 drivers/scsi/scsi_priv.h          |   6 +-
 drivers/scsi/scsi_proc.c          | 124 +++++++++++++++++++++++++-----
 drivers/scsi/scsi_sysfs.c         |   9 +--
 include/linux/module.h            |   1 +
 include/scsi/scsi_host.h          |  18 ++---
 kernel/module/main.c              |  10 +++
 8 files changed, 143 insertions(+), 47 deletions(-)

