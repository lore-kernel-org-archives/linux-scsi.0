Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D72EC6370A
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 11:04:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbiLHLDs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 06:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiLHLC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 06:02:56 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10455CD2A;
        Thu,  8 Dec 2022 03:01:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670497278; x=1702033278;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DL3+bdlAlVJyOHJFHmnZNgLXM8VisYLIjqtEpyzmztw=;
  b=iRb2dIfvFzFFEZP+QquWFc/cf3USk/BeagOQhVPdugKAd3TV3HFYzJNy
   D3wwb2z4L9qFODfUkkdXp/KXqZEdfBA1VUrTDz+9JQBv6sK4hyWKNGCs0
   zYDbmbFUnfRaPq3Iy6M3eIi4PV89Oe9zqthiKN39T81NuZcB62Jn382Hk
   qiAFqs9jeU38wr+1L5+6SOzNiRGlF1Aqs61v61S7LTPZoKfSDLs6FBtIh
   uynxFd28B1ze4M3lwmWxvvPnKpD7ECpjqBU9ejmD/1ar2jTrSuSVLu1Yt
   QxJwpuPYm0da2rfyTgqCc8ULEqTBVWDXV5GqnimlsxriRMVuFCM1ig/M4
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,227,1665417600"; 
   d="scan'208";a="223333404"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Dec 2022 19:01:18 +0800
IronPort-SDR: GGAF7BE+hXSUkIi57qZIzEk49biCE6b2dC7rUoko3DgyPsoaaeIBLtLvgLeRAK+kLl/mpPNGX8
 fHXKSAaB4P/qAVHO6OxopBHjP2K9xXgFth6vlvDvED35g/1W2D3yeDUKbD7LqBGyutGX2tVBut
 iMHF6tqRxFR39pN3egwJ7E+31fOd6OirLwEqpLCaAisTNgx/0pnQquXVkm/9Z4g8wdfDoJNVT4
 eKDN1Ug4eBjHANMDWJJ2WKSl9HSzVTOvWBr3Bse2fiymmSNS/sKtCswnPABfmD84r/UkRmcIKl
 xNg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 02:14:03 -0800
IronPort-SDR: 1giZiys6opqWDb8rUovSg/VnLPD94zAlMtInV7HbHOLoWaD87iyxxlfppqjpzE0ZoMNCDyeCaT
 7kdhnzqrdiorwEF7XLOpHWh+thTk6ZgzwsGF4paPiJ/3K5O8Fnq9Jg5yypdV1sIaZpZgFY6sEG
 1AoWpEJr+zvAy/O9S+GUEcLOrTHNkUcEuSQsA80FG040YqDhFg3m1blTyt/v6HVyjSEwoIYrPc
 bU34Dgcn28l3wbUs3OcBd1bEFWh0y6H4Knz/wfO3QLeMiZ1G2Om9F5oJ9B5bDYpKDDKHyvzfmj
 Lsc=
WDCIronportException: Internal
Received: from dellx5.wdc.com (HELO x1-carbon.cphwdc) ([10.200.210.81])
  by uls-op-cesaip01.wdc.com with ESMTP; 08 Dec 2022 03:01:18 -0800
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        linux-block@vger.kernel.org
Subject: [PATCH 15/25] block: introduce BLK_STS_DURATION_LIMIT
Date:   Thu,  8 Dec 2022 11:59:31 +0100
Message-Id: <20221208105947.2399894-16-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221208105947.2399894-1-niklas.cassel@wdc.com>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
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

Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 block/blk-core.c          | 3 +++
 include/linux/blk_types.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 3866b6c4cd88..5cbb0e5f189c 100644
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
index e0b098089ef2..a357bbd51546 100644
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
2.38.1

