Return-Path: <SRS0=iJzJ=DX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4944AC433E7
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 04:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01E552087D
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Oct 2020 04:53:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388441AbgJPExM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Oct 2020 00:53:12 -0400
Received: from smtp.infotech.no ([82.134.31.41]:44927 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726305AbgJPExI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Oct 2020 00:53:08 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1413D20423B;
        Fri, 16 Oct 2020 06:53:07 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BGf+GG0cu-O0; Fri, 16 Oct 2020 06:53:01 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 07D41204191;
        Fri, 16 Oct 2020 06:52:59 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org
Subject: [PATCH 0/4] scatterlist: add new capabilities
Date:   Fri, 16 Oct 2020 00:52:54 -0400
Message-Id: <20201016045258.16246-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Scatter-gather lists (sgl_s) are frequently used as data
carriers in the block layer. For example the SCSI and NVMe
subsystems interchange data with the block layer using
sgl_s. The sgl API is declared in <linux/scatterlist.h>

The author has extended these transient sgl use cases to
a store (i.e. ramdisk) in the scsi_debug driver. Other new
potential uses of sgl_s could be for caches. When this extra
step is taken, the need to copy between sgl_s becomes apparent.
The patchset adds sgl_copy_sgl() and a few other sgl
operations.

The existing sgl_alloc_order() function can be seen as a
replacement for vmalloc() for large, long-term allocations.
For what seems like no good reason, sgl_alloc_order()
currently restricts its total allocation to less than or
equal to 4 GiB. vmalloc() has no such restriction.

This patchset is against lk 5.9.0

Douglas Gilbert (4):
  sgl_alloc_order: remove 4 GiB limit, sgl_free() warning
  scatterlist: add sgl_copy_sgl() function
  scatterlist: add sgl_compare_sgl() function
  scatterlist: add sgl_memset()

 include/linux/scatterlist.h |  12 +++
 lib/scatterlist.c           | 204 +++++++++++++++++++++++++++++++++++-
 2 files changed, 213 insertions(+), 3 deletions(-)

-- 
2.25.1

