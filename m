Return-Path: <SRS0=3W2l=CX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D998AC43461
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 00:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9127D21D1A
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Sep 2020 00:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fabKoqC9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbgINAey (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Sep 2020 20:34:54 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:19482 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbgINAev (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Sep 2020 20:34:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600043690; x=1631579690;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=EgmrGjpy4F7zOgbDJ7PF7ajKaCMUjMj5tbbe8DLVWnY=;
  b=fabKoqC9JNv/vPnA1ni5Winldhix0d3LPZjoDcBECpEP8Xgh79okpNRF
   SMQymjuAGxnEuENGn2NMguzYkvDHKW5kJ9akYTzkHD94Q5T7ihVdZyi/k
   N1Uv3oiGpkUK+6n5gcFBpi75/RbQv11MYvNqG/rA20HoReMc99Fn93r/s
   K0AjO9O5a9CKYKvoKal0UzehKh0F2W7eVTQYkVL5bZ5oxUdiCzwKDD5/0
   tcQrs/IL815EQ2L9/TjoFIFI/h3P7W64AuOmJK4NmWuYRmiI7wlpYkc0m
   jrk/sISCw6pYVlEzXhzID1UQuZWynbZFR4Uxli+/hZgltCeb42OmMDdPl
   w==;
IronPort-SDR: l4AmbB7lVlWWM9kGJKrunGETQFjkRsH8dS/l9FXB6RKFp7JAYLukunPOtqWvXVCoYZTbUsBRY2
 2cIYZk3Ekpz4qv/oAArN07W2BfFGOAGUY0HRDrafk4YwiGIt/gU+DZGsgWwfG1iFMaBdcgPCHm
 PRSVG+/sfK04A6NQV5//m7pK7KU0WenKbjcyNZQR4ZwhDe9wOq8YdiV9MMfHd2tmM8lx8TCTxb
 3TvuktiOQ4DLEiJNoB9KwD5kcxeQfJsLXwPzvLeWnyM7FdMz1fLn4tHFr5bPX2ww9NFjxgu9wW
 tho=
X-IronPort-AV: E=Sophos;i="5.76,424,1592841600"; 
   d="scan'208";a="256887863"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 14 Sep 2020 08:34:50 +0800
IronPort-SDR: DGDRLZuAGnVmZdLZhufI0+KrGOjvVDJxR3KEqV+wStS6feFMaEOYzh0FfjtiKlmL6TchLbbHxh
 35bnQlSgsofw==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2020 17:21:09 -0700
IronPort-SDR: 4w+Kr7elm21GUbyh0eGrccUlMzQ8+apUm2yxUDHSeOElFKl+cGKqS8AF4zBiM/C6MN9Q8R4QlP
 X5VpbvL3VrHg==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 13 Sep 2020 17:34:49 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v2 0/2] Fix handling of host-aware ZBC disks
Date:   Mon, 14 Sep 2020 09:34:46 +0900
Message-Id: <20200914003448.471624-1-damien.lemoal@wdc.com>
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

Borislav tested the series and confirmed that it solves his problem
(thanks Borislav !)

Changes from v1:
* Rebased on rc5
* Use "if (IS_DEFINED())" instead of #ifdef in patch 1

Damien Le Moal (2):
  scsi: Fix handling of host-aware ZBC disks
  scsi: Fix ZBC disk initialization

 drivers/scsi/sd.c     | 32 ++++++++++++++-------
 drivers/scsi/sd.h     |  8 +-----
 drivers/scsi/sd_zbc.c | 66 ++++++++++++++++++++++++++-----------------
 3 files changed, 63 insertions(+), 43 deletions(-)

-- 
2.26.2

