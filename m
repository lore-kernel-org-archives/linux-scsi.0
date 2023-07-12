Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C46C0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 17:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232483AbjGLRxa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 13:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232608AbjGLRx0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 13:53:26 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E6C1FEC
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:25 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6831a5caf75so352706b3a.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 10:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689184405; x=1689789205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4R5kntMNRgQH2/cacym4g8T87QV8GMcUpokhxZmznwM=;
        b=pWHiLX5aUgWA8+6x4cMbjElqgM4XFUqL7Rlbwhctnh+kJPudRE/oIT3HQIAMzMbojN
         I9REPltVI77p9fI6wb4Eie7sOWWL2HY+o7ikThPtGsjl0wY4S8DjwAivghr4LLLlgIJz
         5jpxQ2D8tuV7BKQKrKRRiUvu6DkMF+/bdR1QfSOsrw6/FxxIx22RESonuzz5l/y7QDXL
         5liVFQCpZ3l7KudVLJg3y8+OMzbiI1ycLSt8l/vRhlUjn0N5E+7AX8MEAbXUWwHbPpKx
         ISNkQPxpeUPt8qalzC5pD7SgP0Y/zZrmbteft3OEd4les2X25+lmhBxW/FE0rBLhL7Ja
         cc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689184405; x=1689789205;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4R5kntMNRgQH2/cacym4g8T87QV8GMcUpokhxZmznwM=;
        b=iSFtmQxvvO9w8hLoiH88bdAwXopLtC5Hp3a2LBTHpRAJH5drZoA5u6kPoBlCLomkN6
         CrnX3y4yetc3fUiqjkzaAAyg5eDK26OGEem10/45csH/61qCPtneG1OqTCEtQ8iNZWKH
         6zSwV9qrcFAPEzzdfppcE9keDL0DvoLYWgUz8qaVdweTbbMCTfhlw9AaeN8D01YKOK1V
         AMlY+gtVhImIeNWjGHhOT8tXVgMgOXLLHMPkppuy0hGxidmkX4F3kv5akYqp4Ji1EpQc
         uznF4zbaMwVvlkB4pkkwOCxShQiW1pAJDit6s9kxv7a4AhSYnGtHOcaRdj8aKRuCA7fc
         V8Gg==
X-Gm-Message-State: ABy/qLb3XOpsZxJzhaIUNrOGdjs88n18AP/SlenXCPLCapMi9W0ZFtZt
        pmN4Vgs7ALzTa43m+L+mmZkfLMcFNCM=
X-Google-Smtp-Source: APBJJlE2f0yhHLAwLb/K4fLrXYckKzfKnB5ZppbhcV/qj9p+IyFE6U8d6BtTs4Mrz0+sZXeT0m9wNw==
X-Received: by 2002:a17:903:22ca:b0:1b8:b0c4:2e3d with SMTP id y10-20020a17090322ca00b001b8b0c42e3dmr80233plg.4.1689184404684;
        Wed, 12 Jul 2023 10:53:24 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902b70b00b001b898595be7sm4218459pls.291.2023.07.12.10.53.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jul 2023 10:53:24 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.14
Date:   Wed, 12 Jul 2023 11:05:10 -0700
Message-Id: <20230712180522.112722-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.14

This patch set contains logging improvements, kref handling fixes,
discovery bug fixes, and refactoring of repeated code.

The patches were cut against Martin's 6.6/scsi-queue tree.

Justin Tee (12):
  lpfc: Pull out fw diagnostic dump log message from driver's trace
    buffer
  lpfc: Simplify fcp_abort transport callback log message
  lpfc: Remove extra ndlp kref decrement in FLOGI cmpl for loop topology
  lpfc: Qualify ndlp discovery state when processing RSCN
  lpfc: Revise ndlp kref handling for dev_loss_tmo_callbk and
    lpfc_drop_node
  lpfc: Set Establish Image Pair service parameter only for Target
    Functions
  lpfc: Make fabric zone discovery more robust when handling unsolicited
    LOGO
  lpfc: Abort outstanding ELS cmds when mailbox timeout error is
    detected
  lpfc: Refactor cpu affinity assignment paths
  lpfc: Clean up SLI-4 sysfs resource reporting
  lpfc: Update lpfc version to 14.2.0.14
  lpfc: Copyright updates for 14.2.0.14 patches

 drivers/scsi/lpfc/lpfc.h           |  20 +++++
 drivers/scsi/lpfc/lpfc_attr.c      | 136 +++++++++++++++++++++--------
 drivers/scsi/lpfc/lpfc_ct.c        |  20 +++--
 drivers/scsi/lpfc/lpfc_els.c       |  58 ++++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  77 ++++++++++------
 drivers/scsi/lpfc/lpfc_hw.h        |   2 +
 drivers/scsi/lpfc/lpfc_init.c      |  53 ++++++-----
 drivers/scsi/lpfc/lpfc_nportdisc.c |  94 +++++++++++---------
 drivers/scsi/lpfc/lpfc_nvme.c      |  16 ++--
 drivers/scsi/lpfc/lpfc_nvmet.c     |   5 +-
 drivers/scsi/lpfc/lpfc_sli.c       |   8 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 12 files changed, 324 insertions(+), 167 deletions(-)

-- 
2.38.0

