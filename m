Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87208C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 12:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F1A86127A
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 12:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbhEMMGe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 08:06:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3747 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbhEMMGb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 08:06:31 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FgqyX3Xc4zqTdF;
        Thu, 13 May 2021 20:01:56 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.498.0; Thu, 13 May 2021 20:05:12 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <kashyap.desai@broadcom.com>, <chenxiang66@hisilicon.com>,
        <yama@redhat.com>, <dgilbert@interlog.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v3 0/2] blk-mq: Request queue-wide tags for shared sbitmap
Date:   Thu, 13 May 2021 20:00:56 +0800
Message-ID: <1620907258-30910-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is v3 of patch/series. I have spun off a new patch for tag allocation
refactoring.

Details are in commit messages.

Changes since v2:
- Spin off separate patch for tag allocation refactoring
- Combine sched shared sbitmap code into a single function

Changes since v1:
- Embed sbitmaps in request_queue struct
- Relocate IO sched functions to blk-mq-sched.c
- Fix error path code

Please retest, thanks! For some reason I could not recreate the original
issue, but I am using qemu...

John Garry (2):
  blk-mq: Some tag allocation code refactoring
  blk-mq: Use request queue-wide tags for tagset-wide sbitmap

 block/blk-mq-sched.c   | 67 ++++++++++++++++++++++++++++++++++--------
 block/blk-mq-sched.h   |  2 ++
 block/blk-mq-tag.c     | 65 +++++++++++++++++++++++-----------------
 block/blk-mq-tag.h     |  9 ++++--
 block/blk-mq.c         | 15 ++++++++--
 include/linux/blkdev.h |  4 +++
 6 files changed, 116 insertions(+), 46 deletions(-)

-- 
2.26.2

