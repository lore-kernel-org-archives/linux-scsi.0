Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F8B5C00144
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 01:22:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A46D60EBD
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Jul 2021 01:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233072AbhGWAlg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 20:41:36 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:43109 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbhGWAld (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 20:41:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627003329; x=1658539329;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fpqlmg/Ix9cd3tQyYAdjWjc+IVx8h6CJqsftFHNVSGM=;
  b=HNkapwUe74UDa5SEJWZOZtsZlAUnQAjg4alhZFxBBR97A/Rtvk64m5aw
   0HZKs6ZZ/THMkk9xxNUWdkDYrY12mtqXNy4dfTxsq8Gb0JK5018BoowGC
   p6HPts+NrionfJPMfv2IRdvjCPI55G38F/9pqbXS0zMIj6L7BeATIksxV
   l69qWhA8HKdaXUGeUikH51zdgxYGta6kjtxw6zZzXngEitJVUVeTOwmxf
   xZSgq4p1a9N/0cEpzWUZl0XLdfXVGwJICPytrKtAVuiaNMNgJrbc1/ilL
   R0KVtE+kPm50vbpdD9t05MOasS9XzqcIWVil+KlYqDZdLmeJ3AarIafPd
   Q==;
X-IronPort-AV: E=Sophos;i="5.84,262,1620662400"; 
   d="scan'208";a="175874127"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 23 Jul 2021 09:22:08 +0800
IronPort-SDR: OAuTfhH1Ku7ElghWYcsAVbdMF2fINNdMDQ5Lw8LT/ydP+SwQ6gpTj7dPP6NWtyM9AcjysdkMkI
 Li0hAVvLEdPp/hp/KNo4m5sCNqzxHBSeC6Sb6OdQ2UqyEQVeS/vroBGPliV35b5PFnBwsTU5Cb
 ykYnjMf9ZTanp6yK5ja8mP0b1e21qktFJchnCbNrhNwWG7LLbaFwhf3lzsrLEyJE1Zn2AEZeyB
 mls5HparWPza2odeXshwe1COmwQ6SIQGBnCi48fI0pvR9URCDH+RAjHWGvPNen2YjcTWx5i+av
 wY+TA+IM4zf9NXZCLE9cMcW7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2021 17:59:58 -0700
IronPort-SDR: Ro+nQZ4/KBXkhCujmPzqjhLSP41jBw0T/A8simmQRMIEb2T8owBdgZFP67YRVgyS6OM/GVcWai
 KCy091i+ByoI82fMdp63P6YgDWcA/Yr6JcItgvqzZhOKKDobIdg8+qAW6M5kgmm0tz1W4k5ZGN
 l78NVgo3FZmmOZ35grDlOq35rFJi6ehn2ufU558SwT5hgMFgoOBGwamLJ+CDdBDxAG13im0Pmo
 AEpZWlkcO+LaJTN5+lHhswINPUMe9zNm1GM7+JozNuvZHDbYQ3kb3XkYse5KlG94bIbRoq2Zy7
 N0w=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 22 Jul 2021 18:22:06 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH v2 4/4] doc: document sysfs queue/cranges attributes
Date:   Fri, 23 Jul 2021 10:22:00 +0900
Message-Id: <20210723012200.953825-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210723012200.953825-1-damien.lemoal@wdc.com>
References: <20210723012200.953825-1-damien.lemoal@wdc.com>
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
---
 Documentation/block/queue-sysfs.rst | 30 ++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 4dc7f0d499a8..25f4a768f450 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -4,7 +4,7 @@ Queue sysfs files
 
 This text file will detail the queue files that are located in the sysfs tree
 for each block device. Note that stacked devices typically do not export
-any settings, since their queue merely functions are a remapping target.
+any settings, since their queue merely functions as a remapping target.
 These files are the ones found in the /sys/block/xxx/queue/ directory.
 
 Files denoted with a RO postfix are readonly and the RW postfix means
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

