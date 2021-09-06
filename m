Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2263EC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D4EA60F6D
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 01:58:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238665AbhIFB7k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Sep 2021 21:59:40 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:22459 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238908AbhIFB7X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Sep 2021 21:59:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1630893500; x=1662429500;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=UeMxn3O3a5dQiuRdZYEQiywnhJ5mySyNi0lx2Vh5+XQ=;
  b=fHMXXxOKHyBwA9nHOCgCvK4aLvLjNxd40/G34Q/HtOD5kNBfyP3632DS
   pB7nYsaLmYNmx7ab5gzCTiIZjxv+rv1FRqYI31wGlXao39I3LeITmiKrU
   1uiRIKx9MCAVAtxd06yyi4VxmtcVR2QZqGrqImrlUGU8BONuyFATwlOOX
   tcq0V3oLi5kj8oyfiuk8v8IMNRZNve49V0u5YHN2WgcpwOLvT5Dd8Kdg+
   U3uKL9pEtA84y98OyvkYkmmBzZ7XctEF3VjP58vNeD+bMETeL7+OYczR4
   JWROIpoxPXMAhXe4HL0xQRUlPkgJoyGASgo/MWxUKYIzwep7fdOkmCzEB
   A==;
X-IronPort-AV: E=Sophos;i="5.85,271,1624291200"; 
   d="scan'208";a="179789034"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 06 Sep 2021 09:58:20 +0800
IronPort-SDR: KUlV65eOtrQpPo4iqlt4PoFKiRgMUttlwPNg+0WbiHrfZ8Ae9VwI5ZOWSEeVK2X1lOn1mzvcNi
 LdxcMNmiefK4+4vdhOg7Qt44NuB84QmXW1wtSJWOLllrMr7F2GHyORaD2Yck/m8O5qlAhmTW4+
 4n95MjgP/+fDQbrpWiTL6kXhSfeC7nL+aht3++Ggd5AENwFJE0HH7kNQkl5Q9DCzuPF38z8uDg
 g5bcb+JRGa71B2Q9KgPrc44toKpB4JYIPQiRAn0ldR39ijSJ60b1OMq3qEF5c7FBEJOkIDJ8M8
 rGsOttwEN2KeG6nt1RI1PzZH
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2021 18:33:20 -0700
IronPort-SDR: qU/VE53OEQsWG8FEzEnQVWPSz8clj1JSG9LmpWKkdBpFMIXp+zxbc1khRoCeNUB1yDVlEEuOGw
 vnRAlt3gPH1HfvvtAQJpNwCfU2I9yc2H8zqwS8+HJTq66Ans5jb5cIy9M1Vf8BLlhVb6Sqptyr
 Y3GIq5RtWunI7BKU3PRmw3jBFBfkEv5w/8QQsqgagnXCu0VT7+mw46uFFna8M/C/SCD0oV+qdg
 xwGhtabrKwEGsmwe7gh8yfEXjy0MTIGL8azJSUvC7P3ASPVouosjdfacHts/XJl3tH7kv3n0gZ
 VDY=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 05 Sep 2021 18:58:19 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v7 4/5] doc: document sysfs queue/independent_access_ranges attributes
Date:   Mon,  6 Sep 2021 10:58:09 +0900
Message-Id: <20210906015810.732799-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210906015810.732799-1-damien.lemoal@wdc.com>
References: <20210906015810.732799-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update the file Documentation/block/queue-sysfs.rst to add a description
of a device queue sysfs entries related to independent access ranges
(e.g. concurrent positioning ranges for multi-actuator hard-disks).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/block/queue-sysfs.rst | 31 +++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 4dc7f0d499a8..b6e8983d8eda 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -286,4 +286,35 @@ sequential zones of zoned block devices (devices with a zoned attributed
 that reports "host-managed" or "host-aware"). This value is always 0 for
 regular block devices.
 
+independent_access_ranges (RO)
+------------------------------
+
+The presence of this sub-directory of the /sys/block/xxx/queue/ directory
+indicates that the device is capable of executing requests targeting
+different sector ranges in parallel. For instance, single LUN multi-actuator
+hard-disks will have an independent_access_ranges directory if the device
+correctly advertizes the sector ranges of its actuators.
+
+The independent_access_ranges directory contains one directory per access
+range, with each range described using the sector (RO) attribute file to
+indicate the first sector of the range and the nr_sectors (RO) attribute file
+to indicate the total number of sectors in the range starting from the first
+sector of the range.  For example, a dual-actuator hard-disk will have the
+following independent_access_ranges entries.::
+
+        $ tree /sys/block/<device>/queue/independent_access_ranges/
+        /sys/block/<device>/queue/independent_access_ranges/
+        |-- 0
+        |   |-- nr_sectors
+        |   `-- sector
+        `-- 1
+            |-- nr_sectors
+            `-- sector
+
+The sector and nr_sectors attributes use 512B sector unit, regardless of
+the actual block size of the device. Independent access ranges do not
+overlap and include all sectors within the device capacity. The access
+ranges are numbered in increasing order of the range start sector,
+that is, the sector attribute of range 0 always has the value 0.
+
 Jens Axboe <jens.axboe@oracle.com>, February 2009
-- 
2.31.1

