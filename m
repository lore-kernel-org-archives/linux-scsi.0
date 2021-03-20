Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A00C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 651666192C
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 23:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhCTXYP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Mar 2021 19:24:15 -0400
Received: from mail-pg1-f174.google.com ([209.85.215.174]:37584 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbhCTXYI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2021 19:24:08 -0400
Received: by mail-pg1-f174.google.com with SMTP id o11so6161356pgs.4
        for <linux-scsi@vger.kernel.org>; Sat, 20 Mar 2021 16:24:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r4wa/ons1kAqT9sjRLuzoe8n2hh1ST9Wt6gXAqyPgy4=;
        b=Gne3qvmsKC8XpVirh1xcCN4OGZoVju9tf+myGTJVrGFyC9YZA740K663cgFXV8XDbm
         hxvztbRQGEumXC1LEBEJSEWwBNmTvXh+vcbc04ECw3QCmEf3s5bGazyihLIEoQQbplk0
         pO/S9M4chdy62+6A3vNkzokOT3pqWvhaV0hVnjhXCJlwNvCM06DYbxzeP2ESLU5VbbGZ
         NSHJxor+sQebsLd8V6nAQTLy5y4WyAIJm6+h0cugs7C3cGnvx8PnfI2/+k9g4fhHUgh0
         ov4uJVCLUsh7KUMW/SOP8j1/nokrjwtbRRpl2cllRFT6NVrjZQTQWR7E33aTr3ndjghy
         ayAQ==
X-Gm-Message-State: AOAM532LoZTWiwMgd7yXUr8TZKT7US0DCEcWZgoApNqAGUSKnDmZObmu
        HUZjvow36YPxG3vOuXmcmII=
X-Google-Smtp-Source: ABdhPJwBZB+BpvOCZ2vIqCIENHqzd6onjPUhOqwvLM0mQflVba2RonmZ5x51E/qdbg3LUA1TXfEzVA==
X-Received: by 2002:a65:44c5:: with SMTP id g5mr17239909pgs.295.1616282646841;
        Sat, 20 Mar 2021 16:24:06 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:9252:a76b:2952:3189])
        by smtp.gmail.com with ESMTPSA id u7sm8869159pfh.150.2021.03.20.16.24.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 16:24:06 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/7] qla2xxx patches for kernel v5.12 and v5.13
Date:   Sat, 20 Mar 2021 16:23:52 -0700
Message-Id: <20210320232359.941-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider the first patch in this series for kernel v5.12 and the
remaining patches for kernel v5.13.

Thanks,

Bart.

Changes compared to v2:
- Addressed the v2 review comments.
- Added a seventh patch that adds a kzalloc() return value check.

Changes compared to v1:
- Improved the description of patch 1/6.
- Dropped one patch that is already upstream.

Bart Van Assche (7):
  Revert "qla2xxx: Make sure that aborted commands are freed"
  qla2xxx: Constify struct qla_tgt_func_tmpl
  qla2xxx: Fix endianness annotations
  qla2xxx: Suppress Coverity complaints about dseg_r*
  qla2xxx: Simplify qla8044_minidump_process_control()
  qla2xxx: Always check the return value of qla24xx_get_isp_stats()
  qla2xxx: Check kzalloc() return value

 drivers/scsi/qla2xxx/qla_attr.c    |  8 +++++++-
 drivers/scsi/qla2xxx/qla_bsg.c     |  4 ++++
 drivers/scsi/qla2xxx/qla_def.h     |  4 ++--
 drivers/scsi/qla2xxx/qla_iocb.c    |  3 ++-
 drivers/scsi/qla2xxx/qla_isr.c     |  2 +-
 drivers/scsi/qla2xxx/qla_mr.c      | 12 ++++++------
 drivers/scsi/qla2xxx/qla_mr.h      |  8 ++++++--
 drivers/scsi/qla2xxx/qla_nx2.c     |  8 --------
 drivers/scsi/qla2xxx/qla_sup.c     |  9 +++++----
 drivers/scsi/qla2xxx/qla_target.c  | 13 +++++--------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  6 +-----
 11 files changed, 39 insertions(+), 38 deletions(-)

