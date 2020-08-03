Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA275C433E3
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B591B22BED
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 21:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jW6uCCBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgHCVCn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 17:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728570AbgHCVCm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 17:02:42 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FAE8C06174A
        for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2020 14:02:42 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id q76so875256wme.4
        for <linux-scsi@vger.kernel.org>; Mon, 03 Aug 2020 14:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N2qWWGwD+Drs2TJqmfYyNTWmq03DsB7BtpeLXmXyHtg=;
        b=jW6uCCBLvEn/NvBDlCLVyZAFNim9bYqheLML0Tib7yN6+TO4ftAqSYAz7Ne3qBjp/G
         nBMej5EBpnRMAKu31FC53bDmTmk/OJ6LhVos+NpF8CwO4A9WYQbyAB+N1jdSunfvG5gZ
         VGNzBsleoTvaexkOekBzGW1TuRvFe5l0grFRnC/w2+Zy1GIvL3XZndmkg6FUg81tYehK
         gUgIqAI0819LqxFkeOaePt5znueQyf6FmLoxKAvdIMPUL04kppTaqrO5vCU44yPgivSE
         fFPUQ7nxXPWbnJp+rw6JxOKDXAl7eAUKqrxoOU5fWBVlQX4m897V/l8c5GdxLvb5aKZU
         E4zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N2qWWGwD+Drs2TJqmfYyNTWmq03DsB7BtpeLXmXyHtg=;
        b=IFY6cp7th60jLj1g1L6i/BgyTtrRX2724FqFxPR41sl6uEC6Uxej3ZxBbYZifEvqdt
         CbMySBk2Q/Xfcm3ntouzRojDCDXID80FGE6cWdfqc7TTJBtrJm/TN/b4pMkiTEau2Vir
         86gkJKAtWw++ShHDHzdvPFifTFZcznn50noFuWp2sj6tuC/1U14aK6qbFKVHP/AZvmik
         MDPTogHpigW50tnlUBJ74k+3GVaOgkS+hhE0GXfHGFuZWHtJdj0jQu0zB/t14fF24EWf
         Q+OWPjUxtlTTlJfV/RXS2EzKSvY0VTYLIGYMb3go+2933MeZhLHwo8L0MVq+FpN6xX4s
         jSgQ==
X-Gm-Message-State: AOAM530r7tqk01/c4itsan2fmvhPVwZTw3NyiKq/mzENBSIWAZ/fOp0r
        vfThRFFQVfyTZkNVPuckoa/wpRMV
X-Google-Smtp-Source: ABdhPJzc50Lsy621z1muKpUG6O3o61P/4pe3xuXlzGMGVWcq/9zHxqJT6U5sbRS5Ap+DJnegkPED6w==
X-Received: by 2002:a7b:c05a:: with SMTP id u26mr892665wmc.134.1596488557625;
        Mon, 03 Aug 2020 14:02:37 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v15sm26649040wrm.23.2020.08.03.14.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 14:02:36 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/8] lpfc: Update lpfc to revision 12.8.0.3
Date:   Mon,  3 Aug 2020 14:02:21 -0700
Message-Id: <20200803210229.23063-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.3

Patch set contains several small fixes.

The patches were cut against Martin's 5.9/scsi-queue tree

James Smart (8):
  lpfc: Fix FCoE speed reporting
  lpfc: Fix no message shown for lpfc_hdw_queue out of range value
  lpfc: Fix RSCN timeout due to incorrect gidft counter
  lpfc: Fix oops when unloading driver while running mds diags
  lpfc: Fix retry of PRLI when status indicates its unsupported
  lpfc: Fix validation of bsg reply lengths
  lpfc: Fix lun loss after cable pull
  lpfc: Update lpfc version to 12.8.0.3

 drivers/scsi/lpfc/lpfc_attr.c      | 26 +++++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_bsg.c       | 21 ++++++++-------------
 drivers/scsi/lpfc/lpfc_ct.c        | 22 ++++++++++++++++------
 drivers/scsi/lpfc/lpfc_els.c       | 10 +++++++---
 drivers/scsi/lpfc/lpfc_init.c      | 18 +++++++++++++++---
 drivers/scsi/lpfc/lpfc_nportdisc.c |  8 +++++++-
 drivers/scsi/lpfc/lpfc_sli.c       | 11 +++++++++--
 drivers/scsi/lpfc/lpfc_version.h   |  2 +-
 8 files changed, 86 insertions(+), 32 deletions(-)

-- 
2.26.2

