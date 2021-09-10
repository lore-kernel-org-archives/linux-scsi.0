Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 031C6C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9ECF61213
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Sep 2021 23:32:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234799AbhIJXdU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Sep 2021 19:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233121AbhIJXdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2021 19:33:19 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B97C061574
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:08 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e7so2124518plh.8
        for <linux-scsi@vger.kernel.org>; Fri, 10 Sep 2021 16:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cdMqb0Ujq7DsrpcAYR7VX3Sz7KHQ9DPGzASa+gy17k0=;
        b=WVr8NuXrlCNPNvAUrttaA8R84vCMkDtKDobrgZY8w1IpkM9fGBDImfaRFlxvPHgoa5
         xIOukbsFHdG7/5dMj6ctJOZjNYaacrDlq+6vc6ocbg+/IVcGNzcZCwBqC9OcWad+pdLI
         eQQeICNaSEvOQ5L18oTXX7fjGAKr8ihghysIDrQPZMiqrqAUpxAONosTsesnCTwbClCV
         +HvrdYS9cWknXCLgrdrPt2bKwvtsrv+HfEax94eg3LYyDxiMDqwwezeZD1mrDbIXOhpA
         Nml/5KNcQE2rZpuIz8rh/5yDXeJQ6y6YM8yI2lq2P2NaQ6GWOoo7FMKhSF6GvEVj9SAN
         7Ffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cdMqb0Ujq7DsrpcAYR7VX3Sz7KHQ9DPGzASa+gy17k0=;
        b=y+Iw52FRUJtyYfyaS6fEiPKoauqsvloMZqtTeGpWTOEdhhIgrmXfTv2zFQbSpJYDjP
         Xq/pgg2eLEVLrNLF8NK+q4KwkStUFMHSSxHl3N7cnK0EOvoCgB1kwfEHLdii4OUbYL5H
         2MXCsP8+ALSOfr8eLgyYvYddSJNOUQ9mF2l1cFYOS5oCOnp8QyarxTG87ZkSIh+Bp0E+
         IrgtGZTEj07fYKawSyPemQI8UQwCTGMZuuQUWcn9a3css72IUVfo13hz93rrW+xz2Fiv
         xEXYsLF85T3tr9Ij+pz66QI2AemNn5bcFrGPif+0jqX31RSR3tFK4nw99Zd05YPpdNH/
         koKQ==
X-Gm-Message-State: AOAM530v1EyeWlaKYcJeOnZtxTl9tWaJ732eHkW1aVX8xy+idDPjh8we
        yjQrD9p86AzLB99nRnm79+XiKOAQyngnqtVp
X-Google-Smtp-Source: ABdhPJyDObzSGu7Ch3Ue/2fRXYQEZmctZI9wV1gK8BMaPmrieIV97DwRq/H6mZ0kwlK4duaaLdGg4Q==
X-Received: by 2002:a17:90a:1990:: with SMTP id 16mr141860pji.11.1631316727483;
        Fri, 10 Sep 2021 16:32:07 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm11325pfk.143.2021.09.10.16.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 16:32:07 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/14] lpfc: Update lpfc to revision 14.0.0.2
Date:   Fri, 10 Sep 2021 16:31:45 -0700
Message-Id: <20210910233159.115896-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.0.0.2

This patch provides a number of fixes to discovery scenarios and
tweaks to the recent congestion mgmt framework.
It also provides a significant eeh patch as well.

The patches were cut against Martin's 5.15/scsi-queue tree



James Smart (14):
  lpfc: Fix list_add corruption in lpfc_drain_txq
  lpfc: Don't release final kref on Fport node while ABTS outstanding
  lpfc: Fix premature rpi release for unsolicited TPLS and LS_RJT
  lpfc: Fix hang on unload due to stuck fport node
  lpfc: Fix rediscovery of tape device after issue lip
  lpfc: Don't remove ndlp on PRLI errors in P2P mode
  lpfc: Fix NVME I/O failover to non-optimized path
  lpfc: Fix FCP I/O flush functionality for TMF routines
  lpfc: Fix EEH support for NVME I/O
  lpfc: Adjust bytes received vales during cmf timer interval
  lpfc: Fix I/O block after enabling managed congestion mode
  lpfc: Zero CGN stats only during initial driver load and stat reset
  lpfc: Improve PBDE checks during SGL processing
  lpfc: Update lpfc version to 14.0.0.2

 drivers/scsi/lpfc/lpfc.h         |   1 +
 drivers/scsi/lpfc/lpfc_els.c     |  41 +++++++--
 drivers/scsi/lpfc/lpfc_hbadisc.c |  32 +++++--
 drivers/scsi/lpfc/lpfc_init.c    |  49 +++++++++--
 drivers/scsi/lpfc/lpfc_nvme.c    |  70 +++++++++++++---
 drivers/scsi/lpfc/lpfc_nvmet.c   |  44 +++++-----
 drivers/scsi/lpfc/lpfc_scsi.c    |  92 ++++++++++++--------
 drivers/scsi/lpfc/lpfc_sli.c     | 139 +++++++++++++++++++++++++------
 drivers/scsi/lpfc/lpfc_sli4.h    |   2 +
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 10 files changed, 353 insertions(+), 119 deletions(-)

-- 
2.26.2

