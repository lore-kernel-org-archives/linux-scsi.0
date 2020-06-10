Return-Path: <SRS0=mOiQ=7X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65FFC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1C302072E
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Jun 2020 17:33:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgFJRda (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Jun 2020 13:33:30 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5805 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726257AbgFJRda (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 10 Jun 2020 13:33:30 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E34FD4BC502FEA3BDBA1;
        Thu, 11 Jun 2020 01:33:26 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 11 Jun 2020 01:33:17 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>, <hare@suse.com>,
        <hch@lst.de>, <shivasharan.srikanteshwara@broadcom.com>
CC:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v7 00/12] blk-mq/scsi: Provide hostwide shared tags for SCSI HBAs
Date:   Thu, 11 Jun 2020 01:29:07 +0800
Message-ID: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
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

Here is v7 of the patchset.

In this version of the series, we keep the shared sbitmap for driver tags,
and introduce changes to fix up the tag budgeting across request queues (
and associated debugfs changes).

Some performance figures:

Using 12x SAS SSDs on hisi_sas v3 hw. mq-deadline results are included,
but it is not always an appropriate scheduler to use.

Tag depth 		4000 (default)			260**

Baseline:
none sched:		2290K IOPS			894K
mq-deadline sched:	2341K IOPS			2313K

Final, host_tagset=0 in LLDD*
none sched:		2289K IOPS			703K
mq-deadline sched:	2337K IOPS			2291K

Final:
none sched:		2281K IOPS			1101K
mq-deadline sched:	2322K IOPS			1278K

* this is relevant as this is the performance in supporting but not
  enabling the feature
** depth=260 is relevant as some point where we are regularly waiting for
   tags to be available. Figures were are a bit unstable here for testing.

A copy of the patches can be found here:
https://github.com/hisilicon/kernel-dev/commits/private-topic-blk-mq-shared-tags-rfc-v7

And to progress this series, we the the following to go in first, when ready:
https://lore.kernel.org/linux-scsi/20200430131904.5847-1-hare@suse.de/

Comments welcome, thanks!

Differences to v6:
- tag budgeting across request queues and associated changes
- add any reviewed tags
- rebase
- I did not include any change related to updating shared sbitmap per-hctx
  wait pointer, based on lack of evidence of performance improvement. This
  was discussed here originally:
  https://lore.kernel.org/linux-scsi/ecaeccf029c6fe377ebd4f30f04df9f1@mail.gmail.com/
  I may revisit.

Differences to v5:
- For now, drop the shared scheduler tags
- Fix megaraid SAS queue selection and rebase
- Omit minor unused arguments patch, which has now been merged
- Add separate patch to introduce sbitmap pointer
- Fixed hctx_tags_bitmap_show() for shared sbitmap
- Various tidying

Hannes Reinecke (5):
  blk-mq: rename blk_mq_update_tag_set_depth()
  scsi: Add template flag 'host_tagset'
  megaraid_sas: switch fusion adapters to MQ
  smartpqi: enable host tagset
  hpsa: enable host_tagset and switch to MQ

John Garry (6):
  blk-mq: Use pointers for blk_mq_tags bitmap tags
  blk-mq: Facilitate a shared sbitmap per tagset
  blk-mq: Record nr_active_requests per queue for when using shared
    sbitmap
  blk-mq: Record active_queues_shared_sbitmap per tag_set for when using
    shared sbitmap
  blk-mq: Add support in hctx_tags_bitmap_show() for a shared sbitmap
  scsi: hisi_sas: Switch v3 hw to MQ

Ming Lei (1):
  blk-mq: rename BLK_MQ_F_TAG_SHARED as BLK_MQ_F_TAG_QUEUE_SHARED

 block/bfq-iosched.c                         |   4 +-
 block/blk-core.c                            |   2 +
 block/blk-mq-debugfs.c                      | 120 ++++++++++++++-
 block/blk-mq-tag.c                          | 157 ++++++++++++++------
 block/blk-mq-tag.h                          |  21 ++-
 block/blk-mq.c                              |  64 +++++---
 block/blk-mq.h                              |  33 +++-
 block/kyber-iosched.c                       |   4 +-
 drivers/scsi/hisi_sas/hisi_sas.h            |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c       |  36 ++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  87 +++++------
 drivers/scsi/hpsa.c                         |  44 +-----
 drivers/scsi/hpsa.h                         |   1 -
 drivers/scsi/megaraid/megaraid_sas.h        |   1 -
 drivers/scsi/megaraid/megaraid_sas_base.c   |  59 +++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  24 +--
 drivers/scsi/scsi_lib.c                     |   2 +
 drivers/scsi/smartpqi/smartpqi_init.c       |  38 +++--
 include/linux/blk-mq.h                      |   9 +-
 include/linux/blkdev.h                      |   3 +
 include/scsi/scsi_host.h                    |   6 +-
 21 files changed, 463 insertions(+), 255 deletions(-)

-- 
2.26.2

