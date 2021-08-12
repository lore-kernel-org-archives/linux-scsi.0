Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB75C43214
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 154476044F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 07:50:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbhHLHus (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 03:50:48 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51846 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbhHLHuq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Aug 2021 03:50:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628754622; x=1660290622;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=YlAMtc1NFjSacQjRaTROX9F+tPKC3ulFDw9e3bnV9hc=;
  b=Vm7+3fYEDsUDGjRIgh2yBAeCMsi514ySRNf59otq2mInB6FB024aTxS0
   X548oAW8fScw8M6bLMDSaDqeNeD6M1PfaqDNt/1/izsS30EdoGAWPgaFq
   uJ8cp2DQdeTXeYNMu8jfRPjVXKiONrHKTD3Qg/Kz0EdRBYs6umxJaSvZE
   hOOZ4vEGZnjuFXHGYOaiTpmirh/QNQrQI/ysDx+NiGtXiHNA3lWmilvYX
   YjXEkhFMzwNHznA58OsWWzXDtOjEct1AgcRYrG4vHwkrBF0I9xYHrbOjW
   bdFsQMI3MWTqbhpwnhq/45p30vEN70XPt/nhdSxri4bNd2HP3kOiDXQ9F
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,315,1620662400"; 
   d="scan'208";a="177596940"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2021 15:50:22 +0800
IronPort-SDR: 511GsPTHmc/zdqV5gAOTtCjQbfj1BOAP6+LhLMVoG1FzyUsYgBV5zx2oHEpGVlY20quHnnvwQ+
 NLVcfSk6yyJnBYjvBZts+/BvIWrzWW0o7MRqLi0MWeYo44FB9Iw/R2iEXH3aAQAtqcviQkwUyS
 v0pATP5y6epbVrMssohp1d47GgU3RFMKJ0/K4YyrcYrWI1Z9ue3zM73yEKYZdbiyCi8rtUN41i
 3YVKC8iJpG802o6Q9wd/PxNOl22p2kpDk5mwlEJyVwPoM17Vrv+xkwhhyfSMfrAIOdxk+5UpDh
 OQw46Ow+wsaF2Abs/CIigCxG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2021 00:25:50 -0700
IronPort-SDR: 45mIB9a3kPaZT45ITWNTcPeuOKSyxNfYC91NcK604gespplMBM3w22tgseVEaWVa5nMU6D2pxv
 QQAMePXmBcorhCm6O0u8a9ulOpYtbaFnBcdvzS31wn2+X5JeeLmJATE3p9Hpd0mFD5+thuRFuK
 4MTlvpGynw7jwhhNeDc9w8wQU/CowBzeftWYrEJS+dfaLIjJJX9LGtmHuISSfgQqW+MklhzQ4R
 DJgd7hMyaJPevSKlt6l8gvxkO+dDL3SMoTU1N7fF76yXjG9ZmONrAEH3ysbaj22w5Wy3q/9Kpi
 KHc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Aug 2021 00:50:20 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v5 4/5] doc: document sysfs queue/cranges attributes
Date:   Thu, 12 Aug 2021 16:50:14 +0900
Message-Id: <20210812075015.1090959-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812075015.1090959-1-damien.lemoal@wdc.com>
References: <20210812075015.1090959-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update the file Documentation/block/queue-sysfs.rst to add a description
of a device queue sysfs entries related to concurrent sector ranges
(e.g. concurrent positioning ranges for multi-actuator hard-disks).

While at it, also fix a typo in this file introduction paragraph.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/block/queue-sysfs.rst | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 4dc7f0d499a8..757609bbb1e2 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -286,4 +286,32 @@ sequential zones of zoned block devices (devices with a zoned attributed
 that reports "host-managed" or "host-aware"). This value is always 0 for
 regular block devices.
 
+cranges (RO)
+------------
+
+The presence of this sub-directory of the /sys/block/xxx/queue/ directory
+indicates that the device is capable of executing requests targeting
+different sector ranges in parallel. For instance, single LUN multi-actuator
+hard-disks will likely have a cranges directory if the device correctly
+advertizes the sector ranges of its actuators.
+
+The cranges directory contains one directory per concurrent range, with each
+range described using the sector (RO) attribute file to indicate the first
+sector of the range and the nr_sectors (RO) attribute file to indicate the
+total number of sector in the range starting from the first sector.
+For example, a dual-actuator hard disk will have the following cranges
+entries.::
+
+        $ tree /sys/block/<device>/queue/cranges/
+        /sys/block/<device>/queue/cranges/
+        |-- 0
+        |   |-- nr_sectors
+        |   `-- sector
+        `-- 1
+            |-- nr_sectors
+            `-- sector
+
+The sector and nr_sectors attributes use 512B sector unit, regardless of
+the actual block size of the device.
+
 Jens Axboe <jens.axboe@oracle.com>, February 2009
-- 
2.31.1

