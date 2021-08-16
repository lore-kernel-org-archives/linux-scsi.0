Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33D60C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BCB360F58
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Aug 2021 16:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhHPQ3n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 12:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbhHPQ3m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2021 12:29:42 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224CBC061764
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:11 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id f3so21312887plg.3
        for <linux-scsi@vger.kernel.org>; Mon, 16 Aug 2021 09:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pWtezKFyikH3cSpXd0m8JXnvMa0CZ94sCB0c7l5CI3w=;
        b=rF319z5ikWGuE1kvUgF6ozZ882P1hCtwhzJIrAkkuGACLL9lNIa0KVjnFfmIKFi1UH
         PmDtws8ifux+6f1yRyboHE99KuPmCMXAJKs200CS/WrikN4zygz0q2JDgvg/h0awiSxv
         Tg5WmSC3ljc4682PSJ6vM9mufeVMvMJ7tfvBbOSVG3bFtdu32zbupA3wMk2UUsYm6u9J
         Tn0X5Ec7CdR7yqX5w9kEEktywhTV+yNCo52AakSFPI/J6uPNScPqwjz6SiFwSlYyLAqb
         rc49X2qGBmsx1hThp485SQ3zLvpYdr6U747TxJW6U1XCPFvHZl5yrv9yd//f1NPQtJ/i
         RG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pWtezKFyikH3cSpXd0m8JXnvMa0CZ94sCB0c7l5CI3w=;
        b=qOJ3bXet9mH7yymyIwm6qLK8OSnxkNG+VrElmJgZ6gCCOyqVbemGyz1vFD2Y9qTnEr
         kWZmmeiF4T37vJ7C70bkrMjWDh3EXqV8+td0dl2voqK3rSSwc9B31m/SQA2PDlrmhJwf
         m20ppwK8fmrj7w9nS6b3jqz2lsol+Tqvs98QdidPYa0ulI2amc/VLAd66PkeLu3PZN1B
         2zJ98SOoZ702Md1EY3Q9LE/3G6Bza10bzLMqlq3xL4CQjJ42rlDXNZHcyCr8eEAdAQDc
         gD1xn0XDl5k1TphkOUEUEBo7lqHWX4kNo6kNqc7cxxvt+1lomTl+dYn+n4oSDJVPEcng
         jYFQ==
X-Gm-Message-State: AOAM530NX4ff/9RbK8SpwCfhXBejc4f692WpKqI28ZJVaNa/RmahxmtE
        UAuqKEJIG4AvCXI/SwirK7dkIFP9KtQ=
X-Google-Smtp-Source: ABdhPJws0xTo3hAO+n2u/Q9GLmkH0Los156mQ4D7dCF/Qp0ajawwwepGjqjL4KBzLVj3e3sDjsSheg==
X-Received: by 2002:a17:90a:e641:: with SMTP id ep1mr1679539pjb.209.1629131350597;
        Mon, 16 Aug 2021 09:29:10 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h5sm11257938pfv.131.2021.08.16.09.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 09:29:10 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v3 00/16] lpfc: Update lpfc to revision 14.0.0.1
Date:   Mon, 16 Aug 2021 09:28:45 -0700
Message-Id: <20210816162901.121235-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.0.0.1

This patch set adds support the Congestion Management Framework (CMF)
which a component of Emulex San Manager (ESM). ESM is an inband
monitoring and management solution.  CMF performs congestion monitoring
and adaptive management with roles split between the adapter and the
driver.

The CMF framework consists of tables and buffers exchanged between
the adapter and the driver. The tables indicate whether congestion is
to be managed, values for management, and congestion statistics. When
fully managed, periodic synchronization occurs between the driver
and the adapter.

The patches were cut against Martin's 5.15/scsi-queue tree

V2:
 Patch 5:
   Addressed kernel test robot warnings for printk arg types. Substituted
     0x%zx for %ld for sizeof args.

v3:
 Patch 9/10/11:
   Address krobot cross compile errors: "__aeabi_ldivmod". Use div_u64
     instead of explicit divide.

James Smart (16):
  fc: Add EDC ELS definition
  lpfc: Add SET_HOST_DATA mbox cmd to pass date/time info to firmware
  lpfc: Add MIB feature enablement support
  lpfc: Expand FPIN and RDF receive logging
  lpfc: Add EDC ELS support
  lpfc: Add cm statistics buffer support
  lpfc: Add support for cm enablement buffer
  lpfc: add cmfsync WQE support
  lpfc: Add support for the CM framework
  lpfc: Add rx monitoring statistics
  lpfc: Add support for maintaining the cm statistics buffer
  lpfc: Add debugfs support for cm framework buffers
  lpfc: Add cmf_info sysfs entry
  lpfc: Add bsg support for retrieving adapter cmf data
  lpfc: Update lpfc version to 14.0.0.1
  lpfc: Copyright updates for 14.0.0.1 patches

 drivers/scsi/lpfc/lpfc.h         |  252 ++++++
 drivers/scsi/lpfc/lpfc_attr.c    |  226 ++++-
 drivers/scsi/lpfc/lpfc_bsg.c     |   89 ++
 drivers/scsi/lpfc/lpfc_bsg.h     |   10 +-
 drivers/scsi/lpfc/lpfc_crtn.h    |   28 +
 drivers/scsi/lpfc/lpfc_ct.c      |   17 +-
 drivers/scsi/lpfc/lpfc_debugfs.c |  223 +++++
 drivers/scsi/lpfc/lpfc_debugfs.h |   11 +-
 drivers/scsi/lpfc/lpfc_els.c     | 1065 ++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c |   23 +-
 drivers/scsi/lpfc/lpfc_hw.h      |    2 +
 drivers/scsi/lpfc/lpfc_hw4.h     |  249 +++++-
 drivers/scsi/lpfc/lpfc_init.c    | 1402 +++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_logmsg.h  |    5 +-
 drivers/scsi/lpfc/lpfc_mem.c     |   15 +-
 drivers/scsi/lpfc/lpfc_nvme.c    |   44 +-
 drivers/scsi/lpfc/lpfc_nvme.h    |    3 -
 drivers/scsi/lpfc/lpfc_scsi.c    |  187 +++-
 drivers/scsi/lpfc/lpfc_sli.c     |  772 +++++++++++++++-
 drivers/scsi/lpfc/lpfc_sli.h     |    2 +
 drivers/scsi/lpfc/lpfc_sli4.h    |    1 +
 drivers/scsi/lpfc/lpfc_version.h |    2 +-
 include/uapi/scsi/fc/fc_els.h    |  106 +++
 23 files changed, 4620 insertions(+), 114 deletions(-)

-- 
2.26.2

