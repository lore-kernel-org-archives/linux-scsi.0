Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28058C6377A
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 398716128C
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Jul 2021 10:48:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239387AbhGUKFU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Jul 2021 06:05:20 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:53613 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239025AbhGUKBw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jul 2021 06:01:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626864149; x=1658400149;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=uQP3CdubqmQZPiPY+fgwiZR463GJzvIEuEEIrPo+s2w=;
  b=QkguLOSIv8ny4H0fkJupnHuLxYK0OJz6ZBh2ISsPzvNX3r7SNefujwHO
   AjVlscV60I5i8KtfqFU9mkDzviZ+xForFX+MvTGVlj7Z0snUZIFjXJYKr
   CHbp0Bx4xnTX53DKR/JSuAyEiZ0YRicUyWxnqW6P8oSGuzJXPolaqYmq6
   zUTfVITpdDitV6/3g1k2HQbS5AslQg52ChFB71OMfRKm4rD7TDXXEIlRl
   S9kUJhrGkekMXouArG63PMFqXgvACgzgA8DS1Jee7Wc37A8DfV/WweDtj
   uwstJhORdGx0U0BSqWsZxT0SGKwZ0n7D7R9vn3on8SpCt6rFoxOI1mTyp
   w==;
X-IronPort-AV: E=Sophos;i="5.84,257,1620662400"; 
   d="scan'208";a="179944869"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Jul 2021 18:42:12 +0800
IronPort-SDR: ifU48VsC0IdYkXmpAip16IthDt6A4DbqtHfS5Bg7PdmuXbyZo1iQtmC5EKInnuXRLS7gFiVb0a
 6aQjc5daS5glPHKBRAj5n6onXuJKPZ2H568clgXmoIadTjJRDIaNvNFJgm6x2d3xaH3W2CclNw
 Ti6IkH7BpwT543tSyY5OD6tEBATiBkZznfu7B/J6cJ75DCdIIpNW4Eu33hYKPy3uBqWxhVMtMy
 /0Wx7+CEphFWUlob4u9sUfjEy+2wX94sYba8ORwLK81IzCPIntnlia9alwLFZ4yjICSbIQr8AE
 KKQRI2Ol1wHlBHzvu0C5kDhY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2021 03:20:06 -0700
IronPort-SDR: 1qCu7lDYHJFdF9VhS+q0kcCqa1PAYXgZVJo6CTOseycZHPjelo8Vwonw87xigSbkmVQYD4HSyu
 +PknNeMWp7NwH3xcHxqEw+daQhp1vMgTdC4gxahx21WfT+9rovYLAZQ/wCn79BQg51HrpZRgo6
 VkfroFBh6bkPX6eRf185V8WU8n4iHUG17LKUmKhS3uD+ltlkEAjUlYT6xZwp25vPFtODHjqRWq
 WUy0w6TZn7BbxXf0hLZ3fghuUzeSJRgagOlEAH6WAebOgKdTmFgTFRJSz2nLc7Md9wpOitWbWY
 faA=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 21 Jul 2021 03:42:13 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org
Subject: [PATCH 4/4] doc: document sysfs queue/cranges attributes
Date:   Wed, 21 Jul 2021 19:42:05 +0900
Message-Id: <20210721104205.885115-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210721104205.885115-1-damien.lemoal@wdc.com>
References: <20210721104205.885115-1-damien.lemoal@wdc.com>
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
 Documentation/block/queue-sysfs.rst | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 4dc7f0d499a8..ffbea0c7a576 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -4,7 +4,7 @@ Queue sysfs files
 
 This text file will detail the queue files that are located in the sysfs tree
 for each block device. Note that stacked devices typically do not export
-any settings, since their queue merely functions are a remapping target.
+any settings, since their queue merely functions as a remapping target.
 These files are the ones found in the /sys/block/xxx/queue/ directory.
 
 Files denoted with a RO postfix are readonly and the RW postfix means
@@ -286,4 +286,29 @@ sequential zones of zoned block devices (devices with a zoned attributed
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
+The cranges directory contains one directory per sector range, with each
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
 Jens Axboe <jens.axboe@oracle.com>, February 2009
-- 
2.31.1

