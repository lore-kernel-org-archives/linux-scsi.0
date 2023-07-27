Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF76CEB64DD
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Jul 2023 19:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbjG0TpO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Jul 2023 15:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjG0TpN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Jul 2023 15:45:13 -0400
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E90B273C
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:45:13 -0700 (PDT)
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-686f19b6dd2so840781b3a.2
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jul 2023 12:45:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690487112; x=1691091912;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BiH6SlBtoEhlvJZjomUKZ5l8P6twIo8R31C1dJ+Y5Io=;
        b=dWuncyPU1+JoAhX7uEDgHYmIWA8i/uBsyPGMvYRX6gvzVtOymik12xWKcwQ7SztiXX
         xkuMNnC/4jMEva2YLNXdSbD8m2rpgb0uDeG6xv7gqBAgwyi1Q3HpH2gB2yt4s9HgANtI
         6StjnyuAxrJm1hK6w/q5OBIMBdZd4qlnvQY4IvPiXDwJNFu9YdR/fB3RImvCY8fnPL6z
         nDWkrKZku1rXVhzhI8rywzPLwgcY6Fd32UDgT2gEsxucKFeRd0ryP+uPvoPwOPrvPT45
         h6bKVERO3O4SBjlSbTh0FJsmRPjL8vHseErusF41R77EUrFejmBVgYwyS1g5yCtljAoG
         kUkw==
X-Gm-Message-State: ABy/qLZJhXIuE9n2ZT9zPCgVsEW1OjUPcma0yh4pn9n0EqF/GyKxgWpD
        wWEE9zT9SjR1rRwlvcegRszrZUNUHzc=
X-Google-Smtp-Source: APBJJlFJ2dB/+eqhFfI//+J09FfqgYuPAgCoDuLU8gPmVo+bfIwKYTY2hS37od/0zHoJg7UqycSZng==
X-Received: by 2002:a05:6a00:198d:b0:67a:9208:87a with SMTP id d13-20020a056a00198d00b0067a9208087amr95456pfl.23.1690487112342;
        Thu, 27 Jul 2023 12:45:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:607:27ba:91cb:68ee])
        by smtp.gmail.com with ESMTPSA id 35-20020a630b23000000b00551df489590sm1879203pgl.12.2023.07.27.12.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jul 2023 12:45:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 00/12] Multiple cleanup patches for the UFS driver
Date:   Thu, 27 Jul 2023 12:41:12 -0700
Message-ID: <20230727194457.3152309-1-bvanassche@acm.org>
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

Changes compared to v1:
 - Introduced a name for the data direction enumeration type.
 - Instead of introducing struct utp_upiu_hdr as an alias for struct
   utp_upiu_header, introduce a union in the latter data structure.

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
 drivers/ufs/core/ufshcd.c          | 529 +++++++++++++++--------------
 drivers/ufs/host/cdns-pltfrm.c     |  27 +-
 drivers/ufs/host/tc-dwc-g210-pci.c |   2 +-
 drivers/ufs/host/tc-dwc-g210.c     |  32 +-
 drivers/ufs/host/ufs-mediatek.c    |   6 +-
 drivers/ufs/host/ufs-qcom.c        |   8 +-
 drivers/ufs/host/ufshcd-dwc.c      |  22 +-
 drivers/ufs/host/ufshcd-pci.c      |   2 +-
 drivers/ufs/host/ufshcd-pltfrm.c   |   6 +-
 include/uapi/scsi/scsi_bsg_ufs.h   |  52 ++-
 include/ufs/ufs.h                  |  47 +--
 include/ufs/ufshcd.h               |  26 +-
 include/ufs/ufshci.h               |  53 ++-
 18 files changed, 460 insertions(+), 398 deletions(-)

