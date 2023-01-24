Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B41C54EED
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 19:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbjAXTDd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 14:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbjAXTDb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 14:03:31 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E9B4A1D3;
        Tue, 24 Jan 2023 11:03:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674587002; x=1706123002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=svVehXplb02VowJ4EoTxl3Wqf+J8HsTcqAMlcWrlec0=;
  b=nAVNZubp9bvMbchgT7Qc5TOIQJdpGKUjlZTeFK82PGCDKQ3/1+Qx/JjK
   sMLRpZj50cmJV+WsJYyWMzr42ZwgJOVMn2H/IINvBuQb0f6xnAuQb4fkq
   n4mJCes4MiwyeinvKLB0vfKJ94+Zgqz6y353ujbOSW/tNjRQEuT91T58L
   XDy1+GgR/PY52koNaJvKhO/A4AeHNxsS0FY0Wtx7XBYBnUd8e8uTtYPiT
   Z9woXjq4robBvTFl20BnCUvyHKgQAAyl5bMbhi4KzHWt7UBQriLGxQZat
   U6C9+Sx1PhcL4Al9aHH6/V1ap5S86XYq+gNCxEDsADQe/xypVOEumteah
   A==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221472925"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 03:03:22 +0800
IronPort-SDR: 27XlF67F+t5m7u0aacHnYtWjkv1JZyzGQKCMoC8+RjKMoD3ZuyM7jDGVQPnGLAzkkm15f6Vj/u
 561pD22pFZt0joJJsF2teK4PSKy3w87seWkzdAn3Z+3/fD6Drpqv9E6Us3czEH/gNplkzDn9Ir
 eno7m/8qfHnNT4piHusRRyrxHVXYmABMX/g9+c6MjgNhev1Nk+wCjrQ8bs9Nb1ZKB5y+FA/7Lo
 SkgJlKhd0EbdP3sElTNsJLmi1h7jyexFTEyaMTahmh4TlI7/ke78saMvMekSzoknEeTwDbRU9l
 Mq0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 10:15:11 -0800
IronPort-SDR: qv2KL4ExEdEJri197Mb+lwO6rT8Pt5sNCoTqnLG5+6qxOnU7Yn1HQXi4X+B7s+gbrDBz5bJqTm
 x/gifDAjSOE9FqmlP/L+fHQsWHy8UFIlfy8HK6CzTG5RhZzjGYE4Sfx+VDvZ95XzpATxH4lt+w
 g2NN30ByfMYhhgW+OenxFkQhg/ojc4IoxkgvfVFF7bmbwM8p58xzddqtBvwxG6K5kT7OmifkSC
 FPaF8BaYTzvsg8HJW7A7braeWs3O26lw4qJng8SxZu4zBKzSqX8iUclkDNhKQLoyfi3OLncAUx
 4ao=
WDCIronportException: Internal
Received: from unknown (HELO x1-carbon.lan) ([10.225.164.48])
  by uls-op-cesaip02.wdc.com with ESMTP; 24 Jan 2023 11:03:20 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v3 02/18] block: introduce BLK_STS_DURATION_LIMIT
Date:   Tue, 24 Jan 2023 20:02:48 +0100
Message-Id: <20230124190308.127318-3-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230124190308.127318-1-niklas.cassel@wdc.com>
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
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
index 46d12b3344c9..9ca31b779fc1 100644
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
2.39.1

