Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E751C636D7
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Feb 2023 19:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbjBJTdd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Feb 2023 14:33:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjBJTd0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2023 14:33:26 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AB663109
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 11:33:22 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso9266252pju.0
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2023 11:33:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DCm1LWykd/v7wx3M+xj9y9kECkykoTeSpVK0kf2mxNI=;
        b=kTKfsDPPpSuz3zJGl6ycygJa/0zMLcQFPrO/htZR4YPNCE91b7KeAZ9i4eafPN1zbD
         SY6Zr0Cs2d65gV+BnvePNcSAaRUQ6PHA3bWm3kMrzsDivwmR/4dcM8pbdUTwqf5Ydkj6
         psW1mWRqE73pBsyfWzCoZZluj/7jh6CoxiNe70hh8dGhmq1zycFEtav2DF6idzZrq96Z
         DCkQ/0WXENjwqcvtM3sohN6hhiHLp5UvPP6W1ZRsCcF0CKfXQFWzv3+rtWkxZM/x9PNa
         /bh1AiKlP0zTWlCmXjdUFh3om51NaLTZt5xz59A32Jt8ozr8B+BLGeHlIcPzkHpCqBAo
         Sa1w==
X-Gm-Message-State: AO0yUKV45RgVx3f03Oy9kV4WBl0OVoVgrZ0cly9yY1JRU3CnXtq5wkRE
        Gn6KpasSOx4CJnKuXzZbKa0ddPYYn/0=
X-Google-Smtp-Source: AK7set/Z3O3J+yKsMI9IjMrpxPycqfSnc2/ilI+EzsCwMC2LLhGUB8RQVLthBeed0UBNrxNZ304giA==
X-Received: by 2002:a17:903:41c3:b0:199:75:9b4b with SMTP id u3-20020a17090341c300b0019900759b4bmr19453891ple.14.1676057602340;
        Fri, 10 Feb 2023 11:33:22 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a834:2664:42:db8b])
        by smtp.gmail.com with ESMTPSA id w9-20020a1709029a8900b0019605d48707sm3718356plp.114.2023.02.10.11.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 11:33:21 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/3] Simplify ufshcd_execute_start_stop()
Date:   Fri, 10 Feb 2023 11:32:55 -0800
Message-Id: <20230210193258.4004923-1-bvanassche@acm.org>
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

Changes compared to v2:
- Changed the type of scsi_exec_args.scmd_flags from unsigned int into int.
- Left out a WARN_ON_ONCE() statement from patch 2/3 that was removed by patch
  3/3 anyway.

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

