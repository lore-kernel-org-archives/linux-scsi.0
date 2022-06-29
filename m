Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52BD4C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 23:56:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiF2X4U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jun 2022 19:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiF2X4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jun 2022 19:56:17 -0400
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474AB26540
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2022 16:56:13 -0700 (PDT)
Received: by mail-pj1-f49.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so1038839pjm.4
        for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2022 16:56:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nACIfVQPWMUV1bAoUXUu0lwbfGBtICgK76L+bIS48MY=;
        b=lBGOEsq2g30OJvtVDE37NhKwOYRhL/aQ/B4NVC2rk2ql2ryfQlw6Jw2gWfpcuSKs8M
         jLKDBIQpSN2Unr3E1pTeJV8pa1MWiychyPAIeFm76ylOfbkR2xR8mtV+zvGx4MfbD6zt
         mYsMZmGR+dqwRWXFzdKHBYXDFbnplvrzl8wCSXRleqN0geeAY2lKSQ9PLV9/OeX0fIDr
         zW3VH8zew0GWHe1OWvUe6yyRQ+CHIY53nieVtIr0ts69aSNq2T0KKJjd5Pxsjz7R2HW2
         IwhIq3SddRndQsxI5dIwxnacbrsnXxBp101xvx7bpXkP36jlW3n3TAwVomjafOypXRE/
         IyDA==
X-Gm-Message-State: AJIora/wTbyLOd+VHa+ipd9G/GB623w0vyXpesiR3gaenNxr3MVsHwdY
        EC2QZX8EfxULdw9xNJdxqGA=
X-Google-Smtp-Source: AGRyM1v1zvplbdnHHusJgx0G07Tv7aUQHqCR0VG5gliYoNYnoN/KqzgHRSTiblrfNa3OGyyAaD4FTQ==
X-Received: by 2002:a17:90b:4f45:b0:1ed:3fe:e54 with SMTP id pj5-20020a17090b4f4500b001ed03fe0e54mr9041539pjb.32.1656546972441;
        Wed, 29 Jun 2022 16:56:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:3841:49ce:cba5:1586])
        by smtp.gmail.com with ESMTPSA id s5-20020a170902988500b00161947ecc82sm11932222plp.199.2022.06.29.16.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 16:56:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] Reduce ATA disk resume time
Date:   Wed, 29 Jun 2022 16:56:04 -0700
Message-Id: <20220629235606.2787919-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Recently it was reported that patch "scsi: core: pm: Rely on the device driver
core for async power management" causes resuming to take longer if an ATA disk
is present. This patch series fixes that regression. Please consider this
patch series for kernel v5.20.

Thanks,

Bart.

Changes compared to v1:
- Dropped patch "Retry after a delay if the device is becoming ready".

Bart Van Assche (2):
  scsi: core: Move the definition of SCSI_QUEUE_DELAY
  scsi: sd: Rework asynchronous resume support

 drivers/scsi/scsi_lib.c | 14 ++++----
 drivers/scsi/sd.c       | 79 +++++++++++++++++++++++++++++++----------
 drivers/scsi/sd.h       |  5 +++
 3 files changed, 73 insertions(+), 25 deletions(-)

