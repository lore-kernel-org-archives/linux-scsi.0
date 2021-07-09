Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA9EC07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:26:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59D4D613C8
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 20:26:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhGIU3g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 16:29:36 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:45908 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbhGIU3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jul 2021 16:29:34 -0400
Received: by mail-pg1-f177.google.com with SMTP id y17so11065813pgf.12
        for <linux-scsi@vger.kernel.org>; Fri, 09 Jul 2021 13:26:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WrrW2VOhcqp9kLuf4rx/H2lci5g7a/+vkKyVP+UB7dY=;
        b=mkG/YeqFPwflsbGvC/55tDLVfeexWA5qMW2waFKx3Kmk5LiR1Fh0K3LvlAWHeks0/1
         +DxzriN7u7Fft19x4AuYrXdVYR1zuOS+m4sOOV7TQp4OlUi9QcVJ3bsjFrYKhjov3Ewt
         cM/REsG2Qu7CU21JaBjhe/WJCMa3/TLhvlRkEfnHlLrdD2mW7rroErOP6VHL3/FnBj1V
         UdOethWl8uus6jhdjuZgWqmmJvb30zfVLzjk0GmlZH7PK9jFA6P8+GvSGddkaF4aldEE
         xfPbIBeqtCbOgFCGUakgYpqpus8NSP3/CHe+XA8FOoKyxRz2nYicy9j1pUpjdFP/LQLf
         BOHg==
X-Gm-Message-State: AOAM531kkvIfZBYn6Ug+2N8StMgjDYniyPMPB/VLSWzazrNeiWqZ53wZ
        1HlKIi7bv6RDCGUJq1kmDDg=
X-Google-Smtp-Source: ABdhPJxBiSSDUld9gI/zKkwCuHQwJdcwePDQEjtZ59jif3As0k1RCY3ejOOiPuYCpI+64lNxku4i2Q==
X-Received: by 2002:a63:a18:: with SMTP id 24mr5912428pgk.309.1625862409179;
        Fri, 09 Jul 2021 13:26:49 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:eeaf:c266:e6cc:b591])
        by smtp.gmail.com with ESMTPSA id e16sm8812927pgl.54.2021.07.09.13.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:26:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 00/19] UFS patches for kernel v5.15
Date:   Fri,  9 Jul 2021 13:26:19 -0700
Message-Id: <20210709202638.9480-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210709202638.9480-1-bvanassche@acm.org>
References: <20210709202638.9480-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider the patches in this series for kernel v5.15.

Thanks,

Bart.

Changes compared to v1:
- Left out the SCSI core patches for the SCSI error handler in order not to
  delay the UFS patches by the conversation around the SCSI error handler
  patches.
- Restored the WARN_ON_ONCE(tag < 0) statements in the patch that removes
  ufshcd_valid_tag().
- Split "Fix a race in the completion path" in two patches.
- Added a fault injection patch.

Bart Van Assche (19):
  scsi: Fix the documentation of the scsi_execute() time parameter
  scsi: ufs: Reduce power management code duplication
  scsi: ufs: Only include power management code if necessary
  scsi: ufs: Rename the second ufshcd_probe_hba() argument
  scsi: ufs: Use DECLARE_COMPLETION_ONSTACK() where appropriate
  scsi: ufs: Remove ufshcd_valid_tag()
  scsi: ufs: Verify UIC locking requirements at runtime
  scsi: ufs: Improve static type checking for the host controller state
  scsi: ufs: Remove several wmb() calls
  scsi: ufs: Inline ufshcd_outstanding_req_clear()
  scsi: ufs: Rename __ufshcd_transfer_req_compl()
  scsi: ufs: Remove a local variable
  scsi: ufs: Fix a race in the completion path
  scsi: ufs: Use the doorbell register instead of the UTRLCNR register
  scsi: ufs: Fix the SCSI abort handler
  scsi: ufs: Request sense data asynchronously
  scsi: ufs: Synchronize SCSI and UFS error handling
  scsi: ufs: Retry aborted SCSI commands instead of completing these
    successfully
  scsi: ufs: Add fault injection support

 drivers/scsi/scsi_lib.c                |   2 +-
 drivers/scsi/ufs/Kconfig               |   7 +
 drivers/scsi/ufs/Makefile              |   1 +
 drivers/scsi/ufs/cdns-pltfrm.c         |   7 +-
 drivers/scsi/ufs/tc-dwc-g210-pci.c     |  32 +-
 drivers/scsi/ufs/tc-dwc-g210-pltfrm.c  |   7 +-
 drivers/scsi/ufs/ufs-exynos.c          |   7 +-
 drivers/scsi/ufs/ufs-fault-injection.c |  67 ++++
 drivers/scsi/ufs/ufs-fault-injection.h |  24 ++
 drivers/scsi/ufs/ufs-hisi.c            |   7 +-
 drivers/scsi/ufs/ufs-mediatek.c        |   7 +-
 drivers/scsi/ufs/ufs-qcom.c            |   7 +-
 drivers/scsi/ufs/ufshcd-pci.c          |  48 +--
 drivers/scsi/ufs/ufshcd-pltfrm.c       |  47 ---
 drivers/scsi/ufs/ufshcd-pltfrm.h       |  18 -
 drivers/scsi/ufs/ufshcd.c              | 485 +++++++++++--------------
 drivers/scsi/ufs/ufshcd.h              |  48 ++-
 17 files changed, 370 insertions(+), 451 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufs-fault-injection.c
 create mode 100644 drivers/scsi/ufs/ufs-fault-injection.h

