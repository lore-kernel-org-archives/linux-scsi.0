Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F793C74A5B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 21:56:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjCIVz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 16:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230082AbjCIVzf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 16:55:35 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94A7F0FE8;
        Thu,  9 Mar 2023 13:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678398933; x=1709934933;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=d+E7JcGzf0SMWiOrDJveN7XrwtqcVN7nUvLupMhlC80=;
  b=WUdxPtex0xvmTr+ma/708Earu2mmWoedJWvM3ti2rYVM8TSYlzRX1Uxb
   YAGrmSv/fwPgXUsCvst7jEetD3a9mLZFlSemdr1ha1KDEjf9mBTvzSZw+
   r6tsjNVzSgj/yjJBXFsS3SnI1SNv58tXYsMNHxLoLtkxahK5L5irEyec+
   XLoS4CCEPcSmpA/NhtJOh26VMzXEYw/7lOAWM0Zvjsjwi2NJKfEi0oKE1
   9VRRRsdrJaZOqJ88uGYIJKLLKuQwsNoifLECgkr3XEr/8o5IPdtGRn08x
   6TJySnb3MEyg4i7isXcRfEipegjhr4fx86HoXeYY7fs5W5xcqvkgjkIRJ
   g==;
X-IronPort-AV: E=Sophos;i="5.98,247,1673884800"; 
   d="scan'208";a="225270952"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Mar 2023 05:55:33 +0800
IronPort-SDR: qP1T+Xr3RTG1s7PqQdJv2sbdfGpnXTDj1xFsAqHS0H3JwoE77eUdoJh/AQm61QvrDztmh5cxGH
 2HoUgENdwheKYQXR3oO1pXo3OuPfFvIAzENXfgpK7oqONhxweSCYV4+ei638yI7JeFJNocdWgU
 HjjF8PYAWhPaJjHCgOZ70XVjmyqIMvggZrXYeD3PXynr9DKtzCQhk8p811w7uYTF+KC0ATF/a/
 wZ+4CKsUzAGZw+6g8YW3RnrmizXVVxVHz43QsLrBnbXZrbc2lSO5wmlNA8SbiQORfepbTZJ6Ii
 Ezc=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Mar 2023 13:06:26 -0800
IronPort-SDR: CUEI3JroSlx1VvH93TJMFdV4mdWVkrURJsY7u+A3hE1Buv64p9lxDRK3Tf/2z6N4hm/BIPdH/U
 Dfczxl0kbpjroXk1TYin6Cp3ExhucUSXmTJ3KWwv++UJt1kea7pXHA4+rty/5MHhjsPnnQhhCw
 kGUR47yRkRZ7mkc0rx+2rUpDV/9ziT+XmqLmw9boXW2giz2nNcGQ7get57cVMhfrMsTNzAzCm+
 T/WeT+16+gxs7mkd9kv/msdkHsYbp2oe7WaJlvc/Fl7ZpmLpKejk7e0qE2EgB9qQHxsH2EOq6m
 wMs=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.wdc.com) ([10.225.164.41])
  by uls-op-cesaip01.wdc.com with ESMTP; 09 Mar 2023 13:55:32 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v4 03/19] block: introduce BLK_STS_DURATION_LIMIT
Date:   Thu,  9 Mar 2023 22:54:55 +0100
Message-Id: <20230309215516.3800571-4-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230309215516.3800571-1-niklas.cassel@wdc.com>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Introduce the new block IO status BLK_STS_DURATION_LIMIT for LLDDs to
report command that failed due to a command duration limit being
exceeded. This new status is mapped to the ETIME error code to allow
users to differentiate "soft" duration limit failures from other more
serious hardware related errors.

If we compare BLK_STS_DURATION_LIMIT with BLK_STS_TIMEOUT:
-BLK_STS_DURATION_LIMIT means that the drive gave a reply indicating that
the command duration limit was exceeded before the command could be
completed. This IO status is mapped to ETIME for user space.

-BLK_STS_TIMEOUT means that the drive never gave a reply at all.
This IO status is mapped to ETIMEDOUT for user space.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c          | 3 +++
 include/linux/blk_types.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9e5e0277a4d9..84b8b8b482b5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -170,6 +170,9 @@ static const struct {
 	[BLK_STS_ZONE_OPEN_RESOURCE]	= { -ETOOMANYREFS, "open zones exceeded" },
 	[BLK_STS_ZONE_ACTIVE_RESOURCE]	= { -EOVERFLOW, "active zones exceeded" },
 
+	/* Command duration limit device-side timeout */
+	[BLK_STS_DURATION_LIMIT]	= { -ETIME, "duration limit exceeded" },
+
 	/* everything else not covered above: */
 	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
 };
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 99be590f952f..cde997590765 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -166,6 +166,12 @@ typedef u16 blk_short_t;
  */
 #define BLK_STS_OFFLINE		((__force blk_status_t)17)
 
+/*
+ * BLK_STS_DURATION_LIMIT is returned from the driver when the target device
+ * aborted the command because it exceeded one of its Command Duration Limits.
+ */
+#define BLK_STS_DURATION_LIMIT	((__force blk_status_t)18)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
-- 
2.39.2

