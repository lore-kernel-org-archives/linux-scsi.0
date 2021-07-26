Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25EDC19F36
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 01:38:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA38560EB4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 01:38:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhGZA5x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Jul 2021 20:57:53 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:5174 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhGZA5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Jul 2021 20:57:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627263498; x=1658799498;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Fpqlmg/Ix9cd3tQyYAdjWjc+IVx8h6CJqsftFHNVSGM=;
  b=VGS7JEHnVEDV/sj0C0QFSyxMfvc8SoNv9uDIG/U9lZ21k981/UETteHo
   snD2zGQP9O+p8b8mGmRX/Wljh6bGiHWeszmm9PtRNAailvMslFYHs7Gr5
   Znob4jtVzVX1mlhjM0rfChjErkRQuMqE0oxhj+YyTonFuwXQRSHb8f4SV
   WUN6sd9UGYv7kHU2R6PVf9ufEYlKgiJCgDJroj7HseFA3kb0tLUPxRT/M
   VelRFGHo7KlSPo/BYjveLYRuzktYAYeaUzyneiPKsywJyPfxBe2HIlC5g
   A7xS4s+iS8Mqd2mrL67RcUmy8BXN2MwJlDmb35bDfQA/YV5dMacS6CZ1K
   w==;
X-IronPort-AV: E=Sophos;i="5.84,269,1620662400"; 
   d="scan'208";a="279290752"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Jul 2021 09:38:15 +0800
IronPort-SDR: 4r3kS0wLwyxLK0CdO1Y2DSxq9L1v9CEE10CG/3JbsODcol1oWet4ABpPtnqd9H86hYx7QlSz1F
 i9AlVhDpSLs5zDL8bzhrdukxl4/vzN5EcsaxaQyIUaIF1fWizTmWoI1YRClexwYFGGSQ4ly2+J
 luOnOu0Qq5g8DqMhQFt9V7yZthtWcXhqm1EAvfRwYYWcIyGgB5ClcQq/NM1Bo7VVTGjN3cSY9f
 iMoz840h134hi00qWu9xzAX2GvqQKtFgJr2WsRfs5KISiBiCmfybbHVnJ2tGS1Agf1f8LE6yMy
 EY+He70MaOzuuGPgrTP9g/oo
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2021 18:14:15 -0700
IronPort-SDR: g0MRw9e4hMTWMCxtQA9DSC+F31DKaEMiNXyTAK+r+OEj4TflXEvkX7f+4fts+otMSszpK+xLLn
 dRsOmPcPiAwnFTszDhSwfCRrufvnMonfM7oBpmKJbCkfsx7i6fvOn3uuPNoygaQaPhvHex0Id0
 iiOahxOoteE90leuSYXe0siwC7yybBU7iPpskUNUZVptWLGSgM0wb/c+YetqZ+eu+D4RoxHxsb
 Lu8Wq/R4kATyPJA3OEAQt8FZdmfzhPoiGxtNqRP4FDnzVD3zqkHH0CAr6oDeaGFehsErsU5Kbd
 CPA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 25 Jul 2021 18:38:14 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Cc:     Hannes Reinecke <hare@suse.de>
Subject: [PATCH v3 4/4] doc: document sysfs queue/cranges attributes
Date:   Mon, 26 Jul 2021 10:38:06 +0900
Message-Id: <20210726013806.84815-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726013806.84815-1-damien.lemoal@wdc.com>
References: <20210726013806.84815-1-damien.lemoal@wdc.com>
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

