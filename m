Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B23BC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C3661025
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 01:32:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbhDLBcR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Apr 2021 21:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236548AbhDLBcR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Apr 2021 21:32:17 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D18C061574
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:00 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id z16so8154594pga.1
        for <linux-scsi@vger.kernel.org>; Sun, 11 Apr 2021 18:32:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uDVYP+td5XfXpgELl3AjKKZtCAeYi9s7kGdxM31Pipk=;
        b=WQGmQjDkFLY3de0YaJNoms2VIKRnQM1VArS8GqSwTjg+6xj7hElio9niI+J46NGkci
         tHGqby4vPkqEC6KCeJ8JF+ZTiU6n13eO0TSXqKrZipGQUYaZX/MXfdJdhl9F/E+Kvi+c
         Yx0mbdR2thKtllt9v8DithSGnRrldyQ9WTLkURXiDwPzQBRHe879CwZhO5HMe0+0g0Fr
         hV9ke0wLJNXGeq59z0sLidYoYomMqwrbJknu3fFW7NUp3UJBHa5eLkH1nCbO7UnOZ5xR
         FWs/p0Ytb8kTc3jU8FsAj2mnYcmij0u8vAjP+7yYS2oaI9x1WWaZWPqNCvZlR/IFOrYl
         QNKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uDVYP+td5XfXpgELl3AjKKZtCAeYi9s7kGdxM31Pipk=;
        b=gFhJkIDCT/M8yi5q5LbMzXDG7fMAoF3FeBMzRkBbhiHyr/StHO7xfhSTPl+/Yj/7kj
         RTnmLtE9GA0mZtbVT3+trMR8QOd9bfyYRHVj8h3r62k14tTB9uGf5oT7IN2r1yqrS9Zc
         HD1rL3PaekneVNtYGkMCGas3AEWDEGH0eRR1JTW/enEcF/EHQs5DpvZGge5tb6HoVPDz
         BKFrbxdBWDt8YSoGY5wJCYtzzFNEEiYhXk7rtUN2yzTrPe92D7Ocdjv3zmpgUiB9KhRT
         3ub/UBnTEldChO3gNeludHFCxT8h1Ko3kclHf5YgMiJ+94iqfiK4rCm/8OMNekNZdqVx
         kAyw==
X-Gm-Message-State: AOAM530pJarjMk9VC5XqhzS2a3EwkkD89ccS3Do6s1QFhu4K4vEnJacK
        3gEvl+aGMGxMUQUtdaZMUHCbx+1NyOU=
X-Google-Smtp-Source: ABdhPJwNj2XmzpU3GSWMxed1DoOhXpcd0yNTv9R1RdGqov48I1yKgeyvKiwf5hk8RzAr2bEP1/Z6oQ==
X-Received: by 2002:a62:874e:0:b029:244:4080:8c7a with SMTP id i75-20020a62874e0000b029024440808c7amr18194167pfe.54.1618191119904;
        Sun, 11 Apr 2021 18:31:59 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id i17sm8153163pfd.84.2021.04.11.18.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 18:31:59 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 00/16] lpfc: Update lpfc to revision 12.8.0.9
Date:   Sun, 11 Apr 2021 18:31:11 -0700
Message-Id: <20210412013127.2387-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.9

This patch set contains fixes and a cleanup patches.

The patches were cut against Martin's 5.13/scsi-queue tree

V2:
 Reworked patch 3, Fix reference countiner errors in
  lpfc_cmpl_els_rsp(), for kernel checkers warning on ls_rjt set but
  not used.

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
 drivers/scsi/lpfc/lpfc_els.c       | 114 +++++--------------
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
 15 files changed, 233 insertions(+), 575 deletions(-)

-- 
2.26.2

