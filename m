Return-Path: <SRS0=lopX=ZY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F74C432C3
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 15:39:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A35102146E
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Dec 2019 15:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfLBPj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Dec 2019 10:39:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:44684 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727431AbfLBPj2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Dec 2019 10:39:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6DB81C1A4;
        Mon,  2 Dec 2019 15:39:25 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v5 00/11] blk-mq/scsi: Provide hostwide shared tags for SCSI HBAs
Date:   Mon,  2 Dec 2019 16:39:03 +0100
Message-Id: <20191202153914.84722-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

here now is an updated version of the v2 patchset from John Garry,
including the suggestions and reviews from the mailing list.
John, apologies for hijacking your work :-)

For this version I've only added some slight modifications to Johns
original patch (renaming variables etc); the contentious separate sbitmap
allocation has been dropped in favour of Johns original version with pointers
to the embedded sbitmap.

But more importantly I've reworked the scheduler tag allocation after
discussions with Ming Lei.

Point is, hostwide shared tags can't really be resized; they surely
cannot be increased (as it's a hardware limitation), and even decreasing
is questionable as any modification here would affect all devices
served by this HBA.

Scheduler tags, OTOH, can be considered as per-queue, as the I/O scheduler
might want to look at all requests on all queues. As such the queue depth
is distinct from the actual queue depth of the tagset.
Seeing that it is distinct the depth can now be changed independently of
the underlying tagset, and there's no need ever to change the tagset itself.

I've also modified megaraid_sas, smartpqi and hpsa to take advantage of
host_tags.

Performance for megaraid_sas is on par with the original implementation,
with the added benefit that with this we should be able to handle cpu
hotplug properly.

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

Hannes Reinecke (7):
  blk-mq: rename blk_mq_update_tag_set_depth()
  blk-mq: add WARN_ON in blk_mq_free_rqs()
  blk-mq: move shared sbitmap into elevator queue
  scsi: Add template flag 'host_tagset'
  megaraid_sas: switch fusion adapters to MQ
  smartpqi: enable host tagset
  hpsa: enable host_tagset and switch to MQ

John Garry (3):
  blk-mq: Remove some unused function arguments
  blk-mq: Facilitate a shared sbitmap per tagset
  scsi: hisi_sas: Switch v3 hw to MQ

Ming Lei (1):
  blk-mq: rename BLK_MQ_F_TAG_SHARED as BLK_MQ_F_TAG_QUEUE_SHARED

 block/bfq-iosched.c                         |   4 +-
 block/blk-mq-debugfs.c                      |  12 +--
 block/blk-mq-sched.c                        |  22 +++++
 block/blk-mq-tag.c                          | 140 +++++++++++++++++++++-------
 block/blk-mq-tag.h                          |  27 ++++--
 block/blk-mq.c                              | 104 +++++++++++++++------
 block/blk-mq.h                              |   7 +-
 block/blk-sysfs.c                           |   7 ++
 block/kyber-iosched.c                       |   4 +-
 drivers/scsi/hisi_sas/hisi_sas.h            |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c       |  36 +++----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c      |  86 +++++++----------
 drivers/scsi/hpsa.c                         |  44 ++-------
 drivers/scsi/hpsa.h                         |   1 -
 drivers/scsi/megaraid/megaraid_sas.h        |   1 -
 drivers/scsi/megaraid/megaraid_sas_base.c   |  65 ++++---------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  14 ++-
 drivers/scsi/scsi_lib.c                     |   2 +
 drivers/scsi/smartpqi/smartpqi_init.c       |  38 ++++++--
 include/linux/blk-mq.h                      |   7 +-
 include/linux/elevator.h                    |   3 +
 include/scsi/scsi_host.h                    |   3 +
 22 files changed, 380 insertions(+), 250 deletions(-)

-- 
2.16.4

