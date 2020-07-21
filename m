Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681C2C433E8
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4212820720
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:44:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cq2Bp7+9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgGUQlz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728281AbgGUQly (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:41:54 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE14C0619DA
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:41:54 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o2so3548970wmh.2
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jrvp4Bz5UjZdR7iMsUpWTUDT01MaTtGC3shuBGmqGX4=;
        b=cq2Bp7+9rqaPiy5mR4WAheJe9dB5/w6mx7Ww01A0+6be4T9ijK1oakrf2zcNFuIgKv
         SGcsaq/jIhei8ZKPDj63Sq6wfNxVIKPgjKh7ktng3nRGkYUxBL2SmBwZshlZ192ukxc0
         Gd4oShMtvs0zcXOjRWQ7JlP77WgeYU45Q0+/mzTb4s03m8SHNHpDAhKIitVTPr1fYDCa
         uQs1XqOm1uVPvZP0co5dWrGEUBenKzzZ8rdfPuSbTe/Zwc3nJtTpI9hcA6ImQyX6HAGt
         ZxOeGQFTh06eDbDffF8O38AFZDaSN5NVSXFSQJ/+MYNK6zUdX4hBx8lhLVJu6UFvMKVh
         FkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jrvp4Bz5UjZdR7iMsUpWTUDT01MaTtGC3shuBGmqGX4=;
        b=egG807Tm8cWfJyTAR0LvCmec/+BhZkLBkC87xu5BXpwNTJlRnTRKmf8C1RiAY+vqbH
         D2ChgxZyll2zr/767orR/pAP+FaMpCCPejXIBsiqP8QO++iM1EJarlsr7Cpzf0qeXHHn
         5zs4E352AcFLWQBTL4FhwMBsdxhJtxSVn5rj+ZicB+gklv8dYow0mC8qQzgmrS9ikdct
         FiGt+w7L6vMqJfWrnCZ2/InpjDXLYA8qhy8I9UiMam1VYbp7trDQlQGe8Nx4kqYB7VmS
         2p66K3Z9/S1f7+6k3x7ekhOeWP9Uill5wrB4cWIv8rISKKyVTPd3QpocDKR1b1w4rZQG
         lpdQ==
X-Gm-Message-State: AOAM532+ggfamOdhlMGO84/nEqT3QcjHORlwnh0smgHaj9TrfLLG61Ee
        JFNcspKgdijR/OwHdUsq1Qf+NQ==
X-Google-Smtp-Source: ABdhPJwqpB/xgGKxh9mMbx2FeeMx09BX/Qf45xrz0kDMEwlxCTngZxpLp0rmn72u1p2sEJK03SeATA==
X-Received: by 2002:a1c:3504:: with SMTP id c4mr4795113wma.177.1595349712779;
        Tue, 21 Jul 2020 09:41:52 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.41.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:41:52 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 00/40] Set 4: Next set of SCSI related W=1 warnings
Date:   Tue, 21 Jul 2020 17:41:08 +0100
Message-Id: <20200721164148.2617584-1-lee.jones@linaro.org>
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

This brings the total of W=1 SCSI wanings from 1690 in v5.8-rc1 to 817.

