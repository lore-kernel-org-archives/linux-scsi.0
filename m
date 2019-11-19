Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F18C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 14:31:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBF6F222B0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 14:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbfKSObO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 09:31:14 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7144 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727809AbfKSObN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 09:31:13 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A42F9476A658ABD8810A;
        Tue, 19 Nov 2019 22:31:08 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Tue, 19 Nov 2019 22:30:58 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <hare@suse.com>, <bvanassche@acm.org>, <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v2 0/5] blk-mq/scsi: Provide hostwide shared tags for SCSI HBAs
Date:   Tue, 19 Nov 2019 22:27:33 +0800
Message-ID: <1574173658-76818-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is another stab at solving the problem of hostwide shared tags for SCSI
HBAs.

As discussed previously, Ming Lei's most recent series in [0] to use
hctx[0] tags for all hctx for a host was a bit messy and intrusive, so seen
as a no go. Indeed, blk-mq is designed for separate tags per hctx.

Bart also followed up on my v1 RFC with another implementation along those
same lines, which was neater, but I am concerned that the change in this
approach may cause issues - see [1].

This series introduces a different approach to solve that problem, in
keeping the per-hctx tags but introducing a new separate sbitmap per
tagset. The shared sbitmap is used to generate a unique tag over all hctx per
tagset.

Currently I just fixed up the hisi_sas driver to use the shared tags,
but should not be much trouble to change others over.

Patch #3 is still quite experimental at this point - I added some code
comments on this. I also threw in a minor tidy-up patch.

[0] https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@redhat.com/
[1] https://lore.kernel.org/linux-block/ff77beff-5fd9-9f05-12b6-826922bace1f@huawei.com/T/#m3db0a602f095cbcbff27e9c884d6b4ae826144be

Differences to v1:
- Use a shared sbitmap, and not a separate shared tags (a big change!)
	- Drop request.shared_tag
- Add RB tags

Hannes Reinecke (1):
  scsi: Add template flag 'host_tagset'

John Garry (3):
  blk-mq: Remove some unused function arguments
  blk-mq: Facilitate a shared sbitmap per tagset
  scsi: hisi_sas: Switch v3 hw to MQ

Ming Lei (1):
  blk-mq: rename BLK_MQ_F_TAG_SHARED as BLK_MQ_F_TAG_QUEUE_SHARED

 block/bfq-iosched.c                    |  4 +-
 block/blk-mq-debugfs.c                 |  6 +-
 block/blk-mq-sched.c                   | 14 +++++
 block/blk-mq-tag.c                     | 80 +++++++++++++++++------
 block/blk-mq-tag.h                     | 18 ++++--
 block/blk-mq.c                         | 87 ++++++++++++++++++++------
 block/blk-mq.h                         |  7 ++-
 block/kyber-iosched.c                  |  4 +-
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 36 ++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 86 +++++++++++--------------
 drivers/scsi/scsi_lib.c                |  2 +
 include/linux/blk-mq.h                 |  9 ++-
 include/scsi/scsi_host.h               |  3 +
 14 files changed, 239 insertions(+), 120 deletions(-)

-- 
2.17.1

