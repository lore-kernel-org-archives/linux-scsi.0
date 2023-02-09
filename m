Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FA42C61DA4
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 18:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjBISxi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Feb 2023 13:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBISxh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2023 13:53:37 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F20D1E1E1
        for <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2023 10:53:36 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id w5so3876163plg.8
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2023 10:53:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vlFDYhh/NDCTnQWq1FOuZuqBNkCnvlwE1Y/SNNsr3O8=;
        b=qwWpllGlDZCwptKIkYDOjspWEDUDiJYaOeanRFB8x75dX+aibXFzCTGjO9nQTFiGzR
         8YHUxdlJJZQd10izB2JdPnkSyT1TpfDZT5Oo8P27cao38TAgwYkFKOs3ttnMhGnUVRVu
         kB3r/4PEeVquwXGmZxEkfXiQZPJR7BWMy8tw7cLGPk7q68ss1Df/0AIlocJXbwJdvVpY
         bsm6U7+G1rn0JfFnm+VogrNjeq5fptIiibN2fyyZXYOzOnjIc1a33Qju9VI7BD3+eXIm
         Hot79Yn1vTYtQqRqTv/sT8YSL1k5gy5HGaAktk6/ZJ9Jc/v2zW3mLJiEsIpitSo2wIwm
         s4yw==
X-Gm-Message-State: AO0yUKUI9DEH34FUEtPKrT6b5V33RcwM8VG9EP9/po6O6vaM2Hg3MSlF
        J9GDH0nYDYpqiBSEMUeqO1o=
X-Google-Smtp-Source: AK7set/inJPUQMfqYdQWlK5U4CGfxLLXIKxFXfd90u2Kc8xinFq2TE5q6LjO61MY6vQh2KgUH448gQ==
X-Received: by 2002:a17:902:e2d1:b0:199:54af:f1fa with SMTP id l17-20020a170902e2d100b0019954aff1famr3597301plc.14.1675968815367;
        Thu, 09 Feb 2023 10:53:35 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:15f5:48f5:6861:f3f6])
        by smtp.gmail.com with ESMTPSA id x18-20020a63b212000000b00478162d9923sm1603988pge.13.2023.02.09.10.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 10:53:34 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/3] Simplify ufshcd_execute_start_stop()
Date:   Thu,  9 Feb 2023 10:53:25 -0800
Message-Id: <20230209185328.2762796-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series simplifies ufshcd_execute_start_stop() by using the new
scsi_execute_cmd() function instead of open-coding it. Please consider this
patch for the next merge window.

Thanks,

Bart.

Changes compared to v1:
- Addressed John's feedback that RQF_PM should always be set if BLK_MQ_REQ_PM
  is set.
- Added a third patch that makes RQF_PM to be set implicitly.

Bart Van Assche (3):
  scsi: core: Extend struct scsi_exec_args
  scsi: ufs: Rely on the block layer for setting RQF_PM
  scsi: ufs: Simplify ufshcd_execute_start_stop()

 drivers/scsi/scsi_lib.c    |  1 +
 drivers/ufs/core/ufshcd.c  | 35 ++++++++---------------------------
 include/scsi/scsi_device.h |  1 +
 3 files changed, 10 insertions(+), 27 deletions(-)

