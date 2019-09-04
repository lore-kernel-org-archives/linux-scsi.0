Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43AEC3A5A9
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD1D322CF5
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 08:43:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CmYAw/Ty"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfIDInA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 04:43:00 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:39226 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfIDIm7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Sep 2019 04:42:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567586579; x=1599122579;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=n1MC1OTzcCm1lOYrJcooNwdcMXLHe+rjMqpRSYid+aE=;
  b=CmYAw/Tyi17gVwbFmGuytyYtaruIVc5Qfs5/n0NRCkRr8LVoNhnEOpzW
   N8yk+1Ykqotv9MNl4KUxY3KtEJRbN7Oga1us8Tju0bjU5J3YaQEPgED48
   jv0AcnCHGLlAkPfjPp7AjEXPjroWUi3xUSdT5I8ZEM/NP/3OvfMST5QTm
   r3l/7kqTQbOT/8ebpjwM+9MpOQCNAsQMtXhxsY0Ifbtd1HETkwCFWTSVO
   bM8Goa+gk3qaEN7qktNL28Uke86bIMVVR3jch0rRcZ74jiGg7gI2YrAFK
   8jyaFI0e0ptSfw8I4ttqRscbI2g8VJ6uwfWlAV0wNVFFsZ1Jo7lgiUr6E
   A==;
IronPort-SDR: c5Lzec8updODWuYu30wSdr1EMpevSVyy2IoqUO3qJ9cibjs14mcswzxMmKIHZgkUFPakp6/PjR
 VHjNFhA8q5Oo4zOLborcDZ6XQ/vel1Kz5Kx+AIeoQEq9AqJqhJwvWzGLJH2HOB2DxVirt7Niv0
 89Lg4tgr1QJKYMgtvjbs2D9TwOULB20yy66SKGid4v4/Zhph2gFC+huDayl+iyeJ1xfQX4Z0mQ
 0JIvqHhQdRp2mwWz8jQne8JzD2wvdFjIyXRnYuFcBjpqq9uklvV8pkEk7B5sUqxCYw6ekvZua3
 4SQ=
X-IronPort-AV: E=Sophos;i="5.64,465,1559491200"; 
   d="scan'208";a="117374674"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Sep 2019 16:42:48 +0800
IronPort-SDR: EktKsKkWQH9KlkxPE+wZjGK1+7DXhi+RzWTDvwFmmwVDihLSIkvvLCptVeSEkYcWxcCcQqlTVw
 VLNlfGjOhC5yJ/LTteWX3mqAL7HbexGNQxnk6Fzf8fysp0K4Q/WjIgUiUEh64xAPEHxgMMskse
 iZ8EYHy0kuPu3Zi4iThxmeJ7g0tbaS20hzCO47MRNn5eOn2IHbB+0CG/jwmZSfU7VC1q1bj4jJ
 zmgYWy7+w6z+zht3zi+cst4pjcZ99ZWJFecURKb5pM9X/AIyhjooHolv1lc4/5WYjptzf4F+wj
 eL4OwpbDJDwno/hrpAxyAgx1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 01:39:47 -0700
IronPort-SDR: Rw2FoNX2vT9k9FjQzmlphbtanEWZf7sVbzvKjPvfB0XCBG/gFx02GLD50OLv6HIHVInl2Vz1/U
 PlXwA8PxGdb+fbnYuShlsq7ZugulUIJUeE9SejX1ev3BSk90q4jp6AQQWRxcZaL8j9eC3hxFom
 l8idDDRdLyrazpwCRs1UgDNeb7TSsMTA0sn2pD8bLxxN0k1zvB9CM7k/OmW/QXzhczUnpQSety
 23XGDkkQ1qiIiiFAzONgx+goUvMpQxGGDkN9O8hZFcpMQEK9PV7voRfVx0VCxALPJ7yQspq24j
 BaI=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 04 Sep 2019 01:42:47 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 0/7] Elevator cleanups and improvements
Date:   Wed,  4 Sep 2019 17:42:40 +0900
Message-Id: <20190904084247.23338-1-damien.lemoal@wdc.com>
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
 block/genhd.c                 |   8 ++
 block/mq-deadline.c           |   1 +
 drivers/block/null_blk_main.c |   2 +
 drivers/scsi/sd_zbc.c         |   2 +
 include/linux/blkdev.h        |   4 +
 include/linux/elevator.h      |   8 ++
 10 files changed, 148 insertions(+), 42 deletions(-)

-- 
2.21.0

