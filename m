Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8480BC3F2D1
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 11:59:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6773E20848
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 11:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgCEL7E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 06:59:04 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11151 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726990AbgCEL7E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Mar 2020 06:59:04 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id CE80E29236B20E110CB8;
        Thu,  5 Mar 2020 19:58:59 +0800 (CST)
Received: from localhost.localdomain (10.69.192.58) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Mar 2020 19:58:52 +0800
From:   John Garry <john.garry@huawei.com>
To:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <ming.lei@redhat.com>,
        <bvanassche@acm.org>, <hare@suse.de>, <don.brace@microsemi.com>,
        <sumit.saxena@broadcom.com>, <hch@infradead.org>,
        <kashyap.desai@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>
CC:     <chenxiang66@hisilicon.com>, <linux-block@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <esc.storagedev@microsemi.com>,
        John Garry <john.garry@huawei.com>
Subject: [PATCH RFC v6 00/10] blk-mq/scsi: Provide hostwide shared tags for SCSI HBAs
Date:   Thu, 5 Mar 2020 19:54:30 +0800
Message-ID: <1583409280-158604-1-git-send-email-john.garry@huawei.com>
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

Here is v6 of the patchset.

In this version of the series, we keep the shared sbitmap for driver tags,
but omit the shared scheduler tags for now - I did not think that this was
an essential feature and the premise was somewhat in doubt.

Comments welcome, thanks!

A copy of the patches can be found here:
https://github.com/hisilicon/kernel-dev/tree/private-topic-blk-mq-shared-tags-rfc-v6-upstream

Differences to v5:
- For now, drop the shared scheduler tags
- Fix megaraid SAS queue selection and rebase
- Omit minor unused arguments patch, which has now been merged
- Add separate patch to introduce sbitmap pointer
- Fixed hctx_tags_bitmap_show() for shared sbitmap
- Various tidying

Differences to v4:
- Rework scheduler tag allocations
- Revert back to the original implementation from John

Differences to v3:
- Include reviews from Ming Lei

Differences to v2:
- Drop embedded tag bitmaps
- Do not share scheduling tags
- Add patches for hpsa and smartpqi

Differences to v1:
- Use a shared sbitmap, and not a separate shared tags (a big change!)
	- Drop request.shared_tag
- Add RB tags

Hannes Reinecke (5):
  blk-mq: rename blk_mq_update_tag_set_depth()
  scsi: Add template flag 'host_tagset'
  megaraid_sas: switch fusion adapters to MQ
  smartpqi: enable host tagset
  hpsa: enable host_tagset and switch to MQ

John Garry (4):
  blk-mq: Use pointers for blk_mq_tags bitmap tags
  blk-mq: Facilitate a shared sbitmap per tagset
  blk-mq: Add support in hctx_tags_bitmap_show() for a shared sbitmap
  scsi: hisi_sas: Switch v3 hw to MQ

Ming Lei (1):
  blk-mq: rename BLK_MQ_F_TAG_SHARED as BLK_MQ_F_TAG_QUEUE_SHARED

 block/bfq-iosched.c                         |  4 +-
 block/blk-mq-debugfs.c                      | 65 ++++++++++++--
 block/blk-mq-tag.c                          | 97 ++++++++++++++-------
 block/blk-mq-tag.h                          | 21 +++--
 block/blk-mq.c                              | 60 +++++++++----
 block/blk-mq.h                              |  5 ++
 block/kyber-iosched.c                       |  4 +-
 drivers/scsi/hisi_sas/hisi_sas.h            |  3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c       | 36 ++++----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      | 87 ++++++++----------
 drivers/scsi/hpsa.c                         | 44 ++--------
 drivers/scsi/hpsa.h                         |  1 -
 drivers/scsi/megaraid/megaraid_sas.h        |  1 -
 drivers/scsi/megaraid/megaraid_sas_base.c   | 59 ++++---------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 24 ++---
 drivers/scsi/scsi_lib.c                     |  2 +
 drivers/scsi/smartpqi/smartpqi_init.c       | 38 +++++---
 include/linux/blk-mq.h                      |  5 +-
 include/scsi/scsi_host.h                    |  3 +
 19 files changed, 325 insertions(+), 234 deletions(-)

-- 
2.17.1

