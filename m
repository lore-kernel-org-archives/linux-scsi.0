Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C87ECAAD5
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Sep 2022 23:37:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiIHXhj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Sep 2022 19:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiIHXhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Sep 2022 19:37:22 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D483AB1A
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 16:36:08 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id b144so19765pfb.7
        for <linux-scsi@vger.kernel.org>; Thu, 08 Sep 2022 16:36:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=+FfNCM2lY3A3MRg1E/LgbqjT4+rkwUJvM1WlBomazII=;
        b=cwBKb/mOD0Uon9joA5jcIf8ZzrARudLY9bgREQDYN1CEjxxPc3dXZqZnsgLnKUbalu
         vPBXPOo4JDRumOr6V3rKICXwC8O/EkIwAd7/R3C43LH1q90wOqBKHS6OZn7YEpenP23s
         zyyLnf2O5A8nkUUQ+9l8knOxWbm+MvR2VsD1a5BjDcVnrIarNsap20A7i6/TwOEBbNnk
         YJdukNLmoqoavQ4o9d/7v0A3AaduN7dFpkvtE8OZ8GyndCDABCJtyKQLHjLO/mIiEIef
         ymSuIlJszWkprxbi29Q933RqeRUETJdBKdvKmYxglLidNikxyw5dJFLWQExcnl6LoGE7
         3Ldg==
X-Gm-Message-State: ACgBeo2nzV/JDfFut/nn2C+IHUrs64qsu74cAJUZ4aKv9Pn/qZthmC3X
        61IN+7uLgikUFghl2LAeYecAXxd7nwg=
X-Google-Smtp-Source: AA6agR62l+Eq09DhoLiem7/Z/NnhfyQY0Gw9UBIUWTMQD0aRarUH8XQb3UpxJSkVtACghOgzjZyDvA==
X-Received: by 2002:a63:d1d:0:b0:42b:9117:ba48 with SMTP id c29-20020a630d1d000000b0042b9117ba48mr9953297pgl.518.1662680167700;
        Thu, 08 Sep 2022 16:36:07 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c18a:7410:112c:aa7c])
        by smtp.gmail.com with ESMTPSA id w16-20020a170902e89000b0016c574aa0fdsm84259plg.76.2022.09.08.16.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 16:36:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/3] Prepare for constifying SCSI host templates
Date:   Thu,  8 Sep 2022 16:35:57 -0700
Message-Id: <20220908233600.3043271-1-bvanassche@acm.org>
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

Changes compared to v2:
- Optimized the show_info == NULL case.
- Added a patch that removes the code that clears the module pointer in the host
  template.

Changes compared to v1:
- Fix the CONFIG_SCSI_PROC_FS=n build.

Bart Van Assche (3):
  scsi: esas2r: Introduce scsi_template_proc_dir()
  scsi: core: Introduce a new list for SCSI proc directory entries
  scsi: core: Rework the code for dropping the LLD module reference

 drivers/scsi/esas2r/esas2r_main.c |  18 +++--
 drivers/scsi/scsi_priv.h          |   4 +-
 drivers/scsi/scsi_proc.c          | 119 ++++++++++++++++++++++++++----
 drivers/scsi/scsi_sysfs.c         |   7 +-
 include/scsi/scsi_device.h        |   1 +
 include/scsi/scsi_host.h          |  18 ++---
 6 files changed, 126 insertions(+), 41 deletions(-)

