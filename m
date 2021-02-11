Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11105C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D97F664E45
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 23:45:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbhBKXpf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhBKXpb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2021 18:45:31 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3122CC061574
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:51 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id c11so4710010pfp.10
        for <linux-scsi@vger.kernel.org>; Thu, 11 Feb 2021 15:44:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bQP/J6QAgH//gzC8/MD4o1mT+lSa0ZtUkoKgXrKl5M=;
        b=nT/r1wYoBnYe6eHc6J3nzl23L1XSmRbHgp1zzDoD3xjF18277/CTZem9BgceS6FI5a
         M0674Xv8BEfyZnUzgufiJgwhtzoFZzVcuqZ647mTi4ABlo3Ny82xqWvKXG16Kv/yj89s
         izk5FeXkGLloftUDaLWvWckfHiVNa+dXHuTys1HW6Jc/MHsO2p5HIiAkPxg4BTXjfQM+
         odv9Y+blmWwkDR/zAeIYigibg1/YCJw5Tsje9V2QPIcdjLAp1Nu37tXQxhY6fDwEQA9v
         /s9X7IuKo44UQ9iM+OjwwozUetQvvdWtdIq/cDa4pNb3MoBcbSP5h07L1sNU3iO16eiU
         RF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bQP/J6QAgH//gzC8/MD4o1mT+lSa0ZtUkoKgXrKl5M=;
        b=cSRbaRU8P8QKce6xASQMK5fxAAC7mpXUuY1PfjIaErWeiDkw+1d3AuX+Nqo8XPOvft
         yXT1swCnpB8K1f4LQen3uTFnKwUjToH/MKadf40rx3vSPHarB4WoOd1SnjY1HArRoi0k
         7hNuy6o4losVf/wUmLJTq1ehOU2Ls3i139kr3rg1a/K35maO1SHIE2YtajmjSZWPhkrA
         ZckM3AIZC1QDNeJi/oPTeHIpMJ7dtqaKIyp1QGU3btvvLgWDfIBGF8XcMWV9pAZsJlsN
         HfyaWhqMxHSMxK8hKpSe6PCj7oWZkggVt4hpqAe81KcjPS5W87zRNf3xilLjHNg5QsmH
         FfJQ==
X-Gm-Message-State: AOAM532dGuWl3xNNk1YBkRNI45SaOSUM0f3S6Y7LjbUMg+aLmPP3nAwo
        n4iCTWgOR5HYR0YoG16HTtpkuT4MZJM=
X-Google-Smtp-Source: ABdhPJy5qRFwmEWiG1EMVOg0NsfMcbXamIRrjJcnwNyicf3huof9r/4R2aSoeiLY0rKhTOGsnAB2Vg==
X-Received: by 2002:a63:1611:: with SMTP id w17mr523699pgl.330.1613087090678;
        Thu, 11 Feb 2021 15:44:50 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id i67sm6808035pfe.19.2021.02.11.15.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 15:44:50 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/22] lpfc: Update lpfc to revision 12.8.0.8
Date:   Thu, 11 Feb 2021 15:44:21 -0800
Message-Id: <20210211234443.3107-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.8

This patch set contains fixes and a cleanup patches.

The patches were cut against Martin's 5.11/scsi-queue tree

James Smart (22):
  lpfc: Fix incorrect dbde assignment when building target abts wqe
  lpfc: Fix vport indices in lpfc_find_vport_by_vpid()
  lpfc: Fix reftag generation sizing errors
  lpfc: Fix stale node accesses on stale RRQ request
  lpfc: Fix FLOGI failure due to accessing a freed node
  lpfc: Fix lpfc_els_retry() possible null pointer dereference
  lpfc: Fix pt2pt connection does not recover after LOGO
  lpfc: Fix unnecessary null check in lpfc_release_scsi_buf
  lpfc: Fix null pointer dereference in lpfc_prep_els_iocb()
  lpfc: Fix use after free in lpfc_els_free_iocb
  lpfc: Fix status returned in lpfc_els_retry() error exit path
  lpfc: Fix dropped FLOGI during pt2pt discovery recovery
  lpfc: Fix PLOGI ACC to be transmit after REG_LOGIN
  lpfc: Fix ADISC handling that never frees nodes
  lpfc: Fix nodeinfo debugfs output
  lpfc: Fix pt2pt state transition causing rmmod hang
  lpfc: Fix crash caused by switch reboot
  lpfc: Change wording of invalid pci reset log message
  lpfc: Reduce LOG_TRACE_EVENT logging for vports
  lpfc: Correct function header comments related to ndlp reference
    counting
  lpfc: Update lpfc version to 12.8.0.8
  lpfc: update copyrights for 12.8.0.7 and 12.8.0.8 changes

 drivers/scsi/lpfc/lpfc.h           |   3 +-
 drivers/scsi/lpfc/lpfc_attr.c      |   2 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   4 +-
 drivers/scsi/lpfc/lpfc_debugfs.c   |  13 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   3 +-
 drivers/scsi/lpfc/lpfc_els.c       | 639 ++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   6 +-
 drivers/scsi/lpfc/lpfc_init.c      |   2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c | 272 +++++-------
 drivers/scsi/lpfc/lpfc_nvme.c      |   2 +-
 drivers/scsi/lpfc/lpfc_nvmet.c     |   5 +-
 drivers/scsi/lpfc/lpfc_scsi.c      | 117 ++++--
 drivers/scsi/lpfc/lpfc_sli.c       |  29 +-
 drivers/scsi/lpfc/lpfc_version.h   |   6 +-
 drivers/scsi/lpfc/lpfc_vport.c     |  10 +-
 15 files changed, 516 insertions(+), 597 deletions(-)

-- 
2.26.2

