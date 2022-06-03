Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940ADC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 17:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345023AbiFCRqq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 13:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344979AbiFCRqf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 13:46:35 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3ADB56C1C
        for <linux-scsi@vger.kernel.org>; Fri,  3 Jun 2022 10:43:35 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so7654625pjq.2
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jun 2022 10:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A3pLZceiFhY7C+/0FB3Q3bgAYsRGnCQOCGI4ilmzjtM=;
        b=DP5eBOl3FoHlc+733H6huD13cUhGni1y8NKE8kf1jTxhn3IVp0/REC0JRYY6UWlbZD
         tjFlxaeMUbF/Oz5qbkuAE0fz9xcObt2gfqDFaRtBeuRalb2L9lAmksJo0DcUeZKYOkLG
         IdQx11j00PRhrrt9WbJdbtgIWD+kYfDbVK/vGgnenznJKg69bCK/cGwgo+g0+jixc2gT
         iQfAq17JtA7jR5glwjXDQ7ASGKkBOj5RWVYhIwMREU5lB+vSwNr3D7BPnPeWQ1KmtF6G
         yJiZ4d7IEIQ+U5xYrxbfxPOeJvBZUhjs0rcS/b4CEQPCwESq4BgJMUAHAXYlE0NXpeLJ
         H/UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A3pLZceiFhY7C+/0FB3Q3bgAYsRGnCQOCGI4ilmzjtM=;
        b=U0kzPiUtnAlaGC9KVWPrAESJajtLNsJun4DGka5w1Q3JbnNPNEsWVW/m9nDXF6oImI
         Ci82n11rYFM8ynKzOkZKjH1ljyS24vIxA1KITrMa4BqL6BT4owfdk5mVX9r/2jWx7y2v
         R4SfRMQwAOsQ4JIMAX8wsix1FMyXcYLCWiCL/wuTkJScHLfVz1BFhAnWqrOOtD2GhO1t
         +akKnoSKx+t/K+slRHgFZfTg/Roj/c33dPG443uQ+krrotE8bWmvbiMt6pSiMB0HNgjM
         /8306CEilSVQA43w1a+kfMw4LPiUd7RBH95OfR/3nz76sZa+lJSjz/3CYirKzI9jxJEH
         P2bg==
X-Gm-Message-State: AOAM532fo2seCwPo+FPqD5cpe7QI2PmRnRyO9cRluyAgJ8lslSqq5KBC
        lOGLj6AC2b5rVCLNP4U0+zMbtvg9Hdw=
X-Google-Smtp-Source: ABdhPJw2CfjTXg279mxatLsD75bxkNDlvMlUwoKszwXzKAwUnlVxuqPXUH//e6qMCrt/qtTGHyoO8w==
X-Received: by 2002:a17:902:f690:b0:163:f8eb:3741 with SMTP id l16-20020a170902f69000b00163f8eb3741mr11143832plg.112.1654278215009;
        Fri, 03 Jun 2022 10:43:35 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902710d00b0015e8d4eb1d2sm5705047pll.28.2022.06.03.10.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 10:43:34 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/9] lpfc: Update lpfc to revision 14.2.0.4
Date:   Fri,  3 Jun 2022 10:43:20 -0700
Message-Id: <20220603174329.63777-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.4

This patch set contains mainly fixes. Also adds some additional logging
for NVMe command completions when errors, and enabling of nvme-fc flush
handling on async event cmds.

The patches were cut against Martin's 5.19/scsi-queue tree

James Smart (9):
  lpfc: Correct BDE type for XMIT_SEQ64_WQE in ct_reject_event
  lpfc: Resolve some cleanup issues following abort path refactoring
  lpfc: Resolve some cleanup issues following SLI path refactoring
  lpfc: Address null pointer dereference after starget_to_rport()
  lpfc: Resolve null ptr dereference after an ELS LOGO is aborted
  lpfc: Fix port stuck in bypassed state after lip in PT2PT topology
  lpfc: Add more logging of cmd and cqe information for aborted NVME
    cmds
  lpfc: Allow reduced polling rate for nvme_admin_async_event cmd
    completion
  lpfc: Update lpfc version to 14.2.0.4

 drivers/scsi/lpfc/lpfc_crtn.h      |  4 +--
 drivers/scsi/lpfc/lpfc_ct.c        |  2 +-
 drivers/scsi/lpfc/lpfc_els.c       | 21 ++++++------
 drivers/scsi/lpfc/lpfc_hw4.h       |  3 ++
 drivers/scsi/lpfc/lpfc_init.c      |  2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  3 +-
 drivers/scsi/lpfc/lpfc_nvme.c      | 52 +++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_scsi.c      |  6 ++++
 drivers/scsi/lpfc/lpfc_sli.c       | 25 +++++++-------
 drivers/scsi/lpfc/lpfc_version.h   |  2 +-
 10 files changed, 76 insertions(+), 44 deletions(-)

-- 
2.26.2

