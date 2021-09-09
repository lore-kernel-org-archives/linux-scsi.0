Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12C75C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 02:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E912E6113C
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 02:36:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241443AbhIIChK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 22:37:10 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:42527 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238723AbhIIChB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 22:37:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1631154952; x=1662690952;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=GzrETZRidFfNItPSNL+wFqWCgQ95fWYFF2GYt16RvEc=;
  b=AFZF0zPA1lD9CaRHFh75HUIQadKyxw4215iTVLIm3hMB47rK3TwGK72R
   /LqsvaIcqYd7AaKpX/jH6PUVIg2l1WgI4Y22bScJBfFy5pjUsAXUGIBOJ
   m7sxM4dLuhV3hyE0tVuffe1Kvuhl16nMx0uNWP3TP9+lWXjUg87k5N+yA
   wYbvfQQGsy5G+hddt1vww2UvLY4FI6Scnv97zncI3O+5Ta0gqNaRKzRIB
   hPUrplVxPcFFV0kviKXtlv3I9br0MDOOxnMJkUT4C11D/3C/9u6zICJHp
   PTo/MPzFKNIMmWws45mlk/kdUVYzisBWDOItKlJgmWJUA/wAvMV51kpzW
   Q==;
X-IronPort-AV: E=Sophos;i="5.85,279,1624291200"; 
   d="scan'208";a="180062216"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Sep 2021 10:35:52 +0800
IronPort-SDR: 1XKXK4zGeBJLzOfuSCd/thL1jHxgx8w6s7RIpmc77QJ5H0gpKrf7/V0kQ9rRDfEc0m3d4bNgwJ
 scsLev/LglG/ZoppqUMzHU7ZbnJPl/s56csd48VAMQXoYBjO0S7BoO0fjuXb+HISVg9wPMIdsf
 dauQqZ8ZIr2MNNAhPmiGN7/s79pCpD31+SBb3Nk/N5n8ko0IbIp8m0V6jZBV+XKA5IHWNslcrI
 CZRfPPkiUEZqcXIc8/h83QEqJFbo4iFkmcFMAvDLvHiFbpPvw6TiqjD50ozXk58rFqz5GJAHSq
 K9bfUvGXpabzOFzl+sndCp2W
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 19:12:27 -0700
IronPort-SDR: tN1KWA0S2mGa4HfJ8XCgr9akIGIt/PP/mv7Z76fEtA0hg2rE7wgLCSzHJDUQca0t98m4WgB4OP
 t5BI1QGmMuorXtZuP5pCTdooeBB66XjmO1vqHvs0U9gQ+fe+9YxU5zQR3BYDAwm6vMAsfU9TK6
 qW6KgSmWzA/+YNetX7A9EO0tTOrlqoEuZ4w2SSl0NyCnG1mSfN08hGY3G9LJNQgLJGS4/YEkCe
 eH0AgTpLsoyiAcj1efSSWk4P7OIokr29rsguZFcNwXAkkD9MMMsSQIRqCUHeVG46Bf7clKAJec
 CfY=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Sep 2021 19:35:51 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v8 4/5] doc: document sysfs queue/independent_access_ranges attributes
Date:   Thu,  9 Sep 2021 11:35:44 +0900
Message-Id: <20210909023545.1101672-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210909023545.1101672-1-damien.lemoal@wdc.com>
References: <20210909023545.1101672-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update the file Documentation/block/queue-sysfs.rst to add a description
of a device queue sysfs entries related to independent access ranges
(e.g. concurrent positioning ranges for multi-actuator hard-disks).

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

