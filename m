Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51907C433DB
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:17:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 159AE207A5
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:17:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbhACARa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbhACAR3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 19:17:29 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3111EC061573
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jan 2021 16:16:49 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id j1so12543135pld.3
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jan 2021 16:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dUKPz+4QMVkDe4xyjWEfJ1b+qZJGTxkH3ug+qHHAsCY=;
        b=rULD3egc0oraoDO1iu3ZZYBKk301nfQKCU5Mvu4uD4yLwIxNZeT0yL4QxVWHMiTz4h
         9qvitevPpHMYkeemyn3jbOD7+Y0XebCEordUoBR/KqxBHh2UbMHXeWp4r6SYyx+hM9Nj
         UEfHG7i9wPX5hQcal86N2w/7ud+dyg+cedMoXFWG+HRF+8vslY5YTbou6+Gr/aCIVbyf
         A4HX2dm/xbnEVQiUdCxqPHsL68C8kVSWioJGGnbwELjPpWjN3zoQqZzcGULxkIgmvjXV
         GrNBwKx3L8plyCMZDoIykxSxlKcqs8G6xZnVizAkw6lnWxS/29SvxDzS0/iMD9j1QblV
         kC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dUKPz+4QMVkDe4xyjWEfJ1b+qZJGTxkH3ug+qHHAsCY=;
        b=PjyoF/YeHg8cQuzmtGnhihg7jwtTairkhMbMwLq79l1trEvVvskBDtyte+FOHcgheL
         jgqJ4lbUzmN6uPc1zHHrRY0NcGd0oFByQ6GPZMwaLoO5/iSYFrXbExDu+9a88WVbjG+5
         LqRpO1vqL7hYiBclaWcbOONp5aXN/YE5bi/AWeRqb6GO9x/CCbuyyTwXsKOzrmt1TD/z
         MQDu6hVNs0/1H10IqUxUTvRkGq3nfZS1fCQWwI4/oeY6d0c+tOshA1IpDQnqnRJyxEGZ
         uXzQiCav/7+9ZakVeISfO+CXHXeVbTx3wT73HEvG0RCBjRlyUjMAa5FMN33zp1yGOw3G
         X8Wg==
X-Gm-Message-State: AOAM532DWEmJIA9Vpwb2AC00jy1cz4dhxwW/3TxZSysNkhmTZudqMc8K
        P8S824yQPJLj8ZCetHzkC5vxJpNvvgg=
X-Google-Smtp-Source: ABdhPJzB8VU7mASeWImbMxBRcGPiaFYSk7xgfaZ+4XehVOL6LX+DVpUVlxbjYBHKEbJV8tGk8i8acQ==
X-Received: by 2002:a17:902:502:b029:db:fa52:c19 with SMTP id 2-20020a1709020502b02900dbfa520c19mr41491267plf.70.1609633008581;
        Sat, 02 Jan 2021 16:16:48 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm55671867pgj.24.2021.01.02.16.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 16:16:48 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/15] lpfc: Update lpfc to revision 12.8.0.7
Date:   Sat,  2 Jan 2021 16:16:24 -0800
Message-Id: <20210103001639.1995-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.8.0.7

This patch set contains fixes and a cleanup of trace logging.

The patches were cut against Martin's 5.11/scsi-queue tree

James Smart (15):
  lpfc: Fix PLOGI S_ID of 0 on pt2pt config
  lpfc: Fix auto sli_mode and its effect on CONFIG_PORT for SLI3
  lpfc: Refresh ndlp when a new PRLI is received in the PRLI issue state
  lpfc: Fix crash when a fabric node is released prematurely.
  lpfc: Use the nvme-fc transport supplied timeout for LS requests
  lpfc: Fix FW reset action if IOs are outstanding
  lpfc: Prevent duplicate requests to unregister with cpuhp framework
  lpfc: Fix error log messages being logged following scsi task mgnt
  lpfc: Fix target reset failing
  lpfc: Fix NVME recovery after mailbox timeout
  lpfc: Fix vport create logging
  lpfc: Fix crash when nvmet transport calls host_release
  lpfc: Implement health checking when aborting io
  lpfc: Enhancements to LOG_TRACE_EVENT for better readability
  lpfc: Update lpfc version to 12.8.0.7

 drivers/scsi/lpfc/lpfc.h           |   4 +-
 drivers/scsi/lpfc/lpfc_attr.c      |   9 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   6 +-
 drivers/scsi/lpfc/lpfc_disc.h      |  15 +-
 drivers/scsi/lpfc/lpfc_els.c       |  47 +++---
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  21 ++-
 drivers/scsi/lpfc/lpfc_init.c      | 241 +++++++++++++++++++----------
 drivers/scsi/lpfc/lpfc_nportdisc.c |  21 ++-
 drivers/scsi/lpfc/lpfc_nvme.c      |  45 +++---
 drivers/scsi/lpfc/lpfc_nvmet.c     |  33 +++-
 drivers/scsi/lpfc/lpfc_scsi.c      |  58 ++++++-
 drivers/scsi/lpfc/lpfc_sli.c       | 141 +++++++++++------
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   2 +-
 14 files changed, 436 insertions(+), 209 deletions(-)

-- 
2.26.2

