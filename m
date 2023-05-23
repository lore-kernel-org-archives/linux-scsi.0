Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9871CC77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 18:22:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbjEWSWG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 14:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjEWSWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 14:22:05 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3677691
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:04 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1ae4e6825e1so6218655ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 11:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684866123; x=1687458123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JLdgcRhIWDXITIzobcpfee8WCCpviV3G9d4UE/Vyj6c=;
        b=W9IyklSnn6gtZj6q04/6Ec2V8rWr9rgrhg3TLYNV/O6lMiGi8b429brBVAYTYOQqi7
         PVz7KHsUct/LAC9WDRbag3JF/MSx8PkmZPKKU8o+MAKydQwwlj9VOCIkiUGwx76mPMTl
         Fl7CTUA6iSbCNASaoW06tbzVfoGkfsMcXIEsoRPyRRVbHbTqMqz1UKT90w2/a7DV5udS
         BuBxQ50hMr3UwEnDSIioalw4t18EWhwvKNTELCQ2QiSlgbfcwNI2nwnCpxPKcjthZyhT
         gAg3hFdclZwx8pDiOrd3AVL7c08FOSaOqDaQdhl7o0dGWSNm7bZwSX7dYVDVXA7uYATZ
         mbwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684866123; x=1687458123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JLdgcRhIWDXITIzobcpfee8WCCpviV3G9d4UE/Vyj6c=;
        b=dybyG1GnxkfwZjnuTbvIQ2xz+4r+27CtG0xBRqA4w7ZDVuXWi2cph22NCnHhe6mWRG
         uFQctk9I101Ot4IoV+zxtx17+NpKYC5WO4fnp1nZtdhBcsZZaN73b20LhppPvY+2viq0
         d8L05p+uAukX55U0Gs22eLYh01Ht8n5Sqvsv3N6Lk/qpjebXUOOwTbHq7cCWR1BEzpxW
         2d8bca8rZsCkkursicu4SeBcOFUQN4JPWhIir/xPCsdII57ceQimIbEh4/DmJmeu8OCK
         dvZD/i+/qWJYJTpBlCDRsl7j+At9mHm9ju1V2xqhbv/ga642APJJRWMOl1YM0nPQW6fM
         Ep3A==
X-Gm-Message-State: AC+VfDyvIyqlcvmRYA4WpY/Amjt95M3qcQQBNLiBisx0Xgpgvco8o49h
        wlHMDwtK1yuzY51fsQdU78GDj0RGt88=
X-Google-Smtp-Source: ACHHUZ5gMgpqbN8hv7HKMny7M0leZhUHFnC1LQmJE0r/Zs7ODmAV0zKFaGNkLKDPbSLvZ3kMKL7ghQ==
X-Received: by 2002:a17:903:22ca:b0:1a6:6bdb:b548 with SMTP id y10-20020a17090322ca00b001a66bdbb548mr16214108plg.1.1684866123269;
        Tue, 23 May 2023 11:22:03 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w10-20020a170902e88a00b001a687c505e9sm7070870plg.237.2023.05.23.11.22.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 11:22:02 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, justin.tee@broadcom.com,
        Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 0/9] lpfc: Update lpfc to revision 14.2.0.13
Date:   Tue, 23 May 2023 11:31:57 -0700
Message-Id: <20230523183206.7728-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.2.0.13

This patch set contains discovery bug fixes, firmware logging improvements,
clean up of CQ handling, and statistics collection enhancements.

The patches were cut against Martin's 6.5/scsi-queue tree.

Justin Tee (9):
  lpfc: Fix use-after-free rport memory access in
    lpfc_register_remote_port
  lpfc: Clear NLP_IN_DEV_LOSS flag if already in rediscovery
  lpfc: Account for fabric domain ctlr device loss recovery
  lpfc: Revise NPIV ELS unsol rcv cmpl logic to drop ndlp based on
    nlp_state
  lpfc: Change firmware upgrade logging to KERN_NOTICE instead of
    TRACE_EVENT
  lpfc: Clean up SLI-4 CQE status handling
  lpfc: Enhance congestion statistics collection
  lpfc: Update lpfc version to 14.2.0.13
  lpfc: Copyright updates for 14.2.0.13 patches

 drivers/scsi/lpfc/lpfc.h         |  65 +++-----
 drivers/scsi/lpfc/lpfc_els.c     |  14 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c |  33 ++--
 drivers/scsi/lpfc/lpfc_hw4.h     |   3 -
 drivers/scsi/lpfc/lpfc_init.c    | 250 +++++++++----------------------
 drivers/scsi/lpfc/lpfc_logmsg.h  |   6 +-
 drivers/scsi/lpfc/lpfc_nvme.c    |  17 ++-
 drivers/scsi/lpfc/lpfc_nvmet.c   |   6 +-
 drivers/scsi/lpfc/lpfc_scsi.c    |  65 ++++----
 drivers/scsi/lpfc/lpfc_sli.c     |  54 +++----
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 11 files changed, 195 insertions(+), 320 deletions(-)

-- 
2.38.0

