Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FF4C77B6E
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Apr 2023 20:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjDLUlf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 16:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjDLUle (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 16:41:34 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6E655A6
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:41:33 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id w11so12737856plp.13
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 13:41:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681332093; x=1683924093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/wUSZJNJReBX5fhjR70d3H/uFpq8P2qcUj8Gkvn0pE0=;
        b=lnEsgmSf6DEh1vSeBEU/EB15qIOuKP7uyRV5OkMHss08FZ1dVHd0pUfs+puHXdkwjh
         GIotiu2bjASTLwqe8M9OMi0i2ELHugNlRxzkO/qJEbFSpql9kXdNt8vfkhmw8W35/gFi
         Gf7YeokSUpg4hhcSrPGOr/d9KrzBsqlSsft1wPZeWXI/DaWJm9rVT0o7AbaELpNb2uol
         TzCBvGr0zElSeHtVX/9MOuXcdHNV/ibKMSuEGPx90D2KmSo/HFR+CyMtYMWQS2Lsbm+0
         EgmDKQswPlkw/kt/0Mys3PIcgD+7yJ9/3VIERbTK/SiCsz6BcEOOO5KgW3WwHdEMvjXv
         hOpw==
X-Gm-Message-State: AAQBX9fLDunxKQZmB2fDtPgu2yMw/TDw1RsX56uraTl8+nk6VgIIUi+2
        czGRXSSPBLxAuxf/Y5YnAWo=
X-Google-Smtp-Source: AKy350a+vlq42j1+LE0Pv/7wlMP8CI+h+ACl8YU1pXBLp2gSUsQ+qVhA99l1mSDBGIFJW0dNWRquEA==
X-Received: by 2002:a05:6a20:cd61:b0:d6:bad9:9136 with SMTP id hn33-20020a056a20cd6100b000d6bad99136mr16603165pzb.27.1681332092783;
        Wed, 12 Apr 2023 13:41:32 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d89d:35dd:5938:1993])
        by smtp.gmail.com with ESMTPSA id l19-20020a62be13000000b006249928aba2sm12123364pff.59.2023.04.12.13.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 13:41:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] SCSI core and UFS patches for kernel v6.4
Date:   Wed, 12 Apr 2023 13:41:22 -0700
Message-Id: <20230412204125.3222615-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series includes a patch for making sd_shutdown() fail future I/O
and also two UFS patches.

Patch 3/3 of this series has been posted earlier. Compared to the previous
version of that patch, a Fixes: tag has been added.

Please consider this patch series for the next merge window. 

Thanks,

Bart.

Bart Van Assche (3):
  scsi: sd: Let sd_shutdown() fail future I/O
  scsi: ufs: Simplify ufshcd_wl_shutdown()
  scsi: ufs: Increase the START STOP UNIT timeout from one to ten
    seconds

 drivers/scsi/sd.c         |  9 ++++++++-
 drivers/ufs/core/ufshcd.c | 15 +++------------
 2 files changed, 11 insertions(+), 13 deletions(-)

