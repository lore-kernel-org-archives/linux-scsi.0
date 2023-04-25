Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40134C77B7C
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Apr 2023 23:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236456AbjDYXaE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Apr 2023 19:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjDYXaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Apr 2023 19:30:03 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02BD8B454
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:30:02 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-63d4595d60fso39185981b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2023 16:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682465401; x=1685057401;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BE/Y2d5AW7sureX5KIoOJq/Tq6851JgIdbwqKtpjbGM=;
        b=OnjB0SfHDYpLJgV8wBGFxJrd6892yPcpj2fnXHhuSLwccW8PZg0KPq2H9CFlv1UhLz
         k7ptGI7cNsvPNre1ZKBKTrcXAmn2YoURGT+YcWpe67oP4FL5D9P2LDbLJjTO+8Ghb3mV
         pmO3oDKODydNazuIJFig/neZEl0wjsnT2ZTV97TYRB3jas31iMi+1zjYQCj96H/+gV1J
         f1RPYNPRPEeRYsBESTQooFMi+s5wr/igWMAU2+xhrV84RoCvd56fMzTXEwehMnT6VAJO
         53ap+0I6Xer1bviqrGnO52uOYhQYcU7fkrh5HKIOAsyUeJTwmGr4BBHyBXFTP/myIblw
         uQKA==
X-Gm-Message-State: AC+VfDwYOXzWYvE3aGKXMkeWnVJh9yJQeCYvWD0MFRE6k1FPhRJ8d2e/
        LQt51rc5G/HnpqYGXAoc5HI=
X-Google-Smtp-Source: ACHHUZ6AOp+6cgKpyReiKruSnIB4/sn3avPqe7A9d7yL16hJpCm7+225uUS5xYWfqQ2NDijDAUGgtQ==
X-Received: by 2002:a05:6a20:4417:b0:f2:4c39:8028 with SMTP id ce23-20020a056a20441700b000f24c398028mr553362pzb.21.1682465401240;
        Tue, 25 Apr 2023 16:30:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5099:ad7c:6c1:9570])
        by smtp.gmail.com with ESMTPSA id b20-20020a056a0002d400b006348cb791f4sm9829941pft.192.2023.04.25.16.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 16:30:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] UFS host controller driver patches
Date:   Tue, 25 Apr 2023 16:29:50 -0700
Message-ID: <20230425232954.1229916-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider these four UFS host controller driver patches for the next
merge window. Patches 1/4 and 2/4 have been posted before while the other two
patches are new.

Thanks,

Bart.

Bart Van Assche (4):
  scsi: ufs: Increase the START STOP UNIT timeout from one to ten
    seconds
  scsi: ufs: Fix handling of lrbp->cmd
  scsi: ufs: Move ufshcd_wl_shutdown()
  scsi: ufs: Simplify driver shutdown

 drivers/ufs/core/ufshcd.c             | 63 ++++++++++-----------------
 drivers/ufs/host/cdns-pltfrm.c        |  1 -
 drivers/ufs/host/tc-dwc-g210-pci.c    | 10 -----
 drivers/ufs/host/tc-dwc-g210-pltfrm.c |  1 -
 drivers/ufs/host/ufs-exynos.c         |  1 -
 drivers/ufs/host/ufs-hisi.c           |  1 -
 drivers/ufs/host/ufs-mediatek.c       |  1 -
 drivers/ufs/host/ufs-qcom.c           |  1 -
 drivers/ufs/host/ufs-sprd.c           |  1 -
 drivers/ufs/host/ufshcd-pci.c         | 10 -----
 drivers/ufs/host/ufshcd-pltfrm.c      |  6 ---
 drivers/ufs/host/ufshcd-pltfrm.h      |  1 -
 include/ufs/ufshcd.h                  |  1 -
 13 files changed, 22 insertions(+), 76 deletions(-)

