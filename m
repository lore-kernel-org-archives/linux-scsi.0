Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C1ECA9ED3
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7302080F
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 00:57:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mNWjTMzB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729490AbfKEA5X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 19:57:23 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40282 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728602AbfKEA5X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 19:57:23 -0500
Received: by mail-wm1-f67.google.com with SMTP id f3so7005666wmc.5
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 16:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=tq3cBC96laVFibolUEyw8gp1jFWzSoy93rwgG0xn0Hw=;
        b=mNWjTMzBM0vw+CY/N+8OkVkDkkXcaG+DDkGJO/abUHl89qa2CygjGDWku8CauGVbQm
         rceAKHRlnZ0a4CfA1dSxI6TKgXKvTbPeZzDKzlHSqTJUFKzjmsg6FFfrtL3Z0LfVh0IS
         Mdc47XGXMaNTXUSlgCsPBl245RYxDvisqrXXf4l/rUiKo7pu0PxEeyzL5c7qEY8O8H4q
         xnHoDeOK+j1rVdno+r4Xp3TAgb3pZujGVwyitbFHi/kOldSvuB/+DTPnl4RF71vsS4Nm
         SuNafiu6cA178Lk6Wg6q1Wgz6sB77Gy5uNLQhKCsU3M5W+19wwfMrdTJbbWfRFY/z2Vx
         1X7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tq3cBC96laVFibolUEyw8gp1jFWzSoy93rwgG0xn0Hw=;
        b=mOR+B8FcudkjPHja3LmEvPKo0u+IwCthiDSzTRBNtty5StbiX8xN7OxyyAjjoyCHgH
         NlhoZOI/qPahizUqwO35LDcBCLQ25XQ4nTkGrsS/gC1Po5zVWR0giZ9H50Eq1Cq0BAT+
         ksie5PoggZVqM+/v7NPuzXliJn2dRTs+X5wN13WBblBQ8YtQwRC8Yz4vxHBUkqP3AzXc
         LTW3w+fGHFHX0DzEBB+sLrI5rvaxhO1i8QWmma/iUs7NY6mezqax1dSLc3O6jeP86oB+
         0gu6B7A/XLIDpb1V166JCJTBjq8h95L0IeWZy6m0e38t9/fSduH/k8HHMaEjpaB3XpQC
         p1kg==
X-Gm-Message-State: APjAAAVbdNh3fNfygUmwJT7zOxKbFRbVj1Ihxaf9Y2rSOCTCTrWrhHpR
        sO4fDhY3EkUmdgiFZUt+G6l0Yw8K
X-Google-Smtp-Source: APXvYqwd+QLe6GlfMw7RwXVX/sZr8g+rMkwQLTD0N15D+tQ+5UAZ7A5MAL8VoOs9MyNGO6LZhP/hNw==
X-Received: by 2002:a1c:4046:: with SMTP id n67mr1591046wma.2.1572915440645;
        Mon, 04 Nov 2019 16:57:20 -0800 (PST)
Received: from pallmd1.broadcom.com ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id g5sm16920991wma.43.2019.11.04.16.57.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 04 Nov 2019 16:57:20 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/11] lpfc: Update lpfc to revision 12.6.0.1
Date:   Mon,  4 Nov 2019 16:56:57 -0800
Message-Id: <20191105005708.7399-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.6.0.1

This patch contains a set fixes and 3 patches of new functionality.
One of the fixes corrects a typo in one of the patches in the last
set (dynamic fw log).

The patches were cut against Martin's 5.5/scsi-queue tree

James Smart (11):
  lpfc: Fix duplicate unreg_rpi error in port offline flow
  lpfc: Fix configuration of BB credit recovery in service parameters
  lpfc: Fix kernel crash at lpfc_nvme_info_show during remote port
    bounce
  lpfc: Fix unexpected error messages during RSCN handling
  lpfc: Fix dynamic fw log enablement check
  lpfc: Sync with FC-NVMe-2 SLER change to require Conf with SLER
  lpfc: Clarify FAWNN error message
  lpfc: Add registration for CPU Offline/Online events
  lpfc: Change default IRQ model on AMD architectures
  lpfc: Add enablement of multiple adapter dumps
  lpfc: Update lpfc version to 12.6.0.1

 drivers/scsi/lpfc/lpfc.h           |  28 ++
 drivers/scsi/lpfc/lpfc_attr.c      | 174 +++++++---
 drivers/scsi/lpfc/lpfc_crtn.h      |   6 +
 drivers/scsi/lpfc/lpfc_els.c       |  21 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  17 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |  10 +
 drivers/scsi/lpfc/lpfc_init.c      | 630 ++++++++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_nportdisc.c |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 198 +++++++++++-
 drivers/scsi/lpfc/lpfc_sli4.h      |  40 ++-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 11 files changed, 953 insertions(+), 177 deletions(-)

-- 
2.13.7

