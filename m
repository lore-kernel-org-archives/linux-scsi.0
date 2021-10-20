Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFFC8C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD917610EA
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbhJTVQj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbhJTVQj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:16:39 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8682BC06161C
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:24 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id a15-20020a17090a688f00b001a132a1679bso1533511pjd.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n+Se+NjRWYgMKDNizSBH7tF4p1VanbZSJClwZPymAG8=;
        b=nRkqN66lMXX0SzEBjqjbGHfQy5HVaCaLa5HUL2tkWLvbSvIx83MMjy4/28nZWw35nm
         H30E3ezCJqSrgKlbgq+JlSgX53HcxdSOYzpWPLwhyZBTk4yc4GaioTE9vXz333saoZDe
         X73s+RIYXFbNQ51hY0uJQt/Fp7MY6hzHCmvD0TRxNvhe/7y/7Z6m4Ku0ZLI+ZUi0jXc1
         so9zO1HXJ5mDeTsWl2Q10rxckcsAas+km/aQpEX3DISWZ4qf4tW4TY5tgMYisiiEczmZ
         b7f1Tk4qTUXMdRm84ZO5HX//SesHppHJeUxLXdsNTuf7mu0pyiHzD5VUIiPU+NE3X/dd
         x3+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=n+Se+NjRWYgMKDNizSBH7tF4p1VanbZSJClwZPymAG8=;
        b=4sWSWfaL4B1aKI6WPGhy3rqEoSVL5EQPBQfGFUAWnio5erjzyq/iVJg3wfAh6DcKZX
         hdNZa7bAHvkn96rAuPySzuh4PqXnmidHyTdNjDrxbSv9vXxNAZKMxvF0WhNb92smpnjz
         on07CR/3/GIYVOLx3fRwhtuSZ/4PXijUBKSzXAd0cy8lqfL/LDDPbuk23uVV0FZePSDb
         fqwxxZPLJ6lhkSvyhPNE9Q7lbdcxQQBpouiX4u/s9g+udcuMUmzOe0aHnu84v7bB1Hla
         ElGWbVipN6f32Pp2luw3qZDnaswWPdTduay3ips7P2J1/Y43zMOyPKYiuBBLTWDRLetn
         pBRQ==
X-Gm-Message-State: AOAM532ln/5Z4fJz6pHJwQg6j3FKLk+s4FOi9SyPHTerpT5W2MaEukEF
        VpxlNrUxIVhB3M0GxGZpPn0MhKECpTA=
X-Google-Smtp-Source: ABdhPJwI+ZwvLagyqgg4YrzOsT7mkm6SpV/kFzojdOtOhkDW5X8oBa56HyE8fqITsHy0On3ybPmj8Q==
X-Received: by 2002:a17:90a:7d11:: with SMTP id g17mr1470468pjl.19.1634764464020;
        Wed, 20 Oct 2021 14:14:24 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id pi9sm3700689pjb.31.2021.10.20.14.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:14:23 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/8] lpfc: Update lpfc to revision 14.0.0.3
Date:   Wed, 20 Oct 2021 14:14:09 -0700
Message-Id: <20211020211417.88754-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.0.0.3

This patch set contains several bug fixes.

The patches were cut against Martin's 5.16/scsi-queue tree


James Smart (8):
  lpfc: Revert LOG_TRACE_EVENT back to LOG_INIT prior to
    driver_resource_setup
  lpfc: Wait for successful restart of SLI3 adapter during host sg_reset
  lpfc: Correct sysfs reporting of loop support after SFP status change
  lpfc: Fix use-after-free in lpfc_unreg_rpi() routine
  lpfc: Allow PLOGI retry if previous PLOGI was aborted
  lpfc: Fix link down processing to address NULL pointer dereference
  lpfc: Allow fabric node recovery if recovery is in progress before
    devloss
  lpfc: Update lpfc version to 14.0.0.3

 drivers/scsi/lpfc/lpfc_crtn.h    |   3 +
 drivers/scsi/lpfc/lpfc_disc.h    |  12 +++-
 drivers/scsi/lpfc/lpfc_els.c     |  20 +++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 112 ++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_init.c    |  68 +++++++++++++++++--
 drivers/scsi/lpfc/lpfc_scsi.c    |  19 ++++--
 drivers/scsi/lpfc/lpfc_sli.c     |  43 ++++--------
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 8 files changed, 229 insertions(+), 50 deletions(-)

-- 
2.26.2

