Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A100C3A5A6
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6C7B22CBB
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 02:29:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="qQTssckT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbfH1C3u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 22:29:50 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27195 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfH1C3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Aug 2019 22:29:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1566959389; x=1598495389;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=BasV3SLGIWbYgDQO7VvOL+anoqnuAFIot55g4YOCIrQ=;
  b=qQTssckT3g7UkgGK0wjOgbQhoEbRI88MQ7Cfmweud/vxmz3W1zFHsxo1
   uHgd2RKXOA/Wm0h0yOF/dCxmayvdlv8zlILNG5ayhqXQOAvWEXSUqyh4K
   L4nXb+tUfDbtiF3mU2KTXV1iW2NLsEQtvv7+m+1sbNGhUZc7ZCxVSVcp5
   PcIFWsFwwC+Put+LlwtH8uH6AL64avIYp9/cQTnqqVB7AA8MPaEQKPcQE
   N6LTfRdekcd1mn3jnu61kRRU6s9jia7KNjpFhePXQxT2qFqZv0pOIrNn8
   mruUF7cWfKvFcU1lbx8sd71SIuspv5aaDNEfOi44l8yx5M8En6Ehne98s
   Q==;
IronPort-SDR: +D587ysDH3fVdQ0r3XeiMGynucnKErmDnI9NtOCYgX2gKB+8S94S4jtNRtkYG0g7M8ucLhh4Pt
 TFy8K4Gm1gw7GlvMb+YIBfOIE1cT0pNhsPxzisMRbKF7i0wl6gxJxk3VM6wXMkE4v+hF9LnN8F
 YvvuA7fVNo1eftJpFjHVcQHYYHv6tCLXeCKwk3Cr+JDnj2+sg6sGMgq+8AEVBRWBl+nT6uwxZU
 Xwlq1DQjDK1ON/pzSkr92puIGRoG3YjV+zQRCFHCrhp3ZbbYEDVByDNzKSNitSAG1X1q5XOEce
 jDo=
X-IronPort-AV: E=Sophos;i="5.64,439,1559491200"; 
   d="scan'208";a="223475478"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 28 Aug 2019 10:29:49 +0800
IronPort-SDR: Fkz8lvA6yB+bqCRG+LrzdmfqiXKxfWO7fpTl0mHwMNSIPHQFx23A1ojIg0t9RGlg+MbnYlbBRC
 h7wwwis2tIxIOq3tr7TJzDauOUU5ozcc58koxa8pRsjElsBdHp1qEPvwE9w8X36eGoVJufFPWQ
 puxUx1x8OMje9oOeItGrRouBD4mKY46KF1Nebzlp2Eo9Xjs1utHy8+7mqvDEmSe4jh/uMqZNqz
 MRHV8PEs1afK/NLN8iHXaDTF+jamXQWc8JP/bna49RB/XBM+tN4FiBTT1RNd1V7uOW8iFwl+FV
 PPyHk0pp38avkA5WKW7nMSTm
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 19:26:59 -0700
IronPort-SDR: j9SAxOZdPfU2gI+aTWkmhZl0e5jVyAIrlz2nRUchN4oMLid5/nFgatOcmldyTyvNrS/V595Yng
 NXwU1yZYCgeSDHU62zGjkXsoDqZD1KCur4c5OUZabcUtfjpVuMHho8yVCTiypHVO/gkoTu2E2E
 +S7BmZalmnRnOpgWJvvC7l4b6achTPQHUSNpVHmzHWOmPrxkf4yyVQcFyjOniBF/fPA4bMl07F
 zJSweF0i/YlmaofsUg67oPIE5BEzaAUXaSpIFd/qjmhQE8ApQlFddxuQd5So+P2i5jYa4pAMb5
 rI0=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Aug 2019 19:29:48 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 0/7] Elevator cleanups and improvements
Date:   Wed, 28 Aug 2019 11:29:40 +0900
Message-Id: <20190828022947.23364-1-damien.lemoal@wdc.com>
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

Damien Le Moal (7):
  block: Cleanup elevator_init_mq() use
  block: Change elevator_init_mq() to always succeed
  block: Introduce elevator features
  block: Improve default elevator selection
  block: Delay default elevator initialization
  block: Set ELEVATOR_F_ZBD_SEQ_WRITE for nullblk zoned disks
  scsi: Set ELEVATOR_F_ZBD_SEQ_WRITE for ZBC disks

 block/blk-mq.c                |  10 ---
 block/blk-settings.c          |  16 ++++
 block/blk.h                   |   2 +-
 block/elevator.c              | 138 ++++++++++++++++++++++++++--------
 block/genhd.c                 |   3 +
 block/mq-deadline.c           |   1 +
 drivers/block/null_blk_main.c |   2 +
 drivers/scsi/sd_zbc.c         |   2 +
 include/linux/blkdev.h        |   4 +
 include/linux/elevator.h      |   8 ++
 10 files changed, 145 insertions(+), 41 deletions(-)

-- 
2.21.0

