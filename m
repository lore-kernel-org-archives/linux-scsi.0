Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDCEEC43461
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 07:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95B4220897
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 07:34:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="LkRvE2gH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgIOHd7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 03:33:59 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12669 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgIOHdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 03:33:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600155234; x=1631691234;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FarJKh3x0In5BY3dfnVbiccgbo1sWfg8Yc3MSgdQfvY=;
  b=LkRvE2gHylnwnKGT8MVjnqLijXuwuB2guQI0p2Pzu/uSCRGYs5/GJ9sJ
   v4JoNMY63ZAVjMEFkHd9rLMUcsEoyXUy17YGo0zwV+XHn7phSZ8X2ybgH
   DDWlVgYx9RXwy4uXGfZjAibves92yXk3J3M9U+QjJLgGEQOHrmEyJ9ifP
   /ERqTQG6BnNmS4Gv5oZHHPnay2kVJ1ALbZo73/NRY6IW0qIVmJXJ5giU6
   yoWvQrCXajq526kGZaOQ0NsRkbzeea1QFhNEMHvNMPfV4lplCpcXwaZSQ
   XWFKB5qqOKIoR0uvXfXiQw/PxXyQsnr/DQTTX0Oi7G4qcIjpnh8yfjPpC
   g==;
IronPort-SDR: NgWhtLidm76GMnT8CO2dxmchBLuUoCXDo986olFWEmPI51KXNixlGxEh4w2Dzd2WBnojw/eZli
 M5Oild3r+GKT+mT/E/oilOtnMUyiqJSeRocf9ctzdxocj05fSy93kVTHVBLJc1dPFmB12ys3cU
 xkFyMRPvXffir2kCZ9hAhU5UCkhhgf40tArWrW+id6E+Q8r08gk7O9qeFTVu4aUHxhQVUoqZBV
 G46nMajg0Xj+HV6yEP0e//FV51fY7pcTSiHe1Kk1ZkBDdz9NJoU+ADS7UWJ+Ubk1zgOMxlYlSO
 eMQ=
X-IronPort-AV: E=Sophos;i="5.76,429,1592841600"; 
   d="scan'208";a="147405117"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2020 15:33:52 +0800
IronPort-SDR: W6RvQwcbocZVw2Be8Qc9S5sHnxtTveFjoZmVcVMbMXBOb6nwDcnAvDYaGiSUG8/K5UneOhKPk5
 d61G/X3jvcjg==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 00:21:02 -0700
IronPort-SDR: YXjMHLq15wGZZgZURDn6+rP+8sqcxZSMvCzjsb1x46aHwffmodbopeWsgZaBXlaPREEKx4HKbv
 Zrb8z90TCLCg==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 15 Sep 2020 00:33:50 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 0/2] Fix handling of host-aware ZBC disks
Date:   Tue, 15 Sep 2020 16:33:45 +0900
Message-Id: <20200915073347.832424-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Two patches for this cycle (with a cc stable) to fix handling of
host-aware ZBC disks that have partitions, that is, used as regular
disks.

The first patch fixes host-aware disk initialization and command
completion processing. It also enables the use of host-aware disks as
regular disks when CONFIG_BLK_DEV_ZONED is disabled.

The second patch fixes the CONFIG_BLK_DEV_ZONED enabled configuration
so that zone append emulation is not initialized for host-aware disks
with partitions/used as regular disks. While at it, this patch also
removes a problem with sd_zbc_init_disk() error handling in
sd_revalidate_disk() by moving this function execution inside
sd_zbc_revalidate_zones().

Borislav tested the previous version of this series and confirmed that
it solves his problem (thanks Borislav !)

Changes from v2:
* Introduce blk_queue_set_zoned() helper function

Changes from v1:
* Rebased on rc5
* Use "if (IS_DEFINED())" instead of #ifdef in patch 1

Damien Le Moal (2):
  scsi: Fix handling of host-aware ZBC disks
  scsi: Fix ZBC disk initialization

 block/blk-settings.c   | 46 +++++++++++++++++++++++++++++
 drivers/scsi/sd.c      | 34 ++++++++++++----------
 drivers/scsi/sd.h      |  8 +----
 drivers/scsi/sd_zbc.c  | 66 +++++++++++++++++++++++++-----------------
 include/linux/blkdev.h |  2 ++
 5 files changed, 107 insertions(+), 49 deletions(-)

-- 
2.26.2

