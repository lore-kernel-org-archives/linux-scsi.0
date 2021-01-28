Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D602C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5310064DD8
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhA1Esm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:48:42 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:21969 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhA1Esl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:48:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611809321; x=1643345321;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=e5BRWH3ndZ4m7lh7jlC59rxB91+FzmyxAYGz5VrGiO0=;
  b=EDOwgMdgUknZq9RIkjvlWixiIupW1A/JTk24Bof9N1Pf0CoJVUj1Z6V6
   G0eCbP96A6OQDh/ALB34W8NstuWry/rWnIKZ4J2g7J642SYHEfwtq3f3h
   1xR8xd+vjZG/P3dzLqQPlOmyY8Q0wm0DIDJXZFOMew9D7ajKLFfD1uZ+0
   t9OBFN4JIplnSpYuZnSeOUM0arqlpjtqX6YOI7dPeixtG2b1rKpmdUDye
   LdY8SF0//AtYHifTfk6HRK1aPsfYJk76ZkZZdLAvgHS7XtzuAp/ViuhB6
   WYuXtRZC+STQcyclxdn2bSEfTsT6GzQhLkoMUOOvXRfTDkyM/6ChtVI3W
   w==;
IronPort-SDR: gYiXVyPYXZlQkLOX/qiXQ1N7z4uwqq0fh1X2CnImq7+viqgpRu8YIgHmA5LmkGTEptBwzmG3uB
 bOqP5ufCyRI/1YY9NtvVPfF7lgJBfqpVVTLl/9TB3tmrGzUBVq48qoqnCWZOyNV8gFLtbfklyo
 9dGdSvHynqs7e06QPOH9q/TLQt+9im0F7HS4Bi4CVUsbDML5MMxG4OPCUnfT+yoCbtLFZLWY65
 cPwrA+6fWFBTsh4LRxK58IDwQ2jKr8YXUOb0Kz1sUJ8HErpqglmwojeheqaSyEDxRDi2qnq+GO
 YPE=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="158509121"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 12:47:36 +0800
IronPort-SDR: aZXiiF2/6JYzTkc0MVw0rgBZXKviirYlj7EkkSJ++VxuMof7bAQCFNaBuFuZ0AD1w3W3XwHfWf
 wxrTPtkuttloIuiwS9n1MiHLNMMBZzSC8Djkf1FUgBxtfg5cmEIkiWtP+y3BVt75vFhVWWA1S+
 N42c/t3Z0whEbWPNjW9UeZL7LWcv1GvTJK9J1kHK4HMPK1GIZoBNwDZt895MQEv18sRSvFDl0v
 Xfwrwcoig8kvXD5Xbf1u8GwPblcURocy1qWKMeS7B7xcyqbptjkkIzTc6XyU1NkUZnN+QJRemN
 m277y33GOw3+ipzZzWBKDtmt
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 20:29:54 -0800
IronPort-SDR: ZdHmQTx/rm7fgx7E8n7fVNa6Sxm51qOl0qUltYbh/FT1cmd4L8nHShfBziClAs7ExJMvQqrAOp
 d9pGCnce6U4YY5zqq+gO+nCmvEzSEF6ylUsvXNS1kj8leKt4TRkUXIT1jRbwz6iRddh3brI+6Y
 tu6kEmzuWooccB6nF94ImYRnHoppa01XRD9JSPJ9af3Zr+v4hKIT1vPteGLCUNTE0dln6o3kO2
 5ywlDhufk75DPMZR9D+oOLi7yw/T9PLZ50WPkjvKbsJ18lBUt0YvMnkGyvPx+cpYWoS1kHN0OV
 1BE=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 20:47:34 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v4 0/8] block: add zone write granularity limit
Date:   Thu, 28 Jan 2021 13:47:25 +0900
Message-Id: <20210128044733.503606-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first patch of this series adds missing documentation of the
zone_append_max_bytes sysfs attribute.

The following 3 patches are cleanup and preparatory patches for the
introduction of the zone write granularity limit. The goal of these
patches is to have all code setting a device queue zoned model to use
the helper function blk_queue_set_zoned(). The nvme driver, null_blk
driver and the partition code are modified to do so.

The fourth patch in this series introduces the zone write granularity
queue limit to indicate the alignment constraint for write operations
into sequential zones of zoned block devices. This limit is always set
by default to the device logical block size. The following patch
documents this new limit.

The last 2 patches introduce the blk_queue_clear_zone_settings()
function and modify the SCSI sd driver to clear the zone related queue
limits and resources of a host-aware zoned disk that is changed to a
regular disk due to the presence of partitions.

Changes from v3:
* Added pathces 2, 3, 4, 7 and 8
* Addressed Christoph's comments on patch 5

Changes from v2:
* Added patch 3 for zonefs
* Addressed Christoph's comments on patch 1 and added the limit
  initialization for zoned nullblk

Changes from v1:
* Fixed typo in patch 2

Damien Le Moal (8):
  block: document zone_append_max_bytes attribute
  nvme: cleanup zone information initialization
  nullb: use blk_queue_set_zoned() to setup zoned devices
  block: use blk_queue_set_zoned in add_partition()
  block: introduce zone_write_granularity limit
  zonefs: use zone write granularity as block size
  block: introduce blk_queue_clear_zone_settings()
  sd_zbc: clear zone resources for non-zoned case

Damien Le Moal (8):
  block: document zone_append_max_bytes attribute
  nvme: cleanup zone information initialization
  nullb: use blk_queue_set_zoned() to setup zoned devices
  block: use blk_queue_set_zoned in add_partition()
  block: introduce zone_write_granularity limit
  zonefs: use zone write granularity as block size
  block: introduce blk_queue_clear_zone_settings()
  sd_zbc: clear zone resources for non-zoned case

 Documentation/block/queue-sysfs.rst | 13 +++++++++
 block/blk-settings.c                | 39 +++++++++++++++++++++++++-
 block/blk-sysfs.c                   |  8 ++++++
 block/blk-zoned.c                   | 17 ++++++++++++
 block/blk.h                         |  2 ++
 block/partitions/core.c             |  2 +-
 drivers/block/null_blk/zoned.c      |  8 +++---
 drivers/nvme/host/core.c            | 11 ++++----
 drivers/nvme/host/zns.c             | 11 ++------
 drivers/scsi/sd_zbc.c               | 43 ++++++++++++++++++++++++++---
 fs/zonefs/super.c                   |  9 +++---
 include/linux/blkdev.h              | 15 ++++++++++
 12 files changed, 150 insertions(+), 28 deletions(-)

-- 
2.29.2

