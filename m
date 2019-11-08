Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C92C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A69C521D82
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 01:57:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="R66SntI1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbfKHB5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 20:57:17 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12762 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKHB5R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 20:57:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573178236; x=1604714236;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=eU3UPObloIUO/IHs6JVYQB0lk+QRMMWcTIgAimNInc8=;
  b=R66SntI1lWGpXRSjWs0slYKdBNjZICuE4oM9H7lA4m38YN5+wqU81HAa
   NenPK+/P/K4Ev4krNVDFOvx1HyS/fDmpCZ0e0rUTtgo/eB9+cW+yfuLT1
   jwVURFU3ac/GTX7p2tDeKOGoXTNjgDnHEXb1b3F0SYwvMa/aa7Ppgj1Tn
   d0gOS69+XY+ODe5wcOfKTJN1mj8vnps2NXpjwX+WzaIsoG0uA3qS+21j3
   d+tZ1m5qZESANfgy2Uulf7av3iZOBQPIc0bjHptUjiH7HQQ81nj/R881E
   KqUD+RAH+ieIVHxdAcdEZ0aBmsfwSio+LMFbtm6CV5uSMOjXPnqIYh9VJ
   A==;
IronPort-SDR: WXMVCfbwbiZaRrWzIYACr2b/AZShZ04UdejeT6tvCZAdIW+7r8NUG203JKySjss0BgEJLj+2dr
 oPEmlwQsJWcMJeD7PuW20YBVuwKHPV/WF5Qf9H2XdM+z/yizRsPSn3+PsOy8gc8gKZCFvF8MgB
 DcWdjZGOENvGPgXxUw1L++HtHwAZyZzsbpsi8+yGPkFbtvFnaFBOj79dycj/NwcrGdsOgdSmFQ
 ugaA2iiwtQ+MMjvkh9bM7gdiazU7s7dvoaq6Tcirpf8PjxRr/LV6RpeyqlYeeVefUeezxzM1e+
 6Pg=
X-IronPort-AV: E=Sophos;i="5.68,279,1569254400"; 
   d="scan'208";a="122437218"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Nov 2019 09:57:16 +0800
IronPort-SDR: 2mDMB4j7+BJUnbnLftJqDcuWl/eUAB0WJowGr9ucxmbnhlfJnnG7FOqcKbj27fXhd9gpB27tgY
 KlNBK0fVWmviq7MVfxHCfsV6/rAck9+K0zvRa6GVn6PAJpwoP+ln9IZ+mXnbLiro3Ky4Kwhowz
 8SzseiZe01H22lxsv+O84lO8VmaeaTk8M0olKb46Nxx19CG6MT8wzsVGCIaBK145UmenHolb3N
 n50RgH+7V7CX6Q4GKp6GIkKNaE09eNitYd5xFAdV0Znjbcs5v0EnrJX27y5KvqU3gVyOrazRKb
 c3crJGXo0nH/JoNgwKsoZfr7
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2019 17:52:26 -0800
IronPort-SDR: eEzgyNms9DdIGk7sRIpN96F8FHGQ06z8avuZlFaN3KKigJBu+LO6ibEz+bD6UKDLObxbCGWKrq
 qXxDKKIVequs0bz2Mmbc2gCKQ8RIIFt3dNjcaHsmUhYC81ER/dlQzPyeEwS6AAJbdoFl3NuE3+
 GP1SLuVOOCyvTrPg6u8HiBFq4tLtmeEaOZdfiEtANGNEn2h8kSQL4eVWOKDVK9X3VfpodIFDIH
 2j9psiwRP02r26em63ZNUVJUGD9fDwUWMsLeCvbu+LVXK/Wg8I1PhoyH5skaS419+eKEEEO0ZC
 hJU=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 07 Nov 2019 17:57:15 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH 7/9] null_blk: Add zone_nr_conv to features
Date:   Fri,  8 Nov 2019 10:57:00 +0900
Message-Id: <20191108015702.233102-8-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191108015702.233102-1-damien.lemoal@wdc.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

For a null_blk device with zoned mode enabled, the number of
conventional zones can be configured through configfs with the
zone_nr_conv parameter. Add this missing parameter in the features
string.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/block/null_blk_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 2687eb36441c..27fb34d7da31 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -467,7 +467,7 @@ nullb_group_drop_item(struct config_group *group, struct config_item *item)
 
 static ssize_t memb_group_features_show(struct config_item *item, char *page)
 {
-	return snprintf(page, PAGE_SIZE, "memory_backed,discard,bandwidth,cache,badblocks,zoned,zone_size\n");
+	return snprintf(page, PAGE_SIZE, "memory_backed,discard,bandwidth,cache,badblocks,zoned,zone_size,zone_nr_conv\n");
 }
 
 CONFIGFS_ATTR_RO(memb_group_, features);
-- 
2.23.0

