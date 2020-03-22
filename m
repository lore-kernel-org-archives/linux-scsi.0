Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D828DC4332B
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A99C32072E
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 18:13:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i4RdENhe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgCVSNN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 14:13:13 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37669 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgCVSNN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 14:13:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id a32so5961165pga.4
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 11:13:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=LP6plaTFmbxwhZbpmYS2FxepZz3RjZKJhbCfGyu9744=;
        b=i4RdENhecBtX3L+q44L4Lv0vVcH0qqy3/gPlOsoT1yAm8iKRoYVMwyc2N98FP90NiU
         nq2vGM/wibd++2GFyYtiy1YiXzluTzjP5Pi4yOQns5mRl10Nvn6NPuFQAJmDw4HHR2rF
         Wtm2ei0W19b+4q4dKZGUB9IvPgPQ5LfPau/uuCGidUDoWz7VRie/2sZm2Ly8WEvmNQ2S
         aCCuS8LAZ8tGPGr6Axrf7oz1TWupnJ1RJNKdeKnI6phkSb9wST4ns5GidfEqJUXnK/Yp
         PwS9Zq1fT+lHB3wD2BA7WfqQA2o8NbaEwGg9vlagaHz+al28HxdYt0H58kWVBT1IjuQh
         S1Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LP6plaTFmbxwhZbpmYS2FxepZz3RjZKJhbCfGyu9744=;
        b=md5StU2yiO5TvPen75hOYA9HppBZ8YSvgOjiruFqUDdUDDBGtZPwsQaQ7GbHQk2aLF
         sTKEL/hEAKsR/LYRtZ6j59Eoa4RH0e8x37vJhQMk3GesfkpW6t6I44x9/OZidxZtASD1
         fTp1LJFtBez2cqDHtDPdzDM6XYa4QD3/jaYhX3ccnJ9yv1GPz3N90J3nFwyKWQwAMW9L
         J2xvV84N1PrdsPR4qLQ/O3kCoNL+IxD3gOK/C14dYQoMS567q8LxALHrD3+IKY3t51WB
         15H8dhHyqjl3MtSbloWK8b1SdKddkVlc+x6neZHBVq65tTq7KRYYS1y6HfUGMXIpx975
         ObIw==
X-Gm-Message-State: ANhLgQ0qRoNy9cY3QsPFwTiDLv7M2NOQREKCK0xB2stis6j5oNFUQZdB
        wDsYFDhygfwm3WAhd2v0bbGlD249
X-Google-Smtp-Source: ADFU+vs3GgjHawk8fuWuA8q1NpJe6uCvtP7Rl3QShS/cl7YAsPPI2Ke+gcPuLfzOxG/gqH0NKVr3Ag==
X-Received: by 2002:aa7:8bdc:: with SMTP id s28mr19156227pfd.110.1584900790403;
        Sun, 22 Mar 2020 11:13:10 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-146-102.oc.oc.cox.net. [68.5.146.102])
        by smtp.gmail.com with ESMTPSA id bt19sm1331657pjb.3.2020.03.22.11.13.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:13:09 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/12] lpfc: Update lpfc to revision 12.8.0.0
Date:   Sun, 22 Mar 2020 11:12:52 -0700
Message-Id: <20200322181304.37655-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.0

Patch set contains mainly fixes, a change to QD default, and a few
cleanups.

The patches were cut against Martin's 5.7/scsi-queue tree

-- james

James Smart (12):
  lpfc: Fix kasan slab-out-of-bounds error in lpfc_unreg_login
  lpfc: Fix lockdep error - register non-static key
  lpfc: Fix lpfc overwrite of sg_cnt field in nvmefc_tgt_fcp_req
  lpfc: Fix scsi host template for SLI3 vports
  lpfc: Fix crash after handling a pci error.
  lpfc: Fix update of wq consumer index in lpfc_sli4_wq_release
  lpfc: Fix crash in target side cable pulls hitting WAIT_FOR_UNREG
  lpfc: Fix erroneous cpu limit of 128 on I/O statistics
  lpfc: Change default SCSI LUN QD to 64
  lpfc: Make debugfs ktime stats generic for NVME and SCSI
  lpfc: Remove prototype FIPS/DSS options from SLI-3
  lpfc: Update lpfc version to 12.8.0.0

 drivers/scsi/lpfc/lpfc.h         |  25 ++-
 drivers/scsi/lpfc/lpfc_attr.c    |  71 +--------
 drivers/scsi/lpfc/lpfc_crtn.h    |   3 +-
 drivers/scsi/lpfc/lpfc_debugfs.c | 333 ++++++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_debugfs.h |   3 +-
 drivers/scsi/lpfc/lpfc_hw.h      |  20 +--
 drivers/scsi/lpfc/lpfc_init.c    | 106 +++++++++----
 drivers/scsi/lpfc/lpfc_mbox.c    |   2 -
 drivers/scsi/lpfc/lpfc_nvme.c    | 147 ++++-------------
 drivers/scsi/lpfc/lpfc_nvmet.c   |  62 ++++----
 drivers/scsi/lpfc/lpfc_scsi.c    |  90 +++--------
 drivers/scsi/lpfc/lpfc_sli.c     |  47 ++----
 drivers/scsi/lpfc/lpfc_sli.h     |   2 +-
 drivers/scsi/lpfc/lpfc_sli4.h    |  19 ++-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 15 files changed, 441 insertions(+), 491 deletions(-)

-- 
2.16.4

