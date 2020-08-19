Return-Path: <SRS0=XqvZ=B5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F4BC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3630F208C7
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Aug 2020 15:25:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728764AbgHSPZV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Aug 2020 11:25:21 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:38870 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728212AbgHSPZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Aug 2020 11:25:09 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 88887990BD3CA5378D3B;
        Wed, 19 Aug 2020 23:24:58 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 19 Aug 2020 23:24:47 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <dgilbert@interlog.com>,
        <paolo.valente@linaro.org>, <hare@suse.de>, <hch@lst.de>
CC:     <sumit.saxena@broadcom.com>, <linux-block@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <megaraidlinux.pdl@broadcom.com>,
        <chenxiang66@hisilicon.com>, <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH v8 00/18] blk-mq/scsi: Provide hostwide shared tags for SCSI HBAs
Date:   Wed, 19 Aug 2020 23:20:18 +0800
Message-ID: <1597850436-116171-1-git-send-email-john.garry@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.58]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

Here is v8 of the patchset.

In this version of the series, we keep the shared sbitmap for driver tags,
and introduce changes to fix up the tag budgeting across request queues.
We also have a change to count requests per-hctx for when an elevator is
enabled, as an optimisation. I also dropped the debugfs changes - more on
that below.

Some performance figures:

Using 12x SAS SSDs on hisi_sas v3 hw. mq-deadline results are included,
but it is not always an appropriate scheduler to use.

Tag depth 		4000 (default)			260**

Baseline (v5.9-rc1):
none sched:		2094K IOPS			513K
mq-deadline sched:	2145K IOPS			1336K

Final, host_tagset=0 in LLDD *, ***:
none sched:		2120K IOPS			550K
mq-deadline sched:	2121K IOPS			1309K

Final ***:
none sched:		2132K IOPS			1185			
mq-deadline sched:	2145K IOPS			2097	

* this is relevant as this is the performance in supporting but not
  enabling the feature
** depth=260 is relevant as some point where we are regularly waiting for
   tags to be available. Figures were are a bit unstable here.
*** Included "[PATCH V4] scsi: core: only re-run queue in
    scsi_end_request() if device queue is busy"

A copy of the patches can be found here:
https://github.com/hisilicon/kernel-dev/tree/private-topic-blk-mq-shared-tags-v8

The hpsa patch depends on:
https://lore.kernel.org/linux-scsi/20200430131904.5847-1-hare@suse.de/

And the smartpqi patch is not to be accepted.

Comments (and testing) welcome, thanks!

Differences to v7:
- Add null_blk and scsi_debug support
- Drop debugfs tags patch - it's too difficult to be the same between
hostwide and non-hostwide, as discussed:
https://lore.kernel.org/linux-scsi/1591810159-240929-1-git-send-email-john.garry@huawei.com/T/#mb3eb462d8be40273718505989abd12f8228c15fd
And from commit 6bf0eb550452 ("sbitmap: Consider cleared bits in
sbitmap_bitmap_show()"), I guess not many used this anyway...
- Add elevator per-hctx request count for optimisation
- Break up "blk-mq: rename blk_mq_update_tag_set_depth()" into 2x patches
- Pass flags for avoid per-hq queue tags init/free for hostwide tags
- Add Don's reviewed-tag and tested-by tags to appropiate patches
	- (@Don, please let me know if issue with how I did this)
- Add "scsi: core: Show nr_hw_queues in sysfs"
- Rework megaraid SAS patch to have module param (Kashyap)
- rebase

V7 is here for more info:
https://lore.kernel.org/linux-scsi/1591810159-240929-1-git-send-email-john.garry@huawei.com/T/#t

Hannes Reinecke (5):
  blk-mq: Rename blk_mq_update_tag_set_depth()
  blk-mq: Free tags in blk_mq_init_tags() upon error
  scsi: Add host and host template flag 'host_tagset'
  hpsa: enable host_tagset and switch to MQ
  smartpqi: enable host tagset

John Garry (10):
  blk-mq: Pass flags for tag init/free
  blk-mq: Use pointers for blk_mq_tags bitmap tags
  blk-mq: Facilitate a shared sbitmap per tagset
  blk-mq: Relocate hctx_may_queue()
  blk-mq: Record nr_active_requests per queue for when using shared
    sbitmap
  blk-mq: Record active_queues_shared_sbitmap per tag_set for when using
    shared sbitmap
  null_blk: Support shared tag bitmap
  scsi: core: Show nr_hw_queues in sysfs
  scsi: hisi_sas: Switch v3 hw to MQ
  scsi: scsi_debug: Support host tagset

Kashyap Desai (2):
  blk-mq, elevator: Count requests per hctx to improve performance
  scsi: megaraid_sas: Added support for shared host tagset for
    cpuhotplug

Ming Lei (1):
  blk-mq: Rename BLK_MQ_F_TAG_SHARED as BLK_MQ_F_TAG_QUEUE_SHARED

 block/bfq-iosched.c                         |   9 +-
 block/blk-core.c                            |   2 +
 block/blk-mq-debugfs.c                      |  10 +-
 block/blk-mq-sched.c                        |  13 +-
 block/blk-mq-tag.c                          | 149 ++++++++++++++------
 block/blk-mq-tag.h                          |  56 +++-----
 block/blk-mq.c                              |  81 +++++++----
 block/blk-mq.h                              |  76 +++++++++-
 block/kyber-iosched.c                       |   4 +-
 block/mq-deadline.c                         |   6 +
 drivers/block/null_blk_main.c               |   6 +
 drivers/block/rnbd/rnbd-clt.c               |   2 +-
 drivers/scsi/hisi_sas/hisi_sas.h            |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c       |  36 ++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  87 +++++-------
 drivers/scsi/hosts.c                        |   1 +
 drivers/scsi/hpsa.c                         |  44 +-----
 drivers/scsi/hpsa.h                         |   1 -
 drivers/scsi/megaraid/megaraid_sas_base.c   |  39 +++++
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  29 ++--
 drivers/scsi/scsi_debug.c                   |  28 ++--
 drivers/scsi/scsi_lib.c                     |   2 +
 drivers/scsi/scsi_sysfs.c                   |  11 ++
 drivers/scsi/smartpqi/smartpqi_init.c       |  45 ++++--
 include/linux/blk-mq.h                      |  13 +-
 include/linux/blkdev.h                      |   3 +
 include/scsi/scsi_host.h                    |   9 +-
 27 files changed, 484 insertions(+), 281 deletions(-)

-- 
2.26.2

