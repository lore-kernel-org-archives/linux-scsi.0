Return-Path: <SRS0=npVx=CW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9E0C2D0A7
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 06:03:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A15682098B
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Sep 2020 06:03:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="htPuHw/4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbgIMGDQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 02:03:16 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:60239 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725894AbgIMGDJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2020 02:03:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599976990; x=1631512990;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=YsAP4licp/FrbHC9FXClGglbn+uiiEsUrJY+IXwukho=;
  b=htPuHw/4OJ8a/tiZGSZs0UNeOiKCErQSd9mEq/X/guSv3aQ0N8kD07lj
   kboZdReHOymwCzpqPwidngId4IoW9Zf0IzzJnu1hE+7Li6wrKpo6inblw
   2+O9fUZekR8az4Gz3df/UtTB0ba+Gxhpf3B9Y3bKGA69+H0GJzze7aMBo
   DDgReeJGmM9BQfpuDN0IkbacQXCQS7A8WSCtPlGl7M8bj3owK/GqJMZkG
   SAnWMKYmQVb1KbATmW4wxL4nN6NpzVFl52Y6ug9p+69x7UhQzL+w9xMrc
   3W/y3Jy+3FvLY7geEURMQG4NjI5tOLvTeb8E7ky7HwDQiqnimPgm1h9OX
   Q==;
IronPort-SDR: 60HOyl1/6ZZS6HQsyCOGCsLpTlhhK8to+4R7QSHmGPR3BfsnBmOcenDPe6Y9CRlZf6QGUlNGEk
 /CQMBYuHJY/Be4UocdKrsYuDI5atiWhL7ZzdOMyG6nrjgJzQdjpjHgcggga1PI9HGU2TXB/LB7
 YPPP73oIO+IFN3m+Q+QYJSMMYobibHcHCFwOcJvjNUhjPZDk1GGgmx3lN8vhoQxriGFSav5nMc
 OOlo8be8C/GTYde3u794aYTuuFVWjgf2Y/dISFTU7JvVTIOQB2tUcQ2jHZURZwvSsS9i24vEGF
 Ahk=
X-IronPort-AV: E=Sophos;i="5.76,421,1592841600"; 
   d="scan'208";a="148458729"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Sep 2020 14:03:08 +0800
IronPort-SDR: IKxHBI98MkANDx9N0JAuPUXyC9juDZBsLI9SeZVm4dEwkj/yZpHaOP/VD6NI2TGgqcMNL/P/nO
 NHUlLMYZPuMQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2020 22:49:27 -0700
IronPort-SDR: arda2lSCABO2PkMjrwHbFcWyo4hr7DqsrdJw54IWaClThu4Rj1yusdGjWc4w8tA20XZDtSJmJH
 EDvPuBGmunyA==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Sep 2020 23:03:07 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@alien8.de>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 0/2] Fix handling of host-aware ZBC disks
Date:   Sun, 13 Sep 2020 15:03:02 +0900
Message-Id: <20200913060304.294898-1-damien.lemoal@wdc.com>
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

Boris,

I tested all this. I could recreate the hang you are seeing with
CONFIG_BLK_DEV_ZONED disabled. The cause for this hang was that
good_bytes always ended up being 0 for all IOs to the host-aware disk.
The fix for this is in the first patch.
If you could test this (on top of 5.9-rc), it would be great. Thanks !

Damien Le Moal (2):
  scsi: Fix handling of host-aware ZBC disks
  scsi: Fix ZBC disk initialization

 drivers/scsi/sd.c     | 26 +++++++++++------
 drivers/scsi/sd.h     |  8 +-----
 drivers/scsi/sd_zbc.c | 66 ++++++++++++++++++++++++++-----------------
 3 files changed, 59 insertions(+), 41 deletions(-)

-- 
2.26.2

