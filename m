Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C10EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 20:25:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjGXUZl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 16:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbjGXUZk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 16:25:40 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56FDA4
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:25:35 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-6687096c6ddso2679905b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 13:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690230335; x=1690835135;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/XwtC2aFCzNPJsEFWrPPRbmZfOwCzTVTafAed+Bbr3Y=;
        b=bR8BULTOU0yDZAsN+U9kdnMF2naFGQ8fHOb155E3lAPDmQ0u8SBItJDiTZNZJjz3xn
         vDFjF6eJ5fABooCBBuYg0Re2kWhSnNC63RkwIyV1q83ZrlrjusLfe6buTXwVtR6ExKG4
         WkydH01PNhE0+HxVAvZ62hfF388OURKrOhnpX21Xzm1olN3fg4R1I7LZbvhUxrzzSF8m
         DuJoNNyhorrmAoEIfZY1A1HBZYP/7/9s9UJKhLGHDyLD/sCxrWx6P7WNwx5rKq8V485b
         F19Rjk0ZIE6+8JR1kWYZGWJ8Tl83kY9YBts/aEGntxnYKCyft3lRNz5pYZuVBfnSc7gZ
         Ag6g==
X-Gm-Message-State: ABy/qLbdckWLl2ACJ/8bsxwB2CYa+tO2mIyK/4veYmzzyi32pqY/6rRz
        VHXmhL2lyLnhhrLFf5JMmyk=
X-Google-Smtp-Source: APBJJlEMljxnmdTZdIuxVR0V4fQRvRmUdJMzgeG7l5WU7aeKjE8UpU8mTsyht+NUc5ai0vdAjkrsPA==
X-Received: by 2002:a05:6a20:9493:b0:130:9638:36d4 with SMTP id hs19-20020a056a20949300b00130963836d4mr7027862pzb.33.1690230335035;
        Mon, 24 Jul 2023 13:25:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:bda6:6519:2a73:345e])
        by smtp.gmail.com with ESMTPSA id v13-20020aa7850d000000b00653fe2d527esm8185540pfn.32.2023.07.24.13.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 13:25:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/12] Multiple cleanup patches for the UFS driver
Date:   Mon, 24 Jul 2023 13:16:35 -0700
Message-ID: <20230724202024.3379114-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch includes the following changes, none of which should change the
functionality of the UFS host controller driver:
- Improve the kernel-doc headers further.
- Fix multiple W=2 compiler warnings.
- Simplify ufshcd_abort_all().
- Simplify the code for creating and parsing UFS Transport Protocol (UTP)
  headers.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (12):
  scsi: ufs: Follow the kernel-doc syntax for documenting return values
  scsi: ufs: Document all return values
  scsi: ufs: Fix kernel-doc headers
  scsi: ufs: Rename a function argument
  scsi: ufs: Minimize #include directives
  scsi: ufs: Simplify zero-initialization
  scsi: ufs: Improve type safety
  scsi: ufs: Remove a local variable from ufshcd_abort_all()
  scsi: ufs: Simplify ufshcd_abort_all()
  scsi: ufs: Remove a member variable
  scsi: ufs: Simplify transfer request header initialization
  scsi: ufs: Simplify response header parsing

 drivers/ufs/core/ufs-hwmon.c       |   3 +-
 drivers/ufs/core/ufs-mcq.c         |  17 +-
 drivers/ufs/core/ufs_bsg.c         |   2 +
 drivers/ufs/core/ufshcd-crypto.h   |  20 +-
 drivers/ufs/core/ufshcd-priv.h     |   4 +-
 drivers/ufs/core/ufshcd.c          | 463 +++++++++++++++--------------
 drivers/ufs/host/cdns-pltfrm.c     |  27 +-
 drivers/ufs/host/tc-dwc-g210-pci.c |   2 +-
 drivers/ufs/host/tc-dwc-g210.c     |  32 +-
 drivers/ufs/host/ufs-mediatek.c    |   6 +-
 drivers/ufs/host/ufs-qcom.c        |   8 +-
 drivers/ufs/host/ufshcd-dwc.c      |  22 +-
 drivers/ufs/host/ufshcd-pci.c      |   2 +-
 drivers/ufs/host/ufshcd-pltfrm.c   |   6 +-
 include/ufs/ufs.h                  |  79 +++--
 include/ufs/ufshcd.h               |  27 +-
 include/ufs/ufshci.h               |  55 ++--
 17 files changed, 414 insertions(+), 361 deletions(-)

