Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54574C3A5A5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2055D21743
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="VVA28PUm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732545AbfIEJvt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 05:51:49 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25315 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730769AbfIEJvt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 05:51:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567677109; x=1599213109;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Cs/kYxOynowlSHLGbvCRTCAdV79X3s4AnL02e7kfB/w=;
  b=VVA28PUmMJ7n5Y9ozUgpTFlKo6R4OBALB7i4P085jXd3JN5l5NRYUVhP
   PjmV2vFPQrYQjm8dfo63CwmnzFPjL9kYRpjyTQ9EmvvmkC+geUJ6WTFo/
   DyBU5ZUDiGThHLxCgtMgfksUsPAvQnzzJz8TJz6UdK29hXmkY31ZF74xZ
   jx4O1xfb3iHBBnzHLpI4oHZMks+qrdTK69wK1aYGur3sEKMiiQHMTlXKR
   n40L6pEydFMKVz6bZGcx3SctwAAnUfDGWuu8re1ydBbP6xdKenZ38I8eL
   u8fDFQcms8fao79YQ+wMril1RTZRyTUbrdeMQJmHfeAQVxG8b5slUOX6s
   w==;
IronPort-SDR: XHzHpiCDGk4ZDiJLuSS4C0bjzcm2ggrwnK4u++lnwfoNSOUP7ZlukAyWnc8Hrey20kK4WPdu99
 2o6hRMILPSVaQDz/Qw8v5YZrCKOjsORqUlkkSg6ynH4VI9xd0xHwdGNx75iDCVnYsAQNf/eLyX
 3suGyQ/7mgZr6WAbwlaP6UzogpRG0RjD4NKdrKLtNhFcpTHXxAaJYTOixDfU+bXyo5zX3xFM5V
 aMQ0S+8SORoJ5dpc+Okxc2v9KKO527a7oR6NisXvkHjCddnOMgV8h5aBuzPPlObISJlfsmp0tY
 UxE=
X-IronPort-AV: E=Sophos;i="5.64,470,1559491200"; 
   d="scan'208";a="119106234"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 17:51:37 +0800
IronPort-SDR: NQW7JSSNQd7wEbvUrIU5EpQ9uGD48LV5AxIA00grOVBlRtt31MV2N32oOaQFs2qknm10NaqwAS
 D4LSulKPyQzr939cUCkH2PRIlP//g2AuViQQX+przCCp/wf6kqOkD9d0xvCDWEFfkLtD2zwsd9
 LGPsOIRnLk36PgZLA5zOwFOGntPDM5a2D7JHhbX0kFuyjqHXbtLPCgXzuvXCV8IczQuNE0cE4l
 TVnvKsicig8dDo9wJ5079CWHCmQ7pHYBPCBIQIu4huH4HW2YJg16YOqmsd1mbkmbJMa0a6JXvH
 zHgF1Oa2QiK1RAqHPUU4loha
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 02:48:33 -0700
IronPort-SDR: Swvm3JGu1EFRj2eCypZzaVkhb977bgBGcHjrQxAyDzagh1Swod1OY4+qoMIPCGCfugLlx5iLND
 R+hgwKOYflCwuBq4/le79FynoSmiK0JTRzbYWbZljCxZkDdhVil7a5ai68uptZ04VoMDuPYlBy
 mWxVEx+drNZc2K1WeltGEhx4mrHkwd5ZEwg96ontrTgxkaCc1EBO8VjbsHQZhvdLvPLrARHbRp
 VZLqDKMIrOaRXQ2XeOiG35ADcOor8DPWAj0lqrNQv4M6t63OA137tmxZbN3WtJ3vbI7TqCMOpc
 Amw=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Sep 2019 02:51:37 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v5 0/7] Elevator cleanups and improvements
Date:   Thu,  5 Sep 2019 18:51:28 +0900
Message-Id: <20190905095135.26026-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series implements some cleanup of the elevator initialization
code and introduces elevator features identification and device matching
to enhance checks for elevator/device compatibility and fitness.

The first 2 patches of the series are simple cleanups which simplify 
elevator initialization for newly allocated device queues.

Patch 3 introduce elevator features, allowing a clean and extensible
definition of devices and features that an elevator supports and match
these against features required by a block device. With this, the sysfs
elevator list for a device always shows only elevators matching the
features that a particular device requires, with the exception of the
none elevator which has no features but is always available for use
with any device.

The first feature defined is for zoned block device sequential write
constraint support through zone write locking which prevents the use of
any elevator that does not support this feature with zoned devices.

The last 4 patches of this series rework the default elevator selection
and initialization to allow for the elevator/device features matching
to work, doing so addressing cases not currently well supported, namely,
multi-queue zoned block devices.

Changes from v4:
* Fix patch 5 again to correctly handle request based DM devices and
  avoid that default queue elevator of these devices end up always
  being "none".

Changes from v3:
* Fixed patch 5 to correctly handle DM devices which do not register a
  request queue and so do not need elevator initialization.

Changes from v2:
* Fixed patch 4
* Call elevator_init_mq() earlier in device_add_disk() as suggested by
  Christoph (patch 5)
* Fixed title of patch 7

Changes from v1:
* Addressed Johannes comments
* Rebased on newest for-next branch to include Ming's sysfs lock changes

Damien Le Moal (7):
  block: Cleanup elevator_init_mq() use
  block: Change elevator_init_mq() to always succeed
  block: Introduce elevator features
  block: Improve default elevator selection
  block: Delay default elevator initialization
  block: Set ELEVATOR_F_ZBD_SEQ_WRITE for nullblk zoned disks
  sd: Set ELEVATOR_F_ZBD_SEQ_WRITE for ZBC disks

 block/blk-mq.c                |  20 +++--
 block/blk-settings.c          |  16 ++++
 block/blk.h                   |   2 +-
 block/elevator.c              | 137 ++++++++++++++++++++++++++--------
 block/genhd.c                 |   9 +++
 block/mq-deadline.c           |   1 +
 drivers/block/null_blk_main.c |   2 +
 drivers/md/dm-rq.c            |   2 +-
 drivers/scsi/sd_zbc.c         |   2 +
 include/linux/blk-mq.h        |   3 +-
 include/linux/blkdev.h        |   4 +
 include/linux/elevator.h      |   8 ++
 12 files changed, 161 insertions(+), 45 deletions(-)

-- 
2.21.0

