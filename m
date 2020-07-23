Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC2CC433EC
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5DBD206D7
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:27:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IxVfFjzc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728693AbgGWMYv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728665AbgGWMYv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:24:51 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2383C0619E2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:24:50 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id c80so4794507wme.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BPw5bYTRkWKKW36iChvzFRop+ogNWWiA3XJP8U5i27Y=;
        b=IxVfFjzc90ZE0V7MFR8NfaEYB9JHKcZIMZdbKq4KLTagYPrOG1mlQC3gxGvqi0Yj6r
         fbyoyqlMiyOrbVtvGp3v06QOhZDmHOofagIqc55BgP3lzMa5kIyWCipigINpEtv4CCZF
         fZOC8tZ5rUKQ6MkyTl+MPCWNYwWASf1r1dhlMAXvu+rDxJLozKY90z6ENo6uFZabB3CN
         X3Fbh3R7xgEz9Gh/3JpDiB44LnZeQ+O44/hYgdFXtyNTw7erLm9KUGDeW1N1/KLe9T9c
         wcafyoStGp+tCwJo5X52iPPhoBK11cOZHeqcIIW/mstNyPsAjxzGL+USrF3YRz/AMO09
         S5+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BPw5bYTRkWKKW36iChvzFRop+ogNWWiA3XJP8U5i27Y=;
        b=tNZQOTSeYezcFob1k1RSR9doIsQx9y164+E6KBKkCgC6hN3ZZ0NoarK2WgVdciWb0F
         qMte+8oFnq0TuyYgU7fPFPxwe7cOd+VlfG173F5JKzrOzN3NJFx76Nf2Gv1aHVvUoOKF
         VNwxm9AG1HzuG2gdg9xt9JlG8O5pUcJ7hIwFjBWcKxNvS0OPN1tdInp0djN7Vkj6HVLX
         s+z0wkx8LMNTVFHn6wU+0WG27skXaP0D2XOXS9slcTNT2JQTqO6HXOKJfz0wCPtzqlGS
         KNN9UqGuhonzxFrL2rsjPELAdyPBKZvZzwBua7NY4mvVZ7r41l3/sD09LwzYN6PXBra0
         egGQ==
X-Gm-Message-State: AOAM531ESPn1SI+HSm6/nlKqIOsdrd9pwVcuOB0OCM/pkHOEpnj6E0PB
        Gqingw4RvN+lVJp1ZDwIZmhtGA==
X-Google-Smtp-Source: ABdhPJyi2akDr13wv4WdZAQ8D0TzOORRcG3bV+ePeDoJcjJciQPgzzjLm1w3nJubU/pr8wMYeguX3A==
X-Received: by 2002:a7b:c054:: with SMTP id u20mr3899527wmc.2.1595507089612;
        Thu, 23 Jul 2020 05:24:49 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:24:48 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 00/40] Set 5: Penultimate set of SCSI related W=1 warnings
Date:   Thu, 23 Jul 2020 13:24:06 +0100
Message-Id: <20200723122446.1329773-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

Hopefully this is the penultimate set.

