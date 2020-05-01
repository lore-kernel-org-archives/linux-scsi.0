Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 392EDC35280
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12FB4208DB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 21:43:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fp0U7+jU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgEAVnY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 17:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgEAVnX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 May 2020 17:43:23 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5CCC061A0C
        for <linux-scsi@vger.kernel.org>; Fri,  1 May 2020 14:43:21 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id h4so1205110wmb.4
        for <linux-scsi@vger.kernel.org>; Fri, 01 May 2020 14:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gytlLC8bm4rPGSzH3jzkD5AsZBCv7wTUI+4ynCwD+zg=;
        b=fp0U7+jUy3Ky6jvvPcCBeWhPLA0z+d5dT1cWpovHdwlpxNuPhvvitimzZMEalcnf/w
         9Pa87AoG3JPA4Ynl1aa4HWbuS2eE7ZsGskvekro5IZewtefHiR/m/wuconFG9R/gTSIJ
         E4ZqOK8tKxL98mQF+ZtowZ0TMOoWglLnEJO0JKj9ee1dcnxbPTz/jaq9A5Alc12u9s5J
         of2ezOdthUv0n1gYObSDsGmqIDi2VoDfLvo1OMqlckDxlMECwI8zWE4FJi2Yk/7M77EA
         6kTOFxsoLWBniIiIrLvxIy6Wqs+Lm580bAKRqnLB8xEl+xFaXCaWXRUEutLtbTyHG+R4
         Mtnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gytlLC8bm4rPGSzH3jzkD5AsZBCv7wTUI+4ynCwD+zg=;
        b=VMBozUAG5pZW5EQ5xARS1fV9qnCQTduu5CKrJ+tBTG+Ka9uSDyKd0gO+2KJwasQZgd
         s93CielIRm+IIA7k10NFDvJfImWltVa4bag3Y3H1EbJwaQZLJeKupECfV4I0Rdfwg3qY
         3O/h91S9kp1N7sR4aUCTa6T6vAZrh6ZCH5GYOVrBtVjykKkh9L3YUXOcahzQHpFSPF4n
         roa64Lq8sHWvGoGJk/eSKwSvASkf1HA8TcR6YCRDoiA7gekf/mKoEIk4+zats15HgbvN
         qYmGhRrPopXtuhhxnD4N+wMg/PvzDHwKLbWN6uvvf5tk0kW7YjrBYisOnG5GW+1EKapT
         WIYw==
X-Gm-Message-State: AGi0PuaeQ+ITcGe3yodVaw2zb8hegBw6iv22ax5bjWKvpAh64UKk0Qqn
        PdyPVDIDAw7n4uy7MyM0QZUpynGQ
X-Google-Smtp-Source: APiQypIr6tzxENV9kMq3PYMnmA2RJUdx/kKMtGqGc8mBJw0HNJ/B9uFmKGoDJhGngP0qnpaN+5uRJA==
X-Received: by 2002:a1c:bc05:: with SMTP id m5mr1349381wmf.143.1588369400406;
        Fri, 01 May 2020 14:43:20 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t2sm1207734wmt.15.2020.05.01.14.43.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 May 2020 14:43:19 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/9] lpfc: Update lpfc to revision 12.8.0.1
Date:   Fri,  1 May 2020 14:43:01 -0700
Message-Id: <20200501214310.91713-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.1

Patch set contains several small fixes, code cleanups, a change to
default number of hdwqs at init, and a sync of devloss with the
nvme-fc transport.

The patches were cut against Martin's 5.8/scsi-queue tree

James Smart (9):
  lpfc: Synchronize NVME transport and lpfc driver devloss_tmo
  lpfc: Maintain atomic consistency of queue_claimed flag
  lpfc: Remove re-binding of nvme rport during registration
  lpfc: Fix negation of else clause in lpfc_prep_node_fc4type
  lpfc: Change default queue allocation for reduced memory consumption
  lpfc: Remove unnecessary lockdep_assert_held calls
  lpfc: Fix noderef and address space warnings
  lpfc: Fix MDS Diagnostic Enablement definition
  lpfc: Update lpfc version to 12.8.0.1

 drivers/scsi/lpfc/lpfc.h         |  23 +++++--
 drivers/scsi/lpfc/lpfc_attr.c    | 106 ++++++++++++++++++++++++-------
 drivers/scsi/lpfc/lpfc_ct.c      |   1 -
 drivers/scsi/lpfc/lpfc_debugfs.c |   3 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c |   8 +--
 drivers/scsi/lpfc/lpfc_hw4.h     |   2 +-
 drivers/scsi/lpfc/lpfc_init.c    |  82 ++++++++++--------------
 drivers/scsi/lpfc/lpfc_mbox.c    |   3 +-
 drivers/scsi/lpfc/lpfc_nvme.c    |  33 +---------
 drivers/scsi/lpfc/lpfc_sli.c     |  45 ++++++-------
 drivers/scsi/lpfc/lpfc_sli4.h    |   2 +-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 12 files changed, 168 insertions(+), 142 deletions(-)

-- 
2.26.1

