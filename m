Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4D4C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:44:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9815E611F2
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 00:44:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhKJArg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 19:47:36 -0500
Received: from mail-pj1-f48.google.com ([209.85.216.48]:46741 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbhKJArg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 19:47:36 -0500
Received: by mail-pj1-f48.google.com with SMTP id f20-20020a17090a639400b001a772f524d1so125944pjj.5
        for <linux-scsi@vger.kernel.org>; Tue, 09 Nov 2021 16:44:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oEmaWzczZP58lCJWkafKIeZC8UvzdUERUbtClUuQjyc=;
        b=Rg99a4sjrG9z70jrsg5h40URf5zFJQCVMCTtseCbNdJk1nO/i5TnQGfT7orvTm9Z1B
         TOAxa8aOckBCU8Pr8xEXlm8a/NizVgrp6lWYhX9vXoHozBQ0xAiM22VJasznJiu9sjvT
         wwvJcMLJAZ7YNIqUptpNhHkvTkOP0TQI+ruDzL2X/BY+vrCzCstcxT9QMQvHnurA8aHr
         o8QGujNVh8dQQuPZuPv0AzuOX2uBkleaBvg+CWj03e5S6Dp/pNrRnpMK85OcRDzFY15F
         HTujASSu8l6ayrmdokug1RuTmAjJRI3ablsoHDGXngjXuYmrjoJP8Vb+m6Z7N5ufBwuF
         NtYA==
X-Gm-Message-State: AOAM533sBe9wQ84yjOMqVqx4qtZLkBYspAPgN+0jYl3f9XYYbxYQbep2
        NPkbk7ZlVQjCS9zScjwapDA=
X-Google-Smtp-Source: ABdhPJxQscEDG+dMSU4Z9oMQ6hNREATfoZr7FDakvEjiMyqrcoXJt1vDxDpdSQgt1OQWE2Td8du3gQ==
X-Received: by 2002:a17:90a:43c4:: with SMTP id r62mr12425958pjg.86.1636505089126;
        Tue, 09 Nov 2021 16:44:49 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a582:6939:6a97:9cbf])
        by smtp.gmail.com with ESMTPSA id l17sm21868826pfc.94.2021.11.09.16.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 16:44:48 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/11] UFS patches for kernel v5.17
Date:   Tue,  9 Nov 2021 16:44:29 -0800
Message-Id: <20211110004440.3389311-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider these UFS driver kernel patches for kernel v5.17.

Thanks,

Bart.

Bart Van Assche (11):
  scsi: ufs: Rename a function argument
  scsi: ufs: Remove is_rpmb_wlun()
  scsi: ufs: Remove the sdev_rpmb member
  scsi: ufs: Remove dead code
  scsi: core: Add support for reserved tags
  scsi: ufs: Rework ufshcd_change_queue_depth()
  scsi: ufs: Fix a deadlock in the error handler
  scsi: ufs: Improve SCSI abort handling further
  scsi: ufs: Fix a kernel crash during shutdown
  scsi: ufs: Optimize the command queueing code
  scsi: ufs: Implement polling support

 drivers/scsi/scsi_lib.c       |   4 +-
 drivers/scsi/ufs/ufs-exynos.c |   4 +-
 drivers/scsi/ufs/ufshcd.c     | 233 +++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h     |   5 +-
 include/scsi/scsi_host.h      |   9 +-
 5 files changed, 115 insertions(+), 140 deletions(-)

