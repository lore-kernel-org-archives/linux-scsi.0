Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2871FC4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:31:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02528233A0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 13:31:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbgLGNbP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 08:31:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:34058 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgLGNbP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 08:31:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1607347829; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=TlW6LRYzNqv2k8YiMXo4C8ho53DA5MhvO4sDaaIu7G8=;
        b=Isny2xaeNXr0QwvWgDPZvWhlph9aEdARWAGMR8XD8mIwJQVGDRljPeuqNDCgqaNncogi7U
        kExKzaMsp3RukRSg9ga3/hbaAlEjkMHMsOZBAa9to1CWegHsRMFs8r6bfuK7vxPsMa92G0
        EoXiC//R5iM0/X6/MTVWmbjDGY0eTzI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 04B78AB63;
        Mon,  7 Dec 2020 13:30:29 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Subject: [PATCH 0/2] xen: fix using ZONE_DEVICE memory for foreign mappings
Date:   Mon,  7 Dec 2020 14:30:22 +0100
Message-Id: <20201207133024.16621-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fix an issue found in dom0 when running on a host with NVMe.

Juergen Gross (2):
  xen: add helpers for caching grant mapping pages
  xen: don't use page->lru for ZONE_DEVICE memory

 drivers/block/xen-blkback/blkback.c |  89 ++++----------------
 drivers/block/xen-blkback/common.h  |   4 +-
 drivers/block/xen-blkback/xenbus.c  |   6 +-
 drivers/xen/grant-table.c           | 123 ++++++++++++++++++++++++++++
 drivers/xen/unpopulated-alloc.c     |  20 +++--
 drivers/xen/xen-scsiback.c          |  60 +++-----------
 include/xen/grant_table.h           |  17 ++++
 7 files changed, 182 insertions(+), 137 deletions(-)

-- 
2.26.2

