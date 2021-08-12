Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07F4C4320E
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B62E960FC3
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 02:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbhHLC1U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Aug 2021 22:27:20 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:55307 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbhHLC1Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Aug 2021 22:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628735212; x=1660271212;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=YlAMtc1NFjSacQjRaTROX9F+tPKC3ulFDw9e3bnV9hc=;
  b=S+J4QxlDP4M4U5mKyYZbkeW4TS4q6Lnl4lR6fVxr4xtSLrcY+iSQyC9k
   zdPqhpyprPthwr6qk6m4C/RhAyK0+qIA6dpjUyqu235whH5rctuafM0nC
   46IvLb6xssS8h4iAhFORwbdjF+8nvjxH+CLvydYNbxYB52NiYNhUGLFgu
   nki0VJWQB5Casak1VMgLKJYJp4QAOYNcDyBvUnmb9AzE2lnTnnr2WPPKy
   NYA/KLL1EaZYPmKdZ6sZuY9Rc3UKgDYACrwVRPHG0P6zgQjdPxPxsXq/W
   1uAlWTL2qIxxFpEn0VR8ivtp7TAWOFGshq2urYX5N7iqvYmmQAEZoFMSy
   w==;
X-IronPort-AV: E=Sophos;i="5.84,314,1620662400"; 
   d="scan'208";a="280823447"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Aug 2021 10:26:51 +0800
IronPort-SDR: F8L9J5rhEmP9+/VTbMjVYNjCg9I2NjPb5Tg/urvNCmx/AjTMUugVPOV6bh548eKN7oz49ISShL
 Q6wwr9wtHAqKUwwBDzs5TciNHFRsLRY0TqTeObGNQUBYvMXktFSTyOqSjqeRgDK0mp/U4jOLE4
 3eQ5a1eugKfFomjl0QGb146dhgrmkOV+Voi1XAGR/SgI+EfXvSOk7Cpk9GBlEFKTLeM6CLQPkr
 4fSjiy26mG0EvBRiLufoVUpOO4O+iFx+4me4WVOrSUyAHmMDGWjGA15sEcOzmVowjouyqkZSN3
 4qAmjpyyamANK0SQxU090DoN
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 19:04:11 -0700
IronPort-SDR: lJREHWqVL3eXXswXTUw02WIfvDfJPa6EGfnf7NlUwgKpkCTy0okz87liIltWTZ+dVcLVVS8pYv
 zsVOPP7FC4ycP7cbwIoBFAZ3S/3sP7gElw+yga632FADis+SA/emfUgk0azvc2bi437n7fbYFh
 ke9w5F3hd5vyNhtSOvQBx5snpuNbf+gFgMflPjfCKshFuR6gLEzmgalyFfK/FHrj94chHCqnI+
 c2aMO1POEOeLaEttTHp0nCmupckAHAWZkgQG/WGPLiW8JSiBaL92HIkskP7BW7HcWIEXcDmPiA
 5io=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Aug 2021 19:26:51 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH v4 4/5] doc: document sysfs queue/cranges attributes
Date:   Thu, 12 Aug 2021 11:26:25 +0900
Message-Id: <20210812022626.694329-5-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210812022626.694329-1-damien.lemoal@wdc.com>
References: <20210812022626.694329-1-damien.lemoal@wdc.com>
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