Lee Jones (40):
  scsi: lpfc: lpfc_els: Fix some function parameter descriptions
  scsi: lpfc: lpfc_hbadisc: Fix kerneldoc parameter
    formatting/misnaming/missing issues
  scsi: ufs: ufs-qcom: Demote nonconformant kerneldoc headers
  scsi: bnx2i: bnx2i_init: Fix parameter misnaming in function header
  scsi: ufs: ufs-exynos: Make stubs 'static inline'
  scsi: ufs: ufs-exynos: Demote seemingly unintentional kerneldoc header
  scsi: bfa: bfa_port: Staticify local functions
  scsi: bnx2i: bnx2i_sysfs: Add missing descriptions for 'attr'
    parameter
  scsi: bfa: bfa_fcpim: Remove set but unused variable 'rp'
  scsi: bfa: bfa_fcpim: Demote seemingly unintentional kerneldoc header
  scsi: qedi: qedi_main: Remove 2 set but unused variables
  scsi: ips: Remove some set but unused variables
  scsi: ips: Convert strnlen() to memcpy() since result should not be
    NUL terminated
  scsi: qla4xxx: ql4_83xx: Remove set but unused variable 'status'
  scsi: lpfc: lpfc_init: Use __printf() format notation
  scsi: lpfc: lpfc_init: Add and rename a whole bunch of function
    parameter descriptions
  scsi: qla4xxx: ql4_bsg: Rename function parameter descriptions
  scsi: lpfc: lpfc_mbox: Fix a bunch of kerneldoc misdemeanours
  scsi: lpfc: lpfc_nportdisc: Add description for lpfc_release_rpi()'s
    'ndlpl param
  scsi: bfa: bfa_ioc: Remove a few unused variables 'pgoff' and 't'
  scsi: csiostor: csio_hw: Mark known unused variable as __always_unused
  scsi: csiostor: csio_hw_t5: Remove 2 unused variables
    {mc,edc}_bist_status_rdata_reg
  scsi: bfa: bfa_ioc: Staticify non-external functions
  scsi: csiostor: csio_rnode: Add missing description for
    csio_rnode_fwevt_handler()'s 'fwevt' param
  scsi: bfa: bfa_ioc_ct: Demote non-compliant kerneldoc headers to
    standard comments
  scsi: mvsas: mv_init: Place 'core_nr' inside correct clause
  scsi: bfa: bfa_fcs_rport: Remove unused variable 'adisc'
  scsi: bnx2i: bnx2i_hwi: Fix a whole host of kerneldoc issues
  scsi: bnx2i: bnx2i_iscsi: Add, remove and edit some function parameter
    descriptions
  scsi: be2iscsi: be_iscsi: Correct misdocumentation of function param
    'ep'
  scsi: qedi: qedi_fw: Remove set but unused variable 'tmp'
  scsi: esas2r: esas2r: Add braces around the one-line if()
  scsi: bfa: bfa_ioc: Demote non-kerneldoc headers down to standard
    comment blocks
  scsi: bfa: bfa_core: Demote seemingly unintentional kerneldoc header
  scsi: bfa: bfa_svc: Demote seemingly unintentional kerneldoc header
  scsi: qedi: qedi_main: Demote seemingly unintentional kerneldoc header
  scsi: qedi: qedi_iscsi: Staticify non-external function
    'qedi_get_iscsi_error'
  scsi: bfa: bfa_ioc: Ensure a blank line precedes next function/header
  scsi: bnx2i: bnx2i_iscsi: Add parameter description and rename another
  scsi: esas2r: esas2r_log: Demote a few non-conformant kerneldoc
    headers

 drivers/scsi/be2iscsi/be_iscsi.c   |  2 +-
 drivers/scsi/bfa/bfa_core.c        |  2 +-
 drivers/scsi/bfa/bfa_fcpim.c       | 10 ++----
 drivers/scsi/bfa/bfa_fcs_rport.c   |  3 --
 drivers/scsi/bfa/bfa_ioc.c         | 57 +++++++++++++-----------------
 drivers/scsi/bfa/bfa_ioc_ct.c      |  6 ++--
 drivers/scsi/bfa/bfa_port.c        |  4 +--
 drivers/scsi/bfa/bfa_svc.c         |  4 +--
 drivers/scsi/bnx2i/bnx2i_hwi.c     | 53 +++++++++++++--------------
 drivers/scsi/bnx2i/bnx2i_init.c    |  2 +-
 drivers/scsi/bnx2i/bnx2i_iscsi.c   | 19 +++++-----
 drivers/scsi/bnx2i/bnx2i_sysfs.c   |  4 +++
 drivers/scsi/csiostor/csio_hw.c    |  2 +-
 drivers/scsi/csiostor/csio_hw_t5.c |  6 ++--
 drivers/scsi/csiostor/csio_rnode.c |  2 +-
 drivers/scsi/esas2r/esas2r.h       |  3 +-
 drivers/scsi/esas2r/esas2r_log.c   | 10 +++---
 drivers/scsi/ips.c                 | 34 +++++++-----------
 drivers/scsi/lpfc/lpfc_els.c       | 12 +++----
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 15 ++++----
 drivers/scsi/lpfc/lpfc_init.c      | 46 +++++++++++++-----------
 drivers/scsi/lpfc/lpfc_mbox.c      | 12 ++++---
 drivers/scsi/lpfc/lpfc_nportdisc.c |  1 +
 drivers/scsi/mvsas/mv_init.c       |  1 -
 drivers/scsi/qedi/qedi_fw.c        |  5 ++-
 drivers/scsi/qedi/qedi_iscsi.c     |  2 +-
 drivers/scsi/qedi/qedi_main.c      |  9 ++---
 drivers/scsi/qla4xxx/ql4_83xx.c    | 34 +++++++-----------
 drivers/scsi/qla4xxx/ql4_bsg.c     |  4 +--
 drivers/scsi/ufs/ufs-exynos.c      |  2 +-
 drivers/scsi/ufs/ufs-exynos.h      | 12 +++----
 drivers/scsi/ufs/ufs-qcom.c        |  6 ++--
 32 files changed, 178 insertions(+), 206 deletions(-)

-- 
2.25.1

