Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78294C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B65E23122
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbhAVIBX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 03:01:23 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:38095 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbhAVIBW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 03:01:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611302481; x=1642838481;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PmVFNnNLJHQcXQX+aWcelrjVOu18j6MRMWuoMHf07yY=;
  b=V/CllaN3z8EKXgnbYd+w2053pgxusLCiQIESx20lTPNPHdD8RSSIzB4L
   j5KTuKQ5BGENnFvwL0u8KPC4l+1nGSi96vBPWZglwXD7lQ7BXMJP9pBYP
   DrM/p8ykTCZB8a47OkLldrXNmUtVMBy5X21JKsXwYAf8m5QoSlJzpASSa
   jCz/21MyKVGqHPlKKzTXSEu9fDr39FvaHiNqZvzp/GypqRqL36Fw3TJRl
   8z1CxKHIKNVTI5/68GfHNZsqHzn+V9Nc9xZWbiaFaBrySzFwxSozBYFYn
   4nYLdfdYcw4i8R17ansuByy7jOxib3oyK40wlmOtYyyWclc8JkjgQgqle
   w==;
IronPort-SDR: PyC+Vc/pfAuSdEXhpGo2W6rnvoMoM7kXJpjfsV2sSzxEmI1UgQvxXhMfe4Y8bQRainFSAs7RZV
 HOJcoHhlSsP6a7RnjejFIMnNBU3siIOJ8rdQQW2LORO+h7oaxJrP9dGXB0ex5tOqGjHhn4CmOp
 d6NKoacrRneVtCIXmX+XAwV2Lw6LoJIRU1LA2Z9iPZjilo2eWgz/8YaqVVf9W8R74igninY/7w
 0D3j511pSzjUZIMSrTP7uJ2PvugAARYBZV35vbpiaVfHR4g+2K947fIiWcRne3HljJ3aVFtP2w
 ELI=
X-IronPort-AV: E=Sophos;i="5.79,366,1602518400"; 
   d="scan'208";a="268398845"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2021 16:00:16 +0800
IronPort-SDR: MUoE9E5CMP6B4jqyDN1oL8QowvX/eTs3/sU+yF+safPycLnssqGhMKKcXCrBN3u5TnXgsWfOnc
 v4fQgZVRq0ZOuANTAZyqN3Jn41y6qKMfeblVM3jq5D8A1gTM4A/zRsn59o+4k5PWbvPVtM+QzY
 fxogOvJ6n661Mtv3hGqMxMk0BhZvChl15c3Oi9O4WISUFddwkkQ2Sko1JfdgZMWko+xdGLtbaV
 IuA+STOezmcnsB4gUJbXFiVAe7UkLRaSH6Qj77s1EV5rmPLwFAcP68DaLiehi7D+nLClqhroG8
 5Rsk0hm73uJN9r+uQd8NAH0y
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 23:42:48 -0800
IronPort-SDR: OP5cUK2NUW3b77Blf3/vL6Fa+7tkZzRXFXJ8NxCdQe/t5TA6TtLdbibkiWl1C84OTKM1PuxciQ
 FD/sjaOzroCgxqSSGbjBczMvYdhizP4XhkQWAIPT5ZddfRqBcWPOavSjZUWmWt3EdyV2C+U+/Z
 vdx4lg4k2FYV35AcFD7jhYP80TyrFJKSFIj6vCt0E91SaWoGiPZ7+8Uk4kBooBe8XBjZ5KFrHI
 5BmDITzvZ4NGLOkTwPWzuSKaZ6CcR7unwxs5lYMpcDfbhmn1mP3ZWvBEzVbIX82+wuCUdAW7KF
 BM4=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Jan 2021 00:00:15 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: [PATCH v3 0/3] block: add zone write granularity limit
Date:   Fri, 22 Jan 2021 17:00:11 +0900
Message-Id: <20210122080014.174391-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first patch in this series introduces the zone write granularity
queue limit to indicate the alignment constraint for write operations
into sequential zones of zoned block devices.

The second patch fixes adds the missing documentation for
zone_append_max_bytes to the sysfs block documentation.

The third patch switch zonefs to use this new limit as the file block
size instead of using the physical block size.

Changes from v2:
* Added patch 3 for zonefs
* Addressed Christoph's comments on patch 1 and added the limit
  initialization for zoned nullblk

Changes from v1:
* Fixed typo in patch 2

Damien Le Moal (3):
  block: introduce zone_write_granularity limit
  block: document zone_append_max_bytes attribute
  zonefs: use zone write granularity as block size

 Documentation/block/queue-sysfs.rst | 13 ++++++++++
 block/blk-settings.c                | 39 +++++++++++++++++++++++++----
 block/blk-sysfs.c                   |  8 ++++++
 drivers/block/null_blk/zoned.c      |  1 +
 drivers/nvme/host/zns.c             |  1 +
 drivers/scsi/sd_zbc.c               | 10 ++++++++
 fs/zonefs/super.c                   |  9 +++----
 include/linux/blkdev.h              | 15 +++++++++++
 8 files changed, 86 insertions(+), 10 deletions(-)

-- 
2.29.2

