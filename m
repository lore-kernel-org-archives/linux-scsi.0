Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8FEC17447
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 13:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A647522466
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 13:40:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbfKMNk3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 08:40:29 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:40766 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727129AbfKMNk3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 08:40:29 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 226C13C6C4E38D3107F6;
        Wed, 13 Nov 2019 21:40:24 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.439.0; Wed, 13 Nov 2019 21:40:14 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <ming.lei@redhat.com>,
        <hare@suse.com>, <bvanassche@acm.org>, <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC 0/5] blk-mq/scsi: Provide hostwide shared tags for SCSI HBAs
Date:   Wed, 13 Nov 2019 21:36:44 +0800
Message-ID: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is a 2nd stab at solving the problem of hostwide shared tags for SCSI
HBAs.

As discussed previously, Ming Lei's most recent series in [0] to use
hctx[0] tags for all hctx for a host was a bit messy and intrusive, so seen
as a no go. Indeed, blk-mq is designed for separate tags per hctx.

This series introduces a different approach to solve that problem, in
keeping the per-hctx tags but introducing a new separate shared set of
tags, which SCSI HBAs can use for a hostwide tags.

Adding support for shared tags should not have a significant performance
impact for when shared tags are not requested.

Currently I just fixed up the hisi_sas driver to use the shared tags,
but should not be much trouble to change others over.

Patch #3 is quite experimental at this point. I also threw in a minor
tidy-up patch.

[0] https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@redhat.com/

Hannes Reinecke (1):
  scsi: Add template flag 'host_tagset'

John Garry (3):
  blk-mq: Remove some unused function arguments
  blk-mq: Facilitate a shared tags per tagset
  scsi: hisi_sas: Switch v3 hw to MQ

Ming Lei (1):
  blk-mq: rename BLK_MQ_F_TAG_SHARED as BLK_MQ_F_TAG_QUEUE_SHARED

 block/blk-core.c                       |  1 +
 block/blk-flush.c                      |  2 +
 block/blk-mq-debugfs.c                 |  4 +-
 block/blk-mq-tag.c                     | 91 +++++++++++++++++++++++++-
 block/blk-mq-tag.h                     |  8 +--
 block/blk-mq.c                         | 91 +++++++++++++++++++-------
 block/blk-mq.h                         | 11 +++-
 drivers/scsi/hisi_sas/hisi_sas.h       |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 43 ++++++------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 85 ++++++++++--------------
 drivers/scsi/scsi_lib.c                |  2 +
 include/linux/blk-mq.h                 |  5 +-
 include/linux/blkdev.h                 |  1 +
 include/scsi/scsi_host.h               |  3 +
 14 files changed, 242 insertions(+), 108 deletions(-)

-- 
2.17.1

