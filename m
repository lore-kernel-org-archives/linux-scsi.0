Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E848EC3A5AB
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C06E0208E4
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 04:29:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="V2AUftpK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731129AbfIEE3D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 00:29:03 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62199 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729941AbfIEE3D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 00:29:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567657743; x=1599193743;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GOxacEXZXEefgxGTxRDZr3EdquI5qXE1LSwK6vh5JeU=;
  b=V2AUftpKHUdlLxUw9wy8300hfInyUqyrp6LiE8sa1la13H/qhZX9LORr
   Q7TXSLgKNgl0z47mfiXTHIJSkjw8RPipmssT+8VJ0jHNIaIwBQ2dU7sd2
   KkF/soUk1B8O7/vt3fjdf4gI/7hDGCOrYNh/6OglFYYZPuCX3Uk0msVXA
   lB2+V2f/ygKgcPjdmOJzL4hJUtCpIF7bBR9zKuTyF2AQ2/O6qDmBKMXtC
   JE5nnvvOVcD+s8bnsxAdW9r/PFCs1S18LfPCGjXtQ9u0T3qdhv7dhKV+a
   Vxtzfe8jxCGiMEhqy1X/c7NG15Q+s9ttjg7QUBURWK+S78CpXRxwABQcd
   w==;
IronPort-SDR: RjCK+Ae0m0JNiRsr8s/6Gszv76FeLNyQITord5rYyQi5bzqMPqsFU7s5tJA5iAVwnxMds7kDUi
 F7N4est8jxcBz4xdWBAeUlU9Iex1iy5mYZA/SVxltprwBmJ1170eLaNZGm5xuUxZVAmXoXeWCZ
 9zajvK1Oal27LJcRuREjMWyR7OY5oGNLm8BLSfbfqhDzX9ZXhl2SLXmc9FpSStVC47Q4f0p4I0
 gQq7A6/oLh5bUCAkadR+3AfLdt28ZKNPS/s24XKMGXCrkwZlQH1nPKmKd+xUnhJT8xwmJ3RK1n
 2Vs=
X-IronPort-AV: E=Sophos;i="5.64,469,1559491200"; 
   d="scan'208";a="224233065"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 12:29:02 +0800
IronPort-SDR: l5TrKMNCK17vq/WGXa3a3TTFazBsrXthJXXm/1iubzZMHFOtdVSblv5AZU+FBVga/Ikyvz/D9/
 cqYq6cNen34je23RztO7tYVtv51hTMwwt20IjdqHnfmyW8XRzvYQK2SLCeibh2hu+E5zp3rNtl
 9gz8HLL6lGjDSbdjOWF/Ui5v5ToauSSdnegV7ZZC+8ZHrqDp+7JHxgjuKgn0QRWZCHXJlu+R/d
 +5fP32psL1T1rHdkARn0BXr/7I5/6wm+0fuvvfwfetHnTgaLr0y3/IA4/oQITFy6nSY7l0QYIX
 HcFl3HAbOpftn0VBsF/ZltiD
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 21:25:59 -0700
IronPort-SDR: QZDAUlwCGEtbsteLmfzka8YZB6Dk0kHinBMXmyfP2RIP6yKTn5VgEUSqYH088jbxuCoJiDlnO0
 29vsQK+uOx1eug0WkvxxRkaDPXSrDPK+7a6zZLXDPOvaHykf/QvaFWozOmRCLb48KGI2Ao6Iri
 zVEn45Nbbpvtx1UYj4TiBbWp/oCFb1rb/ozDpSVkePPjt+XBh12jTRO4n2VqwywTvzxNUkxuBA
 0saGSiVAfhtyKE989mlAScPCSVxJwBGAGAntCWzt7EkY5XykEuSYnoqL3rg9VAuCSfcGHAa+6J
 jNI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 04 Sep 2019 21:29:02 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 0/7] Elevator cleanups and improvements
Date:   Thu,  5 Sep 2019 13:28:54 +0900
Message-Id: <20190905042901.5830-1-damien.lemoal@wdc.com>
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

 block/blk-mq.c                |  10 ---
 block/blk-settings.c          |  16 ++++
 block/blk.h                   |   2 +-
 block/elevator.c              | 137 ++++++++++++++++++++++++++--------
 block/genhd.c                 |   9 +++
 block/mq-deadline.c           |   1 +
 drivers/block/null_blk_main.c |   2 +
 drivers/scsi/sd_zbc.c         |   2 +
 include/linux/blkdev.h        |   4 +
 include/linux/elevator.h      |   8 ++
 10 files changed, 149 insertions(+), 42 deletions(-)

-- 
2.21.0

