Return-Path: <SRS0=nyLG=ZD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB31C17443
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3594620854
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Nov 2019 02:39:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="n8+k64wo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfKKCjp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Nov 2019 21:39:45 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52028 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfKKCjp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Nov 2019 21:39:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1573439985; x=1604975985;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=ZiPMJXvFrkhjV/NQNmkkfkyUBz8ze5+Dwp1BnuDjbu8=;
  b=n8+k64woMpgPDhJrNZ4ck32+raxfxJfoyZ6D3YhCHBBm1Ox9px7JZO2h
   OvcjbBnCuOKzN/fPUi0iCCPgs21WC8pneU4pHp/QJRDFJQYnyqTUBswmY
   hCPistSwg8FTpKBntIPCG71rvOUrWqXJAUpNUUoS9sc0zTwX5JKDfInjW
   rERdIvpOKHGzLxvQWU4F2L36loXWn5xljZ3H4Mnt1EUk3p0oDI/acd661
   YVfDtwvdES6GhgFj4Yy0pq4BUr6T+Jrn0oF8jIvM90GnITF9qMmK1lSGX
   Bi4ePufzGMs57+1M33z6Gt2+SLNRpcGucY2KYm5vpdocWex26gabePVek
   A==;
IronPort-SDR: yCwUE5X9LqScjo/JWTgWyXbYKAYxoGe5g5iTLeqx0kePpVVMBX2Z4JJPXKLou7bp+2GnlWk23q
 0kmPu4IUSRimpIM0u8Qpcenjv82dKxUy0FN5Agq+wZZ0VWksfcum08ApTbFY30GdfXiJSBV9HX
 l3kX7jz0l8OcOKU4E56yVBP+lFv57sDUiQIsvQkBkg0ejV/S2/I1RkYLlrxhV3RA2+vtyWTRRF
 GJ7OGX1TDjDah8AkA7TnM8leB823lq9nX1es+55dig0rOqx6K2CD0G6lfzP6j7VKIVtFTRuUFQ
 dpA=
X-IronPort-AV: E=Sophos;i="5.68,291,1569254400"; 
   d="scan'208";a="127062981"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2019 10:39:44 +0800
IronPort-SDR: HRjn+SH/dYTybCdDTDUWSz2FQL1yR6jDVdJ5od2Tp/KyxaNgs8EALaqn0lfwbX2DCvbY42lh5q
 A+Vz282gBCZC+YEOTIYUz6bco90cQQHIkxKKEowuLlJASCGnjpT9IlOm9rWPms0WVstnJh3I4u
 TEu4ZW9V5SK0yY3+OWoUe4hdaIBc/1a+n8XKCKn4RSapAsRLjHOM58s88837Qg1wig8QS4HMto
 JyV75T6Rt4oFJ4rXCBrZxQ4Q18/d/OFWps+kGCDtpfoZMHb0xLw8nmoQSGOLuDzPo+ZrZJc4R6
 XBEiX+JGq/RrqO5nojfb9S/q
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2019 18:34:49 -0800
IronPort-SDR: AAngVtZSiBojiLXp/FiK1WVNwreEkIoLIx3acvuylkjpOHLL9ELYXZ2JqDTlY6aVogeqZQj4lB
 wDhA3CGOwsJkD/b6NhTbI+/eA5P/jUxynwAB3Fhf2jAH6Ix3ST6hbx5OEjgYm4oSoF4gUoexpv
 5NHZ8UP9iR7U/MVywlalJ4BQ/r0o3NiNkZ0/AM0umuOi4I6VwKb+hhxc/FtQsiCbRZie4a95yh
 9tum5aOleaM3tjCo0NGNvjcFhKFILYHybeUdGPE5lG5eoMzqfSqcBcdhqhSeZH6RdmIQYzwTQo
 O4g=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 10 Nov 2019 18:39:44 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
Subject: [PATCH v2 7/9] null_blk: Add zone_nr_conv to features
Date:   Mon, 11 Nov 2019 11:39:28 +0900
Message-Id: <20191111023930.638129-8-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191111023930.638129-1-damien.lemoal@wdc.com>
References: <20191111023930.638129-1-damien.lemoal@wdc.com>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
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

