Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6FFC433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE593611C1
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhDJRa7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:30:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234392AbhDJRa7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:30:59 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A2CC06138A
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:44 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h25so6182093pgm.3
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C/2ObtgVLI9UCLGkmghmalrYXdvGWHVJMrP37zBUge4=;
        b=Fn5MAAP3Pxw8n/rUwWUgTu14QGIr03S+O456bqD5Rg0XQv1ychpmj20DeHeSYceHpZ
         KvVaytppE1i3fLl2v9F9IuSNUmytQEgq1xljekSpEG7DmLs5lvjzSYOMdcW58WadSS13
         IuUxzEDiXql8B1/6ixmws99+7MFitm1M2iYkzgCrnOfJuSEDOYoECerL+jcG8xJJ9cf1
         8ZIJWrR9SJ9BnF9bfUCpHLyG70a3k9DSDZr24Jt0G6fLwmK6WaRxyiMPVfEfOTvLaMSk
         2jTzXcXEyqF+rw679a7DmIzYJGzLox63LA0s1g/Fnz6pXlq9BgDCpiG+zSGhppdYnj+d
         ESuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C/2ObtgVLI9UCLGkmghmalrYXdvGWHVJMrP37zBUge4=;
        b=DixjYHrsWZoY2zgrx5SSnH1CymdcuXUxa/hoEGTo0V40n1GqFaPCcPFy8sPbxNqCxa
         ggjGLL7fpJ1MNsPTvWcvSAlVAufIeyVGb23USciEHmh9gfQa4zsiM2wooaMcq8J3i8H2
         gnnq6VZpJ7q9EEcnBdVLSQ3wwXaqIjhkwhayX+unH+PEZcWTZNf2gGC0YOL5hTIZO3o3
         ER+h67YA25zRf15N+Mi1py0C4Qli5kg8nheyMcEjk+LaN8wwCZBqjphUa8qlWGmjDisV
         rNxm2GTky0CrSAmoheLw8JYI0mjvgsYAovjMPC+5kc33SFYbccmr2GefAaIRfl4+MD7i
         K9cw==
X-Gm-Message-State: AOAM532zzf8Uz7AcEsrMIQqDaPIdVzzw46+bwtjOsOobPhsUJwh95tK3
        zktLEzHjPBCFhp0rfyzX8+ZvYuprMyY=
X-Google-Smtp-Source: ABdhPJwJdp1WtKSEMhUV3JMFwlf05YkztbWPqcdemZA3Ut2MyOnifn+qQ9dV2LOHDtBoJ10PCF+t5g==
X-Received: by 2002:a05:6a00:174a:b029:1fc:d9ba:da96 with SMTP id j10-20020a056a00174ab02901fcd9bada96mr17840007pfc.40.1618075844231;
        Sat, 10 Apr 2021 10:30:44 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:44 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/16] lpfc: Update lpfc to revision 12.8.0.9
Date:   Sat, 10 Apr 2021 10:30:18 -0700
Message-Id: <20210410173034.67618-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.9

This patch set contains fixes and a cleanup patches.

The patches were cut against Martin's 5.13/scsi-queue tree

James Smart (16):
  lpfc: Fix rmmod crash due to bad ring pointers to abort_iotag
  lpfc: Fix crash when a REG_RPI mailbox fails triggering a LOGO
    response
  lpfc: Fix reference counting errors in lpfc_cmpl_els_rsp()
  lpfc: Fix NMI crash during rmmod due to circular hbalock dependency
  lpfc: Fix lack of device removal on port swaps with PRLIs
  lpfc: Fix error handling for mailboxes completed in MBX_POLL mode
  lpfc: Fix use-after-free on unused nodes after port swap
  lpfc: Fix silent memory allocation failure in
    lpfc_sli4_bsg_link_diag_test()
  lpfc: Fix missing FDMI registrations after Mgmt Svc login
  lpfc: Fix lpfc_hdw_queue attribute being ignored
  lpfc: Remove unsupported mbox PORT_CAPABILITIES logic
  lpfc: Fix various trivial errors in comments and log messages
  lpfc: Standardize discovery object logging format
  lpfc: Eliminate use of LPFC_DRIVER_NAME in lpfc_attr.c
  lpfc: Update lpfc version to 12.8.0.9
  lpfc: Copyright updates for 12.8.0.9 patches

 drivers/scsi/lpfc/lpfc_attr.c      | 120 ++++++++++++--------
 drivers/scsi/lpfc/lpfc_bsg.c       |  22 ++--
 drivers/scsi/lpfc/lpfc_crtn.h      |   7 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  32 +++---
 drivers/scsi/lpfc/lpfc_els.c       | 100 +++++-----------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  26 ++---
 drivers/scsi/lpfc/lpfc_hw4.h       | 176 +----------------------------
 drivers/scsi/lpfc/lpfc_init.c      | 140 +++--------------------
 drivers/scsi/lpfc/lpfc_mbox.c      |  38 +------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  10 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |  16 +--
 drivers/scsi/lpfc/lpfc_nvmet.c     |  26 ++---
 drivers/scsi/lpfc/lpfc_scsi.c      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  77 +++++++------
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 15 files changed, 233 insertions(+), 561 deletions(-)

-- 
2.26.2

