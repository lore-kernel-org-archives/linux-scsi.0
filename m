Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C56C5479D
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Jan 2023 23:22:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234880AbjAIXWa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 18:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237616AbjAIXW1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 18:22:27 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3155959C
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 15:22:23 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d15so11294177pls.6
        for <linux-scsi@vger.kernel.org>; Mon, 09 Jan 2023 15:22:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=r4WX9tIed7v0WbTRjJ/KuceZOPkI07qTrxkS1V4iyIs=;
        b=mu++25HkMKuc9TbLfGp10HALAACdAZqFE6ugz4NzGBEtfEOdz/JbOZb/+C9dXIgGsv
         EUifU6N/pGaHR57K7AqnDDizZJ6YXRdJllV3/IzQHoMVr5/SKsV5FcxM1dce2FJPUdD4
         GHvqZpdMxMDIWe/Lq6hSxJy2RdJgXomePwrI/GhXpeIASn0kXvEEDjUmEveY+36idySH
         fiHREspF2rhzYwHQoqMOkHP4PbwKMkb9uZAMSR63ONyZYNz9dO3TxdsnvobPll5SXvFA
         kJy4BRBQBX9CoKAvr1LN2TyD0kVI/MHMAq4z+NkdM6t8kh9jTKYFsTR7oYfGN6S4C3Ji
         kc2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r4WX9tIed7v0WbTRjJ/KuceZOPkI07qTrxkS1V4iyIs=;
        b=F8Sqq6qFFWq3WsyE8PRszY6pXHtmPOtcEoCgp04blvfbaXS8QQ8O3aQM+uaLol14SE
         QRi6DSE//9E5fMBvOWEFaEXhAuPAFqil7qODoWa835bVveesH6eA2+MWtCa70va957re
         RvM9zoqGadaSplFeaqdXwi6X78O4OamZkq8N4YX9Wta3DfwoiEid/Q9JPu1QK9CtzBhL
         QNhHkhP0TrGbv4pdMQROqB49XAZUsnR+7MIImrdCxEWdtBJVZTAlh7ulcUqQU1Q8dFsq
         Q5FwB0UcFM/erQjUtxG5CqfeiryZ1s4XXWN7On8BFfhowfEVsosyUdjzHoiC8Z8mY9el
         5OlA==
X-Gm-Message-State: AFqh2kru08QHJqddmu0j55iHwGNp9qQW7fYlMxu7PkdSFX7nljETBfCC
        hD7Gss5tTkWmwrNImMGiokXxeQN+LXY=
X-Google-Smtp-Source: AMrXdXtMV/cTrhKBy6eN7MXTdh8SGcmFdJK8YrJy6aqWk6Pxaur5mo6eP/9qUTsYtS6U40HrhB4i2w==
X-Received: by 2002:a17:902:a588:b0:192:50cd:97e2 with SMTP id az8-20020a170902a58800b0019250cd97e2mr61868617plb.26.1673306543317;
        Mon, 09 Jan 2023 15:22:23 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d22-20020a170902aa9600b001871461688esm6628572plr.175.2023.01.09.15.22.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Jan 2023 15:22:22 -0800 (PST)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/12] lpfc: Update lpfc to revision 14.2.0.10
Date:   Mon,  9 Jan 2023 15:33:05 -0800
Message-Id: <20230109233317.54737-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.10

This patch set contains fixes for bugs, kernel test robot, and introduces
new attention type event handling.

The patches were cut against Martin's 6.3/scsi-queue tree.

Justin Tee (12):
  lpfc: Fix space indentation in lpfc_xcvr_data
  lpfc: Replace outdated strncpy with strscpy
  lpfc: Resolve miscellaneous variable set but not used compiler
    warnings
  lpfc: Set max dma segment size to hba supported SGE length
  lpfc: Remove redundant clean up code in disable_vport
  lpfc: Remove duplicate ndlp kref decrement in lpfc_cleanup_rpis
  lpfc: Exit PRLI completion handling early if ndlp not in PRLI_ISSUE
    state
  lpfc: Fix use-after-free KFENCE violation during sysfs firmware write
  lpfc: Reinitialize internal VMID data structures after FLOGI
    completion
  lpfc: Introduce new attention types for lpfc_sli4_async_fc_evt hdlr
  lpfc: Update lpfc version to 14.2.0.10
  Copyright updates for 14.2.0.10 patches

 drivers/scsi/lpfc/lpfc.h         |  4 +-
 drivers/scsi/lpfc/lpfc_attr.c    | 63 +++++++++------------
 drivers/scsi/lpfc/lpfc_crtn.h    |  4 +-
 drivers/scsi/lpfc/lpfc_els.c     | 33 ++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 17 +-----
 drivers/scsi/lpfc/lpfc_hw4.h     |  7 ++-
 drivers/scsi/lpfc/lpfc_init.c    | 94 ++++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_scsi.c    |  8 +--
 drivers/scsi/lpfc/lpfc_sli.c     | 83 ++++++++++++++--------------
 drivers/scsi/lpfc/lpfc_sli4.h    |  5 +-
 drivers/scsi/lpfc/lpfc_version.h |  6 +-
 drivers/scsi/lpfc/lpfc_vmid.c    | 41 +++++++++++++-
 drivers/scsi/lpfc/lpfc_vport.c   | 16 +-----
 13 files changed, 238 insertions(+), 143 deletions(-)

-- 
2.38.0

