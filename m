Return-Path: <SRS0=6nW3=D2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3174C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 19:19:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9417622283
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Oct 2020 19:19:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731083AbgJSTTf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Oct 2020 15:19:35 -0400
Received: from smtp.infotech.no ([82.134.31.41]:56022 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730938AbgJSTTf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Oct 2020 15:19:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 5ABDC204248;
        Mon, 19 Oct 2020 21:19:32 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id M1MqUhragf6R; Mon, 19 Oct 2020 21:19:32 +0200 (CEST)
Received: from xtwo70.bingwo.ca (vpn.infotech.no [82.134.31.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 0AF2520414F;
        Mon, 19 Oct 2020 21:19:30 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     martin.petersen@oracle.com, axboe@kernel.dk, bvanassche@acm.org,
        bostroesser@gmail.com
Subject: [PATCH v3 0/4] scatterlist: add new capabilities
Date:   Mon, 19 Oct 2020 15:19:24 -0400
Message-Id: <20201019191928.77845-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Scatter-gather lists (sgl_s) are frequently used as data carriers in
the block layer. For example the SCSI and NVMe subsystems interchange
data with the block layer using sgl_s. The sgl API is declared in
<linux/scatterlist.h>

The author has extended these transient sgl use cases to a store (i.e.
a ramdisk) in the scsi_debug driver. Other new potential uses of sgl_s
could be for caches. When this extra step is taken, the need to copy
between sgl_s becomes apparent. The patchset adds sgl_copy_sgl() and
two other sgl operations.

The existing sgl_alloc_order() function can be seen as a replacement
for vmalloc() for large, long-term allocations.  For what seems like
no good reason, sgl_alloc_order() currently restricts its total
allocation to less than or equal to 4 GiB. vmalloc() has no such
restriction.

Changes since v2 [posted 20201018]:
  - remove unneeded lines from sgl_memset() definition.
  - change sg_zero_buffer() to call sgl_memset() as the former
    is a subset.

Changes since v1 [posted 20201016]:
  - Bodo Stroesser pointed out a problem with the nesting of
    kmap_atomic() [called via sg_miter_next()] and kunmap_atomic()
    calls [called via sg_miter_stop()] and proposed a solution that
    simplifies the previous code.

  - the new implementation of the three functions has shorter periods
    when pre-emption is disabled (but has more them). This should
    make operations on large sgl_s more pre-emption "friendly" with
    a relatively small performance hit.

  - sgl_memset return type changed from void to size_t and is the
    number of bytes actually (over)written. That number is needed
    anyway internally so may as well return it as it may be useful to
    the caller.

This patchset is against lk 5.9.0

Douglas Gilbert (4):
  sgl_alloc_order: remove 4 GiB limit, sgl_free() warning
  scatterlist: add sgl_copy_sgl() function
  scatterlist: add sgl_compare_sgl() function
  scatterlist: add sgl_memset()

 include/linux/scatterlist.h |  12 +++
 lib/scatterlist.c           | 186 +++++++++++++++++++++++++++++++++---
 2 files changed, 184 insertions(+), 14 deletions(-)

-- 
2.25.1

