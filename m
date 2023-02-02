Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06808C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Feb 2023 22:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjBBWB7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Feb 2023 17:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbjBBWB6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2023 17:01:58 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36552885D4
        for <linux-scsi@vger.kernel.org>; Thu,  2 Feb 2023 14:01:32 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id t12-20020a17090aae0c00b00229f4cff534so6550253pjq.1
        for <linux-scsi@vger.kernel.org>; Thu, 02 Feb 2023 14:01:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6jaA09wzrIRgtIbC8xDy5PlXj/5BjpF7gR5JeHCrLa4=;
        b=waNTSE3qL6vZDPY+LMo/mzQy8zUnyyQc9ScW9SyX7P2iSc/EsbEN/rCU7pprQcwszD
         MTrALf1Qc06JLYWOWrnLw8dudx3c0uXtOCS9CGLjMAcwSNHERpP3mW1o6L2u48oCoM15
         7Z672w0ZnXHnJK1D0nQLPWEDL8aJJDLrR+KXVniB/O5HsawOm8hVk6q1htGCGGDr583Y
         VKFHrQ4qq1j4ZWiFpL7H5X9OlUNECY9k8b+zXCHKhudHn+eIkrsa2NaMLDYei/XEwkSi
         g3nVTZ2Lt3DrsIeC521TQoJqF7PIy/KRjVTCN4ra1jlG5SR8WuYoDns9U49Oi4Nh95e8
         oqPQ==
X-Gm-Message-State: AO0yUKVU6u/pRnISfQjdedGOf7dNWiOS/XNVWL8FNlcoUftdVkZ2X3FK
        AbaJmQWQEzALJ2KKLai2E88=
X-Google-Smtp-Source: AK7set+n1q7z4lAvLk2wz2wnxP1/hVvuVXDxgEdiFGQafoB9KIKA9nTuCwkoQrWy0+h2jB4osLQ3mQ==
X-Received: by 2002:a05:6a21:99a2:b0:bc:8a99:1943 with SMTP id ve34-20020a056a2199a200b000bc8a991943mr10011219pzb.15.1675375248511;
        Thu, 02 Feb 2023 14:00:48 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bf7f:37aa:6a01:bf09])
        by smtp.gmail.com with ESMTPSA id t8-20020a63b708000000b004f1e87530cesm232951pgf.91.2023.02.02.14.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 14:00:47 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] Use SYNCHRONIZE CACHE instead of FUA for UFS devices
Date:   Thu,  2 Feb 2023 14:00:39 -0800
Message-Id: <20230202220041.560919-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Measurements have shown that UFS devices perform better when using SYNCHRONIZE
CACHE instead of FUA. Hence this patch series that makes the SCSI core submit
a SYNCHRONIZE CACHE command instead of setting the FUA bit for UFS
devices. Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
- Updated __BLIST_LAST_USED.
- Added #include <scsi/scsi_devinfo.h> to fix a build error reported by the
  kernel robot.

Asutosh Das (1):
  scsi: ufs: Use SYNCHRONIZE CACHE instead of FUA

Bart Van Assche (1):
  scsi: core: Introduce the BLIST_BROKEN_FUA flag

 drivers/scsi/scsi_scan.c    | 3 +++
 drivers/ufs/core/ufshcd.c   | 4 ++++
 include/scsi/scsi_devinfo.h | 4 +++-
 3 files changed, 10 insertions(+), 1 deletion(-)