Lee Jones (40):
  scsi: arcmsr: arcmsr_hba: Remove statement with no effect
  scsi: aic7xxx: aic79xx_core: Remove a bunch of unused variables
  scsi: aacraid: sa: Add descriptions for missing parameters
  scsi: aacraid: rkt: Add missing description for 'dev'
  scsi: aacraid: nark: Add missing description for 'dev'
  scsi: aic94xx: aic94xx_dev: Fix a couple of kerneldoc formatting
    issues
  scsi: aacraid: src: Add descriptions for missing parameters
  scsi: aic94xx: aic94xx_tmf: Fix kerneldoc formatting issue with 'task'
  scsi: pm8001: pm8001_sas: Fix strncpy() warning
  scsi: pm8001: pm8001_sas: Mover function header and supply some
    missing parameter descriptions
  scsi: pm8001: pm8001_ctl: Add descriptions for unused 'attr' function
    parameters
  scsi: qla4xxx: ql4_init: Remove set but unused variable 'func_number'
  scsi: qla4xxx: ql4_init: Check return value of pci_set_mwi()
  scsi: qla4xxx: ql4_83xx: Move 'qla4_83xx_reg_tbl' from shared header
  scsi: aic7xxx: aic79xx_core: Remove set but unused variables
    'targ_info' and 'value'
  scsi: pm8001: pm8001_hwi: Fix a bunch of kerneldoc issues
  scsi: pm8001: pm80xx_hwi: Fix some function documentation issues
  scsi: pm8001: pm8001_hwi: Remove a bunch of set but unused variables
  scsi: qla4xxx: ql4_nx: Move 'qla4_82xx_reg_tbl' to the only place its
    used
  scsi: lpfc: lpfc_sli: Remove unused variable 'pg_addr'
  scsi: qla4xxx: ql4_mbx: Fix-up incorrectly documented parameter
  scsi: qla4xxx: ql4_iocb: Fix incorrectly named function parameter
  scsi: lpfc: lpfc_sli: Fix-up around 120 documentation issues
  scsi: pm8001: pm8001_hwi: Remove unused variable 'value'
  scsi: pm8001: pm80xx_hwi: Staticify 'pm80xx_pci_mem_copy' and
    'mpi_set_phy_profile_req'
  scsi: qla4xxx: ql4_os: Fix some kerneldoc parameter documentation
    issues
  scsi: qla4xxx: ql4_isr: Repair function documentation headers
  scsi: lpfc: lpfc_mem: Provide description for lpfc_mem_alloc()'s
    'align' param
  scsi: qla4xxx: ql4_init: Document qla4xxx_process_ddb()'s 'conn_err'
  scsi: lpfc: lpfc_ct: Fix-up formatting/docrot where appropriate
  scsi: csiostor: csio_init: Fix misnamed function parameter
  scsi: qla4xxx: ql4_nx: Remove three set but unused variables
  scsi: qla4xxx: ql4_nx: Supply description for 'code'
  scsi: csiostor: csio_lnode: Demote kerneldoc that fails to meet the
    criteria
  scsi: bfa: bfad_bsg: Staticify all local functions
  scsi: lpfc: lpfc_sli: Ensure variable has the same stipulations as
    code using it
  scsi: sym53c8xx_2: sym_glue: Add missing description for 'pdev'
  scsi: sym53c8xx_2: sym_hipd: Ensure variable has the same stipulations
    as code using it
  scsi: mvsas: mv_init: Move 'core_nr' inside #ifdef and remove unused
    variable 'res_flag'
  scsi: cxgbi: cxgb3i: cxgb3i: Remove bad documentation and demote
    kerneldoc header

 drivers/scsi/aacraid/nark.c         |   1 +
 drivers/scsi/aacraid/rkt.c          |   5 +-
 drivers/scsi/aacraid/sa.c           |  19 ++-
 drivers/scsi/aacraid/src.c          |  13 +-
 drivers/scsi/aic7xxx/aic79xx_core.c |  20 +--
 drivers/scsi/aic94xx/aic94xx_dev.c  |   4 +-
 drivers/scsi/aic94xx/aic94xx_tmf.c  |   2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c    |   3 -
 drivers/scsi/bfa/bfad_bsg.c         | 222 ++++++++++++++--------------
 drivers/scsi/csiostor/csio_init.c   |   2 +-
 drivers/scsi/csiostor/csio_lnode.c  |   3 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c  |  13 +-
 drivers/scsi/lpfc/lpfc_ct.c         |  10 +-
 drivers/scsi/lpfc/lpfc_mem.c        |   1 +
 drivers/scsi/lpfc/lpfc_sli.c        | 125 ++++++++++------
 drivers/scsi/mvsas/mv_init.c        |   9 +-
 drivers/scsi/pm8001/pm8001_ctl.c    |   9 +-
 drivers/scsi/pm8001/pm8001_hwi.c    |  30 ++--
 drivers/scsi/pm8001/pm8001_sas.c    |  11 +-
 drivers/scsi/pm8001/pm80xx_hwi.c    |  23 +--
 drivers/scsi/qla4xxx/ql4_83xx.h     |  17 ---
 drivers/scsi/qla4xxx/ql4_init.c     |   6 +-
 drivers/scsi/qla4xxx/ql4_iocb.c     |   2 +-
 drivers/scsi/qla4xxx/ql4_isr.c      |   6 +-
 drivers/scsi/qla4xxx/ql4_mbx.c      |   7 +-
 drivers/scsi/qla4xxx/ql4_nx.c       |  18 +--
 drivers/scsi/qla4xxx/ql4_nx.h       |  17 ---
 drivers/scsi/qla4xxx/ql4_os.c       |  58 ++++++--
 drivers/scsi/sym53c8xx_2/sym_glue.c |   1 +
 drivers/scsi/sym53c8xx_2/sym_hipd.c |   8 +
 30 files changed, 354 insertions(+), 311 deletions(-)

-- 
2.25.1

