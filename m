Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6396C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 09:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF8372082F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 09:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfKZJOZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 04:14:25 -0500
Received: from mx2.suse.de ([195.135.220.15]:41604 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727464AbfKZJOZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 04:14:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8F17FB9EC;
        Tue, 26 Nov 2019 09:14:23 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH RFC v3 0/8] blk-mq/scsi: Provide hostwide shared tags for SCSI HBAs
Date:   Tue, 26 Nov 2019 10:14:08 +0100
Message-Id: <20191126091416.20052-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

here now is an updated version of the v2 patchset from John Garry,
including the suggestions and reviews from the mailing list.
John, apologies for hijacking your work :-)

The main diffence is that I've changed the bitmaps to be allocated
separately in all cases, and just set the pointer to the shared bitmap
for the hostwide tags case.
I've also modified smartpqi and hpsa to take advantage of host_tags.

I did audit the iterators, and I _think_ they do the correct thing even
in the shared bitmap case. But then I might have overlooked things,
so feedback and reviews are welcome.

The one thing I'm not happy with is the debugfs interface; for shared
bitmaps all will be displaying essentially the same information, which
could be moved to a top-level directory. But that would change the
layout and I'm not sure if that buys us anything.

Differences to v2:
- Drop embedded tag bitmaps
- Do not share scheduling tags
- Add patches for hpsa and smartpqi

Differences to v1:
- Use a shared sbitmap, and not a separate shared tags (a big change!)
	- Drop request.shared_tag
- Add RB tags

Hannes Reinecke (4):
  blk-mq: Use a pointer for sbitmap
  scsi: Add template flag 'host_tagset'
  smartpqi: enable host tagset
  hpsa: switch to using blk-mq

John Garry (3):
  blk-mq: Remove some unused function arguments
  blk-mq: Facilitate a shared sbitmap per tagset
  scsi: hisi_sas: Switch v3 hw to MQ

Ming Lei (1):
  blk-mq: rename BLK_MQ_F_TAG_SHARED as BLK_MQ_F_TAG_QUEUE_SHARED

 block/bfq-iosched.c                    |   4 +-
 block/blk-mq-debugfs.c                 |  10 ++--
 block/blk-mq-sched.c                   |   8 ++-
 block/blk-mq-tag.c                     | 104 ++++++++++++++++++++++-----------
 block/blk-mq-tag.h                     |  18 +++---
 block/blk-mq.c                         |  80 ++++++++++++++++---------
 block/blk-mq.h                         |   9 ++-
 block/kyber-iosched.c                  |   4 +-
 drivers/scsi/hisi_sas/hisi_sas.h       |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  36 ++++++------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  86 +++++++++++----------------
 drivers/scsi/hpsa.c                    |  44 +++-----------
 drivers/scsi/hpsa.h                    |   1 -
 drivers/scsi/scsi_lib.c                |   2 +
 drivers/scsi/smartpqi/smartpqi_init.c  |  38 ++++++++----
 include/linux/blk-mq.h                 |   9 ++-
 include/scsi/scsi_host.h               |   3 +
 17 files changed, 260 insertions(+), 199 deletions(-)

-- 
2.16.4

