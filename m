Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 631BAC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AC7B21582
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 23:58:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jgjo7Tj0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfLRX6U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 18:58:20 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:41592 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfLRX6U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 18:58:20 -0500
Received: by mail-wr1-f41.google.com with SMTP id c9so4129608wrw.8
        for <linux-scsi@vger.kernel.org>; Wed, 18 Dec 2019 15:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=p/EYMLCi6Bh0bEFmyhkesPANqGMLzDPNhqQ8fX9uOuc=;
        b=Jgjo7Tj0N+60fXIxAjXbwKkeAAm7377mojMrVFU9+j0UnOoV/ADVnf9vLb3W/bfbIX
         05/IxZAiQ6Xw5I1FsfwYyKDL4EdcPnWPB8NjwikWpT+uiCA8VSd3AGIIh41MdrCTjlJh
         A8xAIp3HnKKmohmsP8uq/lUhhD5Y7gTbJ9vLBviiioQOHjPZUPWPi8xXGHBVuy45VS9d
         pvPCM+W4nKeqeeBl8QrygJjRY8W8mHz2Wy0U8lEoeAVUUfPSG675YAz8D2zh/+NlYAxW
         zluG3A048kJHs3XNfpK2dtKAHNQBbZ5JlhqPVSMvp360LPbMG285qRrJKly8p0e4JmnT
         PcsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=p/EYMLCi6Bh0bEFmyhkesPANqGMLzDPNhqQ8fX9uOuc=;
        b=IsWKqY0I51Jus6aG7ERaqM5/IL3FAZ1xHul4ZkCPXO9OHP3dWh31XZ931v/E+u9fYp
         JRQB1JkJyqgCN4quOVE4TCOJaX8XvDimtb79pxCTEJhIXIseaBC2A8pTlYAx5h29MiMA
         U3FNEa2GviYCG8AO8mIbWDit3DQVG/+E94t2o7JtwxxjXkFi7ek9bGXZKcAda+Ti1Fyb
         Xh9C9mLdnkYX6g3uqcgHvVhhmY6ah5a7MMXmNK1Ir0uC4tiJZ3b7iQumz82WNNFp4H/2
         8KCiWbfbbMOQRY4GchHdfHKx0L/VWU4iNJKEPq+56pU9lTFehci8U7ULZRKLqxMGBYTY
         EaEw==
X-Gm-Message-State: APjAAAUby/XhMKSmNoxtGs1ZJlpAW0ndvO+X87Fqs2maM2zyIAnn+oh+
        UAtOWF0uT0bTOkzwU1Hw+1yDfl3+
X-Google-Smtp-Source: APXvYqye8fcL/fJ4PxHdxQdKJwGcIIjDkB90VbsE0LD/ioIV5K5lzIrpkM36lKfn7r1/7gwV2M67oA==
X-Received: by 2002:adf:e984:: with SMTP id h4mr5651918wrm.275.1576713498093;
        Wed, 18 Dec 2019 15:58:18 -0800 (PST)
Received: from os42.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x11sm4240731wmg.46.2019.12.18.15.58.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 18 Dec 2019 15:58:17 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/10] lpfc: Update lpfc to revision 12.6.0.3
Date:   Wed, 18 Dec 2019 15:57:58 -0800
Message-Id: <20191218235808.31922-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.6.0.3

This patch set contains nine fixes.

The patches were cut against Martin's 5.6/scsi-queue tree

James Smart (10):
  lpfc: Fix incomplete NVME discovery when target
  lpfc: Fix: Rework setting of fdmi symbolic node name registration
  lpfc: Fix missing check for CSF in Write Object Mbox Rsp
  lpfc: Fix Fabric hostname registration if system hostname changes
  lpfc: Fix ras_log via debugfs
  lpfc: Fix disablement of FC-AL on lpe35000 models
  lpfc: Fix unmap of dpp bars affecting next driver load
  lpfc: Fix MDS Latency Diagnostics Err-drop rates
  lpfc: Fix improper flag check for IO type
  lpfc: Update lpfc version to 12.6.0.3

 drivers/scsi/lpfc/lpfc.h           |   2 +
 drivers/scsi/lpfc/lpfc_attr.c      |   9 ++--
 drivers/scsi/lpfc/lpfc_crtn.h      |   2 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  88 +++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_debugfs.c   |  11 +++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   5 ++
 drivers/scsi/lpfc/lpfc_hw4.h       |   3 ++
 drivers/scsi/lpfc/lpfc_init.c      |  12 ++---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 108 +++++++++++++++++++++++++++++++++----
 drivers/scsi/lpfc/lpfc_scsi.c      |   4 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  25 +++++++--
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 12 files changed, 209 insertions(+), 62 deletions(-)

-- 
2.13.7

