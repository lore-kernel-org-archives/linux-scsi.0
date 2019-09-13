Return-Path: <SRS0=Er8N=XI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F5ABC49ED7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF4CD206BB
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Sep 2019 13:05:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="bSJWZ1Cd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729766AbfIMNFD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Sep 2019 09:05:03 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:42720 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfIMNFD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2019 09:05:03 -0400
Received: by mail-pl1-f180.google.com with SMTP id e5so2166335pls.9
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2019 06:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=v2wg6lMQIZKOaikaxSrH60ne9KKYtn5dhZ02GifaYdc=;
        b=bSJWZ1Cd1hb4JRO22sCx3fKM+7QOjKppa1GMqe5FuOra4cTf6dTwdp5Hh18GpZAQlV
         fXr05UMNn632qGI18VK61nIEzpA9qid+SrBEfe1zm9JAOYGsv1cFMwAULJAq546JAt0B
         y0QStQvCh9uQgV0cqC/lKxz3leCXqsCQMM3Zo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=v2wg6lMQIZKOaikaxSrH60ne9KKYtn5dhZ02GifaYdc=;
        b=reDOSRHRJd9wEWc6LL9KKxZ8RDMj+AclqKqWDsKoQQRqYE9SWnxuVsyIBirutJQBl/
         qfdJnJcKtBHp3lA1Sll2tgpHPdjZjkPKhMLcadP73c4t6RjwPEfEr+DvzZIkp9/mC/ke
         izshoLvqILC1pF+4OKW9+7XGcTm8XBjWg6D1MH4mG4QHR1ciJ21gTYbCQd4gdcavVPZF
         EHCbUBa/nuZP0mud1M+f4GcRxdNuoknUE0PF1sWmPGoKTdL39wnXQvDep97mFxIAPhzu
         /X1uOY9ifPqOqO672TFV1hakFQHKJY2R6BehCWEFyjaTM5I4mlk9Umi97u0pjjxG/Gc4
         4Emw==
X-Gm-Message-State: APjAAAXdBRxMCRpzlw0wCtAvR9momdvmRHXYhIc90khoYBLP5K6ESSf9
        RqdkuzBKrca5z/+NF8+SN5sOww==
X-Google-Smtp-Source: APXvYqy7thoWLcgGXP04v6QgP7g9oXenlivMXC94WGeHNkmq092+efsAhSvwFQWULePWpWpCJspF/g==
X-Received: by 2002:a17:902:8202:: with SMTP id x2mr48832333pln.182.1568379901209;
        Fri, 13 Sep 2019 06:05:01 -0700 (PDT)
Received: from dhcp-10-123-20-15.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 69sm37208841pfb.145.2019.09.13.06.04.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Sep 2019 06:05:00 -0700 (PDT)
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, suganath-prabu.subramani@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 00/13] Enhancements w.r.t to diag buffer and few bug fixes
Date:   Fri, 13 Sep 2019 09:04:37 -0400
Message-Id: <1568379890-18347-1-git-send-email-sreekanth.reddy@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series contains enhancements w.r.t to diag buffer support
and few bug fix patches.

Sreekanth Reddy (13):
  mpt3sas: Register trace buffer based on NVDATA settings
  mpt3sas: Display message before releasing diag buffer
  mpt3sas: Fix clear pending bit in ioctl status
  mpt3sas: Free diag buffer without any status check
  mpt3sas: Maintain ownership of diag buffer through UniqueID
  mpt3sas: clear release bit when diag buffer is re-registered
  mpt3sas: Reuse diag buffer which is allocated during load time
  mpt3sas: Add app owned flag support for diag buffer
  mpt3sas: Fail release cmnd if diag buffer is released
  mpt3sas: Use Component img header for getting Package version
  mpt3sas: Reject NVMe Encap commands to unsupported HBA's.
  mpt3sas: Fix module parameter max_msix_vectors
  mpt3sas: Bump mpt3sas driver version to 32.100.00.00

 drivers/scsi/mpt3sas/mpt3sas_base.c         |  36 ++-
 drivers/scsi/mpt3sas/mpt3sas_base.h         |  15 +-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          | 344 ++++++++++++++++++++++++----
 drivers/scsi/mpt3sas/mpt3sas_ctl.h          |   9 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |   2 +
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |  12 +-
 6 files changed, 358 insertions(+), 60 deletions(-)

-- 
1.8.3.1

