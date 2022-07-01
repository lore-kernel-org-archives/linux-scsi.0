Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FB0C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 21:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiGAVO7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 17:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiGAVO7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 17:14:59 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BCA3DA7E
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 14:14:57 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id ay10so1354185qtb.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2022 14:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ew/+jasX/Loy24RmMwTkDSPHJgaUJOxgvbngVmTJks8=;
        b=GAQPukLRzLX5KqjJGVtHnfE6+NCkfpnOMwTz8mp5TexNGsqg3Pe1HmJdBmlJ5BsdBq
         e11dz5NHaT7ppQ52JjjbxLAfknuBdCRDFsBkQi1XRABwbIaGKoo8qrnXdg2NkoI+im/4
         pAoQXfoRNBGL3tX1UmP8b2Wf2Nbb9XNHSepCw7zRQAFXKlwnFULA4/I+McLZNdaBPPte
         YYkzxuTZUJ+te/Q7FvTaBQ5EjkuxOFTQrffF5tMYwJTgnATaIMCN+HXVt8Oh+oB4v8Bh
         0Cz9cPYpDxUj1up2TYIViyRM6u9FL9fvOwUnc8A8nt6xMISNkIjv5HalxLgG5vXvZwWx
         jfOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ew/+jasX/Loy24RmMwTkDSPHJgaUJOxgvbngVmTJks8=;
        b=2iny+STWrvVpCK9AC9OwHt77HEe/z0AER07bdHGVxsP7JLiwt7O+3A4l2GPs9yb7mJ
         WTOVJ6/9mh3Y6xcIEvPKQwxUN7Nrwmvi9p3PWfF8+gU0ECCybRX6KFuuZdM0ExlQwqTJ
         IhbwEiCJquYLXYS25zKftY1QSMGUjSfuE0sg0Q5DAqwgvcqw6rnplOgeDq66ZvExa6Gu
         ajbvfcMOjrCxTo0xp3/cJBK4l2ZNBaWRbZ5ssIq1NuirjljoS2VV0ro6tC7AF1zs1Bhx
         6epBN2IihTtgI7O0AWm+dlcpHqMwRgkq3N9kXglCq6YemRXfcSvNo+8FY/VldApZnJpK
         z8UA==
X-Gm-Message-State: AJIora9RjckcMb/z0zuGt6NxbugxinAAy2sL9RfZ8cVoJtOBkc/AKM9d
        SP5U5xxqEo3bKP8Vtxz5ZJaB/7W4Eho=
X-Google-Smtp-Source: AGRyM1uLC4bSqET1UgdQmgeVYWu/hg0ir+I+ltEx1MKItOWqx1BYAj7HrQV8erdnva+gE/zrDKArvQ==
X-Received: by 2002:a05:6214:5284:b0:444:10c8:ee59 with SMTP id kj4-20020a056214528400b0044410c8ee59mr18372838qvb.68.1656710096695;
        Fri, 01 Jul 2022 14:14:56 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g6-20020ac842c6000000b00317ccc66971sm14584509qtm.52.2022.07.01.14.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 14:14:55 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.5
Date:   Fri,  1 Jul 2022 14:14:13 -0700
Message-Id: <20220701211425.2708-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.5

This patch set contains mainly fixes.

The patches were cut against Martin's 5.20/scsi-queue tree with patches
for 14.2.0.4 (9 patches in 5.19/scsi-fixes) applied prior.

James Smart (12):
  lpfc: Fix uninitialized cqe field in lpfc_nvme_cancel_iocb
  lpfc: Prevent buffer overflow crashes in debugfs with malformed user
    input
  lpfc: Set PU field when providing D_ID in XMIT_ELS_RSP64_CX iocb
  lpfc: Remove extra atomic_inc on cmd_pending in queuecommand after
    VMID
  lpfc: Fix possible memory leak when failing to issue CMF WQE
  lpfc: Fix attempted FA-PWWN usage after feature disable
  lpfc: Fix lost NVME paths during LIF bounce stress test
  lpfc: Revert RSCN_MEMENTO workaround for misbehaved configuration
  lpfc: Refactor lpfc_nvmet_prep_abort_wqe into lpfc_sli_prep_abort_xri
  lpfc: Remove Menlo/Hornet related code
  lpfc: Update lpfc version to 14.2.0.5
  lpfc: Copyright updates for 14.2.0.5 patches

 drivers/scsi/lpfc/lpfc.h         |  11 +-
 drivers/scsi/lpfc/lpfc_attr.c    |  27 +--
 drivers/scsi/lpfc/lpfc_bsg.c     | 324 -------------------------------
 drivers/scsi/lpfc/lpfc_bsg.h     |  14 +-
 drivers/scsi/lpfc/lpfc_crtn.h    |   2 +-
 drivers/scsi/lpfc/lpfc_debugfs.c |  22 +--
 drivers/scsi/lpfc/lpfc_els.c     |  32 +--
 drivers/scsi/lpfc/lpfc_hbadisc.c |  60 +-----
 drivers/scsi/lpfc/lpfc_hw.h      |  10 -
 drivers/scsi/lpfc/lpfc_hw4.h     |   1 -
 drivers/scsi/lpfc/lpfc_ids.h     |   4 +-
 drivers/scsi/lpfc/lpfc_init.c    |  19 +-
 drivers/scsi/lpfc/lpfc_nvme.c    |   1 +
 drivers/scsi/lpfc/lpfc_nvmet.c   |  48 +----
 drivers/scsi/lpfc/lpfc_scsi.c    |   1 -
 drivers/scsi/lpfc/lpfc_sli.c     |  38 ++--
 drivers/scsi/lpfc/lpfc_sli.h     |   1 -
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 18 files changed, 66 insertions(+), 551 deletions(-)

-- 
2.26.2

