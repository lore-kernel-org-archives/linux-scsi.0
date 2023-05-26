Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD682C77B7A
	for <linux-scsi@archiver.kernel.org>; Fri, 26 May 2023 17:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242576AbjEZRaN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 May 2023 13:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjEZRaM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 May 2023 13:30:12 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131311A2
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 10:30:11 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2537a79b9acso845656a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 26 May 2023 10:30:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685122210; x=1687714210;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U0a8SpZvUprwvf6ooboRYq5seYDnZboYfrxOVgi0LC0=;
        b=j4NbvF5kPfuT5G4AnUeBPXXOmbdouLaliiWLxZt9cA0peNiji+FQyOcUUB7ZOlBV6f
         RaKryv7gnOZ9ZU+nm92+adPOVApf4t7QpQLTn/MTYwVQsBhndK+6wt/8ydYFu0kKDM/C
         BQNikn8/ZLIsy1UKDZDSVGwe8z/nz18M05ec3C1l0vIxMq5XimcXay4lZT8ODovvGc+x
         cSMt9bX1M/5/cpd6md3lkF0HcojJKMcA1e/h+fWol5AzQpW3I14Y9WjDaxNekrmmO6UR
         ccRtocYDvXbFBoh/nrQE3xdSaew8kiwDCbR0TDcO6EIQ2CeX0aOrDlddDi0AAPjRSmq5
         cj6Q==
X-Gm-Message-State: AC+VfDzwidowzrp1rY9Lsmb9XWYHQn8t79RwbHvhyVCufUjtfwRiXLjL
        JNuVQKkUFnfr3AsigIIUmDkPvFQ1+n4=
X-Google-Smtp-Source: ACHHUZ6Y9ngIj0P9tCv3w2YpfuKFM82jV76vMLlBLSBeJ9jJ2CN8Mnjp8u2ZNBmzNBEdPCdJ2QR0Dw==
X-Received: by 2002:a17:902:9a96:b0:1af:d213:668c with SMTP id w22-20020a1709029a9600b001afd213668cmr3225715plp.12.1685122210403;
        Fri, 26 May 2023 10:30:10 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902f54900b001ac7c725c1asm3519156plf.6.2023.05.26.10.30.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 10:30:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/4] ufs: Do not requeue while ungating the clock
Date:   Fri, 26 May 2023 10:29:45 -0700
Message-ID: <20230526173007.1627017-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.rc0.172.g3f132b7071-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

In the traces we recorded while testing zoned storage we noticed that UFS
commands are requeued while the clock is being ungated. Command requeueing
makes it harder than necessary to preserve the command order. Hence this
patch series that modifies the SCSI core and also the UFS driver such that
clock ungating does not trigger command requeueing.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v2:
- Only enable BLK_MQ_F_BLOCKING if necessary.

Changes compared to v1:
- Dropped patch "scsi: ufs: core: Unexport ufshcd_hold() and ufshcd_release()".
- Removed a ufshcd_scsi_block_requests() / ufshcd_scsi_unblock_requests() pair
  from patch "scsi: ufs: Ungate the clock synchronously".

Bart Van Assche (4):
  scsi: core: Rework scsi_host_block()
  scsi: core: Support setting BLK_MQ_F_BLOCKING
  scsi: ufs: Conditionally enable the BLK_MQ_F_BLOCKING flag
  scsi: ufs: Ungate the clock synchronously

 drivers/scsi/hosts.c             |  1 +
 drivers/scsi/scsi_lib.c          | 26 +++++-----
 drivers/ufs/core/ufs-sysfs.c     |  2 +-
 drivers/ufs/core/ufshcd-crypto.c |  2 +-
 drivers/ufs/core/ufshcd-priv.h   |  2 +-
 drivers/ufs/core/ufshcd.c        | 85 ++++++++++----------------------
 include/scsi/scsi_host.h         |  6 +++
 include/ufs/ufshcd.h             |  2 +-
 8 files changed, 53 insertions(+), 73 deletions(-)

