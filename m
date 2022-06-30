Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89941CCA473
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jun 2022 19:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236536AbiF3T5S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jun 2022 15:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbiF3T5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jun 2022 15:57:17 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D2245040
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 12:57:17 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id m2so332604plx.3
        for <linux-scsi@vger.kernel.org>; Thu, 30 Jun 2022 12:57:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SvNBbqzK/X2SN+Gd7C7NgjZJC8ydfh77I4hoUjZHWn4=;
        b=wnWXuhXW/nn5DEM5JwcgYyjR6T1YFieCxL8rdftvSy+FHa8SENgJFqFO7+MH+Uh27R
         wyPH8OCG9Kgka1xoQK37nmw87JvxYyRcYLXtzB1LUWHaiQHSCBHZqFS5HVbCMREuzFW5
         /ODPX0liGtCHbkahnqCpa0mDdymLdTc/j74tR1jF3EyOl5FtGG++C7Qdep4QRtWphoen
         krzUPPKIvCUThTcr32i3kebbjm9BUNF5OOqydGe+q04vpYGF+pldB1NQBN+LdtXmrXrt
         oglvVgwTnQHybJ1FIDc2FpVsqqd6qkbMBVc9KhgH7EMQFJ+WwlWkhyd3mrd6boZmdhmD
         EPpw==
X-Gm-Message-State: AJIora8RP0WHN3hvq3jj6UqGGCBMwUj0MLujltuU6kXEt6vjccrosfkC
        vZL2o0ErC4rJ1JiTkQujaOs=
X-Google-Smtp-Source: AGRyM1sqr/l3Gwd9g65Whdgm6Qa2M6Pw4fJ/hv+PrLNat6YAL0SzUIPGkFtZYo6Il8o8ewzPsKrOkw==
X-Received: by 2002:a17:90b:896:b0:1ef:2963:953d with SMTP id bj22-20020a17090b089600b001ef2963953dmr9685475pjb.203.1656619036393;
        Thu, 30 Jun 2022 12:57:16 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id x1-20020a17090300c100b0016a33177d3csm13789452plc.160.2022.06.30.12.57.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 12:57:15 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] Reduce ATA disk resume time
Date:   Thu, 30 Jun 2022 12:57:01 -0700
Message-Id: <20220630195703.10155-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
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

Changes compared to v1: addressed John Garry's two comments.

Bart Van Assche (2):
  scsi: core: Move the definition of SCSI_QUEUE_DELAY
  scsi: sd: Rework asynchronous resume support

 drivers/scsi/scsi_lib.c | 14 +++----
 drivers/scsi/sd.c       | 84 ++++++++++++++++++++++++++++++++---------
 drivers/scsi/sd.h       |  5 +++
 3 files changed, 78 insertions(+), 25 deletions(-)

